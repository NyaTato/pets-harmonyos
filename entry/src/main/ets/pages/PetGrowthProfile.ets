import { CommonStyles } from '../common/css/CommonStyles';
import { RouterHelper } from '../router/RouterHelper';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';
import { petList, Pet } from '../mock/PetData';
import { promptAction } from '@kit.ArkUI';

type TabKey = 'timeline' | 'health' | 'vaccine' | 'weight' | 'care' | 'album';

interface TimelineEvent {
  date: string;
  icon: string;
  title: string;
  desc?: string;
  type: string;
}

interface HealthRecord {
  date: string;
  title: string;
  result: string;
  status: 'normal' | 'attention' | 'resolved';
}

interface VaccineRecord {
  name: string;
  date: string;
  nextDue?: string;
  isCompleted: boolean;
}

interface WeightRecord {
  date: string;
  weight: number;
}

interface CareLog {
  date: string;
  type: string;
  icon: string;
  note: string;
}

interface TabItem {
  key: TabKey;
  label: string;
  icon: string;
}

@Entry
@Component
struct PetGrowthProfile {
  @State private currentTab: TabKey = 'timeline';
  @State private selectedPetId: number = 1;

  private get pet(): Pet | undefined {
    return petList.find((p: Pet) => p.id === this.selectedPetId);
  }

  private readonly tabs: TabItem[] = [
    { key: 'timeline', label: '时间线', icon: '📅' },
    { key: 'health', label: '健康', icon: '🏥' },
    { key: 'vaccine', label: '疫苗', icon: '💉' },
    { key: 'weight', label: '体重', icon: '⚖️' },
    { key: 'care', label: '护理', icon: '📝' },
    { key: 'album', label: '相册', icon: '📷' }
  ];

  // 模拟数据
  private readonly timelineEvents: TimelineEvent[] = [
    { date: '2026-01-15', icon: '🎂', title: '2岁生日！', desc: '庆祝照片 x5', type: 'milestone' },
    { date: '2026-01-10', icon: '⚖️', title: '体重4.8kg', desc: '达到成年期标准', type: 'weight' },
    { date: '2025-12-25', icon: '🎄', title: '第一个圣诞节', desc: '收到猫爬架礼物', type: 'memory' },
    { date: '2025-11-15', icon: '🏥', title: '年度体检', desc: '结论: 非常健康', type: 'health_check' },
    { date: '2025-08-20', icon: '💊', title: '皮肤过敏治疗', desc: '已痊愈', type: 'illness' },
    { date: '2025-06-15', icon: '💉', title: '狂犬疫苗接种', desc: '', type: 'vaccine' },
    { date: '2025-03-20', icon: '🏠', title: '加入我们的家庭', desc: '领养日！永远铭记', type: 'adoption' },
    { date: '2025-01-15', icon: '🎂', title: '1岁生日', desc: '', type: 'milestone' }
  ];

  private readonly healthRecords: HealthRecord[] = [
    { date: '2026-01-10', title: '体重检查', result: '4.8kg (+0.3kg)，正常范围', status: 'normal' },
    { date: '2025-11-15', title: '年度体检', result: '各项指标优秀，建议保持现有饮食', status: 'normal' },
    { date: '2025-08-20', title: '皮肤过敏治疗', result: '局部红肿瘙痒，药膏+口服药，已痊愈', status: 'resolved' }
  ];

  private readonly vaccineRecords: VaccineRecord[] = [
    { name: '猫三联(第一针)', date: '2024-04-10', isCompleted: true },
    { name: '猫三联(第二针)', date: '2024-05-10', isCompleted: true },
    { name: '猫三联(第三针)', date: '2024-06-10', isCompleted: true },
    { name: '狂犬疫苗', date: '2025-07-10', nextDue: '2026-07-10', isCompleted: true },
    { name: '体内驱虫 (加强)', date: '', nextDue: '预计2026-02-15', isCompleted: false }
  ];

  private readonly weightRecords: WeightRecord[] = [
    { date: '2026-01', weight: 4.8 },
    { date: '2025-12', weight: 4.5 },
    { date: '2025-09', weight: 4.2 },
    { date: '2025-06', weight: 3.8 },
    { date: '2025-03', weight: 3.2 },
    { date: '2025-01', weight: 2.5 },
    { date: '2024-06', weight: 1.2 },
    { date: '2024-03', weight: 0.6 }
  ];

  private readonly careLogs: CareLog[] = [
    { date: '今天 14:30', type: 'feeding', icon: '🍖', note: '午餐 猫粮30g' },
    { date: '昨天 20:00', type: 'feeding', icon: '🍖', note: '晚餐 猫粮+罐头' },
    { date: '3天前', type: 'grooming', icon: '🛁', note: '洗澡 香波沐浴' },
    { date: '7天前', type: 'deworming', icon: '🐛', note: '驱虫 内驱' },
    { date: '14天前', type: 'nail_trim', icon: '✂️', note: '剪指甲' }
  ];

  build() {
    Column() {
      SafeArea({ edges: ['top'] }) {
        Row() {
          BackButton()
          Text('📋 宠物成长档案')
            .fontSize(18).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
            .layoutWeight(1)
        }
        .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })
        .backgroundColor('#FFFFFF')

        Scroll() {
          Column({ space: 18 }) {

            if (this.pet) {
              this.PetProfileCard()
              this.TabBar()
            }

            if (this.currentTab === 'timeline') {
              this.TimelineTab();
            } else if (this.currentTab === 'health') {
              this.HealthTab();
            } else if (this.currentTab === 'vaccine') {
              this.VaccineTab();
            } else if (this.currentTab === 'weight') {
              this.WeightTab();
            } else if (this.currentTab === 'care') {
              this.CareTab();
            } else if (this.currentTab === 'album') {
              this.AlbumTab();
            }

          }
          .width('100%').padding({ left: 16, right: 16, bottom: 32 })
        }
        .scrollable(ScrollDirection.Vertical).scrollBar(BarState.Off)
        .layoutWeight(1).backgroundColor('#F8FAFC')
      }
    }
    .width('100%').height('100%')
    .padding({ top: '45mm' })
  }

  // ==================== 宠物名片卡片 ====================
  @Builder
  PetProfileCard() {
    Column({ space: 12 }) {
      Row({ space: 14 }) {
        Stack({ alignContent: Alignment.BottomEnd }) {
          Image(this.pet!.images && this.pet!.images.length > 0 ? $rawfile(this.pet!.images[0]) : '')
            .width(80).height(80).objectFit(ImageFit.Cover)
            .borderRadius(50)

          Stack({ alignContent: Alignment.Center })
            .width(22).height(22)
            .borderRadius(11)
            .backgroundColor('#FFFFFF')
            .shadow({ color: 'rgba(0,0,0,0.1)', radius: 4, offsetX: 0, offsetY: 1 })
            .position({ x: 54, y: 54 })
          Text('🟢').fontSize(10)
        }

        Column({ space: 4 }) {
          Text(this.pet!.name)
            .fontSize(20).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)

          Text(`${this.pet!.breed} · ${this.pet!.age}岁${this.pet!.age! > 1 ? `${this.pet!.age}个月` : ''} · ${this.pet!.gender === 'male' ? '♂公' : '♀母'} · ${this.pet!.weight || '?'}kg`)
            .fontSize(13).fontColor(CommonStyles.TEXT_SECONDARY)

          Row({ space: 8 }) {
            Text(`💚 ${this.pet!.healthStatus === 'excellent' ? '健康状况良好' : '需要关注'}`)
              .fontSize(11).fontWeight(FontWeight.Medium)
              .fontColor('#10B981')
              .padding({ left: 7, right: 7, top: 2, bottom: 2 })
              .backgroundColor('#ECFDF5')
              .borderRadius(6)

            Text(`${this.pet!.vaccines.length > 0 ? '💉已免疫' : '💉待接种'}`)
              .fontSize(11).fontWeight(FontWeight.Medium)
              .fontColor('#3B82F6')
              .padding({ left: 7, right: 7, top: 2, bottom: 2 })
              .backgroundColor('#EFF6FF')
              .borderRadius(6)

            Text(`⚖️ ${this.pet!.weight || '?'}kg`)
              .fontSize(11).fontWeight(FontWeight.Medium)
              .fontColor('#F59E0B')
              .padding({ left: 7, right: 7, top: 2, bottom: 2 })
              .backgroundColor('#FFFBEB')
              .borderRadius(6)
          }
        }
        .layoutWeight(1).alignItems(HorizontalAlign.Start)
      }

      Divider().color('#F1F5F9')

      Row({ space: 16 }) {
        this.ProfileStat('🏠 入住家庭', '486天')
        this.ProfileStat('🎂 下次生日', '23天后')
        this.ProfileStat('⬆️ 今年增重', '+0.6kg')
      }
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .shadow({ color: 'rgba(16,185,129,0.08)', radius: 16, offsetX: 0, offsetY: 2 })
  }

  @Builder
  ProfileStat(icon: string, value: string) {
    Column({ space: 3 }) {
      Text(value).fontSize(13).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
      Text(icon).fontSize(10).fontColor(CommonStyles.TEXT_TERTIARY)
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
  }

  // ==================== Tab 导航 ====================
  @Builder
  TabBar() {
    Scroll() {
      Row({ space: 6 }) {
        ForEach(this.tabs, (tab: TabItem) => {
          Column({ space: 3 }) {
            Text(tab.icon).fontSize(14)
            Text(tab.label)
              .fontSize(10).fontWeight(this.currentTab === tab.key ? FontWeight.Bold : FontWeight.Regular)
              .fontColor(this.currentTab === tab.key ? '#10B981' : '#94A3B8')
          }
          .padding({ left: 10, right: 10, top: 7, bottom: 7 })
          .backgroundColor(this.currentTab === tab.key ? '#ECFDF5' : 'transparent')
          .borderRadius(10)
          .onClick(() => { this.currentTab = tab.key; })
        })
      }
      .padding(4)
    }
    .width('100%')
  }

  // ==================== Tab: 时间线（核心视觉展示） ====================
  @Builder
  TimelineTab() {
    Column({ space: 14 }) {
      Row() {
        Text('📅 成长时间线')
          .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text(`${this.timelineEvents.length}个里程碑`)
          .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .backgroundColor('#F1F5F9')
          .borderRadius(CommonStyles.RADIUS_FULL)
      }.width('100%')

      Column({ space: 0 }) {
        ForEach(this.timelineEvents, (event: TimelineEvent, index: number) => {
          Row({ space: 12 }) {
            Column({ space: 0 }) {
              Stack({ alignContent: Alignment.Center }) {
                Circle().width(36).height(36).fill('#ECFDF5')
                Text(event.icon).fontSize(16)
              }
              if (index < this.timelineEvents.length - 1) {
                Column().width(2).height(32).backgroundColor('#D1FAE5')
                  .margin({ top: 2 })
              }
            }.width(40)

            Column({ space: 4 }) {
              Text(event.date).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
              Row() {
                Text(event.title).fontSize(14).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
                Blank()
                if (event.type === 'milestone') {
                  Text('🌟').fontSize(12)
                } else if (event.type === 'adoption') {
                  Text('❤️').fontSize(12)
                }
              }.width('100%')
              if (event.desc) {
                Text(event.desc).fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
              }
            }
            .layoutWeight(1).alignItems(HorizontalAlign.Start)
          }
          .width('100%').padding({ bottom: 14 })
        })
      }
      .width('100%').padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow({ color: 'rgba(0,0,0,0.04)', radius: 8, offsetX: 0, offsetY: 1 })

      Button('记录此刻（演示）', { type: ButtonType.Capsule })
        .height(38).fontSize(13)
        .fontColor('#10B981').fontWeight(FontWeight.Medium)
        .backgroundColor('#ECFDF5')
        .borderRadius(10)
        .margin({ top: 4 })
        .onClick(() => promptAction.showToast({ message: '演示功能：暂不支持新增记录' }))
    }
  }

  // ==================== Tab: 健康档案 ====================
  @Builder
  HealthTab() {
    Column({ space: 14 }) {
      Row() {
        Text('🏥 健康档案')
          .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text('状态: 良好')
          .fontSize(11).fontWeight(FontWeight.Medium).fontColor('#10B981')
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .backgroundColor('#ECFDF5')
          .borderRadius(6)
      }.width('100%')

      ForEach(this.healthRecords, (record: HealthRecord) => {
        Row({ space: 10 }) {
          Stack({ alignContent: Alignment.Center }) {
            Circle().width(34).height(34)
              .fill(record.status === 'normal' ? '#ECFDF5' : record.status === 'resolved' ? '#FEF3C7' : '#FEE2E2')
            Text(record.status === 'normal' ? '✅' : record.status === 'resolved' ? '⚠️' : '❌').fontSize(14)
              .fontColor(record.status === 'normal' ? '#10B981' : record.status === 'resolved' ? '#F59E0B' : '#EF4444')
          }

          Column({ space: 3 }) {
            Row() {
              Text(record.title).fontSize(14).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
              Blank()
              Text(record.date).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
            }.width('100%')
            Text(record.result).fontSize(12).fontColor(CommonStyles.TEXT_SECONDARY).lineHeight(17)
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Start)
        }
        .width('100%').padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .shadow({ color: 'rgba(0,0,0,0.03)', radius: 6, offsetX: 0, offsetY: 1 })
      })

      Button('添加健康记录（演示）', { type: ButtonType.Capsule })
        .width('100%').height(38).fontSize(13)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .backgroundColor('#F1F5F9')
        .borderRadius(10)
        .margin({ top: 4 })
        .onClick(() => promptAction.showToast({ message: '演示功能：暂不支持新增健康记录' }))
    }
  }

  // ==================== Tab: 疫苗接种 ====================
  @Builder
  VaccineTab() {
    Column({ space: 14 }) {
      Row() {
        Text('💉 疫苗接种记录')
          .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text(`${this.vaccineRecords.filter(v => v.isCompleted).length}/${this.vaccineRecords.length} 已完成`)
          .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .backgroundColor('#F1F5F9')
          .borderRadius(CommonStyles.RADIUS_FULL)
      }.width('100%')

      Column({ space: 10 }) {
        Progress({
          value: Math.round((this.vaccineRecords.filter(v => v.isCompleted).length / this.vaccineRecords.length) * 100),
          total: 100,
          type: ProgressType.Ring
        }).width(70).height(70)
          .color('#10B981')
          .backgroundColor('#D1FAE5')
          .style({ strokeWidth: 7 })

        Text('接种完成率').fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
      }
      .width('100%').alignItems(HorizontalAlign.Center)
      .margin({ bottom: 8 })

      ForEach(this.vaccineRecords, (record: VaccineRecord) => {
        Row({ space: 12 }) {
          Stack({ alignContent: Alignment.Center }) {
            Circle().width(32).height(32)
              .fill(record.isCompleted ? '#ECFDF5' : '#FFFBEB')
            Text(record.isCompleted ? '✅' : '⏳').fontSize(14)
              .fontColor(record.isCompleted ? '#10B981' : '#F59E0B')
          }

          Column({ space: 3 }) {
            Row() {
              Text(record.name).fontSize(14).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
              Blank()
              if (record.nextDue && !record.isCompleted) {
                Text(`⏰ ${record.nextDue}`).fontSize(10).fontColor('#F59E0B').fontWeight(FontWeight.Medium)
              }
            }.width('100%')
            if (record.date) {
              Text(`接种日期: ${record.date}`).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
            } else if (record.nextDue) {
              Text(`预计: ${record.nextDue}`).fontSize(11).fontColor('#F59E0B')
            }
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Start)
        }
        .width('100%').padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .shadow({ color: 'rgba(0,0,0,0.03)', radius: 6, offsetX: 0, offsetY: 1 })
      })
    }
  }

  // ==================== Tab: 体重曲线 ====================
  @Builder
  WeightTab() {
    Column({ space: 14 }) {
      Row() {
        Text('⚖️ 生长发育曲线')
          .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text('成年期')
          .fontSize(11).fontWeight(FontWeight.Medium).fontColor('#10B981')
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .backgroundColor('#ECFDF5')
          .borderRadius(6)
      }.width('100%')

      Column({ space: 8 }) {
        Row({ space: 8 }) {
          Text('当前体重').fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
          Blank()
          Text(`${this.weightRecords[0].weight} kg`).fontSize(24).fontWeight(FontWeight.Bold).fontColor('#10B981')
        }
        .width('100%')

        Row({ space: 8 }) {
          Text('较上月').fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
          Blank()
          Text(`+${(this.weightRecords[0].weight - this.weightRecords[1].weight).toFixed(1)}kg ↗`)
            .fontSize(13).fontWeight(FontWeight.Bold).fontColor('#10B981')
        }
        .width('100%')

        Text('标准范围: 4.0-5.5kg ✓ 正常')
          .fontSize(11).fontColor('#10B981').fontWeight(FontWeight.Medium)
          .width('100%').textAlign(TextAlign.End)
      }
      .width('100%').padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow({ color: 'rgba(0,0,0,0.04)', radius: 8, offsetX: 0, offsetY: 1 })

      Column({ space: 8 }) {
        Text('体重历史').fontSize(14).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
          .width('100%')

        ForEach(this.weightRecords.slice().reverse(), (wr: WeightRecord) => {
          Row() {
            Text(wr.date).fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY).width(70)
            Blank()
            Row() {
              Text(`${wr.weight}`).fontSize(13).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
              Text(' kg').fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
            }
            Blank()
            Progress({
              value: wr.weight * 15,
              total: 75,
              type: ProgressType.Linear
            }).width(80).height(6)
              .color('#10B981')
              .backgroundColor('#D1FAE5')
              .borderRadius(3)
          }
          .width('100%').padding(8)
          .backgroundColor('#FAFAFA')
          .borderRadius(8)
        })
      }
      .width('100%').padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow({ color: 'rgba(0,0,0,0.04)', radius: 8, offsetX: 0, offsetY: 1 })

      Button('记录今日体重（演示）', { type: ButtonType.Capsule })
        .width('100%').height(38).fontSize(13)
        .fontColor('#10B981').fontWeight(FontWeight.Medium)
        .backgroundColor('#ECFDF5')
        .borderRadius(10)
        .margin({ top: 4 })
        .onClick(() => promptAction.showToast({ message: '演示功能：暂不支持记录体重' }))
    }
  }

  // ==================== Tab: 护理日志 ====================
  @Builder
  CareTab() {
    Column({ space: 14 }) {
      Row() {
        Text('📝 护理日志')
          .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text(`${this.careLogs.length}条记录`)
          .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .backgroundColor('#F1F5F9')
          .borderRadius(CommonStyles.RADIUS_FULL)
      }.width('100%')

      ForEach(this.careLogs, (log: CareLog) => {
        Row({ space: 10 }) {
          Text(log.icon).fontSize(20)
            .width(36).height(36)
            .backgroundColor('#EFF6FF')
            .borderRadius(10)
            .textAlign(TextAlign.Center)

          Column({ space: 2 }) {
            Row() {
              Text(log.note.split(' ')[0] || log.type).fontSize(13).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
              Blank()
              Text(log.date).fontSize(10).fontColor(CommonStyles.TEXT_TERTIARY)
            }.width('100%')
            Text(log.note).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Start)
        }
        .width('100%').padding(10)
        .backgroundColor('#FFFFFF')
        .borderRadius(10)
        .shadow({ color: 'rgba(0,0,0,0.03)', radius: 4, offsetX: 0, offsetY: 1 })
      })

      Button('记录护理事项（演示）', { type: ButtonType.Capsule })
        .width('100%').height(38).fontSize(13)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .backgroundColor('#F1F5F9')
        .borderRadius(10)
        .margin({ top: 4 })
        .onClick(() => promptAction.showToast({ message: '演示功能：暂不支持新增护理记录' }))
    }
  }

  // ==================== Tab: 纪念相册 ====================
  @Builder
  AlbumTab() {
    Column({ space: 14 }) {
      Row() {
        Text('📷 成长相册')
          .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text('128张照片')
          .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .backgroundColor('#F1F5F9')
          .borderRadius(CommonStyles.RADIUS_FULL)
      }.width('100%')

      Row({ space: 10 }) {
        this.AlbumCard('🎂', '生日派对', '24张', '#FEF3C7')
        this.AlbumCard('🛁', '洗澡美容', '18张', '#DBEAFE')
        this.AlbumCard('😴', '日常萌照', '45张', '#E9D5FF')
      }

      Text('最新照片').fontSize(14).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach([0, 1, 2, 3], (_i: number) => {
          Image(this.pet!.images && this.pet!.images[_i % this.pet!.images.length]
            ? $rawfile(this.pet!.images[_i % this.pet!.images.length])
            : '')
            .width('22%')
            .height(80)
            .objectFit(ImageFit.Cover)
            .borderRadius(12)
            .margin({ right: 8, bottom: 8 })
        })
      }
      .width('100%')

      Button('查看全部相册（演示）', { type: ButtonType.Capsule })
        .width('100%').height(38).fontSize(13)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .backgroundColor('#F1F5F9')
        .borderRadius(10)
        .margin({ top: 8 })
        .onClick(() => promptAction.showToast({ message: '演示功能：暂无相册详情页' }))
    }
  }

  @Builder
  AlbumCard(icon: string, title: string, count: string, bgColor: string) {
    Column({ space: 6 }) {
      Text(icon).fontSize(28)
      Text(title).fontSize(12).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
      Text(count).fontSize(10).fontColor(CommonStyles.TEXT_TERTIARY)
    }
    .layoutWeight(1)
    .padding({ top: 14, bottom: 12 })
    .backgroundColor(bgColor)
    .borderRadius(14)
  }
}
