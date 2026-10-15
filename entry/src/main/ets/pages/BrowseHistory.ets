﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿import { CommonStyles } from '../common/css/CommonStyles';
import { AppStore } from '../store/AppStore';
import { Pet } from '../mock/PetData';
import { promptAction } from '@kit.ArkUI';
import { RouterHelper, RouteParams } from '../router/RouterHelper';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';


// 临时获取浏览历史函数
function getBrowseHistory(userId: number): Pet[] {
  return [];
}

// HistoryItem组件的props接口
interface HistoryItemProps {
  pet: Pet;
}

// ToastOptions接口
interface ToastOptions {
  message: string;
  duration?: number;
}

// TextOverflowOptions接口
interface TextOverflowOptions {
  overflow: TextOverflow;
}





// BorderOptions接口
interface BorderOptions {
  width: number;
  color: string;
  radius: number;
  style: number;
}

@Entry
@Component
struct BrowseHistory {
  @State private history: Pet[] = [];
  @State private isLoading: boolean = true;
  @State private historyCount: number = 0;

  aboutToAppear() {
    this.loadHistory();
  }

  loadHistory() {
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
      this.history = getBrowseHistory(currentUser.id);
      this.isLoading = false;
    }, 500);
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top']
      }) {
        Column() {
          // 顶部导航
      Row({ space: CommonStyles.SPACE_MD }) {
        // 返回按钮
        BackButton()

        // 标题
        Text('浏览记录')
          .fontSize(CommonStyles.FONT_SIZE_XL)
          .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .layoutWeight(1)

        // 清空按钮
        if (this.history.length > 0) {
          Button('清空', { type: ButtonType.Normal })
            .width(60)
            .height(32)
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(CommonStyles.DANGER_COLOR)
            .backgroundColor('#00000000')
            .border({
              width: 1,
              color: CommonStyles.DANGER_COLOR,
              radius: CommonStyles.RADIUS_MD,
              style: 0
            } as BorderOptions)
            .onClick(() => {
              this.clearHistory();
            })
        }
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

      // 浏览记录列表
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
          } else if (this.history.length === 0) {
            // 无数据
            Column() {
              Text('🕐')
                .fontSize(40)
                .fontColor(CommonStyles.TEXT_TERTIARY)

              Text('暂无浏览记录')
                .fontSize(CommonStyles.FONT_SIZE_LG)
                .fontColor(CommonStyles.TEXT_SECONDARY)
                .margin({ bottom: CommonStyles.SPACE_SM })

              Text('快去浏览你喜欢的宠物吧')
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
            // 浏览记录列表
            ForEach(this.history, (pet: Pet): void => {
              this.HistoryItem({ pet: pet } as HistoryItemProps, (petId: number): void => { this.removeFromHistory(petId) })
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
        .width('100%')
        .height('100%')
        .padding({ top: '45mm' })
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  HistoryItem(props: HistoryItemProps, removeCallback: (petId: number) => void) {
    Row({ space: CommonStyles.SPACE_MD }) {
      // 宠物图片
      if (props.pet.images[0]) {
        Image($rawfile(props.pet.images[0]))
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
          Text(props.pet.name)
            .fontSize(CommonStyles.FONT_SIZE_LG)
            .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
            .fontColor(CommonStyles.TEXT_PRIMARY)

          Text(props.pet.gender === 'male' ? '♂' : '♀')
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(props.pet.gender === 'male' ? CommonStyles.PRIMARY_COLOR : CommonStyles.WARNING_COLOR)
        }

        Text(`${props.pet.breed} · ${props.pet.age}岁`)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.TEXT_SECONDARY)

        Text(props.pet.location)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.TEXT_TERTIARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis } as TextOverflowOptions)

        // 浏览时间
        Text('2小时前')
          .fontSize(CommonStyles.FONT_SIZE_XS)
          .fontColor(CommonStyles.TEXT_TERTIARY)
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
            radius: CommonStyles.RADIUS_SM,
            style: 0
          } as BorderOptions)
          .onClick(() => {
            const params: RouteParams = { petId: props.pet.id.toString() };
            RouterHelper.pushUrl("pages/PetDetail", params);
          })

        Button('删除', { type: ButtonType.Normal })
          .width(60)
          .height(28)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.DANGER_COLOR)
          .backgroundColor('#00000000')
          .border({
            width: 1,
            color: CommonStyles.DANGER_COLOR,
            radius: CommonStyles.RADIUS_SM,
            style: 0
          } as BorderOptions)
          .onClick(() => {
            removeCallback(props.pet.id);
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

  private removeFromHistory(petId: number) {
    const index = this.history.findIndex((item: Pet) => item.id === petId);
    if (index > -1) {
      this.history.splice(index, 1);
      this.historyCount--;
      this.showToast('记录已删除');
    }
  }

  private clearHistory() {
    this.history = [];
    this.historyCount = 0;
    this.showToast('浏览记录已清空');
  }

  private showToast(message: string) {
    promptAction.showToast({
      message: message,
      duration: 2000
    } as ToastOptions);
  }
}