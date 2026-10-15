﻿// 分享提问页面
import { RouterHelper } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { promptAction } from '@kit.ArkUI';
import { AppStore } from '../store/AppStore';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

interface QuestionData {
  title: string;
  content: string;
  tags: string[];
  isAnonymous: boolean;
  createdAt: string;
  author: string;
}

@Entry
@Component
struct PostQuestion {
  @State private title: string = '';
  @State private content: string = '';
  @State private tags: string[] = [];
  @State private tagInput: string = '';
  @State private isLoading: boolean = false;
  @State private isAnonymous: boolean = false;
  @State private isDarkMode: boolean = false;

  aboutToAppear() {
    // 获取当前主题
    const store = AppStore.getInstance();
    const state = store.getState();
    this.isDarkMode = state.theme === 'dark';
  }

  // 添加标签
  addTag() {
    const tag = this.tagInput.trim();
    if (tag && !this.tags.includes(tag)) {
      this.tags.push(tag);
      this.tagInput = '';
    }
  }

  // 移除标签
  removeTag(index: number) {
    this.tags.splice(index, 1);
  }

  // 验证表单
  validateForm(): boolean {
    if (!this.title.trim()) {
      this.showToast('请输入问题标题');
      return false;
    }

    if (!this.content.trim()) {
      this.showToast('请输入问题内容');
      return false;
    }

    if (this.content.trim().length < 10) {
      this.showToast('问题内容至少需要10个字符');
      return false;
    }

    return true;
  }

  // 提交问题
  async submitQuestion() {
    if (!this.validateForm()) {
      return;
    }

    this.isLoading = true;

    try {
      // 模拟网络请求
      await new Promise<void>(resolve => setTimeout(resolve, 1000));

      // 这里应该调用API提交问题
      const questionData: QuestionData = {
        title: this.title.trim(),
        content: this.content.trim(),
        tags: this.tags,
        isAnonymous: this.isAnonymous,
        createdAt: new Date().toISOString(),
        author: this.isAnonymous ? '匿名用户' : '当前用户'
      };

      this.showToast('问题发布成功！');

      // 清空表单
      this.title = '';
      this.content = '';
      this.tags = [];
      this.tagInput = '';
      this.isAnonymous = false;

      // 延迟返回上一页
      setTimeout(() => {
        RouterHelper.back();
      }, 1500);

    } catch (error) {
      console.error('提交问题失败:', error);
      this.showToast('提交失败，请重试');
    } finally {
      this.isLoading = false;
    }
  }

  // 显示Toast
  showToast(message: string) {
    promptAction.showToast({
      message: message,
      duration: 2000
    });
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top', 'bottom']
      }) {
        Column() {
          // 导航栏
          Row({ space: CommonStyles.SPACE_MD }) {
            BackButton()

            Text('分享提问')
          .fontSize(CommonStyles.FONT_SIZE_XL)
          .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .layoutWeight(1)

        Text('发布')
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontColor(CommonStyles.PRIMARY_COLOR)
          .onClick(() => {
            this.submitQuestion();
          })
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

      Scroll() {
        Column({ space: CommonStyles.SPACE_XL }) {
          // 标题输入
          Column({ space: CommonStyles.SPACE_SM }) {
            Text('问题标题 *')
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(this.isDarkMode ? CommonStyles.TEXT_LIGHT : CommonStyles.TEXT_PRIMARY)
              .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
              .width('100%')
              .textAlign(TextAlign.Start)

            TextInput({ placeholder: '请输入问题标题（不超过50字）', text: this.title })
              .width('100%')
              .height(48)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .backgroundColor(this.isDarkMode ? CommonStyles.GRAY_800 : CommonStyles.WHITE)
              .borderRadius(CommonStyles.RADIUS_MD)
              .padding({ left: CommonStyles.SPACE_MD, right: CommonStyles.SPACE_MD })
              .border({
                width: 1,
                color: this.isDarkMode ? CommonStyles.GRAY_600 : CommonStyles.GRAY_300,
                radius: CommonStyles.RADIUS_MD
              })
              .maxLength(50)
              .onChange((value: string) => {
                this.title = value;
              })
          }
          .width('100%')
          .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG })

          // 内容输入
          Column({ space: CommonStyles.SPACE_SM }) {
            Text('问题内容 *')
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(this.isDarkMode ? CommonStyles.TEXT_LIGHT : CommonStyles.TEXT_PRIMARY)
              .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
              .width('100%')
              .textAlign(TextAlign.Start)

            TextArea({ placeholder: '请详细描述您的问题（至少10字）', text: this.content })
              .width('100%')
              .height(200)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .backgroundColor(this.isDarkMode ? CommonStyles.GRAY_800 : CommonStyles.WHITE)
              .borderRadius(CommonStyles.RADIUS_MD)
              .padding(CommonStyles.SPACE_MD)
              .border({
                width: 1,
                color: this.isDarkMode ? CommonStyles.GRAY_600 : CommonStyles.GRAY_300,
                radius: CommonStyles.RADIUS_MD
              })
              .maxLength(1000)
              .onChange((value: string) => {
                this.content = value;
              })
          }
          .width('100%')
          .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG })

          // 标签输入
          Column({ space: CommonStyles.SPACE_SM }) {
            Text('问题标签')
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(this.isDarkMode ? CommonStyles.TEXT_LIGHT : CommonStyles.TEXT_PRIMARY)
              .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
              .width('100%')
              .textAlign(TextAlign.Start)

            Row({ space: CommonStyles.SPACE_SM }) {
              TextInput({ placeholder: '输入标签后按回车添加', text: this.tagInput })
                .layoutWeight(1)
                .height(40)
                .fontSize(CommonStyles.FONT_SIZE_MD)
                .backgroundColor(this.isDarkMode ? CommonStyles.GRAY_800 : CommonStyles.WHITE)
                .borderRadius(CommonStyles.RADIUS_MD)
                .padding({ left: CommonStyles.SPACE_MD, right: CommonStyles.SPACE_MD })
                .border({
                  width: 1,
                  color: this.isDarkMode ? CommonStyles.GRAY_600 : CommonStyles.GRAY_300,
                  radius: CommonStyles.RADIUS_MD
                })
                .onChange((value: string) => {
                  this.tagInput = value;
                })
                .onSubmit(() => {
                  this.addTag();
                })

              Button('添加', { type: ButtonType.Normal })
                .height(40)
                .fontSize(CommonStyles.FONT_SIZE_MD)
                .fontColor(CommonStyles.WHITE)
                .backgroundColor(CommonStyles.PRIMARY_COLOR)
                .borderRadius(CommonStyles.RADIUS_MD)
                .onClick(() => {
                  this.addTag();
                })
            }
            .width('100%')

            // 标签列表
            if (this.tags.length > 0) {
              Row() {
                ForEach(this.tags, (tag: string, index: number) => {
                  Row({ space: CommonStyles.SPACE_XS }) {
                    Text(tag)
                      .fontSize(CommonStyles.FONT_SIZE_SM)
                      .fontColor(CommonStyles.PRIMARY_COLOR)

                    Text('✕')
                      .fontSize(12)
                      .fontColor(CommonStyles.TEXT_TERTIARY)
                      .onClick(() => {
                        this.removeTag(index);
                      })
                  }
                  .padding({
                    left: CommonStyles.SPACE_MD,
                    right: CommonStyles.SPACE_MD,
                    top: CommonStyles.SPACE_XS,
                    bottom: CommonStyles.SPACE_XS
                  })
                  .backgroundColor(this.isDarkMode ? CommonStyles.GRAY_700 : CommonStyles.GRAY_100)
                  .borderRadius(CommonStyles.RADIUS_MD)
                  .border({
                    width: 1,
                    color: CommonStyles.PRIMARY_COLOR,
                    radius: CommonStyles.RADIUS_MD
                  })
                })
              }
              .width('100%')
              .margin({ top: CommonStyles.SPACE_SM })
            }
          }
          .width('100%')
          .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG })

          // 匿名发布选项
          Row({ space: CommonStyles.SPACE_SM }) {
            Checkbox()
              .select(this.isAnonymous)
              .onChange((value: boolean) => {
                this.isAnonymous = value;
              })

            Text('匿名发布')
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(this.isDarkMode ? CommonStyles.TEXT_LIGHT : CommonStyles.TEXT_PRIMARY)
              .onClick(() => {
                this.isAnonymous = !this.isAnonymous;
              })
          }
          .width('100%')
          .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG })
          .justifyContent(FlexAlign.Start)

          // 发布按钮
          Button('发布问题', { type: ButtonType.Capsule, stateEffect: true })
            .width('90%')
            .height(56)
            .fontSize(CommonStyles.FONT_SIZE_LG)
            .fontColor(CommonStyles.WHITE)
            .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
            .backgroundColor(CommonStyles.PRIMARY_COLOR)
            .borderRadius(CommonStyles.RADIUS_LG)
            .enabled(!this.isLoading && this.title.trim().length > 0 && this.content.trim().length >= 10)
            .onClick(() => {
              this.submitQuestion();
            })
            .margin({ top: CommonStyles.SPACE_XL })

          // 加载动画
          if (this.isLoading) {
            LoadingProgress()
              .color(CommonStyles.PRIMARY_COLOR)
              .width(40)
              .height(40)
              .margin({ top: CommonStyles.SPACE_MD })
          }

          // 提示信息
          Column({ space: CommonStyles.SPACE_XS }) {
            Text('发布提示：')
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(this.isDarkMode ? CommonStyles.TEXT_LIGHT : CommonStyles.TEXT_PRIMARY)
              .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
              .width('100%')
              .textAlign(TextAlign.Start)

            Text('1. 请确保问题描述清晰具体')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(this.isDarkMode ? CommonStyles.TEXT_TERTIARY : CommonStyles.TEXT_SECONDARY)

            Text('2. 添加相关标签有助于更快获得回答')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(this.isDarkMode ? CommonStyles.TEXT_TERTIARY : CommonStyles.TEXT_SECONDARY)

            Text('3. 文明提问，遵守社区规范')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(this.isDarkMode ? CommonStyles.TEXT_TERTIARY : CommonStyles.TEXT_SECONDARY)
          }
          .width('100%')
          .padding({
            left: CommonStyles.SPACE_LG,
            right: CommonStyles.SPACE_LG,
            top: CommonStyles.SPACE_XL
          })
        }
        .width('100%')
        .padding({ top: CommonStyles.SPACE_LG, bottom: CommonStyles.SPACE_XL })
      }
      .scrollBar(BarState.Off)
        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: '45mm' })
  }
}