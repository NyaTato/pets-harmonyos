import { CommonStyles } from '../common/css/CommonStyles';
import { RouterHelper } from '../router/RouterHelper';

@Component
export struct BackButton {
  private onBackClick?: () => void;
  @Prop color: string = CommonStyles.TEXT_PRIMARY;
  @Prop iconSize: number = CommonStyles.ICON_SIZE_MD;
  @Prop bgColor: string = 'transparent';

  build() {
    Row() {
      Text('<')
        .fontSize(this.iconSize)
        .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
        .fontColor(this.color)
    }
    .width(CommonStyles.ICON_SIZE_TOUCH)
    .height(CommonStyles.ICON_SIZE_TOUCH)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .borderRadius(CommonStyles.RADIUS_FULL)
    .backgroundColor(this.bgColor)
    .onClick(() => {
      if (this.onBackClick) {
        this.onBackClick();
      } else {
        RouterHelper.back();
      }
    })
  }
}
