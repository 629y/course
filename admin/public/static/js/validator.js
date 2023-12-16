Validator = {
  require: function (value, text) {
    if (Tool.isEmpty(value)) {
      Toast.warning(text + "不能为空");
      return false;
    } else {
      return true;
    }
  },

  length: function (value, text, min, max) {
    //为了不改模板，所以增加这个判断
    if (Tool.isEmpty(value)) {
      return true;
    }
    if (!Tool.isLength(value, min, max)) {
      Toast.warning(text + "长度" + min + "~" + max + "位");
      return false;
    } else {
      return true;
    }
  }
};