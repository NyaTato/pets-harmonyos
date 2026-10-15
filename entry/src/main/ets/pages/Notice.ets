import { RouterHelper } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { getNotices, getUnreadNoticeCount, markNoticeAsRead, markAllNoticesAsRead, noticeList, Notice } from '../mock/NoticeData';
import { AppStore } from '../store/AppStore';
import { promptAction } from '@kit.ArkUI';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

interface TypeOption {
  label: string;
  icon: string;
  value: string;
}

@Entry
@Component
struct NoticePage {
  @State private notices: Notice[] = [];
  @State private unreadCount: number = 0;
  @State private isLoading: boolean = true;
  @State private selectedType: string = '全部';
  @State private showNoticeDialog: boolean = false;
  @State private selectedNoticeTitle: string = '';
  @State private selectedNoticeContent: string = '';

  private typeOptions: TypeOption[] = [
    { label: '全部', icon: '📋', value: 'all' },
    { label: '系统', icon: '🔔', value: 'system' },
    { label: '活动', icon: '🎉', value: 'activity' },
    { label: '维护', icon: '🔧', value: 'maintenance' },
    { label: '重要', icon: '⚠️', value: 'important' }
  ];

  aboutToAppear() {
    this.loadNotices();
  }

  loadNotices() {
    this.isLoading = true;

    setTimeout(() => {
      this.notices = getNotices();
      this.unreadCount = getUnreadNoticeCount();
      this.isLoading = false;

      const store = AppStore.getInstance();
      if (store.getState().notices.length === 0) {
        store.setNotices([...this.notices]);
      }
    }, 500);
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top', 'bottom']
      }) {
        Column() {
          this.NavigationBar()
          this.TypeFilter()

          Scroll() {
            Column({ space: CommonStyles.LG }) {
              this.LoadingContent()
              this.EmptyContent()
              this.NoticeList()
            }
            .padding({ left: CommonStyles.LG, right: CommonStyles.LG, bottom: CommonStyles.SPACE_3XL })
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)
          .layoutWeight(1)
        }
        .width('100%')
        .height('100%')
        .backgroundColor(CommonStyles.COLOR_BG)

        if (this.showNoticeDialog) {
          this.NoticeDetailDialog()
        }
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: '45mm' })
  }

  @Builder NavigationBar() {
    Row() {
      BackButton()

      Text('📢 系统公告')
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Row({ space: CommonStyles.XS }) {
        if (this.unreadCount > 0) {
          Text(`${this.unreadCount}`)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.WHITE)
            .padding({ left: CommonStyles.SM, right: CommonStyles.SM, top: 2, bottom: 2 })
            .backgroundColor(CommonStyles.DANGER)
            .borderRadius(CommonStyles.RADIUS_FULL)
        }

        Text('✓')
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontColor(CommonStyles.PRIMARY)
          .visibility(this.unreadCount > 0 ? Visibility.Visible : Visibility.None)
          .onClick(() => {
            this.markAllAsRead();
          })
      }
      .width(CommonStyles.ICON_SIZE_TOUCH)
      .height(CommonStyles.ICON_SIZE_TOUCH)
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Bottom)
      .onClick(() => {
        if (this.unreadCount > 0) {
          this.markAllAsRead();
        }
      })
    }
    .width('100%')
    .padding({ left: CommonStyles.LG, right: CommonStyles.LG, top: CommonStyles.SM, bottom: CommonStyles.SM })
  }

  @Builder TypeFilter() {
    Scroll() {
      Row({ space: CommonStyles.SM }) {
        ForEach(this.typeOptions, (option: TypeOption) => {
          Text(`${option.icon} ${option.label}`)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontWeight(this.selectedType === option.value ? FontWeight.Medium : FontWeight.Normal)
            .fontColor(this.selectedType === option.value ? CommonStyles.WHITE : CommonStyles.TEXT_SECONDARY)
            .padding({ left: CommonStyles.MD, right: CommonStyles.MD, top: CommonStyles.SM, bottom: CommonStyles.SM })
            .backgroundColor(this.selectedType === option.value ? CommonStyles.PRIMARY : CommonStyles.GRAY_100)
            .borderRadius(CommonStyles.RADIUS_FULL)
            .onClick(() => {
              this.selectedType = option.value;
              this.filterNotices();
            })
        })
      }
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .width('100%')
    .padding({ left: CommonStyles.LG, right: CommonStyles.LG, top: CommonStyles.SM, bottom: CommonStyles.SM })
  }

  @Builder LoadingContent() {
    Column() {
      LoadingProgress()
        .color(CommonStyles.PRIMARY)
        .width(CommonStyles.SIZE_XL)
        .height(CommonStyles.SIZE_XL)

      Text('加载中...')
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .margin({ top: CommonStyles.MD })
    }
    .width('100%')
    .height(CommonStyles.SIZE_2XL)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .visibility(this.isLoading ? Visibility.Visible : Visibility.None)
  }

  @Builder EmptyContent() {
    Column() {
      Text('📢')
        .fontSize(64)

      Text('暂无公告')
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .margin({ top: CommonStyles.LG })

      Text('暂时没有新的系统公告 📭')
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .margin({ top: CommonStyles.XS })
    }
    .width('100%')
    .height(CommonStyles.SIZE_2XL)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .visibility((!this.isLoading && this.notices.length === 0) ? Visibility.Visible : Visibility.None)
  }

  @Builder NoticeList() {
    Column({ space: CommonStyles.MD }) {
      ForEach(this.notices, (notice: Notice) => {
        this.NoticeCard(notice)
      })
    }
    .width('100%')
    .visibility((!this.isLoading && this.notices.length > 0) ? Visibility.Visible : Visibility.None)
  }

  @Builder NoticeCard(notice: Notice) {
    Column({ space: CommonStyles.MD }) {
      Row() {
        Stack({ alignContent: Alignment.TopEnd }) {
          Column() {
            Text(this.getTypeIcon(notice.type))
              .fontSize(CommonStyles.FONT_SIZE_XL)
          }
          .width(CommonStyles.AVATAR_SIZE_MD)
          .height(CommonStyles.AVATAR_SIZE_MD)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor(notice.isRead ? CommonStyles.GRAY_100 : CommonStyles.PRIMARY_LIGHT)
          .borderRadius(CommonStyles.RADIUS_FULL)

          if (!notice.isRead) {
            Row()
              .width(10)
              .height(10)
              .borderRadius(5)
              .backgroundColor(CommonStyles.DANGER)
              .margin({ top: -2, right: -2 })
          }
        }

        Column({ space: CommonStyles.XS }) {
          Row() {
            Text(notice.title)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontWeight(notice.isRead ? FontWeight.Normal : FontWeight.Medium)
              .fontColor(CommonStyles.TEXT_PRIMARY)
              .layoutWeight(1)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text(notice.createTime || '')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(CommonStyles.TEXT_TERTIARY)
          }
          .width('100%')

          Text(notice.content || '')
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(notice.isRead ? CommonStyles.TEXT_TERTIARY : CommonStyles.TEXT_SECONDARY)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')

          Row({ space: CommonStyles.SM }) {
            Text(this.getTypeLabel(notice.type))
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(CommonStyles.PRIMARY)
              .padding({ left: CommonStyles.SM, right: CommonStyles.SM, top: CommonStyles.XS, bottom: CommonStyles.XS })
              .backgroundColor(CommonStyles.PRIMARY_LIGHT)
              .borderRadius(CommonStyles.RADIUS_FULL)

            if (!notice.isRead) {
              Text('标记已读 ✓')
                .fontSize(CommonStyles.FONT_SIZE_SM)
                .fontColor(CommonStyles.SUCCESS)
                .onClick(() => {
                  this.markAsRead(notice.id);
                })
            }
          }
          .width('100%')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
    }
    .width('100%')
    .padding(CommonStyles.MD)
    .backgroundColor(notice.isRead ? CommonStyles.WHITE : CommonStyles.PRIMARY_BG)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(notice.isRead ? CommonStyles.SHADOW_NONE : CommonStyles.SHADOW_SM)
    .onClick(() => {
      this.viewNoticeDetail(notice);
    })
  }

  @Builder NoticeDetailDialog() {
    Stack({ alignContent: Alignment.Center }) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#00000080')
        .onClick(() => {
          this.showNoticeDialog = false;
        })

      Column({ space: CommonStyles.LG }) {
        Row() {
          Text('📢 公告详情')
            .fontSize(CommonStyles.FONT_SIZE_LG)
            .fontWeight(FontWeight.Medium)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .layoutWeight(1)

          Row() {
            Text('✕')
              .fontSize(CommonStyles.FONT_SIZE_LG)
              .fontColor(CommonStyles.TEXT_TERTIARY)
          }
          .width(CommonStyles.ICON_SIZE_TOUCH)
          .height(CommonStyles.ICON_SIZE_TOUCH)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.showNoticeDialog = false;
          })
        }
        .width('100%')

        Text(this.selectedNoticeTitle)
          .fontSize(CommonStyles.FONT_SIZE_XL)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .width('100%')

        Divider().color(CommonStyles.GRAY_200).width('100%')

        Scroll() {
          Text(this.selectedNoticeContent)
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .lineHeight(22)
            .width('100%')
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .height(300)
        .layoutWeight(1)

        Button('我知道了 👍', { type: ButtonType.Capsule })
          .width('100%')
          .height(CommonStyles.BUTTON_HEIGHT_LG)
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.WHITE)
          .backgroundColor(CommonStyles.PRIMARY)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .shadow(CommonStyles.SHADOW_BRAND_OLD)
          .onClick(() => {
            this.showNoticeDialog = false;
          })
      }
      .width('90%')
      .height('80%')
      .backgroundColor(CommonStyles.WHITE)
      .borderRadius(CommonStyles.RADIUS_XL)
      .shadow(CommonStyles.SHADOW_XL)
      .padding(CommonStyles.XL)
    }
    .width('100%')
    .height('100%')
    .position({ x: 0, y: 0 })
  }

  private getTypeIcon(type: string): string {
    const iconMap: Record<string, string> = {
      'system': '🔔',
      'activity': '🎉',
      'maintenance': '🔧',
      'important': '⚠️'
    };
    return iconMap[type] || '📋';
  }

  private getTypeLabel(type: string): string {
    const labelMap: Record<string, string> = {
      'system': '系统通知',
      'activity': '活动公告',
      'maintenance': '维护通知',
      'important': '重要公告'
    };
    return labelMap[type] || '其他';
  }

  private filterNotices() {
    if (this.selectedType === 'all') {
      this.notices = getNotices();
    } else {
      this.notices = getNotices().filter(notice => notice.type === this.selectedType);
    }
  }

  private markAsRead(noticeId: number) {
    const success = markNoticeAsRead(noticeId);

    if (success) {
      this.unreadCount = getUnreadNoticeCount();
      this.loadNotices();
      this.showToast('✅ 已标记为已读');
    } else {
      this.showToast('标记失败');
    }
  }

  private syncToStore(): void {
    const store = AppStore.getInstance();
    store.setNotices([...getNotices()]);
  }

  private markAllAsRead() {
    markAllNoticesAsRead();
    this.unreadCount = getUnreadNoticeCount();
    this.loadNotices();
    this.showToast('✅ 全部标记为已读');
  }

  private viewNoticeDetail(notice: Notice) {
    this.selectedNoticeTitle = notice.title;
    this.selectedNoticeContent = notice.content;
    this.showNoticeDialog = true;

    if (!notice.isRead) {
      this.markAsRead(notice.id);
    }
  }

  private showToast(message: string) {
    promptAction.showToast({
      message: message,
      duration: 2000
    });
  }
}
