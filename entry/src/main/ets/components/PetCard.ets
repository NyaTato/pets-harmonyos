import { CommonStyles } from '../common/css/CommonStyles';
import { ComponentStyles } from '../common/css/ComponentStyles';
import { Pet } from '../mock/PetData';

@Component
export struct PetCard {
  @Prop pet: Pet;
  private onDetailClick?: () => void;
  private onLikeClick?: () => void;
  private onFavoriteClick?: () => void;

  @State isLiked: boolean = false;
  @State isFavorited: boolean = false;

  aboutToAppear() {
    this.isLiked = this.pet?.isLiked ?? false;
    this.isFavorited = this.pet?.isFavorited ?? false;
  }

  build() {
    Column() {
      // 宠物图片区域
      Stack({ alignContent: Alignment.Bottom }) {
        Image(this.pet?.pics?.[0] || $r('app.media.startIcon'))
          .width('100%')
          .height(160)
          .objectFit(ImageFit.Cover)
          .borderRadius({
            topLeft: CommonStyles.RADIUS_XL,
            topRight: CommonStyles.RADIUS_XL
          })

        // 渐变遮罩
        Row()
          .width('100%')
          .height(60)
          .linearGradient({
            angle: 180,
            colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0.5)', 1]]
          })
          .position({ x: 0, y: '100%' })
          .translate({ y: -60 })

        // 状态标签
        Row() {
          Text(this.getStatusText(this.pet?.adoptionStatus) || '待领养')
            .fontSize(CommonStyles.FONT_SIZE_CAPTION)
            .fontColor(CommonStyles.WHITE)
            .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
            .padding({
              left: CommonStyles.SM,
              right: CommonStyles.SM,
              top: 4,
              bottom: 4
            })
            .borderRadius(CommonStyles.RADIUS_SM)
            .backgroundColor(this.getStatusColor())
        }
        .position({ x: CommonStyles.MD, y: -50 })

        // 心情标签（如果有）
        if (this.pet?.mood) {
          Row({ space: CommonStyles.XS }) {
            Text(this.getMoodEmoji())
              .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
            Text(this.pet.mood)
              .fontSize(CommonStyles.FONT_SIZE_CAPTION)
              .fontColor(CommonStyles.WHITE)
          }
          .padding({
            left: CommonStyles.SM,
            right: CommonStyles.SM,
            top: 4,
            bottom: 4
          })
          .borderRadius(CommonStyles.RADIUS_SM)
          .backgroundColor(this.getMoodColor())
          .position({ x: '100%', y: -50 })
          .translate({ x: -(this.pet.mood.length * 12 + 32) })
        }
      }
      .width('100%')
      .height(160)

      // 卡片内容区域
      Column({ space: CommonStyles.SM }) {
        // 名称和类型标签
        Row() {
          Text(this.pet?.name || '未知')
            .fontSize(CommonStyles.FONT_SIZE_H3)
            .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)

          Text(this.getTypeLabel())
            .fontSize(CommonStyles.FONT_SIZE_CAPTION)
            .fontColor(CommonStyles.WHITE)
            .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
            .padding({
              left: CommonStyles.SM,
              right: CommonStyles.SM,
              top: 4,
              bottom: 4
            })
            .borderRadius(CommonStyles.RADIUS_FULL)
            .backgroundColor(this.getTypeColor())
        }
        .width('100%')

        // 基础信息
        Text(`${this.pet?.age || '未知'} · ${this.pet?.gender || '未知'}${this.pet?.breed ? ' · ' + this.pet.breed : ''}`)
          .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
          .fontColor(CommonStyles.TEXT_SECONDARY)
          .width('100%')

        // 健康状态标签
        if (this.hasHealthTags()) {
          Row({ space: CommonStyles.XS }) {
            if (this.pet?.vaccines && this.pet.vaccines.length > 0) {
              this.createHealthTag('已免疫', CommonStyles.SUCCESS)
            }
            if (this.pet?.isSterilized) {
              this.createHealthTag('已绝育', CommonStyles.INFO)
            }
            if (this.pet?.health === '健康') {
              this.createHealthTag('健康', CommonStyles.WARNING)
            }
          }
          .width('100%')
        }

        // 分割线
        Row()
          .width('100%')
          .height(1)
          .backgroundColor(CommonStyles.BORDER_SUBTLE)
          .margin({ top: CommonStyles.SM })

        // 底部操作栏
        Row() {
          // 点赞
          this.createActionButton(
            this.isLiked ? '♥' : '♡',
            this.pet?.likes?.toString() || '0',
            this.isLiked ? CommonStyles.SECONDARY : CommonStyles.TEXT_TERTIARY,
            () => {
              this.isLiked = !this.isLiked;
              this.onLikeClick?.();
            }
          )

          // 收藏
          this.createActionButton(
            this.isFavorited ? '★' : '☆',
            this.pet?.favorites?.toString() || '0',
            this.isFavorited ? CommonStyles.WARNING : CommonStyles.TEXT_TERTIARY,
            () => {
              this.isFavorited = !this.isFavorited;
              this.onFavoriteClick?.();
            }
          )

          // 浏览量
          this.createActionButton(
            '👁',
            this.pet?.views?.toString() || '0',
            CommonStyles.TEXT_TERTIARY,
            undefined
          )

          Blank()

          // 查看详情按钮
          Button('查看详情', { type: ButtonType.Capsule, stateEffect: true })
            .height(28)
            .fontSize(CommonStyles.FONT_SIZE_CAPTION)
            .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
            .fontColor(CommonStyles.WHITE)
            .backgroundColor(CommonStyles.PRIMARY)
            .onClick(() => {
              this.onDetailClick?.();
            })
        }
        .width('100%')
        .margin({ top: CommonStyles.SM })
      }
      .width('100%')
      .padding(CommonStyles.MD)
    }
    .width('100%')
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(ComponentStyles.CARD_INTERACTIVE.shadow)
    .border({
      width: 1,
      color: CommonStyles.BORDER_SUBTLE,
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_XL
    })
    .margin({ bottom: CommonStyles.MD })
    .onClick(() => {
      this.onDetailClick?.();
    })
  }

  @Builder
  createHealthTag(text: string, color: string) {
    Text(text)
      .fontSize(CommonStyles.FONT_SIZE_OVERLINE)
      .fontColor(CommonStyles.WHITE)
      .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
      .padding({
        left: CommonStyles.SM,
        right: CommonStyles.SM,
        top: 3,
        bottom: 3
      })
      .borderRadius(CommonStyles.RADIUS_FULL)
      .backgroundColor(color)
  }

  @Builder
  createActionButton(icon: string, count: string, color: string, onClick?: () => void) {
    Row({ space: 4 }) {
      Text(icon)
        .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
        .fontColor(color)
      Text(count)
        .fontSize(CommonStyles.FONT_SIZE_CAPTION)
        .fontColor(color)
    }
    .onClick(() => {
      onClick?.();
    })
  }

  private hasHealthTags(): boolean {
    return (this.pet?.vaccines && this.pet.vaccines.length > 0) ||
           this.pet?.isSterilized ||
           this.pet?.health === '健康';
  }

  private getStatusText(status: 'available' | 'pending' | 'adopted' | undefined): string {
    switch (status) {
      case 'available': return '可领养';
      case 'pending': return '审核中';
      case 'adopted': return '已领养';
      default: return '未知';
    }
  }

  private getStatusColor(): string {
    const status = this.pet?.adoptionStatus;
    switch (status) {
      case 'available': return CommonStyles.SUCCESS;
      case 'pending': return CommonStyles.WARNING;
      case 'adopted': return CommonStyles.GRAY_500;
      default: return CommonStyles.GRAY_400;
    }
  }

  private getTypeLabel(): string {
    const typeMap: Record<string, string> = {
      'cat': '猫咪',
      'dog': '狗狗',
      'other': '其他'
    };
    return typeMap[this.pet?.type || ''] || '其他';
  }

  private getTypeColor(): string {
    const colorMap: Record<string, string> = {
      'cat': '#FF6B9D',
      'dog': '#4A90E2',
      'other': '#50C878'
    };
    return colorMap[this.pet?.type || ''] || CommonStyles.GRAY_400;
  }

  private getMoodEmoji(): string {
    const moodEmojis: Record<string, string> = {
      '开心': '😊',
      '活泼': '🐾',
      '平静': '😌',
      '普通': '😐',
      '委屈': '😔',
      '胆小': '😨',
      '警惕': '👀',
      '友好': '🤝'
    };
    return moodEmojis[this.pet?.mood || ''] || '❓';
  }

  private getMoodColor(): string {
    const moodColors: Record<string, string> = {
      'happy': '#FFD93D',
      'calm': '#6BCB77',
      'playful': '#FF6B9D',
      'sleepy': '#A0C4FF',
      'hungry': '#FFA07A'
    };
    return moodColors[this.pet?.mood || ''] || CommonStyles.GRAY_400;
  }
}
