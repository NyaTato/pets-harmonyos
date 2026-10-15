import { CommonStyles } from '../common/css/CommonStyles';

import { Notice } from '../mock/NoticeData';

interface TypeConfig {
  color: string;
  text: string;
}

@Component
export struct NoticeCard {
  @Prop notice: Notice | null = null;
  // 使用普通属性而不是@Prop，因为@Prop不支持函数类型
  private onCardClick?: () => void;
  private onReadClick?: () => void;

  build() {
    Column({ space: CommonStyles.SPACE_MD }) {
      // 公告头部
      Row() {
        // 类型标签
        this.createTypeTag(this.notice?.type || '系统')

        // 时间
        Text(this.notice?.createTime || '')
          .fontSize(CommonStyles.FONT_SIZE_XS)
          .fontColor(CommonStyles.TEXT_TERTIARY)
          .margin({ left: 'auto' })
      }
      .width('100%')

      // 公告标题
      Text(this.notice?.title || '')
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      // 公告内容预览
      Text(this.notice?.content || '')
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .width('100%')
        .maxLines(3)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      // 底部操作栏
      Row() {
        // 未读标识
        if (!this.notice?.isRead) {
          Row({ space: CommonStyles.SPACE_XS }) {
            Image('common/images/unread.png')
              .width(12)
              .height(12)
            Text('未读')
              .fontSize(CommonStyles.FONT_SIZE_XS)
              .fontColor(CommonStyles.SECONDARY_COLOR)
          }
        }

        // 标记为已读按钮
        if (!this.notice?.isRead) {
          Button('标记为已读', { type: ButtonType.Normal })
            .width(100)
            .height(28)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.PRIMARY_COLOR)
            .backgroundColor('#00000000')
            .border({
              width: 1,
              color: CommonStyles.PRIMARY_COLOR,
              radius: CommonStyles.RADIUS_SM
            })
            .onClick(() => {
              this.onReadClick?.();
            })
            .margin({ left: 'auto' })
        }
      }
      .width('100%')
      .margin({ top: CommonStyles.SPACE_SM })
    }
    .padding(CommonStyles.SPACE_MD)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_MD)
    .width('100%')
    .margin({ bottom: CommonStyles.SPACE_MD })
    .onClick(() => {
      this.onCardClick?.();
    })
  }

  // 获取类型配置
  private getTypeConfig(type: string): TypeConfig {
    const typeConfigs: Record<string, TypeConfig> = {
      '系统': { color: CommonStyles.PRIMARY_COLOR, text: '系统' },
      '活动': { color: CommonStyles.SUCCESS_COLOR, text: '活动' },
      '领养': { color: CommonStyles.WARNING_COLOR, text: '领养' },
      '重要': { color: CommonStyles.DANGER_COLOR, text: '重要' }
    };
    return typeConfigs[type] || typeConfigs['系统'];
  }

  @Builder
  createTypeTag(type: string) {
    Row() {
      Text(this.getTypeConfig(type).text)
        .fontSize(CommonStyles.FONT_SIZE_XS)
        .fontColor(CommonStyles.WHITE)
        .padding({
          left: CommonStyles.SPACE_SM,
          right: CommonStyles.SPACE_SM,
          top: 4,
          bottom: 4
        })
        .backgroundColor(this.getTypeConfig(type).color)
        .borderRadius(CommonStyles.RADIUS_SM)
    }
  }
}
