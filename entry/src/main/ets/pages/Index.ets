import { CommonStyles } from '../common/css/CommonStyles';
import { ComponentStyles } from '../common/css/ComponentStyles';
import { RouterHelper } from '../router/RouterHelper';
import { Pet, petList } from '../mock/PetData';
import { Notice, noticeList } from '../mock/NoticeData';
import { AppStore } from '../store/AppStore';

interface DemoFeature {
  id: string;
  icon: string;
  title: string;
  subtitle: string;
  description: string;
  themeColor: string;
  bgColor: string;
  route: string;
  badge?: string;
  order: number;
}

interface SupportFeature {
  icon: string;
  title: string;
  route: string;
  color: string;
}

@Component
export struct Index {
  @State private searchKeyword: string = '';
  @State private unreadCount: number = 0;
  @State private pets: Pet[] = [];
  @State private notices: Notice[] = [];

  private nickname: string = '爱宠人士';

  private readonly demoFeatures: DemoFeature[] = [
    {
      id: 'ar',
      icon: '🔮',
      title: '图片预览（演示）',
      subtitle: 'Image demo',
      description: '本地图片位置与大小互动',
      themeColor: CommonStyles.AR,
      bgColor: CommonStyles.AR_BG,
      route: 'pages/ARPreview',
      badge: '①',
      order: 1
    },
    {
      id: 'ai',
      icon: '🧠',
      title: '推荐匹配（演示）',
      subtitle: 'Mock recommendations',
      description: '基于示例数据的匹配展示',
      themeColor: CommonStyles.PRIMARY,
      bgColor: CommonStyles.PRIMARY_BG,
      route: 'pages/SmartRecommendation',
      badge: '②',
      order: 2
    },
    {
      id: 'iot',
      icon: '🛡️',
      title: '走失预警（模拟）',
      subtitle: 'Local alert demo',
      description: '本地模拟位置与告警',
      themeColor: CommonStyles.IOT,
      bgColor: CommonStyles.IOT_BG,
      route: 'pages/PetLostWarning',
      badge: '③',
      order: 3
    }
  ];

  // ===== 支持功能（产品完整性） =====
  private readonly supportFeatures: SupportFeature[] = [
    { icon: '📋', title: '成长档案', route: 'pages/PetGrowthProfile', color: CommonStyles.INFO },
    { icon: '🔔', title: '智能提醒', route: 'pages/SmartReminder', color: CommonStyles.SUCCESS },
    { icon: '📅', title: '日历', route: 'pages/Calendar', color: CommonStyles.WARNING },
    { icon: '⭐', title: '等级系统', route: 'pages/PetLevelSystem', color: CommonStyles.SECONDARY }
  ];

  aboutToAppear(): void {
    this.initData();
  }

  private initData(): void {
    const store = AppStore.getInstance();
    const state = store.getState();
    this.nickname = state.currentUser?.nickname || '爱宠人士';
    this.unreadCount = state.notices.filter((n: Notice) => !n.isRead).length;

    setTimeout(() => {
      this.pets = petList.slice(0, 4);
      this.notices = noticeList.slice(0, 3);
    }, 200);
  }

  build() {
    Column() {
      // ===== 1. 顶部问候栏（固定顶部） =====
      this.TopBar()

      // ===== 2. 可滚动内容区（包含Banner + 其他内容） =====
      Scroll() {
        Column({ space: CommonStyles.SECTION_GAP }) {

          this.DemoHeroSection()

          // 支持功能快速入口
          this.SupportFeaturesGrid()

          // 推荐宠物
          this.PetPreviewSection()

          // 最新消息（精简）
          this.MessagePreview()

        }
        .width('100%')
        .padding({ left: CommonStyles.PAGE_PADDING_H, right: CommonStyles.PAGE_PADDING_H, bottom: 32 })
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .backgroundColor(CommonStyles.BG_SURFACE)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(CommonStyles.BG_SURFACE)
  }

  // ==================== Builder: 顶部栏 ====================
  @Builder
  TopBar() {
    Column({ space: CommonStyles.MD }) {
      Row() {
        Column({ space: 4 }) {
          Text(`你好，${this.nickname}`)
            .fontSize(CommonStyles.FONT_SIZE_H2)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.TEXT_PRIMARY)

          Text('宠缘 · 让每只宠物都有家')
            .fontSize(CommonStyles.FONT_SIZE_CAPTION)
            .fontColor(CommonStyles.TEXT_TERTIARY)
        }

        Blank()

        Stack({ alignContent: Alignment.TopEnd }) {
          Text('🔔')
            .fontSize(24)

          if (this.unreadCount > 0) {
            Text(this.unreadCount.toString())
              .width(18)
              .height(18)
              .fontSize(CommonStyles.FONT_SIZE_OVERLINE)
              .fontColor(CommonStyles.WHITE)
              .backgroundColor(CommonStyles.DANGER)
              .borderRadius(9)
              .textAlign(TextAlign.Center)
              .position({ x: 14, y: -4 })
          }
        }
        .onClick(() => RouterHelper.pushUrl("pages/Messages"))
      }
      .width('100%')

      // 搜索框（简化）
      Row({ space: CommonStyles.SM }) {
        Text('🔍')
          .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
          .fontColor(CommonStyles.TEXT_TERTIARY)

        TextInput({
          placeholder: '搜索品种、年龄、地区...',
          text: this.searchKeyword
        })
          .placeholderColor(CommonStyles.TEXT_PLACEHOLDER)
          .placeholderFont({ size: CommonStyles.FONT_SIZE_BODY_SMALL })
          .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .layoutWeight(1)
          .height(40)
          .backgroundColor(CommonStyles.BG_ELEVATED)
          .borderRadius(CommonStyles.RADIUS_FULL)
          .onChange((v: string) => { this.searchKeyword = v; })
          .onSubmit(() => {
            if (this.searchKeyword.trim()) RouterHelper.navigateToPetList();
          })
      }
      .width('100%')
    }
    .width('100%')
    .padding(CommonStyles.PAGE_PADDING_H)
    .padding({ top: 16, bottom: 14 })
    .backgroundColor(CommonStyles.WHITE)
  }

  // ==================== Builder: 核心演示区 ====================
  @Builder
  DemoHeroSection() {
    Column({ space: CommonStyles.MD }) {
      // 轮播Banner（可随页面滚动）
      Swiper() {
        ForEach(this.demoFeatures, (feature: DemoFeature, index: number) => {
          this.SwiperBanner(feature, index)
        })
      }
      .width('100%')
      .height(240)
      .autoPlay(true)
      .interval(3500)
      .loop(true)
      .indicator(
        new DotIndicator()
          .itemWidth(6)
          .itemHeight(6)
          .selectedItemWidth(20)
          .selectedItemHeight(6)
          .color('#FFFFFF80')
          .selectedColor('#FFFFFF')
      )
      .borderRadius(CommonStyles.RADIUS_XL)
      .clip(true)

      // 精炼口号（抓住评委眼球）
      this.ImpactSlogan()
    }
    .width('100%')
    .padding({
      left: CommonStyles.PAGE_PADDING_H,
      right: CommonStyles.PAGE_PADDING_H,
      top: CommonStyles.LG,
      bottom: CommonStyles.LG
    })
    .backgroundColor(CommonStyles.WHITE)
    .shadow(CommonStyles.SHADOW_SM)
  }

  @Builder
  SwiperBanner(feature: DemoFeature, index: number) {
    Stack({ alignContent: Alignment.End }) {
      // 背景层：多层渐变
      Column() {
        // 主背景渐变
        Column()
          .width('100%')
          .height('100%')
          .linearGradient({
            angle: 135,
            colors: [
              [feature.themeColor + 'DD', 0],
              [feature.bgColor, 0.5],
              ['#FFFFFF', 1]
            ]
          })

        // 右上角装饰圆
        Column()
          .width(180)
          .height(180)
          .borderRadius(90)
          .backgroundColor(feature.themeColor + '15')
          .position({ x: '70%', y: '-20%' })

        // 左下角小圆
        Column()
          .width(80)
          .height(80)
          .borderRadius(40)
          .backgroundColor(feature.themeColor + '10')
          .position({ x: '-10%', y: '60%' })

        // 中间装饰环
        Column()
          .width(120)
          .height(120)
          .borderRadius(60)
          .border({ width: 2, color: feature.themeColor + '20', style: BorderStyle.Solid })
          .position({ x: '55%', y: '25%' })
      }
      .width('100%')
      .height('100%')

      // 内容层：左对齐
      Row() {
        // 左侧：文字信息区
        Column({ space: 12 }) {
          // 标签行
          Row({ space: 8 }) {
            Text(feature.icon)
              .fontSize(28)

            Text(feature.subtitle)
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .fontColor(feature.themeColor)
              .padding({ left: 10, right: 10, top: 4, bottom: 4 })
              .backgroundColor(feature.themeColor + '15')
              .borderRadius(CommonStyles.RADIUS_FULL)
          }
          .width('100%')

          // 主标题
          Text(feature.title)
            .fontSize(26)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .textAlign(TextAlign.Start)

          // 描述文字
          Text(feature.description)
            .fontSize(14)
            .fontColor(CommonStyles.TEXT_SECONDARY)
            .lineHeight(20)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Start)

          // CTA按钮组
          Row({ space: 12 }) {
            Button('立即体验', { type: ButtonType.Capsule })
              .height(38)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .backgroundColor(feature.themeColor)
              .borderRadius(19)
              .shadow({
                radius: 12,
                color: feature.themeColor + '50',
                offsetX: 0,
                offsetY: 4
              })
              .onClick(() => RouterHelper.pushUrl(feature.route))

            Text('了解更多 →')
              .fontSize(13)
              .fontColor(feature.themeColor)
              .fontWeight(FontWeight.Medium)
              .padding({ left: 8, right: 0, top: 8, bottom: 8 })
              .onClick(() => RouterHelper.pushUrl(feature.route))
          }
        }
        .width('100%')
        .padding({ left: 20, right: 10, top: 16, bottom: 16 })

        // 右侧：图标展示区（占位，让文字左对齐）
        Column()
          .width(100)
      }
      .width('100%')
      .height('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .onClick(() => RouterHelper.pushUrl(feature.route))
  }

  @Builder
  ImpactSlogan() {
    Column({ space: CommonStyles.SM }) {
      // 主标语：情感共鸣
      Text('让每只宠物找到温暖的家')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .letterSpacing(2)

      // 副标语：技术亮点
      Row({ space: CommonStyles.SM }) {
        Text('AR')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.AR)
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor('#F3E8FF')
          .borderRadius(CommonStyles.RADIUS_FULL)

        Text('·')
          .fontSize(13)
          .fontColor(CommonStyles.TEXT_TERTIARY)

        Text('AI')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.PRIMARY)
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor('#DBEAFE')
          .borderRadius(CommonStyles.RADIUS_FULL)

        Text('·')
          .fontSize(13)
          .fontColor(CommonStyles.TEXT_TERTIARY)

        Text('IoT')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.IOT)
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor('#D1FAE5')
          .borderRadius(CommonStyles.RADIUS_FULL)

        Text('三大黑科技')
          .fontSize(12)
          .fontColor(CommonStyles.TEXT_SECONDARY)
      }
    }
    .width('100%')
    .padding({ top: CommonStyles.MD, bottom: CommonStyles.SM })
    .alignItems(HorizontalAlign.Center)
  }

  // ==================== Builder: 支持功能网格 ====================
  @Builder
  SupportFeaturesGrid() {
    Column({ space: CommonStyles.MD }) {
      Row() {
        Text('更多功能')
          .fontSize(CommonStyles.FONT_SIZE_H3)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Blank()
      }
      .width('100%')

      Grid() {
        ForEach(this.supportFeatures, (feature: SupportFeature) => {
          GridItem() {
            Column({ space: CommonStyles.SM }) {
              Text(feature.icon)
                .fontSize(28)

              Text(feature.title)
                .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
                .fontWeight(FontWeight.Medium)
                .fontColor(CommonStyles.TEXT_PRIMARY)
            }
            .width('100%')
            .padding({
              top: CommonStyles.LG,
              bottom: CommonStyles.LG
            })
            .backgroundColor(CommonStyles.WHITE)
            .borderRadius(CommonStyles.RADIUS_LG)
            .shadow(CommonStyles.SHADOW_XS)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .onClick(() => RouterHelper.pushUrl(feature.route))
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsGap(CommonStyles.SM)
      .columnsGap(CommonStyles.SM)
      .width('100%')
    }
    .width('100%')
  }

  // ==================== Builder: 宠物预览（简化版） ====================
  @Builder
  PetPreviewSection() {
    Column({ space: CommonStyles.MD }) {
      Row() {
        Text('推荐宠物')
          .fontSize(CommonStyles.FONT_SIZE_H3)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Blank()
        Text('查看全部 ›')
          .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
          .fontColor(CommonStyles.PRIMARY)
          .fontWeight(FontWeight.Medium)
          .onClick(() => RouterHelper.navigateToPetList())
      }
      .width('100%')

      if (this.pets.length > 0) {
        Grid() {
          ForEach(this.pets.slice(0, 4), (pet: Pet) => {
            GridItem() {
              this.CompactPetCard(pet)
            }
          })
        }
        .columnsTemplate('1fr 1fr')
        .rowsGap(CommonStyles.MD)
        .columnsGap(CommonStyles.MD)
        .width('100%')
      } else {
        this.EmptyStatePlaceholder('🐾', '暂无推荐宠物', () => RouterHelper.navigateToPetList())
      }
    }
    .width('100%')
  }

  @Builder
  CompactPetCard(pet: Pet) {
    Column({ space: CommonStyles.XS }) {
      Stack({ alignContent: Alignment.Bottom }) {
        Image(pet.images && pet.images.length > 0 ? $rawfile(pet.images[0]) : '')
          .width('100%')
          .height(120)
          .objectFit(ImageFit.Cover)
          .borderRadius({
            topLeft: CommonStyles.RADIUS_MD,
            topRight: CommonStyles.RADIUS_MD
          })

        if (pet.adoptionStatus === 'available') {
          Text('可领养')
            .fontSize(CommonStyles.FONT_SIZE_OVERLINE)
            .fontColor(CommonStyles.WHITE)
            .fontWeight(FontWeight.Medium)
            .padding({
              left: CommonStyles.SM,
              right: CommonStyles.SM,
              top: 3,
              bottom: 3
            })
            .borderRadius(CommonStyles.RADIUS_FULL)
            .backgroundColor(CommonStyles.SUCCESS + 'DD')
            .position({ x: CommonStyles.SM, y: CommonStyles.SM })
        }
      }

      Row() {
        Text(pet.name)
          .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)

        Text(`${pet.age}岁`)
          .fontSize(CommonStyles.FONT_SIZE_OVERLINE)
          .fontColor(CommonStyles.TEXT_TERTIARY)
      }
      .width('100%')
    }
    .width('100%')
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_MD)
    .shadow(CommonStyles.SHADOW_XS)
    .onClick(() => RouterHelper.navigateToPetDetail(pet.id))
  }

  // ==================== Builder: 消息预览（精简版） ====================
  @Builder
  MessagePreview() {
    Column({ space: CommonStyles.MD }) {
      Row() {
        Row({ space: CommonStyles.XS }) {
          Text('消息中心')
            .fontSize(CommonStyles.FONT_SIZE_H3)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.TEXT_PRIMARY)

          if (this.unreadCount > 0) {
            Circle()
              .width(8)
              .height(8)
              .fill(CommonStyles.DANGER)
          }
        }

        Blank()
        Text('查看全部 ›')
          .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
          .fontColor(CommonStyles.PRIMARY)
          .fontWeight(FontWeight.Medium)
          .onClick(() => RouterHelper.pushUrl("pages/Messages"))
      }
      .width('100%')

      if (this.notices.length > 0) {
        Column({ space: CommonStyles.SM }) {
          ForEach(this.notices.slice(0, 2), (notice: Notice) => {
            this.CompactMessageItem(notice)
          })
        }
      } else {
        this.EmptyStatePlaceholder('📭', '暂无新消息', () => RouterHelper.pushUrl("pages/Messages"))
      }
    }
    .width('100%')
  }

  @Builder
  CompactMessageItem(msg: Notice) {
    Row({ space: CommonStyles.SM }) {
      Text(msg.type === '系统' ? '⚙️' : msg.type === '活动' ? '🎉' : msg.type === '重要' ? '⚠️' : '📢')
        .fontSize(18)

      Column({ space: 2 }) {
        Text(msg.title || '消息标题')
          .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(msg.content?.substring(0, 30) + '...' || '内容摘要...')
          .fontSize(CommonStyles.FONT_SIZE_OVERLINE)
          .fontColor(CommonStyles.TEXT_TERTIARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      if (!msg.isRead) {
        Circle()
          .width(6)
          .height(6)
          .fill(CommonStyles.DANGER)
      }
    }
    .width('100%')
    .padding(CommonStyles.MD)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_MD)
    .shadow(CommonStyles.SHADOW_XS)
    .onClick(() => RouterHelper.pushUrl("pages/Messages"))
  }

  // ==================== Builder: 空状态占位符 ====================
  @Builder
  EmptyStatePlaceholder(icon: string, text: string, action: () => void) {
    Column({ space: CommonStyles.SM }) {
      Text(icon)
        .fontSize(32)
        .fontColor(CommonStyles.TEXT_DISABLED)

      Text(text)
        .fontSize(CommonStyles.FONT_SIZE_BODY_SMALL)
        .fontColor(CommonStyles.TEXT_TERTIARY)

      Button('去看看', { type: ButtonType.Capsule })
        .height(32)
        .fontSize(CommonStyles.FONT_SIZE_CAPTION)
        .fontColor(CommonStyles.WHITE)
        .backgroundColor(CommonStyles.PRIMARY)
        .borderRadius(CommonStyles.RADIUS_FULL)
        .onClick(action)
    }
    .width('100%')
    .padding(CommonStyles.XL)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_MD)
    .shadow(CommonStyles.SHADOW_XS)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
