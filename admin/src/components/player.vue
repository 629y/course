<template>
  <div v-bind:id="playerId">
<!--要做成动态的，所以不在这个地方写了-->
<!--    <div class="prism-player" id="J_prismPlayer"></div>-->
  </div>
</template>
<script>
export default {
  name: "player",
  props: {
    playerId: {
      default: "player-div"
    },
  },
  data: function () {
    return {
      aliPlayer: {},//播放器实例
    }
  },
  methods: {
    playUrl(url) {
      let _this = this;
      console.log("开始播放:", url);

      //如果已经有播放器了，则将播放器div删除
      if (_this.aliPlayer) {
        _this.aliPlayer = null;
        $("#J_prismPlayer").remove();
      }

      // 初始化播放器
      $("#" + _this.playerId)
          .append("<div class=\"prism-player\" id=\"J_prismPlayer\"></div>");
      _this.aliPlayer = new Aliplayer({
        id: "J_prismPlayer",
        width: '100%',
        autoplay: false,
        source: url,
        cover: 'http://imooc-coursemac.oss-cn-shanghai.aliyuncs.com/头像1.jpg',
      }, function (player) {
        console.log('播放器创建好了。')
      });
    },
  }
}
</script>
