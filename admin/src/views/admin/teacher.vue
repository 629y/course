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
    <div class="row">
      <div v-for="teacher in teachers" class="col-md-3 center">
        <div>
      <span class="profile-picture">
        <img v-show="!teacher.image" class="editable img-responsive editable-click editable-empty" alt="Alex's Avatar"
             src="/static/image/profile-pic.jpg" v-bind:title="teacher.intro">
        <img v-show="teacher.image" v-bind:src="teacher.image"
             class="editable img-responsive editable-click editable-empty" alt="Alex's Avatar"
             v-bind:title="teacher.intro">
      </span>

          <div class="space-4"></div>

          <div class="width-85 label label-info label-xlg arrowed-in arrowed-in-right">
            <div class="inline position-relative">
              <a href="javascript:;" class="user-title-label dropdown-toggle" data-toggle="dropdown">
                <i class="ace-icon fa fa-circle light-green"></i>
                &nbsp;
                <span class="white">{{ teacher.position }}</span>
              </a>
            </div>
          </div>
        </div>
        <div class="space-6"></div>
        <a href="javascript:;" class="text-info bigger-110" v-bind:title="teacher.motto">
          <i class="ace-icon fa fa-user"></i>
          {{ teacher.name }}【{{ teacher.nickname }}】
        </a>
        <div class="space-6"></div>
        <div class="profile-social-links align-center">
          <button v-on:click="edit(teacher)" class="btn btn-xs btn-info">
            <i class="ace-icon fa fa-pencil bigger-120"></i>
          </button>
          &nbsp;
          <button v-on:click="del(teacher.id)" class="btn btn-xs btn-danger">
            <i class="ace-icon fa fa-trash-o bigger-120"></i>
          </button>
        </div>
        <div class="hr hr16 dotted"></div>
      </div>
    </div>
    <div id="form-modal" class="modal fade" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                aria-hidden="true">&times;</span></button>
            <h4 class="modal-title">表单</h4>
          </div>
          <div class="modal-body">
            <form class="form-horizontal">
              <div class="form-group">
                <label class="col-sm-2 control-label">姓名</label>
                <div class="col-sm-10">
                  <input v-model="teacher.name" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">昵称</label>
                <div class="col-sm-10">
                  <input v-model="teacher.nickname" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">头像</label>
                <div class="col-sm-10">
                 <file v-bind:input-id="'image-upload'"
                       v-bind:text="'上传头像'"
                       v-bind:suffixs="['jpg','jpeg', 'png']"
                       v-bind:use="FILE_USE.TEACHER.key"
                       v-bind:after-upload="afterUpload"></file>
                  <div v-show="teacher.image" class="row">
                    <div class="col-md-4">
                      <img v-bind:src="teacher.image" class="img-responsive">
                      <!--img-responsive:bootstrap内置的样式，图片自适应-->
                    </div>
                  </div>
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">职位</label>
                <div class="col-sm-10">
                  <input v-model="teacher.position" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">座右铭</label>
                <div class="col-sm-10">
                  <input v-model="teacher.motto" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">简介</label>
                <div class="col-sm-10">
                  <textarea v-model="teacher.intro" class="form-control" rows="5"></textarea>
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
import BigFile from "@/components/big-file.vue";
import File from "@/components/file.vue";
export default {
  name: "business-teacher",
  components: {File, BigFile, Pagination},
  data: function () {
    return {
      teacher: {},
      // teacher变量用于绑定form 表单的数据
      teachers: [],
      FILE_USE:FILE_USE
    }
  },
  mounted: function () {
    let _this = this;
    _this.$refs.pagination.size = 5;
    _this.list(1);
    // sidebar 激活样式方法一
    // this.$parent.activeSidebar("business-teacher-sidebar");
  },
  methods: {
    /**
     * 点击【新增】
     */
    add() {
      let _this = this;
      // 发现问题：对文本框编辑后，点新增弹出文本框，会带出上一次编辑过的值。
      //新增讲师，上传头像后不能实时预览，解决方法一
      // _this.teacher = {
      //   image:null
      // };
      _this.teacher = {};
      $("#form-modal").modal("show");//打开
      //$("#form-modal").modal("hide");//关闭
    },
    /**
     * 点击【编辑】
     */
    edit(teacher) {
      let _this = this;
      // 数据显示：将表格行数据显示到表单。反过来，数据修改：修改表单影响表格行数据。
      _this.teacher = $.extend({}, teacher);
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
      _this.$ajax.post(process.env.VUE_APP_SERVER + "/business/admin/teacher/list", {
        page: page,
        size: _this.$refs.pagination.size,
      }).then((response) => {
        Loading.hide();
        let resp = response.data;
        _this.teachers = resp.content.list;
        //response.data 就相当于responseDto
        _this.$refs.pagination.render(page, resp.content.total);
      })
    },
    /**
     * 点击【保存】
     */
    save() {
      let _this = this;

      // 保存校验
      //1! = 1 的设计，类似于mybatis 的动态sql 设计，在拼动态where 条件时，会在前面加 1==1
      if (1 != 1
          || !Validator.require(_this.teacher.name, "姓名")
          || !Validator.length(_this.teacher.name, "姓名", 1, 50)
          || !Validator.length(_this.teacher.nickname, "昵称", 1, 50)
          || !Validator.length(_this.teacher.image, "头像", 1, 100)
          || !Validator.length(_this.teacher.position, "职位", 1, 50)
          || !Validator.length(_this.teacher.motto, "座右铭", 1, 50)
          || !Validator.length(_this.teacher.intro, "简介", 1, 500)
      ) {
        return;
      }

      Loading.show();
      // /admin 用于控台类的接口，/web 用于网站类的接口。接口设计中，用不同的请求前缀代表不同的入口，做接口隔离，方便做鉴权、统计、监控等
      _this.$ajax.post(process.env.VUE_APP_SERVER + "/business/admin/teacher/save", _this.teacher).then((response) => {
        Loading.hide();
        let resp = response.data;
        if (resp.success) {
          $("#form-modal").modal("hide");
          _this.list(1);
          Toast.success("保存成功！");
        } else {
          Toast.warning(resp.message);
        }
      })
    },
    /**
     * 点击【删除】
     */
    del(id) {
      let _this = this;
      Confirm.show("删除讲师后不可恢复，确认删除？", function () {
        Loading.show();
        //restful 是一种请求风格。简单的理解：通过看url 就能知道这个请求是要对什么资源做什么操作
        _this.$ajax.delete(process.env.VUE_APP_SERVER + "/business/admin/teacher/delete/" + id).then((response) => {
          Loading.hide();
          let resp = response.data;
          if (resp.success) {
            _this.list(1);
            Toast.success("删除成功！");
          }
        })
      })
    },
    afterUpload(resp){
      let _this = this;
      let image = resp.content.path;
      _this.teacher.image = image;
      //新增讲师，上传头像后不能实时预览，解决方法二
      _this.$forceUpdate();
    }
  }
}
</script>