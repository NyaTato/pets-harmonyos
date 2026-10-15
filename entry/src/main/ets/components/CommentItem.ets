import { CommonStyles } from '../common/css/CommonStyles';
import { Comment, Reply } from '../mock/PostData';

interface ReplyItemProps {
  reply: Reply;
}

@Component
export struct CommentItem {
  @Prop comment: Comment | null = null;
  // 使用普通属性而不是@Prop，因为@Prop不支持函数类型
  private onLikeClick?: () => void;
  private onReplyClick?: () => void;
  @Prop showReplyButton: boolean = true;

  @State isLiked: boolean = false;
  @State likeCount: number = 0;

  aboutToAppear() {
    this.isLiked = this.comment?.isLiked || false;
    this.likeCount = this.comment?.likes || 0;
  }

  build() {
    Column({ space: CommonStyles.SPACE_MD }) {
      // 评论头部
      Row({ space: CommonStyles.SPACE_SM }) {
        // 用户头像
        Image(this.comment?.userAvatar ? $rawfile(this.comment.userAvatar) : $rawfile('avatars/avatar_fallback_40.jpg'))
          .width(40)
          .height(40)
          .borderRadius(20)
          .objectFit(ImageFit.Cover)

        // 用户信息和时间
        Column({ space: 2 }) {
          Text(this.comment?.userName || '匿名用户')
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
            .fontColor(CommonStyles.TEXT_PRIMARY)

          Text(this.comment?.createTime || '未知')
            .fontSize(CommonStyles.FONT_SIZE_XS)
            .fontColor(CommonStyles.TEXT_TERTIARY)
        }
        .layoutWeight(1)

        // 点赞按钮
        Row({ space: 4 }) {
          Image(this.isLiked ? 'common/images/like_filled.png' : 'common/images/like_outline.png')
            .width(16)
            .height(16)
            .onClick(() => {
              this.isLiked = !this.isLiked;
              this.likeCount = this.isLiked ? this.likeCount + 1 : this.likeCount - 1;
              this.onLikeClick?.();
            })
          Text(this.likeCount.toString())
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(this.isLiked ? CommonStyles.SECONDARY_COLOR : CommonStyles.TEXT_TERTIARY)
        }
      }
      .width('100%')

      // 评论内容
      Text(this.comment?.content || '')
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ top: CommonStyles.SPACE_SM })

      // 回复按钮
      if (this.showReplyButton) {
        Row() {
          Button('回复', { type: ButtonType.Normal })
            .width(60)
            .height(24)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.PRIMARY_COLOR)
            .backgroundColor('#00000000')
            .border({
              width: 1,
              color: CommonStyles.PRIMARY_COLOR,
              radius: CommonStyles.RADIUS_SM
            })
            .onClick(() => {
              this.onReplyClick?.();
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .margin({ top: CommonStyles.SPACE_SM })
      }

      // 回复列表
      if (this.comment?.replies && this.comment.replies.length > 0) {
        Column({ space: CommonStyles.SPACE_MD }) {
          ForEach(this.comment.replies, (reply: Reply) => {
            this.ReplyItem({ reply: reply })
          })
        }
        .width('100%')
        .margin({ top: CommonStyles.SPACE_MD })
        .padding({
          left: CommonStyles.SPACE_MD,
          top: CommonStyles.SPACE_MD,
          bottom: CommonStyles.SPACE_MD
        })
        .backgroundColor(CommonStyles.GRAY_100)
        .borderRadius(CommonStyles.RADIUS_MD)
      }
    }
    .padding(CommonStyles.SPACE_MD)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
    .width('100%')
    .margin({ bottom: CommonStyles.SPACE_MD })
  }

  @Builder
  ReplyItem(props: ReplyItemProps) {
    Column({ space: CommonStyles.SPACE_SM }) {
      // 回复头部
      Row({ space: CommonStyles.SPACE_SM }) {
        // 用户头像
        Image(props.reply?.userAvatar ? $rawfile(props.reply.userAvatar) : $rawfile('avatars/avatar_fallback_30.jpg'))
          .width(30)
          .height(30)
          .borderRadius(15)
          .objectFit(ImageFit.Cover)

        // 用户信息和时间
        Column({ space: 2 }) {
          Row({ space: CommonStyles.SPACE_XS }) {
            Text(props.reply?.userName || '匿名用户')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
              .fontColor(CommonStyles.TEXT_PRIMARY)

            Text('回复')
              .fontSize(CommonStyles.FONT_SIZE_XS)
              .fontColor(CommonStyles.TEXT_TERTIARY)
          }

          Text(props.reply?.createTime || '未知')
            .fontSize(CommonStyles.FONT_SIZE_XS)
            .fontColor(CommonStyles.TEXT_TERTIARY)
        }
        .layoutWeight(1)

        // 点赞按钮
        Row({ space: 4 }) {
          Image(props.reply?.isLiked ? 'common/images/like_filled.png' : 'common/images/like_outline.png')
            .width(14)
            .height(14)
          Text((props.reply?.likes || 0).toString())
            .fontSize(CommonStyles.FONT_SIZE_XS)
            .fontColor(CommonStyles.TEXT_TERTIARY)
        }
      }
      .width('100%')

      // 回复内容
      Text(props.reply?.content || '')
        .fontSize(CommonStyles.FONT_SIZE_SM)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ top: 4 })
    }
    .width('100%')
    .padding({
      left: CommonStyles.SPACE_MD,
      right: CommonStyles.SPACE_MD,
      top: CommonStyles.SPACE_SM,
      bottom: CommonStyles.SPACE_SM
    })
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_MD)
    .shadow(CommonStyles.SHADOW_SM)
  }
}
