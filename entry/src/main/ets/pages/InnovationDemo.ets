﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿import { RouterHelper } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

interface FeatureItem {
  icon: string;
  title: string;
  subtitle: string;
  route: string;
  tag: string;
  tagColor: string;
}

@Entry
@Component
struct InnovationDemo {
  private features: FeatureItem[] = [
    { icon: '🥽', title: '图片预览', subtitle: '本地图片互动，无真实 AR', route: 'pages/ARPreview', tag: '演示', tagColor: '#3B82F6' },
    { icon: '🔊', title: '声音模拟器', subtitle: '本地示例交互', route: 'pages/PetSoundSimulator', tag: '演示', tagColor: '#3B82F6' },
    { icon: '☁️', title: '云养宠模式', subtitle: '本地模拟互动', route: 'pages/PetCloudAdoption', tag: '演示', tagColor: '#3B82F6' },
    { icon: '🚨', title: '走失预警', subtitle: '本地模拟位置与告警', route: 'pages/PetLostWarning', tag: '演示', tagColor: '#3B82F6' },
    { icon: '🤖', title: '宠物匹配', subtitle: '示例结果，未接入 AI 模型', route: 'pages/SmartRecommendation', tag: '演示', tagColor: '#3B82F6' },
    { icon: '🎴', title: '分享卡片', subtitle: '页面交互展示', route: 'pages/ShareCardGenerator', tag: '演示', tagColor: '#10B981' },
    { icon: '⭐', title: '信用积分', subtitle: '示例评分展示', route: 'pages/CreditScoreDisplay', tag: '演示', tagColor: '#3B82F6' },
    { icon: '😺', title: '情绪展示', subtitle: '本地模拟情绪数据', route: 'pages/MoodDisplay', tag: '演示', tagColor: '#3B82F6' },
    { icon: '🏆', title: '等级成长', subtitle: '本地养成流程示例', route: 'pages/PetLevelSystem', tag: '演示', tagColor: '#3B82F6' },
    { icon: '💕', title: '匹配度测试', subtitle: '示例问答与分数', route: 'pages/MatchTest', tag: '演示', tagColor: '#3B82F6' },
    { icon: '📅', title: '养宠日历', subtitle: '本地日历页面', route: 'pages/Calendar', tag: '演示', tagColor: '#10B981' },
    { icon: '🏅', title: '分享排行榜', subtitle: '示例内容排序', route: 'pages/ShareRank', tag: '演示', tagColor: '#EF4444' }
  ];

  build() {
    Column() {
      SafeArea({
        edges: ['top']
      }) {
        Row() {
          BackButton()

          Text('功能演示中心')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .layoutWeight(1)
        }
        .width('100%')
        .padding({ left: 24, right: 24, top: 16, bottom: 16 })
        .backgroundColor('#FFFFFF')

        Scroll() {
          Column({ space: 0 }) {

            this.HeroSection()

            Text('全部功能')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1A1A1A')
              .width('100%')
              .padding({ left: 20, top: 32, bottom: 16 })

            ForEach(this.features, (item: FeatureItem, index: number) => {
              this.FeatureRow(item)
            }, (item: FeatureItem) => item.route)

          }
          .width('100%')
          .padding({ bottom: 60 })
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .layoutWeight(1)
        .backgroundColor('#F5F7FA')
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: '45mm' })
  }

  @Builder
  HeroSection() {
    Column({ space: 16 }) {
      Text('探索演示页面')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')

      Text('这些页面使用本地示例数据，不代表已接入真实服务或设备')
        .fontSize(15)
        .fontColor('#6B7280')
        .textAlign(TextAlign.Center)

      Row({ space: 12 }) {
        this.StatBadge('12', '个演示入口')
        this.StatBadge('本地', '示例数据')
        this.StatBadge('待验证', '设备运行')
      }

      Text('所有入口均按演示功能展示，具体实现边界见 README')
        .fontSize(12)
        .fontColor('#9CA3AF')
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .padding({ top: 40, bottom: 28 })
  }

  @Builder
  StatBadge(value: string, label: string) {
    Column({ space: 4 }) {
      Text(value)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.PRIMARY)
      Text(label)
        .fontSize(11)
        .fontColor('#9CA3AF')
    }
    .layoutWeight(1)
    .padding(12)
    .backgroundColor('#F0FDF4')
    .borderRadius(12)
  }

  @Builder
  FeatureRow(item: FeatureItem) {
    Row({ space: 14 }) {
      Text(item.icon)
        .fontSize(32)

      Column({ space: 4 }) {
        Row({ space: 8 }) {
          Text(item.title)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1A1A1A')

          Text(item.tag)
            .fontSize(10)
            .fontColor('#FFFFFF')
            .backgroundColor(item.tagColor)
            .borderRadius(4)
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
        }

        Text(item.subtitle)
          .fontSize(13)
          .fontColor('#9CA3AF')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Text('>')
        .fontSize(18)
        .fontColor('#D1D5DB')
    }
    .width('100%')
    .padding(16)
    .margin({ left: 20, right: 20, bottom: 12 })
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .onClick(() => {
      RouterHelper.pushUrl(item.route);
    })
  }
}
