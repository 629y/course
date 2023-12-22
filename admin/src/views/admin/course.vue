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
    <!--  v-bind:list="list",前面的list,是分页组件暴露出来的一个回调方法，后面的list，是course组件的list方法  -->
    <div class="row">
      <div v-for="course in courses" class="col-md-4">
        <div class="thumbnail search-thumbnail">
          <img v-show="!course.image" class="media-object" src="/static/image/demo-course.jpg" />
          <img v-show="course.image" class="media-object" v-bind:src="course.image" />
          <div class="caption">
            <div class="clearfix">
              <span class="pull-right label label-primary info-label">
                {{COURSE_LEVEL | optionKV(course.level)}}
              </span>
              <span class="pull-right label label-primary info-label">
                {{COURSE_CHARGE | optionKV(course.charge)}}
              </span>
              <span class="pull-right label label-primary info-label">
                {{COURSE_STATUS | optionKV(course.status)}}
              </span>
            </div>

            <h3 class="search-title">
              <a href="#" class="blue">{{course.name}}</a>
            </h3>
            <p>
              <span class="blue bolder bigger-150">{{course.price}}&nbsp;<i class="fa fa-rmb"></i></span>
            </p>
            <p>{{course.summary}}</p>
            <p>
              <span class="badge badge-info">{{course.id}}</span>
              <span class="badge badge-info">排序: {{course.sort}}</span>
              <span class="badge badge-info">时长: {{course.time | formatSecond}}</span>
            </p>
            <p>
              <button v-on:click="toChapter(course)" class="btn btn-white btn-xs btn-info btn-round">
                大章
              </button>
              <button v-on:click="edit(course)" class="btn btn-white btn-xs btn-info btn-round">
                编辑
              <!--1.将表格每一行数据传递到edit中做处理2.将传递过来的一行数据course，赋给vue变量_this.course
                  vue变量_this.course会通过v-model属性和form表单做数据绑定-->
              </button>&nbsp;

              <button v-on:click="del(course.id)" class="btn btn-white btn-xs btn-warning btn-round">
                删除
                <!--delete 是js 的关键字，vue 方法里不能使用js 关键字-->
              </button>
            </p>
          </div>
        </div>
      </div>
    </div>

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
                <label class="col-sm-2 control-label">
                  分类
                </label>
                <div class="col-sm-10">
                  <ul id="tree" class="ztree"></ul>
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">名称</label>
                <div class="col-sm-10">
                   <input v-model="course.name" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">概述</label>
                <div class="col-sm-10">
                   <input v-model="course.summary" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">时长</label>
                <div class="col-sm-10">
                   <input v-model="course.time" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">价格（元）</label>
                <div class="col-sm-10">
                   <input v-model="course.price" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">封面</label>
                <div class="col-sm-10">
                   <input v-model="course.image" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">级别</label>
                <div class="col-sm-10">
                  <select v-model="course.level" class="form-control">
                    <option v-for="o in COURSE_LEVEL" v-bind:value="o.key">{{o.value}}</option>
                  </select>
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">收费</label>
                <div class="col-sm-10">
                  <select v-model="course.charge" class="form-control">
                    <option v-for="o in COURSE_CHARGE" v-bind:value="o.key">{{o.value}}</option>
                  </select>
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">状态</label>
                <div class="col-sm-10">
                  <select v-model="course.status" class="form-control">
                    <option v-for="o in COURSE_STATUS" v-bind:value="o.key">{{o.value}}</option>
                  </select>
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">报名数</label>
                <div class="col-sm-10">
                   <input v-model="course.enroll" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">顺序</label>
                <div class="col-sm-10">
                   <input v-model="course.sort" class="form-control">
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
<script >
  import Pagination from "@/components/pagination.vue";

  export default {
    name: "business-course",
    components: {Pagination},
    data: function () {
      return {
        course:{},
        // course变量用于绑定form 表单的数据
        courses: [],
        COURSE_LEVEL: COURSE_LEVEL,
        COURSE_CHARGE: COURSE_CHARGE,
        COURSE_STATUS: COURSE_STATUS,
        categorys: [],
        tree:{},
      }
    },
    mounted:function () {
      let _this = this;
      _this.$refs.pagination.size = 5;
      _this.allCategory();
      _this.list(1);
    },
    methods:{
      /**
       * 点击【新增】
       */
      add(){
        let _this = this;
        // 发现问题：对文本框编辑后，点新增弹出文本框，会带出上一次编辑过的值。
        _this.course = {};
        _this.tree.checkAllNodes(false);
        $("#form-modal").modal("show");//打开
        //$("#form-modal").modal("hide");//关闭
      },
      /**
       * 点击【编辑】
       */
      edit(course){
        let _this = this;
        // 数据显示：将表格行数据显示到表单。反过来，数据修改：修改表单影响表格行数据。
        _this.course = $.extend({},course);
        _this.listCategory(course.id);
        $("#form-modal").modal("show");//打开
      },
      /**
       * 列表查询
       */
      list(page) {
        let _this = this;
        Loading.show();
        // /admin 用于控台类的接口，/web 用于网站类的接口。接口设计中，用不同的请求前缀代表不同的入口，做接口隔离，方便做鉴权、统计、监控等
        _this.$ajax.post(process.env.VUE_APP_SERVER +"/business/admin/course/list",{
          page:page,
          size:_this.$refs.pagination.size,
        }).then((response) => {
          Loading.hide();
          let resp = response.data;
          _this.courses = resp.content.list;
          //response.data 就相当于responseDto
          _this.$refs.pagination.render(page,resp.content.total);
        })
      },
      /**
       * 点击【保存】
       */
      save(page) {
        let _this = this;

        // 保存校验
        //1! = 1 的设计，类似于mybatis 的动态sql 设计，在拼动态where 条件时，会在前面加 1==1
        if(1 !=1
          || !Validator.require(_this.course.name,"名称")
          || !Validator.length(_this.course.name,"名称",1,50)
          || !Validator.length(_this.course.summary,"概述",1,2000)
          || !Validator.length(_this.course.image,"封面",1,100)
        ){
          return;
        }
          let categorys = _this.tree.getCheckedNodes();
          if (Tool.isEmpty(categorys)){
            Toast.warning("请选择分类！");
            return;
          }
          // console.log(categorys);
          _this.course.categorys = categorys;
          //把tree变成组件变量
          Loading.show();
          // /admin 用于控台类的接口，/web 用于网站类的接口。接口设计中，用不同的请求前缀代表不同的入口，做接口隔离，方便做鉴权、统计、监控等
          _this.$ajax.post(process.env.VUE_APP_SERVER  + "/business/admin/course/save",_this.course).then((response) => {
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
        Confirm.show("删除课程表后不可恢复，确认删除？",function (){
          Loading.show();
          //restful 是一种请求风格。简单的理解：通过看url 就能知道这个请求是要对什么资源做什么操作
          _this.$ajax.delete(process.env.VUE_APP_SERVER + "/business/admin/course/delete/" + id).then((response) => {
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
       * 点击【大章】
       */
      toChapter(course){
        let _this = this;
        //组件(页面)间传输数据可以用h5原生的localStorage,sessionStorage;也可以用js全局变量;也可以用vuex stofe，
        // 但是后两者在页面刷新时会丢失数据，所以推荐使用h5原生的。
        SessionStorage.set("course",course);
        _this.$router.push("/business/chapter");
      },
      /**
       * 方法名和注释同样重要，要容易理解。all(),容易被误解为是查找所有的课程，所以改名allCategory()
       */
      allCategory() {
        let _this = this;
        Loading.show();
        _this.$ajax.post(process.env.VUE_APP_SERVER +"/business/admin/category/all").then((response) => {
          Loading.hide();
          let resp = response.data;
          _this.categorys = resp.content;
          _this.initTree();
        })
      },
      initTree(){
        let _this = this;
        let setting = {
          check:{
            enable:true
          },
          data:{
            simpleData:{
              idKey: "id",
              pIdKey: "parent",
              rootPId: "00000000",
              enable: true
            }
          }
        };
        let zNodes = _this.categorys;
        _this.tree = $.fn.zTree.init($("#tree"),setting,zNodes);

        //展开所有的节点
        // _this.tree.expandAll(true);
      },
      /**
       * 查找课程下所有分类
       * @param courseId
       */
      listCategory(courseId){
        let _this = this;
        Loading.show();
        _this.$ajax.post(process.env.VUE_APP_SERVER+'/business/admin/course/list-category/'+courseId).then((res)=>{
          Loading.hide();
          console.log("查找课程下所有分类结果：",res);
          let response = res.data;
          let categorys = response.content;

          //勾选查询到的分类
          _this.tree.checkAllNodes(false);
          for (let i = 0; i < categorys.length; i++) {
            let node = _this.tree.getNodeByParam("id",categorys[i].categoryId);
            _this.tree.checkNode(node,true);
          }
        })
      },
    }
  }
</script>
<!--scoped:style下的样式只应用于当前组件，防止互相污染-->
<style scoped>
 .caption h3{
   font-size: 20px;
 }
</style>