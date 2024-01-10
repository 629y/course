<template>
  <div>
    <p>
      <button v-on:click="add()" class="btn btn-white btn-default btn-round">
        <i class="ace-icon fa-edit"></i>
        <!--        fa-edit 参考font awesome 图标-->
        新增
      </button>
      &nbsp;
      <button v-on:click="list(1)" class="btn btn-white btn-default btn-round">
        <i class="ace-icon fa fa-refresh"></i>
        刷新
      </button>
    </p>
    <pagination ref="pagination" v-bind:list="list" v-bind:itemCount="8"></pagination>
    <!--  v-bind:list="list",前面的list,是分页组件暴露出来的一个回调方法，后面的list，是role组件的list方法  -->
    <table id="simple-table" class="table  table-bordered table-hover">
      <thead>
      <tr>
        <th>id</th>
        <th>角色</th>
        <th>描述</th>
        <th>操作</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="role in roles">
        <td>{{role.id}}</td>
        <td>{{role.name}}</td>
        <td>{{role.desc}}</td>
      <td>
        <div class="hidden-sm hidden-xs btn-group">
          <button v-on:click="editUser(role)" class="btn btn-xs btn-info">
            <i class="ace-icon fa fa-user bigger-120"></i>
          </button>
          <button v-on:click="editResource(role)" class="btn btn-xs btn-info">
            <i class="ace-icon fa fa-list bigger-120"></i>
          </button>
          <button v-on:click="edit(role)" class="btn btn-xs btn-info">
            <!--              1.将表格每一行数据传递到edit中做处理2.将传递过来的一行数据role，赋给vue变量_this.role
                              vue变量_this.role会通过v-model属性和form表单做数据绑定-->
            <i class="ace-icon fa fa-pencil bigger-120"></i>
          </button>

          <button v-on:click="del(role.id)" class="btn btn-xs btn-danger">
            <!--              delete 是js 的关键字，vue 方法里不能使用js 关键字-->
            <i class="ace-icon fa fa-trash-o bigger-120"></i>
          </button>
        </div>
      </td>
      </tr>
      </tbody>
    </table>
    <div id="form-modal" class="modal fade" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title">表单</h4>
          </div>
          <div class="modal-body">
            <form class="form-horizontal">
              <div class="form-group">
                <label class="col-sm-2 control-label">角色</label>
                <div class="col-sm-10">
                   <input v-model="role.name" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">描述</label>
                <div class="col-sm-10">
                   <input v-model="role.desc" class="form-control">
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            <button v-on:click="save()" type="button" class="btn btn-primary">保存</button>
          </div>
        </div><!-- /.modal-content -->
      </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
    <!--角色资源关联配置-->
    <div id="resource-modal" class="modal fade" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title">角色资源关联配置</h4>
          </div>
          <div class="modal-body">
            <ul id="tree" class="ztree"></ul>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-white btn-default btn-round" data-dismiss="modal">
              <i class="ace-icon fa fa-times"></i>
              关闭
            </button>
            <button v-on:click="saveResource()" type="button" class="btn btn-white btn-info btn-round">
              <i class="ace-icon fa fa-plus blue"></i>
              保存
            </button>
          </div>
        </div><!-- /.modal-content -->
      </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
    <!--角色用户关联配置-->
    <div id="user-modal" class="modal fade" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title">角色用户关联配置</h4>
          </div>
          <div class="modal-body">
            <div class="row">
              <div class="col-md-6">
                <table id="user-table" class="table table-hover">
                  <tbody>
                  <tr v-for="user in users">
                    <td>{{user.loginName}}</td>
                    <td class="text-right">
                      <a v-on:click="addUser(user)" href="javascript:;" class="">
                        <i class="ace-icon fa fa-arrow-circle-right blue"></i>
                      </a>
                    </td>
                  </tr>
                  </tbody>
                </table>
              </div>
              <div class="col-md-6">
                <table id="role-user-table" class="table table-hover">
                  <tbody>
                  <tr v-for="user in roleUsers">
                    <td>{{user.loginName}}</td>
                    <td class="text-right">
                      <a v-on:click="deleteUser(user)" href="javascript:;" class="">
                        <i class="ace-icon fa fa-trash blue"></i>
                      </a>
                    </td>
                  </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-white btn-default btn-round" data-dismiss="modal">
              <i class="ace-icon fa fa-times"></i>
              关闭
            </button>
            <button v-on:click="saveUser()" type="button" class="btn btn-white btn-info btn-round">
              <i class="ace-icon fa fa-plus blue"></i>
              保存
            </button>
          </div>
        </div><!-- /.modal-content -->
      </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
  </div>
</template>
<script>
  import Pagination from "../../components/pagination";
  export default {
    name: "system-role",
    components: {Pagination},
    data: function () {
      return {
        role:{},
        // role变量用于绑定form 表单的数据
        roles: [],
        resources:[],
        zTree:{},
        users:[],
        roleUsers:[],
      }
    },
    mounted:function () {
      let _this = this;
      _this.$refs.pagination.size = 5;
      _this.list(1);
      // sidebar 激活样式方法一
      // this.$parent.activeSidebar("system-role-sidebar");
    },
    methods:{
      /**
       * 点击【新增】
       */
      add(){
        let _this = this;
        // 发现问题：对文本框编辑后，点新增弹出文本框，会带出上一次编辑过的值。
        _this.role = {};
        $("#form-modal").modal("show");//打开
        //$("#form-modal").modal("hide");//关闭
      },
      /**
       * 点击【编辑】
       */
      edit(role){
        let _this = this;
        // 数据显示：将表格行数据显示到表单。反过来，数据修改：修改表单影响表格行数据。
        _this.role = $.extend({},role);
        $("#form-modal").modal("show");//打开
      },
      /**
       * 列表查询
       */
      list(page) {
        let _this = this;
        Loading.show();
        _this.$refs.pagination.size = 5;
        // /admin 用于控台类的接口，/web 用于网站类的接口。接口设计中，用不同的请求前缀代表不同的入口，做接口隔离，方便做鉴权、统计、监控等
        _this.$ajax.post(process.env.VUE_APP_SERVER +"/system/admin/role/list",{
          page:page,
          size:_this.$refs.pagination.size,
        }).then((response) => {
          Loading.hide();
          let resp = response.data;
          _this.roles = resp.content.list;
          //response.data 就相当于responseDto
          _this.$refs.pagination.render(page,resp.content.total);
        })
      },
      /**
       * 点击【保存】
       */
      save() {
        let _this = this;

        // 保存校验
        //1! = 1 的设计，类似于mybatis 的动态sql 设计，在拼动态where 条件时，会在前面加 1==1
        if(1 !=1
          || !Validator.require(_this.role.name,"角色")
          || !Validator.length(_this.role.name,"角色",1,50)
          || !Validator.require(_this.role.desc,"描述")
          || !Validator.length(_this.role.desc,"描述",1,100)
        ){
          return;
        }

          Loading.show();
          // /admin 用于控台类的接口，/web 用于网站类的接口。接口设计中，用不同的请求前缀代表不同的入口，做接口隔离，方便做鉴权、统计、监控等
          _this.$ajax.post(process.env.VUE_APP_SERVER  + "/system/admin/role/save",_this.role).then((response) => {
          Loading.hide();
          let resp = response.data;
          if (resp.success){
            $("#form-modal").modal("hide");
            _this.list(1);
            Toast.success("保存成功！");
          }else {
            Toast.warning(resp.message);
          }
        })
      },
      /**
       * 点击【删除】
       */
      del(id) {
        let _this = this;
        Confirm.show("删除角色后不可恢复，确认删除？",function (){
          Loading.show();
          //restful 是一种请求风格。简单的理解：通过看url 就能知道这个请求是要对什么资源做什么操作
          _this.$ajax.delete(process.env.VUE_APP_SERVER + "/system/admin/role/delete/" + id).then((response) => {
            Loading.hide();
            let resp = response.data;
            if (resp.success){
              _this.list(1);
              Toast.success("删除成功！");
            }
          })
        })
      },
      /**
       * 点击【编辑】
       */
      editResource(role){
        let _this = this;
        _this.role = $.extend({},role);
        _this.loadResource();
        $("#resource-modal").modal("show");
      },
      /**
       * 加载资源树
       */
      loadResource(){
        let _this = this;
        Loading.show();
        _this.$ajax.get(process.env.VUE_APP_SERVER + '/system/admin/resource/load-tree').then((res) => {
          Loading.hide();
          let response = res.data;
          _this.resources = response.content;
          //初始化树
          _this.initTree();
          _this.listRoleResource();
        })
      },
      /**
       * 初始资源树
       */
      initTree(){
        let _this = this;
        let setting = {
          check:{
            enable:true
          },
          data:{
            simpleData:{
              idKey:"id",
              pIdKey:"parent",
              rootPId:"",
              enable:true
            }
          }
        };
        _this.zTree = $.fn.zTree.init($("#tree"),setting,_this.resources);
        _this.zTree.expandAll(true);
      },
      /**
       * 资源模态框点击【保存】
       */
      saveResource(){
        let _this = this;
        let resources = _this.zTree.getCheckedNodes();
        console.log("勾选的资源：",resources);

        //保存时，只需要保存资源id,所以使用id数组进行参数传递
        let resourceIds = [];
        for (let i = 0;i < resources.length; i++){
          resourceIds.push(resources[i].id);
        }

        _this.$ajax.post(process.env.VUE_APP_SERVER + '/system/admin/role/save-resource',{
          id:_this.role.id,
          resourceIds:resourceIds
        }).then((response)=>{
          let resp = response.data;
          if (resp.success){
            Toast.success("保存成功！");
          }else {
            Toast.warning(resp.message);
          }
        });
      },
      /**
       * 加载角色资源关联记录
       */
      listRoleResource(){
        let _this = this;
        _this.$ajax.get(process.env.VUE_APP_SERVER
            + '/system/admin/role/list-resource/'+ _this.role.id).then((response)=>{
          let resp = response.data;
          let resources = resp.content;

          //勾选查询到的资源：先把树的所有节点清空勾选，再勾选查询到的节点
          _this.zTree.checkAllNodes(false);
          for (let i = 0;i < resources.length; i++){
            let node = _this.zTree.getNodeByParam("id",resources[i]);
            _this.zTree.checkNode(node,true);
          }
        });
      },
      /**
       * 点击【用户】
       */
      editUser(role){
        let _this = this;
        _this.role = $.extend({},role);
        _this.listUser();
        $("#user-modal").modal("show");
      },
      /**
       * 查询所有用户
       */
      listUser(){
        let _this = this;
        _this.$ajax.post(process.env.VUE_APP_SERVER + "/system/admin/user/list",{
          page:1,
          size:9999
        }).then((response)=>{
          let resp = response.data;
          if (resp.success){
            _this.users = resp.content.list;
            _this.listRoleUser();
          }else {
            Toast.warning(resp.message);
          }
        })
      },
      /**
       * 角色中增加用户
       */
      addUser(user){
        let _this = this;
        //如果当前要添加的用户在右边列表中已经有了，则不用再添加
        let users = _this.roleUsers;
        for (let i = 0; i < users.length; i++) {
          if (user === users[i]){
            return;
          }
        }
        _this.roleUsers.push(user);
      },
      /**
       * 角色中删除用户
       */
      deleteUser(user){
        let _this = this;
        Tool.removeObj(_this.roleUsers,user);
      },
      /**
       * 角色用户模态框点击【保存】
       */
      saveUser(){
        let _this = this;
        let users = _this.roleUsers;

        //保存时，只需要保存用户id，所以使用id数组进行参数传递
        let userIds = [];
        for (let i = 0; i < users.length; i++) {
          userIds.push(users[i].id);
        }
        _this.$ajax.post(process.env.VUE_APP_SERVER + '/system/admin/role/save-user',{
          id: _this.role.id,
          userIds: userIds
        }).then((response)=>{
          console.log("保存角色用户结果：",response);
          let resp = response.data;
          if (resp.success){
            Toast.success("保存成功！");
          }else {
            Toast.warning(resp.message);
          }
        })
      },
      /**
       * 加载角色用户
       */
      listRoleUser(){
        let _this = this;
        _this.roleUsers = [];
        _this.$ajax.get(process.env.VUE_APP_SERVER
            + '/system/admin/role/list-user/' + _this.role.id).then((res)=>{
          let response = res.data;
          let userIds = response.content;

          //根据加载到用户ID，到【所有用户数组：users】中查找用户对象，用于列表显示
          for (let i = 0; i < userIds.length; i++) {
            for (let j = 0; j < _this.users.length; j++){
              if (userIds[i] === _this.users[j].id){
                _this.roleUsers.push(_this.users[j]);
              }
            }
          }
        });
      },
    }
  }
</script>