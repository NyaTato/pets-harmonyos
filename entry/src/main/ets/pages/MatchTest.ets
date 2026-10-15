import { RouterHelper } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { PetCard } from '../components/PetCard';
import { Pet } from '../mock/PetData';
import {
  matchQuestions,
  calculateMatchResult,
  getRecommendedPetsByMatch,
  getTestSuggestions,
  saveTestHistory,
  getUserTestHistories,
  getTestProgress,
  type MatchQuestion,
  type MatchOption,
  type MatchResult,
  type TestHistory,
  type SaveTestHistoryData
} from '../mock/MatchTestData';
import { BackButton } from '../components/BackButton';
import { SafeArea } from '../components/SafeArea';
import { promptAction } from '@kit.ArkUI';

enum MatchPageState {
  WELCOME = 'welcome',
  QUESTIONNAIRE = 'questionnaire',
  RESULT = 'result',
  HISTORY = 'history'
}

@Entry
@Component
struct MatchTest {
  @State private currentPage: MatchPageState = MatchPageState.WELCOME;
  @State private currentQuestionIndex: number = 0;
  @State private answers: Record<number, number> = {};
  @State private matchResult: MatchResult | null = null;
  @State private testHistories: TestHistory[] = [];
  @State private selectedOptionId: number | null = null;
  @State private isAnimating: boolean = false;
  @State private recommendedPetsList: Pet[] = [];
  @State private progressValue: number = 0;
  @State private refreshFlag: number = 0; // 用于强制刷新UI

  aboutToAppear(): void {
    this.loadTestHistories();
  }

  // 更新进度条和UI
  private updateProgress(): void {
    this.progressValue = (this.currentQuestionIndex / matchQuestions.length) * 100;
    this.refreshFlag++;
  }

  private loadTestHistories(): void {
    this.testHistories = getUserTestHistories(1);
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top']
      }) {
        if (this.currentPage === MatchPageState.WELCOME) {
          this.WelcomePage()
        } else if (this.currentPage === MatchPageState.QUESTIONNAIRE) {
          this.QuestionnairePage()
        } else if (this.currentPage === MatchPageState.RESULT) {
          this.ResultPage()
        } else if (this.currentPage === MatchPageState.HISTORY) {
          this.HistoryPage()
        }
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: '45mm' })
  }

  // ========== Welcome Page ==========
  @Builder
  WelcomePage() {
    Column({ space: 32 }) {
      Row() {
        BackButton()

        Blank()

        Text('🐾 匹配测试')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Blank()

        Text('')
          .width(24)
      }
      .width('100%')
      .padding({ left: CommonStyles.LG, right: CommonStyles.LG, top: 16, bottom: 16 })

      Scroll() {
        Column({ space: 28 }) {
          Stack({ alignContent: Alignment.Center }) {
            // 外圈光晕
            Column()
              .width(120)
              .height(120)
              .borderRadius(60)
              .backgroundColor('#3B82F608')

            // 中圈渐变环
            Column()
              .width(100)
              .height(100)
              .borderRadius(50)
              .linearGradient({
                angle: 135,
                colors: [
                  ['#60A5FA', 0],
                  ['#3B82F6', 0.5],
                  ['#2563EB', 1]
                ]
              })
              .shadow({
                radius: 20,
                color: 'rgba(59,130,246,0.25)',
                offsetX: 0,
                offsetY: 6
              })

            // 内圈白色底
            Column()
              .width(80)
              .height(80)
              .borderRadius(40)
              .backgroundColor('#FFFFFF')

            // 图标组合
            Column({ space: 2 }) {
              Text('🐾')
                .fontSize(32)

              Row({ space: 4 }) {
                Text('❤️')
                  .fontSize(14)
                Text('🐱')
                  .fontSize(14)
                Text('🐶')
                  .fontSize(14)
              }
            }
            .justifyContent(FlexAlign.Center)
          }
          .margin({ top: 40 })

          Text('找到你的理想伴侣')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.TEXT_PRIMARY)

          Text('通过8道科学题目，AI将为你推荐最匹配的宠物伙伴')
            .fontSize(16)
            .fontColor(CommonStyles.TEXT_SECONDARY)
            .textAlign(TextAlign.Center)
            .width('80%')

          Column({ space: 16 }) {
            this.FeatureItem('🧠', '科学匹配', '多维度分析性格、空间、时间等因素')
            this.FeatureItem('⏱️', '快速完成', '仅需2分钟，8道精选题')
            this.FeatureItem('🎯', '精准推荐', '基于专业算法的智能推荐')
          }
          .width('90%')
          .margin({ top: 20 })

          Button('开始测试', { type: ButtonType.Capsule })
            .width('80%')
            .height(52)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.WHITE)
            .backgroundColor(CommonStyles.PRIMARY)
            .borderRadius(CommonStyles.RADIUS_FULL)
            .shadow(CommonStyles.SHADOW_BRAND_OLD)
            .margin({ top: 40 })
            .onClick(() => {
              this.startQuestionnaire();
            })

          if (this.testHistories.length > 0) {
            Text(`查看历史记录 (${this.testHistories.length}次)`)
              .fontSize(15)
              .fontColor(CommonStyles.PRIMARY)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 20 })
              .onClick(() => {
                this.currentPage = MatchPageState.HISTORY;
              })
          }

          Blank().height(40)
        }
        .width('100%')
        .padding({ bottom: 32 })
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .backgroundColor(CommonStyles.BG_SECONDARY)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  FeatureItem(icon: string, title: string, desc: string) {
    Row({ space: 14 }) {
      // 精美图标背景
      Stack({ alignContent: Alignment.Center }) {
        Column()
          .width(48)
          .height(48)
          .borderRadius(14)
          .linearGradient({
            angle: 135,
            colors: [
              ['#EFF6FF', 0],
              ['#DBEAFE', 1]
            ]
          })

        Text(icon)
          .fontSize(24)
      }

      Column({ space: 4 }) {
        Text(title)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Text(desc)
          .fontSize(13)
          .fontColor(CommonStyles.TEXT_SECONDARY)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
  }

  // ========== Questionnaire Page ==========
  @Builder
  QuestionnairePage() {
    Column() {
      Column({ space: 16 }) {
        Row() {
          Text('✕')
            .fontSize(24)
            .fontColor(CommonStyles.TEXT_TERTIARY)
            .onClick(() => {
              this.showExitConfirm();
            })

          Blank()

          Text(`第 ${this.currentQuestionIndex + 1}/${matchQuestions.length} 题`)
            .fontSize(15)
            .fontColor(CommonStyles.TEXT_SECONDARY)

          Blank()

          Text('')
            .width(24)
        }
        .width('100%')
        .padding({ left: CommonStyles.LG, right: CommonStyles.LG, top: 16 })

        Progress({
          value: (this.currentQuestionIndex / matchQuestions.length) * 100,
          total: 100,
          type: ProgressType.Linear
        })
          .width('100%')
          .color(CommonStyles.PRIMARY)
          .backgroundColor(CommonStyles.GRAY_200)

        // ✅ 修复关键：使用 key 强制组件重建，直接访问数组元素
        if (this.currentQuestionIndex < matchQuestions.length) {
          Column() {
            // 直接渲染题目文本 - 使用 @State 变量 currentQuestionIndex
            Text(matchQuestions[this.currentQuestionIndex].question)
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor(CommonStyles.TEXT_PRIMARY)
              .width('100%')
              .textAlign(TextAlign.Center)

            // 直接渲染选项列表 - 使用 ForEach 并绑定正确的 key
            ForEach(matchQuestions[this.currentQuestionIndex].options, (option: MatchOption) => {
              Row({ space: 14 }) {
                Stack({ alignContent: Alignment.Center }) {
                  if (this.selectedOptionId === option.id) {
                    Column()
                      .width(28)
                      .height(28)
                      .borderRadius(14)
                      .linearGradient({
                        angle: 135,
                        colors: [
                          ['#60A5FA', 0],
                          ['#3B82F6', 1]
                        ]
                      })
                      .shadow({
                        radius: 8,
                        color: 'rgba(59,130,246,0.3)',
                        offsetX: 0,
                        offsetY: 2
                      })

                    Text('✓')
                      .fontSize(14)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#FFFFFF')
                  } else {
                    Column()
                      .width(28)
                      .height(28)
                      .borderRadius(14)
                      .backgroundColor('#F1F5F9')
                      .border({
                        width: 2,
                        color: '#E2E8F0',
                        style: BorderStyle.Solid
                      })
                  }
                }

                Text(option.text)
                  .fontSize(15)
                  .fontColor(this.selectedOptionId === option.id ? CommonStyles.PRIMARY : CommonStyles.TEXT_PRIMARY)
                  .fontWeight(this.selectedOptionId === option.id ? FontWeight.Medium : FontWeight.Normal)
                  .layoutWeight(1)
              }
              .width('100%')
              .padding(16)
              .backgroundColor(this.selectedOptionId === option.id ? '#EFF6FF' : '#FFFFFF')
              .borderRadius(CommonStyles.RADIUS_LG)
              .border({
                width: this.selectedOptionId === option.id ? 2 : 1,
                color: this.selectedOptionId === option.id ? '#93C5FD' : CommonStyles.BORDER_LIGHT,
                radius: CommonStyles.RADIUS_LG
              })
              .shadow(this.selectedOptionId === option.id ? {
                radius: 12,
                color: 'rgba(59,130,246,0.08)',
                offsetX: 0,
                offsetY: 2
              } : CommonStyles.SHADOW_SM)
                  .onClick(() => {
                    this.selectOption(option.id);
                  })
              }, (option: MatchOption) => `${option.id}_${this.currentQuestionIndex}`)  // ✅ 关键：动态key
          }
          .width('90%')
          .padding({ top: 32, bottom: 32 })
          .key(`question_container_${this.currentQuestionIndex}`)  // ✅ 关键：强制重建整个容器
        }
      }
      .width('100%')
      .backgroundColor('#FFFFFF')

      Button(this.getButtonText(), { type: ButtonType.Capsule })
        .width('90%')
        .height(48)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.selectedOptionId !== null ? '#FFFFFF' : CommonStyles.TEXT_TERTIARY)
        .backgroundColor(this.selectedOptionId !== null ? CommonStyles.PRIMARY : CommonStyles.GRAY_200)
        .borderRadius(CommonStyles.RADIUS_FULL)
        .enabled(this.selectedOptionId !== null)
        .margin({ top: 20 })
        .onClick(() => {
          if (this.selectedOptionId !== null) {
            this.nextQuestion();
          }
        })
    }
    .width('100%').layoutWeight(1).padding({ bottom: 32 })
    .backgroundColor(CommonStyles.BG_SECONDARY)
  }

  // 获取按钮文本
  private getButtonText(): string {
    const isLastQuestion = this.currentQuestionIndex >= matchQuestions.length - 1;
    return this.selectedOptionId !== null ? (isLastQuestion ? '提交测试' : '下一题') : '请选择一个选项';
  }

  // ========== Result Page ==========
  @Builder
  ResultPage() {
    Scroll() {
      Column({ space: 20 }) {
        Row() {
          BackButton()

          Blank()

          Text('匹配结果')
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

        if (this.matchResult) {
          this.ResultScoreCard()
          this.ResultDetails()
          this.RecommendedPets()
          this.ResultActions()
        }
      }
      .width('100%')
      .padding({ left: CommonStyles.LG, right: CommonStyles.LG, bottom: 32 })
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .layoutWeight(1)
    .backgroundColor(CommonStyles.BG_SECONDARY)
  }

  @Builder
  ResultScoreCard() {
    Column({ space: 20 }) {
      // 精美图标区域 - 根据宠物类型显示对应图标
      Stack({ alignContent: Alignment.Center }) {
        // 外圈光晕
        Column()
          .width(140)
          .height(140)
          .borderRadius(70)
          .backgroundColor(this.getPetTypeColor() + '08')

        // 中圈渐变环
        Column()
          .width(120)
          .height(120)
          .borderRadius(60)
          .linearGradient({
            angle: 135,
            colors: [
              [this.getPetTypeLightColor(), 0],
              [this.getPetTypeColor(), 0.5],
              [this.getPetTypeDarkColor(), 1]
            ]
          })
          .shadow({
            radius: 25,
            color: this.getPetTypeShadowColor(),
            offsetX: 0,
            offsetY: 8
          })

        // 内圈白色底
        Column()
          .width(95)
          .height(95)
          .borderRadius(47)
          .backgroundColor('#FFFFFF')

        // 图标组合 - 根据宠物类型动态显示
        Column({ space: 4 }) {
          Text(this.getPetTypeIcon())
            .fontSize(36)

          Row({ space: 4 }) {
            Text(this.getPetTypeSubIcon1())
              .fontSize(16)
            Text(this.getPetTypeSubIcon2())
              .fontSize(16)
          }
        }
        .justifyContent(FlexAlign.Center)
      }

      // 分数信息区
      Column({ space: 10 }) {
        Text(`${this.matchResult!.score}%`)
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getPetTypeColor())

        Text('匹配度')
          .fontSize(16)
          .fontColor(CommonStyles.TEXT_SECONDARY)

        // 宠物类型 + 等级标签
        Row({ space: 8 }) {
          Text(`${this.matchResult!.petType} · ${this.matchResult!.levelText}`)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .padding({ left: 24, right: 24, top: 10, bottom: 10 })
            .backgroundColor(this.getPetTypeColor())
            .borderRadius(22)
        }
      }
    }
    .width('100%')
    .padding({ top: 32, bottom: 32 })
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  // ========== 根据宠物类型返回对应的图标和颜色 ==========
  private getPetTypeIcon(): string {
    const petType = this.matchResult?.petType || '';
    if (petType === '猫') {
      return '🐱'; // 猫咪图标
    } else if (petType === '狗') {
      return '🐶'; // 狗狗图标
    } else {
      return '🐰'; // 兔子/其他图标
    }
  }

  private getPetTypeSubIcon1(): string {
    const petType = this.matchResult?.petType || '';
    if (petType === '猫') {
      return '😺';
    } else if (petType === '狗') {
      return '🦮';
    } else {
      return '🥕';
    }
  }

  private getPetTypeSubIcon2(): string {
    const petType = this.matchResult?.petType || '';
    if (petType === '猫') {
      return '🐈';
    } else if (petType === '狗') {
      return '🐕';
    } else {
      return '🐇';
    }
  }

  private getPetTypeColor(): string {
    const petType = this.matchResult?.petType || '';
    if (petType === '猫') {
      return '#EC4899'; // 粉红色（猫咪）
    } else if (petType === '狗') {
      return '#F59E0B'; // 橙黄色（狗狗）
    } else {
      return '#10B981'; // 绿色（其他/兔子）
    }
  }

  private getPetTypeLightColor(): string {
    const petType = this.matchResult?.petType || '';
    if (petType === '猫') {
      return '#FDF2F8';
    } else if (petType === '狗') {
      return '#FFFBEB';
    } else {
      return '#ECFDF5';
    }
  }

  private getPetTypeDarkColor(): string {
    const petType = this.matchResult?.petType || '';
    if (petType === '猫') {
      return '#DB2777';
    } else if (petType === '狗') {
      return '#D97706';
    } else {
      return '#059669';
    }
  }

  private getPetTypeShadowColor(): string {
    const petType = this.matchResult?.petType || '';
    if (petType === '猫') {
      return 'rgba(236,72,153,0.3)';
    } else if (petType === '狗') {
      return 'rgba(245,158,11,0.3)';
    } else {
      return 'rgba(16,185,129,0.3)';
    }
  }

  @Builder
  ResultDetails() {
    Column({ space: 16 }) {
      Text('📋 匹配说明')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      Text(this.matchResult!.description)
        .fontSize(15)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .lineHeight(22)
        .width('100%')

      Divider().color(CommonStyles.BORDER_LIGHT).margin({ top: 8, bottom: 8 })

      Text('💡 推荐理由')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')
        .margin({ top: 8 })

      ForEach(this.matchResult!.recommendation, (suggestion: string, index: number) => {
        Row({ space: 12 }) {
          // 精美序号圆
          Text(`${index + 1}`)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.PRIMARY)
            .width(28)
            .height(28)
            .borderRadius(14)
            .backgroundColor('#EFF6FF')
            .textAlign(TextAlign.Center)

          Text(suggestion)
            .fontSize(15)
            .fontColor(CommonStyles.TEXT_SECONDARY)
            .layoutWeight(1)
        }
        .width('100%')
        .padding({ top: 8, bottom: 8 })
      })
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_SM)
  }

  @Builder
  RecommendedPets() {
    Column({ space: 16 }) {
      Text('🐕 为你推荐的宠物')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      Text(`基于您的偏好，为您精选 ${this.recommendedPetsList.length} 只最适合的宠物`)
        .fontSize(13)
        .fontColor(CommonStyles.TEXT_SECONDARY)

      if (this.recommendedPetsList.length > 0) {
        Scroll() {
          Row({ space: 14 }) {
            ForEach(this.recommendedPetsList.slice(0, 6), (pet: Pet) => {
              this.RecommendPetCard(pet)
            })
          }
          .width('100%')
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .height(220)
      } else {
        Column({ space: 12 }) {
          Text('🔍')
            .fontSize(40)
          Text('暂无推荐宠物')
            .fontSize(15)
            .fontColor(CommonStyles.TEXT_SECONDARY)
        }
        .height(150)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_SM)
  }

  @Builder
  RecommendPetCard(pet: Pet) {
    Column({ space: 10 }) {
      // 宠物图片
      Stack({ alignContent: Alignment.Bottom }) {
        Image(pet.images && pet.images.length > 0 ? $rawfile(pet.images[0]) : '')
          .width('100%')
          .height(130)
          .objectFit(ImageFit.Cover)
          .borderRadius({ topLeft: CommonStyles.RADIUS_LG, topRight: CommonStyles.RADIUS_LG })

        // 渐变遮罩
        Column()
          .width('100%')
          .height(40)
          .linearGradient({
            angle: 180,
            colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0.4)', 1]]
          })
          .borderRadius({ bottomLeft: CommonStyles.RADIUS_LG, bottomRight: CommonStyles.RADIUS_LG })
      }

      // 宠物信息
      Column({ space: 4 }) {
        Row() {
          Text(pet.name)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(`${pet.age}岁`)
            .fontSize(12)
            .fontColor(CommonStyles.PRIMARY)
            .padding({ left: 8, right: 8, top: 2, bottom: 2 })
            .backgroundColor('#EFF6FF')
            .borderRadius(10)
        }
        .width('100%')

        Row() {
          Text(pet.breed)
            .fontSize(12)
            .fontColor(CommonStyles.TEXT_SECONDARY)

          Blank()

          Text(pet.gender === 'male' ? '♂️' : '♀️')
            .fontSize(12)
        }
        .width('100%')

        // 匹配度标签
        Row() {
          Text('演示分数')
            .fontSize(11)
            .fontColor(CommonStyles.PRIMARY)

          Text('95（示例）') // 固定演示值，不代表真实匹配结论
            .fontSize(11)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .backgroundColor(CommonStyles.PRIMARY)
            .borderRadius(8)
        }
        .width('100%')
      }
    }
    .width(160)
    .padding({ left: 10, right: 10, bottom: 10 })
    .backgroundColor('#FAFBFC')
    .borderRadius(CommonStyles.RADIUS_XL)
    .border({
      width: 1,
      color: '#E2E8F0',
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_XL
    })
    .shadow(CommonStyles.SHADOW_SM)
    .onClick(() => {
      RouterHelper.navigateToPetDetail(pet.id);
    })
  }

  @Builder
  ResultActions() {
    Column({ space: 14 }) {
      Button('查看更多宠物 🐾', { type: ButtonType.Capsule })
        .width('100%')
        .height(48)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.PRIMARY)
        .backgroundColor(CommonStyles.PRIMARY_LIGHT)
        .borderRadius(CommonStyles.RADIUS_MD)
        .onClick(() => {
          RouterHelper.navigateToPetList();
        })

      Row({ space: 14 }) {
        Button('重新测试', { type: ButtonType.Normal })
          .layoutWeight(1)
          .height(44)
          .fontSize(15)
          .fontColor(CommonStyles.TEXT_SECONDARY)
          .backgroundColor(CommonStyles.GRAY_100)
          .borderRadius(CommonStyles.RADIUS_MD)
          .onClick(() => {
            this.restartTest();
          })

        Button('分享结果', { type: ButtonType.Capsule })
          .layoutWeight(1)
          .height(44)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.WHITE)
          .backgroundColor(CommonStyles.PRIMARY)
          .borderRadius(CommonStyles.RADIUS_MD)
          .onClick(() => {
            this.shareResult();
          })
      }
    }
    .width('100%')
  }

  // ========== History Page ==========
  @Builder
  HistoryPage() {
    Column() {
      Row() {
        BackButton({
          onBackClick: () => { this.currentPage = MatchPageState.WELCOME; }
        })

        Blank()

        Text('历史记录')
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

      if (this.testHistories.length === 0) {
        Column({ space: 20 }) {
          // 精美空状态图标
          Stack({ alignContent: Alignment.Center }) {
            Column()
              .width(120)
              .height(120)
              .borderRadius(60)
              .backgroundColor('#F1F5F9')

            Text('📭')
              .fontSize(48)
          }

          Text('暂无测试记录')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor(CommonStyles.TEXT_PRIMARY)

          Text('完成测试后可在此查看匹配历史')
            .fontSize(14)
            .fontColor(CommonStyles.TEXT_SECONDARY)

          Button('去测试', { type: ButtonType.Capsule })
            .margin({ top: 20 })
            .height(44)
            .padding({ left: 32, right: 32 })
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF')
            .backgroundColor(CommonStyles.PRIMARY)
            .borderRadius(CommonStyles.RADIUS_FULL)
            .shadow({
              radius: 12,
              color: 'rgba(59,130,246,0.3)',
              offsetX: 0,
              offsetY: 4
            })
            .onClick(() => {
              this.currentPage = MatchPageState.WELCOME;
            })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(CommonStyles.BG_SECONDARY)
        .layoutWeight(1)
      } else {
        Scroll() {
          Column({ space: 16 }) {
            ForEach(this.testHistories, (history: TestHistory) => {
              this.HistoryCard(history)
            })
          }
          .padding({ left: CommonStyles.LG, right: CommonStyles.LG, top: 16, bottom: 32 })
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .layoutWeight(1)
        .backgroundColor(CommonStyles.BG_SECONDARY)
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  HistoryCard(history: TestHistory) {
    Row({ space: 16 }) {
      // 精美分数圆
      Stack({ alignContent: Alignment.Center }) {
        Column()
          .width(56)
          .height(56)
          .borderRadius(28)
          .linearGradient({
            angle: 135,
            colors: [
              ['#DBEAFE', 0],
              ['#BFDBFE', 1]
            ]
          })

        Column({ space: 2 }) {
          Text(`${history.score}%`)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.PRIMARY)

          Text(history.levelText)
            .fontSize(10)
            .fontColor(CommonStyles.PRIMARY)
        }
      }

      Column({ space: 6 }) {
        Text('测试时间')
          .fontSize(12)
          .fontColor(CommonStyles.TEXT_TERTIARY)

        Text(new Date(history.timestamp).toLocaleDateString())
          .fontSize(15)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .fontWeight(FontWeight.Medium)

        Text(new Date(history.timestamp).toLocaleTimeString())
          .fontSize(13)
          .fontColor(CommonStyles.TEXT_SECONDARY)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.End)

      // 查看详情按钮
      Text('查看')
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.PRIMARY)
        .padding({ left: 14, right: 14, top: 8, bottom: 8 })
        .backgroundColor('#EFF6FF')
        .borderRadius(16)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
    .onClick(() => {
      this.viewHistoryDetail(history);
    })
  }

  // ========== Methods ==========
  private startQuestionnaire(): void {
    this.answers = {};
    this.currentQuestionIndex = 0;
    this.selectedOptionId = null;
    this.isAnimating = false;
    this.currentPage = MatchPageState.QUESTIONNAIRE;
  }

  private viewHistoryDetail(history: TestHistory): void {
    this.matchResult = history.result;
    this.currentPage = MatchPageState.RESULT;
  }

  private selectOption(optionId: number): void {
    this.selectedOptionId = optionId;
  }

  private nextQuestion(): void {
    if (this.selectedOptionId !== null) {
      this.answers[this.currentQuestionIndex] = this.selectedOptionId;

      if (this.currentQuestionIndex < matchQuestions.length - 1) {
        // ✅ 简化逻辑：只更新索引和状态，UI会自动响应
        this.currentQuestionIndex++;
        this.selectedOptionId = null;
        this.updateProgress();
      } else {
        this.completeTest();
      }
    }
  }

  private completeTest(): void {
    const result: MatchResult = calculateMatchResult(this.answers);
    this.matchResult = result;
    this.recommendedPetsList = getRecommendedPetsByMatch(result);

    const historyData: SaveTestHistoryData = {
      userId: 1,
      score: result.score,
      levelText: result.levelText,
      answers: this.answers,
      timestamp: new Date().toISOString()
    };
    saveTestHistory(historyData);

    this.currentPage = MatchPageState.RESULT;
  }

  private restartTest(): void {
    this.startQuestionnaire();
  }

  private shareResult(): void {
    promptAction.showToast({ message: '分享功能开发中' });
  }

  private showExitConfirm(): void {
    promptAction.showDialog({
      title: '确认退出',
      message: '确定要退出测试吗？当前进度将会丢失。',
      buttons: [
        { text: '继续测试', color: CommonStyles.PRIMARY },
        { text: '退出', color: CommonStyles.DANGER }
      ]
    }).then((result: promptAction.ShowDialogSuccessResponse) => {
      if (result.index === 1) {
        this.currentPage = MatchPageState.WELCOME;
      }
    });
  }
}
