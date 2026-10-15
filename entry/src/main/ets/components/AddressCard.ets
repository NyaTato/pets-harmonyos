import { CommonStyles } from '../common/css/CommonStyles';

import { Address } from '../mock/UserData';

@Component
export struct AddressCard {
  @Prop address: Address | null = null;
  @Prop isDefault: boolean = false;
  // 使用普通属性而不是@Prop，因为@Prop不支持函数类型
  private onEditClick?: () => void;
  private onDeleteClick?: () => void;
  private onSetDefaultClick?: () => void;

  build() {
    Column({ space: CommonStyles.SPACE_MD }) {
      // 地址头部
      Row() {
        // 收货人信息
        Column({ space: 2 }) {
          Row({ space: CommonStyles.SPACE_SM }) {
            Text(this.address?.name || '')
              .fontSize(CommonStyles.FONT_SIZE_LG)
              .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
              .fontColor(CommonStyles.TEXT_PRIMARY)

            Text(this.address?.phone || '')
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(CommonStyles.TEXT_SECONDARY)
          }

          // 默认地址标签
          if (this.isDefault) {
            Row() {
              Text('默认')
                .fontSize(CommonStyles.FONT_SIZE_XS)
                .fontColor(CommonStyles.WHITE)
                .padding({
                  left: CommonStyles.SPACE_SM,
                  right: CommonStyles.SPACE_SM,
                  top: 2,
                  bottom: 2
                })
                .backgroundColor(CommonStyles.SUCCESS_COLOR)
                .borderRadius(CommonStyles.RADIUS_SM)
            }
            .margin({ top: 4 })
          }
        }
        .layoutWeight(1)

        // 操作按钮
        Row({ space: CommonStyles.SPACE_SM }) {
          // 编辑按钮
          Button('编辑', { type: ButtonType.Normal })
            .width(60)
            .height(28)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.PRIMARY_COLOR)
            .backgroundColor('#00000000')
            .border({
              width: 1,
              color: CommonStyles.PRIMARY_COLOR,
              radius: CommonStyles.RADIUS_SM
            })
            .onClick(() => {
              this.onEditClick?.();
            })

          // 删除按钮
          Button('删除', { type: ButtonType.Normal })
            .width(60)
            .height(28)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.DANGER_COLOR)
            .backgroundColor('#00000000')
            .border({
              width: 1,
              color: CommonStyles.DANGER_COLOR,
              radius: CommonStyles.RADIUS_SM
            })
            .onClick(() => {
              this.onDeleteClick?.();
            })
        }
      }
      .width('100%')

      // 地址内容
      Column({ space: CommonStyles.SPACE_XS }) {
        // 省市区
        Text(`${this.address?.province || ''} ${this.address?.city || ''} ${this.address?.district || ''}`)
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .width('100%')

        // 详细地址
        Text(this.address?.detail || '')
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .width('100%')
          .margin({ top: 4 })
      }
      .width('100%')
      .padding({
        top: CommonStyles.SPACE_SM,
        bottom: CommonStyles.SPACE_SM
      })
      .backgroundColor(CommonStyles.GRAY_100)
      .borderRadius(CommonStyles.RADIUS_MD)

      // 设为默认地址按钮
      if (!this.isDefault) {
        Row() {
          Button({ type: ButtonType.Capsule }) {
          Text('设为默认地址')
        }
            .width('100%')
            .height(36)
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(CommonStyles.PRIMARY_COLOR)
            .backgroundColor('#00000000')
            .border({
              width: 1,
              color: CommonStyles.PRIMARY_COLOR,
              radius: CommonStyles.RADIUS_MD
            })
            .onClick(() => {
              this.onSetDefaultClick?.();
            })
        }
        .width('100%')
      }
    }
    .padding(CommonStyles.SPACE_MD)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_MD)
    .width('100%')
    .margin({ bottom: CommonStyles.SPACE_MD })
  }
}
