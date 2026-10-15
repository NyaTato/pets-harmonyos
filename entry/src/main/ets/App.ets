// 鸿蒙宠物领养平台应用入口
// 应用入口组件，由EntryAbility加载Splash页面作为启动页
// 此组件仅作为占位，实际启动逻辑在Splash页面中处理

@Component
struct App {
  build() {
    // 空白页面，实际内容由路由跳转控制
    Column() {
      // 空页面，实际内容由Splash页面控制
    }
    .width('100%')
    .height('100%')
  }
}
