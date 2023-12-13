const Toast = Swal.mixin({
  toast: true,
  position: "top-end",
  showConfirmButton: false,
  timer: 3000,
  timerProgressBar: true,
  didOpen: (toast) => {
    toast.onmouseenter = Swal.stopTimer;
    toast.onmouseleave = Swal.resumeTimer;
  }
});
toast = {
  success:function (message){
    Toast.fire({
      icon: "success",
      title: message
    });
  },
  error:function (message){
    Toast.fire({
      icon: "error",
      title: message
    });
  },
  warning:function (message){
    Toast.fire({
      icon: "warning",
      title: message
    });
  }
};