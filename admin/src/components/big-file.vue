<template>
  <div>
    <button type="button" v-on:click="selectFile()" class="btn btn-white btn-default btn-round">
      <i class="ace-icon fa fa-upload"></i>
      {{text}}
    </button>
    <input class="hidden" type="file" ref="file" v-on:change="uploadFile()" v-bind:id="inputId+'-input'">
  </div>
</template>

<script>
export default {
  name: 'big-file',
  //props，用于父子组件传递数据，可以理解成组件可配置的属性。
  props: {
    text:{
      default: "上传大文件"
    },
    inputId:{
      default: "file-upload"
    },
    suffixs:{
      default: []
    },
    use:{
      default: ""
    },
    afterUpload: {
      type: Function,
      default: null
    },
  },
  data: function () {
    return {}
  },
  methods: {
     uploadFile(){
      let _this = this;
      let formData = new window.FormData();
      let file = _this.$refs.file.files[0];

      console.log(file);
      /*
        name:"fourcat.mp4"
        lastModified:1901173357457
        lastModifiedDate:Tue May 27 2099 14:49:17 GMT+0800 (中国标准时间){}
        webkitRelativePath:""
        size:37415970
        type:"video/mp4"
       */
      //生成文件标识，标识多次上传的是不是同一个文件
      let key = hex_md5(file);
      let key10 = parseInt(key,16);
      let key62 = Tool._10to62(key10);
      //26个大写字母+26个小写字母+10个阿拉伯数字，共62个字符，可以表达62进制数字
      console.log(key,key10,key62);


      //判断文件格式
      let suffixs =_this.suffixs;
      let fileName = file.name;
      let suffix = fileName.substring(fileName.lastIndexOf(".") + 1,fileName.length).toLowerCase();
      let validateSuffix = false;
      for (let i = 0; i < suffixs.length; i++) {
        if(suffixs[i].toLowerCase() === suffix){
          validateSuffix = true;
          break;
        }
      }
      if(!validateSuffix){
        Toast.warning("文件格式不正确，只支持上传：" + suffixs.join(","));
        $("#" + _this.inputId + "-input").val("");
        return;
      }

      //文件分片
      let shardSize = 5 * 1024 * 1024;   //以15MB为一个分片
      let shardIndex = 1;//分片索引,1表示第一个分片


      let size = file.size;
      let shardTotal = Math.ceil(size / shardSize);//总片数

      let param = {
        'shardIndex':shardIndex,
        'shardSize':shardSize,
        'shardTotal':shardTotal,
        'use':_this.use,
        'name':file.name,
        'suffix':suffix,
        'size':file.size,
        'key':key62
      };
      _this.upload(param);
    },
    upload : function (param) {
      let _this = this;
      //shardIndex和shardTotal在param中已经有了，所以不需要单独传参
      let shardIndex = param.shardIndex;
      let shardTotal = param.shardTotal;
      let shardSize = param.shardSize;
      let fileShard = _this.getFileShard(shardIndex, shardSize);
      //将图片转为base64进行传输
      let fileReader = new FileReader();
      fileReader.onload = function (e) {
        let base64 = e.target.result;
        // console.log("base64",base64);

        param.shard = base64;

        Loading.show();
        _this.$ajax.post(process.env.VUE_APP_SERVER + "/file/admin/upload", param).then((response) => {
          Loading.hide();
          let resp = response.data;
          console.log("上传文件成功：", resp);
          if (shardIndex < shardTotal) {
            //上传下一个分片
            param.shardIndex = param.shardIndex + 1;
            _this.upload(param);
            //递归，不断的重复做某一件事（上传分片），直到某个条件成立 (shardIndex == shardTotal) ,退出重复做的事。初学者慎用，容易陷入无限递归，跳不出来。
          } else {
            _this.afterUpload(resp);
            $("#" + _this.inputId + "-input").val("");
          }
        });
      };
      fileReader.readAsDataURL(fileShard);
    },
    getFileShard: function (shardIndex, shardSize) {
      let _this = this;
      let file = _this.$refs.file.files[0];
      //起始位置，其实就是和mysql分页一样
      let start = (shardIndex - 1) * shardSize;//当前分片起始位置
      //比如说35MB，第一个是20MB，第二个就是15MB，所以就要取最小的那个了。
      let end = Math.min(file.size, start + shardSize);//当前分片结束位置
      let fileShard = file.slice(start, end);//从文件中截取当前的分片数据
      return fileShard;
    },
    selectFile(){
      let _this = this;
      $("#" + _this.inputId + "-input").trigger("click");
    }
  }
}
</script>
