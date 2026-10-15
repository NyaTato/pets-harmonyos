import { RouterHelper, RouteParams } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { getPostById, getPostComments, addComment, likeComment, Post, Comment as PostComment } from '../mock/PostData';
import { AppStore } from '../store/AppStore';
import { promptAction } from '@kit.ArkUI';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

@Entry
@Component
struct Comment {
  @State private post: Post | null = null;
  @State private comments: PostComment[] = [];
  @State private isLoading: boolean = true;
  @State private newComment: string = '';
  @State private isSubmitting: boolean = false;

  aboutToAppear() {
    const params = RouterHelper.getParams();
    const postId = params.postId ? parseInt(params.postId) : 1;
    this.loadPost(postId);
  }

  loadPost(postId: number) {
    this.isLoading = true;

    setTimeout(() => {
      this.post = getPostById(postId);
      this.comments = getPostComments(postId);
      this.isLoading = false;
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
            Column({ space: CommonStyles.LG }) {
              this.LoadingContent()
              this.ErrorContent()
              this.PostDetail()
              this.CommentsSection()
            }
            .padding({ left: CommonStyles.LG, right: CommonStyles.LG, bottom: CommonStyles.SPACE_3XL })
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)
          .layoutWeight(1)

          this.CommentInput()
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

      Text('评论详情')
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

  @Builder ErrorContent() {
    Column() {
      Text('💬')
        .fontSize(64)

      Text('帖子不存在')
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .margin({ top: CommonStyles.LG })

      Text('该帖子可能已被删除或链接失效')
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .margin({ top: CommonStyles.XS })

      Button('返回列表', { type: ButtonType.Capsule })
        .width(CommonStyles.BUTTON_WIDTH_LG)
        .height(CommonStyles.BUTTON_HEIGHT_LG)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.PRIMARY)
        .backgroundColor(Color.Transparent)
        .borderWidth(1.5)
        .borderColor(CommonStyles.PRIMARY)
        .borderRadius(CommonStyles.RADIUS_FULL)
        .margin({ top: CommonStyles.XL })
        .onClick(() => {
          RouterHelper.back();
        })
    }
    .width('100%')
    .height(CommonStyles.SIZE_2XL)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .visibility((!this.isLoading && !this.post) ? Visibility.Visible : Visibility.None)
  }

  @Builder PostDetail() {
    Column({ space: CommonStyles.LG }) {
      Column({ space: CommonStyles.MD }) {
        Text(this.post?.title || '')
          .fontSize(CommonStyles.FONT_SIZE_XL)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Row({ space: CommonStyles.SM }) {
          Image(this.post?.authorAvatar ? $rawfile(this.post.authorAvatar) : '')
            .width(CommonStyles.AVATAR_SIZE_SM)
            .height(CommonStyles.AVATAR_SIZE_SM)
            .borderRadius(CommonStyles.RADIUS_FULL)
            .objectFit(ImageFit.Cover)

          Column({ space: CommonStyles.XS }) {
            Text(this.post?.author || '匿名用户')
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(CommonStyles.TEXT_PRIMARY)

            Text(this.post?.createTime || '')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(CommonStyles.TEXT_TERTIARY)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Text(this.getCategoryTag())
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.WHITE)
            .padding({ left: CommonStyles.SM, right: CommonStyles.SM, top: CommonStyles.XS, bottom: CommonStyles.XS })
            .backgroundColor(this.getCategoryColor())
            .borderRadius(CommonStyles.RADIUS_FULL)
        }
      }
      .width('100%')

      Divider().color(CommonStyles.GRAY_200).width('100%')

      Text(this.post?.content || '')
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .lineHeight(22)
        .width('100%')

      if (this.post && this.post.tags.length > 0) {
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.post.tags, (tag: string) => {
            Text(`#${tag}`)
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(CommonStyles.PRIMARY)
              .padding({ left: CommonStyles.SM, right: CommonStyles.SM, top: CommonStyles.XS, bottom: CommonStyles.XS })
              .backgroundColor(CommonStyles.PRIMARY_LIGHT)
              .borderRadius(CommonStyles.RADIUS_FULL)
              .margin({ right: CommonStyles.SM, bottom: CommonStyles.SM })
          })
        }
        .width('100%')
      }
    }
    .width('100%')
    .padding(CommonStyles.LG)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
    .visibility((!this.isLoading && this.post) ? Visibility.Visible : Visibility.None)
  }

  @Builder CommentsSection() {
    Column({ space: CommonStyles.LG }) {
      Row() {
        Text('💬')
          .fontSize(CommonStyles.FONT_SIZE_LG)

        Text(`评论 (${this.comments.length})`)
          .fontSize(CommonStyles.FONT_SIZE_LG)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .margin({ left: CommonStyles.SM })
      }
      .width('100%')

      this.EmptyComments()
      this.CommentsList()
    }
    .width('100%')
    .visibility((!this.isLoading && this.post) ? Visibility.Visible : Visibility.None)
  }

  @Builder EmptyComments() {
    Column() {
      Text('💭')
        .fontSize(48)

      Text('暂无评论')
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .margin({ top: CommonStyles.MD })

      Text('快来发表第一条评论吧 ✨')
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .margin({ top: CommonStyles.XS })
    }
    .width('100%')
    .height(CommonStyles.SIZE_2XL)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .visibility((this.comments.length === 0) ? Visibility.Visible : Visibility.None)
  }

  @Builder CommentsList() {
    Column({ space: CommonStyles.MD }) {
      ForEach(this.comments, (comment: PostComment) => {
        this.CommentCard(comment)
      })
    }
    .width('100%')
    .visibility((this.comments.length > 0) ? Visibility.Visible : Visibility.None)
  }

  @Builder CommentCard(comment: PostComment) {
    Column({ space: CommonStyles.SM }) {
      Row({ space: CommonStyles.SM }) {
        Image(comment.userAvatar || '')
          .width(CommonStyles.AVATAR_SIZE_SM)
          .height(CommonStyles.AVATAR_SIZE_SM)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .objectFit(ImageFit.Cover)

        Column({ space: CommonStyles.XS }) {
          Row() {
            Text(comment.userName)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontWeight(FontWeight.Medium)
              .fontColor(CommonStyles.TEXT_PRIMARY)

            Text(comment.createTime || '')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(CommonStyles.TEXT_TERTIARY)
              .margin({ left: CommonStyles.SM })
          }
          .width('100%')

          Text(comment.content)
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .lineHeight(20)
            .width('100%')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')

      Row({ space: CommonStyles.SM }) {
        Row({ space: CommonStyles.XS }) {
          Text('👍')
            .fontSize(CommonStyles.FONT_SIZE_SM)

          Text(`${comment.likes}`)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.TEXT_SECONDARY)
        }
        .onClick(() => {
          this.handleLikeComment(comment.id);
        })

        Row({ space: CommonStyles.XS }) {
          Text('💬')
            .fontSize(CommonStyles.FONT_SIZE_SM)

          Text('回复')
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.TEXT_SECONDARY)
        }
        .margin({ left: CommonStyles.MD })

        Blank()

        Text('举报 ⚠️')
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.TEXT_TERTIARY)
      }
      .width('100%')
      .padding({ left: CommonStyles.AVATAR_SIZE_SM + CommonStyles.SM })
    }
    .width('100%')
    .padding(CommonStyles.MD)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
  }

  @Builder CommentInput() {
    Row({ space: CommonStyles.SM }) {
      TextInput({ placeholder: '写下你的评论...', text: this.newComment })
        .layoutWeight(1)
        .height(CommonStyles.INPUT_HEIGHT)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .placeholderColor(CommonStyles.GRAY_400)
        .backgroundColor(CommonStyles.GRAY_50)
        .borderRadius(CommonStyles.RADIUS_FULL)
        .padding({ left: CommonStyles.MD, right: CommonStyles.MD })
        .onChange((value: string) => {
          this.newComment = value;
        })

      Button('发送', { type: ButtonType.Capsule })
        .height(CommonStyles.INPUT_HEIGHT)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.WHITE)
        .backgroundColor(this.newComment.trim() ? CommonStyles.PRIMARY : CommonStyles.GRAY_300)
        .borderRadius(CommonStyles.RADIUS_FULL)
        .enabled(!!this.newComment.trim())
        .shadow(this.newComment.trim() ? CommonStyles.SHADOW_BRAND_OLD : CommonStyles.SHADOW_NONE)
        .onClick(() => {
          this.handleSubmitComment();
        })
    }
    .width('100%')
    .padding({ left: CommonStyles.LG, right: CommonStyles.LG, top: CommonStyles.SM, bottom: CommonStyles.SM })
    .backgroundColor(CommonStyles.WHITE)
    .shadow(CommonStyles.SHADOW_MD)
    .visibility((this.post && !this.isLoading) ? Visibility.Visible : Visibility.None)
  }

  private getCategoryColor(): string {
    const categoryColors: Record<string, string> = {
      '领养故事': '#3B82F6',
      '养护知识': '#10B981',
      '行为训练': '#F59E0B',
      '宠物用品': '#8B5CF6',
      '其他': '#6B7280'
    };

    return categoryColors[this.post?.category || ''] || CommonStyles.PRIMARY_DARK;
  }

  private getCategoryTag(): string {
    return this.post?.category || '其他';
  }

  private handleLikeComment(commentId: number) {
    const store = AppStore.getInstance();
    const state = store.getState();

    if (!state.currentUser) {
      RouterHelper.replaceUrl("pages/Login");
      return;
    }

    const success = likeComment(commentId);

    if (success) {
      if (this.post) {
        this.comments = getPostComments(this.post.id);
      }
      this.showToast('✓ 点赞成功');
    } else {
      this.showToast('点赞失败');
    }
  }

  private handleSubmitComment() {
    if (!this.newComment.trim()) {
      this.showToast('请输入评论内容');
      return;
    }

    if (!this.post) {
      this.showToast('帖子不存在');
      return;
    }

    const store = AppStore.getInstance();
    const state = store.getState();
    const currentUser = state.currentUser;

    if (!currentUser) {
      RouterHelper.replaceUrl("pages/Login");
      return;
    }

    this.isSubmitting = true;

    const newComment = addComment(
      this.post.id,
      currentUser.id,
      currentUser.nickname,
      currentUser.avatar || '',
      this.newComment
    );

    if (newComment) {
      this.comments = [newComment, ...this.comments];
      this.newComment = '';
      this.isSubmitting = false;
      this.showToast('✓ 评论发布成功');
    } else {
      this.isSubmitting = false;
      this.showToast('✗ 评论发布失败');
    }
  }

  private showToast(message: string) {
    promptAction.showToast({
      message: message,
      duration: 2000
    });
  }
}
