<template>
  <div>
    <p>
      <button v-on:click="list(1)" class="btn btn-white btn-default btn-round">
        <i class="ace-icon fa fa-refresh"></i>
        刷新
      </button>
    </p>
    <pagination ref="pagination" v-bind:list="list" v-bind:itemCount="8"></pagination>
    <!--  v-bind:list="list",前面的list,是分页组件暴露出来的一个回调方法，后面的list，是sms组件的list方法  -->
    <table id="simple-table" class="table  table-bordered table-hover">
      <thead>
      <tr>
        <th>id</th>
        <th>手机号</th>
        <th>验证码</th>
        <th>用途</th>
        <th>生成时间</th>
        <th>状态</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="sms in smss">
        <td>{{sms.id}}</td>
        <td>{{sms.mobile}}</td>
        <td>{{sms.code}}</td>
        <td>{{SMS_USE | optionKV(sms.use)}}</td>
        <td>{{sms.at}}</td>
        <td>{{SMS_STATUS | optionKV(sms.status)}}</td>
      </tr>
      </tbody>
    </table>
  </div>
</template>
<script>
  import Pagination from "../../components/pagination";

  export default {
    name: "business-sms",
    components: {Pagination},
    data: function () {
      return {
        sms:{},
        // sms变量用于绑定form 表单的数据
        smss: [],
        SMS_USE: SMS_USE,
        SMS_STATUS: SMS_STATUS,
      }
    },
    mounted:function () {
      let _this = this;
      _this.$refs.pagination.size = 5;
      _this.list(1);
      // sidebar 激活样式方法一
      // this.$parent.activeSidebar("business-sms-sidebar");
    },
    methods:{
      /**
       * 列表查询
       */
      list(page) {
        let _this = this;
        Loading.show();
        _this.$refs.pagination.size = 5;
        // /admin 用于控台类的接口，/web 用于网站类的接口。接口设计中，用不同的请求前缀代表不同的入口，做接口隔离，方便做鉴权、统计、监控等
        _this.$ajax.post(process.env.VUE_APP_SERVER +"/business/admin/sms/list",{
          page:page,
          size:_this.$refs.pagination.size,
        }).then((response) => {
          Loading.hide();
          let resp = response.data;
          _this.smss = resp.content.list;
          //response.data 就相当于responseDto
          _this.$refs.pagination.render(page,resp.content.total);
        })
      },
    }
  }
</script>