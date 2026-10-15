import { RouterHelper, RouteParams } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { getPetById, Pet } from '../mock/PetData';
import { createApply, ApplyData } from '../mock/ApplyData';
import { getUserAddresses, Address } from '../mock/UserData';
import { AppStore, AppState } from '../store/AppStore';
import { promptAction } from '@kit.ArkUI';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';
import { AppIcon } from '../components/AppIcon';

interface ApplyFormData {
  name: string;
  phone: string;
  email: string;
  address: string;
  housingType: string;
  hasYard: boolean;
  petAllowed: boolean;
  experience: string;
  reason: string;
  agreeTerms: boolean;
}

@Entry
@Component
struct Apply {
  @State private pet: Pet | null = null;
  @State private isLoading: boolean = true;
  @State private formData: ApplyFormData = {
    name: '',
    phone: '',
    email: '',
    address: '',
    housingType: '',
    hasYard: false,
    petAllowed: false,
    experience: '',
    reason: '',
    agreeTerms: false
  };
  @State private isSubmitting: boolean = false;
  @State private errorMessage: string = '';
  @State private showAddressDialog: boolean = false;
  @State private addresses: Address[] = [];
  @State private selectedAddress: Address | null = null;

  aboutToAppear() {
    const params = RouterHelper.getParams();
    const petId = params.petId ? parseInt(params.petId) : 1;
    this.loadPet(petId);

    const store = AppStore.getInstance();
    const state: AppState = store.getState();
    if (state.currentUser) {
      this.formData.name = state.currentUser.nickname || '';
      this.formData.phone = state.currentUser.phone || '';
      this.loadUserAddresses(state.currentUser.id);
    }
  }

  loadUserAddresses(userId: number) {
    const addresses = getUserAddresses(userId);
    this.addresses = addresses;

    const defaultAddress = addresses.find(addr => addr.isDefault);
    if (defaultAddress) {
      this.selectedAddress = defaultAddress;
      this.formData.address = this.formatAddress(defaultAddress);
    }
  }

  formatAddress(address: Address): string {
    return `${address.province}${address.city}${address.district}${address.detail}`;
  }

  loadPet(petId: number) {
    this.isLoading = true;
    const self = this;
    setTimeout(() => {
      self.pet = getPetById(petId);
      self.isLoading = false;
    }, 500);
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top', 'bottom']
      }) {
        Column() {
          this.NavigationBar()

          Scroll() {
            Column({ space: CommonStyles.SPACE_XL }) {
              this.LoadingContent()
              this.ErrorContent()
              this.MainContent()
            }
            .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG, bottom: CommonStyles.SPACE_3XL })
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)
          .layoutWeight(1)

          this.BottomCTA()
        }
        .width('100%')
        .height('100%')
        .backgroundColor(CommonStyles.COLOR_BG)
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: '45mm' })
  }

  @Builder NavigationBar() {
    Row() {
      BackButton()

      Text('领养申请表单')
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Row()
        .width(CommonStyles.ICON_SIZE_TOUCH)
    }
    .width('100%')
    .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG, top: CommonStyles.SPACE_SM, bottom: CommonStyles.SPACE_SM })
  }

  @Builder LoadingContent() {
    Column() {
      LoadingProgress()
        .color(CommonStyles.PRIMARY)
        .width(CommonStyles.SIZE_LG)
        .height(CommonStyles.SIZE_LG)

      Text('加载中...')
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .margin({ top: CommonStyles.SPACE_MD })
    }
    .width('100%')
    .height(CommonStyles.SIZE_2XL)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .visibility(this.isLoading ? Visibility.Visible : Visibility.None)
  }

  @Builder ErrorContent() {
    Column() {
      Text('🐾')
        .fontSize(64)

      Text('宠物信息加载失败')
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .margin({ top: CommonStyles.SPACE_LG })

      Text('该宠物可能已被下架或链接失效')
        .fontSize(CommonStyles.FONT_SIZE_SM)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .margin({ top: CommonStyles.SPACE_XS })

      Button('返回列表', { type: ButtonType.Capsule })
        .width(CommonStyles.BUTTON_WIDTH_LG)
        .height(CommonStyles.BUTTON_HEIGHT_LG)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.PRIMARY)
        .backgroundColor(Color.Transparent)
        .borderWidth(1.5)
        .borderColor(CommonStyles.PRIMARY)
        .borderRadius(CommonStyles.RADIUS_FULL)
        .margin({ top: CommonStyles.SPACE_XL })
        .onClick(() => {
          RouterHelper.back();
        })
    }
    .width('100%')
    .height(CommonStyles.SIZE_2XL)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .visibility((!this.isLoading && !this.pet) ? Visibility.Visible : Visibility.None)
  }

  @Builder MainContent() {
    Column({ space: CommonStyles.SPACE_XL }) {
      this.PetInfoCard()
      this.StepIndicator()
      this.ContactSection()
      this.HousingSection()
      this.ExperienceSection()
      this.ReasonSection()
      this.AgreementSection()
      this.ErrorMessage()
    }
    .visibility((!this.isLoading && this.pet) ? Visibility.Visible : Visibility.None)
  }

  @Builder PetInfoCard() {
    Row({ space: CommonStyles.SPACE_MD }) {
      Image(this.pet && this.pet.images && this.pet.images.length > 0 ? $rawfile(this.pet.images[0]) : '')
        .width(CommonStyles.SIZE_XL)
        .height(CommonStyles.SIZE_XL)
        .borderRadius(CommonStyles.RADIUS_MD)
        .objectFit(ImageFit.Cover)

      Column({ space: CommonStyles.SPACE_XS }) {
        Text(this.pet?.name || '')
          .fontSize(CommonStyles.FONT_SIZE_LG)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Text(`${this.pet?.breed || ''} · ${this.pet?.age || ''}岁 · ${this.pet?.gender || ''}`)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.TEXT_SECONDARY)

        Row({ space: CommonStyles.SPACE_XS }) {
          Text('📍')
            .fontSize(CommonStyles.FONT_SIZE_SM)

          Text(this.pet?.location || '未知位置')
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.TEXT_TERTIARY)
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(CommonStyles.SPACE_MD)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
  }

  @Builder StepIndicator() {
    Row() {
      ForEach([1, 2, 3], (step: number) => {
        Column() {
          Text(`${step}`)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontWeight(FontWeight.Medium)
            .fontColor(step === 1 ? CommonStyles.WHITE : CommonStyles.PRIMARY)
        }
        .width(CommonStyles.SIZE_SM)
        .height(CommonStyles.SIZE_SM)
        .borderRadius(CommonStyles.RADIUS_FULL)
        .backgroundColor(step === 1 ? CommonStyles.PRIMARY : CommonStyles.PRIMARY_LIGHT)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)

        if (step < 3) {
          Row()
            .width(CommonStyles.SIZE_XL)
            .height(2)
            .backgroundColor(step === 1 ? CommonStyles.PRIMARY : CommonStyles.GRAY_200)
            .margin({ left: CommonStyles.SPACE_XS, right: CommonStyles.SPACE_XS })
        }
      })
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .padding(CommonStyles.SPACE_MD)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
  }

  @Builder ContactSection() {
    Column({ space: CommonStyles.SPACE_LG }) {
      Row() {
        Text('👤')
          .fontSize(CommonStyles.FONT_SIZE_LG)

        Text('联系信息')
          .fontSize(CommonStyles.FONT_SIZE_LG)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .margin({ left: CommonStyles.SPACE_SM })
      }
      .width('100%')

      this.FormField('姓名', '请输入您的真实姓名', 'user', true, (value: string) => {
        this.formData.name = value;
        this.errorMessage = '';
      }, this.formData.name)

      this.FormField('手机号', '请输入11位手机号', 'phone', true, (value: string) => {
        this.formData.phone = value;
        this.errorMessage = '';
      }, this.formData.phone, 11)

      this.FormField('邮箱', '请输入您的邮箱（可选）', 'email', false, (value: string) => {
        this.formData.email = value;
      }, this.formData.email)
    }
    .width('100%')
    .padding(CommonStyles.SPACE_LG)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
  }

  @Builder HousingSection() {
    Column({ space: CommonStyles.SPACE_LG }) {
      Row() {
        Text('🏠')
          .fontSize(CommonStyles.FONT_SIZE_LG)

        Text('居住环境')
          .fontSize(CommonStyles.FONT_SIZE_LG)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .margin({ left: CommonStyles.SPACE_SM })
      }
      .width('100%')

      this.SelectField('居住类型', ['自有住房', '租赁房屋', '合租房', '与父母同住'], (value: string) => {
        this.formData.housingType = value;
      })

      this.ToggleField('是否有庭院或阳台', 'hasYard', (value: boolean) => {
        this.formData.hasYard = value;
      })

      this.ToggleField('居住地是否允许养宠物', 'petAllowed', (value: boolean) => {
        this.formData.petAllowed = value;
      })

      this.AddressField()
    }
    .width('100%')
    .padding(CommonStyles.SPACE_LG)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
  }

  @Builder ExperienceSection() {
    Column({ space: CommonStyles.SPACE_LG }) {
      Row() {
        Text('📝')
          .fontSize(CommonStyles.FONT_SIZE_LG)

        Text('饲养经验')
          .fontSize(CommonStyles.FONT_SIZE_LG)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .margin({ left: CommonStyles.SPACE_SM })
      }
      .width('100%')

      this.TextAreaField('宠物饲养经验', '简要描述您之前是否养过宠物、养过什么品种、养了多长时间等（可选）', (value: string) => {
        this.formData.experience = value;
      }, this.formData.experience)
    }
    .width('100%')
    .padding(CommonStyles.SPACE_LG)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
  }

  @Builder ReasonSection() {
    Column({ space: CommonStyles.SPACE_LG }) {
      Row() {
        Text('❤️')
          .fontSize(CommonStyles.FONT_SIZE_LG)

        Text('领养原因')
          .fontSize(CommonStyles.FONT_SIZE_LG)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .margin({ left: CommonStyles.SPACE_SM })
      }
      .width('100%')

      this.TextAreaField('您的领养计划 *', '请详细说明您想领养这只宠物的理由以及未来的照顾计划', (value: string) => {
        this.formData.reason = value;
        this.errorMessage = '';
      }, this.formData.reason, true)
    }
    .width('100%')
    .padding(CommonStyles.SPACE_LG)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
  }

  @Builder AgreementSection() {
    Row({ space: CommonStyles.SPACE_SM }) {
      Row() {
        Text(this.formData.agreeTerms ? '✓' : '○')
          .fontSize(CommonStyles.FONT_SIZE_MD)
      }
      .onClick(() => {
        this.formData.agreeTerms = !this.formData.agreeTerms;
        if (!this.formData.agreeTerms) {
          this.errorMessage = '';
        }
      })

      Column({ space: CommonStyles.SPACE_XS }) {
        Text('我已阅读并同意')
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.TEXT_SECONDARY)

        Text('《宠物领养服务协议》和《用户须知》')
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.PRIMARY)
          .onClick(() => {
            this.showAgreement();
          })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding(CommonStyles.SPACE_MD)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .onClick(() => {
      this.formData.agreeTerms = !this.formData.agreeTerms;
    })
  }

  @Builder ErrorMessage() {
    Row({ space: CommonStyles.SM }) {
      Text('⚠️')
        .fontSize(CommonStyles.FONT_SIZE_MD)

      Text(this.errorMessage)
        .fontSize(CommonStyles.FONT_SIZE_SM)
        .fontColor(CommonStyles.DANGER)
        .layoutWeight(1)
    }
    .width('100%')
    .padding(CommonStyles.SPACE_MD)
    .backgroundColor('#FEE2E2')
    .borderRadius(CommonStyles.RADIUS_MD)
    .visibility(this.errorMessage ? Visibility.Visible : Visibility.None)
  }

  @Builder FormField(label: string, placeholder: string, icon: string, required: boolean,
                     onChange: (value: string) => void, value: string, maxLength?: number) {
    Column({ space: CommonStyles.SPACE_SM }) {
      Row() {
        Text(label + (required ? ' *' : ''))
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontWeight(required ? FontWeight.Medium : FontWeight.Normal)
          .fontColor(CommonStyles.TEXT_PRIMARY)
      }
      .width('100%')

      Row({ space: CommonStyles.SM }) {
        Text(this.getIconEmoji(icon))
          .fontSize(CommonStyles.FONT_SIZE_MD)

        TextInput({ placeholder: placeholder, text: value })
          .layoutWeight(1)
          .height(CommonStyles.INPUT_HEIGHT)
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .placeholderColor(CommonStyles.GRAY_400)
          .placeholderFont({ size: CommonStyles.FONT_SIZE_MD })
          .backgroundColor(CommonStyles.GRAY_50)
          .borderRadius(CommonStyles.RADIUS_MD)
          .padding({ left: CommonStyles.SM, right: CommonStyles.SM })
          .onChange(onChange)
          .maxLength(maxLength || 100)
      }
      .width('100%')
      .padding({ left: CommonStyles.SM, right: CommonStyles.SM })
      .backgroundColor(CommonStyles.GRAY_50)
      .borderRadius(CommonStyles.RADIUS_MD)
    }
    .width('100%')
  }

  @Builder SelectField(label: string, options: string[], onChange: (value: string) => void) {
    Column({ space: CommonStyles.SPACE_SM }) {
      Text(label + ' *')
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(options, (option: string) => {
          Text(option)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(this.formData.housingType === option ? CommonStyles.WHITE : CommonStyles.TEXT_SECONDARY)
            .padding({ left: CommonStyles.MD, right: CommonStyles.MD, top: CommonStyles.SM, bottom: CommonStyles.SM })
            .backgroundColor(this.formData.housingType === option ? CommonStyles.PRIMARY : CommonStyles.GRAY_100)
            .borderRadius(CommonStyles.RADIUS_FULL)
            .margin({ right: CommonStyles.SM, bottom: CommonStyles.SM })
            .onClick(() => {
              onChange(option);
            })
        })
      }
      .width('100%')
    }
    .width('100%')
  }

  // fieldKey 只传 'hasYard' / 'petAllowed' 静态键，显示与切换都直接读写
  // this.formData，避免把 boolean 当普通值参数传入 @Builder（按值拷贝，
  // 点击后显示不变、滚动后丢失）。保留原有 onChange 回写与校验提交逻辑。
  @Builder ToggleField(label: string, fieldKey: string, onChange: (value: boolean) => void) {
    Row() {
      Text(label)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .layoutWeight(1)

      if (fieldKey === 'hasYard') {
        Text(this.formData.hasYard ? '✓ 是' : '✗ 否')
          .fontSize(CommonStyles.FONT_SIZE_LG)
          .onClick(() => {
            onChange(!this.formData.hasYard);
          })
      } else {
        Text(this.formData.petAllowed ? '✓ 是' : '✗ 否')
          .fontSize(CommonStyles.FONT_SIZE_LG)
          .onClick(() => {
            onChange(!this.formData.petAllowed);
          })
      }
    }
    .width('100%')
    .padding({ top: CommonStyles.SM, bottom: CommonStyles.SM })
  }

  @Builder AddressField() {
    Column({ space: CommonStyles.SPACE_SM }) {
      Row() {
        Text('详细地址 *')
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .layoutWeight(1)

        Text('选择地址')
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.PRIMARY)
          .visibility(this.addresses.length > 0 ? Visibility.Visible : Visibility.None)
          .onClick(() => {
            this.showAddressDialog = true;
          })
      }
      .width('100%')

      TextInput({ placeholder: '请输入您的详细地址', text: this.formData.address })
        .width('100%')
        .height(CommonStyles.INPUT_HEIGHT)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .placeholderColor(CommonStyles.GRAY_400)
        .placeholderFont({ size: CommonStyles.FONT_SIZE_MD })
        .backgroundColor(CommonStyles.GRAY_50)
        .borderRadius(CommonStyles.RADIUS_MD)
        .padding({ left: CommonStyles.SM, right: CommonStyles.SM })
        .onChange((value: string) => {
          this.formData.address = value;
          this.errorMessage = '';
        })

      Row({ space: CommonStyles.XS }) {
        Text('已选择:')
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.TEXT_SECONDARY)

        Text(`${this.selectedAddress?.name || ''} ${this.selectedAddress?.phone || ''}`)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.PRIMARY)

        Text('清除')
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.DANGER)
          .margin({ left: CommonStyles.MD })
          .onClick(() => {
            this.selectedAddress = null;
            this.formData.address = '';
          })
      }
      .width('100%')
      .padding({ top: CommonStyles.XS })
      .visibility(this.selectedAddress ? Visibility.Visible : Visibility.None)
    }
    .width('100%')
  }

  @Builder TextAreaField(label: string, placeholder: string, onChange: (value: string) => void, value: string, required: boolean = false) {
    Column({ space: CommonStyles.SPACE_SM }) {
      Text(label)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontWeight(required ? FontWeight.Medium : FontWeight.Normal)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      TextArea({ placeholder: placeholder, text: value })
        .width('100%')
        .height(120)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .placeholderColor(CommonStyles.GRAY_400)
        .placeholderFont({ size: CommonStyles.FONT_SIZE_MD })
        .backgroundColor(CommonStyles.GRAY_50)
        .borderRadius(CommonStyles.RADIUS_MD)
        .padding({ left: CommonStyles.SM, right: CommonStyles.SM, top: CommonStyles.SM, bottom: CommonStyles.SM })
        .onChange(onChange)
    }
    .width('100%')
  }

  @Builder BottomCTA() {
    Column() {
      Button() {
        Row({ space: CommonStyles.SM }) {
          if (this.isSubmitting) {
            LoadingProgress()
              .width(CommonStyles.SIZE_SM)
              .height(CommonStyles.SIZE_SM)
              .color(CommonStyles.WHITE)
          } else {
            Text('提交申请 ✓')
              .fontSize(CommonStyles.FONT_SIZE_LG)
              .fontWeight(FontWeight.Medium)
              .fontColor(CommonStyles.WHITE)
          }
        }
      }
      .width('100%')
      .height(CommonStyles.BUTTON_HEIGHT_XL)
      .enabled(this.formData.agreeTerms && !this.isSubmitting)
      .backgroundColor(this.formData.agreeTerms && !this.isSubmitting ? CommonStyles.PRIMARY : CommonStyles.GRAY_300)
      .borderRadius(CommonStyles.RADIUS_FULL)
      .shadow(this.formData.agreeTerms ? CommonStyles.SHADOW_BRAND_OLD : CommonStyles.SHADOW_NONE)
      .onClick(() => {
        this.handleSubmit();
      })
    }
    .width('100%')
    .padding({ left: CommonStyles.LG, right: CommonStyles.LG, top: CommonStyles.MD, bottom: CommonStyles.LG })
    .backgroundColor(CommonStyles.WHITE)
    .shadow(CommonStyles.SHADOW_MD)
  }

  private getIconEmoji(iconName: string): string {
    const iconMap: Record<string, string> = {
      'user': '👤',
      'phone': '📱',
      'email': '📧'
    };
    return iconMap[iconName] || '📌';
  }

  private handleSubmit() {
    if (!this.formData.name.trim()) {
      this.errorMessage = '请输入真实姓名';
      return;
    }

    if (!this.formData.phone.trim()) {
      this.errorMessage = '请输入手机号';
      return;
    }

    if (!/^1[3-9]\d{9}$/.test(this.formData.phone)) {
      this.errorMessage = '请输入有效的11位手机号';
      return;
    }

    if (!this.formData.housingType) {
      this.errorMessage = '请选择居住类型';
      return;
    }

    if (!this.formData.address.trim()) {
      this.errorMessage = '请输入详细地址';
      return;
    }

    if (!this.formData.reason.trim()) {
      this.errorMessage = '请填写领养计划';
      return;
    }

    if (!this.formData.agreeTerms) {
      this.errorMessage = '请阅读并同意领养协议';
      return;
    }

    this.isSubmitting = true;
    this.errorMessage = '';

    const self = this;
    setTimeout(() => {
      const store: AppStore = AppStore.getInstance();
      const state: AppState = store.getState();
      const currentUser = state.currentUser;

      if (!currentUser) {
        self.errorMessage = '请先登录后再提交申请';
        self.isSubmitting = false;
        return;
      }

      if (!self.pet) {
        self.errorMessage = '宠物信息获取失败，请重试';
        self.isSubmitting = false;
        return;
      }

      const applyData: ApplyData = {
        petId: self.pet.id,
        userId: currentUser.id,
        petName: self.pet.name,
        userName: self.formData.name,
        phone: this.formData.phone,
        address: this.formData.address,
        experience: this.formData.experience,
        reason: this.formData.reason,
        status: '待审核'
      };

      const result = createApply(applyData);

      if (result) {
        const store = AppStore.getInstance();
        const currentApplies = store.getState().applies;
        store.setApplies([...currentApplies, result]);

        self.showToast('✓ 申请提交成功！我们会尽快审核');
        self.isSubmitting = false;

        setTimeout(() => {
          RouterHelper.back();
        }, 1500);
      } else {
        self.errorMessage = '✗ 提交失败，请稍后重试';
        self.isSubmitting = false;
      }
    }, 1500);
  }

  private showAgreement() {
    RouterHelper.pushUrl("pages/Contract");
  }

  private showToast(message: string) {
    promptAction.showToast({
      message: message,
      duration: 2000
    });
  }

  private resetForm() {
    this.formData = {
      name: '',
      phone: '',
      email: '',
      address: '',
      housingType: '',
      hasYard: false,
      petAllowed: false,
      experience: '',
      reason: '',
      agreeTerms: false
    };
    this.selectedAddress = null;
    this.errorMessage = '';
  }
}
