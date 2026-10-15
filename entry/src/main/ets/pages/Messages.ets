import { CommonStyles } from '../common/css/CommonStyles';
import { RouterHelper } from '../router/RouterHelper';
import { AppStore } from '../store/AppStore';
import { noticeList, Notice } from '../mock/NoticeData';
import { promptAction } from '@kit.ArkUI';
import { BackButton } from '../components/BackButton';
import { SafeArea } from '../components/SafeArea';

interface MessageCategory {
  id: string;
  name: string;
  count: number;
}

@Entry
@Component
export struct Messages {
  @State private selectedTab: string = 'all';
  @State private messages: Notice[] = [];
  @State private unreadCount: number = 0;

  private categories: MessageCategory[] = [
    { id: 'all', name: '全部消息', count: 0 },
    { id: '系统', name: '系统通知', count: 0 },
    { id: '活动', name: '活动消息', count: 0 },
    { id: '维护', name: '维护通知', count: 0 },
    { id: '重要', name: '重要消息', count: 0 }
  ];

  aboutToAppear(): void {
    this.loadMessages();
  }

  onPageShow(): void {
    this.refreshFromStore();
  }

  private refreshFromStore(): void {
    const store = AppStore.getInstance();
    const state = store.getState();
    this.messages = [...state.notices];
    this.unreadCount = state.notices.filter((n: Notice) => !n.isRead).length;
    this.updateCategoryCounts();
  }

  private loadMessages(): void {
    const store = AppStore.getInstance();
    const state = store.getState();

    if (state.notices && state.notices.length > 0) {
      this.messages = [...state.notices];
    } else {
      store.setNotices([...noticeList]);
      this.messages = [...noticeList];
    }

    this.unreadCount = this.messages.filter((m: Notice) => !m.isRead).length;
    this.updateCategoryCounts();
  }

  private updateCategoryCounts(): void {
    const allMessages = this.getFilteredMessages('all');
    this.categories[0].count = allMessages.length;

    for (const cat of this.categories) {
      if (cat.id !== 'all') {
        cat.count = this.messages.filter((m: Notice) => m.type === cat.id).length;
      }
    }
  }

  private getFilteredMessages(categoryId: string): Notice[] {
    if (categoryId === 'all') {
      return this.messages;
    }
    return this.messages.filter((m: Notice) => m.type === categoryId);
  }

  private selectTab(id: string): void {
    this.selectedTab = id;
  }

  private viewMessageDetail(message: Notice): void {
    if (!message.isRead) {
      message.isRead = true;
      this.syncToStore();

      this.unreadCount = this.messages.filter((m: Notice) => !m.isRead).length;
      this.updateCategoryCounts();
    }

    RouterHelper.pushUrl("pages/Notice");
  }

  private markAllAsRead(): void {
    let changed: boolean = false;

    for (const msg of this.messages) {
      if (!msg.isRead) {
        msg.isRead = true;
        changed = true;
      }
    }

    if (changed) {
      this.syncToStore();
    }

    this.unreadCount = 0;
    this.updateCategoryCounts();

    promptAction.showToast({ message: '已全部标记为已读' });
  }

  private syncToStore(): void {
    const store = AppStore.getInstance();
    store.setNotices([...this.messages]);
  }

  build() {
    Column() {
      SafeArea({ edges: ['top'] }) {
        // ===== 顶部导航栏 =====
        Row({ space: CommonStyles.SPACE_MD }) {
          BackButton()

          Text('消息中心')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.TEXT_PRIMARY)

          Blank()

          if (this.unreadCount > 0) {
            Text(`${this.unreadCount}条未读`)
              .fontSize(13)
              .fontColor(CommonStyles.PRIMARY)
              .fontWeight(FontWeight.Medium)
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .backgroundColor(CommonStyles.PRIMARY + '15')
              .borderRadius(CommonStyles.RADIUS_FULL)
              .onClick(() => {
                this.markAllAsRead();
              })
          }
        }
        .width('100%')
        .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG, top: 16, bottom: 16 })
        .backgroundColor('#FFFFFF')

        // ===== 消息分类标签栏 =====
        Scroll() {
          Row({ space: 8 }) {
            ForEach(this.categories, (category: MessageCategory) => {
              Column() {
                Text(category.name)
                  .fontSize(13)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.selectedTab === category.id ? '#FFFFFF' : CommonStyles.TEXT_SECONDARY)

                if (this.selectedTab !== category.id && category.count > 0) {
                  Text(`${category.count}`)
                    .fontSize(11)
                    .fontColor(this.selectedTab === category.id ? '#FFFFFF' : CommonStyles.DANGER)
                    .position({ x: '50%', y: -2 })
                }
              }
              .padding({ left: 18, right: 18, top: 9, bottom: 9 })
              .borderRadius(CommonStyles.RADIUS_FULL)
              .backgroundColor(this.selectedTab === category.id ? CommonStyles.PRIMARY : '#F1F5F9')
              .onClick(() => {
                this.selectTab(category.id);
              })
            })
          }
          .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG })
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .width('100%')

        // ===== 消息列表 =====
        Scroll() {
          Column({ space: 12 }) {
            ForEach(this.getFilteredMessages(this.selectedTab), (message: Notice) => {
              this.MessageCard(message)
            }, (message: Notice) => message.id.toString())
          }
          .width('100%')
          .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG, top: 16, bottom: 24 })
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .layoutWeight(1)

        if (this.getFilteredMessages(this.selectedTab).length === 0) {
          Column({ space: 20 }) {
              Text('📭')
                .fontSize(32)
                .fontColor(CommonStyles.TEXT_TERTIARY)

            Text('暂无消息')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(CommonStyles.TEXT_PRIMARY)

            Text('有新消息时会在这里显示')
              .fontSize(14)
              .fontColor(CommonStyles.TEXT_TERTIARY)
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(CommonStyles.BG_LIGHT)
    .padding({ top: '45mm' })
  }

  @Builder
  MessageCard(message: Notice) {
    Row({ space: 12 }) {
      Text(this.getTypeIcon(message.type))
        .fontSize(22)

      Column({ space: 6 }) {
        Text(message.title || '消息标题')
          .fontSize(16)
          .fontWeight(message.isRead ? FontWeight.Normal : FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(message.content || '消息内容摘要...')
          .fontSize(14)
          .fontColor(CommonStyles.TEXT_SECONDARY)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Row({ space: 8 }) {
          Text(message.createTime || '')
            .fontSize(12)
            .fontColor(CommonStyles.TEXT_TERTIARY)

          if (!message.isRead) {
            Text('未读')
              .fontSize(11)
              .fontColor(CommonStyles.PRIMARY)
              .fontWeight(FontWeight.Medium)
              .padding({ left: 6, right: 6, top: 3, bottom: 3 })
              .backgroundColor(CommonStyles.PRIMARY + '15')
              .borderRadius(CommonStyles.RADIUS_FULL)
          }
        }
        .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      if (!message.isRead) {
        Circle()
          .width(10)
          .height(10)
          .fill(CommonStyles.DANGER)
      }

      Text('›')
        .fontSize(22)
        .fontColor(CommonStyles.TEXT_TERTIARY)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_MD)
    .shadow(CommonStyles.SHADOW_SM)
    .onClick(() => {
      this.viewMessageDetail(message);
    })
  }

  private getTypeIcon(type: string): string {
    switch (type) {
      case '系统':
        return '⚙️';
      case '活动':
        return '🎉';
      case '维护':
        return '🔧';
      case '重要':
        return '⚠️';
      default:
        return '📌';
    }
  }

  private getTypeColor(type: string): string {
    switch (type) {
      case '系统':
        return '#6366F1';
      case '活动':
        return '#F59E0B';
      case '维护':
        return '#EF4444';
      case '重要':
        return '#EF4444';
      default:
        return '#6B7280';
    }
  }
}
