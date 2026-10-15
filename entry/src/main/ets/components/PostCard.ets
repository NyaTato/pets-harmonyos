import { CommonStyles } from '../common/css/CommonStyles';
import { ComponentStyles } from '../common/css/ComponentStyles';
import { Post } from '../mock/PostData';

@Component
export struct PostCard {
  @Prop post: Post | null = null;
  private onCardClick?: () => void;
  private onLikeClick?: () => void;
  private onFavoriteClick?: () => void;
  private onCommentClick?: () => void;

  @State isLiked: boolean = false;
  @State isFavorited: boolean = false;

  aboutToAppear() {
    this.isLiked = this.post?.isLiked || false;
    this.isFavorited = this.post?.isFavorited || false;
  }

  build() {
    Column({ space: CommonStyles.MD }) {
      // 头部：作者信息 + 分类标签
      Row() {
        // 作者头像
        Image(this.post?.authorAvatar ? $rawfile(this.post.authorAvatar) : $rawfile('avatars/avatar_fallback_30.jpg'))
          .width(36)
          .height(36)
          .borderRadius(18)
          .objectFit(ImageFit.Cover)

        Column({ space: 2 }) {
          Text(this.post?.author || '匿名用户')
            .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
            .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
            .fontColor(CommonStyles.TEXT_PRIMARY)

          Text(this.formatTime(this.post?.createTime))
            .fontSize(CommonStyles.FONT_SIZE_OVERLINE)
            .fontColor(CommonStyles.TEXT_DISABLED)
        }
        .margin({ left: CommonStyles.SM })
        .layoutWeight(1)

        // 分类标签
        Text(this.post?.category || '其他')
          .fontSize(CommonStyles.FONT_SIZE_OVERLINE)
          .fontColor(CommonStyles.WHITE)
          .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
          .padding({
            left: CommonStyles.SM,
            right: CommonStyles.SM,
            top: 4,
            bottom: 4
          })
          .borderRadius(CommonStyles.RADIUS_FULL)
          .backgroundColor(this.getCategoryColor())
      }
      .width('100%')

      // 帖子标题
      Text(this.post?.title || '')
        .fontSize(CommonStyles.FONT_SIZE_H3)
        .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
        .margin({ top: CommonStyles.XS })

      // 帖子内容预览
      if (this.post?.content) {
        Text(this.post.content)
          .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
          .fontColor(CommonStyles.TEXT_SECONDARY)
          .maxLines(3)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(CommonStyles.LINE_HEIGHT_RELAXED)
          .width('100%')
      }

      // 标签区域
      if (this.post?.tags && this.post.tags.length > 0) {
        Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
          ForEach(this.post.tags.slice(0, 3), (tag: string) => {
            Text(`#${tag}`)
              .fontSize(CommonStyles.FONT_SIZE_OVERLINE)
              .fontColor(CommonStyles.PRIMARY)
              .padding({
                left: CommonStyles.SM,
                right: CommonStyles.XS,
                top: 2,
                bottom: 2
              })
              .margin({ right: CommonStyles.XS, top: CommonStyles.XS })
              .backgroundColor(CommonStyles.PRIMARY_BG)
              .borderRadius(CommonStyles.RADIUS_SM)
          })
        }
        .width('100%')
      }

      // 分割线
      Row()
        .width('100%')
        .height(1)
        .backgroundColor(CommonStyles.BORDER_SUBTLE)

      // 底部互动栏
      Row() {
        // 点赞
        this.createInteractionButton(
          this.isLiked ? '♥' : '♡',
          (this.post?.likes || 0).toString(),
          this.isLiked ? CommonStyles.SECONDARY : CommonStyles.TEXT_TERTIARY,
          () => {
            this.isLiked = !this.isLiked;
            this.onLikeClick?.();
          }
        )

        // 评论
        this.createInteractionButton(
          '💬',
          (this.post?.comments || 0).toString(),
          CommonStyles.TEXT_TERTIARY,
          () => {
            this.onCommentClick?.();
          }
        )

        // 收藏
        this.createInteractionButton(
          this.isFavorited ? '★' : '☆',
          this.isFavorited ? '已收藏' : '收藏',
          this.isFavorited ? CommonStyles.WARNING : CommonStyles.TEXT_TERTIARY,
          () => {
            this.isFavorited = !this.isFavorited;
            this.onFavoriteClick?.();
          }
        )

        Blank()

        // 浏览量
        Row({ space: 4 }) {
          Text('👁')
            .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
          Text((this.post?.views || 0).toString())
            .fontSize(CommonStyles.FONT_SIZE_CAPTION)
            .fontColor(CommonStyles.TEXT_DISABLED)
        }
      }
      .width('100%')
    }
    .width('100%')
    .padding(CommonStyles.MD)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(ComponentStyles.CARD_STANDARD.shadow)
    .border({
      width: 1,
      color: CommonStyles.BORDER_SUBTLE,
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_XL
    })
    .margin({ bottom: CommonStyles.MD })
    .onClick(() => {
      this.onCardClick?.();
    })
  }

  @Builder
  createInteractionButton(icon: string, text: string, color: string, onClick?: () => void) {
    Row({ space: 4 }) {
      Text(icon)
        .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
        .fontColor(color)
      Text(text)
        .fontSize(CommonStyles.FONT_SIZE_CAPTION)
        .fontColor(color)
    }
    .padding({
      right: CommonStyles.MD
    })
    .onClick(() => {
      onClick?.();
    })
  }

  private getCategoryColor(): string {
    const categoryColors: Record<string, string> = {
      '宠物日常': '#4A90E2',
      '健康医疗': '#34C759',
      '行为训练': '#FF9500',
      '寄养服务': '#AF52DE',
      '领养故事': '#FF6B9D',
      '其他': CommonStyles.GRAY_400
    };
    return categoryColors[this.post?.category || ''] || CommonStyles.GRAY_400;
  }

  private formatTime(time?: string): string {
    if (!time) return '';
    return time;
  }
}
