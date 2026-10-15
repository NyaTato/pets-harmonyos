import { RouterHelper } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { getUserAddresses, Address as UserAddress } from '../mock/UserData';
import { AppStore } from '../store/AppStore';
import { promptAction } from '@kit.ArkUI';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

@Entry
@Component
struct AddressList {
  @State private addresses: UserAddress[] = [];
  @State private isLoading: boolean = true;

  aboutToAppear() {
    this.loadAddresses();
  }

  loadAddresses() {
    this.isLoading = true;

    const store = AppStore.getInstance();
    const state = store.getState();

    if (state.currentUser) {
      const currentUser = state.currentUser;
      setTimeout(() => {
        this.addresses = getUserAddresses(currentUser.id);
        this.isLoading = false;
      }, 500);
    } else {
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top', 'bottom']
      }) {
        Column() {
          this.NavigationBar()

          Scroll() {
            Column({ space: CommonStyles.LG }) {
              this.LoadingContent()
              this.EmptyContent()
              this.AddressListContent()
            }
            .padding({ left: CommonStyles.LG, right: CommonStyles.LG, bottom: CommonStyles.SPACE_3XL })
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)
          .layoutWeight(1)

          this.AddButton()
        }
        .width('100%')
        .height('100%')
        .backgroundColor(CommonStyles.COLOR_BG)
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: '45mm' })
  }@Builder NavigationBar() {
    Row() {
      BackButton()

      Text('地址管理')
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Row()
        .width(CommonStyles.ICON_SIZE_TOUCH)
    }
    .width('100%')
    .padding({ left: CommonStyles.LG, right: CommonStyles.LG, top: CommonStyles.SM, bottom: CommonStyles.SM })
  }

  @Builder LoadingContent() {
    Column() {
      LoadingProgress()
        .color(CommonStyles.PRIMARY)
        .width(CommonStyles.SIZE_XL)
        .height(CommonStyles.SIZE_XL)

      Text('加载中...')
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .margin({ top: CommonStyles.MD })
    }
    .width('100%')
    .height(CommonStyles.SIZE_2XL)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .visibility(this.isLoading ? Visibility.Visible : Visibility.None)
  }

  @Builder EmptyContent() {
    Column() {
      Text('📍')
        .fontSize(64)

      Text('暂无地址')
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .margin({ top: CommonStyles.LG })

      Text('点击下方按钮添加收货地址 ➕')
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .margin({ top: CommonStyles.XS })

      Button('添加地址', { type: ButtonType.Capsule })
        .width(CommonStyles.BUTTON_WIDTH_LG)
        .height(CommonStyles.BUTTON_HEIGHT_LG)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.WHITE)
        .backgroundColor(CommonStyles.PRIMARY)
        .borderRadius(CommonStyles.RADIUS_FULL)
        .shadow(CommonStyles.SHADOW_BRAND_OLD)
        .margin({ top: CommonStyles.XL })
        .onClick(() => {
          this.addNewAddress();
        })
    }
    .width('100%')
    .height(CommonStyles.SIZE_2XL)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .visibility((!this.isLoading && this.addresses.length === 0) ? Visibility.Visible : Visibility.None)
  }

  @Builder AddressListContent() {
    Column({ space: CommonStyles.MD }) {
      ForEach(this.addresses, (address: UserAddress) => {
        this.AddressCard(address)
      })
    }
    .width('100%')
    .visibility((!this.isLoading && this.addresses.length > 0) ? Visibility.Visible : Visibility.None)
  }

  @Builder AddressCard(address: UserAddress) {
    Column({ space: CommonStyles.MD }) {
      Row() {
        Column({ space: CommonStyles.XS }) {
          Row({ space: CommonStyles.SM }) {
            Text(address.name)
              .fontSize(CommonStyles.FONT_SIZE_LG)
              .fontWeight(FontWeight.Medium)
              .fontColor(CommonStyles.TEXT_PRIMARY)

            Text(address.phone || '')
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(CommonStyles.TEXT_SECONDARY)

            if (address.isDefault) {
              Text('⭐ 默认')
                .fontSize(CommonStyles.FONT_SIZE_SM)
                .fontWeight(FontWeight.Medium)
                .fontColor(CommonStyles.WHITE)
                .padding({ left: CommonStyles.SM, right: CommonStyles.SM, top: CommonStyles.XS, bottom: CommonStyles.XS })
                .backgroundColor(CommonStyles.SECONDARY)
                .borderRadius(CommonStyles.RADIUS_FULL)
                .margin({ left: CommonStyles.SM })
            }
          }
          .width('100%')

          Text(`${address.province}${address.city}${address.district}${address.detail}`)
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(CommonStyles.TEXT_SECONDARY)
            .lineHeight(20)
            .width('100%')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Column({ space: CommonStyles.XS }) {
          Row() {
            Text('✏️')
              .fontSize(CommonStyles.FONT_SIZE_MD)
          }
          .width(CommonStyles.ICON_SIZE_TOUCH - 10)
          .height(CommonStyles.ICON_SIZE_TOUCH - 10)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(CommonStyles.GRAY_100)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .onClick(() => {
            this.editAddress(address);
          })

          Row() {
            Text('🗑️')
              .fontSize(CommonStyles.FONT_SIZE_MD)
          }
          .width(CommonStyles.ICON_SIZE_TOUCH - 10)
          .height(CommonStyles.ICON_SIZE_TOUCH - 10)
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#FEE2E2')
          .borderRadius(CommonStyles.RADIUS_FULL)
          .onClick(() => {
            this.deleteAddress(address.id);
          })
        }
      }
      .width('100%')

      if (!address.isDefault) {
        Button('设为默认地址 ⭐', { type: ButtonType.Normal })
          .width('100%')
          .height(CommonStyles.BUTTON_HEIGHT_SM)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.SECONDARY)
          .backgroundColor('#FFF7ED')
          .borderWidth(1)
          .borderColor(CommonStyles.SECONDARY + '40')
          .borderRadius(CommonStyles.RADIUS_FULL)
          .onClick(() => {
            this.setDefaultAddress(address.id);
          })
      }
    }
    .width('100%')
    .padding(CommonStyles.LG)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  @Builder AddButton() {
    Column() {
      Button('添加新地址', { type: ButtonType.Capsule })
        .width('100%')
        .height(CommonStyles.BUTTON_HEIGHT_XL)
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.WHITE)
        .backgroundColor(CommonStyles.PRIMARY)
        .borderRadius(CommonStyles.RADIUS_FULL)
        .shadow(CommonStyles.SHADOW_BRAND_OLD)
        .onClick(() => {
          this.addNewAddress();
        })
    }
    .width('100%')
    .padding({ left: CommonStyles.LG, right: CommonStyles.LG, top: CommonStyles.MD, bottom: CommonStyles.LG })
    .backgroundColor(CommonStyles.WHITE)
    .shadow(CommonStyles.SHADOW_MD)
    .visibility((!this.isLoading && this.addresses.length > 0) ? Visibility.Visible : Visibility.None)
  }

  private setDefaultAddress(addressId: number) {
    this.addresses = this.addresses.map((address: UserAddress): UserAddress => ({
      id: address.id,
      userId: address.userId,
      name: address.name,
      phone: address.phone,
      province: address.province,
      city: address.city,
      district: address.district,
      detail: address.detail,
      isDefault: address.id === addressId
    }));

    this.showToast('✓ 已设为默认地址');
  }

  private editAddress(address: UserAddress) {
    this.showToast(`✏️ 编辑地址：${address.name}`);
  }

  private deleteAddress(addressId: number) {
    promptAction.showDialog({
      title: '⚠️ 确认删除',
      message: '确定要删除此地址？删除后无法恢复！',
      buttons: [
        { text: '取消', color: CommonStyles.TEXT_TERTIARY },
        { text: '删除', color: CommonStyles.DANGER }
      ]
    }).then((result: promptAction.ShowDialogSuccessResponse) => {
      if (result.index === 1) {
        this.addresses = this.addresses.filter(addr => addr.id !== addressId);
        this.showToast('🗑️ 地址已删除');
      }
    }).catch(() => {
      this.showToast('操作已取消');
    });
  }

  private addNewAddress() {
    const newAddress: UserAddress = {
      id: Date.now(),
      userId: 1,
      name: '新地址',
      phone: '138****8888',
      province: '请选择省',
      city: '请选择市',
      district: '请选择区',
      detail: '请填写详细地址',
      isDefault: this.addresses.length === 0
    };

    this.addresses = [newAddress, ...this.addresses];
    promptAction.showToast({
      message: '地址已添加，请前往编辑详细信息',
      duration: 2500
    });
  }

  private showToast(message: string) {
    promptAction.showToast({
      message: message,
      duration: 2000
    });
  }
}
