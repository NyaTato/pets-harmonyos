import { RouterHelper } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { login } from '../mock/UserData';
import { AppStore } from '../store/AppStore';
import { promptAction } from '@kit.ArkUI';
import { SafeArea } from '../components/SafeArea';

interface LoginFormData {
  username: string;
  password: string;
}

@Entry
@Component
export struct Login {
  @State private formData: LoginFormData = {
    username: '',
    password: ''
  };
  @State private isLoading: boolean = false;
  @State private errorMessage: string = '';

  private handleLogin(): void {
    if (!this.formData.username || !this.formData.password) {
      this.errorMessage = '请输入用户名和密码';
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    setTimeout(() => {
      const result = login(this.formData.username, this.formData.password);
      if (result.success && result.user) {
        // 更新全局AppStore状态（关键修复）
        AppStore.getInstance().setUser(result.user);

        // 导航到主页面
        RouterHelper.navigateToMainTab();
      } else {
        this.errorMessage = '用户名或密码错误';
        this.isLoading = false;
      }
    }, 800);
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top', 'bottom']
      }) {
        Column() {
          // 顶部品牌区域
          Column({ space: 16 }) {
            Text('欢迎回来')
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor(CommonStyles.TEXT_PRIMARY)

            Text('登录您的账号，继续领养之旅')
              .fontSize(16)
              .fontColor(CommonStyles.TEXT_SECONDARY)
          }
          .width('100%')
          .padding({ left: CommonStyles.SPACE_3XL, right: CommonStyles.SPACE_3XL, top: 60, bottom: 40 })

          // 表单区域
          Scroll() {
            Column({ space: 24 }) {
              // 用户名输入框
              this.InputField(
                '用户名',
                '请输入用户名',
                this.formData.username,
                (value: string) => {
                  this.formData.username = value;
                  this.errorMessage = '';
                },
                '👤'
              )

              // 密码输入框
              this.InputField(
                '密码',
                '请输入密码',
                this.formData.password,
                (value: string) => {
                  this.formData.password = value;
                  this.errorMessage = '';
                },
                '🔒'
              )

              // 错误提示
              Text(this.errorMessage || '')
                .fontSize(14)
                .fontColor(CommonStyles.DANGER)
                .width('100%')
                .textAlign(TextAlign.Center)
                .visibility(this.errorMessage ? Visibility.Visible : Visibility.None)

              // 忘记密码链接
              Row() {
                Blank()
                Text('忘记密码？')
                  .fontSize(14)
                  .fontColor(CommonStyles.PRIMARY)
                  .fontWeight(FontWeight.Medium)
                  .onClick(() => {
                    RouterHelper.navigateToForgotPassword();
                  })
              }
              .width('100%')

              // 登录按钮
              Button('登 录', { type: ButtonType.Capsule, stateEffect: true })
                .width('100%')
                .height(CommonStyles.BUTTON_HEIGHT_LG)
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor(CommonStyles.WHITE)
                .backgroundColor(CommonStyles.PRIMARY)
                .borderRadius(CommonStyles.RADIUS_FULL)
                .enabled(!this.isLoading && (this.formData.username.length > 0 && this.formData.password.length > 0))
                .shadow({
                  radius: 16,
                  color: '#2DD4BF60',
                  offsetX: 0,
                  offsetY: 8
                })
                .onClick(() => {
                  this.handleLogin();
                })

              // 分隔线
              Row({ space: 16 }) {
                Column()
                  .layoutWeight(1)
                  .height(1)
                  .backgroundColor(CommonStyles.BORDER_LIGHT)

                Text('或')
                  .fontSize(14)
                  .fontColor(CommonStyles.TEXT_TERTIARY)

                Column()
                  .layoutWeight(1)
                  .height(1)
                  .backgroundColor(CommonStyles.BORDER_LIGHT)
              }
              .width('100%')
              .padding({ top: 8, bottom: 8 })

              // 第三方登录
              Row({ space: 20 }) {
                this.SocialLoginButton('微', '微信', '#07C160')
                this.SocialLoginButton('手', '手机', CommonStyles.INFO)
                this.SocialLoginButton('邮', '邮箱', CommonStyles.GRAY_600)
              }

              // 注册引导
              Row({ space: 8 }) {
                Text('还没有账号？')
                  .fontSize(15)
                  .fontColor(CommonStyles.TEXT_SECONDARY)

                Text('立即注册')
                  .fontSize(15)
                  .fontColor(CommonStyles.PRIMARY)
                  .fontWeight(FontWeight.Bold)
                  .onClick(() => {
                    RouterHelper.navigateToRegister();
                  })
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .margin({ top: 32 })
            }
            .width('100%')
            .padding({ left: CommonStyles.SPACE_3XL, right: CommonStyles.SPACE_3XL, bottom: 48 })
          }
          .scrollBar(BarState.Off)
          .layoutWeight(1)
        }
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: '45mm' })
    .backgroundColor('#FFFFFF')
  }

  @Builder
  InputField(label: string, placeholder: string, value: string, onChange: (value: string) => void, icon?: string) {
    Column({ space: 8 }) {
      if (label) {
        Text(label)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .width('100%')
      }

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
          .type(label === '密码' ? InputType.Password : InputType.Normal)
          .backgroundColor(CommonStyles.BG_TERTIARY)
          .borderRadius(CommonStyles.RADIUS_MD)
          .padding({ left: 16, right: 16 })
          .onChange(onChange)
      }
    }
    .width('100%')
  }

  @Builder
  SocialLoginButton(icon: string, label: string, bgColor: string) {
    Column({ space: 6 }) {
      Text(icon)
        .fontSize(28)

      Text(label)
        .fontSize(11)
        .fontColor(CommonStyles.TEXT_SECONDARY)
    }
    .width(72)
    .height(80)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(bgColor + '15')
    .borderRadius(CommonStyles.RADIUS_LG)
    .onClick(() => {
      promptAction.showToast({
        message: `${label}登录即将上线，敬请期待！`,
        duration: 2500
      });
    })
  }
}
