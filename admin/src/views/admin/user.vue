<template>
  <div>
    <p>
      <button v-show="hasResource('010101')" v-on:click="add()" class="btn btn-white btn-default btn-round">
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
    <!--  v-bind:list="list",前面的list,是分页组件暴露出来的一个回调方法，后面的list，是user组件的list方法  -->
    <table id="simple-table" class="table  table-bordered table-hover">
      <thead>
      <tr>
        <th>id</th>
        <th>登录名</th>
        <th>昵称</th>
        <th>密码</th>
        <th>操作</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="user in users">
        <td>{{user.id}}</td>
        <td>{{user.loginName}}</td>
        <td>{{user.name}}</td>
        <td>{{user.password}}</td>
      <td>
        <div class="hidden-sm hidden-xs btn-group">
          <button v-show="hasResource('010103')" v-on:click="editPassword(user)" class="btn btn-xs btn-info">
            <i class="ace-icon fa fa-key bigger-120"></i>
          </button>
          <button v-show="hasResource('010101')" v-on:click="edit(user)" class="btn btn-xs btn-info">
            <!--              1.将表格每一行数据传递到edit中做处理2.将传递过来的一行数据user，赋给vue变量_this.user
                              vue变量_this.user会通过v-model属性和form表单做数据绑定-->
            <i class="ace-icon fa fa-pencil bigger-120"></i>
          </button>

          <button v-show="hasResource('010102')" v-on:click="del(user.id)" class="btn btn-xs btn-danger">
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
                <label class="col-sm-2 control-label">登录名</label>
                <div class="col-sm-10">
                   <input v-model="user.loginName" v-bind:disabled="user.id" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">昵称</label>
                <div class="col-sm-10">
                   <input v-model="user.name" class="form-control">
                </div>
              </div>
              <div v-show="!user.id" class="form-group">
                <label class="col-sm-2 control-label">密码</label>
                <div class="col-sm-10">
                   <input v-model="user.password" type="password" class="form-control">
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

    <div id="edit-password-modal" class="modal fade" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title">修改密码</h4>
          </div>
          <div class="modal-body">
            <form class="form-horizontal">
              <div class="form-group">
                <label class="control-label col-lg-3">密码</label>
                <div class="col-lg-9">
                  <input class="form-control" type="password" v-model="user.password" name="password">
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-white btn-default btn-round" data-dismiss="modal">
              <i class="ace-icon fa fa-times"></i>
              取消
            </button>
            <button type="button" class="btn btn-white btn-info btn-round" v-on:click="savePassword()">
              <i class="ace-icon fa fa-plus blue"></i>
              保存密码
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
    name: "system-user",
    components: {Pagination},
    data: function () {
      return {
        user:{},
        // user变量用于绑定form 表单的数据
        users: [],
      }
    },
    mounted:function () {
      let _this = this;
      _this.$refs.pagination.size = 5;
      _this.list(1);
      // sidebar 激活样式方法一
      // this.$parent.activeSidebar("system-user-sidebar");
    },
    methods:{
      /**
       * 查找是否有权限
       * @param id
       * @return {boolean}
       */
      hasResource(id){
        return Tool.hasResource(id);
      },
      /**
       * 点击【新增】
       */
      add(){
        let _this = this;
        // 发现问题：对文本框编辑后，点新增弹出文本框，会带出上一次编辑过的值。
        _this.user = {};
        $("#form-modal").modal("show");//打开
        //$("#form-modal").modal("hide");//关闭
      },
      /**
       * 点击【编辑】
       */
      edit(user){
        let _this = this;
        // 数据显示：将表格行数据显示到表单。反过来，数据修改：修改表单影响表格行数据。
        _this.user = $.extend({},user);
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
        _this.$ajax.post(process.env.VUE_APP_SERVER +"/system/admin/user/list",{
          page:page,
          size:_this.$refs.pagination.size,
        }).then((response) => {
          Loading.hide();
          let resp = response.data;
          if (resp.success){
            _this.users = resp.content.list;
            //response.data 就相当于responseDto
            _this.$refs.pagination.render(page,resp.content.total);
          }
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
          || !Validator.require(_this.user.loginName,"登录名")
          || !Validator.length(_this.user.loginName,"登录名",1,50)
          || !Validator.length(_this.user.name,"昵称",1,50)
          || !Validator.require(_this.user.password,"密码")
        ){
          return;
        }
          _this.user.password = hex_md5(_this.user.password + KEY);
          //加密
          Loading.show();
          // /admin 用于控台类的接口，/web 用于网站类的接口。接口设计中，用不同的请求前缀代表不同的入口，做接口隔离，方便做鉴权、统计、监控等
          _this.$ajax.post(process.env.VUE_APP_SERVER  + "/system/admin/user/save",_this.user).then((response) => {
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
        Confirm.show("删除用户后不可恢复，确认删除？",function (){
          Loading.show();
          //restful 是一种请求风格。简单的理解：通过看url 就能知道这个请求是要对什么资源做什么操作
          _this.$ajax.delete(process.env.VUE_APP_SERVER + "/system/admin/user/delete/" + id).then((response) => {
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
       * 点击【重置密码】
       */
      editPassword(user){
        let _this = this;
        _this.user = $.extend({},user);
        _this.user.password = null;
        $("#edit-password-modal").modal("show");//打开
      },
      /**
       * 点击【保存密码】
       */
      savePassword() {
        let _this = this;

        _this.user.password = hex_md5(_this.user.password + KEY);
        //加密
        Loading.show();
        _this.$ajax.post(process.env.VUE_APP_SERVER  + "/system/admin/user/save-password",_this.user)
            .then((response) => {
          Loading.hide();
          let resp = response.data;
          if (resp.success){
            $("#edit-password-modal").modal("hide");
            _this.list(1);
            Toast.success("保存成功！");
          }else {
            Toast.warning(resp.message);
          }
        })
      },
    }
  }
</script>