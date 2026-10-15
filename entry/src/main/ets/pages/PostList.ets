import { RouterHelper, RouteParams } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { PostCard } from '../components/PostCard';
import { getPosts, getHotPosts, getLatestPosts, createPost, likePost, favoritePost, Post, CreatePostInput } from '../mock/PostData';
import { AppStore } from '../store/AppStore';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct PostList {
  @State private posts: Post[] = [];
  @State private selectedTab: 'latest' | 'hot' = 'latest';
  @State private isLoading: boolean = true;
  @State private searchKeyword: string = '';
  @State private showCreateDialog: boolean = false;
  @State private newPostTitle: string = '';
  @State private newPostContent: string = '';
  private loadTimer: number | null = null;

  aboutToAppear() {
    this.loadPosts();
  }

  aboutToDisappear() {
    if (this.loadTimer !== null) {
      clearTimeout(this.loadTimer);
      this.loadTimer = null;
    }
  }

  loadPosts() {
    this.isLoading = true;

    if (this.loadTimer !== null) {
      clearTimeout(this.loadTimer);
    }

    this.loadTimer = setTimeout(() => {
      try {
        if (this.selectedTab === 'latest') {
          this.posts = getLatestPosts(10);
        } else {
          this.posts = getHotPosts(10);
        }
      } catch (error) {
        console.error('Error loading posts:', error);
        this.posts = [];
      } finally {
        this.isLoading = false;
        this.loadTimer = null;
      }
    }, 500);
  }

  build() {
    Column() {
      Column() {
        this.NavigationBar()
        this.SearchBar()
        this.TabSwitcher()

        Scroll() {
          Column({ space: CommonStyles.SPACE_LG }) {
            if (this.isLoading) {
              this.LoadingContent()
            } else if (this.posts.length === 0) {
              this.EmptyContent()
            } else {
              this.PostListContent()
            }
          }
          .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG, bottom: CommonStyles.SPACE_3XL })
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(CommonStyles.COLOR_BG)

      if (this.showCreateDialog) {
        this.CreatePostOverlay()
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder NavigationBar() {
    Row() {
      Text('📝')
        .fontSize(CommonStyles.FONT_SIZE_XL)

      Text('经验分享')
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .layoutWeight(1)
        .margin({ left: CommonStyles.SM })

      Row() {
        Text('✏️')
          .fontSize(CommonStyles.FONT_SIZE_LG)
      }
      .width(CommonStyles.ICON_SIZE_TOUCH)
      .height(CommonStyles.ICON_SIZE_TOUCH)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(CommonStyles.PRIMARY)
      .borderRadius(CommonStyles.RADIUS_FULL)
      .shadow(CommonStyles.SHADOW_BRAND_TEAL)
      .onClick(() => {
        this.createPost();
      })
    }
    .width('100%')
    .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG, top: CommonStyles.SM, bottom: CommonStyles.SM })
  }

  @Builder SearchBar() {
    Row({
      space: CommonStyles.SM
    }) {
      Row({
        space: CommonStyles.SM
      }) {
        Text('🔍')
          .fontSize(CommonStyles.FONT_SIZE_MD)

        TextInput({
          placeholder: '搜索养宠经验...',
          text: this.searchKeyword
        })
          .layoutWeight(1)
          .height(CommonStyles.INPUT_HEIGHT)
          .fontSize(CommonStyles.FONT_SIZE_MD)
          .placeholderColor(CommonStyles.GRAY_400)
          .placeholderFont({ size: CommonStyles.FONT_SIZE_MD })
          .backgroundColor(CommonStyles.GRAY_50)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .padding({ left: CommonStyles.SM, right: CommonStyles.SM })
          .onChange((value: string) => {
            this.searchKeyword = value;
          })
          .onSubmit(() => {
            this.searchPosts();
          })
      }
      .layoutWeight(1)

      Row() {
        Text('🔎')
          .fontSize(CommonStyles.FONT_SIZE_MD)
      }
      .width(CommonStyles.ICON_SIZE_TOUCH)
      .height(CommonStyles.INPUT_HEIGHT)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(CommonStyles.PRIMARY)
      .borderRadius(CommonStyles.RADIUS_FULL)
      .onClick(() => {
        this.searchPosts();
      })
    }
    .width('100%')
    .padding({ left: CommonStyles.LG, right: CommonStyles.LG, top: CommonStyles.SM, bottom: CommonStyles.SM })
  }

  @Builder TabSwitcher() {
    Row({ space: CommonStyles.SM }) {
      this.TabItemBuilder('最新', this.selectedTab === 'latest', () => {
        this.selectedTab = 'latest';
        this.loadPosts();
      })

      this.TabItemBuilder('🔥 热门', this.selectedTab === 'hot', () => {
        this.selectedTab = 'hot';
        this.loadPosts();
      })
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .padding({ left: CommonStyles.LG, right: CommonStyles.LG, top: CommonStyles.SM, bottom: CommonStyles.SM })
  }

  @Builder TabItemBuilder(label: string, isActive: boolean, onTap: () => void) {
    Text(label)
      .fontSize(CommonStyles.FONT_SIZE_MD)
      .fontWeight(isActive ? FontWeight.Medium : FontWeight.Normal)
      .fontColor(isActive ? CommonStyles.WHITE : CommonStyles.TEXT_SECONDARY)
      .padding({ left: CommonStyles.XL, right: CommonStyles.XL, top: CommonStyles.SM, bottom: CommonStyles.SM })
      .backgroundColor(isActive ? CommonStyles.PRIMARY : CommonStyles.GRAY_100)
      .borderRadius(CommonStyles.RADIUS_FULL)
      .onClick(onTap)
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
    .height(350)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .visibility(this.isLoading ? Visibility.Visible : Visibility.None)
  }

  @Builder EmptyContent() {
    Column() {
      Text('📭')
        .fontSize(64)

      Text('暂无帖子')
        .fontSize(CommonStyles.FONT_SIZE_LG)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .margin({ top: CommonStyles.LG })

      Text('快来分享你的养宠经验吧 🐾')
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .margin({ top: CommonStyles.XS })

      Button('发布帖子 ✏️', { type: ButtonType.Capsule })
        .width('80%')
        .height(CommonStyles.BUTTON_HEIGHT_LG)
        .fontSize(CommonStyles.FONT_SIZE_MD)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.WHITE)
        .backgroundColor(CommonStyles.PRIMARY)
        .borderRadius(CommonStyles.RADIUS_FULL)
        .shadow(CommonStyles.SHADOW_BRAND_TEAL)
        .margin({ top: CommonStyles.XL })
        .onClick(() => {
          this.createPost();
        })
    }
    .width('100%')
    .height(350)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .visibility((!this.isLoading && this.posts.length === 0) ? Visibility.Visible : Visibility.None)
  }

  @Builder PostListContent() {
    Column({ space: CommonStyles.LG }) {
      ForEach(this.posts, (post: Post) => {
        PostCard({
          post: post,
          onCardClick: () => {
            this.viewPostDetail(post.id);
          },
          onLikeClick: () => {
            this.handleLike(post.id);
          },
          onFavoriteClick: () => {
            this.handleFavorite(post.id);
          },
          onCommentClick: () => {
            this.viewPostDetail(post.id);
          }
        })
      })
    }
    .width('100%')
    .visibility((!this.isLoading && this.posts.length > 0) ? Visibility.Visible : Visibility.None)
  }

  @Builder CreatePostOverlay() {
    Stack({ alignContent: Alignment.Center }) {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#00000080')
        .onClick(() => {
          this.showCreateDialog = false;
        })

      Column({ space: CommonStyles.LG }) {
        Row() {
          Text('✏️ 发布帖子')
            .fontSize(CommonStyles.FONT_SIZE_LG)
            .fontWeight(FontWeight.Medium)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .layoutWeight(1)

          Row() {
            Text('✕')
              .fontSize(CommonStyles.FONT_SIZE_LG)
              .fontColor(CommonStyles.TEXT_TERTIARY)
          }
          .width(CommonStyles.ICON_SIZE_TOUCH)
          .height(CommonStyles.ICON_SIZE_TOUCH)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.showCreateDialog = false;
          })
        }
        .width('100%')

        Column({ space: CommonStyles.MD }) {
          Column({ space: CommonStyles.SM }) {
            Text('标题 *')
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontWeight(FontWeight.Medium)
              .fontColor(CommonStyles.TEXT_PRIMARY)
              .width('100%')

            TextInput({ placeholder: '请输入帖子标题', text: this.newPostTitle })
              .width('100%')
              .height(CommonStyles.INPUT_HEIGHT)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .placeholderColor(CommonStyles.GRAY_400)
              .backgroundColor(CommonStyles.GRAY_50)
              .borderRadius(CommonStyles.RADIUS_MD)
              .padding({ left: CommonStyles.SM, right: CommonStyles.SM })
              .onChange((value: string) => {
                this.newPostTitle = value;
              })
          }
          .width('100%')

          Column({ space: CommonStyles.SM }) {
            Text('内容 *')
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontWeight(FontWeight.Medium)
              .fontColor(CommonStyles.TEXT_PRIMARY)
              .width('100%')

            TextArea({ placeholder: '分享你的养宠经验...', text: this.newPostContent })
              .width('100%')
              .height(200)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .placeholderColor(CommonStyles.GRAY_400)
              .backgroundColor(CommonStyles.GRAY_50)
              .borderRadius(CommonStyles.RADIUS_MD)
              .padding({ left: CommonStyles.SM, right: CommonStyles.SM, top: CommonStyles.SM, bottom: CommonStyles.SM })
              .onChange((value: string) => {
                this.newPostContent = value;
              })
          }
          .width('100%')
        }
        .width('100%')

        Row({ space: CommonStyles.MD }) {
          Button('取消', { type: ButtonType.Normal })
            .layoutWeight(1)
            .height(CommonStyles.BUTTON_HEIGHT_LG)
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(CommonStyles.TEXT_SECONDARY)
            .backgroundColor(CommonStyles.GRAY_100)
            .borderRadius(CommonStyles.RADIUS_FULL)
            .onClick(() => {
              this.showCreateDialog = false;
            })

          Button('发布', { type: ButtonType.Capsule })
            .layoutWeight(1)
            .height(CommonStyles.BUTTON_HEIGHT_LG)
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontWeight(FontWeight.Medium)
            .fontColor(CommonStyles.WHITE)
            .backgroundColor(CommonStyles.PRIMARY)
            .borderRadius(CommonStyles.RADIUS_FULL)
            .shadow(CommonStyles.SHADOW_BRAND_TEAL)
            .onClick(() => {
              this.handleCreatePost();
            })
        }
        .width('100%')
      }
      .width('90%')
      .height('80%')
      .backgroundColor(CommonStyles.WHITE)
      .borderRadius(CommonStyles.RADIUS_XL)
      .shadow(CommonStyles.SHADOW_XL)
      .padding(CommonStyles.XL)
    }
    .width('100%')
    .height('100%')
    .position({ x: 0, y: 0 })
  }

  searchPosts(): void {
    if (!this.searchKeyword.trim()) {
      this.showToast('请输入搜索关键词');
      return;
    }

    this.isLoading = true;

    setTimeout(() => {
      const allPosts = getPosts();
      const keyword = this.searchKeyword;
      this.posts = allPosts.filter(post =>
        post.title.includes(keyword) ||
        post.content.includes(keyword) ||
        post.tags.some(tag => tag.includes(keyword))
      );
      this.isLoading = false;

      if (this.posts.length === 0) {
        this.showToast('未找到相关帖子');
      }
    }, 500);
  }

  createPost(): void {
    const store = AppStore.getInstance();
    const state = store.getState();
    const currentUser = state.currentUser;

    if (!currentUser) {
      promptAction.showToast({
        message: '请先登录',
        duration: 2000
      });
      return;
    }

    this.showCreateDialog = true;
    this.newPostTitle = '';
    this.newPostContent = '';
  }

  handleCreatePost(): void {
    if (!this.newPostTitle.trim()) {
      this.showToast('请输入帖子标题');
      return;
    }

    if (!this.newPostContent.trim()) {
      this.showToast('请输入帖子内容');
      return;
    }

    const store = AppStore.getInstance();
    const state = store.getState();
    const currentUser = state.currentUser;

    if (!currentUser) {
      this.showToast('请先登录');
      return;
    }

    const postInput: CreatePostInput = {
      title: this.newPostTitle,
      content: this.newPostContent,
      author: currentUser?.nickname || currentUser?.username || '用户',
      authorAvatar: currentUser?.avatar || '',
      category: 'general',
      tags: []
    };

    const newPost = createPost(postInput);
    if (newPost) {
      this.showToast('✅ 帖子发布成功');
      this.showCreateDialog = false;
      this.loadPosts();
    } else {
      this.showToast('❌ 帖子发布失败');
    }
  }

  viewPostDetail(postId: number): void {
    const params: RouteParams = { postId: postId.toString() };
    RouterHelper.pushUrl("pages/Comment", params);
  }

  handleLike(postId: number): void {
    const store = AppStore.getInstance();
    const state = store.getState();
    const currentUser = state.currentUser;

    if (!currentUser) {
      this.showToast('请先登录');
      return;
    }

    const success = likePost(postId);
    if (success) {
      this.loadPosts();
      this.showToast('❤️ 点赞成功');
    } else {
      this.showToast('点赞失败');
    }
  }

  handleFavorite(postId: number): void {
    const store = AppStore.getInstance();
    const state = store.getState();
    const currentUser = state.currentUser;

    if (!currentUser) {
      this.showToast('请先登录');
      return;
    }

    const success = favoritePost(postId);
    if (success) {
      this.loadPosts();
      this.showToast('⭐ 收藏成功');
    } else {
      this.showToast('收藏失败');
    }
  }

  showToast(message: string): void {
    promptAction.showToast({
      message: message,
      duration: 2000
    });
  }
}
