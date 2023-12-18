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
    <!--  v-bind:list="list",前面的list,是分页组件暴露出来的一个回调方法，后面的list，是${domain}组件的list方法  -->
    <table id="simple-table" class="table  table-bordered table-hover">
      <thead>
      <tr>
<#list fieldList as field>
          <#if field.nameHump!="createdAt" && field.nameHump!="updatedAt">
        <th>${field.nameCn}</th>
          </#if>
      </#list>
        <th>操作</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="${domain} in ${domain}s">
        <#list fieldList as field>
          <#if field.nameHump!="createdAt" && field.nameHump!="updatedAt">
            <#if field.enums>
        <td>{{${field.enumsConst} | optionKV(${domain}.${field.nameHump})}}</td>
            <#else>
        <td>{{${domain}.${field.nameHump}}}</td>
            </#if>
          </#if>
      </#list>
      <td>
        <div class="hidden-sm hidden-xs btn-group">
          <button v-on:click="edit(${domain})" class="btn btn-xs btn-info">
            <!--              1.将表格每一行数据传递到edit中做处理2.将传递过来的一行数据${domain}，赋给vue变量_this.${domain}
                              vue变量_this.${domain}会通过v-model属性和form表单做数据绑定-->
            <i class="ace-icon fa fa-pencil bigger-120"></i>
          </button>

          <button v-on:click="del(${domain}.id)" class="btn btn-xs btn-danger">
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
              <#list fieldList as field>
                <#if field.name!="id" && field.nameHump!="createdAt" && field.nameHump!="updatedAt">
                  <#if field.enums>
              <div class="form-group">
                <label class="col-sm-2 control-label">${field.nameCn}</label>
                <div class="col-sm-10">
                  <select v-model="${domain}.${field.nameHump}" class="form-control">
                    <option v-for="o in ${field.enumsConst}" v-bind:value="o.key">{{o.value}}</option>
                  </select>
                </div>
              </div>
                  <#else>
              <div class="form-group">
                <label class="col-sm-2 control-label">${field.nameCn}</label>
                <div class="col-sm-10">
                   <input v-model="${domain}.${field.nameHump}" class="form-control">
                </div>
              </div>
                  </#if>
                </#if>
            </#list>
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
    name: "${module}-${domain}",
    components: {Pagination},
    data: function () {
      return {
        ${domain}:{},
        // ${domain}变量用于绑定form 表单的数据
        ${domain}s: [],
        <#list fieldList as field>
          <#if field.enums>
        ${field.enumsConst}: ${field.enumsConst},
          </#if>
        </#list>
      }
    },
    mounted:function () {
      let _this = this;
      _this.list(1);
      // sidebar 激活样式方法一
      // this.$parent.activeSidebar("${module}-${domain}-sidebar");
    },
    methods:{
      /**
       * 点击【新增】
       */
      add(){
        let _this = this;
        // 发现问题：对文本框编辑后，点新增弹出文本框，会带出上一次编辑过的值。
        _this.${domain} = {};
        $("#form-modal").modal("show");//打开
        //$("#form-modal").modal("hide");//关闭
      },
      /**
       * 点击【编辑】
       */
      edit(${domain}){
        let _this = this;
        // 数据显示：将表格行数据显示到表单。反过来，数据修改：修改表单影响表格行数据。
        _this.${domain} = $.extend({},${domain});
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
        _this.$ajax.post(process.env.VUE_APP_SERVER +"/${module}/admin/${domain}/list",{
          page:page,
          size:_this.$refs.pagination.size,
        }).then((response) => {
          Loading.hide();
          let resp = response.data;
          _this.${domain}s = resp.content.list;
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
        <#list fieldList as field>
          <#if field.name!="id" && field.nameHump!="createdAt" && field.nameHump!="updatedAt" && field.nameHump!="sort">
            <#if !field.nullAble>
          || !Validator.require(_this.${domain}.${field.nameHump},"${field.nameCn}")
            </#if>
            <#if (field.length > 0)>
          || !Validator.length(_this.${domain}.${field.nameHump},"${field.nameCn}",1,${field.length?c})
            </#if>
          </#if>
        </#list>
        ){
          return;
        }

          Loading.show();
          // /admin 用于控台类的接口，/web 用于网站类的接口。接口设计中，用不同的请求前缀代表不同的入口，做接口隔离，方便做鉴权、统计、监控等
          _this.$ajax.post(process.env.VUE_APP_SERVER  + "/${module}/admin/${domain}/save",_this.${domain}).then((response) => {
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
        Confirm.show("删除${tableNameCn}后不可恢复，确认删除？",function (){
          Loading.show();
          //restful 是一种请求风格。简单的理解：通过看url 就能知道这个请求是要对什么资源做什么操作
          _this.$ajax.delete(process.env.VUE_APP_SERVER + "/${module}/admin/${domain}/delete/" + id).then((response) => {
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