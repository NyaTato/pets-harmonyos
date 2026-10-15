﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿import { CommonStyles } from '../common/css/CommonStyles';
import { AppStore } from '../store/AppStore';
// import { getUserComments, Comment } from '../mock/InteractionData';
import { promptAction } from '@kit.ArkUI';
import { RouterHelper, RouteParams } from '../router/RouterHelper';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';


// TextOverflow选项接口
interface TextOverflowOptions {
  overflow: TextOverflow;
}

// Toast选项接口
interface ToastOptions {
  message: string;
  duration?: number;
}



// Padding选项接口
interface PaddingOptions {
  top?: number;
  right?: number;
  bottom?: number;
  left?: number;
}

interface MarginOptions {
  top?: number;
  right?: number;
  bottom?: number;
  left?: number;
}

// 临时Comment接口定义
interface Comment {
  id: number;
  userId: number;
  petId: number;
  content: string;
  createTime: string;
  rating?: number;
  replyToUserId?: number;
  username?: string;
  postTitle?: string;
  postId?: number;
}

// BorderOptions接口
interface BorderOptions {
  width: number;
  color: string;
  radius: number;
  style: number;
}

// CommentItem组件的props接口
interface CommentItemProps {
  comment: Comment;
}

// 临时获取用户评论函数
function getUserComments(userId: number): Comment[] {
  return [];
}

@Entry
@Component
struct MyComments {
  @State private comments: Comment[] = [];
  @State private isLoading: boolean = true;
  @State private commentCount: number = 0;
  @State private selectedType: string = '全部';
  @State private typeOptions: string[] = ['全部', '我的评论', '回复我的'];

  aboutToAppear() {
    this.loadComments();
  }

  loadComments() {
    this.isLoading = true;

    // 从AppStore获取用户信息
    const store = AppStore.getInstance();
    const state = store.getState();
    const currentUser = state.currentUser;

    if (!currentUser) {
      RouterHelper.replaceUrl("pages/Login");
      return;
    }

    // 模拟加载延迟
    setTimeout(() => {
      this.comments = getUserComments(currentUser.id);
      this.isLoading = false;
    }, 500);
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top']
      }) {
      // 顶部导航
      Row({ space: CommonStyles.SPACE_MD }) {
        // 返回按钮
        BackButton()

        // 标题
        Text('我的评论')
          .fontSize(CommonStyles.FONT_SIZE_XL)
          .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .layoutWeight(1)
      }
      .width('100%')
      .padding({
        left: CommonStyles.SPACE_LG,
        right: CommonStyles.SPACE_LG,
        top: CommonStyles.SPACE_XL,
        bottom: CommonStyles.SPACE_LG
      } as PaddingOptions)
      .backgroundColor(CommonStyles.WHITE)
      .shadow(CommonStyles.SHADOW_SM)

      // 类型筛选
      Scroll() {
        Row({ space: CommonStyles.SPACE_SM }) {
          ForEach(this.typeOptions, (type: string) => {
            Button(type, { type: ButtonType.Capsule })
              .padding({
                left: CommonStyles.SPACE_LG,
                right: CommonStyles.SPACE_LG,
                top: CommonStyles.SPACE_SM,
                bottom: CommonStyles.SPACE_SM
              } as PaddingOptions)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(this.selectedType === type ? CommonStyles.WHITE : CommonStyles.TEXT_PRIMARY)
              .backgroundColor(this.selectedType === type ? CommonStyles.PRIMARY_COLOR : CommonStyles.GRAY_100)
              .onClick(() => {
                this.selectedType = type;
                this.filterComments();
              })
          })
        }
        .padding({
          left: CommonStyles.SPACE_LG,
          right: CommonStyles.SPACE_LG
        } as PaddingOptions)
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(0)
      .width('100%')
      .margin({ top: CommonStyles.SPACE_MD })

      // 评论列表
      Scroll() {
        Column({ space: CommonStyles.SPACE_MD }) {
          if (this.isLoading) {
            // 加载中
            Column() {
              LoadingProgress()
                .color($r('app.color.primary'))
                .width(50)
                .height(50)
                .margin({ top: CommonStyles.SPACE_4XL })

              Text('加载中...')
                .fontSize(CommonStyles.FONT_SIZE_MD)
                .fontColor(CommonStyles.TEXT_SECONDARY)
                .margin({ top: CommonStyles.SPACE_LG })
            }
            .width('100%')
            .height(300)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
          } else if (this.comments.length === 0) {
            // 无数据
            Column() {
              Text('💬')
                .fontSize(40)
                .fontColor(CommonStyles.TEXT_TERTIARY)

              Text('暂无评论')
                .fontSize(CommonStyles.FONT_SIZE_LG)
                .fontColor(CommonStyles.TEXT_SECONDARY)
                .margin({ bottom: CommonStyles.SPACE_SM })

              Text('快去发表你的评论吧')
                .fontSize(CommonStyles.FONT_SIZE_MD)
                .fontColor(CommonStyles.TEXT_TERTIARY)

              Button({ type: ButtonType.Capsule }) {
                Text('去评论')
              }
              .width(120)
              .height(40)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(CommonStyles.WHITE)
              .backgroundColor(CommonStyles.PRIMARY_COLOR)
              .margin({ top: CommonStyles.SPACE_LG })
              .onClick(() => {
                RouterHelper.pushUrl("pages/PostList");
              })
            }
            .width('100%')
            .height(400)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
          } else {
            // 评论列表
            ForEach(this.comments, (comment: Comment) => {
              this.CommentItem({ comment: comment })
            })
          }
        }
        .width('100%')
        .padding({
          left: CommonStyles.SPACE_LG,
          right: CommonStyles.SPACE_LG,
          top: CommonStyles.SPACE_MD,
          bottom: CommonStyles.SPACE_2XL
        } as PaddingOptions)
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(0)
      .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: '45mm' })
  }

  private filterComments() {
    // 从AppStore获取用户信息
    const store = AppStore.getInstance();
    const state = store.getState();
    const currentUser = state.currentUser;

    if (!currentUser) {
      RouterHelper.replaceUrl("pages/Login");
      return;
    }

    if (this.selectedType === '全部') {
      this.loadComments();
    } else if (this.selectedType === '我的评论') {
      this.comments = getUserComments(currentUser.id).filter(
        comment => comment.userId === currentUser.id
      );
    } else if (this.selectedType === '回复我的') {
      this.comments = getUserComments(currentUser.id).filter(
        comment => comment.replyToUserId === currentUser.id
      );
    }
  }

  @Builder
  CommentItem(props: CommentItemProps) {
    Column({ space: CommonStyles.SPACE_MD }) {
      // 评论头部
      Row() {
        Column({ space: CommonStyles.SPACE_XS }) {
          Text(props.comment.username)
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
            .fontColor(CommonStyles.TEXT_PRIMARY)

          Text(props.comment.createTime)
            .fontSize(CommonStyles.FONT_SIZE_XS)
            .fontColor(CommonStyles.TEXT_TERTIARY)
        }
        .layoutWeight(1)
      }
      .width('100%')

      // 评论内容
      Text(props.comment.content)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')
        .textAlign(TextAlign.Start)
        .padding(CommonStyles.SPACE_MD)
        .backgroundColor(CommonStyles.GRAY_100)
        .borderRadius(CommonStyles.RADIUS_MD)

      // 帖子信息
      if (props.comment.postTitle) {
        Row({ space: CommonStyles.SPACE_SM }) {
          Text('帖子：')
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.TEXT_SECONDARY)

          Text(props.comment.postTitle)
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.PRIMARY_COLOR)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis } as TextOverflowOptions)
            .layoutWeight(1)
            .onClick(() => {
              if (props.comment.postId) {
                const params: RouteParams = { postId: props.comment.postId.toString() };
                RouterHelper.pushUrl("pages/Comment", params);
              } else {
                promptAction.showToast({ message: '帖子ID不存在' } as ToastOptions);
              }
            })
        }
        .width('100%')
        .padding({ top: CommonStyles.SPACE_XS } as PaddingOptions)
      }

      // 操作按钮
      Row({ space: CommonStyles.SPACE_MD }) {
        Button('查看帖子', { type: ButtonType.Normal })
          .width(80)
          .height(32)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.PRIMARY_COLOR)
          .backgroundColor('#00000000')
          .border({
            width: 1,
            color: CommonStyles.PRIMARY_COLOR,
            radius: CommonStyles.RADIUS_MD,
            style: 0
          } as BorderOptions)
          .onClick(() => {
            if (props.comment.postId) {
              const params: RouteParams = { postId: props.comment.postId!.toString() };
              RouterHelper.pushUrl("pages/Comment", params);
            } else {
              promptAction.showToast({ message: '帖子ID不存在' } as ToastOptions);
            }
          })

        Button('删除', { type: ButtonType.Normal })
          .width(60)
          .height(32)
          .fontSize(CommonStyles.FONT_SIZE_SM)
          .fontColor(CommonStyles.DANGER_COLOR)
          .backgroundColor('#00000000')
          .border({
            width: 1,
            color: CommonStyles.DANGER_COLOR,
            radius: CommonStyles.RADIUS_MD,
            style: 0
          } as BorderOptions)
          .onClick(() => {
            this.deleteComment(props.comment.id);
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
    }
    .padding(CommonStyles.SPACE_MD)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_MD)
    .width('100%')
    .margin({ bottom: CommonStyles.SPACE_MD } as MarginOptions)
  }

  private deleteComment(commentId: number) {
    const index = this.comments.findIndex((comment) => comment.id === commentId);
    if (index > -1) {
      this.comments.splice(index, 1);
      this.commentCount--;
      promptAction.showToast({
        message: '评论已删除',
        duration: 2000
      });
    }
  }

  private showToast(message: string) {
    promptAction.showToast({
      message: message,
      duration: 2000
    });
  }
}