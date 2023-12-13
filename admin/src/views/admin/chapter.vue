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
    <pagination ref="pagination" v-bind:list="list" v-bind:item-count="8"></pagination>
<!--  v-bind:list="list",前面的list,是分页组件暴露出来的一个回调方法，后面的list，是chapter组件的list方法  -->
    <table id="simple-table" class="table  table-bordered table-hover">
      <thead>
      <tr>
        <th>ID</th>
        <th>名称</th>
        <th>课程ID</th>
        <th>操作</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="chapter in chapters">
        <td>{{ chapter.id }}</td>
        <td>{{ chapter.name }}</td>
        <td>{{ chapter.courseId }}</td>
        <td>
          <div class="hidden-sm hidden-xs btn-group">
            <button v-on:click="edit(chapter)" class="btn btn-xs btn-info">
<!--              1.将表格每一行数据传递到edit中做处理2.将传递过来的一行数据chapter，赋给vue变量_this.chapter
                  vue变量_this.chapter会通过v-model属性和form表单做数据绑定-->
              <i class="ace-icon fa fa-pencil bigger-120"></i>
            </button>

            <button v-on:click="del(chapter.id)" class="btn btn-xs btn-danger">
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
                <label class="col-sm-2 control-label">名称</label>
                <div class="col-sm-10">
                  <input v-model="chapter.name" class="form-control" placeholder="名称">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">课程ID</label>
                <div class="col-sm-10">
                  <input v-model="chapter.courseId" class="form-control" placeholder="课程ID">
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
import Pagination from "@/components/pagination.vue";

export default {
  name: "chapter",
  components: {Pagination},
  data: function () {
    return {
      chapter:{},
      // chapter变量用于绑定form 表单的数据
      chapters: []
    }
  },
  mounted:function () {
    let _this = this;
    _this.list(1);
    // sidebar 激活样式方法一
    // this.$parent.activeSidebar("business-chapter-sidebar");
  },
  methods:{
    add(){
      let _this = this;
      // 发现问题：对文本框编辑后，点新增弹出文本框，会带出上一次编辑过的值。
      _this.chapter = {};
      $("#form-modal").modal("show");//打开
      //$("#form-modal").modal("hide");//关闭
    },
    edit(chapter){
      let _this = this;
      // 数据显示：将表格行数据显示到表单。反过来，数据修改：修改表单影响表格行数据。
      _this.chapter = $.extend({},chapter);
      $("#form-modal").modal("show");//打开
    },
    list(page) {
      let _this = this;
      Loading.show();
      _this.$refs.pagination.size = 5;
      // /admin 用于控台类的接口，/web 用于网站类的接口。接口设计中，用不同的请求前缀代表不同的入口，做接口隔离，方便做鉴权、统计、监控等
      _this.$ajax.post("http://127.0.0.1:9000/business/admin/chapter/list",{
        page:page,
        size:_this.$refs.pagination.size,
      }).then((response) => {
        Loading.hide();
        console.log("查询大章列表结果", response);
        let resp = response.data;
        _this.chapters = resp.content.list;
        //response.data 就相当于responseDto
        _this.$refs.pagination.render(page,resp.content.total);
      })
    },
    save(page) {
      let _this = this;

      // 保存校验
      if (!Validator.require(_this.chapter.name, "名称")
          || !Validator.require(_this.chapter.courseId, "课程ID")
          || !Validator.length(_this.chapter.courseId, "课程ID", 1, 8)) {
        return;
      }

      Loading.show();
      // /admin 用于控台类的接口，/web 用于网站类的接口。接口设计中，用不同的请求前缀代表不同的入口，做接口隔离，方便做鉴权、统计、监控等
      _this.$ajax.post("http://127.0.0.1:9000/business/admin/chapter/save",_this.chapter).then((response) => {
        Loading.hide();
        console.log("保存大章列表结果", response);
        let resp = response.data;
        if (resp.success){
          $("#form-modal").modal("hide");
          _this.list(1);
          Toast.success("保存成功！");
        }
      })
    },
    del(id) {
      let _this = this;
      Confirm.show("删除大章后不可恢复，确认删除？",function (){
        Loading.show();
        //restful 是一种请求风格。简单的理解：通过看url 就能知道这个请求是要对什么资源做什么操作
        _this.$ajax.delete("http://127.0.0.1:9000/business/admin/chapter/delete/" + id).then((response) => {
          Loading.hide();
          console.log("删除大章列表结果", response);
          let resp = response.data;
          if (resp.success){
            _this.list(1);
            Toast.success("删除成功！");
          }
        })
      })

      // Swal.fire({
      //   title: "确认删除?",
      //   text: "删除后不可恢复，确认删除？",
      //   icon: "warning",
      //   showCancelButton: true,
      //   confirmButtonColor: "#3085d6",
      //   cancelButtonColor: "#d33",
      //   confirmButtonText: "确认!"
      // }).then((result) => {
      //   if (result.isConfirmed) {
      //     Loading.show();
      //     //restful 是一种请求风格。简单的理解：通过看url 就能知道这个请求是要对什么资源做什么操作
      //     _this.$ajax.delete("http://127.0.0.1:9000/business/admin/chapter/delete/" + id).then((response) => {
      //       Loading.hide();
      //       console.log("删除大章列表结果", response);
      //       let resp = response.data;
      //       if (resp.success){
      //         _this.list(1);
      //         Toast.success("删除成功！");
      //       }
      //     })
      //   }
      // });
    }
  }
}
</script>