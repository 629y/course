<template>
  <div>
    <p>
      <button v-on:click="list(1)" class="btn btn-white btn-default btn-round">
        <i class="ace-icon fa fa-refresh"></i>
        刷新
      </button>
    </p>
    <div class="row">
      <div class="col-md-6">
        <textarea id="resource-textarea" class="form-control" v-model="resourceStr" name="resource"
                  rows="10"></textarea>
        <br>
        <button id="save-btn" type="button" class="btn btn-primary" v-on:click="save()">
          保存
        </button>
      </div>
      <div class="col-md-6">
        <ul id="tree" class="ztree"></ul>
      </div>
    </div>
  </div>
</template>
<script>
  export default {
    name: "system-resource",
    data: function () {
      return {
        resource:{},
        // resource变量用于绑定form 表单的数据
        resources: [],
        resourceStr:"",
        tree:{},
      }
    },
    mounted:function () {
      let _this = this;
      _this.list();
      // sidebar 激活样式方法一
      // this.$parent.activeSidebar("system-resource-sidebar");
    },
    methods:{
      /**
       * 列表查询
       */
      list() {
        let _this = this;
        Loading.show();
        // /admin 用于控台类的接口，/web 用于网站类的接口。接口设计中，用不同的请求前缀代表不同的入口，做接口隔离，方便做鉴权、统计、监控等
        _this.$ajax.get(process.env.VUE_APP_SERVER +"/system/admin/resource/load-tree").then((res) => {
          Loading.hide();
          let response = res.data;
          _this.resources = response.content;
          //初始化树
          _this.initTree();
        })
      },
      /**
       * 点击【保存】
       */
      save() {
        let _this = this;
        // 保存校验
        if(Tool.isEmpty(_this.resourceStr)){
          Toast.warning("资源不能为空！");
          return;
        }
        let json = JSON.parse(_this.resourceStr);

          Loading.show();
          // /admin 用于控台类的接口，/web 用于网站类的接口。接口设计中，用不同的请求前缀代表不同的入口，做接口隔离，方便做鉴权、统计、监控等
          _this.$ajax.post(process.env.VUE_APP_SERVER  + "/system/admin/resource/save",json).then((response) => {
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
        Confirm.show("删除资源后不可恢复，确认删除？",function (){
          Loading.show();
          //restful 是一种请求风格。简单的理解：通过看url 就能知道这个请求是要对什么资源做什么操作
          _this.$ajax.delete(process.env.VUE_APP_SERVER + "/system/admin/resource/delete/" + id).then((response) => {
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
       * 初始化资源树
       */
      initTree(){
        let _this = this;
        let setting = {
          data:{
            simpleData:{
              idKey:"id",
              pIdKey:"parent",
              rootPId:"",
            }
          }
        };
        _this.zTree = $.fn.zTree.init($("#tree"),setting,_this.resources);
        _this.zTree.expandAll(true);
      },
    }
  }
</script>