import { RouterHelper } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { submitFeedback, FeedbackInput } from '../mock/NoticeData';
import { AppStore } from '../store/AppStore';
import { filterPost } from '../mock/SensitiveWordFilter';
import { promptAction } from '@kit.ArkUI';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

@Entry
@Component
struct Feedback {
  @State private feedbackTypeIndex: number = 0;
  @State private title: string = '';
  @State private content: string = '';
  @State private images: string[] = [];
  @State private isSubmitting: boolean = false;
  @State private errorMessage: string = '';
  @State private successMessage: string = '';

  private typeOptions: ('其他' | '建议' | '问题' | '投诉')[] = ['其他', '建议', '问题', '投诉'];

  @Builder NavigationBar() {
    Row() {
      BackButton()

      Text('意见反馈')
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

  @Builder TypeSelector() {
    Column({ space: CommonStyles.SM }) {
      Row() {
        Text('反馈类型 *')
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)
      }
      .width('100%')

      Scroll() {
        Row({ space: CommonStyles.SM }) {
          ForEach(this.typeOptions, (type: '其他' | '建议' | '问题' | '投诉', index: number): void => {
            this.TypeOptionItem(type, this.getTypeIcon(type), this.feedbackTypeIndex === index, () => {
              this.feedbackTypeIndex = index;
            })
          })
        }
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
    }
    .width('100%')
    .padding(CommonStyles.LG)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  @Builder TitleInput() {
    Column({ space: CommonStyles.SM }) {
      Row() {
        Text('标题 *')
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Text(this.title.length + '/50')
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(this.title.length > 50 ? CommonStyles.DANGER : CommonStyles.TEXT_TERTIARY)
      }
      .width('100%')

      TextInput({ placeholder: '请输入反馈标题，5-50个字符', text: this.title })
        .width('100%')
        .height(CommonStyles.INPUT_HEIGHT)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .placeholderColor(CommonStyles.GRAY_400)
        .placeholderFont({ size: CommonStyles.FONT_SIZE_MD })
        .backgroundColor(CommonStyles.GRAY_50)
        .borderRadius(CommonStyles.RADIUS_MD)
        .padding({ left: CommonStyles.SM, right: CommonStyles.SM })
        .maxLength(50)
        .onChange((value: string): void => {
          this.title = value;
          this.errorMessage = '';
          this.successMessage = '';
        })
    }
    .width('100%')
    .padding(CommonStyles.LG)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  @Builder ContentInput() {
    Column({ space: CommonStyles.SM }) {
      Row() {
        Text('详细内容 *')
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Text(this.content.length + '/500')
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(this.content.length > 500 ? CommonStyles.DANGER : CommonStyles.TEXT_TERTIARY)
      }
      .width('100%')

      TextArea({ placeholder: '请输入详细内容，描述问题或建议，10-500个字符', text: this.content })
        .width('100%')
        .height(200)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .placeholderColor(CommonStyles.GRAY_400)
        .placeholderFont({ size: CommonStyles.FONT_SIZE_MD })
        .backgroundColor(CommonStyles.GRAY_50)
        .borderRadius(CommonStyles.RADIUS_MD)
        .padding({ left: CommonStyles.SM, right: CommonStyles.SM, top: CommonStyles.SM, bottom: CommonStyles.SM })
        .maxLength(500)
        .onChange((value: string): void => {
          this.content = value;
          this.errorMessage = '';
          this.successMessage = '';
        })
    }
    .width('100%')
    .padding(CommonStyles.LG)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  @Builder ImageUploader() {
    Column({ space: CommonStyles.SM }) {
      Row() {
        Text('示例图片（可选）')
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Text(this.images.length + '/3')
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.TEXT_TERTIARY)
      }
      .width('100%')

      Text('原型演示用示例图，最多可添加 3 张示例图')
        .fontSize(CommonStyles.FONT_SIZE_SM)
        .fontColor(CommonStyles.TEXT_TERTIARY)
        .width('100%')

      if (this.images.length > 0) {
        Scroll() {
          Row({ space: CommonStyles.SM }) {
            ForEach(this.images, (image: string, index: number): void => {
              Stack({ alignContent: Alignment.TopEnd }) {
                Image($rawfile(image))
                  .width(CommonStyles.SIZE_XL)
                  .height(CommonStyles.SIZE_XL)
                  .borderRadius(CommonStyles.RADIUS_MD)
                  .objectFit(ImageFit.Cover)

                Row() {
                  Text('✕')
                    .fontSize(CommonStyles.FONT_SIZE_SM)
                    .fontColor(CommonStyles.WHITE)
                }
                .width(20)
                .height(20)
                .justifyContent(FlexAlign.Center)
                .alignItems(VerticalAlign.Center)
                .backgroundColor(CommonStyles.DANGER)
                .borderRadius(CommonStyles.RADIUS_FULL)
                .margin({ top: -4, right: -4 })
                .onClick(() => {
                  this.removeImage(index);
                })
              }
              .width(CommonStyles.SIZE_XL)
            })

            if (this.images.length < 3) {
              Column({ space: CommonStyles.XS }) {
                Text('+')
                  .fontSize(CommonStyles.FONT_SIZE_XL)
                  .fontColor(CommonStyles.TEXT_TERTIARY)

                Text('添加示例图')
                  .fontSize(CommonStyles.FONT_SIZE_SM)
                  .fontColor(CommonStyles.TEXT_TERTIARY)
              }
              .width(CommonStyles.SIZE_XL)
              .height(CommonStyles.SIZE_XL)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .backgroundColor(CommonStyles.GRAY_100)
              .borderRadius(CommonStyles.RADIUS_MD)
              .border({
                width: 1.5,
                color: CommonStyles.GRAY_300,
                style: BorderStyle.Dashed
              })
              .onClick(() => {
                this.selectImage();
              })
            }
          }
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .width('100%')
        .margin({ top: CommonStyles.SM })
      } else {
        Column({ space: CommonStyles.SM }) {
          Text('📷')
            .fontSize(40)

          Text('点击添加示例图')
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(CommonStyles.TEXT_SECONDARY)

          Text('本地 Mock 示例图，非相册读取或真实上传')
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.TEXT_TERTIARY)
        }
        .width('100%')
        .height(150)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(CommonStyles.GRAY_50)
        .borderRadius(CommonStyles.RADIUS_LG)
        .border({
          width: 1.5,
          color: CommonStyles.GRAY_200,
          style: BorderStyle.Dashed
        })
        .margin({ top: CommonStyles.SM })
        .onClick(() => {
          this.selectImage();
        })
      }
    }
    .width('100%')
    .padding(CommonStyles.LG)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  @Builder StatusMessages() {
    Column({ space: CommonStyles.SM }) {
      Row({ space: CommonStyles.SM }) {
        Circle()
          .width(18)
          .height(18)
          .fill(CommonStyles.DANGER)

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

      Row({ space: CommonStyles.SM }) {
        Circle()
          .width(18)
          .height(18)
          .fill(CommonStyles.SUCCESS)

        Text(this.successMessage)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.SUCCESS)
          .layoutWeight(1)
      }
      .width('100%')
      .padding(CommonStyles.MD)
      .backgroundColor('#DCFCE7')
      .borderRadius(CommonStyles.RADIUS_MD)
      .visibility(this.successMessage ? Visibility.Visible : Visibility.None)
    }
    .width('100%')
  }

  @Builder SubmitButton() {
    Column() {
      Button() {
        Row({ space: CommonStyles.SM }) {
          if (this.isSubmitting) {
            LoadingProgress()
              .width(CommonStyles.SIZE_SM)
              .height(CommonStyles.SIZE_SM)
              .color(CommonStyles.WHITE)
          } else {
            Text('提交反馈')
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
        this.handleSubmit();
      })
    }
    .width('100%')
    .padding({ left: CommonStyles.LG, right: CommonStyles.LG, top: CommonStyles.MD, bottom: CommonStyles.LG })
    .backgroundColor(CommonStyles.WHITE)
    .shadow(CommonStyles.SHADOW_MD)
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
              this.TypeSelector()
              this.TitleInput()
              this.ContentInput()
              this.ImageUploader()
              this.StatusMessages()
            }
            .padding({ left: CommonStyles.LG, right: CommonStyles.LG, bottom: CommonStyles.SPACE_3XL })
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)
          .layoutWeight(1)

          this.SubmitButton()
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

  @Builder TypeOptionItem(label: string, icon: string, isActive: boolean, onTap: () => void) {
    Row({ space: CommonStyles.XS }) {
      Text(icon)
        .fontSize(CommonStyles.FONT_SIZE_MD)

      Text(label)
        .fontSize(CommonStyles.FONT_SIZE_SM)
        .fontWeight(isActive ? FontWeight.Medium : FontWeight.Normal)
    }
    .padding({ left: CommonStyles.MD, right: CommonStyles.MD, top: CommonStyles.SM, bottom: CommonStyles.SM })
    .backgroundColor(isActive ? CommonStyles.PRIMARY : CommonStyles.GRAY_100)
    .borderRadius(CommonStyles.RADIUS_FULL)
    .onClick(() => {
      onTap();
    })
  }

  private getTypeIcon(type: string): string {
    if (type === '建议') { return '💡'; }
    if (type === '问题') { return '❓'; }
    if (type === '投诉') { return '⚠️'; }
    if (type === '其他') { return '👍'; }
    return '📝';
  }

  private selectImage(): void {
    if (this.images.length < 3) {
      const mockImages: string[] = [
        'pets/pet_corgi_01.jpg',
        'pets/pet_orange_cat_01.jpg',
        'pets/pet_ragdoll_01.jpg'
      ];
      this.images = [...this.images, mockImages[this.images.length % mockImages.length]];
    }
  }

  private removeImage(index: number): void {
    const newImages: string[] = [...this.images];
    newImages.splice(index, 1);
    this.images = newImages;
  }

  private handleSubmit(): void {
    const store = AppStore.getInstance();
    const state = store.getState();
    const currentUser = state.currentUser;

    if (!this.title.trim()) {
      this.errorMessage = '请输入反馈标题';
      return;
    }

    if (this.title.length < 5 || this.title.length > 50) {
      this.errorMessage = '标题长度应在5-50个字符之间';
      return;
    }

    if (!this.content.trim()) {
      this.errorMessage = '请输入反馈内容';
      return;
    }

    if (this.content.length < 10 || this.content.length > 500) {
      this.errorMessage = '内容长度应在10-500个字符之间';
      return;
    }

    const filtered = filterPost(this.title, this.content);
    if (filtered.hasSensitive) {
      this.errorMessage = '内容包含敏感词汇，请修改后再提交';
      return;
    }

    if (!currentUser) {
      this.errorMessage = '请先登录';
      RouterHelper.replaceUrl("pages/Login");
      return;
    }

    this.isSubmitting = true;
    this.errorMessage = '';
    this.successMessage = '';

    setTimeout((): void => {
      const feedbackData: FeedbackInput = {
        userId: currentUser.id,
        userName: currentUser.nickname,
        type: this.typeOptions[this.feedbackTypeIndex],
        title: this.title,
        content: this.content,
        images: this.images
      };

      const result = submitFeedback(feedbackData);

      if (result) {
        this.successMessage = '感谢您的反馈，我们会认真处理并回复您';
        this.title = '';
        this.content = '';
        this.images = [];
        this.feedbackTypeIndex = 0;

        setTimeout((): void => {
          this.successMessage = '';
        }, 3000);
      } else {
        this.errorMessage = '提交失败，请稍后重试';
      }

      this.isSubmitting = false;
    }, 1500);
  }

  private showToast(message: string): void {
    promptAction.showToast({
      message: message,
      duration: 2000
    });
  }
}
