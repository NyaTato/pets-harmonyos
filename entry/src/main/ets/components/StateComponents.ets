import { CommonStyles } from '../common/css/CommonStyles';

@Component
export struct EmptyState {
  @Prop icon: string = '📭';
  @Prop title: string = '暂无数据';
  @Prop description: string = '';
  @Prop actionText: string = '';
  @Prop onAction?: () => void;
  @Prop module?: 'ar' | 'ai' | 'iot' | 'default' = 'default';

  build() {
    Column({ space: CommonStyles.LG }) {
      // 图标区域 - 带动画效果
      Stack() {
        // 背景圆圈
        Circle()
          .width(100)
          .height(100)
          .fill(this.getModuleBgColor())

        // 图标
        Text(this.icon)
          .fontSize(48)
      }
      .margin({ bottom: CommonStyles.SM })

      // 文字信息区域
      Column({ space: CommonStyles.SM }) {
        Text(this.title)
          .fontSize(CommonStyles.FONT_SIZE_H3)
          .fontWeight(CommonStyles.FONT_WEIGHT_SEMIBOLD)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        if (this.description) {
          Text(this.description)
            .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
            .fontColor(CommonStyles.TEXT_TERTIARY)
            .textAlign(TextAlign.Center)
            .lineHeight(CommonStyles.LINE_HEIGHT_RELAXED)
            .width('80%')
        }
      }

      // 操作按钮
      if (this.actionText && this.onAction) {
        Button(this.actionText, { type: ButtonType.Capsule, stateEffect: true })
          .height(CommonStyles.BUTTON_HEIGHT_SM)
          .fontSize(CommonStyles.FONT_SIZE_BODY)
          .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
          .fontColor(CommonStyles.WHITE)
          .backgroundColor(CommonStyles.getThemeColor(this.module))
          .borderRadius(CommonStyles.RADIUS_FULL)
          .shadow(CommonStyles.SHADOW_SM)
          .margin({ top: CommonStyles.MD })
          .onClick(() => {
            if (this.onAction) {
              this.onAction();
            }
          })
      }
    }
    .width('100%')
    .padding({ top: 80, bottom: 60 })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  private getModuleBgColor(): string {
    switch (this.module) {
      case 'ar':
        return CommonStyles.AR_BG;
      case 'ai':
        return CommonStyles.PRIMARY_BG;
      case 'iot':
        return CommonStyles.IOT_BG;
      default:
        return CommonStyles.BG_SURFACE;
    }
  }
}

@Component
export struct LoadingState {
  @Prop message: string = '加载中...';
  @Prop showProgress: boolean = true;
  @Prop module?: 'ar' | 'ai' | 'iot' | 'default' = 'default';

  build() {
    Column({ space: CommonStyles.MD }) {
      if (this.showProgress) {
        // 加载动画
        LoadingProgress()
          .width(40)
          .height(40)
          .color(CommonStyles.getThemeColor(this.module))
          .animation({
            duration: CommonStyles.ANIMATION_SLOW,
            iterations: -1,
            curve: Curve.EaseInOut
          })
      }

      // 加载文字
      Text(this.message)
        .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
        .fontColor(CommonStyles.TEXT_TERTIARY)

      // 可选：加载提示
      Text('请稍候...')
        .fontSize(CommonStyles.FONT_SIZE_CAPTION)
        .fontColor(CommonStyles.TEXT_DISABLED)
        .margin({ top: CommonStyles.XS })
    }
    .width('100%')
    .padding({ top: 120, bottom: 60 })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}

@Component
export struct ErrorState {
  @Prop icon: string = '⚠️';
  @Prop title: string = '出错了';
  @Prop description: string = '发生了未知错误，请稍后重试';
  @Prop retryText: string = '重试';
  @Prop onRetry?: () => void;

  build() {
    Column({ space: CommonStyles.LG }) {
      // 错误图标
      Stack() {
        Circle()
          .width(90)
          .height(90)
          .fill(CommonStyles.DANGER_BG)

        Text(this.icon)
          .fontSize(42)
      }

      // 错误信息
      Column({ space: CommonStyles.SM }) {
        Text(this.title)
          .fontSize(CommonStyles.FONT_SIZE_H3)
          .fontWeight(CommonStyles.FONT_WEIGHT_SEMIBOLD)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Text(this.description)
          .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
          .fontColor(CommonStyles.TEXT_TERTIARY)
          .textAlign(TextAlign.Center)
          .lineHeight(CommonStyles.LINE_HEIGHT_RELAXED)
          .width('80%')
      }

      // 重试按钮
      if (this.onRetry) {
        Button(this.retryText, { type: ButtonType.Capsule, stateEffect: true })
          .height(CommonStyles.BUTTON_HEIGHT_SM)
          .fontSize(CommonStyles.FONT_SIZE_BODY)
          .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
          .fontColor(CommonStyles.WHITE)
          .backgroundColor(CommonStyles.DANGER)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .shadow(CommonStyles.SHADOW_SM)
          .margin({ top: CommonStyles.MD })
          .onClick(() => {
            this.onRetry?.();
          })
      }
    }
    .width('100%')
    .padding({ top: 80, bottom: 60 })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}

@Component
export struct TipState {
  @Prop icon: string = '💡';
  @Prop title: string = '温馨提示';
  @Prop content: string = '';
  @Prop type?: 'info' | 'success' | 'warning' | 'error' = 'info';
  @Prop onClose?: () => void;
  @Prop showClose: boolean = false;

  build() {
    Row({ space: CommonStyles.MD }) {
      // 图标
      Text(this.getTipIcon())
        .fontSize(20)
        .margin({ top: 2 })

      // 内容区域
      Column({ space: CommonStyles.XS }) {
        Row() {
          Text(this.title)
            .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
            .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
            .fontColor(this.getTitleColor())
            .layoutWeight(1)

          if (this.showClose && this.onClose) {
            Text('✕')
              .fontSize(16)
              .fontColor(CommonStyles.TEXT_DISABLED)
              .onClick(() => {
                this.onClose?.();
              })
          }
        }

        if (this.content) {
          Text(this.content)
            .fontSize(CommonStyles.FONT_SIZE_CAPTION)
            .fontColor(this.getContentColor())
            .lineHeight(CommonStyles.LINE_HEIGHT_RELAXED)
            .width('100%')
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(CommonStyles.MD)
    .borderRadius(CommonStyles.RADIUS_MD)
    .backgroundColor(this.getBackgroundColor())
    .border({
      width: 1,
      color: this.getBorderColor(),
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_MD
    })
  }

  private getTipIcon(): string {
    if (this.icon !== '💡') {
      return this.icon;
    }
    switch (this.type) {
      case 'success': return '✅';
      case 'warning': return '⚠️';
      case 'error': return '❌';
      default: return '💡';
    }
  }

  private getTitleColor(): string {
    switch (this.type) {
      case 'success': return CommonStyles.SUCCESS;
      case 'warning': return CommonStyles.WARNING;
      case 'error': return CommonStyles.DANGER;
      default: return CommonStyles.INFO;
    }
  }

  private getContentColor(): string {
    switch (this.type) {
      case 'success': return '#065F46';
      case 'warning': return '#92400E';
      case 'error': return '#991B1B';
      default: return '#1E40AF';
    }
  }

  private getBackgroundColor(): string {
    switch (this.type) {
      case 'success': return CommonStyles.SUCCESS_BG;
      case 'warning': return CommonStyles.WARNING_BG;
      case 'error': return CommonStyles.DANGER_BG;
      default: return CommonStyles.INFO_BG;
    }
  }

  private getBorderColor(): string {
    switch (this.type) {
      case 'success': return CommonStyles.SUCCESS_LIGHT;
      case 'warning': return CommonStyles.WARNING_LIGHT;
      case 'error': return CommonStyles.DANGER_LIGHT;
      default: return CommonStyles.INFO_LIGHT;
    }
  }
}

@Component
export struct InlineLoading {
  @Prop message?: string;
  @Prop size?: 'small' | 'medium' | 'large' = 'small';

  build() {
    Row({ space: CommonStyles.SM }) {
      LoadingProgress()
        .width(this.getSize())
        .height(this.getSize())
        .color(CommonStyles.PRIMARY)

      if (this.message) {
        Text(this.message)
          .fontSize(CommonStyles.FONT_SIZE_CAPTION)
          .fontColor(CommonStyles.TEXT_TERTIARY)
      }
    }
    .padding(CommonStyles.SM)
    .alignItems(VerticalAlign.Center)
  }

  private getSize(): number {
    switch (this.size) {
      case 'small': return 16;
      case 'medium': return 24;
      case 'large': return 32;
      default: return 16;
    }
  }
}
