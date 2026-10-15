import { RouterHelper } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';
import { petList, Pet } from '../mock/PetData';
import { promptAction } from '@kit.ArkUI';

interface TrackedPet {
  pet: Pet;
  isSafe: boolean;
  lastSeen: string;
  lastLocation: string;
  safeZoneRadius: number;
  alertCount: number;
}

interface AlertRecord {
  id: number;
  petName: string;
  time: string;
  location: string;
  status: 'active' | 'resolved' | 'false_alarm';
  resolvedTime?: string;
  helpersCount?: number;
}

@Entry
@Component
struct PetLostWarning {
  @State private trackedPets: TrackedPet[] = [];
  @State private selectedPet: TrackedPet | null = null;
  @State private showAlertPanel: boolean = false;
  @State private alerts: AlertRecord[] = [];
  @State private showEmergencyCenter: boolean = false;

  aboutToAppear(): void {
    const myPets: Pet[] = petList.slice(0, 4);
    this.trackedPets = myPets.map((pet: Pet): TrackedPet => ({
      pet,
      isSafe: true,
      lastSeen: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
      lastLocation: ['家中', '小区花园', '附近公园', '宠物店'][Math.floor(Math.random() * 4)],
      safeZoneRadius: 500,
      alertCount: 0
    }));

    this.alerts = [
      { id: 1, petName: '小橘', time: '昨天 14:30', location: '小区东门', status: 'resolved', resolvedTime: '昨天 14:45', helpersCount: 5 },
      { id: 2, petName: '豆豆', time: '3天前 09:15', location: '中央公园', status: 'resolved', resolvedTime: '3天前 10:20', helpersCount: 12 }
    ];
  }

  build() {
    Column() {
      SafeArea({ edges: ['top'] }) {
        Row() {
          BackButton()
          Text('走失预警（模拟演示）')
            .fontSize(18).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
            .layoutWeight(1)
          if (this.showAlertPanel) {
            Text('关闭')
              .fontSize(14).fontColor('#EF4444').fontWeight(FontWeight.Medium)
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .backgroundColor('#FEF2F2')
              .borderRadius(CommonStyles.RADIUS_FULL)
              .onClick(() => this.showAlertPanel = false)
          }
        }
        .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })
        .backgroundColor('#FFFFFF')

        Scroll() {
          Column({ space: 18 }) {

            this.HeroSection()

            this.GuardianDashboard()

            Column() {
              Row() {
                Text('🐾 宠物守护列表')
                  .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
                Blank()
                Text(`${this.trackedPets.length}只示例宠物`)
                  .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
                  .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                  .backgroundColor('#FFFBEB')
                  .borderRadius(CommonStyles.RADIUS_FULL)
              }.width('100%')

              ForEach(this.trackedPets, (tp: TrackedPet) => {
                this.PetGuardCard(tp)
              })
            }

            this.AlertHistory()

            this.EmergencyCenterEntry()

            this.SocialImpactSection()

          }
          .width('100%').padding({ left: 16, right: 16, bottom: 32 })
        }
        .scrollable(ScrollDirection.Vertical).scrollBar(BarState.Off)
        .layoutWeight(1).backgroundColor('#F8FAFC')
      }

      if (this.showAlertPanel && this.selectedPet) {
        this.AlertOverlay()
      }
    }
    .width('100%').height('100%')
    .padding({ top: '45mm' })
  }

  // ==================== Hero 区域 - 情感化首屏 ====================
  @Builder
  HeroSection() {
    Column({ space: 14 }) {

      Stack({ alignContent: Alignment.Bottom }) {
        Column()
          .width(90).height(90)
          .borderRadius(50)
          .backgroundColor('rgba(245,158,11,0.08)')
        Text('🛡️').fontSize(48)
      }

      Text('本地走失预警演示')
        .fontSize(24).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)

      Text('使用示例位置与本地状态演示告警流程；未连接定位设备或通知服务')
        .fontSize(13).fontColor(CommonStyles.TEXT_SECONDARY)
        .textAlign(TextAlign.Center)

      Row({ space: 10 }) {
        this.ImpactStat('本地', '示例数据', '✅')
        this.ImpactStat('模拟', '告警流程', '⚡')
        this.ImpactStat('未接入', '设备通知', '🔔')
      }
    }
    .width('100%').padding({ top: 22, bottom: 16, left: 16, right: 16 })
    .justifyContent(FlexAlign.Start).alignItems(HorizontalAlign.Center)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .shadow({ color: 'rgba(245,158,11,0.08)', radius: 16, offsetX: 0, offsetY: 2 })
  }

  @Builder
  ImpactStat(value: string, label: string, icon: string) {
    Column({ space: 4 }) {
      Text(icon).fontSize(14)
      Text(value).fontSize(17).fontWeight(FontWeight.Bold).fontColor('#F59E0B')
      Text(label).fontSize(10).fontColor(CommonStyles.TEXT_TERTIARY)
    }
    .layoutWeight(1)
    .padding(10)
    .backgroundColor('#FFFBEB')
    .borderRadius(12)
  }

  // ==================== 守护仪表盘 ====================
  @Builder
  GuardianDashboard() {
    Column({ space: 12 }) {
      Row() {
        Text('示例守护状态')
          .fontSize(15).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text(this.allSafe ? '一切正常' : '需要关注')
          .fontSize(11).fontWeight(FontWeight.Medium)
          .fontColor(this.allSafe ? '#10B981' : '#EF4444')
          .padding({ left: 8, right: 8, top: 3, bottom: 3 })
          .backgroundColor(this.allSafe ? '#ECFDF5' : '#FEF2F2')
          .borderRadius(CommonStyles.RADIUS_FULL)
      }
      .width('100%')

      ForEach(this.trackedPets, (tp: TrackedPet) => {
        Row({ space: 10 }) {
          Stack({ alignContent: Alignment.Center }) {
            Circle().width(36).height(36).fill(tp.isSafe ? '#ECFDF5' : '#FEF2F2')
            Text(tp.pet.name.charAt(0)).fontSize(16).fontWeight(FontWeight.Bold)
              .fontColor(tp.isSafe ? '#10B981' : '#EF4444')
          }

          Column({ space: 2 }) {
            Row() {
              Text(tp.pet.name).fontSize(14).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
              Blank()
              Text(tp.isSafe ? '安全 · 在线' : '⚠️ 偏离区域')
                .fontSize(11).fontWeight(FontWeight.Medium)
                .fontColor(tp.isSafe ? '#10B981' : '#EF4444')
            }
            .width('100%')
            Text(`${tp.lastLocation} · 更新于${tp.lastSeen}`)
              .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Start)

          Circle()
            .width(10).height(10)
            .fill(tp.isSafe ? '#10B981' : '#EF4444')
        }
        .width('100%').padding(10)
        .backgroundColor('#FAFAFA')
        .borderRadius(10)
      })

      Row({ space: 6 }) {
        Text(`演示计时: ${this.formatGuardHours()}小时`).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
        Blank()
        Text(`本地模拟预警: ${this.totalAlertCount}次`).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
      }
      .width('100%')
    }
    .width('100%').padding(14)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({ color: 'rgba(0,0,0,0.04)', radius: 8, offsetX: 0, offsetY: 1 })
  }

  get allSafe(): boolean {
    return this.trackedPets.every((t: TrackedPet) => t.isSafe);
  }

  private formatGuardHours(): string {
    const h = 8 + Math.floor(Math.random() * 4);
    const m = Math.floor(Math.random() * 60);
    return `${h}:${m.toString().padStart(2, '0')}`;
  }

  get totalAlertCount(): number {
    return this.trackedPets.reduce((sum: number, t: TrackedPet) => sum + t.alertCount, 0) + this.alerts.filter(a => a.status !== 'false_alarm').length;
  }

  // ==================== 宠物守护卡片 ====================
  @Builder
  PetGuardCard(tp: TrackedPet) {
    Column({ space: 12 }) {
      Row({ space: 12 }) {
        Stack({ alignContent: Alignment.BottomEnd }) {
          Image(tp.pet.images && tp.pet.images.length > 0 ? $rawfile(tp.pet.images[0]) : '')
            .width(68).height(68).objectFit(ImageFit.Cover)
            .borderRadius(16)

          Column() {
            Text(tp.isSafe ? '🟢' : '🔴').fontSize(10)
          }
          .width(22).height(22)
          .backgroundColor('#FFFFFF')
          .borderRadius(11)
          .shadow({ color: 'rgba(0,0,0,0.1)', radius: 4, offsetX: 0, offsetY: 1 })
          .position({ x: 42, y: 42 })
          .justifyContent(FlexAlign.Center)
        }

        Column({ space: 5 }) {
          Row() {
            Text(tp.pet.name)
              .fontSize(16).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
            Blank()
            Text(tp.isSafe ? '安全' : '⚠️ 偏离区域')
              .fontSize(12).fontWeight(FontWeight.Medium)
              .fontColor(tp.isSafe ? '#10B981' : '#EF4444')
              .padding({ left: 8, right: 8, top: 3, bottom: 3 })
              .backgroundColor(tp.isSafe ? '#ECFDF5' : '#FEF2F2')
              .borderRadius(CommonStyles.RADIUS_FULL)
          }.width('100%')

          Text(`最后位置 ${tp.lastLocation}`)
            .fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)

          Row({ space: 8 }) {
            Text(`于${tp.lastSeen}`).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
            Text(`🛡️ ${tp.safeZoneRadius}m`).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
            if (tp.alertCount > 0) {
              Text(`🚨 ${tp.alertCount}次`).fontSize(11).fontColor('#EF4444').fontWeight(FontWeight.Medium)
            }
          }
        }
        .layoutWeight(1).alignItems(HorizontalAlign.Start)
      }

      Row({ space: 8 }) {
        Button('模拟走失', { type: ButtonType.Capsule })
          .layoutWeight(1).height(36).fontSize(12)
          .fontColor('#FFFFFF').fontWeight(FontWeight.Medium)
          .backgroundColor('#EF4444')
          .borderRadius(10)
          .shadow({ color: 'rgba(239,68,68,0.25)', radius: 6, offsetX: 0, offsetY: 2 })
          .onClick(() => this.triggerAlert(tp))

        Button('调整范围', { type: ButtonType.Capsule })
          .layoutWeight(1).height(36).fontSize(12)
          .fontColor(CommonStyles.TEXT_SECONDARY)
          .backgroundColor('#F1F5F9')
          .borderRadius(10)
          .onClick(() => {
            tp.safeZoneRadius = tp.safeZoneRadius >= 1000 ? 200 : tp.safeZoneRadius + 200;
            promptAction.showToast({ message: `安全半径已调整为 ${tp.safeZoneRadius}m` });
          })

        Button(tp.isSafe ? '查看轨迹' : '确认找到', { type: ButtonType.Capsule })
          .layoutWeight(1).height(36).fontSize(12)
          .fontColor(tp.isSafe ? CommonStyles.TEXT_SECONDARY : '#FFFFFF')
          .fontWeight(FontWeight.Medium)
          .backgroundColor(tp.isSafe ? '#F1F5F9' : '#10B981')
          .borderRadius(10)
          .onClick(() => {
            if (!tp.isSafe) {
              tp.isSafe = true;
              const existingAlert: AlertRecord | undefined = this.alerts.find((a: AlertRecord) =>
                a.petName === tp.pet.name && a.status === 'active'
              );
              if (existingAlert) {
                existingAlert.status = 'resolved';
                existingAlert.resolvedTime = new Date().toLocaleTimeString();
                existingAlert.helpersCount = Math.floor(Math.random() * 15) + 1;
              }
              promptAction.showToast({ message: `🎉 ${tp.pet.name} 已找到！感谢所有帮助者` });
            } else {
              promptAction.showToast({ message: `查看 ${tp.pet.name} 的活动轨迹` });
            }
          })
      }
    }
    .width('100%').padding(14)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow(!tp.isSafe
      ? { color: 'rgba(239,68,68,0.2)', radius: 12, offsetX: 0, offsetY: 4 }
      : { color: 'rgba(0,0,0,0.04)', radius: 8, offsetX: 0, offsetY: 1 })
    .border({
      width: !tp.isSafe ? 2 : 0,
      color: '#EF4444',
      radius: 16
    })
  }

  // ==================== 预警历史记录 ====================
  @Builder
  AlertHistory() {
    Column({ space: 14 }) {
      Row() {
        Text('📋 预警历史记录')
          .fontSize(16).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text(`${this.alerts.length}条记录`)
          .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .backgroundColor('#F1F5F9')
          .borderRadius(CommonStyles.RADIUS_FULL)
      }
      .width('100%')

      if (this.alerts.length > 0) {
        ForEach(this.alerts, (alert: AlertRecord) => {
          Column({ space: 10 }) {
            Row({ space: 10 }) {
              Stack({ alignContent: Alignment.Center }) {
                Circle()
                  .width(38).height(38)
                  .fill(alert.status === 'active' ? '#FEF2F2' :
                    alert.status === 'resolved' ? '#ECFDF5' : '#FFFBEB')

                Text(alert.status === 'active' ? '🚨' :
                  alert.status === 'resolved' ? '✅' : '⚠️')
                  .fontSize(18)
              }

              Column({ space: 3 }) {
                Row() {
                  Text(alert.petName)
                    .fontSize(14).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
                  Text(this.getStatusText(alert.status))
                }
                .width('100%')

                Row({ space: 12 }) {
                  Text(`📍 ${alert.location}`).fontSize(11).fontColor(CommonStyles.TEXT_SECONDARY)
                  Text(`🕐 ${alert.time}`).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
                }

                if (alert.status === 'resolved' && alert.helpersCount) {
                  Text(`模拟协助人数 ${alert.helpersCount} · 演示用时${this.calcDuration(alert.time, alert.resolvedTime || '')}`)
                    .fontSize(10).fontColor('#10B981').fontWeight(FontWeight.Medium)
                }
              }
              .layoutWeight(1).alignItems(HorizontalAlign.Start)
            }
            .width('100%')
          }
          .width('100%').padding(13)
          .backgroundColor('#FFFFFF')
          .borderRadius(14)
          .shadow({ color: 'rgba(0,0,0,0.04)', radius: 8, offsetX: 0, offsetY: 1 })
        })
      } else {
        Column({ space: 10 }) {
          Text('✅').fontSize(36).fontColor('#10B981')
          Text('暂无预警记录').fontSize(15).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_SECONDARY)
          Text('所有宠物都在安全区域内运行').fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
        }
        .width('100%').padding(28)
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
        .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({ color: 'rgba(0,0,0,0.03)', radius: 10, offsetX: 0, offsetY: 1 })
  }

  private getStatusText(status: string): string {
    return status === 'active' ? '进行中' : status === 'resolved' ? '已解决' : '误报';
  }

  @Builder
  getStatusBadge(status: string) {
    Text(status === 'active' ? '进行中' : status === 'resolved' ? '已解决' : '误报')
      .fontSize(10).fontWeight(FontWeight.Medium)
      .fontColor(status === 'active' ? '#EF4444' : status === 'resolved' ? '#10B981' : '#F59E0B')
      .padding({ left: 7, right: 7, top: 2, bottom: 2 })
      .backgroundColor(status === 'active' ? '#FEF2F2' : status === 'resolved' ? '#ECFDF5' : '#FFFBEB')
      .borderRadius(6)
  }

  private calcDuration(start: string, end: string): string {
    if (!start || !end) return '';
    return `${Math.floor(Math.random() * 25) + 5}分钟`;
  }

  // ==================== 紧急求助中心入口 ====================
  @Builder
  EmergencyCenterEntry() {
    Column({ space: 14 }) {
      Row() {
        Text('🆘 紧急求助中心')
          .fontSize(16).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text('一键求救')
          .fontSize(10).fontColor('#EF4444').fontWeight(FontWeight.Medium)
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .backgroundColor('#FEF2F2')
          .borderRadius(6)
      }
      .width('100%')

      Row({ space: 10 }) {
        this.EmergencyAction('📞', '拨打救助热线', '400-PET-HELP', () => {})
        this.EmergencyAction('📢', '发布寻宠启事', '一键生成海报', () => {})
        this.EmergencyAction('🤝', '联系志愿者', '3人在线待命', () => {})
        this.EmergencyAction('🏥', '导航到救助站', '距离1.2km', () => {})
      }
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({ color: 'rgba(239,68,68,0.05)', radius: 10, offsetX: 0, offsetY: 2 })
  }

  @Builder
  EmergencyAction(icon: string, title: string, subtitle: string, action: () => void) {
    Column({ space: 6 }) {
      Text(icon).fontSize(24)
      Text(title).fontSize(11).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
      Text(subtitle).fontSize(9).fontColor(CommonStyles.TEXT_TERTIARY)
    }
    .layoutWeight(1)
    .padding({ top: 12, bottom: 10 })
    .backgroundColor('#FEF2F2')
    .borderRadius(12)
    .onClick(action)
  }

  // ==================== 社会影响展示 ====================
  @Builder
  SocialImpactSection() {
    Column({ space: 16 }) {
      Row() {
        Text('💝 平台社会价值')
          .fontSize(16).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text('科技向善')
          .fontSize(10).fontColor('#F59E0B').fontWeight(FontWeight.Medium)
          .padding({ left: 7, right: 7, top: 2, bottom: 2 })
          .backgroundColor('#FFFBEB')
          .borderRadius(6)
      }
      .width('100%')

      Row({ space: 10 }) {
        this.ImpactCard('本地', '数据来源', '👨‍👩‍👧‍👦', '#6366F1')
        this.ImpactCard('示例', '宠物记录', '🐾', '#14B8A6')
        this.ImpactCard('模拟', '预警反馈', '🎯', '#10B981')
        this.ImpactCard('未接入', '外部网络', '🤝', '#F59E0B')
      }

      Divider().color('#F1F5F9')

      Text('本页用于展示产品设想，没有真实定位、社区通知、救助站联动或找回率数据。')
        .fontSize(12).fontColor(CommonStyles.TEXT_SECONDARY).lineHeight(20)
        .textAlign(TextAlign.Center)
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({ color: 'rgba(245,158,11,0.05)', radius: 10, offsetX: 0, offsetY: 2 })
  }

  @Builder
  ImpactCard(number: string, label: string, icon: string, accent: string) {
    Column({ space: 4 }) {
      Text(icon).fontSize(14)
      Text(number)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor(accent)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(label).fontSize(9).fontColor(CommonStyles.TEXT_TERTIARY)
    }
    .layoutWeight(1)
    .padding(10)
    .backgroundColor(accent + '08')
    .borderRadius(10)
  }

  // ==================== 走失预警弹窗 ====================
  @Builder
  AlertOverlay() {
    Stack({
      alignContent: Alignment.Center
    }) {
      Column()
        .width('100%').height('100%')
        .backgroundColor('rgba(0,0,0,0.55)')
        .onClick(() => {})

      Column({ space: 20 }) {
        Row() {
          Text('🚨 走失预警')
            .fontSize(20).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
          Blank()
          Button('关闭', { type: ButtonType.Capsule })
            .height(32).fontSize(12)
            .fontColor('#FFFFFF')
            .backgroundColor('rgba(255,255,255,0.2)')
            .borderRadius(CommonStyles.RADIUS_FULL)
            .onClick(() => this.showAlertPanel = false)
        }
        .width('100%')

        Column({ space: 18 }) {
          if (this.selectedPet) {
            Stack({ alignContent: Alignment.Center }) {
              Column()
                .width(80).height(80)
                .borderRadius(40)
                .backgroundColor('#FEF2F2')
              Text('⚠️').fontSize(36)
            }

            Text(`${this.selectedPet.pet.name} 已偏离安全区域！`)
              .fontSize(18).fontWeight(FontWeight.Bold)
              .fontColor('#991B1B')
              .textAlign(TextAlign.Center)

            Column({ space: 10 }) {
              this.AlertInfoRow('最后已知位置', this.selectedPet.lastLocation)
              this.AlertInfoRow('偏离时间', '刚刚')
              this.AlertInfoRow('安全半径', `${this.selectedPet.safeZoneRadius}米`)
              this.AlertInfoRow('历史警报次数', `共${this.selectedPet.alertCount} 次`)
            }
            .width('100%').padding(14)
            .backgroundColor('#FEF2F2')
            .borderRadius(14)

            Column({ space: 10 }) {
              Row() {
                Text('三级响应示意（不会发送通知）：')
                  .fontSize(13).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
              }
              .width('100%')

              this.NotifyRow('L1 提醒', '仅本页提示，未发送手机推送', false)
              this.NotifyRow('L2 扩散', '未通知社区群组或附近用户', false)
              this.NotifyRow('L3 支持', '未联动救助站或志愿者', false)
            }
            .width('100%').padding(14)
            .backgroundColor('#FFF8F0')
            .borderRadius(14)

            Row({ space: 12 }) {
              Button('误报解除', { type: ButtonType.Capsule })
                .layoutWeight(1).height(44).fontSize(14)
                .fontColor(CommonStyles.TEXT_SECONDARY)
                .backgroundColor('#F1F5F9')
                .borderRadius(12)
                .onClick(() => this.dismissAlert(false))

              Button('确认走失，开始寻找', { type: ButtonType.Capsule })
                .layoutWeight(1.5).height(44).fontSize(14)
                .fontColor('#FFFFFF').fontWeight(FontWeight.Bold)
                .backgroundColor('#EF4444')
                .borderRadius(12)
                .shadow({ color: 'rgba(239,68,68,0.35)', radius: 10, offsetX: 0, offsetY: 3 })
                .onClick(() => this.dismissAlert(true))
            }
          }
        }
        .width('100%').padding(24)
        .backgroundColor('#FFFFFF')
        .borderRadius(24)
        .shadow({ radius: 28, color: 'rgba(0,0,0,0.3)', offsetX: 0, offsetY: 12 })
      }
      .width('92%')
    }
    .width('100%')
    .height('100%')
    .position({ x: 0, y: 0 })
  }

  @Builder
  AlertInfoRow(label: string, value: string) {
    Row() {
      Text(label).fontSize(13).fontColor(CommonStyles.TEXT_TERTIARY).width(85)
      Text(value).fontSize(13).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
      Blank()
    }
    .width('100%')
  }

  @Builder
  NotifyRow(level: string, desc: string, active: boolean) {
    Row({ space: 10 }) {
      Text(level).fontSize(11).fontWeight(FontWeight.Bold)
        .fontColor(active ? '#EF4444' : '#94A3B8')
        .width(45)
      Text(desc).fontSize(12).fontColor(active ? CommonStyles.TEXT_PRIMARY : CommonStyles.TEXT_TERTIARY)
        .layoutWeight(1)
      Text(active ? '✅' : '⏸️').fontSize(12)
        .fontColor(active ? '#10B981' : '#CBD5E1')
        .fontWeight(FontWeight.Bold)
    }
    .width('100%').padding(8)
    .backgroundColor(active ? '#FEF2F2' : '#F8FAFC')
    .borderRadius(8)
  }

  // ==================== 业务逻辑 ====================

  private triggerAlert(tp: TrackedPet): void {
    this.selectedPet = tp;
    tp.isSafe = false;
    tp.alertCount++;
    tp.lastLocation = ['小区北门', '中央广场', '地铁站口', '商业街'][Math.floor(Math.random() * 4)];

    const newAlert: AlertRecord = {
      id: Date.now(),
      petName: tp.pet.name,
      time: new Date().toLocaleString(),
      location: tp.lastLocation,
      status: 'active'
    };
    this.alerts.unshift(newAlert);

    this.showAlertPanel = true;
    promptAction.showToast({ message: `${tp.pet.name} 的本地模拟预警已显示；未发送真实通知` });
  }

  private dismissAlert(isRealLost: boolean): void {
    if (this.selectedPet) {
      const alert: AlertRecord | undefined = this.alerts.find((a: AlertRecord) =>
        a.petName === this.selectedPet!.pet.name && a.status === 'active'
      );
      if (alert) {
        alert.status = isRealLost ? 'active' : 'false_alarm';
      }
      if (!isRealLost) {
        this.selectedPet.isSafe = true;
        promptAction.showToast({ message: '警报已解除，宠物安全' });
      } else {
        promptAction.showToast({ message: '🚀 已启动全网搜寻模式，正在联系周边用户...' });
      }
    }
    this.showAlertPanel = false;
  }
}
