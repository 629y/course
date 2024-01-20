package com.course.server.service;

import com.course.server.domain.Member;
import com.course.server.domain.MemberExample;
import com.course.server.dto.LoginMemberDto;
import com.course.server.dto.MemberDto;
import com.course.server.dto.PageDto;
import com.course.server.exception.BusinessException;
import com.course.server.exception.BusinessExceptionCode;
import com.course.server.mapper.MemberMapper;
import com.course.server.util.CopyUtil;
import com.course.server.util.UuidUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.github.pagehelper.util.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

@Service
public class MemberService {
    private static final Logger LOG = LoggerFactory.getLogger(MemberService.class);
    @Resource
    private MemberMapper memberMapper;
    /**
     * 列表查询
     */
    public void list(PageDto pageDto) {
        PageHelper.startPage(pageDto.getPage(), pageDto.getSize());
        MemberExample memberExample = new MemberExample();
        List<Member> memberList = memberMapper.selectByExample(memberExample);
        PageInfo<Member> pageInfo = new PageInfo<>(memberList);
        pageDto.setTotal(pageInfo.getTotal());
        List<MemberDto> memberDtoList = CopyUtil.copyList(memberList, MemberDto.class);
        pageDto.setList(memberDtoList);
    }
    /**
     * 保存，id有值时更新，无值时新增
     */
    public void save(MemberDto memberDto) {
        Member member = CopyUtil.copy(memberDto, Member.class);
        if (StringUtil.isEmpty(memberDto.getId())){
            this.insert(member);
        }else {
            this.update(member);
        }
    }
    /**
     * 新增
     */
    private void insert(Member member) {
        //目前使用BeanUtil.copyProperties，需要多行代码，后续会对其做封装优化。
        Date now =new Date();
        member.setId(UuidUtil.getShortUuid());
        member.setRegisterTime(now);
        memberMapper.insert(member);
    }
    /**
     * 更新
     */
    private void update(Member member) {
        memberMapper.updateByPrimaryKey(member);
    }
    /**
     * 删除
     */
    public void delete(String id) {
        memberMapper.deleteByPrimaryKey(id);
    }

    /**
     * 按手机号查找
     * @param mobile
     * @return
     */
    public MemberDto findByMobile(String mobile){
        Member member = this.selectByMobile(mobile);
        return CopyUtil.copy(member,MemberDto.class);
    }
    /**
     * 按手机号查找
     * 这里登录时，需要验证手机号是否存在，和控台登录类似，控台登录时，需要验证登录名是否存在
     * @param mobile
     * @return
     */
    public Member selectByMobile(String mobile){
        if (StringUtils.isEmpty(mobile)){
            return null;
        }
        MemberExample example = new MemberExample();
        example.createCriteria().andMobileEqualTo(mobile);
        List<Member> memberList = memberMapper.selectByExample(example);
        if (memberList == null || memberList.size() == 0){
            return null;
        }else {
            return memberList.get(0);
        }
    }

    /**
     * 登录
     * @param memberDto
     */
    public LoginMemberDto login(MemberDto memberDto){
        Member member = selectByMobile(memberDto.getMobile());
        if (member == null){
            LOG.info("手机号不存在,{}",memberDto.getMobile());
            throw new BusinessException(BusinessExceptionCode.LOGIN_MEMBER_ERROR);
        }else {
            if (member.getPassword().equals(memberDto.getPassword())){
                //登录成功
                LoginMemberDto loginMemberDto = CopyUtil.copy(member, LoginMemberDto.class);
                return loginMemberDto;
            }else {
                LOG.info("密码不对，输入密码:{},数据库密码:{}",memberDto.getPassword(),member.getPassword());
                throw new BusinessException(BusinessExceptionCode.LOGIN_MEMBER_ERROR);
            }
        }
    }
}