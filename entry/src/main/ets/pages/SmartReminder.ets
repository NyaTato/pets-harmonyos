import { CommonStyles } from '../common/css/CommonStyles';
import { RouterHelper } from '../router/RouterHelper';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';
import { promptAction } from '@kit.ArkUI';

interface ReminderItem {
  id: string;
  time?: string;
  title: string;
  petName: string;
  category: string;
  isCompleted: boolean;
  isOverdue: boolean;
  priority: 'high' | 'normal' | 'low';
  categoryIcon: string;
}

interface AISuggestion {
  id: string;
  icon: string;
  title: string;
  description: string;
  confidence: number;
  actionLabel: string;
}

@Entry
@Component
struct SmartReminder {
  @State private urgentItems: ReminderItem[] = [];
  @State private todayItems: ReminderItem[] = [];
  @State private weekItems: ReminderItem[] = [];
  @State private aiSuggestions: AISuggestion[] = [];

  aboutToAppear(): void {
    this.urgentItems = [
      {
        id: 'u1', time: '', title: '驱虫时间已过', petName: '豆豆',
        category: 'deworming', isCompleted: false, isOverdue: true,
        priority: 'high', categoryIcon: '💊'
      }
    ];

    this.todayItems = [
      { id: 't1', time: '08:00', title: '早餐喂食', petName: '小橘', category: 'feeding', isCompleted: true, isOverdue: false, priority: 'high', categoryIcon: '🍖' },
      { id: 't2', time: '09:30', title: '早晨遛弯', petName: '豆豆', category: 'walking', isCompleted: false, isOverdue: false, priority: 'normal', categoryIcon: '🚶' },
      { id: 't3', time: '12:00', title: '午餐喂食', petName: '小橘', category: 'feeding', isCompleted: false, isOverdue: false, priority: 'normal', categoryIcon: '🍖' },
      { id: 't4', time: '15:00', title: '洗澡美容', petName: '豆豆', category: 'grooming', isCompleted: false, isOverdue: false, priority: 'low', categoryIcon: '🛁️' },
      { id: 't5', time: '18:30', title: '晚餐喂食', petName: '小橘', category: 'feeding', isCompleted: false, isOverdue: false, priority: 'normal', categoryIcon: '🍖' },
      { id: 't6', time: '20:00', title: '晚间遛弯', petName: '豆豆', category: 'walking', isCompleted: false, isOverdue: false, priority: 'normal', categoryIcon: '🚶' }
    ];

    this.weekItems = [
      { id: 'w1', time: '周五', title: '定期驱虫', petName: '豆豆', category: 'deworming', isCompleted: false, isOverdue: false, priority: 'high', categoryIcon: '💊' },
      { id: 'w2', time: '下周一', title: '疫苗接种', petName: '豆豆', category: 'vaccine', isCompleted: false, isOverdue: false, priority: 'high', categoryIcon: '💉' },
      { id: 'w3', time: '下周一', title: '健康检查', petName: '豆豆', category: 'checkup', isCompleted: false, isOverdue: false, priority: 'normal', categoryIcon: '🏥' },
      { id: 'w4', time: '下周三', title: '指甲修剪', petName: '豆豆', category: 'nail_trim', isCompleted: false, isOverdue: false, priority: 'low', categoryIcon: '✂️' }
    ];

    this.aiSuggestions = [
      {
        id: 'a1', icon: '⏰', title: '行为洞察: 周末喂食时间式微调',
        description: '检测到您周末的喂食任务经常延迟或遗漏，建议调整周末的喂食时间，或使用自动喂食器辅助',
        confidence: 87, actionLabel: '优化喂食时间'
      },
      {
        id: 'a2', icon: '📊', title: '频率推荐: 增加遛弯频率',
        description: '豆豆近期活动量偏低，建议将遛弯从每周一次调整为每天一次，以便准确追踪其运动情况',
        confidence: 92, actionLabel: '立即调整'
      },
      {
        id: 'a3', icon: '🛁️', title: '护理计划: 距离上次洗澡已超30天',
        description: '根据洗澡记录显示已超过30天，猫咪一般每4-6周需要一次专业洗澡护理',
        confidence: 95, actionLabel: '预约洗澡'
      }
    ];
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        BackButton()
        Text('🔔 智能提醒系统')
          .fontSize(18).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
          .layoutWeight(1)
      }
      .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })
      .backgroundColor('#FFFFFF')

      // 可滚动内容区
      Scroll() {
        Column({ space: 16 }) {

          this.SummaryCard()

          if (this.urgentItems.length > 0) {
            this.UrgentSection()
          }

          this.TodaySection()

          this.WeekSection()

          this.AISuggestionSection()

          this.CrossModuleNav()

        }
        .width('100%').padding({ left: 16, right: 16, bottom: 32 })
      }
      .scrollable(ScrollDirection.Vertical).scrollBar(BarState.Off)
      .layoutWeight(1).backgroundColor('#F8FAFC')
    }
    .width('100%').height('100%')
    .backgroundColor('#F8FAFC')
    .padding({ top: '45mm' })
  }

  // ==================== 今日概览卡片 ====================
  @Builder
  SummaryCard() {
    Column({ space: 14 }) {
      Row() {
        Text('📋 今日概览')
          .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text(`${this.todayItems.filter(t => t.isCompleted).length}/${this.todayItems.length} 项`)
          .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .backgroundColor('#F1F5F9')
          .borderRadius(CommonStyles.RADIUS_FULL)
      }.width('100%')

      Row({ space: 10 }) {
        this.SummaryStat('待完成', `${this.todayItems.filter(t => !t.isCompleted).length}`, '#F59E0B')
        this.SummaryStat('已完成', `${this.todayItems.filter(t => t.isCompleted).length}`, '#10B981')
        this.SummaryStat('紧急', `${this.urgentItems.length}`, '#EF4444')
        this.SummaryStat('本周预览', `${this.weekItems.length}`, '#3B82F6')
      }

      Progress({
        value: (this.todayItems.filter(t => t.isCompleted).length / this.todayItems.length) * 100,
        total: 100,
        type: ProgressType.Linear
      }).width('100%').height(8)
        .color('#14B8A6')
        .backgroundColor('#E2E8F0')
        .borderRadius(4)

      if (this.urgentItems.length > 0) {
        Text(`⚠️ ${this.urgentItems.length}项需要立即处理`)
          .fontSize(13).fontWeight(FontWeight.Medium).fontColor('#EF4444')
          .width('100%').textAlign(TextAlign.Center)
      } else {
        Text('✅ 一切都在掌控之中！')
          .fontSize(13).fontWeight(FontWeight.Medium).fontColor('#10B981')
          .width('100%').textAlign(TextAlign.Center)
      }

      Row({ space: 8 }) {
        Text('下一项任务: ').fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
        Text(this.nextPendingTitle()).fontSize(11).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_SECONDARY)
        Blank()
        Text(this.nextPendingTime()).fontSize(11).fontColor('#14B8A6').fontWeight(FontWeight.Medium)
      }.width('100%')
    }
    .width('100%').padding(18)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .shadow({ color: 'rgba(20,184,166,0.08)', radius: 16, offsetX: 0, offsetY: 2 })
  }

  @Builder
  SummaryStat(label: string, value: string, color: string) {
    Column({ space: 4 }) {
      Text(value).fontSize(22).fontWeight(FontWeight.Bold).fontColor(color)
      Text(label).fontSize(10).fontColor(CommonStyles.TEXT_TERTIARY)
    }
    .layoutWeight(1)
    .padding(8)
    .backgroundColor(color + '0D')
    .borderRadius(12)
  }

  // ==================== 紧急事项 ====================
  @Builder
  UrgentSection() {
    Column({ space: 12 }) {
      Row() {
        Text('🚨 紧急事项')
          .fontSize(16).fontWeight(FontWeight.Bold).fontColor('#EF4444')
        Blank()
        Text(`${this.urgentItems.length}项`)
          .fontSize(11).fontColor('#EF4444').fontWeight(FontWeight.Medium)
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .backgroundColor('#FEF2F2')
          .borderRadius(6)
      }.width('100%')

      ForEach(this.urgentItems, (item: ReminderItem) => {
        this.UrgentCard(item)
      })
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({ color: 'rgba(239,68,68,0.08)', radius: 12, offsetX: 0, offsetY: 2 })
  }

  @Builder
  UrgentCard(item: ReminderItem) {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Text(item.categoryIcon).fontSize(22)
        Column({ space: 3 }) {
          Text(item.title).fontSize(15).fontWeight(FontWeight.Bold).fontColor('#991B1B')
          Text(`${item.petName} · 已超期2天 · 每季度一次`)
            .fontSize(12).fontColor('#DC2626')
        }
        .layoutWeight(1).alignItems(HorizontalAlign.Start)
      }
      .width('100%')

      Row({ space: 10 }) {
        Button('立即处理', { type: ButtonType.Capsule })
          .layoutWeight(1.5).height(38).fontSize(13)
          .fontColor('#FFFFFF').fontWeight(FontWeight.Bold)
          .backgroundColor('#EF4444')
          .borderRadius(10)
          .shadow({ color: 'rgba(239,68,68,0.25)', radius: 6, offsetX: 0, offsetY: 2 })
          .onClick(() => {
            item.isCompleted = true;
            this.urgentItems = this.urgentItems.filter((u: ReminderItem) => u.id !== item.id);
            promptAction.showToast({ message: `✅ 已完成 ${item.title}` });
          })

        Button('稍后提醒', { type: ButtonType.Capsule })
          .layoutWeight(1).height(38).fontSize(13)
          .fontColor(CommonStyles.TEXT_SECONDARY)
          .backgroundColor('#F1F5F9')
          .borderRadius(10)
          .onClick(() => promptAction.showToast({ message: '已设置稍后提醒' }))
      }
    }
    .width('100%').padding(14)
    .backgroundColor('#FEF2F2')
    .borderRadius(14)
    .border({ width: 1.5, color: '#FECACA', radius: 14 })
  }

  // ==================== 今日计划 ====================
  @Builder
  TodaySection() {
    Column({ space: 12 }) {
      Row() {
        Text('📅 今日计划')
          .fontSize(16).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text(`${this.todayItems.length}项`)
          .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .backgroundColor('#F1F5F9')
          .borderRadius(6)
      }.width('100%')

      ForEach(this.todayItems, (item: ReminderItem) => {
        this.TaskRow(item)
      })
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({ color: 'rgba(0,0,0,0.04)', radius: 8, offsetX: 0, offsetY: 1 })
  }

  @Builder
  TaskRow(item: ReminderItem) {
    Row({ space: 12 }) {
      Row({ space: 6 }) {
        if (item.isCompleted) {
          Text('✓').fontSize(14).fontWeight(FontWeight.Bold).fontColor('#10B981')
            .width(24).height(24)
            .backgroundColor('#ECFDF5')
            .borderRadius(12)
            .textAlign(TextAlign.Center)
        } else {
          Circle().width(18).height(18)
            .fill(item.priority === 'high' ? '#14B8A6' : item.priority === 'normal' ? '#94A3B8' : '#CBD5E1')
        }
        Text(item.time || '').fontSize(12).fontColor(
          item.isCompleted ? CommonStyles.TEXT_TERTIARY : item.priority === 'high' ? '#14B8A6' : CommonStyles.TEXT_TERTIARY
        ).width(42)
      }

      Column({ space: 2 }) {
        Text(item.title)
          .fontSize(14)
          .fontColor(item.isCompleted ? CommonStyles.TEXT_TERTIARY : CommonStyles.TEXT_PRIMARY)
          .decoration({ type: item.isCompleted ? TextDecorationType.LineThrough : TextDecorationType.None })

        Row({ space: 6 }) {
          Text(item.petName).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          Text('·').fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          Text(item.categoryIcon).fontSize(11)
        }
      }
      .layoutWeight(1).alignItems(HorizontalAlign.Start)

      if (!item.isCompleted) {
        Text(item.categoryIcon).fontSize(20)
      }
    }
    .width('100%').padding({ top: 10, bottom: 10, left: 12, right: 12 })
    .backgroundColor(item.isCompleted ? '#F8FAFC' : '#FFFFFF')
    .borderRadius(12)
    .opacity(item.isCompleted ? 0.7 : 1)
    .onClick(() => {
      if (!item.isCompleted) {
        item.isCompleted = true;
        promptAction.showToast({ message: `✓ ${item.title} 已完成` });
      }
    })
  }

  // ==================== 本周预览 ====================
  @Builder
  WeekSection() {
    Column({ space: 12 }) {
      Row() {
        Text('📆 本周预览')
          .fontSize(16).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text(`${this.weekItems.length}项`)
          .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .backgroundColor('#EFF6FF')
          .borderRadius(6)
      }.width('100%')

      ForEach(this.weekItems, (item: ReminderItem) => {
        Row({ space: 10 }) {
          Text(item.categoryIcon).fontSize(18)
            .width(34).height(34)
            .backgroundColor('#EFF6FF')
            .borderRadius(10)
            .textAlign(TextAlign.Center)

          Column({ space: 2 }) {
            Row() {
              Text(item.title).fontSize(14).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
              Blank()
              Text(item.time).fontSize(11).fontColor('#3B82F6').fontWeight(FontWeight.Medium)
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .backgroundColor('#EFF6FF')
                .borderRadius(6)
            }.width('100%')
            Text(`${item.petName} · ${item.priority === 'high' ? '重要' : '普通'}`)
              .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Start)
        }
        .width('100%').padding(10)
        .backgroundColor('#FFFFFF')
        .borderRadius(10)
        .shadow({ color: 'rgba(0,0,0,0.03)', radius: 4, offsetX: 0, offsetY: 1 })
      })
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({ color: 'rgba(59,130,246,0.05)', radius: 8, offsetX: 0, offsetY: 1 })
  }

  // ==================== AI 智能建议 ====================
  @Builder
  AISuggestionSection() {
    Column({ space: 14 }) {
      Row() {
        Text('🤖 AI 智能建议')
          .fontSize(16).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text('基于数据分析')
          .fontSize(10).fontColor('#14B8A6').fontWeight(FontWeight.Medium)
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .backgroundColor('#F0FDFA')
          .borderRadius(6)
      }.width('100%')

      ForEach(this.aiSuggestions, (sug: AISuggestion) => {
        Column({ space: 10 }) {
          Row({ space: 10 }) {
            Text(sug.icon).fontSize(22)
              .width(40).height(40)
              .backgroundColor(sug.confidence >= 90 ? '#ECFDF5' : '#F0FDFA')
              .borderRadius(12)
              .textAlign(TextAlign.Center)

            Column({ space: 3 }) {
              Text(sug.title).fontSize(14).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
              Text(sug.description)
                .fontSize(11).fontColor(CommonStyles.TEXT_SECONDARY).lineHeight(17)
            }
            .layoutWeight(1).alignItems(HorizontalAlign.Start)

            Column({ space: 2 }) {
              Text(`${sug.confidence}%`).fontSize(14).fontWeight(FontWeight.Bold)
                .fontColor(sug.confidence >= 90 ? '#10B981' : '#14B8A6')
              Text('置信度').fontSize(9).fontColor(CommonStyles.TEXT_TERTIARY)
            }
          }
          .width('100%')

          Row() {
            Text(sug.actionLabel)
              .fontSize(12).fontWeight(FontWeight.Medium).fontColor('#14B8A6')
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .backgroundColor('#F0FDFA')
              .borderRadius(8)
              .layoutWeight(1)

            Text('忽略')
              .fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .backgroundColor('#F1F5F9')
              .borderRadius(8)
              .layoutWeight(1)
          }
          .width('100%')
        }
        .width('100%').padding(14)
        .backgroundColor('#FFFFFF')
        .borderRadius(14)
        .border({ width: 1, style: BorderStyle.Dashed, color: '#CCFBF1', radius: 14 })
      })
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({ color: 'rgba(20,184,166,0.06)', radius: 8, offsetX: 0, offsetY: 1 })
  }

  // ==================== 跨模块导航 ====================
  @Builder
  CrossModuleNav() {
    Column({ space: 14 }) {
      Row() {
        Text('🔗 相关功能')
          .fontSize(16).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text('数据互通')
          .fontSize(10).fontColor('#6366F1').fontWeight(FontWeight.Medium)
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .backgroundColor('#EEF2FF')
          .borderRadius(6)
      }.width('100%')

      Row({ space: 10 }) {
        this.NavCard('📅', '护理日历', '查看完整日程表\n自动同步健康记录', '#3B82F6',
          () => RouterHelper.pushUrl("pages/Calendar"))
        this.NavCard('📈', '成长档案', '查看宠物成长记录\n智能健康追踪', '#10B981',
          () => RouterHelper.pushUrl("pages/PetGrowthProfile"))
        this.NavCard('🛡️', '走失预警', '实时守护安全\n定位追踪', '#F59E0B',
          () => RouterHelper.pushUrl("pages/PetLostWarning"))
      }
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({ color: 'rgba(99,102,241,0.05)', radius: 8, offsetX: 0, offsetY: 1 })
  }

  @Builder
  NavCard(icon: string, title: string, desc: string, accent: string, action: () => void) {
    Column({ space: 8 }) {
      Text(icon).fontSize(26)
      Text(title).fontSize(13).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
      Text(desc).fontSize(10).fontColor(CommonStyles.TEXT_TERTIARY).lineHeight(15).textAlign(TextAlign.Center)
    }
    .layoutWeight(1)
    .padding({ top: 16, bottom: 14 })
    .backgroundColor(accent + '0C')
    .borderRadius(14)
    .onClick(action)
  }

  // ==================== 流程导航 ====================
  @Builder
  DemoFlowNav(currentStep: number, prevRoute: string, nextRoute: string) {
    Column({ space: CommonStyles.MD }) {
      Row({ space: CommonStyles.SM }) {
        this.StepIndicator(1, 'AI推荐', currentStep >= 1, '#14B8A6')
        this.StepConnector(currentStep >= 2)
        this.StepIndicator(2, '智能提醒', currentStep >= 2, '#6366F1')
        this.StepConnector(currentStep >= 3)
        this.StepIndicator(3, '护理日历', currentStep >= 3, '#10B981')
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)

      Row({ space: CommonStyles.SM }) {
        Button(`← AI推荐`, { type: ButtonType.Capsule })
          .layoutWeight(1).height(44).fontSize(13)
          .fontWeight(FontWeight.Medium).fontColor('#14B8A6')
          .backgroundColor('#F0FDFA').borderRadius(CommonStyles.RADIUS_LG)
          .onClick(() => RouterHelper.pushUrl(prevRoute))

        Button(`护理日历 →`, { type: ButtonType.Capsule })
          .layoutWeight(1).height(44).fontSize(13)
          .fontWeight(FontWeight.Medium).fontColor('#FFFFFF')
          .backgroundColor('#10B981')
          .borderRadius(CommonStyles.RADIUS_LG)
          .shadow({ radius: 10, color: 'rgba(16,185,129,0.35)', offsetX: 0, offsetY: 3 })
          .onClick(() => RouterHelper.pushUrl(nextRoute))
      }
      .width('100%')

      Text('演示流程: Choose with AI → Manage with Smart Reminder → Track with Calendar')
        .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
    }
  }

  // ==================== 辅助方法 ====================

  @Builder
  StepIndicator(stepNum: number, label: string, isActive: boolean, activeColor: string) {
    Column({ space: 4 }) {
      Text(`${stepNum}`)
        .fontSize(14).fontWeight(FontWeight.Bold)
        .fontColor(isActive ? '#FFFFFF' : CommonStyles.TEXT_TERTIARY)
        .width(28).height(28)
        .backgroundColor(isActive ? activeColor : '#F1F5F9')
        .borderRadius(14)
        .textAlign(TextAlign.Center)
      Text(label).fontSize(9).fontColor(isActive ? activeColor : CommonStyles.TEXT_TERTIARY)
    }
  }

  @Builder
  StepConnector(isActive: boolean) {
    Row().width(24).height(3)
      .backgroundColor(isActive ? '#14B8A6' : '#E2E8F0')
      .borderRadius(2)
  }

  // ==================== 辅助函数 ====================

  private nextPendingTitle(): string {
    const pending: ReminderItem | undefined = this.todayItems.find((t: ReminderItem) => !t.isCompleted);
    return pending?.title || '无';
  }

  private nextPendingTime(): string {
    const pending: ReminderItem | undefined = this.todayItems.find((t: ReminderItem) => !t.isCompleted);
    return pending?.time || '';
  }
}
