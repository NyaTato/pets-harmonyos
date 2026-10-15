﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿import { RouterHelper } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { AppStore } from '../store/AppStore';
import { getUserFavoritePets, Pet } from '../mock/PetData';
import { hasFavoritedPet, addFavoriteRecord } from '../mock/InteractionData';
import { promptAction } from '@kit.ArkUI';
import { RouteParams } from '../router/RouterHelper';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

@Entry
@Component
struct MyFavorites {
  @State private favorites: Pet[] = [];
  @State private isLoading: boolean = true;

  aboutToAppear() {
    this.loadFavorites();
  }

  // 从详情页返回时重新加载，保持列表与互动记录一致
  onPageShow(): void {
    this.loadFavorites();
  }

  loadFavorites() {
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
      this.favorites = getUserFavoritePets(currentUser.id);
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
        Text('我的收藏')
          .fontSize(CommonStyles.FONT_SIZE_XL)
          .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .layoutWeight(1)
      }
      .width('100%')
      .padding({
        left: CommonStyles.SPACE_LG,
        right: CommonStyles.SPACE_LG,
        top: CommonStyles.SPACE_XL,
        bottom: CommonStyles.SPACE_LG
      })
      .backgroundColor(CommonStyles.WHITE)
      .shadow(CommonStyles.SHADOW_SM)

      // 收藏列表
      Scroll() {
        Column({ space: CommonStyles.SPACE_MD }) {
          if (this.isLoading) {
            // 加载中
            Column() {
              LoadingProgress()
                .color($r('app.color.primary'))
                .width(50)
                .height(50)
                .margin({ top: CommonStyles.SPACE_4XL })

              Text('加载中...')
                .fontSize(CommonStyles.FONT_SIZE_MD)
                .fontColor(CommonStyles.TEXT_SECONDARY)
                .margin({ top: CommonStyles.SPACE_LG })
            }
            .width('100%')
            .height(300)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
          } else if (this.favorites.length === 0) {
            // 无数据
            Column() {
              Text('❤️')
                .fontSize(40)
                .fontColor(CommonStyles.TEXT_TERTIARY)

              Text('暂无收藏')
                .fontSize(CommonStyles.FONT_SIZE_LG)
                .fontColor(CommonStyles.TEXT_SECONDARY)
                .margin({ bottom: CommonStyles.SPACE_SM })

              Text('快去发现你喜欢的宠物吧')
                .fontSize(CommonStyles.FONT_SIZE_MD)
                .fontColor(CommonStyles.TEXT_TERTIARY)

              Button({ type: ButtonType.Capsule }) {
                Text('去逛逛')
              }
              .width(120)
              .height(40)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(CommonStyles.WHITE)
              .backgroundColor(CommonStyles.PRIMARY_COLOR)
              .margin({ top: CommonStyles.SPACE_LG })
              .onClick(() => {
                RouterHelper.pushUrl("pages/PetList");
              })
            }
            .width('100%')
            .height(400)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
          } else {
            // 收藏列表
            ForEach(this.favorites, (pet: Pet) => {
              this.FavoriteItem(pet)
            })
          }
        }
        .width('100%')
        .padding({
          left: CommonStyles.SPACE_LG,
          right: CommonStyles.SPACE_LG,
          top: CommonStyles.SPACE_MD,
          bottom: CommonStyles.SPACE_2XL
        })
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

  // 收藏项组件
  @Builder
  FavoriteItem(pet: Pet) {
    Row({ space: CommonStyles.SPACE_MD }) {
      // 宠物图片
      if (pet.images[0]) {
        Image($rawfile(pet.images[0]))
          .width(80)
          .height(80)
          .borderRadius(CommonStyles.RADIUS_MD)
          .objectFit(ImageFit.Cover)
      } else {
        Column() {
          Text('图')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#D1D5DB')
        }
        .width(80)
        .height(80)
        .backgroundColor('#F3F4F6')
        .borderRadius(CommonStyles.RADIUS_MD)
        .justifyContent(FlexAlign.Center)
      }

      // 宠物信息
      Column({ space: CommonStyles.SPACE_XS }) {
        Row({ space: CommonStyles.SPACE_SM }) {
          Text(pet.name)
            .fontSize(CommonStyles.FONT_SIZE_LG)
            .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
            .fontColor(CommonStyles.TEXT_PRIMARY)

          Text(pet.gender === 'male' ? '♂' : '♀')
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(pet.gender === 'male' ? CommonStyles.PRIMARY_COLOR : CommonStyles.WARNING_COLOR)
        }

        Text(`${pet.breed} · ${pet.age}岁`)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.TEXT_SECONDARY)

        Text(pet.location)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.TEXT_TERTIARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)

      // 操作按钮
      Column({ space: CommonStyles.SPACE_XS }) {
        Button('查看', { type: ButtonType.Normal })
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
            const params: RouteParams = { petId: pet.id.toString() };
            RouterHelper.pushUrl("pages/Detail", params);
          })

        Button('取消收藏', { type: ButtonType.Normal })
          .width(80)
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
            this.removeFavorite(pet.id);
          })
      }
    }
    .width('100%')
    .padding(CommonStyles.SPACE_MD)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_MD)
    .margin({ bottom: CommonStyles.SPACE_MD })
  }

  private removeFavorite(petId: number) {
    const currentUser = AppStore.getInstance().getState().currentUser;
    if (!currentUser) {
      RouterHelper.replaceUrl("pages/Login");
      return;
    }

    // 仅当该用户确实收藏了这只宠物时才取消
    if (!hasFavoritedPet(currentUser.id, petId)) {
      return;
    }

    addFavoriteRecord(currentUser.id, petId);
    // 以互动记录重建列表，避免局部状态与数据源不一致
    this.favorites = getUserFavoritePets(currentUser.id);

    promptAction.showToast({
      message: '已取消收藏',
      duration: 2000
    });
  }

  private showToast(message: string) {
    promptAction.showToast({
      message: message,
      duration: 2000
    });
  }
}