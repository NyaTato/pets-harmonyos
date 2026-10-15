import { RouterHelper } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { AppStore } from '../store/AppStore';
import { User } from '../mock/UserData';
import { getUserApplies } from '../mock/ApplyData';
import { getUserFavoriteRecords, getUserViewRecords, getFavoriteVersion, subscribeFavoriteChanges } from '../mock/InteractionData';
import { promptAction } from '@kit.ArkUI';
import { SafeArea } from '../components/SafeArea';

@Component
export struct Mine {
  @State private userInfo: User | null = null;
  @State private cloudCarePoints: number = 0;
  @State private isDarkMode: boolean = false;
  @State private showLogin: boolean = false;
  @State private applyCount: number = 0;
  @State private favoriteCount: number = 0;
  @State private historyCount: number = 0;
  // MainTab 透传：Tab 是否选中 / 路由返回刷新戳。Mine 作为内嵌 @Component 收不到
  // onPageShow，visibility 切换与路由返回都不会重建组件，全靠这两个 @Prop @Watch 刷新。
  @Prop @Watch('onExternalRefresh') isActive: boolean = false;
  @Prop @Watch('onExternalRefresh') refreshKey: number = 0;
  // 收藏记录跨页面变更时由 InteractionData 直接推送，Mine 订阅后重读计数。
  private unsubscribeFavorites: (() => void) | null = null;
  private lastFavoriteVersion: number = -1;

  aboutToAppear() {
    this.loadUserInfo();
    this.ensureFavoriteSubscription();
  }

  // 注意：push MyFavorites / Detail 时 Mine 不会被销毁，返回时也不会重新触发
  // aboutToAppear（本组件的 onPageShow 同样不会被框架调用），所以刻意不在
  // aboutToDisappear 中取消订阅，否则返回后推送永久丢失，计数停留在旧值。
  aboutToDisappear(): void {
  }

  // Tab 选中变化与 MainTab.onPageShow 自增的 refreshKey 都会走到这里：
  // 先补齐订阅（幂等），再按当前用户重读计数，保证返回与 Tab 往返可见时即最新。
  onExternalRefresh(): void {
    this.ensureFavoriteSubscription();
    this.loadUserInfo();
  }

  private ensureFavoriteSubscription(): void {
    if (this.unsubscribeFavorites) {
      return;
    }
    this.lastFavoriteVersion = getFavoriteVersion();
    this.unsubscribeFavorites = subscribeFavoriteChanges((version: number) => {
      this.lastFavoriteVersion = version;
      this.loadUserInfo();
    });
  }

  loadUserInfo() {
    const store = AppStore.getInstance();
    const state = store.getState();
    const currentUser = state.currentUser;

    if (currentUser) {
      this.userInfo = currentUser;
      this.cloudCarePoints = 100;
      this.showLogin = false;

      this.applyCount = getUserApplies(currentUser.id).length;
      this.favoriteCount = getUserFavoriteRecords(currentUser.id).length;
      this.historyCount = getUserViewRecords(currentUser.id).length;
      this.lastFavoriteVersion = getFavoriteVersion();
    } else {
      this.userInfo = null;
      this.showLogin = true;
      this.applyCount = 0;
      this.favoriteCount = 0;
      this.historyCount = 0;
    }
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top', 'bottom']
      }) {
        Scroll() {
          Column() {
            this.GuestContent()
            this.LoggedInContent()
          }
          .width('100%')
          .padding({ bottom: CommonStyles.SPACE_3XL })
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .layoutWeight(1)
        .backgroundColor(CommonStyles.COLOR_BG)
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder GuestContent() {
    Column({ space: CommonStyles.SPACE_XL }) {
      Column() {
        Column() {
        Circle()
          .width(80)
          .height(80)
          .fill(CommonStyles.GRADIENT_BRAND)

        Text('未登录')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .margin({ top: CommonStyles.SPACE_LG })
      }
      .margin({ top: CommonStyles.SIZE_2XL })

        Text('请先登录')
          .fontSize(CommonStyles.FONT_SIZE_XL)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Text('登录后查看个人信息')
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontColor(CommonStyles.TEXT_SECONDARY)
          .textAlign(TextAlign.Center)
          .margin({ top: CommonStyles.SPACE_SM })

        Button('去登录', { type: ButtonType.Capsule })
          .width(CommonStyles.BUTTON_WIDTH_XL)
          .height(CommonStyles.BUTTON_HEIGHT_XL)
          .fontSize(CommonStyles.FONT_SIZE_LG)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.WHITE)
          .backgroundColor(CommonStyles.PRIMARY)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .shadow(CommonStyles.SHADOW_BRAND_OLD)
          .margin({ top: CommonStyles.SPACE_XL })
          .onClick(() => {
            RouterHelper.navigateToLogin();
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .visibility(this.showLogin ? Visibility.Visible : Visibility.None)
    }
    .width('100%')
  }

  @Builder LoggedInContent() {
    Column({ space: CommonStyles.SPACE_XL }) {
      this.ProfileHeader()
      this.FunctionGrid()
      this.LogoutButton()
    }
    .width('100%')
    .visibility((!this.showLogin && this.userInfo) ? Visibility.Visible : Visibility.None)
  }

  @Builder ProfileHeader() {
    Column({ space: CommonStyles.SPACE_LG }) {
      Row() {
        Image(this.userInfo?.avatar ? $rawfile(this.userInfo.avatar) : '')
          .width(CommonStyles.SIZE_2XL)
          .height(CommonStyles.SIZE_2XL)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .objectFit(ImageFit.Cover)
          .border({ width: 3, color: CommonStyles.WHITE })
          .shadow(CommonStyles.SHADOW_LG)

        Column({ space: CommonStyles.SM }) {
          Text(this.userInfo?.nickname || '爱宠领用户')
            .fontSize(CommonStyles.FONT_SIZE_XL)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.WHITE)

          Row({ space: CommonStyles.SM }) {
            Text(`ID: ${this.userInfo?.id || '-'}`)
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(CommonStyles.PRIMARY_LIGHT)

            Text('👤')

            Text(`Lv.${this.userInfo?.level || 1}`)
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(CommonStyles.PRIMARY_LIGHT)
          }
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        .margin({ left: CommonStyles.SPACE_LG })

        Button('编辑', { type: ButtonType.Normal })
          .height(CommonStyles.BUTTON_HEIGHT_SM)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.PRIMARY)
          .backgroundColor(CommonStyles.WHITE)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .onClick(() => {
            RouterHelper.pushUrl('pages/EditProfile');
          })
      }
      .width('100%')

      Row() {
        // 申请数字刻意内联而不走 this.StatItem(...)：@Builder 的按值参数是一次性拷贝，
        // 状态变化不会重建该项，会导致申请数停留在初次渲染的值（与收藏数修复同理）。
        Column({ space: CommonStyles.XS }) {
          Text(this.applyCount.toString())
            .fontSize(CommonStyles.FONT_SIZE_LG)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.WHITE)

          Text('申请')
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.PRIMARY_LIGHT)
        }
        // 收藏数字刻意内联而不走 this.StatItem(...)：@Builder 的按值参数是一次性拷贝，
        // 状态变化不会重建该项，会导致收藏数停留在初次渲染的值。
        Column({ space: CommonStyles.XS }) {
          Text(this.favoriteCount.toString())
            .fontSize(CommonStyles.FONT_SIZE_LG)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.WHITE)

          Text('收藏')
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.PRIMARY_LIGHT)
        }
        this.StatItem('👁', this.historyCount.toString(), '浏览')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
      .padding({ top: CommonStyles.MD, bottom: CommonStyles.XS })
    }
    .width('100%')
    .padding(CommonStyles.SPACE_XL)
    .linearGradient({
      angle: 135,
      colors: [[CommonStyles.PRIMARY, 0], [CommonStyles.PRIMARY_DARK, 1]]
    })
    .borderRadius(CommonStyles.RADIUS_XL)
    .margin({ bottom: -CommonStyles.MD })
  }

  @Builder StatItem(emoji: string, value: string, label: string) {
    Column({ space: CommonStyles.XS }) {
      Text(value)
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.WHITE)

      Text(label)
        .fontSize(CommonStyles.FONT_SIZE_SM)
        .fontColor(CommonStyles.PRIMARY_LIGHT)
    }
  }

  @Builder FunctionGrid() {
    Grid() {
      GridItem() { this.FunctionEntry('📋', '我的申请', 'pages/MyApply') }
      GridItem() { this.FunctionEntry('❤️', '我的收藏', 'pages/MyFavorites') }
      GridItem() { this.FunctionEntry('📍', '地址管理', 'pages/AddressList') }
      GridItem() { this.FunctionEntry('💬', '我的评论', 'pages/MyComments') }
      GridItem() { this.FunctionEntry('👍', '我的点赞', 'pages/MyLikes') }
      GridItem() { this.FunctionEntry('🕐', '浏览历史', 'pages/BrowseHistory') }
      GridItem() { this.FunctionEntry('📅', '护理日历', 'pages/Calendar') }
      GridItem() { this.FunctionEntry('💭', '消息通知', 'pages/Messages') }
      GridItem() { this.FunctionEntry('⚙️', '系统设置', 'pages/EditProfile') }
      GridItem() { this.FunctionEntry('💡', '意见反馈', 'pages/Feedback') }
      GridItem() { this.FunctionEntry('🔔', '系统公告', 'pages/Notice') }
      GridItem() { this.FunctionEntry('✨', '功能展示', 'pages/InnovationDemo') }
    }
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .rowsGap(CommonStyles.SPACE_MD)
    .columnsGap(CommonStyles.SPACE_MD)
    .padding(CommonStyles.SPACE_LG)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  @Builder FunctionEntry(icon: string, title: string, page: string) {
    Column({ space: CommonStyles.SM }) {
      Text(icon)
        .fontSize(CommonStyles.FONT_SIZE_XL)

      Text(title)
        .fontSize(CommonStyles.FONT_SIZE_SM)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .padding({ top: CommonStyles.MD, bottom: CommonStyles.MD })
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
    .onClick(() => {
      RouterHelper.pushUrl(page);
    })
  }

  @Builder LogoutButton() {
    Button('退出登录', { type: ButtonType.Capsule })
      .width('90%')
      .height(CommonStyles.BUTTON_HEIGHT_XL)
      .fontSize(CommonStyles.FONT_SIZE_MD)
      .fontColor(CommonStyles.DANGER)
      .backgroundColor('#FEE2E2')
      .borderRadius(CommonStyles.RADIUS_FULL)
      .margin({ top: CommonStyles.SPACE_XL })
      .onClick(() => {
        promptAction.showToast({
          message: '确认退出登录',
          duration: 2000
        });
        const store = AppStore.getInstance();
        store.clearUser();
        this.showLogin = true;
        this.userInfo = null;
      })
  }
}
