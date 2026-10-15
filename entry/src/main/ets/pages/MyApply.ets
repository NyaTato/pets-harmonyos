import { RouterHelper, RouteParams } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { getUserApplies, getUserApplyStats, updateApplyStatus, Apply, ApplyStats } from '../mock/ApplyData';
import { AppStore } from '../store/AppStore';
import { promptAction } from '@kit.ArkUI';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

interface ApplyItemProps {
  apply: Apply;
}

@Entry
@Component
struct MyApply {
  @State private applies: Apply[] = [];
  @State private stats: ApplyStats | null = null;
  @State private selectedStatus: string = '全部';
  @State private isLoading: boolean = false;

  private statusOptions: Array<string> = ['全部', '待审核', '已通过', '已驳回', '已完成'];

  private getStatusColor(status: string): string {
    switch (status) {
      case '待审核': return CommonStyles.WARNING;
      case '已通过': return CommonStyles.SUCCESS;
      case '已驳回': return CommonStyles.DANGER;
      case '已完成': return CommonStyles.PRIMARY_DARK;
      default: return CommonStyles.TEXT_TERTIARY;
    }
  }

  private getStatusBgColor(status: string): string {
    switch (status) {
      case '待审核': return '#FEF3C7';
      case '已通过': return '#DCFCE7';
      case '已驳回': return '#FEE2E2';
      case '已完成': return '#E0E7FF';
      default: return CommonStyles.GRAY_100;
    }
  }

  private allApplies: Apply[] = [];

  aboutToAppear() {
    this.loadApplies();
  }

  loadApplies() {
    this.isLoading = true;

    const store = AppStore.getInstance();
    const state = store.getState();
    const currentUser = state.currentUser;

    if (!currentUser) {
      RouterHelper.replaceUrl("pages/Login");
      return;
    }

    setTimeout((): void => {
      this.allApplies = getUserApplies(currentUser.id);
      this.applies = this.allApplies;
      this.stats = getUserApplyStats(currentUser.id);
      this.isLoading = false;

      store.setApplies([...this.allApplies]);
    }, 500);
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top', 'bottom']
      }) {
        Column() {
          this.NavigationBar()

          Scroll() {
            Column({ space: CommonStyles.SPACE_XL }) {
              this.StatsCards()
              this.StatusFilter()
              this.ContentSection()
            }
            .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG, bottom: CommonStyles.SPACE_3XL })
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)
          .layoutWeight(1)
        }
        .width('100%')
        .height('100%')
        .backgroundColor(CommonStyles.COLOR_BG)
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: '45mm' })
  }

  @Builder NavigationBar() {
    Row() {
      BackButton()

      Text('我的申请')
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Row() {
        Text('🔄')
          .fontSize(CommonStyles.FONT_SIZE_MD)
      }
      .width(CommonStyles.ICON_SIZE_TOUCH)
      .height(CommonStyles.ICON_SIZE_TOUCH)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(CommonStyles.PRIMARY_LIGHT)
      .borderRadius(CommonStyles.RADIUS_FULL)
      .onClick(() => {
        this.loadApplies();
      })
    }
    .width('100%')
    .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG, top: CommonStyles.SPACE_SM, bottom: CommonStyles.SPACE_SM })
  }

  @Builder StatsCards() {
    Column({ space: CommonStyles.SPACE_MD }) {
      Row({ space: CommonStyles.SPACE_MD }) {
        // 统计值刻意不在调用处求值后传入：@Builder 普通参数按值拷贝，
        // 异步 loadApplies 回填 this.stats 后不会重建，统计卡会停留在 0。
        // 这里只传静态 statKey，数值在 StatCard 内部直接读 this.stats，保证刷新/取消重载后更新。
        this.StatCard('📋', '全部申请', 'total', CommonStyles.PRIMARY)

        this.StatCard('⏳', '待审核', 'pending', CommonStyles.WARNING)

        this.StatCard('✅', '已通过', 'approved', CommonStyles.SUCCESS)
      }

      Row({ space: CommonStyles.SPACE_MD }) {
        this.StatCard('❌', '已驳回', 'rejected', CommonStyles.DANGER)

        this.StatCard('🎉', '已完成', 'completed', CommonStyles.PRIMARY_DARK)
      }
    }
    .width('100%')
  }

  @Builder StatCard(emoji: string, label: string, statKey: string, color: string) {
    Column({ space: CommonStyles.SPACE_XS }) {
      Text(emoji)
        .fontSize(CommonStyles.FONT_SIZE_XL)

      // 直接绑定 @State stats：loadApplies 异步回填、手动刷新与取消申请重载都会触发重建。
      if (statKey === 'total') {
        Text((this.stats?.total || 0).toString())
          .fontSize(CommonStyles.FONT_SIZE_XL)
          .fontWeight(FontWeight.Bold)
          .fontColor(color)
      } else if (statKey === 'pending') {
        Text((this.stats?.pending || 0).toString())
          .fontSize(CommonStyles.FONT_SIZE_XL)
          .fontWeight(FontWeight.Bold)
          .fontColor(color)
      } else if (statKey === 'approved') {
        Text((this.stats?.approved || 0).toString())
          .fontSize(CommonStyles.FONT_SIZE_XL)
          .fontWeight(FontWeight.Bold)
          .fontColor(color)
      } else if (statKey === 'rejected') {
        Text((this.stats?.rejected || 0).toString())
          .fontSize(CommonStyles.FONT_SIZE_XL)
          .fontWeight(FontWeight.Bold)
          .fontColor(color)
      } else {
        Text((this.stats?.completed || 0).toString())
          .fontSize(CommonStyles.FONT_SIZE_XL)
          .fontWeight(FontWeight.Bold)
          .fontColor(color)
      }

      Text(label)
        .fontSize(CommonStyles.FONT_SIZE_SM)
        .fontColor(CommonStyles.TEXT_SECONDARY)
    }
    .width('100%')
    .height(CommonStyles.SIZE_2XL)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
  }

  @Builder StatusFilter() {
    Scroll() {
      Row({ space: CommonStyles.SM }) {
        ForEach(this.statusOptions, (status: string) => {
          Text(status)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontWeight(this.selectedStatus === status ? FontWeight.Medium : FontWeight.Normal)
            .fontColor(this.selectedStatus === status ? CommonStyles.WHITE : CommonStyles.TEXT_SECONDARY)
            .padding({ left: CommonStyles.MD, right: CommonStyles.MD, top: CommonStyles.SM, bottom: CommonStyles.SM })
            .backgroundColor(this.selectedStatus === status ? CommonStyles.PRIMARY : CommonStyles.GRAY_100)
            .borderRadius(CommonStyles.RADIUS_FULL)
            .onClick(() => {
              this.selectedStatus = status;
              this.filterApplies();
            })
        })
      }
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .width('100%')
  }

  @Builder ContentSection() {
    Column({ space: CommonStyles.SPACE_LG }) {
      this.LoadingContent()
      this.EmptyContent()
      this.ApplyList()
    }
    .width('100%')
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
        .margin({ top: CommonStyles.SPACE_MD })
    }
    .width('100%')
    .height(CommonStyles.SIZE_2XL)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .visibility(this.isLoading ? Visibility.Visible : Visibility.None)
  }

  @Builder EmptyContent() {
    Column() {
      Text('📭')
        .fontSize(64)

      Text('暂无申请记录')
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .margin({ top: CommonStyles.SPACE_LG })

      Text('快去领养一只宠物吧 🐾')
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .margin({ top: CommonStyles.SPACE_XS })

      Button('去领养 💝', { type: ButtonType.Capsule })
        .width(CommonStyles.BUTTON_WIDTH_LG)
        .height(CommonStyles.BUTTON_HEIGHT_LG)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.WHITE)
        .backgroundColor(CommonStyles.PRIMARY)
        .borderRadius(CommonStyles.RADIUS_FULL)
        .shadow(CommonStyles.SHADOW_BRAND_OLD)
        .margin({ top: CommonStyles.SPACE_XL })
        .onClick(() => {
          RouterHelper.pushUrl("pages/PetList");
        })
    }
    .width('100%')
    .height(CommonStyles.SIZE_2XL)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .visibility((!this.isLoading && this.applies.length === 0) ? Visibility.Visible : Visibility.None)
  }

  @Builder ApplyList() {
    Column({ space: CommonStyles.SPACE_LG }) {
      ForEach(this.applies, (apply: Apply) => {
        this.ApplyCard({ apply: apply })
      })
    }
    .width('100%')
    .visibility((!this.isLoading && this.applies.length > 0) ? Visibility.Visible : Visibility.None)
  }

  @Builder ApplyCard(props: ApplyItemProps) {
    Column({ space: CommonStyles.SPACE_MD }) {
      Row() {
        Column({ space: CommonStyles.XS }) {
          Text(props.apply.petName)
            .fontSize(CommonStyles.FONT_SIZE_LG)
            .fontWeight(FontWeight.Medium)
            .fontColor(CommonStyles.TEXT_PRIMARY)

          Text(`📅 ${props.apply.createTime || ''}`)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.TEXT_TERTIARY)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Text(props.apply.status)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.getStatusColor(props.apply.status))
          .padding({ left: CommonStyles.SM, right: CommonStyles.SM, top: CommonStyles.XS, bottom: CommonStyles.XS })
          .backgroundColor(this.getStatusBgColor(props.apply.status))
          .borderRadius(CommonStyles.RADIUS_FULL)
      }
      .width('100%')

      Divider().color(CommonStyles.GRAY_200).width('100%')

      Column({ space: CommonStyles.SM }) {
        this.InfoRow('📱', '联系方式', props.apply.phone || '-')
        this.InfoRow('💬', '申请理由', props.apply.reason || '未填写', 2)

        Row() {
          this.InfoRow('📝', '审核备注', props.apply.reviewNote || '', 2)
        }
        .visibility((props.apply.status !== '待审核' && props.apply.reviewNote) ? Visibility.Visible : Visibility.None)
      }
      .width('100%')

      Row({ space: CommonStyles.SM }) {
        Button('查看详情', { type: ButtonType.Normal })
          .height(CommonStyles.BUTTON_HEIGHT_SM)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.PRIMARY)
          .backgroundColor(CommonStyles.WHITE)
          .borderWidth(1.5)
          .borderColor(CommonStyles.PRIMARY)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .onClick(() => {
            this.viewApplyDetail(props.apply);
          })

        Button('取消申请', { type: ButtonType.Normal })
          .height(CommonStyles.BUTTON_HEIGHT_SM)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.DANGER)
          .backgroundColor(CommonStyles.WHITE)
          .borderWidth(1.5)
          .borderColor(CommonStyles.DANGER)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .onClick(() => {
            this.cancelApply(props.apply);
          })
          .visibility(props.apply.status === '待审核' ? Visibility.Visible : Visibility.None)

        Button('重新申请', { type: ButtonType.Capsule })
          .height(CommonStyles.BUTTON_HEIGHT_SM)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.WHITE)
          .backgroundColor(CommonStyles.PRIMARY)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .onClick(() => {
            this.reapply(props.apply);
          })
          .visibility(props.apply.status === '已驳回' ? Visibility.Visible : Visibility.None)

        Button('查看合同', { type: ButtonType.Normal })
          .height(CommonStyles.BUTTON_HEIGHT_SM)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.PRIMARY)
          .backgroundColor(CommonStyles.WHITE)
          .borderWidth(1.5)
          .borderColor(CommonStyles.PRIMARY)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .onClick(() => {
            const params: RouteParams = { applyId: props.apply.id.toString() };
            RouterHelper.pushUrl("pages/Contract", params);
          })
          .visibility(props.apply.status === '已通过' ? Visibility.Visible : Visibility.None)

        Button('联系领养', { type: ButtonType.Capsule })
          .height(CommonStyles.BUTTON_HEIGHT_SM)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.WHITE)
          .backgroundColor(CommonStyles.SUCCESS)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .onClick(() => {
            this.contactAdoption(props.apply);
          })
          .visibility(props.apply.status === '已通过' ? Visibility.Visible : Visibility.None)
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
    }
    .width('100%')
    .padding(CommonStyles.SPACE_LG)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  @Builder InfoRow(icon: string, label: string, value: string, maxLines?: number) {
    Row() {
      Text(`${icon} ${label}`)
        .fontSize(CommonStyles.FONT_SIZE_SM)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .width(90)

      Text(value)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)
        .maxLines(maxLines || 1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
  }

  private filterApplies() {
    if (this.selectedStatus === '全部') {
      this.applies = this.allApplies;
    } else {
      this.applies = this.allApplies.filter(
        apply => apply.status === this.selectedStatus
      );
    }
  }

  private contactAdoption(apply: Apply) {
    console.log('联系领养:', apply);
    promptAction.showToast({
      message: '📞 联系领养功能开发中',
      duration: 2000
    });

    setTimeout(() => {
      RouterHelper.pushUrl("pages/Messages");
    }, 1600);
  }

  private viewApplyDetail(apply: Apply) {
    promptAction.showDialog({
      title: '📋 申请详情',
      message: `🐾 宠物名称：${apply.petName}\n\n` +
        `📅 申请时间：${apply.createTime}\n\n` +
        `📊 申请状态：${apply.status}\n\n` +
        `👤 申请人：${apply.userName}\n\n` +
        `📱 联系方式：${apply.phone}\n\n` +
        `📍 居住地址：${apply.address}\n\n` +
        `✨ 养宠经验：${apply.experience}\n\n` +
        `💬 申请理由：${apply.reason || '无'}\n\n` +
        (apply.reviewer ? `👨‍💼 审核人：${apply.reviewer}\n` : '') +
        (apply.reviewTime ? `⏰ 审核时间：${apply.reviewTime}\n` : '') +
        (apply.reviewNote ? `📝 审核备注：${apply.reviewNote}` : ''),
      buttons: [
        { text: '关闭', color: CommonStyles.PRIMARY }
      ]
    });
  }

  private cancelApply(apply: Apply) {
    promptAction.showDialog({
      title: '⚠️ 确认取消',
      message: '确定要取消该领养申请吗？取消后无法恢复！',
      buttons: [
        { text: '取消', color: CommonStyles.TEXT_TERTIARY },
        { text: '确定', color: CommonStyles.DANGER }
      ]
    }).then((result: promptAction.ShowDialogSuccessResponse) => {
      if (result.index === 1) {
        const success = updateApplyStatus(apply.id, '已驳回', '系统', '用户主动取消申请');
        if (success) {
          promptAction.showToast({ message: '✅ 申请已取消', duration: 2000 });
          this.loadApplies();
        } else {
          promptAction.showToast({ message: '❌ 取消失败，请稍后重试', duration: 2000 });
        }
      }
    }).catch(() => {
      promptAction.showToast({ message: '操作已取消', duration: 2000 });
    });
  }

  private reapply(apply: Apply) {
    promptAction.showDialog({
      title: '🔄 重新申请',
      message: '确定要重新提交领养申请吗？',
      buttons: [
        { text: '取消', color: CommonStyles.TEXT_TERTIARY },
        { text: '确定', color: CommonStyles.PRIMARY }
      ]
    }).then((result: promptAction.ShowDialogSuccessResponse) => {
      if (result.index === 1) {
        const params: RouteParams = { petId: apply.petId.toString() };
        RouterHelper.pushUrl("pages/Apply", params);
      }
    }).catch(() => {
      promptAction.showToast({ message: '操作已取消', duration: 2000 });
    });
  }
}
