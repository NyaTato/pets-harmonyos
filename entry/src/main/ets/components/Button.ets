import { CommonStyles } from '../common/css/CommonStyles';
import { ComponentStyles } from '../common/css/ComponentStyles';
import { ButtonStyle } from '../common/css/StyleTypes';

interface ButtonParams {
  text: string;
  disabled?: boolean;
  onButtonClick: () => void;
  loading?: boolean;
  customStyle?: ButtonStyle;
}

export interface PrimaryButtonParams extends ButtonParams {}

@Component
export struct PrimaryButton {
  @Prop text: string = '';
  @Prop disabled: boolean = false;
  private onButtonClick?: () => void;
  @Prop loading: boolean = false;
  @Prop customStyle?: ButtonStyle;
  @Prop module?: 'ar' | 'ai' | 'iot' | 'default' = 'default';

  build() {
    Button(this.text, { type: ButtonType.Capsule, stateEffect: true })
      .width('100%')
      .height(ComponentStyles.getButtonStyle(this.module).height)
      .fontSize(ComponentStyles.getButtonStyle(this.module).fontSize)
      .fontWeight(ComponentStyles.getButtonStyle(this.module).fontWeight)
      .fontColor(ComponentStyles.getButtonStyle(this.module).fontColor)
      .backgroundColor(this.disabled ? CommonStyles.GRAY_200 : ComponentStyles.getButtonStyle(this.module).backgroundColor)
      .borderRadius(ComponentStyles.getButtonStyle(this.module).borderRadius)
      .enabled(!this.disabled && !this.loading)
      .shadow(this.disabled ? CommonStyles.SHADOW_NONE : (ComponentStyles.getButtonStyle(this.module).shadow || CommonStyles.SHADOW_SM))
      .onClick(() => {
        if (this.onButtonClick && !this.loading) {
          this.onButtonClick();
        }
      })
      .stateEffect(true)
  }
}

@Component
export struct SecondaryButton {
  @Prop text: string = '';
  @Prop disabled: boolean = false;
  private onButtonClick?: () => void;
  @Prop loading: boolean = false;
  @Prop customStyle?: ButtonStyle;

  build() {
    Button(this.text, { type: ButtonType.Capsule, stateEffect: true })
      .width('100%')
      .height(ComponentStyles.BUTTON_SECONDARY.height)
      .fontSize(ComponentStyles.BUTTON_SECONDARY.fontSize)
      .fontWeight(ComponentStyles.BUTTON_SECONDARY.fontWeight)
      .fontColor(ComponentStyles.BUTTON_SECONDARY.fontColor)
      .backgroundColor(ComponentStyles.BUTTON_SECONDARY.backgroundColor)
      .border(ComponentStyles.BUTTON_SECONDARY.border)
      .borderRadius(ComponentStyles.BUTTON_SECONDARY.borderRadius)
      .enabled(!this.disabled && !this.loading)
      .onClick(() => {
        if (this.onButtonClick && !this.loading) {
          this.onButtonClick();
        }
      })
      .stateEffect(ComponentStyles.BUTTON_SECONDARY.stateEffect)
  }
}

interface TextButtonParams extends ButtonParams {
  textColor?: string;
}

@Component
export struct TextButton {
  @Prop text: string = '';
  @Prop textColor: string = CommonStyles.PRIMARY;
  @Prop disabled: boolean = false;
  private onButtonClick?: () => void;
  @Prop loading: boolean = false;
  @Prop customStyle?: ButtonStyle;

  build() {
    Button(this.text, { type: ButtonType.Normal })
      .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
      .fontColor(this.disabled ? CommonStyles.TEXT_DISABLED : this.textColor)
      .backgroundColor(Color.Transparent)
      .enabled(!this.disabled && !this.loading)
      .onClick(() => {
        if (this.onButtonClick && !this.loading) {
          this.onButtonClick();
        }
      })
  }
}

interface IconButtonParams {
  icon: Resource;
  iconSize?: number;
  color?: string;
  disabled?: boolean;
  onButtonClick: () => void;
}

@Component
export struct IconButton {
  @Prop icon: Resource;
  @Prop iconSize: number = CommonStyles.ICON_SIZE_MD;
  @Prop color: string = CommonStyles.TEXT_PRIMARY;
  @Prop disabled: boolean = false;
  private onButtonClick?: () => void;

  build() {
    Image(this.icon)
      .width(this.iconSize)
      .height(this.iconSize)
      .objectFit(ImageFit.Contain)
      .opacity(this.disabled ? 0.5 : 1)
      .onClick(() => {
        if (this.onButtonClick && !this.disabled) {
          this.onButtonClick();
        }
      })
  }
}

// 新增：AR主题按钮
@Component
export struct ARButton {
  @Prop text: string = '开始AR体验';
  @Prop disabled: boolean = false;
  private onButtonClick?: () => void;
  @Prop loading: boolean = false;

  build() {
    Button(this.text, { type: ButtonType.Capsule, stateEffect: true })
      .width('100%')
      .height(ComponentStyles.BUTTON_AR.height)
      .fontSize(ComponentStyles.BUTTON_AR.fontSize)
      .fontWeight(ComponentStyles.BUTTON_AR.fontWeight)
      .fontColor(ComponentStyles.AR.fontColor || CommonStyles.WHITE)
      .backgroundColor(this.disabled ? CommonStyles.GRAY_200 : ComponentStyles.AR.backgroundColor)
      .borderRadius(ComponentStyles.AR.borderRadius)
      .enabled(!this.disabled && !this.loading)
      .shadow(this.disabled ? CommonStyles.SHADOW_NONE : ComponentStyles.AR.shadow)
      .onClick(() => {
        if (this.onButtonClick && !this.loading) {
          this.onButtonClick();
        }
      })
  }
}

// 新增：IoT主题按钮
@Component
export struct IoTButton {
  @Prop text: string = '立即启用';
  @Prop disabled: boolean = false;
  private onButtonClick?: () => void;
  @Prop loading: boolean = false;

  build() {
    Button(this.text, { type: ButtonType.Capsule, stateEffect: true })
      .width('100%')
      .height(ComponentStyles.BUTTON_IOT.height)
      .fontSize(ComponentStyles.BUTTON_IOT.fontSize)
      .fontWeight(ComponentStyles.BUTTON_IOT.fontWeight)
      .fontColor(ComponentStyles.IOT.fontColor || CommonStyles.WHITE)
      .backgroundColor(this.disabled ? CommonStyles.GRAY_200 : ComponentStyles.IOT.backgroundColor)
      .borderRadius(ComponentStyles.IOT.borderRadius)
      .enabled(!this.disabled && !this.loading)
      .shadow(this.disabled ? CommonStyles.SHADOW_NONE : ComponentStyles.IOT.shadow)
      .onClick(() => {
        if (this.onButtonClick && !this.loading) {
          this.onButtonClick();
        }
      })
  }
}
