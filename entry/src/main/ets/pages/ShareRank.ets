// 分享排行页面
import { RouterHelper } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { promptAction } from '@kit.ArkUI';
import { AppStore } from '../store/AppStore';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

// 分享排行数据接口
interface ShareRankItem {
  id: number;
  rank: number;
  name: string;
  avatar: string;
  likes: number;
  shares: number;
  posts: number;
  isFollowing: boolean;
}

@Entry
@Component
struct ShareRank {
  @State private rankList: ShareRankItem[] = [];
  @State private selectedTab: 'daily' | 'weekly' | 'monthly' = 'daily';
  @State private isLoading: boolean = false;
  @State private isDarkMode: boolean = false;

  // 模拟数据
  private mockRankData: ShareRankItem[] = [
    { id: 1, rank: 1, name: '宠物达人小王', avatar: '', likes: 1250, shares: 320, posts: 45, isFollowing: false },
    { id: 2, rank: 2, name: '爱宠小张', avatar: '', likes: 980, shares: 210, posts: 32, isFollowing: true },
    { id: 3, rank: 3, name: '宠物医生李医生', avatar: '', likes: 850, shares: 180, posts: 28, isFollowing: false },
    { id: 4, rank: 4, name: '萌宠摄影师', avatar: '', likes: 720, shares: 150, posts: 25, isFollowing: false },
    { id: 5, rank: 5, name: '宠物训练师', avatar: '', likes: 650, shares: 120, posts: 22, isFollowing: true },
    { id: 6, rank: 6, name: '宠物营养师', avatar: '', likes: 580, shares: 95, posts: 18, isFollowing: false },
    { id: 7, rank: 7, name: '流浪猫救助者', avatar: '', likes: 520, shares: 80, posts: 15, isFollowing: false },
    { id: 8, rank: 8, name: '宠物美容师', avatar: '', likes: 480, shares: 75, posts: 14, isFollowing: true },
    { id: 9, rank: 9, name: '宠物博主小美', avatar: '', likes: 420, shares: 65, posts: 12, isFollowing: false },
    { id: 10, rank: 10, name: '宠物用品测评师', avatar: '', likes: 380, shares: 55, posts: 10, isFollowing: false }
  ];

  aboutToAppear() {
    // 获取当前主题
    const store = AppStore.getInstance();
    const state = store.getState();
    this.isDarkMode = state.theme === 'dark';

    // 加载数据
    this.loadRankData();
  }

  // 加载排行数据
  loadRankData() {
    this.isLoading = true;

    // 模拟网络请求
    setTimeout(() => {
      this.rankList = this.mockRankData;
      this.isLoading = false;
    }, 500);
  }

  // 切换标签
  switchTab(tab: 'daily' | 'weekly' | 'monthly') {
    this.selectedTab = tab;
    this.loadRankData();
  }

  // 关注/取消关注
  toggleFollow(item: ShareRankItem) {
    const index = this.rankList.findIndex(rank => rank.id === item.id);
    if (index !== -1) {
      this.rankList[index].isFollowing = !this.rankList[index].isFollowing;
      this.rankList = [...this.rankList];

      const action = this.rankList[index].isFollowing ? '关注' : '取消关注';
      this.showToast(`${action} ${item.name} 成功`);
    }
  }

  // 查看用户详情
  viewUserDetail(item: ShareRankItem) {
    this.showToast(`查看 ${item.name} 的详情`);
    // 实际应用中这里应该跳转到用户详情页
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
      // 导航栏
      Row({ space: CommonStyles.SPACE_MD }) {
        BackButton()

        Text('分享排行')
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
      })
      .backgroundColor(CommonStyles.WHITE)
      .shadow(CommonStyles.SHADOW_SM)

      Scroll() {
        Column({ space: CommonStyles.SPACE_XL }) {
          // 标签切换
          Row({ space: CommonStyles.SPACE_MD }) {
            // 日榜
            Button('日榜', { type: ButtonType.Normal })
              .layoutWeight(1)
              .height(40)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(this.selectedTab === 'daily' ? CommonStyles.WHITE : CommonStyles.TEXT_PRIMARY)
              .backgroundColor(this.selectedTab === 'daily' ? CommonStyles.PRIMARY_COLOR :
                (this.isDarkMode ? CommonStyles.GRAY_700 : CommonStyles.GRAY_100))
              .borderRadius(CommonStyles.RADIUS_MD)
              .onClick(() => {
                this.switchTab('daily');
              })

            // 周榜
            Button('周榜', { type: ButtonType.Normal })
              .layoutWeight(1)
              .height(40)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(this.selectedTab === 'weekly' ? CommonStyles.WHITE : CommonStyles.TEXT_PRIMARY)
              .backgroundColor(this.selectedTab === 'weekly' ? CommonStyles.PRIMARY_COLOR :
                (this.isDarkMode ? CommonStyles.GRAY_700 : CommonStyles.GRAY_100))
              .borderRadius(CommonStyles.RADIUS_MD)
              .onClick(() => {
                this.switchTab('weekly');
              })

            // 月榜
            Button('月榜', { type: ButtonType.Normal })
              .layoutWeight(1)
              .height(40)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(this.selectedTab === 'monthly' ? CommonStyles.WHITE : CommonStyles.TEXT_PRIMARY)
              .backgroundColor(this.selectedTab === 'monthly' ? CommonStyles.PRIMARY_COLOR :
                (this.isDarkMode ? CommonStyles.GRAY_700 : CommonStyles.GRAY_100))
              .borderRadius(CommonStyles.RADIUS_MD)
              .onClick(() => {
                this.switchTab('monthly');
              })
          }
          .width('100%')
          .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG })

          // 排行榜说明
          Row({ space: CommonStyles.SM }) {
            Circle()
              .width(20)
              .height(20)
              .fill(CommonStyles.INFO + '20')

            Text('根据用户分享的帖子获得的点赞、分享和发布数量综合计算')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(this.isDarkMode ? CommonStyles.TEXT_TERTIARY : CommonStyles.TEXT_SECONDARY)
              .layoutWeight(1)
          }
          .width('100%')
          .padding({
            left: CommonStyles.SPACE_LG,
            right: CommonStyles.SPACE_LG,
            top: CommonStyles.SPACE_SM
          })

          // 加载中
          if (this.isLoading) {
            Column() {
              LoadingProgress()
                .color(CommonStyles.PRIMARY_COLOR)
                .width(50)
                .height(50)

              Text('加载中...')
                .fontSize(CommonStyles.FONT_SIZE_MD)
                .fontColor(this.isDarkMode ? CommonStyles.TEXT_LIGHT : CommonStyles.TEXT_PRIMARY)
                .margin({ top: CommonStyles.SPACE_MD })
            }
            .width('100%')
            .height(200)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
          } else {
            // 排行榜列表
            Column({ space: CommonStyles.SPACE_MD }) {
              ForEach(this.rankList, (item: ShareRankItem) => {
                // 排名卡片
                Row({ space: CommonStyles.SPACE_MD }) {
                  // 排名
                  Column() {
                    if (item.rank <= 3) {
                      // 前三名特殊样式
                      Text(item.rank.toString())
                        .fontSize(CommonStyles.FONT_SIZE_XL)
                        .fontColor(CommonStyles.WHITE)
                        .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
                    } else {
                      Text(item.rank.toString())
                        .fontSize(CommonStyles.FONT_SIZE_LG)
                        .fontColor(this.isDarkMode ? CommonStyles.TEXT_LIGHT : CommonStyles.TEXT_PRIMARY)
                        .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
                    }
                  }
                  .width(40)
                  .height(40)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundColor(item.rank <= 3 ? CommonStyles.PRIMARY_COLOR :
                    (this.isDarkMode ? CommonStyles.GRAY_700 : CommonStyles.GRAY_100))
                  .borderRadius(CommonStyles.RADIUS_MD)

                  // 用户信息
                  Column({ space: CommonStyles.SPACE_XS }) {
                    Row({ space: CommonStyles.SPACE_SM }) {
                      // 头像
                      Image($r('app.media.foreground'))
                        .width(40)
                        .height(40)
                        .borderRadius(20)
                        .objectFit(ImageFit.Contain)

                      // 用户名和关注状态
                      Column({ space: CommonStyles.SPACE_XS }) {
                        Text(item.name)
                          .fontSize(CommonStyles.FONT_SIZE_MD)
                          .fontColor(this.isDarkMode ? CommonStyles.TEXT_LIGHT : CommonStyles.TEXT_PRIMARY)
                          .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)

                        Row({ space: CommonStyles.SPACE_SM }) {
                          Text(`👍 ${item.likes}`)
                            .fontSize(CommonStyles.FONT_SIZE_SM)
                            .fontColor(this.isDarkMode ? CommonStyles.TEXT_TERTIARY : CommonStyles.TEXT_SECONDARY)

                          Text(`↻ ${item.shares}`)
                            .fontSize(CommonStyles.FONT_SIZE_SM)
                            .fontColor(this.isDarkMode ? CommonStyles.TEXT_TERTIARY : CommonStyles.TEXT_SECONDARY)

                          Text(`📝 ${item.posts}`)
                            .fontSize(CommonStyles.FONT_SIZE_SM)
                            .fontColor(this.isDarkMode ? CommonStyles.TEXT_TERTIARY : CommonStyles.TEXT_SECONDARY)
                        }
                      }
                      .layoutWeight(1)
                    }

                    // 数据条
                    Row({ space: CommonStyles.SPACE_XS }) {
                      // 点赞条
                      Column()
                        .width(`${(item.likes / 1500) * 100}%`)
                        .height(4)
                        .backgroundColor(CommonStyles.SUCCESS_COLOR)
                        .borderRadius(CommonStyles.RADIUS_SM)

                      // 分享条
                      Column()
                        .width(`${(item.shares / 400) * 100}%`)
                        .height(4)
                        .backgroundColor(CommonStyles.INFO_COLOR)
                        .borderRadius(CommonStyles.RADIUS_SM)

                      // 帖子条
                      Column()
                        .width(`${(item.posts / 50) * 100}%`)
                        .height(4)
                        .backgroundColor(CommonStyles.WARNING_COLOR)
                        .borderRadius(CommonStyles.RADIUS_SM)
                    }
                    .width('100%')
                    .height(4)
                    .backgroundColor(this.isDarkMode ? CommonStyles.GRAY_600 : CommonStyles.GRAY_200)
                    .borderRadius(CommonStyles.RADIUS_SM)
                  }
                  .layoutWeight(1)

                  // 关注按钮
                  Button(item.isFollowing ? '已关注' : '+关注',
                    { type: ButtonType.Normal })
                    .width(80)
                    .height(32)
                    .fontSize(CommonStyles.FONT_SIZE_SM)
                    .fontColor(item.isFollowing ? CommonStyles.TEXT_SECONDARY : CommonStyles.WHITE)
                    .backgroundColor(item.isFollowing ?
                      (this.isDarkMode ? CommonStyles.GRAY_600 : CommonStyles.GRAY_200) :
                      CommonStyles.PRIMARY_COLOR)
                    .borderRadius(CommonStyles.RADIUS_MD)
                    .onClick(() => {
                      this.toggleFollow(item);
                    })
                }
                .width('100%')
                .padding(CommonStyles.SPACE_MD)
                .backgroundColor(this.isDarkMode ? CommonStyles.GRAY_800 : CommonStyles.WHITE)
                .borderRadius(CommonStyles.RADIUS_LG)
                .shadow(this.isDarkMode ? CommonStyles.SHADOW_SM : CommonStyles.SHADOW_MD)
                .onClick(() => {
                  this.viewUserDetail(item);
                })
              })
            }
            .width('100%')
            .padding({
              left: CommonStyles.SPACE_LG,
              right: CommonStyles.SPACE_LG,
              top: CommonStyles.SPACE_MD
            })
          }

          // 底部说明
          Column({ space: CommonStyles.SPACE_XS }) {
            Text('排行榜说明：')
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontColor(this.isDarkMode ? CommonStyles.TEXT_LIGHT : CommonStyles.TEXT_PRIMARY)
              .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
              .width('100%')
              .textAlign(TextAlign.Start)

            Text('• 排行榜根据用户分享内容的质量和互动数据综合计算')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(this.isDarkMode ? CommonStyles.TEXT_TERTIARY : CommonStyles.TEXT_SECONDARY)
              .width('100%')
              .textAlign(TextAlign.Start)

            Text('• 数据每日更新，鼓励优质内容分享')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(this.isDarkMode ? CommonStyles.TEXT_TERTIARY : CommonStyles.TEXT_SECONDARY)
              .width('100%')
              .textAlign(TextAlign.Start)

            Text('• 关注你喜欢的分享者，获取更多优质内容')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(this.isDarkMode ? CommonStyles.TEXT_TERTIARY : CommonStyles.TEXT_SECONDARY)
              .width('100%')
              .textAlign(TextAlign.Start)
          }
          .width('100%')
          .padding({
            left: CommonStyles.SPACE_LG,
            right: CommonStyles.SPACE_LG,
            top: CommonStyles.SPACE_XL,
            bottom: CommonStyles.SPACE_XL
          })
        }
        .width('100%')
        .padding({ top: CommonStyles.SPACE_LG })
      }
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .padding({ top: '45mm' })
    .backgroundColor(CommonStyles.BG_LIGHT)
  }
}