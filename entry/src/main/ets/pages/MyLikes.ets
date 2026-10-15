﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿import { RouterHelper, RouteParams } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { AppStore } from '../store/AppStore';
import { getUserLikedPets, Pet } from '../mock/PetData';
import { promptAction } from '@kit.ArkUI';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

@Entry
@Component
struct MyLikes {
  @State private likes: Pet[] = [];
  @State private isLoading: boolean = true;

  aboutToAppear() {
    this.loadLikes();
  }

  loadLikes() {
    this.isLoading = true;

    // 从AppStore获取用户信息
    const store = AppStore.getInstance();
    const state = store.getState();
    const currentUser = state.currentUser;

    if (!currentUser) {
      RouterHelper.replaceUrl("pages/Login");
      return;
    }

    // 模拟加载延迟
    setTimeout(() => {
      this.likes = getUserLikedPets(currentUser.id);
      this.isLoading = false;
    }, 500);
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top']
      }) {
      // 顶部导航
      Row({ space: CommonStyles.SPACE_MD }) {
        // 返回按钮
        BackButton()

        // 标题
        Text('我的点赞')
          .fontSize(CommonStyles.FONT_SIZE_XL)
          .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .padding({
        left: CommonStyles.SPACE_LG,
        right: CommonStyles.SPACE_LG,
        top: CommonStyles.SPACE_XL,
        bottom: CommonStyles.SPACE_LG
      })
      .backgroundColor(CommonStyles.WHITE)

      Scroll() {
        Column({ space: CommonStyles.SPACE_MD }) {
          if (this.isLoading) {
            // 加载中
            Column() {
              LoadingProgress()
                .width(40)
                .height(40)
                .color(CommonStyles.PRIMARY_COLOR)

              Text('加载中...')
                .fontSize(CommonStyles.FONT_SIZE_MD)
                .fontColor(CommonStyles.TEXT_SECONDARY)
                .margin({ top: CommonStyles.SPACE_MD })
            }
            .width('100%')
            .height(300)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
          } else if (this.likes.length === 0) {
            // 空状态
            Column() {
              Text('👍')
                .fontSize(40)
                .fontColor(CommonStyles.TEXT_TERTIARY)

              Text('暂无点赞记录')
                .fontSize(CommonStyles.FONT_SIZE_LG)
                .fontColor(CommonStyles.TEXT_SECONDARY)
                .margin({ bottom: CommonStyles.SPACE_SM })

              Text('快去发现喜欢的宠物并点赞吧！')
                .fontSize(CommonStyles.FONT_SIZE_SM)
                .fontColor(CommonStyles.TEXT_TERTIARY)
            }
            .width('100%')
            .height(300)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
          } else {
            // 点赞列表
            ForEach(this.likes, (pet: Pet) => {
              this.LikeItem(pet)
            })
          }
        }
        .width('100%')
        .padding(CommonStyles.SPACE_LG)
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: '45mm' })
  }

  // 点赞项组件
  @Builder
  LikeItem(pet: Pet) {
    Column({ space: CommonStyles.SPACE_MD }) {
      // 宠物图片
      if (pet.images[0]) {
        Image($rawfile(pet.images[0]))
          .width('100%')
          .height(200)
          .objectFit(ImageFit.Cover)
          .borderRadius(CommonStyles.RADIUS_LG)
      } else {
        Column() {
          Text('暂无图片')
            .fontSize(14)
            .fontColor('#9CA3AF')
        }
        .width('100%')
        .height(200)
        .backgroundColor('#F3F4F6')
        .borderRadius(CommonStyles.RADIUS_LG)
        .justifyContent(FlexAlign.Center)
      }

      // 宠物信息
      Column({ space: CommonStyles.SPACE_XS }) {
        Row() {
          Text(pet.name)
            .fontSize(CommonStyles.FONT_SIZE_LG)
            .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .layoutWeight(1)

          // 点赞状态
          Text('❤️')
            .fontSize(22)
            .fontColor(CommonStyles.DANGER_COLOR)
        }

        Row({ space: CommonStyles.SPACE_MD }) {
          Text(pet.type)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.TEXT_SECONDARY)
            .backgroundColor(CommonStyles.GRAY_100)
            .padding({
              left: CommonStyles.SPACE_SM,
              right: CommonStyles.SPACE_SM,
              top: 2,
              bottom: 2
            })
            .borderRadius(CommonStyles.RADIUS_SM)

          Text(pet.gender)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.TEXT_SECONDARY)
            .backgroundColor(CommonStyles.GRAY_100)
            .padding({
              left: CommonStyles.SPACE_SM,
              right: CommonStyles.SPACE_SM,
              top: 2,
              bottom: 2
            })
            .borderRadius(CommonStyles.RADIUS_SM)

          Text(pet.age.toString())
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.TEXT_SECONDARY)
            .backgroundColor(CommonStyles.GRAY_100)
            .padding({
              left: CommonStyles.SPACE_SM,
              right: CommonStyles.SPACE_SM,
              top: 2,
              bottom: 2
            })
            .borderRadius(CommonStyles.RADIUS_SM)
        }

        Text(pet.description)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.TEXT_SECONDARY)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: CommonStyles.SPACE_XS })

        // 状态标签
        Row() {
          Text(pet.adoptionStatus)
            .fontSize(CommonStyles.FONT_SIZE_XS)
            .fontColor(CommonStyles.WHITE)
            .padding({
              left: CommonStyles.SPACE_SM,
              right: CommonStyles.SPACE_SM,
              top: 2,
              bottom: 2
            })
            .backgroundColor(
              pet.adoptionStatus === 'available' ? CommonStyles.SUCCESS_COLOR :
                pet.adoptionStatus === 'adopted' ? CommonStyles.INFO_COLOR :
                  CommonStyles.WARNING_COLOR
            )
            .borderRadius(CommonStyles.RADIUS_SM)

          // 情绪状态
          if (pet.mood) {
            Text(pet.mood)
              .fontSize(CommonStyles.FONT_SIZE_XS)
              .fontColor(CommonStyles.WHITE)
              .padding({
                left: CommonStyles.SPACE_SM,
                right: CommonStyles.SPACE_SM,
                top: 2,
                bottom: 2
              })
              .backgroundColor(CommonStyles.PRIMARY_COLOR)
              .borderRadius(CommonStyles.RADIUS_SM)
              .margin({ left: CommonStyles.SPACE_SM })
          }
        }
        .margin({ top: CommonStyles.SPACE_SM })
      }
      .width('100%')
    }
    .width('100%')
    .padding(CommonStyles.SPACE_MD)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
    .onClick(() => {
      // 跳转到宠物详情页
      const params: RouteParams = { petId: pet.id.toString() };
      RouterHelper.pushUrl('pages/Detail', params);
    })
  }
}