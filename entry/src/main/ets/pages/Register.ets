import { RouterHelper } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { register, RegisterUserData } from '../mock/UserData';
import { AppStore } from '../store/AppStore';
import { promptAction } from '@kit.ArkUI';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

interface RegisterFormData extends RegisterUserData {
  confirmPassword: string;
  agreeTerms: boolean;
}

@Entry
@Component
export struct Register {
  @State private formData: RegisterFormData = {
    username: '',
    password: '',
    confirmPassword: '',
    nickname: '',
    phone: '',
    email: '',
    avatar: '',
    agreeTerms: false
  };
  @State private isLoading: boolean = false;
  @State private errorMessage: string = '';
  @State private showPassword: boolean = false;
  @State private passwordStrength: number = 0;

  private getPasswordStrength(password: string): number {
    let strength = 0;
    if (password.length >= 6) strength++;
    if (password.length >= 10) strength++;
    if (/[A-Z]/.test(password)) strength++;
    if (/[0-9]/.test(password)) strength++;
    if (/[^A-Za-z0-9]/.test(password)) strength++;
    return Math.min(strength, 4);
  }

  private handleRegister(): void {
    if (!this.validateForm()) {
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    setTimeout(() => {
      const success = register(this.formData);
      if (success) {
        promptAction.showToast({ message: '注册成功！' });
        RouterHelper.navigateToLogin();
      } else {
        this.errorMessage = '注册失败，请稍后重试';
        this.isLoading = false;
      }
    }, 1000);
  }

  private validateForm(): boolean {
    if (!this.formData.username || this.formData.username.length < 3) {
      this.errorMessage = '用户名至少3位';
      return false;
    }
    if (!this.formData.password || this.formData.password.length < 6) {
      this.errorMessage = '密码至少6位';
      return false;
    }
    if (this.formData.password !== this.formData.confirmPassword) {
      this.errorMessage = '两次密码不一致';
      return false;
    }
    if (!this.formData.nickname) {
      this.errorMessage = '请输入昵称';
      return false;
    }
    if (!this.formData.agreeTerms) {
      this.errorMessage = '请同意用户协议';
      return false;
    }
    return true;
  }

  build() {
    Column() {
      // 导航栏
      Row() {
        BackButton()

        Blank()

        Text('注册账号')
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Blank()

        Text('')
          .width(24)
      }
      .width('100%')
      .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG, top: 16, bottom: 16 })

      // 表单区域
      Scroll() {
        Column({ space: 20 }) {

          // 用户名
          this.FormField('用户名', '3-20位字母数字', this.formData.username,
            (value: string) => {
              this.formData.username = value;
              this.errorMessage = '';
            }, '👤'
          )

          // 密码 + 强度指示器
          Column({ space: 8 }) {
            Text('密码 *')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor(CommonStyles.TEXT_PRIMARY)
              .width('100%')

            Stack({ alignContent: Alignment.End }) {
              TextInput({ placeholder: '6-20位，包含字母和数字', text: this.formData.password })
                .placeholderColor(CommonStyles.TEXT_TERTIARY)
                .placeholderFont({ size: 15 })
                .fontSize(15)
                .fontColor(CommonStyles.TEXT_PRIMARY)
                .width('100%')
                .height(52)
                .type(InputType.Password)
                .backgroundColor(CommonStyles.BG_TERTIARY)
                .borderRadius(CommonStyles.RADIUS_MD)
                .padding({ left: 16, right: 48 })
                .onChange((value: string) => {
                  this.formData.password = value;
                  this.passwordStrength = this.getPasswordStrength(value);
                  this.errorMessage = '';
                })

              Text(this.showPassword ? '🙈' : '👁️')
                .fontSize(20)
                .padding(12)
                .position({ x: '85%', y: '50%' })
                .onClick(() => {
                  this.showPassword = !this.showPassword;
                })
            }

            // 密码强度条
            if (this.formData.password.length > 0) {
              Row({ space: 6 }) {
                ForEach([1, 2, 3, 4], (level: number) => {
                  Column()
                    .layoutWeight(1)
                    .height(4)
                    .borderRadius(2)
                    .backgroundColor(
                      this.passwordStrength >= level
                        ? (this.passwordStrength <= 1 ? CommonStyles.DANGER
                          : this.passwordStrength <= 2 ? CommonStyles.WARNING
                            : this.passwordStrength <= 3 ? CommonStyles.INFO : CommonStyles.SUCCESS)
                        : CommonStyles.GRAY_200
                    )
                })
              }
              .width('100%')

              Text(['弱', '一般', '强', '非常强'][this.passwordStrength - 1] || '')
                .fontSize(12)
                .fontColor(this.passwordStrength >= 3 ? CommonStyles.SUCCESS : CommonStyles.WARNING)
                .margin({ top: 4 })
            }
          }
          .width('100%')

          // 确认密码
          this.FormField('确认密码', '请再次输入密码', this.formData.confirmPassword,
            (value: string) => {
              this.formData.confirmPassword = value;
              this.errorMessage = '';
            }, '🔒', InputType.Password
          )

          // 昵称
          this.FormField('昵称', '2-20位', this.formData.nickname,
            (value: string) => {
              this.formData.nickname = value;
              this.errorMessage = '';
            }, '😊'
          )

          // 手机号（可选）
          this.FormField('手机号', '选填', this.formData.phone,
            (value: string) => {
              this.formData.phone = value;
              this.errorMessage = '';
            }, '📱'
          )

          // 邮箱（可选）
          this.FormField('邮箱', '选填', this.formData.email,
            (value: string) => {
              this.formData.email = value;
              this.errorMessage = '';
            }, '✉️'
          )

          // 用户协议
          Row({ space: 10 }) {
            Checkbox()
              .select(this.formData.agreeTerms)
              .shape(CheckBoxShape.ROUNDED_SQUARE)
              .selectedColor(CommonStyles.PRIMARY)
              .onChange((checked: boolean) => {
                this.formData.agreeTerms = checked;
                this.errorMessage = '';
              })

            Column({ space: 2 }) {
              Text('我已阅读并同意')
                .fontSize(14)
                .fontColor(CommonStyles.TEXT_SECONDARY)

              Row({ space: 4 }) {
                Text('《用户协议》')
                  .fontSize(14)
                  .fontColor(CommonStyles.PRIMARY)
                  .fontWeight(FontWeight.Medium)

                Text('和')
                  .fontSize(14)
                  .fontColor(CommonStyles.TEXT_SECONDARY)

                Text('《隐私政策》')
                  .fontSize(14)
                  .fontColor(CommonStyles.PRIMARY)
                  .fontWeight(FontWeight.Medium)
              }
            }
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')

          // 错误提示
          Text(this.errorMessage || '')
            .fontSize(14)
            .fontColor(CommonStyles.DANGER)
            .width('100%')
            .textAlign(TextAlign.Center)
            .visibility(this.errorMessage ? Visibility.Visible : Visibility.None)

          // 注册按钮
          Button('注 册', { type: ButtonType.Capsule, stateEffect: true })
            .width('100%')
            .height(CommonStyles.BUTTON_HEIGHT_LG)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.WHITE)
            .backgroundColor(CommonStyles.PRIMARY)
            .borderRadius(CommonStyles.RADIUS_FULL)
            .shadow({
              radius: 16,
              color: '#2DD4BF60',
              offsetX: 0,
              offsetY: 8
            })
            .enabled(!this.isLoading && this.formData.agreeTerms)
            .onClick(() => {
              this.handleRegister();
            })

          // 已有账号
          Row({ space: 8 }) {
            Text('已有账号？')
              .fontSize(15)
              .fontColor(CommonStyles.TEXT_SECONDARY)

            Text('去登录')
              .fontSize(15)
              .fontColor(CommonStyles.PRIMARY)
              .fontWeight(FontWeight.Bold)
              .onClick(() => {
                RouterHelper.navigateToLogin();
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ top: 16 })
        }
        .width('100%')
        .padding({
          left: CommonStyles.SPACE_3XL,
          right: CommonStyles.SPACE_3XL,
          top: CommonStyles.SPACE_XL,
          bottom: 40
        })
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .padding({ top: '45mm' })
  }

  @Builder
  FormField(label: string, placeholder: string, value: string, onChange: (value: string) => void, icon?: string, inputType?: InputType) {
    Column({ space: 8 }) {
      Text(`${label} ${label.includes('*') ? '' : '*'}`)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      Row({ space: 12 }) {
        if (icon) {
          Text(icon)
            .fontSize(20)
        }

        TextInput({ placeholder: placeholder, text: value })
          .placeholderColor(CommonStyles.TEXT_TERTIARY)
          .placeholderFont({ size: 15 })
          .fontSize(15)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .layoutWeight(1)
          .height(52)
          .type(inputType || InputType.Normal)
          .backgroundColor(CommonStyles.BG_TERTIARY)
          .borderRadius(CommonStyles.RADIUS_MD)
          .padding({ left: 16, right: 16 })
          .onChange(onChange)
      }
    }
    .width('100%')
  }
}
