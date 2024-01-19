package com.course.business.controller.web;

import com.alibaba.fastjson.JSON;
import com.course.server.dto.LoginMemberDto;
import com.course.server.dto.MemberDto;
import com.course.server.dto.ResponseDto;
import com.course.server.service.MemberService;
import com.course.server.util.UuidUtil;
import com.course.server.util.ValidatorUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.util.DigestUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.concurrent.TimeUnit;

@RestController("webMemberController")
@RequestMapping("/web/member")
public class MemberController {
    private static final Logger LOG = LoggerFactory.getLogger(MemberController.class);
    public static final String BUSINESS_NAME = "会员";
    @Resource
    private MemberService memberService;

    @Resource(name = "redisTemplate")
    private RedisTemplate redisTemplate;

    /**
     * 保存，id有值时更新，无值时新增
     */
    @PostMapping("/register")
    public ResponseDto register(@RequestBody MemberDto memberDto){
        //保存校验
        ValidatorUtil.require(memberDto.getMobile(),"手机号");
        ValidatorUtil.length(memberDto.getMobile(),"手机号",11,11);
        ValidatorUtil.require(memberDto.getPassword(),"密码");
        ValidatorUtil.length(memberDto.getName(),"昵称",1,50);
        ValidatorUtil.length(memberDto.getPhoto(),"头像url",1,200);

        //密码加密
        memberDto.setPassword(DigestUtils.md5DigestAsHex(memberDto.getPassword().getBytes()));
        //密码两层加密，传输加密+保存密码

        ResponseDto responseDto = new ResponseDto();
        memberService.save(memberDto);
        responseDto.setContent(memberDto);
        return responseDto;
    }
    /**
     * 登录
     */
    @PostMapping("/login")
    public ResponseDto login(@RequestBody MemberDto memberDto){
        LOG.info("用户登录开始");
        memberDto.setPassword(DigestUtils.md5DigestAsHex(memberDto.getPassword().getBytes()));
        ResponseDto responseDto = new ResponseDto();

        //在登录里面，增加验证码校验：通过token去缓存中获取验证码字符串，并和用户输入的字符串做比较。
        //根据验证码token去获取缓存中的验证码，和用户输入的验证码是否一致
        //前后端分离会有一个问题，每次ajax请求，后端的session是不一样的。
        //String imageCode = (String) request.getSession().getAttribute(userDto.getImageCodeToken());
        String imageCode = (String) redisTemplate.opsForValue().get(memberDto.getImageCodeToken());
        LOG.info("从redis中获取到的验证码:{}",imageCode);
        if (StringUtils.isEmpty(imageCode)){
            responseDto.setSuccess(false);
            responseDto.setMessage("验证码已过期");
            LOG.info("用户登录失败,验证码已过期");
            return responseDto;
        }
        if (!imageCode.toLowerCase().equals(memberDto.getImageCode().toLowerCase())){
            responseDto.setSuccess(false);
            responseDto.setMessage("验证码不对");
            LOG.info("用户登录失败,验证码不对");
            return responseDto;
        }else {
            //验证通过后，移除验证码
            //request.getSession().removeAttribute(userDto.getImageCodeToken());
            redisTemplate.delete(memberDto.getImageCodeToken());
        }

        LoginMemberDto loginMemberDto = memberService.login(memberDto);
        String token = UuidUtil.getShortUuid();
        loginMemberDto.setToken(token);
//        request.getSession().setAttribute(Constants.LOGIN_USER,loginUserDto);
        redisTemplate.opsForValue()
                .set(token, JSON.toJSONString(loginMemberDto),3600, TimeUnit.SECONDS);
        //这里也可以直接保存loginUserDto对象，但是需要序列化。如果是跨应用使用的，比如A应用存，B应用取，
        //一般会把值转成JSON字符串。
        responseDto.setContent(loginMemberDto);
        return responseDto;
    }
    /**
     * 退出登录
     */
    @GetMapping("/logout/{token}")
    public ResponseDto logout(@PathVariable String token){
        ResponseDto responseDto = new ResponseDto();
        redisTemplate.delete(token);
        LOG.info("从redis中删除token:{}",token);
        return responseDto;
    }
}
