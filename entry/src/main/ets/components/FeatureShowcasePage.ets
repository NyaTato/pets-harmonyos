import { CommonStyles } from '../common/css/CommonStyles';
import { RouterHelper } from '../router/RouterHelper';
import { BackButton } from './BackButton';
import { SafeArea } from './SafeArea';

export interface FeatureShowcaseConfig {
  title: string;
  subtitle: string;
  description: string;
  iconSymbol: string;
  tagText: string;
  tagColor: string;
  features: FeatureItemData[];
}

export interface FeatureItemData {
  symbol: string;
  label: string;
}

@Component
export struct FeatureShowcasePage {
  @Prop config: FeatureShowcaseConfig = {
    title: '新功能',
    subtitle: '即将推出',
    description: '',
    iconSymbol: '✦',
    tagText: '概念',
    tagColor: '#8B5CF6',
    features: []
  };

  build() {
    Column() {
      SafeArea({
        edges: ['top']
      }) {
        Column() {
          this.NavBar()

          Scroll() {
            Column({ space: 0 }) {

              this.HeroSection()

              this.DescriptionSection()

              this.FeaturesSection()

              this.StatusBadge()

              this.ActionArea()

            }
            .width('100%')
            .padding({ bottom: 60 })
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)
          .layoutWeight(1)
          .backgroundColor('#F8FAFC')
        }
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: '45mm' })
  }

  @Builder
  NavBar() {
    Row() {
      BackButton()

      Text(this.config.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0F172A')
        .layoutWeight(1)
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 16, bottom: 16 })
    .backgroundColor('#FFFFFF')
  }

  @Builder
  HeroSection() {
    Column({ space: 16 }) {
      Stack({ alignContent: Alignment.Center }) {
        Circle()
          .width(100)
          .height(100)
          .fill(this.config.tagColor)
          .opacity(0.15)

        Text(this.config.iconSymbol)
          .fontSize(44)
          .fontColor(this.config.tagColor)
      }

      Text(this.config.subtitle)
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .fontColor('#0F172A')

      Text(this.config.title)
        .fontSize(14)
        .fontColor('#64748B')
        .letterSpacing(2)
    }
    .width('100%')
    .padding({ top: 48, bottom: 8 })
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  DescriptionSection() {
    Text(this.config.description)
      .fontSize(15)
      .fontColor('#475569')
      .textAlign(TextAlign.Center)
      .lineHeight(24)
      .width('80%')
      .padding({ top: 12, bottom: 28 })
  }

  @Builder
  FeaturesSection() {
    if (this.config.features.length > 0) {
      Column({ space: 12 }) {
        ForEach(this.config.features, (item: FeatureItemData, index: number) => {
          this.FeatureRow(item)
        }, (item: FeatureItemData) => item.label)
      }
      .width('90%')
      .padding({ left: 20, right: 20 })
    }
  }

  @Builder
  FeatureRow(item: FeatureItemData) {
    Row({ space: 14 }) {
      Circle()
        .width(36)
        .height(36)
        .fill('#F1F5F9')

      Text(item.symbol)
        .fontSize(18)

      Text(item.label)
        .fontSize(15)
        .fontColor('#334155')
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)

      Text('→')
        .fontSize(16)
        .fontColor('#CBD5E1')
    }
    .width('100%')
    .padding({ left: 4, right: 16, top: 14, bottom: 14 })
    .backgroundColor('#FFFFFF')
    .borderRadius(14)
    .shadow({ radius: 4, color: 'rgba(0,0,0,0.04)', offsetX: 0, offsetY: 2 })
  }

  @Builder
  StatusBadge() {
    Row({ space: 8 }) {
      Circle()
        .width(8)
        .height(8)
        .fill(this.config.tagColor)

      Text(this.config.tagText)
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.config.tagColor)
    }
    .padding({ left: 18, right: 18, top: 10, bottom: 10 })
    .backgroundColor(`${this.config.tagColor}15`)
    .borderRadius(20)
    .margin({ top: 32 })
  }

  @Builder
  ActionArea() {
    Button('返回', { type: ButtonType.Capsule })
      .width(180)
      .height(46)
      .fontSize(16)
      .fontWeight(FontWeight.Medium)
      .fontColor('#FFFFFF')
      .backgroundColor(this.config.tagColor)
      .borderRadius(23)
      .shadow({ radius: 12, color: `${this.config.tagColor}40`, offsetX: 0, offsetY: 4 })
      .margin({ top: 32 })
      .onClick(() => RouterHelper.back())
  }
}
