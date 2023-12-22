<template>
  <div>
    <div class="row">
      <div class="col-md-6">
        <p>
          <button v-on:click="add1()" class="btn btn-white btn-default btn-round">
            <i class="ace-icon fa-edit"></i>
            <!--        fa-edit 参考font awesome 图标-->
            新增一级
          </button>
          &nbsp;
          <button v-on:click="all()" class="btn btn-white btn-default btn-round">
            <i class="ace-icon fa fa-refresh"></i>
            刷新
          </button>
        </p>
        <table id="level1-table" class="table  table-bordered table-hover">
          <thead>
          <tr>
            <th>id</th>
            <th>名称</th>
            <th>顺序</th>
            <th>操作</th>
          </tr>
          </thead>
          <tbody>
          <tr v-for="category in level1" v-on:click="onClickLevel1(category)" v-bind:class="{'active': category.id === active.id}">
<!--            动态class:使用v-bind:class=json表达式，key就是样式，value是boolean,为true时，表示key的样式生效。可以和原生的class 并存-->
            <td>{{category.id}}</td>
            <td>{{category.name}}</td>
            <td>{{category.sort}}</td>
            <td>
              <div class="hidden-sm hidden-xs btn-group">
                <button v-on:click="edit(category)" class="btn btn-xs btn-info">
                  <!--              1.将表格每一行数据传递到edit中做处理2.将传递过来的一行数据category，赋给vue变量_this.category
                                    vue变量_this.category会通过v-model属性和form表单做数据绑定-->
                  <i class="ace-icon fa fa-pencil bigger-120"></i>
                </button>

                <button v-on:click="del(category.id)" class="btn btn-xs btn-danger">
                  <!--              delete 是js 的关键字，vue 方法里不能使用js 关键字-->
                  <i class="ace-icon fa fa-trash-o bigger-120"></i>
                </button>
              </div>
            </td>
          </tr>
          </tbody>
        </table>
      </div>
      <div class="col-md-6">
        <p>
          <button v-on:click="add2()" class="btn btn-white btn-default btn-round">
            <i class="ace-icon fa-edit"></i>
            <!--        fa-edit 参考font awesome 图标-->
            新增二级
          </button>
        </p>
        <table id="level2-table" class="table  table-bordered table-hover">
          <thead>
          <tr>
            <th>id</th>
            <th>名称</th>
            <th>顺序</th>
            <th>操作</th>
          </tr>
          </thead>
          <tbody>
          <tr v-for="category in level2">
            <td>{{category.id}}</td>
            <td>{{category.name}}</td>
            <td>{{category.sort}}</td>
            <td>
              <div class="hidden-sm hidden-xs btn-group">
                <button v-on:click="edit(category)" class="btn btn-xs btn-info">
                  <!--              1.将表格每一行数据传递到edit中做处理2.将传递过来的一行数据category，赋给vue变量_this.category
                                    vue变量_this.category会通过v-model属性和form表单做数据绑定-->
                  <i class="ace-icon fa fa-pencil bigger-120"></i>
                </button>

                <button v-on:click="del(category.id)" class="btn btn-xs btn-danger">
                  <!--              delete 是js 的关键字，vue 方法里不能使用js 关键字-->
                  <i class="ace-icon fa fa-trash-o bigger-120"></i>
                </button>
              </div>
            </td>
          </tr>
          </tbody>
        </table>
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
                <label class="col-sm-2 control-label">父分类</label>
                <div class="col-sm-10">
                  <p class="form-control-static">{{active.name || "无"}}</p>
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">名称</label>
                <div class="col-sm-10">
                   <input v-model="category.name" class="form-control">
                </div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label">顺序</label>
                <div class="col-sm-10">
                   <input v-model="category.sort" class="form-control">
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
    name: "business-category",
    components: {Pagination},
    data: function () {
      return {
        category:{},
        // category变量用于绑定form 表单的数据
        categorys: [],
        level1:[],
        level2:[],
        active:{},
      }
    },
    mounted:function () {
      let _this = this;
      _this.all();
      // sidebar 激活样式方法一
      // this.$parent.activeSidebar("business-category-sidebar");
    },
    methods:{
      /**
       * 点击【新增一级】
       */
      add1(){
        let _this = this;
        _this.active = {};
        _this.level2 = [];
        _this.category = {
          parent:"00000000"
        };
        $("#form-modal").modal("show");
      },
      /**
       * 点击【新增二级】
       */
      add2(){
        let _this = this;
        if (Tool.isEmpty(_this.active)){
           Toast.warning("请先点击一级分类");
           return;
        }
        _this.category = {
          parent:_this.active.id
        };
        $(".modal").modal("show");
      },
      /**
       * 点击【编辑】
       */
      edit(category){
        let _this = this;
        // 数据显示：将表格行数据显示到表单。反过来，数据修改：修改表单影响表格行数据。
        _this.category = $.extend({},category);
        $("#form-modal").modal("show");//打开
      },
      /**
       * 列表查询
       */
      all() {
        let _this = this;
        Loading.show();
        // /admin 用于控台类的接口，/web 用于网站类的接口。接口设计中，用不同的请求前缀代表不同的入口，做接口隔离，方便做鉴权、统计、监控等
        _this.$ajax.post(process.env.VUE_APP_SERVER +"/business/admin/category/all").then((response) => {
          Loading.hide();
          let resp = response.data;
          _this.categorys = resp.content;
          //将所有记录格式化成树形结构
          _this.level1 = [];
          for (let i = 0; i < _this.categorys.length; i++) {
            let c = _this.categorys[i];
            if (c.parent === '00000000'){
              _this.level1.push(c);
              for (let j = 0; j < _this.categorys.length; j++) {
                let child = _this.categorys[j];
                if (child.parent === c.id){
                  if(Tool.isEmpty(c.children)){
                    c.children = [];
                  }
                  c.children.push(child);
                }
              }
            }
          }
          //处理：对一级或二级分类的增删改查，都会调用all()刷新数据，所以all()的后面触发一次表格行点击事件。
          _this.level2 = [];
          //对当前一级分类中选中的表格触发一次点击事件，以刷新二级菜单列表
          //注意：界面的渲染需要等vue绑定好变量后才做，所以加延时100ms
          setTimeout(function (){
            $("tr.active").trigger("click");
          },100);
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
          || !Validator.require(_this.category.parent,"父id")
          || !Validator.require(_this.category.name,"名称")
          || !Validator.length(_this.category.name,"名称",1,50)
        ){
          return;
        }

          Loading.show();
          // /admin 用于控台类的接口，/web 用于网站类的接口。接口设计中，用不同的请求前缀代表不同的入口，做接口隔离，方便做鉴权、统计、监控等
          _this.$ajax.post(process.env.VUE_APP_SERVER  + "/business/admin/category/save",_this.category).then((response) => {
          Loading.hide();
          let resp = response.data;
          if (resp.success){
            $("#form-modal").modal("hide");
            _this.all();
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
        Confirm.show("删除分类后不可恢复，确认删除？",function (){
          Loading.show();
          //restful 是一种请求风格。简单的理解：通过看url 就能知道这个请求是要对什么资源做什么操作
          _this.$ajax.delete(process.env.VUE_APP_SERVER + "/business/admin/category/delete/" + id).then((response) => {
            Loading.hide();
            let resp = response.data;
            if (resp.success){
              _this.all();
              Toast.success("删除成功！");
            }
          })
        });
      },
      onClickLevel1(category){
        let _this = this;
        _this.active = category;
        _this.level2 = category.children;
      }
    }
  }
</script>
<style scoped>
  .active td{
    background-color: #d6e9c6 !important;
  }
</style>