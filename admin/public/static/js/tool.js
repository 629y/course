Tool = {
  /**
   * 空校验 null或""都返回true
   */
  isEmpty: function (obj) {
    if ((typeof obj == 'string')) {
      return !obj || obj.replace(/\s+/g, "") == ""
    } else {
      return (!obj || JSON.stringify(obj) === "{}" || obj.length === 0);
    }
  },

  /**
   * 非空校验
   */
  isNotEmpty: function (obj) {
    return !this.isEmpty(obj);
  },

  /**
   * 长度校验
   */
  isLength: function (str, min, max) {
    return $.trim(str).length >= min && $.trim(str).length <= max;
  },
  /**
   * 时间格式化，date为空时取当前时间
   */
  dateFormat: function (format,date){
    let result;
    if (!date){
      date = new Date();
    }
    const option = {
      "y+":date.getFullYear().toString(),    //年
      "M+":(date.getMonth()+1).toString(),   //月
      "d+":date.getDate().toString(),        //日
      "h+":date.getHours().toString(),       //时
      "m+":date.getMinutes().toString(),     //分
      "s+":date.getSeconds().toString(),     //秒
    };
    for (let i in option){
      result = new RegExp("("+i+")").exec(format);
      if (result){
        format = format.replace(result[1],(result[1].length===1)?(option[i])
          :(option[i].padStart(result[1].length, "0")))
      }
    }
    return format;
  },
  /**
   * 移除对象数组中的对象
   * @param array
   * @param obj
   * @returns {number}
   */
  //splice() 方法向/从数组中添加/删除项目，然后返回被删除的项目。
  //注释：该方法会改变原始数组。
  removeObj: function (array, obj) {
    let index = -1;
    for (let i = 0; i < array.length; i++) {
      if (array[i] === obj) {
        array.splice(i, 1);
        index = i;
        break;
      }
    }
    return index;
  },
  /**
   * 10进制转62进制
   * @param number
   * @returns {string}
   * @private
   */
  _10to62: function (number) {
    let chars = '0123456789abcdefghigklmnopqrstuvwxyzABCDEFGHIGKLMNOPQRSTUVWXYZ';
    let radix = chars.length;
    let arr = [];
    do {
      let mod = number % radix;
      number = (number - mod) / radix;
      arr.unshift(chars[mod]);
    } while (number);
    return arr.join('');
  },
  /**
   * 保存登录用户信息
   */
  setLoginUser: function (loginUser) {
    SessionStorage.set(SESSION_KEY_LOGIN_USER,loginUser);
  },
  /**
   * 获取登录用户信息
   */
  getLoginUser: function () {
    return SessionStorage.get(SESSION_KEY_LOGIN_USER) || {};
    //小技巧：在获取一些对象的时候，加上|| {},避免获取属性值时报错。
  },
};