import { CommonStyles } from '../common/css/CommonStyles';
import { type User, userList } from '../mock/UserData';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

interface SuggestionItem {
  icon: string;
  title: string;
  desc: string;
  points: number;
}

interface TrendItem {
  month: string;
  score: number;
}

@Entry
@Component
struct CreditScoreDisplay {
  @State private user: User | null = null;
  @State private isLoading: boolean = true;
  @State private creditScore: number = 0;
  @State private creditLevel: string = '';
  @State private levelColor: string = '';
  @State private levelDescription: string = '';

  aboutToAppear(): void {
    this.loadUserData();
  }

  private loadUserData(): void {
    this.isLoading = true;

    setTimeout(() => {
      const currentUser = userList.find((u: User) => u.id === 1);
      if (currentUser) {
        this.user = currentUser;
        this.creditScore = currentUser.creditScore || 75; // 默认75分
        this.setCreditLevel(this.creditScore);
      }
      this.isLoading = false;
    }, 300);
  }

  private setCreditLevel(score: number): void {
    if (score >= 90) {
      this.creditLevel = '卓越领养人';
      this.levelColor = '#FF6B35'; // 橙金色
      this.levelDescription = '信用极优，享受所有特权';
    } else if (score >= 80) {
      this.creditLevel = '优秀领养人';
      this.levelColor = '#34C759'; // 绿色
      this.levelDescription = '信用良好，优先审核通过';
    } else if (score >= 70) {
      this.creditLevel = '良好领养人';
      this.levelColor = '#007AFF'; // 蓝色
      this.levelDescription = '信用合格，正常流程申请';
    } else if (score >= 60) {
      this.creditLevel = '普通领养人';
      this.levelColor = '#FF9500'; // 橙色
      this.levelDescription = '信用一般，需补充材料';
    } else {
      this.creditLevel = '待提升';
      this.levelColor = '#FF3B30'; // 红色
      this.levelDescription = '信用较低，建议完善信息';
    }
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top']
      }) {
        if (this.isLoading) {
          this.LoadingState()
        } else {
          this.MainContent()
        }
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: '45mm' })
  }

  // ========== Loading State ==========
  @Builder
  LoadingState() {
    Column() {
      LoadingProgress()
        .color(CommonStyles.PRIMARY)
        .width(48)
        .height(48)
        .margin({ top: 120 })

      Text('正在加载信用数据...')
        .fontSize(15)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .margin({ top: 16 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // ========== Main Content ==========
  @Builder
  MainContent() {
    Scroll() {
      Column({ space: 24 }) {

        // ===== 1. 顶部导航栏 =====
        this.NavigationBar()

        // ===== 2. 信用分环形图（核心）=====
        this.CreditScoreCircle()

        // ===== 3. 等级说明卡片 =====
        this.LevelInfoCard()

        // ===== 4. 信用构成维度 =====
        this.ScoreDimensions()

        // ===== 5. 等级特权列表 =====
        this.LevelPrivileges()

        // ===== 6. 提升建议 =====
        this.ImprovementSuggestions()

        // ===== 7. 历史趋势（简化版）=====
        this.ScoreHistory()

      }
      .width('100%')
      .padding({ left: CommonStyles.LG, right: CommonStyles.LG, bottom: 40 })
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .layoutWeight(1)
    .backgroundColor(CommonStyles.BG_SECONDARY)
  }

  // ========== Navigation Bar ==========
  @Builder
  NavigationBar() {
    Row() {
      BackButton()

      Blank()

      Text('我的信用分')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)

      Blank()

      Text('')
        .width(24)
    }
    .width('100%')
    .padding({ left: CommonStyles.LG, right: CommonStyles.LG, top: 16, bottom: 16 })
    .backgroundColor('#FFFFFF')
  }

  // ========== Credit Score Circle ==========
  @Builder
  CreditScoreCircle() {
    Column({ space: 20 }) {
      // 分数环形图（使用Stack模拟）
      Stack({ alignContent: Alignment.Center }) {
        // 背景圆环
        Column()
          .width(200)
          .height(200)
          .borderRadius(100)
          .backgroundColor(CommonStyles.GRAY_100)

        // 进度圆环（通过角度模拟）
        Column()
          .width(200)
          .height(200)
          .borderRadius(100)
          .border({
            width: 12,
            color: this.levelColor
          })

        // 内部内容
        Column({ space: 8 }) {
          Text(`${this.creditScore}`)
            .fontSize(52)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.levelColor)

          Text('信用分数')
            .fontSize(15)
            .fontColor(CommonStyles.TEXT_SECONDARY)

          Divider().color(CommonStyles.BORDER_LIGHT).margin({ top: 8, bottom: 8 })

          Text(this.creditLevel)
            .fontSize(17)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.levelColor)
        }
      }
      .width(220)
      .height(220)

      // 等级描述
      Text(this.levelDescription)
        .fontSize(14)
        .fontColor(CommonStyles.TEXT_TERTIARY)
        .textAlign(TextAlign.Center)
        .width('90%')
    }
    .width('100%')
    .padding(32)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_LG)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // ========== Level Info Card ==========
  @Builder
  LevelInfoCard() {
    Column({ space: 16 }) {
      Text(`🏆 ${this.creditLevel} 权益说明`)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      // 当前等级优势
      Column({ space: 12 }) {
        ForEach(this.getLevelBenefits(), (benefit: string) => {
          Row({ space: 10 }) {
            Text('✓')
              .fontSize(16)
              .fontColor(this.levelColor)
              .fontWeight(FontWeight.Bold)

            Text(benefit)
              .fontSize(14)
              .fontColor(CommonStyles.TEXT_SECONDARY)
              .layoutWeight(1)
          }
          .width('100%')
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  // ========== Score Dimensions ==========
  @Builder
  ScoreDimensions() {
    Column({ space: 16 }) {
      Text('📊 信用构成维度')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      Grid() {
        this.DimensionItem('基本信息', 85, '👤')
        this.DimensionItem('认证状态', 70, '✅')
        this.DimensionItem('活跃度', 92, '🔥')
        this.DimensionItem('履约记录', 88, '📝')
        this.DimensionItem('评价反馈', 78, '⭐')
        this.DimensionItem('历史表现', 82, '📈')
      }
      .columnsTemplate('1fr 1fr')
      .rowsGap(12)
      .columnsGap(12)
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  // ========== Level Privileges ==========
  @Builder
  LevelPrivileges() {
    Column({ space: 16 }) {
      Text('🎁 等级特权对比')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      // 特权表格（简化版）
      Column({ space: 10 }) {
        this.PrivilegeRow('优先审核', '立即', '1-3天', '3-5天', '5-7天')
        this.PrivilegeRow('免押金', '✅', '部分', '-', '-')
        this.PrivilegeRow('专属客服', '24h', '工作日', '-', '-')
        this.PrivilegeRow('生日福利', '双倍积分', '正常', '-', '-')
        this.PrivilegeRow('新宠优先权', '提前3天', '提前1天', '-', '-')
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  // ========== Improvement Suggestions ==========
  @Builder
  ImprovementSuggestions() {
    Column({ space: 16 }) {
      Text('💡 提升信用分建议')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      Column({ space: 12 }) {
        ForEach(this.getSuggestions(), (suggestion: SuggestionItem) => {
          Row({ space: 12 }) {
            Text(suggestion.icon)
              .fontSize(28)

            Column({ space: 6 }) {
              Text(suggestion.title)
                .fontSize(15)
                .fontWeight(FontWeight.Medium)
                .fontColor(CommonStyles.TEXT_PRIMARY)

              Text(suggestion.desc)
                .fontSize(13)
                .fontColor(CommonStyles.TEXT_SECONDARY)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('100%')

              Row({ space: 6 }) {
                Text('+')
                  .fontSize(14)
                  .fontColor(CommonStyles.SUCCESS)
                  .fontWeight(FontWeight.Bold)

                Text(`${suggestion.points}分`)
                  .fontSize(14)
                  .fontColor(CommonStyles.SUCCESS)
                  .fontWeight(FontWeight.Bold)
              }
              .width('100%')
            }
            .layoutWeight(1)
          }
          .width('100%')
          .padding(14)
          .backgroundColor(CommonStyles.GRAY_50)
          .borderRadius(CommonStyles.RADIUS_LG)
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  // ========== Score History ==========
  @Builder
  ScoreHistory() {
    Column({ space: 16 }) {
      Text('📈 近期信用变化')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      // 简化的趋势图（用文字+进度条）
      Column({ space: 12 }) {
        ForEach([
          { month: '4月', score: this.creditScore } as TrendItem,
          { month: '3月', score: Math.max(0, this.creditScore - 5) } as TrendItem,
          { month: '2月', score: Math.max(0, this.creditScore - 8) } as TrendItem,
          { month: '1月', score: Math.max(0, this.creditScore - 12) } as TrendItem,
          { month: '12月', score: Math.max(0, this.creditScore - 15) } as TrendItem
        ], (item: TrendItem) => {
          Row({ space: 12 }) {
            Text(item.month)
              .fontSize(13)
              .fontColor(CommonStyles.TEXT_TERTIARY)
              .width(40)

            Progress({
              value: item.score,
              total: 100,
              type: ProgressType.Linear
            })
              .layoutWeight(1)
              .color(this.getScoreColor(item.score))
              .backgroundColor(CommonStyles.GRAY_200)

            Text(`${item.score}`)
              .fontSize(13)
              .fontWeight(FontWeight.Medium)
              .fontColor(CommonStyles.TEXT_PRIMARY)
              .width(36)
              .textAlign(TextAlign.End)
          }
          .width('100%')
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  // ========== Helper Methods ==========
  private getLevelBenefits(): string[] {
    const benefitsMap: Record<string, string[]> = {
      '卓越领养人': [
        '免审核直接领养',
        '优先选择心仪宠物',
        '专享折扣优惠',
        '一对一专属顾问',
        '年度免费体检',
        '社区VIP标识'
      ],
      '优秀领养人': [
        '优先审核通道',
        '更多宠物选择',
        '定期优惠券',
        '在线客服支持',
        '季度健康检查'
      ],
      '良好领养人': [
        '正常申请流程',
        '标准宠物库',
        '基础优惠券',
        '工单客服支持'
      ],
      '普通领养人': [
        '标准申请',
        '基础宠物库',
        '补充材料可能需要'
      ],
      '待提升': [
        '完善个人信息',
        '完成身份认证',
        '参与平台活动'
      ]
    };

    return benefitsMap[this.creditLevel] || benefitsMap['普通领养人'];
  }

  private getScoreColor(score: number): string {
    if (score >= 90) return '#FF6B35';
    if (score >= 80) return '#34C759';
    if (score >= 70) return '#007AFF';
    if (score >= 60) return '#FF9500';
    return '#FF3B30';
  }

  private getSuggestions(): SuggestionItem[] {
    return [
      {
        icon: '📋',
        title: '完善个人资料',
        desc: '填写真实姓名、联系方式、居住地址等信息',
        points: 5
      } as SuggestionItem,
      {
        icon: '✅',
        title: '完成身份认证',
        desc: '上传身份证件，完成实名验证',
        points: 10
      } as SuggestionItem,
      {
        icon: '🔥',
        title: '保持活跃登录',
        desc: '每周至少登录3次，浏览宠物信息',
        points: 3
      } as SuggestionItem,
      {
        icon: '⭐',
        title: '获得好评反馈',
        desc: '成功领养后获得救助机构的好评',
        points: 8
      } as SuggestionItem,
      {
        icon: '📝',
        title: '按时履约承诺',
        desc: '遵守领养协议，配合回访调查',
        points: 5
      } as SuggestionItem
    ];
  }

  @Builder
  DimensionItem(label: string, score: number, icon: string) {
    Column({ space: 8 }) {
      Row({ space: 6 }) {
        Text(icon)
          .fontSize(18)

        Text(label)
          .fontSize(13)
          .fontColor(CommonStyles.TEXT_SECONDARY)
      }
      .width('100%')

      Row() {
        Text(`${score}分`)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getScoreColor(score))

        Blank()

        Text(this.getScoreLabel(score))
          .fontSize(11)
          .fontColor(this.getScoreColor(score))
          .fontWeight(FontWeight.Medium)
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor(this.getScoreColor(score) + '20')
          .borderRadius(CommonStyles.RADIUS_SM)
      }
      .width('100%')
    }
    .padding(14)
    .backgroundColor(CommonStyles.GRAY_50)
    .borderRadius(CommonStyles.RADIUS_MD)
  }

  private getScoreLabel(score: number): string {
    if (score >= 85) return '优秀';
    if (score >= 70) return '良好';
    if (score >= 60) return '及格';
    return '待提升';
  }

  @Builder
  PrivilegeRow(title: string, v1: string, v2: string, v3: string, v4: string) {
    Column({ space: 8 }) {
      Text(title)
        .fontSize(13)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .fontWeight(FontWeight.Medium)
        .width('100%')

      Row({ space: 4 }) {
        Text(v1).fontSize(11).fontColor(CommonStyles.PRIMARY_DARK).fontWeight(FontWeight.Bold).layoutWeight(1)
        Text(v2).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY).layoutWeight(1)
        Text(v3).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY).layoutWeight(1)
        Text(v4).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY).layoutWeight(1)
      }
      .width('100%')
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
    .border({
      width: { bottom: 0.5 },
      color: CommonStyles.BORDER_LIGHT
    })
  }
}