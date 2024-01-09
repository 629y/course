package com.course.server.service;

import com.course.server.domain.Role;
import com.course.server.domain.RoleExample;
import com.course.server.dto.RoleDto;
import com.course.server.dto.PageDto;
import com.course.server.mapper.RoleMapper;
import com.course.server.util.CopyUtil;
import com.course.server.util.UuidUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.github.pagehelper.util.StringUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class RoleService {
    @Resource
    private RoleMapper roleMapper;
    /**
     * 列表查询
     */
    public void list(PageDto pageDto) {
        PageHelper.startPage(pageDto.getPage(), pageDto.getSize());
        RoleExample roleExample = new RoleExample();
        List<Role> roleList = roleMapper.selectByExample(roleExample);
        PageInfo<Role> pageInfo = new PageInfo<>(roleList);
        pageDto.setTotal(pageInfo.getTotal());
        List<RoleDto> roleDtoList = CopyUtil.copyList(roleList, RoleDto.class);
        pageDto.setList(roleDtoList);
    }
    /**
     * 保存，id有值时更新，无值时新增
     */
    public void save(RoleDto roleDto) {
        Role role = CopyUtil.copy(roleDto, Role.class);
        if (StringUtil.isEmpty(roleDto.getId())){
            this.insert(role);
        }else {
            this.update(role);
        }
    }
    /**
     * 新增
     */
    private void insert(Role role) {
        //目前使用BeanUtil.copyProperties，需要多行代码，后续会对其做封装优化。
        role.setId(UuidUtil.getShortUuid());
        roleMapper.insert(role);
    }
    /**
     * 更新
     */
    private void update(Role role) {
        roleMapper.updateByPrimaryKey(role);
    }
    /**
     * 删除
     */
    public void delete(String id) {
        roleMapper.deleteByPrimaryKey(id);
    }
}