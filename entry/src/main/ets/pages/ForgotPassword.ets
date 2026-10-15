﻿﻿﻿﻿﻿import { RouterHelper } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { ResourceManager } from '../common/ResourceManager';
import { promptAction } from '@kit.ArkUI';
import { ValidationUtils } from '../utils/ValidationUtils';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';



@Entry
@Component
struct ForgotPassword {
  @State private email: string = '';
  @State private verificationCode: string = '';
  @State private newPassword: string = '';
  @State private confirmPassword: string = '';
  @State private isLoading: boolean = false;
  @State private isSendingCode: boolean = false;
  @State private countdown: number = 0;
  @State private errorMessage: string = '';
  @State private successMessage: string = '';
  @State private step: number = 1; // 1: 输入邮箱, 2: 输入验证码和密码

  private timerId: number | null = null;

  aboutToDisappear(): void {
    // 清除定时器
    if (this.timerId) {
      clearInterval(this.timerId);
      this.timerId = null;
    }
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top', 'bottom']
      }) {
        Column() {
          // 返回按钮和标题
          Row({ space: CommonStyles.SPACE_MD }) {
            // 返回按钮
            BackButton()

            Text('忘记密码')
          .fontSize(CommonStyles.FONT_SIZE_XL)
          .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .layoutWeight(1)
      }
      .width('100%')
      .padding({ top: CommonStyles.SPACE_XL, bottom: CommonStyles.SPACE_XL, left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG })

      // 步骤指示器
      Row({ space: CommonStyles.SPACE_MD }) {
        // 步骤1
        Column({ space: CommonStyles.SPACE_XS }) {
          Circle({ width: 24, height: 24 })
            .fill(this.step >= 1 ? CommonStyles.PRIMARY_COLOR : CommonStyles.GRAY_300)

          Text('1. 验证身份')
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(this.step >= 1 ? CommonStyles.PRIMARY_COLOR : CommonStyles.TEXT_SECONDARY)
        }
        .layoutWeight(1)

        // 连接线
        Divider()
          .vertical(false)
          .strokeWidth(2)
          .color(this.step >= 2 ? CommonStyles.PRIMARY_COLOR : CommonStyles.GRAY_300)
          .lineCap(LineCapStyle.Round)
          .layoutWeight(2)

        // 步骤2
        Column({ space: CommonStyles.SPACE_XS }) {
          Circle({ width: 24, height: 24 })
            .fill(this.step >= 2 ? CommonStyles.PRIMARY_COLOR : CommonStyles.GRAY_300)

          Text('2. 重置密码')
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(this.step >= 2 ? CommonStyles.PRIMARY_COLOR : CommonStyles.TEXT_SECONDARY)
        }
        .layoutWeight(1)
      }
      .width('85%')
      .margin({ top: CommonStyles.SPACE_XL, bottom: CommonStyles.SPACE_XL })

      // 说明文字
      Column({ space: CommonStyles.SPACE_SM }) {
        if (this.step === 1) {
          Text('请输入您注册时使用的邮箱地址')
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .width('100%')
            .textAlign(TextAlign.Start)

          Text('我们将发送验证码到您的邮箱')
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.TEXT_SECONDARY)
            .width('100%')
            .textAlign(TextAlign.Start)
        } else {
          Text('请输入验证码和新密码')
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .width('100%')
            .textAlign(TextAlign.Start)

          Text('验证码已发送到您的邮箱，请查收')
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.TEXT_SECONDARY)
            .width('100%')
            .textAlign(TextAlign.Start)
        }
      }
      .width('85%')
      .margin({ top: CommonStyles.SPACE_2XL, bottom: CommonStyles.SPACE_XL })

      // 邮箱输入框
      Column({ space: CommonStyles.SPACE_SM }) {
        Text('邮箱地址')
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .width('100%')
          .textAlign(TextAlign.Start)

        TextInput({ placeholder: '请输入注册邮箱', text: this.email })
          .width('100%')
          .height(48)
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .backgroundColor(CommonStyles.WHITE)
          .borderRadius(CommonStyles.RADIUS_MD)
          .padding({ left: CommonStyles.SPACE_MD, right: CommonStyles.SPACE_MD })
          .border({
            width: 1,
            color: $r('app.color.gray_300'),
            radius: CommonStyles.RADIUS_MD
          })
          .onChange((value: string) => {
            this.email = value;
            this.errorMessage = '';
            this.successMessage = '';
          })
      }
      .width('85%')
      .margin({ bottom: CommonStyles.SPACE_LG })

      // 步骤1: 获取验证码
      if (this.step === 1) {
        // 获取验证码按钮
        Button('获取验证码', { type: ButtonType.Capsule, stateEffect: true })
          .width('85%')
          .height(50)
          .fontSize(CommonStyles.FONT_SIZE_LG)
          .fontColor(CommonStyles.WHITE)
          .backgroundColor(CommonStyles.PRIMARY_COLOR)
          .enabled(!this.isSendingCode && this.countdown === 0 && this.email.trim().length > 0)
          .onClick(() => {
            this.handleSendVerificationCode();
          })
          .margin({ top: CommonStyles.SPACE_XL })
      }

      // 步骤2: 验证码和新密码输入
      if (this.step === 2) {
        // 验证码输入框
        Column({ space: CommonStyles.SPACE_SM }) {
          Text('验证码')
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .width('100%')
            .textAlign(TextAlign.Start)

          Row({ space: CommonStyles.SPACE_MD }) {
            TextInput({ placeholder: '请输入6位验证码', text: this.verificationCode })
              .width('70%')
              .height(48)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .backgroundColor(CommonStyles.WHITE)
              .borderRadius(CommonStyles.RADIUS_MD)
              .padding({ left: CommonStyles.SPACE_MD, right: CommonStyles.SPACE_MD })
              .border({
                width: 1,
                color: $r('app.color.gray_300'),
                radius: CommonStyles.RADIUS_MD
              })
              .maxLength(6)
              .onChange((value: string) => {
                this.verificationCode = value;
                this.errorMessage = '';
              })

            // 重新获取验证码按钮
            Button(this.countdown > 0 ? `${this.countdown}s后重发` : '重新获取',
                   { type: ButtonType.Capsule, stateEffect: true })
              .width('30%')
              .height(48)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(this.countdown > 0 ? CommonStyles.TEXT_SECONDARY : CommonStyles.PRIMARY_COLOR)
              .backgroundColor(this.countdown > 0 ? CommonStyles.GRAY_200 : CommonStyles.WHITE)
              .border({
                width: 1,
                color: this.countdown > 0 ? CommonStyles.GRAY_300 : CommonStyles.PRIMARY_COLOR,
                radius: CommonStyles.RADIUS_MD
              })
              .enabled(this.countdown === 0)
              .onClick(() => {
                this.handleSendVerificationCode();
              })
          }
          .width('100%')
        }
        .width('85%')
        .margin({ bottom: CommonStyles.SPACE_LG })

        // 新密码输入框
        Column({ space: CommonStyles.SPACE_SM }) {
          Text('新密码')
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .width('100%')
            .textAlign(TextAlign.Start)

          TextInput({ placeholder: '请输入新密码', text: this.newPassword })
            .width('100%')
            .height(48)
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .backgroundColor(CommonStyles.WHITE)
            .borderRadius(CommonStyles.RADIUS_MD)
            .padding({ left: CommonStyles.SPACE_MD, right: CommonStyles.SPACE_MD })
            .border({
              width: 1,
              color: $r('app.color.gray_300'),
              radius: CommonStyles.RADIUS_MD
            })
            .type(3)
             .onChange((value: string) => {
              this.newPassword = value;
              this.errorMessage = '';
            })
        }
        .width('85%')
        .margin({ bottom: CommonStyles.SPACE_LG })

        // 确认密码输入框
        Column({ space: CommonStyles.SPACE_SM }) {
          Text('确认密码')
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .width('100%')
            .textAlign(TextAlign.Start)

          TextInput({ placeholder: '请再次输入新密码', text: this.confirmPassword })
            .width('100%')
            .height(48)
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .backgroundColor(CommonStyles.WHITE)
            .borderRadius(CommonStyles.RADIUS_MD)
            .padding({ left: CommonStyles.SPACE_MD, right: CommonStyles.SPACE_MD })
            .border({
              width: 1,
              color: $r('app.color.gray_300'),
              radius: CommonStyles.RADIUS_MD
            })
            .type(3)
            .onChange((value: string) => {
              this.confirmPassword = value;
              this.errorMessage = '';
            })
        }
        .width('85%')
        .margin({ bottom: CommonStyles.SPACE_LG })

        // 重置密码按钮
        Button('重置密码', { type: ButtonType.Capsule, stateEffect: true })
          .width('85%')
          .height(50)
          .fontSize(CommonStyles.FONT_SIZE_LG)
          .fontColor(CommonStyles.WHITE)
          .backgroundColor(CommonStyles.PRIMARY_COLOR)
          .enabled(!this.isLoading &&
                   this.verificationCode.trim().length === 6 &&
                   this.newPassword.trim().length > 0 &&
                   this.confirmPassword.trim().length > 0)
          .onClick(() => {
            this.handleResetPassword();
          })
          .margin({ top: CommonStyles.SPACE_XL })
      }

      // 错误信息
      if (this.errorMessage) {
        Row() {
          Circle()
            .width(16)
            .height(16)
            .fill(CommonStyles.DANGER_COLOR)
            .margin({ right: CommonStyles.SM })

          Text(this.errorMessage)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.DANGER_COLOR)
            .layoutWeight(1)
        }
        .width('85%')
        .padding(CommonStyles.SPACE_MD)
        .backgroundColor('#FF3B3010')
        .borderRadius(CommonStyles.RADIUS_MD)
        .margin({ bottom: CommonStyles.SPACE_LG })
      }

      // 成功信息
      if (this.successMessage) {
        Row() {
          Circle()
            .width(16)
            .height(16)
            .fill(CommonStyles.SUCCESS_COLOR)
            .margin({ right: CommonStyles.SM })

          Text(this.successMessage)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.SUCCESS_COLOR)
            .layoutWeight(1)
        }
        .width('85%')
        .padding(CommonStyles.SPACE_MD)
        .backgroundColor('#FF34C75910')
        .borderRadius(CommonStyles.RADIUS_MD)
        .margin({ bottom: CommonStyles.SPACE_LG })
      }

      // 步骤1: 下一步按钮
      if (this.step === 1) {
        Button('下一步', { type: ButtonType.Capsule, stateEffect: true })
          .width('85%')
          .height(50)
          .fontSize(CommonStyles.FONT_SIZE_LG)
          .fontColor(CommonStyles.WHITE)
          .backgroundColor(CommonStyles.PRIMARY_COLOR)
          .enabled(!this.isLoading && this.email.trim().length > 0)
          .onClick(() => {
            this.handleNextStep();
          })
          .margin({ top: CommonStyles.SPACE_XL })
      }

      // 加载动画
      if (this.isLoading) {
        LoadingProgress()
          .color($r('app.color.primary'))
          .width(30)
          .height(30)
          .margin({ top: CommonStyles.SPACE_MD })
      }

      // 返回登录链接
      Row({ space: CommonStyles.SPACE_SM }) {
        Text('想起密码了？')
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontColor(CommonStyles.TEXT_SECONDARY)

        Text('返回登录')
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontColor(CommonStyles.PRIMARY_COLOR)
          .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
          .onClick(() => {
            RouterHelper.navigateToLogin();
          })
      }
      .margin({ top: CommonStyles.SPACE_XL })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(CommonStyles.BG_LIGHT)
    .justifyContent(FlexAlign.Start)
    .padding({ top: '45mm' })
      }
    }
  }

  private handleNextStep() {
    // 验证邮箱格式
    const email = this.email.trim();

    // 验证邮箱是否为空
    if (!email) {
      this.errorMessage = '请输入邮箱地址';
      return;
    }

    // 验证邮箱格式
    if (!ValidationUtils.isValidEmail(email)) {
      this.errorMessage = '请输入有效的邮箱地址';
      return;
    }

    // 切换到步骤2
    this.step = 2;
    this.errorMessage = '';
    this.successMessage = '';

    // 模拟发送验证码
    this.handleSendVerificationCode();
  }

  private async handleSendVerificationCode() {
    const email = this.email.trim();

    // 验证邮箱格式
    if (!email) {
      this.errorMessage = '请输入邮箱地址';
      return;
    }

    if (!ValidationUtils.isValidEmail(email)) {
      this.errorMessage = '请输入有效的邮箱地址';
      return;
    }

    this.isSendingCode = true;
    this.errorMessage = '';

    try {
      // 模拟发送验证码
      await new Promise<void>(resolve => setTimeout(resolve, 1000));

      // 开始倒计时
      this.countdown = 60;
      this.startCountdown();

      this.showToast('验证码已发送到您的邮箱');

    } catch (error) {
      console.error('发送验证码失败:', error);
      this.errorMessage = '发送验证码失败，请稍后重试';
      this.showToast('发送失败，请重试');
    } finally {
      this.isSendingCode = false;
    }
  }

  private startCountdown() {
    if (this.timerId) {
      clearInterval(this.timerId);
    }

    this.timerId = setInterval(() => {
      if (this.countdown > 0) {
        this.countdown--;
      } else {
        if (this.timerId) {
          clearInterval(this.timerId);
          this.timerId = null;
        }
      }
    }, 1000) as number;
  }

  private async handleResetPassword() {
    // 验证验证码
    const code = this.verificationCode.trim();
    if (!code) {
      this.errorMessage = '请输入验证码';
      return;
    }

    if (code.length !== 6) {
      this.errorMessage = '验证码必须是6位数字';
      return;
    }

    // 验证新密码
    const newPassword = this.newPassword.trim();
    const confirmPassword = this.confirmPassword.trim();

    if (!newPassword) {
      this.errorMessage = '请输入新密码';
      return;
    }

    if (!confirmPassword) {
      this.errorMessage = '请确认新密码';
      return;
    }

    if (newPassword !== confirmPassword) {
      this.errorMessage = '两次输入的密码不一致';
      return;
    }

    // 验证密码强度
    const passwordValidation = ValidationUtils.isValidPassword(newPassword);
    if (!passwordValidation.isValid) {
      this.errorMessage = passwordValidation.message;
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';
    this.successMessage = '';

    try {
      // 模拟重置密码请求
      await new Promise<void>(resolve => setTimeout(resolve, 1500));

      // 显示成功消息
      this.successMessage = '密码重置成功，请使用新密码登录';

      // 显示提示
      this.showToast('密码重置成功');

      // 3秒后自动返回登录页
      setTimeout((): void => {
        RouterHelper.navigateToLogin();
      }, 3000);

    } catch (error) {
      console.error('重置密码失败:', error);
      this.errorMessage = '重置密码失败，请检查验证码是否正确';
      this.showToast('重置失败，请重试');
    } finally {
      this.isLoading = false;
    }
  }

  private showToast(message: string) {
    promptAction.showToast({
      message: message,
      duration: 2000
    });
  }
}