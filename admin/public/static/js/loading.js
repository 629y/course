// 显示等待框
Loading = {
  show: function () {
    $.blockUI({
      message: '<img src="/static/image/loading.gif" />',
      css: {
        zIndex:"10011",//如果不改，loading按钮会被模态框挡住，看不到转圈圈图片
        padding: "10px",
        left: "50%",
        width: "80px",
        marginLeft: "-40px",
      }
    });
  },
  hide: function () {
    // 本地查询速度太快，loading显示一瞬间，故意做个延迟，其实这里面的内容只需要$.unblockUI();就可以
    setTimeout(function () {
      $.unblockUI();
    }, 500)
  }
};