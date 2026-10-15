import { CommonStyles } from '../common/css/CommonStyles';

interface TabItem {
  name: string;
  icon: string;
  activeIcon: string;
}

@Component
export struct TabsBar {
  @Prop currentIndex: number = 0;
  private tabChangeCallback?: (index: number) => void = undefined;

  private tabs: TabItem[] = [
    { name: '首页', icon: '🏠', activeIcon: '🏠' },
    { name: '领养', icon: '🐾', activeIcon: '🐾' },
    { name: '社区', icon: '📝', activeIcon: '📝' },
    { name: '消息', icon: '💬', activeIcon: '💬' },
    { name: '我的', icon: '👤', activeIcon: '👤' }
  ];

  build() {
    Column() {
      // Tab内容区域
      Row({ space: 0 }) {
        ForEach(this.tabs, (tab: TabItem, index: number) => {
          Column() {
            // 图标 + 可选徽标
            Stack({ alignContent: Alignment.TopEnd }) {
              Text(this.currentIndex === index ? tab.activeIcon : tab.icon)
                .fontSize(24)

              // 未读消息徽标 (示例：消息tab显示)
              if (index === 3) {
                Text('3')
                  .width(16)
                  .height(16)
                  .fontSize(10)
                  .fontColor('#FFFFFF')
                  .backgroundColor(CommonStyles.DANGER)
                  .borderRadius(8)
                  .textAlign(TextAlign.Center)
                  .visibility(Visibility.Visible)
              }
            }

            // 标签文字
            Text(tab.name)
              .fontSize(11)
              .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)
              .fontColor(this.currentIndex === index ? CommonStyles.PRIMARY : CommonStyles.TEXT_TERTIARY)
              .margin({ top: 4 })
          }
          .layoutWeight(1)
          .height(56)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(() => {
            this.handleTabClick(index);
          })
        })
      }
      .width('100%')
      .backgroundColor(CommonStyles.WHITE)
      // 顶部边框线
      .border({
        width: { top: 0.5, bottom: 0, left: 0, right: 0 },
        color: { top: CommonStyles.BORDER_LIGHT, bottom: '#FFFFFF', left: '#FFFFFF', right: '#FFFFFF' },
        style: BorderStyle.Solid,
        radius: { topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0 }
      })
      // 安全区域内边距
      .padding({
        top: 6,
        bottom: `calc(6vp + env(safe-area-inset-bottom))`
      })
    }
    .width('100%')
    .shadow({
      radius: 12,
      color: '#00000008',
      offsetX: 0,
      offsetY: -2
    })
  }

  private handleTabClick(index: number): void {
    try {
      if (this.tabChangeCallback && typeof this.tabChangeCallback === 'function') {
        this.tabChangeCallback(index);
      }
    } catch (error) {
      console.error('TabsBar: Error in handleTabClick:', error);
    }
  }
}