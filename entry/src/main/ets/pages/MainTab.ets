import { CommonStyles } from '../common/css/CommonStyles';
import { TabsBar } from '../components/TabsBar';
import { Index } from './Index';
import { PetList } from './PetList';
import { PostList } from './PostList';
import { Messages } from './Messages';
import { Mine } from './Mine';
import { SafeArea } from '../components/SafeArea';

@Entry
@Component
export struct MainTab {
  @State currentIndex: number = 0;
  // 路由返回刷新戳：Mine 作为内嵌组件收不到 onPageShow，由 MainTab 在此自增并透传。
  @State mineRefreshKey: number = 0;

  private handleTabChange(index: number): void {
    this.currentIndex = index;
  }

  aboutToAppear(): void {
    this.mineRefreshKey = 0;
  }

  onPageShow(): void {
    // 从 MyFavorites / Detail 返回时 Mine 不会重建，用 key 变化触发其 @Watch 重读。
    this.mineRefreshKey++;
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top', 'bottom']
      }) {
        Column() {
          // 页面内容区域
          Column() {
            Index()
              .visibility(this.currentIndex === 0 ? Visibility.Visible : Visibility.None)

            PetList()
              .visibility(this.currentIndex === 1 ? Visibility.Visible : Visibility.None)

            PostList()
              .visibility(this.currentIndex === 2 ? Visibility.Visible : Visibility.None)

            Messages()
              .visibility(this.currentIndex === 3 ? Visibility.Visible : Visibility.None)

            Mine({ isActive: this.currentIndex === 4, refreshKey: this.mineRefreshKey })
              .visibility(this.currentIndex === 4 ? Visibility.Visible : Visibility.None)
          }
          .width('100%')
          .layoutWeight(1)
          .padding({ top: '45mm' })
          .backgroundColor(CommonStyles.BG_SECONDARY)

          // 底部导航栏
          TabsBar({
            currentIndex: this.currentIndex,
            tabChangeCallback: (index: number) => this.handleTabChange(index)
          })
        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(CommonStyles.BG_SECONDARY)
  }
}
