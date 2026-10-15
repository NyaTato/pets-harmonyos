/**
 * 沉浸式宠物相册组件
 * 支持3D轮播、手势缩放旋转、全屏查看
 */

import { CommonStyles } from '../common/css/CommonStyles';
import { ImageData } from '../common/types/ComponentTypes';

interface GalleryProps {
  images: string[];
}

@Component
export struct ImmersivePetGallery {
  @Prop images: string[];

  @State private currentIndex: number = 0;
  @State private imageScale: number = 1.0;
  @State private rotation: number = 0;
  @State private offsetX: number = 0;
  @State private offsetY: number = 0;
  @State private isFullscreen: boolean = false;
  @State private showControls: boolean = true;

  // 获取当前图片
  private getCurrentImage(): string {
    return this.images[this.currentIndex] || 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';
  }

  // 下一张图片
  private nextImage(): void {
    this.currentIndex = (this.currentIndex + 1) % this.images.length;
    this.resetTransform();
  }

  // 上一张图片
  private prevImage(): void {
    this.currentIndex = (this.currentIndex - 1 + this.images.length) % this.images.length;
    this.resetTransform();
  }

  // 重置变换
  private resetTransform(): void {
    this.imageScale = 1.0;
    this.rotation = 0;
    this.offsetX = 0;
    this.offsetY = 0;
  }

  // 切换全屏
  private toggleFullscreen(): void {
    this.isFullscreen = !this.isFullscreen;
  }

  // 切换控制面板显示
  private toggleControls(): void {
    this.showControls = !this.showControls;
  }

  // 处理捏合手势
  private handlePinch(event: GestureEvent): void {
    if (event.scale) {
      this.imageScale = Math.max(0.5, Math.min(3, this.imageScale * event.scale));
    }
  }

  // 处理旋转手势
  private handleRotation(event: GestureEvent): void {
    if (event.angle) {
      this.rotation += event.angle;
    }
  }

  // 处理拖动手势
  private handlePan(event: GestureEvent): void {
    if (event.offsetX !== undefined && event.offsetY !== undefined) {
      this.offsetX += event.offsetX;
      this.offsetY += event.offsetY;
    }
  }

  // 双击重置
  private handleDoubleTap(): void {
    this.resetTransform();
  }

  build() {
    Column({ space: CommonStyles.SPACE_MD }) {
      // 标题
      Text('沉浸式宠物相册')
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .margin({ bottom: CommonStyles.SPACE_SM })

      // 画廊容器
      Stack() {
        // 图片显示区域
        Column() {
          // 图片容器
          Stack() {
            // 图片背景
            Row()
              .width('100%')
              .height(300)
              .backgroundColor(CommonStyles.GRAY_100)
              .borderRadius(CommonStyles.RADIUS_LG)

            // 图片
            Image(this.getCurrentImage())
              .width('100%')
              .height(300)
              .objectFit(ImageFit.Contain)
              .scale({ x: this.imageScale, y: this.imageScale })
              .rotate({ angle: this.rotation })
              .translate({ x: this.offsetX, y: this.offsetY })
              .borderRadius(CommonStyles.RADIUS_LG)
          }
          .width('100%')
          .height(300)
          .clip(true)
          .gesture(
            GestureGroup(GestureMode.Parallel,
              PinchGesture({ fingers: 2 })
                .onActionStart((event: GestureEvent) => {
                  this.handlePinch(event);
                })
                .onActionUpdate((event: GestureEvent) => {
                  this.handlePinch(event);
                }),
              RotationGesture({ fingers: 2 })
                .onActionStart((event: GestureEvent) => {
                  this.handleRotation(event);
                })
                .onActionUpdate((event: GestureEvent) => {
                  this.handleRotation(event);
                }),
              PanGesture({ fingers: 1 })
                .onActionStart((event: GestureEvent) => {
                  this.handlePan(event);
                })
                .onActionUpdate((event: GestureEvent) => {
                  this.handlePan(event);
                }),
              TapGesture({ count: 2 })
                .onAction(() => {
                  this.handleDoubleTap();
                })
            )
          )

          // 缩略图导航
          if (this.images.length > 1 && this.showControls) {
            Scroll() {
              Row({ space: CommonStyles.SPACE_SM }) {
                ForEach(this.images, (image: string, index: number) => {
                  Image(image)
                    .width(60)
                    .height(60)
                    .borderRadius(CommonStyles.RADIUS_MD)
                    .objectFit(ImageFit.Cover)
                    .border({
                      width: index === this.currentIndex ? 3 : 1,
                      color: index === this.currentIndex ? CommonStyles.PRIMARY_COLOR : CommonStyles.GRAY_300
                    })
                    .onClick(() => {
                      this.currentIndex = index;
                      this.resetTransform();
                    })
                })
              }
              .padding({ top: CommonStyles.SPACE_SM , bottom: CommonStyles.SPACE_SM  })
            }
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Auto)
            .height(80)
            .margin({ top: CommonStyles.SPACE_MD })
          }
        }

        // 控制按钮（右上角）
        if (this.showControls) {
          Row({ space: CommonStyles.SPACE_SM }) {
            Button('全屏', { type: ButtonType.Normal })
              .width(60)
              .height(32)
              .backgroundColor(Color.Black)
              .opacity(0.7)
              .fontColor(Color.White)
              .fontSize(CommonStyles.FONT_SIZE_XS)
              .onClick(() => {
                this.toggleFullscreen();
              })

            Button('重置', { type: ButtonType.Normal })
              .width(60)
              .height(32)
              .backgroundColor(Color.Black)
              .opacity(0.7)
              .fontColor(Color.White)
              .fontSize(CommonStyles.FONT_SIZE_XS)
              .onClick(() => {
                this.resetTransform();
              })
          }
          .position({ x: '85%', y: 16 })
        }
      }
      .width('100%')
      .padding(CommonStyles.SPACE_MD)
      .backgroundColor(CommonStyles.BG_LIGHT)
      .borderRadius(CommonStyles.RADIUS_LG)

      // 控制面板
      if (this.showControls) {
        Column({ space: CommonStyles.SPACE_SM }) {
          // 图片信息
          Row({ space: CommonStyles.SPACE_SM }) {
            Text(`图片 ${this.currentIndex + 1}/${this.images.length}`)
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(CommonStyles.TEXT_PRIMARY)
              .fontWeight(FontWeight.Medium)

            Text(`缩放: ${this.imageScale.toFixed(1)}x`)
              .fontSize(CommonStyles.FONT_SIZE_XS)
              .fontColor(CommonStyles.TEXT_SECONDARY)

            Text(`旋转: ${Math.round(this.rotation)}°`)
              .fontSize(CommonStyles.FONT_SIZE_XS)
              .fontColor(CommonStyles.TEXT_SECONDARY)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          // 缩放控制
          Row({ space: CommonStyles.SPACE_SM }) {
            Button('-', { type: ButtonType.Normal })
              .width(40)
              .height(32)
              .backgroundColor(CommonStyles.GRAY_200)
              .fontColor(CommonStyles.TEXT_PRIMARY)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .onClick(() => {
                this.imageScale = Math.max(0.5, this.imageScale - 0.2);
              })

            Slider({
              value: this.imageScale,
              min: 0.5,
              max: 3.0,
              step: 0.1,
              style: SliderStyle.OutSet
            })
            .flexGrow(1)
            .onChange((value: number) => {
              this.imageScale = value;
            })

            Button('+', { type: ButtonType.Normal })
              .width(40)
              .height(32)
              .backgroundColor(CommonStyles.GRAY_200)
              .fontColor(CommonStyles.TEXT_PRIMARY)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .onClick(() => {
                this.imageScale = Math.min(3.0, this.imageScale + 0.2);
              })
          }

          // 旋转控制
          Row({ space: CommonStyles.SPACE_SM }) {
            Button('←', { type: ButtonType.Normal })
              .width(40)
              .height(32)
              .backgroundColor(CommonStyles.GRAY_200)
              .fontColor(CommonStyles.TEXT_PRIMARY)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .onClick(() => {
                this.rotation -= 15;
              })

            Slider({
              value: (this.rotation % 360 + 360) % 360,
              min: 0,
              max: 360,
              step: 15,
              style: SliderStyle.OutSet
            })
            .flexGrow(1)
            .onChange((value: number) => {
              this.rotation = value;
            })

            Button('→', { type: ButtonType.Normal })
              .width(40)
              .height(32)
              .backgroundColor(CommonStyles.GRAY_200)
              .fontColor(CommonStyles.TEXT_PRIMARY)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .onClick(() => {
                this.rotation += 15;
              })
          }

          // 导航按钮
          Row({ space: CommonStyles.SPACE_MD }) {
            Button('上一张', { type: ButtonType.Normal })
              .flexGrow(1)
              .height(40)
              .backgroundColor(CommonStyles.PRIMARY_COLOR)
              .fontColor(Color.White)
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .onClick(() => {
                this.prevImage();
              })

            Button('下一张', { type: ButtonType.Normal })
              .flexGrow(1)
              .height(40)
              .backgroundColor(CommonStyles.PRIMARY_COLOR)
              .fontColor(Color.White)
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .onClick(() => {
                this.nextImage();
              })
          }
          .width('100%')
          .margin({ top: CommonStyles.SPACE_SM })
        }
        .width('100%')
        .padding(CommonStyles.SPACE_MD)
        .backgroundColor(CommonStyles.GRAY_100)
        .borderRadius(CommonStyles.RADIUS_MD)
      }

      // 操作提示
      Row({ space: CommonStyles.SPACE_SM }) {
        Text('💡 操作提示:')
          .fontSize(CommonStyles.FONT_SIZE_XS)
          .fontColor(CommonStyles.TEXT_SECONDARY)

        Text('双指缩放·双指旋转·单指拖动·双击重置')
          .fontSize(CommonStyles.FONT_SIZE_XS)
          .fontColor(CommonStyles.TEXT_TERTIARY)
          .flexGrow(1)

        Button(this.showControls ? '隐藏控制' : '显示控制', { type: ButtonType.Normal })
          .height(24)
          .backgroundColor(CommonStyles.GRAY_200)
          .fontColor(CommonStyles.TEXT_SECONDARY)
          .fontSize(CommonStyles.FONT_SIZE_XS)
          .onClick(() => {
            this.toggleControls();
          })
      }
      .width('100%')
      .padding({ top: CommonStyles.SPACE_SM, bottom: CommonStyles.SPACE_SM, left: CommonStyles.SPACE_MD, right: CommonStyles.SPACE_MD })
      .backgroundColor(CommonStyles.GRAY_100)
      .borderRadius(CommonStyles.RADIUS_MD)
    }
    .width('100%')
    .padding(CommonStyles.SPACE_LG)
    .backgroundColor(Color.White)
    .borderRadius(CommonStyles.RADIUS_LG)
    .border({ width: 1, color: CommonStyles.GRAY_300 })
  }
}
