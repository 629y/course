import Vue from 'vue'
import App from './app.vue'
import router from './router'
import axios from 'axios'
import filter from "@/filter/filter";
Vue.config.productionTip = false;
Vue.prototype.$ajax = axios;

//解决每次ajax请求，对应的sessionId不一致的问题
axios.defaults.withCredentials = true;

/**
 * axios拦截器
 */
axios.interceptors.request.use(function (config) {
  console.log("请求：", config);
 let token = Tool.getLoginUser().token;
 if (Tool.isNotEmpty(token)){
   //可以用这种方法给所有请求加了统一的系统参数，比如在header里加上请求流水，请求时间等。
   config.headers.token = token;
   console.log("请求headers增加token:",token);
 }
  return config;
}, error => {});
axios.interceptors.response.use(function (response) {
  console.log("返回结果：", response);
  return response;
}, error => {
  console.log("返回拦截:",error.response);
  let response = error.response;
  const status= response.status;
  if (status === 401){
    //判断状态码是401，跳转到登录
    console.log("未登录，跳到登录页面");
    Tool.setLoginUser(null);
    router.push('/login');
  }
  return{
    data:{
      success:false,
      message:"请重新登录"
    }
  };
});

//全局过滤器
Object.keys(filter).forEach(key=>{
  Vue.filter(key,filter[key])
});

//路由拦截器
router.beforeEach((to,from,next)=>{
  //要不要对meta.loginRequire属性做监控拦截
  if (to.matched.some(function (item){
    return item.meta.loginRequire
  })){
    let loginUser = Tool.getLoginUser();
    if (Tool.isEmpty(loginUser)){
      next('/login');
    }else{
      next();
    }
  }else {
    next();
  }
});

new Vue({
  router,
  render: h => h(App),
}).$mount('#app');

console.log("环境：",process.env.NODE_ENV);