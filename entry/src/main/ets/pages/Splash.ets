import { RouterHelper } from '../router/RouterHelper';
import { AppStore } from '../store/AppStore';
import { CommonStyles } from '../common/css/CommonStyles';

@Entry
@Component
export struct Splash {
  @State private showContent: boolean = false;
  @State private logoScale: number = 0.5;
  @State private logoOpacity: number = 0;
  @State private textOpacity: number = 0;
  @State private tagOpacity: number = 0;
  @State private pulseScale: number = 1;

  aboutToAppear(): void {
    this.showContent = true;

    setTimeout(() => {
      this.logoOpacity = 1;
      this.logoScale = 1.0;
    }, 100);

    setTimeout(() => {
      this.textOpacity = 1;
    }, 400);

    setTimeout(() => {
      this.tagOpacity = 1;
    }, 700);

    setTimeout(() => {
      const isLoggedIn = AppStore.getInstance().getState().isLoggedIn;
      if (isLoggedIn) {
        RouterHelper.navigateToMainTab();
      } else {
        RouterHelper.navigateToLogin();
      }
    }, 1500);
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      // 背景层：柔和渐变
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 180,
          colors: [
            ['#F0F9FF', 0],
            ['#E0F2FE', 0.3],
            ['#FFFFFF', 1]
          ]
        })

      // 装饰圆环（右上）
      Column()
        .width(200)
        .height(200)
        .borderRadius(100)
        .border({ width: 30, color: '#DBEAFE', style: BorderStyle.Solid })
        .position({ x: '65%', y: '-15%' })
        .opacity(0.6)

      // 装饰圆环（左下）
      Column()
        .width(150)
        .height(150)
        .borderRadius(75)
        .border({ width: 20, color: '#FEF3C7', style: BorderStyle.Solid })
        .position({ x: '-20%', y: '60%' })
        .opacity(0.5)

      // 装饰小圆点
      Column()
        .width(16)
        .height(16)
        .borderRadius(8)
        .backgroundColor('#93C5FD')
        .position({ x: '25%', y: '20%' })

      Column()
        .width(12)
        .height(12)
        .borderRadius(6)
        .backgroundColor('#FCD34D')
        .position({ x: '75%', y: '70%' })

      Column()
        .width(10)
        .height(10)
        .borderRadius(5)
        .backgroundColor('#6EE7B7')
        .position({ x: '15%', y: '75%' })

      // 主内容区
      Column({ space: 28 }) {
        // Logo区域：精美设计
        Stack({ alignContent: Alignment.Center }) {
          // 外圈光晕（脉冲动画）
          Column()
            .width(140)
            .height(140)
            .borderRadius(70)
            .backgroundColor('#3B82F608')
            .scale({ x: this.pulseScale, y: this.pulseScale })
            .animation({
              duration: 1500,
              curve: Curve.EaseInOut,
              iterations: -1
            })

          // 中圈渐变环
          Column()
            .width(120)
            .height(120)
            .borderRadius(60)
            .linearGradient({
              angle: 135,
              colors: [
                ['#60A5FA', 0],
                ['#3B82F6', 0.5],
                ['#2563EB', 1]
              ]
            })
            .shadow({
              radius: 30,
              color: 'rgba(59,130,246,0.3)',
              offsetX: 0,
              offsetY: 8
            })

          // 内圈白色底
          Column()
            .width(100)
            .height(100)
            .borderRadius(50)
            .backgroundColor('#FFFFFF')

          // Logo图标：可爱宠物爪印组合
          Column({ space: 4 }) {
            Row({ space: 6 }) {
              Text('🐾')
                .fontSize(22)

              Column({ space: 2 }) {
                Text('❤️')
                  .fontSize(14)
                Text('🏠')
                  .fontSize(14)
              }
            }
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
        .scale({ x: this.logoScale, y: this.logoScale })
        .opacity(this.logoOpacity)
        .animation({
          duration: 600,
          curve: Curve.EaseOut
        })

        // 品牌文字
        Column({ space: 8 }) {
          Text('宠缘')
            .fontSize(42)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .letterSpacing(8)

          Text('让每只宠物找到温暖的家 🐱🐶')
            .fontSize(15)
            .fontColor(CommonStyles.TEXT_SECONDARY)
            .letterSpacing(1)
        }
        .opacity(this.textOpacity)
        .animation({
          duration: 500,
          curve: Curve.EaseOut
        })

        // 特性标签
        Row({ space: 10 }) {
          this.FeatureTag('🔒 安全保障', '#3B82F6')
          this.FeatureTag('💝 精心筛选', '#EC4899')
          this.FeatureTag('🆓 免费领养', '#10B981')
        }
        .opacity(this.tagOpacity)
        .animation({
      duration: 400,
      curve: Curve.EaseIn
    })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .padding({ left: 40, right: 40 })

      // 底部跳过按钮
      Text('跳过 →')
        .fontSize(14)
        .fontColor(CommonStyles.PRIMARY)
        .fontWeight(FontWeight.Medium)
        .padding({ left: 28, right: 28, top: 10, bottom: 10 })
        .position({ bottom: 60 })
        .backgroundColor('#EFF6FF')
        .borderRadius(20)
        .onClick(() => {
          const isLoggedIn = AppStore.getInstance().getState().isLoggedIn;
          if (isLoggedIn) {
            RouterHelper.navigateToMainTab();
          } else {
            RouterHelper.navigateToLogin();
          }
        })
    }
    .width('100%')
    .height('100%')
    .opacity(this.showContent ? 1 : 0)
    .animation({
      duration: 300,
      curve: Curve.EaseOut
    })
  }

  @Builder
  FeatureTag(text: string, color: string) {
    Text(text)
      .fontSize(12)
      .fontWeight(FontWeight.Medium)
      .fontColor(color)
      .padding({ left: 14, right: 14, top: 6, bottom: 6 })
      .backgroundColor(color + '12')
      .borderRadius(16)
  }
}
