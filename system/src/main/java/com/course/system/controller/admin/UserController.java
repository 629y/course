package com.course.system.controller.admin;

import com.alibaba.fastjson.JSON;
import com.course.server.dto.*;
import com.course.server.service.UserService;
import com.course.server.util.UuidUtil;
import com.course.server.util.ValidatorUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.util.DigestUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/admin/user")
public class UserController {
    private static final Logger LOG = LoggerFactory.getLogger(UserController.class);
    public static final String BUSINESS_NAME = "用户";
    @Resource
    private UserService userService;

    @Resource
    public RedisTemplate redisTemplate;
    /**
     * 列表查询
     */
    @PostMapping("/list")
    public ResponseDto list(@RequestBody PageDto pageDto){
        //LOG.info("pageDto:{}",pageDto);
        ResponseDto responseDto = new ResponseDto();
        userService.list(pageDto);
        responseDto.setContent(pageDto);
        return responseDto;
    }
    /**
     * 保存，id有值时更新，无值时新增
     */
    @PostMapping("/save")
    public ResponseDto save(@RequestBody UserDto userDto){
        //保险方案：对密码做两层加密
        userDto.setPassword(DigestUtils.md5DigestAsHex(userDto.getPassword().getBytes()));
        //LOG.info("userDto:{}",userDto);

        //保存校验
        ValidatorUtil.require(userDto.getLoginName(), "登录名");
        ValidatorUtil.length(userDto.getLoginName(), "登录名",1,50);
        ValidatorUtil.length(userDto.getName(), "昵称",1,50);
        ValidatorUtil.require(userDto.getPassword(), "密码");
        ResponseDto responseDto = new ResponseDto();
        userService.save(userDto);
        responseDto.setContent(userDto);
        return responseDto;
    }
    /**
     * 删除
     */
    @DeleteMapping("/delete/{id}")
    public ResponseDto delete(@PathVariable String id){
        //LOG.info("id:{}",id);
        ResponseDto responseDto = new ResponseDto();
        userService.delete(id);
        return responseDto;
    }

    /**
     * 重置密码
     * @param userDto
     * @return
     */
    @PostMapping("/save-password")
    public ResponseDto savePassword(@RequestBody UserDto userDto){
        userDto.setPassword(DigestUtils.md5DigestAsHex(userDto.getPassword().getBytes()));
        ResponseDto responseDto = new ResponseDto();
        userService.savePassword(userDto);
        responseDto.setContent(userDto);
        return responseDto;
    }

    /**
     * 登录
     */
    @PostMapping("/login")
    public ResponseDto login(@RequestBody UserDto userDto, HttpServletRequest request){
        LOG.info("用户登录开始");
        userDto.setPassword(DigestUtils.md5DigestAsHex(userDto.getPassword().getBytes()));
        ResponseDto responseDto = new ResponseDto();

        //在登录里面，增加验证码校验：通过token去缓存中获取验证码字符串，并和用户输入的字符串做比较。
        //根据验证码token去获取缓存中的验证码，和用户输入的验证码是否一致
        //前后端分离会有一个问题，每次ajax请求，后端的session是不一样的。
        //String imageCode = (String) request.getSession().getAttribute(userDto.getImageCodeToken());
        String imageCode = (String) redisTemplate.opsForValue().get(userDto.getImageCodeToken());
        LOG.info("从redis中获取到的验证码:{}",imageCode);
        if (StringUtils.isEmpty(imageCode)){
            responseDto.setSuccess(false);
            responseDto.setMessage("验证码已过期");
            LOG.info("用户登录失败,验证码已过期");
            return responseDto;
        }
        if (!imageCode.toLowerCase().equals(userDto.getImageCode().toLowerCase())){
            responseDto.setSuccess(false);
            responseDto.setMessage("验证码不对");
            LOG.info("用户登录失败,验证码不对");
            return responseDto;
        }else {
            //验证通过后，移除验证码
            //request.getSession().removeAttribute(userDto.getImageCodeToken());
            redisTemplate.delete(userDto.getImageCodeToken());
        }

        LoginUserDto loginUserDto = userService.login(userDto);
        String token = UuidUtil.getShortUuid();
        loginUserDto.setToken(token);
//        request.getSession().setAttribute(Constants.LOGIN_USER,loginUserDto);
        redisTemplate.opsForValue().set(token,
                JSON.toJSONString(loginUserDto),3600, TimeUnit.SECONDS);
        //这里也可以直接保存loginUserDto对象，但是需要序列化。如果是跨应用使用的，比如A应用存，B应用取，
        //一般会把值转成JSON字符串。
        responseDto.setContent(loginUserDto);
        return responseDto;
    }
    /**
     * 退出登录
     */
    @GetMapping("/logout/{token}")
    public ResponseDto login(@PathVariable String token){
        ResponseDto responseDto = new ResponseDto();
//        request.getSession().removeAttribute(Constants.LOGIN_USER);
        redisTemplate.delete(token);
        LOG.info("从redis中删除token:{}",token);
        return responseDto;
    }
}
