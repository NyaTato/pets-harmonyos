﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿import { CommonStyles } from '../common/css/CommonStyles';
import { RouterHelper } from '../router/RouterHelper';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';
import { petList, Pet } from '../mock/PetData';
import { promptAction } from '@kit.ArkUI';

interface UserPreference {
  petType: string;
  size: string;
  ageRange: string;
  activityLevel: string;
}

interface PrefOption {
  value: string;
  label: string;
  icon?: string;
}

interface RecommendResult {
  pet: Pet;
  matchScore: number;
  dimensionScores: DimensionScore[];
  keyAdvantages: string[];
  aiInsight: string;
  isLiked: boolean;
  isExpanded: boolean;
}

interface DimensionScore {
  label: string;
  score: number;
  detail: string;
}

@Entry
@Component
struct SmartRecommendation {
  @State private currentStep: number = 0;
  @State private preference: UserPreference = {
    petType: 'all',
    size: 'medium',
    ageRange: 'young',
    activityLevel: 'moderate'
  };
  @State private results: RecommendResult[] = [];
  @State private isAnalyzing: boolean = false;
  @State private analysisProgress: number = 0;
  @State private analysisStage: string = '';

  private petTypeOptions: PrefOption[] = [
    { value: 'all', label: '全部', icon: '🐾' },
    { value: 'cat', label: '猫咪', icon: '🐱' },
    { value: 'dog', label: '狗狗', icon: '🐶' },
    { value: 'other', label: '其他', icon: '🦜' }
  ];
  private sizeOptions: PrefOption[] = [
    { value: 'small', label: '小型', icon: '🐹' },
    { value: 'medium', label: '中型', icon: '🐕' },
    { value: 'large', label: '大型', icon: '🦁' }
  ];
  private ageOptions: PrefOption[] = [
    { value: 'young', label: '幼年', icon: '👶' },
    { value: 'adult', label: '成年', icon: '🧑' },
    { value: 'senior', label: '老年', icon: '👴' }
  ];
  private activityOptions: PrefOption[] = [
    { value: 'low', label: '宅家型', icon: '🏠' },
    { value: 'moderate', label: '适度运动', icon: '🚶' },
    { value: 'high', label: '活跃运动', icon: '⚡' }
  ];

  build() {
    Column() {
      SafeArea({ edges: ['top'] }) {
        Row() {
          BackButton()
          Text('宠物匹配（模拟演示）')
            .fontSize(18).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
            .layoutWeight(1)
          if (this.currentStep > 0 && this.currentStep < 3) {
            Text(this.currentStep === 1 ? '开始分析' : '')
              .fontSize(14).fontColor('#14B8A6').fontWeight(FontWeight.Medium)
              .visibility(this.currentStep === 1 ? Visibility.Visible : Visibility.None)
              .onClick(() => this.startAnalysis())
          }
        }
        .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })
        .backgroundColor('#FFFFFF')

        Scroll() {
          Column({ space: 20 }) {
            if (this.currentStep === 0) {
              this.IntroSection()
            } else if (this.currentStep === 1) {
              this.PreferenceSection()
            } else if (this.currentStep === 2) {
              this.AnalyzingSection()
            } else {
              this.ResultSection()
            }
          }
          .width('100%').padding({ left: 16, right: 16, bottom: 32 })
        }
        .scrollable(ScrollDirection.Vertical).scrollBar(BarState.Off)
        .layoutWeight(1).backgroundColor('#F8FAFC')
      }
    }
    .width('100%').height('100%')
    .padding({ top: '45mm' })
  }

  // ==================== 步骤0: AI智能介绍 ====================
  @Builder
  IntroSection() {
    Column({ space: 20 }) {

      Stack({ alignContent: Alignment.Bottom }) {
        Column()
          .width(100).height(100)
          .borderRadius(50)
          .backgroundColor('rgba(20,184,166,0.08)')
        Text('🤖').fontSize(52)
      }

      Text('宠物匹配演示')
        .fontSize(26).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)

      Text('基于本地示例数据展示偏好选择与匹配界面\n结果含随机演示，不调用 AI 模型')
        .fontSize(14).fontColor(CommonStyles.TEXT_SECONDARY)
        .textAlign(TextAlign.Center).lineHeight(22).width('88%')

      Row({ space: 10 }) {
        this.StatCard('本地', '示例数据', '🎯')
        this.StatCard('模拟', '展示分数', '📊')
        this.StatCard('未接入', 'AI 模型', '⚡')
      }

      Column({ space: 14 }) {
        Text('演示内容').fontSize(15).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
          .width('100%')

        this.CapabilityRow('🧠', '偏好选择', '选择喜欢的宠物类型与生活场景', '#14B8A6')
        this.CapabilityRow('📈', '示例排序', '使用本地宠物数据展示候选结果', '#0D9488')
        this.CapabilityRow('🔄', '模拟反馈', '当前结果不具备学习能力', '#0F766E')
        this.CapabilityRow('💡', '展示边界', '演示分数不代表实际适配结论', '#115E59')
      }
      .width('100%').padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(20)
      .shadow({ color: 'rgba(20,184,166,0.08)', radius: 16, offsetX: 0, offsetY: 2 })

      Button('🚀 开始宠物匹配之旅', { type: ButtonType.Capsule })
        .width('100%').height(52).fontSize(17)
        .fontColor('#FFFFFF').fontWeight(FontWeight.Medium)
        .backgroundColor('#14B8A6')
        .borderRadius(16)
        .shadow({ color: 'rgba(20,184,166,0.35)', radius: 16, offsetX: 0, offsetY: 4 })
        .margin({ top: 8 })
        .onClick(() => { this.currentStep = 1; })
    }
    .width('100%').padding({ top: 24, bottom: 16, left: 16, right: 16 })
    .justifyContent(FlexAlign.Start).alignItems(HorizontalAlign.Center)
  }

  @Builder
  StatCard(value: string, label: string, icon: string) {
    Column({ space: 4 }) {
      Text(icon).fontSize(16)
      Text(value).fontSize(18).fontWeight(FontWeight.Bold).fontColor('#14B8A6')
      Text(label).fontSize(10).fontColor(CommonStyles.TEXT_TERTIARY)
    }
    .layoutWeight(1)
    .padding(10)
    .backgroundColor('#F0FDFA')
    .borderRadius(12)
  }

  @Builder
  CapabilityRow(icon: string, title: string, desc: string, accent: string) {
    Row({ space: 12 }) {
      Text(icon).fontSize(20)
        .width(36).height(36)
        .backgroundColor(accent + '12')
        .borderRadius(9)
        .textAlign(TextAlign.Center)
      Column({ space: 2 }) {
        Text(title).fontSize(14).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
        Text(desc).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY).lineHeight(16)
      }
      .layoutWeight(1).alignItems(HorizontalAlign.Start)
    }
    .width('100%').padding(10)
    .backgroundColor('#F8FAFC')
    .borderRadius(10)
  }

  // ==================== 步骤1: 偏好用户构建 ====================
  @Builder
  PreferenceSection() {
    Column({ space: 18 }) {

      Row() {
        Column({ space: 2 }) {
          Text('您的专属偏好画像')
            .fontSize(19).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
          Text('选择偏好，查看本地示例匹配结果')
            .fontSize(13).fontColor(CommonStyles.TEXT_TERTIARY)
        }.alignItems(HorizontalAlign.Start)

        Blank()
        Column({ space: 4 }) {
          Text(this.getMatchPoolCount().toString()).fontSize(22).fontWeight(FontWeight.Bold).fontColor('#14B8A6')
          Text('候选宠物').fontSize(10).fontColor(CommonStyles.TEXT_TERTIARY)
        }
        .padding(10)
        .backgroundColor('#F0FDFA')
        .borderRadius(12)
      }
      .width('100%')

      this.PrefGroup('宠物类型', 'petType', this.petTypeOptions)
      this.PrefGroup('体型大小', 'size', this.sizeOptions)
      this.PrefGroup('年龄阶段', 'ageRange', this.ageOptions)
      this.PrefGroup('活动强度', 'activityLevel', this.activityOptions)

      this.AIPreviewPanel()

      Button('查看模拟匹配结果', { type: ButtonType.Capsule })
        .width('100%').height(52).fontSize(17)
        .fontColor('#FFFFFF').fontWeight(FontWeight.Medium)
        .backgroundColor('#14B8A6')
        .borderRadius(16)
        .shadow({ color: 'rgba(20,184,166,0.35)', radius: 16, offsetX: 0, offsetY: 4 })
        .onClick(() => this.startAnalysis())
    }
  }

  @Builder
  PrefGroup(title: string, field: keyof UserPreference, options: PrefOption[]) {
    Column({ space: 10 }) {
      Row() {
        Text(title).fontSize(15).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text(this.getSelectLabel(field, options)).fontSize(12).fontColor('#14B8A6').fontWeight(FontWeight.Medium)
          .padding({ left: 8, right: 8, top: 3, bottom: 3 })
          .backgroundColor('#F0FDFA')
          .borderRadius(CommonStyles.RADIUS_FULL)
      }
      .width('100%')

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(options, (opt: PrefOption) => {
          Row({ space: 4 }) {
            if (opt.icon) {
              Text(opt.icon).fontSize(14)
                .fontColor(this.getPreferenceValue(field) === opt.value ? '#FFFFFF' : CommonStyles.TEXT_SECONDARY)
            }
            Text(opt.label).fontSize(13).fontWeight(FontWeight.Medium)
              .fontColor(this.getPreferenceValue(field) === opt.value ? '#FFFFFF' : CommonStyles.TEXT_SECONDARY)
          }
          .padding({ left: 14, right: 14, top: 8, bottom: 8 })
          .backgroundColor(this.getPreferenceValue(field) === opt.value ? '#14B8A6' : '#F1F5F9')
          .borderRadius(CommonStyles.RADIUS_FULL)
          .margin({ right: 8, bottom: 8 })
          .onClick(() => { this.setPreferenceValue(field, opt.value); })
        })
      }
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({ color: 'rgba(0,0,0,0.04)', radius: 8, offsetX: 0, offsetY: 1 })
  }

  @Builder
  AIPreviewPanel() {
    Column({ space: 10 }) {
      Row() {
        Text('匹配预览（演示）').fontSize(13).fontWeight(FontWeight.Bold).fontColor('#14B8A6')
        Blank()
        Text('基于当前选择').fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
      }
      .width('100%')

      Row({ space: 12 }) {
        this.PreviewItem('当前筛选', `${this.getMatchPoolCount()}只`, '#14B8A6')
        this.PreviewItem('结果性质', '随机演示', '#0D9488')
        this.PreviewItem('模型调用', '未接入', '#0F766E')
      }
    }
    .width('100%').padding(14)
    .backgroundColor('#F0FDFA')
    .borderRadius(14)
    .border({ width: 1, color: '#99F6E4', radius: 14 })
  }

  @Builder
  PreviewItem(label: string, value: string, color: string) {
    Column({ space: 3 }) {
      Text(label).fontSize(10).fontColor(CommonStyles.TEXT_TERTIARY)
      Text(value).fontSize(13).fontWeight(FontWeight.Bold).fontColor(color)
    }
    .layoutWeight(1)
  }

  // ==================== 步骤2: AI精准分析中 ====================
  @Builder
  AnalyzingSection() {
    Column({ space: 28 }) {

      Stack({ alignContent: Alignment.Bottom }) {
        Column()
          .width(90).height(90)
          .borderRadius(50)
          .backgroundColor('rgba(20,184,166,0.08)')
        Text('⏳').fontSize(48)
      }

      Text(this.analysisStage || '正在生成演示结果...')
        .fontSize(18).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
        .textAlign(TextAlign.Center)

      Column({ space: 10 }) {
        Progress({
          value: this.analysisProgress,
          total: 100,
          type: ProgressType.Linear
        })
          .width('85%').height(10)
          .color('#14B8A6')
          .backgroundColor('#CCFBF1')
          .borderRadius(5)

        Row() {
          Text(`${Math.round(this.analysisProgress)}%`).fontSize(16).fontWeight(FontWeight.Bold).fontColor('#14B8A6')
          Blank()
          Text('分析中...').fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
        }
        .width('85%')
      }

      Column({ space: 10 }) {
        this.AnalysisStageItem('读取本地示例偏好', 15, '📊')
        this.AnalysisStageItem('读取本地宠物列表', 35, '🔍')
        this.AnalysisStageItem('演示匹配过程', 60, '🧮')
        this.AnalysisStageItem('生成模拟分数', 78, '⚖️')
        this.AnalysisStageItem('展示候选结果', 92, '✨')
        this.AnalysisStageItem('完成界面演示', 100, '🎯')
      }
      .width('85%')
    }
    .width('100%').padding({ top: 32, bottom: 24 })
    .justifyContent(FlexAlign.Start).alignItems(HorizontalAlign.Center)
  }

  @Builder
  AnalysisStageItem(text: string, threshold: number, icon: string) {
    Row({ space: 10 }) {
      Text(icon).fontSize(14)
        .width(24).height(24)
        .backgroundColor(this.analysisProgress >= threshold ? '#14B8A6' : '#E2E8F0')
        .borderRadius(6)
        .textAlign(TextAlign.Center)
        .fontColor(this.analysisProgress >= threshold ? '#FFFFFF' : '#94A3B8')

      Text(text)
        .fontSize(13).fontWeight(this.analysisProgress >= threshold ? FontWeight.Medium : FontWeight.Regular)
        .fontColor(this.analysisProgress >= threshold ? CommonStyles.TEXT_PRIMARY : CommonStyles.TEXT_TERTIARY)
        .layoutWeight(1)

      if (this.analysisProgress >= threshold) {
        Text('?').fontSize(12).fontColor('#14B8A6').fontWeight(FontWeight.Bold)
      } else if (this.analysisProgress >= threshold - 15) {
        LoadingProgress().width(14).height(14).color('#14B8A6')
      }
    }
    .width('100%')
  }

  // ==================== 步骤3: 推荐结果 ====================
  @Builder
  ResultSection() {
    Column({ space: 20 }) {

      Row() {
        Column({ space: 2 }) {
          Text('🎉 推荐完成').fontSize(20).fontWeight(FontWeight.Bold).fontColor('#14B8A6')
          Text(`找到 ${this.results.length} 只匹配宠物`).fontSize(13).fontColor(CommonStyles.TEXT_TERTIARY)
        }.alignItems(HorizontalAlign.Start)
        Blank()
        Text('🔄 重新分析')
          .fontSize(13).fontColor('#14B8A6').fontWeight(FontWeight.Medium)
          .padding({ left: 10, right: 10, top: 5, bottom: 5 })
          .backgroundColor('#F0FDFA')
          .borderRadius(10)
          .onClick(() => this.startAnalysis())
      }
      .width('100%')

      ForEach(this.results, (result: RecommendResult, index: number) => {
        if (index === 0) {
          this.TopRecommendCard(result)
        } else {
          this.CompactRecommendCard(result, index)
        }
      })

      Button('返回首页浏览更多', { type: ButtonType.Capsule })
        .width('100%').height(44).fontSize(14)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .backgroundColor('#F1F5F9').borderRadius(12)
        .onClick(() => RouterHelper.back())
    }
  }

  // TOP1 推荐 - Hero卡片
  @Builder
  TopRecommendCard(result: RecommendResult) {
    Column({ space: 16 }) {

      Row({ space: 14 }) {
        Stack({ alignContent: Alignment.TopStart }) {
          Image(result.pet.images && result.pet.images.length > 0 ? $rawfile(result.pet.images[0]) : '')
            .width(110).height(110).objectFit(ImageFit.Cover)
            .borderRadius(20)

          Column() {
            Text('🏆 TOP 1').fontSize(10).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
              .padding({ left: 8, right: 8, top: 3, bottom: 3 })
              .backgroundColor('#14B8A6')
              .borderRadius(8)
          }
          .position({ x: 6, y: 6 })
        }

        Column({ space: 6 }) {
          Row() {
            Text(result.pet.name).fontSize(19).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
            Blank()
            Column({ space: 0 }) {
              Text(`${result.matchScore}`).fontSize(28).fontWeight(FontWeight.Bold).fontColor('#14B8A6')
              Text('模拟分数').fontSize(10).fontColor('#14B8A6')
            }
          }
          .width('100%')

          Text(`${result.pet.breed} · ${result.pet.age}岁 · ${result.pet.gender === 'male' ? '公' : '母'} · ${result.pet.weight || '?'}kg`)
            .fontSize(13).fontColor(CommonStyles.TEXT_SECONDARY)

          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(result.keyAdvantages.slice(0, 3), (tag: string) => {
              Text(tag)
                .fontSize(10).fontWeight(FontWeight.Medium).fontColor('#14B8A6')
                .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                .backgroundColor('#F0FDFA')
                .borderRadius(8)
                .margin({ right: 5, bottom: 4 })
            })
          }
        }
        .layoutWeight(1).alignItems(HorizontalAlign.Start)
      }
      .width('100%')

      Divider().color('#F1F5F9')

      Column({ space: 12 }) {
        Row() {
          Text('推荐演示说明').fontSize(15).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
          Blank()
          Text('模拟数据').fontSize(10).fontColor('#14B8A6').fontWeight(FontWeight.Medium)
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .backgroundColor('#F0FDFA')
            .borderRadius(6)
        }
        .width('100%')

        ForEach(result.dimensionScores, (dim: DimensionScore) => {
          Row({ space: 10 }) {
            Text(dim.label).fontSize(12).fontColor(CommonStyles.TEXT_SECONDARY).width(70)
            Column({ space: 4 }) {
              Row() {
                Text(`${dim.score}（演示）`).fontSize(13).fontWeight(FontWeight.Bold)
                  .fontColor(dim.score >= 95 ? '#10B981' : dim.score >= 85 ? '#14B8A6' : '#F59E0B')
                Blank()
                Progress({
                  value: dim.score,
                  total: 100,
                  type: ProgressType.Linear
                }).width(120).height(6)
                  .color(dim.score >= 95 ? '#10B981' : dim.score >= 85 ? '#14B8A6' : '#F59E0B')
                  .backgroundColor('#F1F5F9').borderRadius(3)
              }
              Text(dim.detail).fontSize(10).fontColor(CommonStyles.TEXT_TERTIARY)
            }
            .layoutWeight(1)
          }
          .width('100%').padding(8)
          .backgroundColor('#FAFAFA')
          .borderRadius(8)
        })

        Divider().color('#F8FAFC')

        Column({ space: 6 }) {
          Row() {
            Text('演示说明').fontSize(13).fontWeight(FontWeight.Bold).fontColor('#14B8A6')
          }
          Text(result.aiInsight)
            .fontSize(12).fontColor(CommonStyles.TEXT_SECONDARY).lineHeight(19)
        }
        .width('100%').padding(12)
        .backgroundColor('#F0FDFA')
        .borderRadius(10)
      }
      .width('100%')

      Row({ space: 8 }) {
        Button(result.isLiked ? '❤️ 已喜欢' : '❤ 喜欢', { type: ButtonType.Capsule })
          .layoutWeight(1).height(38).fontSize(13)
          .fontColor(result.isLiked ? '#FFFFFF' : '#64748B')
          .backgroundColor(result.isLiked ? '#EF4444' : '#F1F5F9')
          .borderRadius(10)
          .onClick(() => {
            result.isLiked = !result.isLiked;
            promptAction.showToast({ message: result.isLiked ? '已添加到喜欢列表' : '已取消喜欢' });
          })

        Button('查看详情', { type: ButtonType.Capsule })
          .layoutWeight(1).height(38).fontSize(13)
          .fontColor('#FFFFFF').fontWeight(FontWeight.Medium)
          .backgroundColor('#14B8A6')
          .borderRadius(10)
          .onClick(() => RouterHelper.navigateToPetDetail(result.pet.id))

        Button('申请领养', { type: ButtonType.Capsule })
          .layoutWeight(1).height(38).fontSize(13)
          .fontColor('#FFFFFF').fontWeight(FontWeight.Medium)
          .backgroundColor('#10B981')
          .borderRadius(10)
          .onClick(() => {
            RouterHelper.navigateToApply(result.pet.id);
            promptAction.showToast({ message: `正在为 ${result.pet.name} 准备申请表单` });
          })
      }
    }
    .width('100%').padding(18)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .border({ width: 2, color: '#99F6E4', radius: 20 })
    .shadow({ color: 'rgba(20,184,166,0.12)', radius: 20, offsetX: 0, offsetY: 4 })
  }

  // 紧凑推荐卡片
  @Builder
  CompactRecommendCard(result: RecommendResult, index: number) {
    Row({ space: 12 }) {
      Stack({ alignContent: Alignment.TopEnd }) {
        Image(result.pet.images && result.pet.images.length > 0 ? $rawfile(result.pet.images[0]) : '')
          .width(72).height(72).objectFit(ImageFit.Cover)
          .borderRadius(14)

        Text(`#${index + 1}`).fontSize(10).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .backgroundColor('#94A3B8')
          .borderRadius(6)
          .position({ x: 46, y: 2 })
      }

      Column({ space: 4 }) {
        Row() {
          Text(result.pet.name).fontSize(15).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
          Blank()
          Text(`${result.matchScore} 分（演示）`).fontSize(15).fontWeight(FontWeight.Bold).fontColor('#14B8A6')
        }
        .width('100%')

        Text(`${result.pet.breed} · ${result.pet.age}岁`)
          .fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)

        Row({ space: 4 }) {
          ForEach(result.keyAdvantages.slice(0, 2), (reason: string) => {
            Text(reason).fontSize(9).fontColor('#14B8A6')
              .padding({ left: 5, right: 5, top: 2, bottom: 2 })
              .backgroundColor('#F0FDFA')
              .borderRadius(4)
          })
        }
      }
      .layoutWeight(1).alignItems(HorizontalAlign.Start)

      Column({ space: 6 }) {
        Button('查看', { type: ButtonType.Capsule })
          .width(70).height(30).fontSize(11)
          .fontColor('#FFFFFF')
          .backgroundColor('#14B8A6')
          .borderRadius(8)
          .onClick(() => RouterHelper.navigateToPetDetail(result.pet.id))

        Button(result.isLiked ? '❤️ 已收藏' : '🤍 收藏', { type: ButtonType.Capsule })
          .width(70).height(30).fontSize(12)
          .fontColor(result.isLiked ? '#EF4444' : '#94A3B8')
          .backgroundColor(result.isLiked ? '#FEF2F2' : '#F1F5F9')
          .borderRadius(8)
          .onClick(() => {
            result.isLiked = !result.isLiked;
            promptAction.showToast({ message: result.isLiked ? '已添加到喜欢列表' : '已取消收藏' });
          })
      }
      .width(76)
    }
    .width('100%').padding(14)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({ color: 'rgba(0,0,0,0.04)', radius: 10, offsetX: 0, offsetY: 1 })
  }

  // ==================== 我的逻辑 ====================

  private getMatchPoolCount(): number {
    let count = petList.filter((p: Pet) => p.adoptionStatus === 'available').length;
    if (this.preference.petType !== 'all') {
      count = petList.filter((p: Pet) => p.type === this.preference.petType && p.adoptionStatus === 'available').length;
    }
    return Math.max(count, 3);
  }

  private getSelectLabel(field: keyof UserPreference, options: PrefOption[]): string {
    const currentValue = this.getPreferenceValue(field);
    const opt = options.find((o: PrefOption) => o.value === currentValue);
    return opt?.label || '';
  }

  private getPreferenceValue(field: keyof UserPreference): string {
    switch (field) {
      case 'petType':
        return this.preference.petType;
      case 'size':
        return this.preference.size;
      case 'ageRange':
        return this.preference.ageRange;
      case 'activityLevel':
        return this.preference.activityLevel;
      default:
        return '';
    }
  }

  private setPreferenceValue(field: keyof UserPreference, value: string): void {
    switch (field) {
      case 'petType':
        this.preference.petType = value;
        break;
      case 'size':
        this.preference.size = value;
        break;
      case 'ageRange':
        this.preference.ageRange = value;
        break;
      case 'activityLevel':
        this.preference.activityLevel = value;
        break;
    }
  }

  private startAnalysis(): void {
    this.currentStep = 2;
    this.isAnalyzing = true;
    this.analysisProgress = 0;
    this.results = [];

    const stages: string[] = [
      '正在收集用户偏好数据...',
      '正在扫描宠物数据库...',
      '正在生成模拟分数...',
      '正在应用个性化权重...',
      '正在生成推荐结果...',
      '正在优化结果排序...'
    ];

    let stageIndex = 0;
    const interval = setInterval(() => {
      this.analysisProgress += Math.random() * 12 + 4;

      if (this.analysisProgress >= (stageIndex + 1) * 16.5 && stageIndex < stages.length) {
        this.analysisStage = stages[stageIndex];
        stageIndex++;
      }

      if (this.analysisProgress >= 100) {
        this.analysisProgress = 100;
        clearInterval(interval);
        setTimeout(() => {
          this.generateResults();
          this.isAnalyzing = false;
          this.currentStep = 3;
        }, 600);
      }
    }, 280);
  }

  private generateResults(): void {
    let candidates: Pet[] = [...petList];

    if (this.preference.petType !== 'all') {
      candidates = candidates.filter((p: Pet) => p.type === this.preference.petType);
    }

    candidates = candidates
      .filter((p: Pet) => p.adoptionStatus === 'available')
      .sort((_a: Pet, _b: Pet): number => Math.random() - 0.5)
      .slice(0, 4);

    this.results = candidates.map((pet: Pet, idx: number): RecommendResult => {
      const baseScore = Math.max(82, 97 - idx * 5 - Math.floor(Math.random() * 3));
      return {
        pet,
        matchScore: baseScore,
        dimensionScores: this.generateDimensionScores(pet, baseScore),
        keyAdvantages: this.generateKeyAdvantages(pet),
        aiInsight: this.generateAIInsight(pet),
        isLiked: false,
        isExpanded: idx === 0
      };
    });
  }

  private generateDimensionScores(pet: Pet, baseScore: number): DimensionScore[] {
    const variance = () => Math.floor(Math.random() * 8) - 4;
    return [
      { label: '性格偏好', score: Math.min(99, baseScore + 2 + variance()), detail: `${pet.name}的性格需现场了解；此处是随机演示分数` },
      { label: '空间偏好', score: Math.min(99, baseScore - 1 + variance()), detail: `示例选择：${this.getSizeLabel()}` },
      { label: '护理预期', score: Math.min(99, baseScore + 1 + variance()), detail: '护理时间应根据真实宠物情况评估' },
      { label: '活动偏好', score: Math.min(99, baseScore + variance()), detail: `示例选择：${this.getActivityLabel()}` },
      { label: '健康资料', score: Math.min(99, baseScore + 3 + variance()), detail: '未核实健康档案，不提供专业结论' }
    ];
  }

  private generateKeyAdvantages(pet: Pet): string[] {
    const pool: string[][] = [
      [`${pet.name}的示例资料`, `已选择"${this.getActivityLabel()}"活动偏好`, '性格信息需线下核实'],
      ['疫苗信息为示例字段', '领养前请核实真实健康档案', '不要仅凭演示结果决策'],
      [`已选择${this.getSizeLabel()}空间预期`, '生活条件需与实际宠物匹配', '当前不提供专业评估']
    ];
    const group = pool[Math.floor(Math.random() * pool.length)];
    return group.slice(0, 3);
  }

  private generateAIInsight(pet: Pet): string {
    const insights: string[] = [
      `这是${pet.name}的本地示例介绍。您选择了"${this.getActivityLabel()}"活动水平与"${this.getSizeLabel()}"空间预期；实际领养仍需了解宠物真实情况。`,
      `${pet.name}显示在演示候选列表中。页面分数由本地模拟逻辑生成，不代表专业评估或真实 AI 推荐。`,
      `请结合宠物健康、生活空间与照护能力作出选择；当前展示没有服务端数据或模型推理。`
    ];
    return insights[Math.floor(Math.random() * insights.length)];
  }

  private getSizeLabel(): string {
    return this.preference.size === 'small' ? '小型空间' : this.preference.size === 'medium' ? '中等空间' : '大型空间';
  }

  private getActivityLabel(): string {
    return this.preference.activityLevel === 'low' ? '宅家型' : this.preference.activityLevel === 'moderate' ? '适度运动' : '活跃运动';
  }
}
