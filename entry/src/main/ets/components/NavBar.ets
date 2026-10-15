// 统一导航栏组件
import { CommonStyles } from '../common/css/CommonStyles';
import { ComponentStyles } from '../common/css/ComponentStyles';
import { RouterHelper } from '../router/RouterHelper';
import { AppStore } from '../store/AppStore';
import { BackButton } from './BackButton';

@Component
export struct NavBar {
  // 标题
  @Prop title: string = '';
  // 是否显示返回按钮
  @Prop showBack: boolean = false;
  // 返回按钮点击事件 - 使用普通属性而不是@Prop，因为@Prop不支持函数类型
  private onBack?: () => void;
  // 是否显示右侧操作
  @Prop showRightAction: boolean = false;
  // 右侧操作文本
  @Prop rightText: string = '';
  // 右侧操作图标
  @Prop rightIcon?: Resource;
  // 右侧操作点击事件 - 使用普通属性而不是@Prop，因为@Prop不支持函数类型
  private onRightAction?: () => void;
  // 是否深色模式
  @Prop isDarkMode: boolean = false;

  build() {
    Row({ space: CommonStyles.SPACE_MD }) {
      // 左侧区域
      Row({ space: CommonStyles.SPACE_SM }) {
        // 返回按钮
        if (this.showBack) {
          BackButton({
            onBackClick: this.onBack ? () => this.onBack() : undefined,
            color: this.isDarkMode ? CommonStyles.TEXT_LIGHT : CommonStyles.TEXT_PRIMARY
          })
        }

        // 标题
        Text(this.title)
          .fontSize(CommonStyles.FONT_SIZE_XL)
          .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
          .fontColor(this.isDarkMode ? CommonStyles.TEXT_LIGHT : CommonStyles.TEXT_PRIMARY)
          .layoutWeight(1)
          .textAlign(TextAlign.Start)
      }
      .layoutWeight(1)

      // 右侧区域
      if (this.showRightAction) {
        if (this.rightIcon) {
          // 图标按钮
          Image(this.rightIcon)
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              if (this.onRightAction) {
                this.onRightAction();
              }
            })
        } else if (this.rightText) {
          // 文本按钮
          Text(this.rightText)
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(CommonStyles.PRIMARY_COLOR)
            .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
            .onClick(() => {
              if (this.onRightAction) {
                this.onRightAction();
              }
            })
        }
      }
    }
    .width('100%')
    .padding({
      left: CommonStyles.SPACE_LG,
      right: CommonStyles.SPACE_LG,
      top: CommonStyles.SPACE_XL,
      bottom: CommonStyles.SPACE_LG
    })
    .backgroundColor(this.isDarkMode ? CommonStyles.BG_DARK : CommonStyles.WHITE)
    .shadow(CommonStyles.SHADOW_SM)
  }
}
