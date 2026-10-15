// 宠物画廊组件
import { CommonStyles } from '../common/css/CommonStyles';
import { Pet } from '../mock/PetData';

@Component
export struct PetGallery {
  @Prop pets: Array<Pet> = [];
  @Prop columns: number = 2;
  // 使用普通属性而不是@Prop，因为@Prop不支持函数类型
  private onPetClick?: (pet: Pet) => void;
  @Prop showStatus: boolean = true;

  build() {
    Grid() {
      ForEach(this.pets, (pet: Pet) => {
        GridItem() {
          Column({ space: CommonStyles.SPACE_SM }) {
            // 宠物图片
            Stack() {
              Image(pet.pics[0] ? $rawfile(pet.pics[0]) : $rawfile('pets/pet_orange_cat_01.jpg'))
                .width('100%')
                .height(120)
                .objectFit(ImageFit.Cover)
                .borderRadius(CommonStyles.RADIUS_MD)

              // 状态标签
              if (this.showStatus) {
                Row() {
                  Text(pet.adoptionStatus === 'available' ? '可领养' : '已预约')
                    .fontSize(CommonStyles.FONT_SIZE_XS)
                    .fontColor(CommonStyles.WHITE)
                    .padding({
                      left: CommonStyles.SPACE_SM,
                      right: CommonStyles.SPACE_SM,
                      top: 2,
                      bottom: 2
                    })
                    .backgroundColor(
                      pet.adoptionStatus === 'available'
                        ? CommonStyles.SUCCESS_COLOR
                        : CommonStyles.WARNING_COLOR
                    )
                    .borderRadius(CommonStyles.RADIUS_SM)
                }
                .position({ x: 8, y: 8 })
              }
            }
            .width('100%')
            .aspectRatio(1.2)

            // 宠物信息
            Column({ space: CommonStyles.SPACE_XS }) {
              // 宠物名称
              Text(pet.name)
                .fontSize(CommonStyles.FONT_SIZE_MD)
                .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
                .fontColor(CommonStyles.TEXT_PRIMARY)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('100%')

              // 宠物类型和年龄
              Row() {
                Text(pet.type)
                  .fontSize(CommonStyles.FONT_SIZE_SM)
                  .fontColor(CommonStyles.TEXT_SECONDARY)

                Text('·')
                  .fontSize(CommonStyles.FONT_SIZE_SM)
                  .fontColor(CommonStyles.TEXT_TERTIARY)
                  .margin({ left: CommonStyles.SPACE_XS, right: CommonStyles.SPACE_XS })

                Text(`${pet.age}岁`)
                  .fontSize(CommonStyles.FONT_SIZE_SM)
                  .fontColor(CommonStyles.TEXT_SECONDARY)
              }
              .width('100%')
            }
            .width('100%')
          }
          .width('100%')
          .padding(CommonStyles.SPACE_SM)
          .backgroundColor(CommonStyles.WHITE)
          .borderRadius(CommonStyles.RADIUS_MD)
          .shadow(CommonStyles.SHADOW_SM)
          .onClick(() => {
            if (this.onPetClick) {
              this.onPetClick(pet);
            }
          })
        }
      })
    }
    .columnsTemplate(`1fr 1fr`)
    .rowsTemplate('auto')
    .columnsGap(CommonStyles.SPACE_MD)
    .rowsGap(CommonStyles.SPACE_MD)
    .width('100%')
  }
}
