package com.course.server.service;

import com.course.server.domain.User;
import com.course.server.domain.UserExample;
import com.course.server.dto.PageDto;
import com.course.server.dto.UserDto;
import com.course.server.exception.BusinessException;
import com.course.server.exception.BusinessExceptionCode;
import com.course.server.mapper.UserMapper;
import com.course.server.util.CopyUtil;
import com.course.server.util.UuidUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.github.pagehelper.util.StringUtil;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import javax.annotation.Resource;
import java.util.List;

@Service
public class UserService {
    @Resource
    private UserMapper userMapper;
    /**
     * 列表查询
     */
    public void list(PageDto pageDto) {
        PageHelper.startPage(pageDto.getPage(), pageDto.getSize());
        UserExample userExample = new UserExample();
        List<User> userList = userMapper.selectByExample(userExample);
        PageInfo<User> pageInfo = new PageInfo<>(userList);
        pageDto.setTotal(pageInfo.getTotal());
        List<UserDto> userDtoList = CopyUtil.copyList(userList, UserDto.class);
        pageDto.setList(userDtoList);
    }
    /**
     * 保存，id有值时更新，无值时新增
     */
    public void save(UserDto userDto) {
        User user = CopyUtil.copy(userDto, User.class);
        if (StringUtil.isEmpty(userDto.getId())){
            this.insert(user);
        }else {
            this.update(user);
        }
    }
    /**
     * 新增
     */
    private void insert(User user) {
        //目前使用BeanUtil.copyProperties，需要多行代码，后续会对其做封装优化。
        user.setId(UuidUtil.getShortUuid());
        User userDb = this.selectByLoginName(user.getLoginName());
        //如果user变量已经存在了，则从数据库中查出来的，我们可以约定Db结尾，用userDb
        if (userDb != null){
            throw new BusinessException(BusinessExceptionCode.USER_LOGIN_NAME_EXIST);
            //业务上的逻辑校验，在校验不通过时，使用业务异常（自定义异常）
        }
        userMapper.insert(user);
    }
    /**
     * 更新
     */
    private void update(User user) {
        user.setPassword(null);
        userMapper.updateByPrimaryKeySelective(user);
        //mybatis-generator 生成的方法里，updateByPrimaryKeySelective会对字段进行非空判断，
        //再更新，如果值为空就不更新，原理就是利用mybatis的if拼成动态sql
    }
    /**
     * 删除
     */
    public void delete(String id) {
        userMapper.deleteByPrimaryKey(id);
    }

    /**
     * 根据登录名查询用户信息
     * @param loginName
     * @return
     */
    public User selectByLoginName(String loginName){
        UserExample userExample = new UserExample();
        userExample.createCriteria().andLoginNameEqualTo(loginName);
        //loginName 是唯一的，所以查出来要么没有记录，要么只有一条记录
        List<User> userList = userMapper.selectByExample(userExample);
        if (CollectionUtils.isEmpty(userList)){
            return null;
        }else {
            return userList.get(0);
        }
    }

    /**
     * 重置密码
     * @param userDto
     */
    public void savePassword(UserDto userDto){
        User user = new User();
        user.setId(userDto.getId());
        user.setPassword(userDto.getPassword());
        userMapper.updateByPrimaryKeySelective(user);
    }
}