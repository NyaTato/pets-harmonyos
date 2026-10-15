// 加载动画组件
import { CommonStyles } from '../common/css/CommonStyles';

@Component
export struct LoadingSpinner {
  @Prop spinnerSize: number = 40;
  @Prop color: string = CommonStyles.PRIMARY_COLOR;
  @Prop text: string = '加载中..';
  @Prop showText: boolean = true;

  @State private rotation: number = 0;
  private timerId: number = 0;

  aboutToAppear() {
    this.startAnimation();
  }

  aboutToDisappear() {
    this.stopAnimation();
  }

  private startAnimation() {
    this.timerId = setInterval(() => {
      this.rotation = (this.rotation + 5) % 360;
    }, 16);
  }

  private stopAnimation() {
    if (this.timerId) {
      clearInterval(this.timerId);
      this.timerId = 0;
    }
  }

  build() {
    Column({ space: CommonStyles.SPACE_MD }) {
      // 旋转动画
      Stack() {
        Circle({ width: this.spinnerSize, height: this.spinnerSize })
          .fill(this.color)
          .opacity(0.2)

        Circle({ width: this.spinnerSize * 0.8, height: this.spinnerSize * 0.8 })
          .fill(Color.Transparent)
          .stroke(this.color)
          .strokeWidth(4)
          .strokeDashArray([this.spinnerSize * 0.25, this.spinnerSize * 0.75])
          .rotate({ angle: this.rotation })
      }
      .width(this.spinnerSize)
      .height(this.spinnerSize)

      // 加载文本
      if (this.showText) {
        Text(this.text)
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontColor(CommonStyles.TEXT_SECONDARY)
      }
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
