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
    <!--  v-bind:list="list",前面的list,是分页组件暴露出来的一个回调方法，后面的list，是member组件的list方法  -->
    <table id="simple-table" class="table  table-bordered table-hover">
      <thead>
      <tr>
        <th>id</th>
        <th>手机号</th>
        <th>密码</th>
        <th>昵称</th>
        <th>头像url</th>
        <th>注册时间</th>
        <th>操作</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="member in members">
        <td>{{member.id}}</td>
        <td>{{member.mobile}}</td>
        <td>{{member.password}}</td>
        <td>{{member.name}}</td>
        <td>{{member.photo}}</td>
        <td>{{member.registerTime}}</td>
      <td>
        <div class="hidden-sm hidden-xs btn-group">
          <button v-on:click="edit(member)" class="btn btn-xs btn-info">
            <!--              1.将表格每一行数据传递到edit中做处理2.将传递过来的一行数据member，赋给vue变量_this.member
                              vue变量_this.member会通过v-model属性和form表单做数据绑定-->
            <i class="ace-icon fa fa-pencil bigger-120"></i>
          </button>

          <button v-on:click="del(member.id)" class="btn btn-xs btn-danger">
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
                <label class="col-sm-2 control-label">手机号</label>
                <div class="col-sm-10">
                   <input v-model="member.mobile" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">密码</label>
                <div class="col-sm-10">
                   <input v-model="member.password" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">昵称</label>
                <div class="col-sm-10">
                   <input v-model="member.name" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">头像url</label>
                <div class="col-sm-10">
                   <input v-model="member.photo" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">注册时间</label>
                <div class="col-sm-10">
                   <input v-model="member.registerTime" class="form-control">
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
  </div>
</template>
<script>
  import Pagination from "../../components/pagination";

  export default {
    name: "business-member",
    components: {Pagination},
    data: function () {
      return {
        member:{},
        // member变量用于绑定form 表单的数据
        members: [],
      }
    },
    mounted:function () {
      let _this = this;
      _this.$refs.pagination.size = 5;
      _this.list(1);
      // sidebar 激活样式方法一
      // this.$parent.activeSidebar("business-member-sidebar");
    },
    methods:{
      /**
       * 点击【新增】
       */
      add(){
        let _this = this;
        // 发现问题：对文本框编辑后，点新增弹出文本框，会带出上一次编辑过的值。
        _this.member = {};
        $("#form-modal").modal("show");//打开
        //$("#form-modal").modal("hide");//关闭
      },
      /**
       * 点击【编辑】
       */
      edit(member){
        let _this = this;
        // 数据显示：将表格行数据显示到表单。反过来，数据修改：修改表单影响表格行数据。
        _this.member = $.extend({},member);
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
        _this.$ajax.post(process.env.VUE_APP_SERVER +"/business/admin/member/list",{
          page:page,
          size:_this.$refs.pagination.size,
        }).then((response) => {
          Loading.hide();
          let resp = response.data;
          _this.members = resp.content.list;
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
          || !Validator.length(_this.member.mobile,"手机号",1,11)
          || !Validator.require(_this.member.password,"密码")
          || !Validator.length(_this.member.name,"昵称",1,50)
          || !Validator.length(_this.member.photo,"头像url",1,200)
        ){
          return;
        }

          Loading.show();
          // /admin 用于控台类的接口，/web 用于网站类的接口。接口设计中，用不同的请求前缀代表不同的入口，做接口隔离，方便做鉴权、统计、监控等
          _this.$ajax.post(process.env.VUE_APP_SERVER  + "/business/admin/member/save",_this.member).then((response) => {
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
        Confirm.show("删除会员后不可恢复，确认删除？",function (){
          Loading.show();
          //restful 是一种请求风格。简单的理解：通过看url 就能知道这个请求是要对什么资源做什么操作
          _this.$ajax.delete(process.env.VUE_APP_SERVER + "/business/admin/member/delete/" + id).then((response) => {
            Loading.hide();
            let resp = response.data;
            if (resp.success){
              _this.list(1);
              Toast.success("删除成功！");
            }
          })
        })
      }
    }
  }
</script>