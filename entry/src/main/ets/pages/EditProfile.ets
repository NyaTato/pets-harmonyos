import { RouterHelper } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { AppStore } from '../store/AppStore';
import { updateUserInfo, User } from '../mock/UserData';
import { promptAction } from '@kit.ArkUI';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

interface EditProfileFormData {
  nickname: string;
  phone: string;
  email: string;
  bio: string;
}

@Entry
@Component
struct EditProfile {
  @State private userInfo: User | null = null;
  @State private formData: EditProfileFormData = {
    nickname: '',
    phone: '',
    email: '',
    bio: ''
  };
  @State private isSubmitting: boolean = false;
  @State private errorMessage: string = '';
  @State private showAvatarPicker: boolean = false;

  private avatarOptions: string[] = [
    'avatars/avatar_user_zhangsan.jpg',
    'avatars/avatar_user_lisi.jpg',
    'avatars/avatar_user_wangwu.jpg',
    'avatars/avatar_option_4.jpg',
    'avatars/avatar_option_5.jpg',
    'avatars/avatar_sample_cat.jpg',
    'avatars/avatar_sample_dog.jpg'
  ];

  aboutToAppear() {
    const store = AppStore.getInstance();
    const state = store.getState();
    if (state.currentUser) {
      this.userInfo = state.currentUser;
      this.formData = {
        nickname: state.currentUser.nickname || '',
        phone: state.currentUser.phone || '',
        email: state.currentUser.email || '',
        bio: state.currentUser.bio || ''
      };
    } else {
      RouterHelper.replaceUrl("pages/Login");
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
            Column({ space: CommonStyles.XL }) {
              this.AvatarSection()
              this.FormSection()
              this.ErrorMessage()
            }
            .padding({ left: CommonStyles.LG, right: CommonStyles.LG, bottom: CommonStyles.SPACE_3XL })
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)
          .layoutWeight(1)

          this.BottomSaveButton()
        }
        .width('100%')
        .height('100%')
        .backgroundColor(CommonStyles.COLOR_BG)
      }

      if (this.showAvatarPicker) {
        this.AvatarPickerDialog()
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: '45mm' })
  }

  @Builder NavigationBar() {
    Row() {
      BackButton()

      Text('编辑资料')
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

  @Builder AvatarSection() {
    Column({ space: CommonStyles.MD }) {
      Text('头像设置')
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      Column({ space: CommonStyles.MD }) {
        Image(this.userInfo?.avatar ? $rawfile(this.userInfo.avatar) : '')
          .width(CommonStyles.SIZE_2XL)
          .height(CommonStyles.SIZE_2XL)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .objectFit(ImageFit.Cover)
          .border({ width: 4, color: CommonStyles.PRIMARY_LIGHT })

        Button('更换头像 📷', { type: ButtonType.Normal })
          .height(CommonStyles.BUTTON_HEIGHT_SM)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.PRIMARY)
          .backgroundColor(CommonStyles.WHITE)
          .borderWidth(1.5)
          .borderColor(CommonStyles.PRIMARY)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .onClick(() => {
            this.showAvatarPicker = true;
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .padding({ top: CommonStyles.LG, bottom: CommonStyles.LG })
    }
    .width('100%')
    .padding(CommonStyles.LG)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  @Builder FormSection() {
    Column({ space: CommonStyles.LG }) {
      Row() {
        Text('📝')
          .fontSize(CommonStyles.FONT_SIZE_LG)

        Text('基本信息')
          .fontSize(CommonStyles.FONT_SIZE_LG)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .margin({ left: CommonStyles.SM })
      }
      .width('100%')

      this.FormField('昵称 *', '请输入您的昵称', 'user', true,
        (value: string) => {
          this.formData.nickname = value;
          this.errorMessage = '';
        }, this.formData.nickname)

      this.FormField('手机号', '请输入11位手机号（可选）', 'phone', false,
        (value: string) => {
          this.formData.phone = value;
          this.errorMessage = '';
        }, this.formData.phone, 11)

      this.FormField('邮箱', '请输入您的邮箱（可选）', 'email', false,
        (value: string) => {
          this.formData.email = value;
          this.errorMessage = '';
        }, this.formData.email)

      this.TextAreaField('个人简介', '介绍一下自己吧~（可选）',
        (value: string) => {
          this.formData.bio = value;
        }, this.formData.bio)
    }
    .width('100%')
    .padding(CommonStyles.LG)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  @Builder FormField(label: string, placeholder: string, icon: string, required: boolean,
                     onChange: (value: string) => void, value: string, maxLength?: number) {
    Column({ space: CommonStyles.SM }) {
      Row() {
        Text(label)
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

  @Builder TextAreaField(label: string, placeholder: string, onChange: (value: string) => void, value: string) {
    Column({ space: CommonStyles.SM }) {
      Text(label)
        .fontSize(CommonStyles.FONT_SIZE_MD)
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
    .padding(CommonStyles.MD)
    .backgroundColor('#FEE2E2')
    .borderRadius(CommonStyles.RADIUS_MD)
    .visibility(this.errorMessage ? Visibility.Visible : Visibility.None)
  }

  @Builder BottomSaveButton() {
    Column() {
      Button() {
        Row({ space: CommonStyles.SM }) {
          if (this.isSubmitting) {
            LoadingProgress()
              .width(CommonStyles.SIZE_SM)
              .height(CommonStyles.SIZE_SM)
              .color(CommonStyles.WHITE)
          } else {
            Text('保存修改 ✓')
              .fontSize(CommonStyles.FONT_SIZE_LG)
              .fontWeight(FontWeight.Medium)
              .fontColor(CommonStyles.WHITE)
          }
        }
      }
      .width('100%')
      .height(CommonStyles.BUTTON_HEIGHT_XL)
      .enabled(!this.isSubmitting)
      .backgroundColor(!this.isSubmitting ? CommonStyles.PRIMARY : CommonStyles.GRAY_300)
      .borderRadius(CommonStyles.RADIUS_FULL)
      .shadow(!this.isSubmitting ? CommonStyles.SHADOW_BRAND_OLD : CommonStyles.SHADOW_NONE)
      .onClick(() => {
        this.handleSave();
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

  private handleSave() {
    if (!this.formData.nickname.trim()) {
      this.errorMessage = '请输入昵称';
      return;
    }

    if (this.formData.phone && !/^1[3-9]\d{9}$/.test(this.formData.phone)) {
      this.errorMessage = '请输入有效的11位手机号';
      return;
    }

    if (this.formData.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.formData.email)) {
      this.errorMessage = '请输入有效的邮箱地址';
      return;
    }

    if (!this.userInfo) {
      this.errorMessage = '用户信息获取失败';
      return;
    }

    this.isSubmitting = true;
    this.errorMessage = '';

    setTimeout(() => {
      if (!this.userInfo) {
        this.errorMessage = '用户信息获取失败';
        this.isSubmitting = false;
        return;
      }

      const updatedUser: User = {
        id: this.userInfo.id,
        username: this.userInfo.username,
        password: this.userInfo.password,
        nickname: this.formData.nickname,
        avatar: this.userInfo.avatar,
        phone: this.formData.phone,
        email: this.formData.email,
        signature: this.userInfo.signature || '',
        bio: this.formData.bio,
        role: this.userInfo.role,
        creditScore: this.userInfo.creditScore,
        level: this.userInfo.level,
        experience: this.userInfo.experience,
        medals: this.userInfo.medals,
        createdAt: this.userInfo.createdAt,
        lastLogin: this.userInfo.lastLogin
      };

      const success = updateUserInfo(updatedUser.id, updatedUser);

      if (success) {
        this.showToast('✓ 信息更新成功');
        setTimeout(() => {
          RouterHelper.back();
        }, 1000);
      } else {
        this.errorMessage = '✗ 更新失败，请稍后再试';
      }

      this.isSubmitting = false;
    }, 1000);
  }

  // ========== Avatar Picker Dialog ==========
  @Builder
  AvatarPickerDialog() {
    Column() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#00000080')
        .onClick(() => {
          this.showAvatarPicker = false;
        })

      Column({ space: 20 }) {
        Text('选择头像')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Grid() {
          ForEach(this.avatarOptions, (avatar: string, index: number) => {
            GridItem() {
              Column() {
                Text(avatar)
                  .fontSize(32)
              }
              .width('100%')
              .height('100%')
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
            }
            .width('25%')
            .height(100)
          })
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsGap(12)
        .columnsGap(12)
        .padding(16)
        .backgroundColor('#F9FAFB')
        .borderRadius(16)

        Button('取消', { type: ButtonType.Normal })
          .width('100%')
          .height(40)
          .fontSize(14)
          .fontColor(CommonStyles.TEXT_TERTIARY)
          .backgroundColor('transparent')
          .onClick(() => {
            this.showAvatarPicker = false;
          })
      }
      .width('85%')
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(20)
      .shadow({ radius: 20, color: 'rgba(0,0,0,0.15)', offsetX: 0, offsetY: 8 })
      .position({ x: 0, y: '25%' })
    }
    .width('100%')
    .height('100%')
    .position({ x: 0, y: 0 })
  }

  private showToast(message: string) {
    promptAction.showToast({
      message: message,
      duration: 2000
    });
  }
}
