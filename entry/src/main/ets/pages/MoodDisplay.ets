﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿import { CommonStyles } from '../common/css/CommonStyles';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';
import { promptAction } from '@kit.ArkUI';

interface EmotionResult {
  id: string;
  petName: string;
  emotion: string;
  emoji: string;
  confidence: number;
  timestamp: string;
  suggestions: string[];
}

interface EmotionType {
  id: string;
  name: string;
  emoji: string;
  color: string;
  description: string;
}

@Entry
@Component
struct MoodDisplay {
  @State private currentStep: number = 0;
  @State private selectedPetName: string = '';
  @State private isAnalyzing: boolean = false;
  @State private analysisProgress: number = 0;
  @State private currentResult: EmotionResult | null = null;
  @State private history: EmotionResult[] = [];
  @State private showHistory: boolean = false;

  private emotions: EmotionType[] = [
    { id: 'happy', name: '开心满足', emoji: '😺', color: '#10B981', description: '宠物看起来非常愉快和满足' },
    { id: 'relaxed', name: '放松安逸', emoji: '😌', color: '#3B82F6', description: '宠物处于舒适放松的状态' },
    { id: 'curious', name: '好奇探索', emoji: '🐱', color: '#8B5CF6', description: '宠物对周围环境充满兴趣' },
    { id: 'anxious', name: '焦虑不安', emoji: '😰', color: '#F59E0B', description: '宠物可能感到紧张或不安' },
    { id: 'sad', name: '低落沮丧', emoji: '😿', color: '#6B7280', description: '宠物情绪较低，需要更多关注' },
    { id: 'angry', name: '生气警惕', emoji: '😾', color: '#EF4444', description: '宠物处于防御或愤怒状态' },
    { id: 'sleepy', name: '困倦疲惫', emoji: '😴', color: '#06B6D4', description: '宠物想要休息或已经累了' },
    { id: 'excited', name: '兴奋活跃', emoji: '🤩', color: '#EC4899', description: '宠物精力充沛，非常活跃' }
  ];

  aboutToAppear(): void {
    this.history = [
      {
        id: '1',
        petName: '小橘',
        emotion: 'happy',
        emoji: '😺',
        confidence: 92,
        timestamp: '今天 14:30',
        suggestions: ['保持当前互动方式', '可以尝试新玩具', '情绪状态非常好']
      },
      {
        id: '2',
        petName: '豆豆',
        emotion: 'relaxed',
        emoji: '😌',
        confidence: 88,
        timestamp: '昨天 16:20',
        suggestions: ['适合安静陪伴', '轻柔抚摸效果更好', '避免突然的大声']
      }
    ];
  }

  build() {
    Column() {
      SafeArea({ edges: ['top'] }) {
        Row() {
          BackButton()
          Text('情绪识别系统')
            .fontSize(18).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
            .layoutWeight(1)
          if (this.currentStep === 0 && !this.showHistory) {
            Text('历史')
              .fontSize(14).fontColor(CommonStyles.PRIMARY)
              .onClick(() => { this.showHistory = true; })
          } else if (this.showHistory) {
            Text('返回')
              .fontSize(14).fontColor(CommonStyles.PRIMARY)
              .onClick(() => { this.showHistory = false; })
          }
        }
        .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })
        .backgroundColor('#FFFFFF')

        Scroll() {
          Column({ space: 20 }) {
            if (this.showHistory) {
              this.HistoryView()
            } else if (this.currentStep === 0) {
              this.HomeView()
            } else if (this.currentStep === 1) {
              this.AnalyzingView()
            } else {
              this.ResultView()
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

  // ========== 首页：介绍+开始识别 ==========
  @Builder
  HomeView() {
    Column({ space: 24 }) {
      Text('😺').fontSize(56)

      Text('AI 情绪识别')
        .fontSize(24).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)

      Text('通过AI分析宠物的表情、姿态和行为，精准解读它们的内心世界，让您更懂TA')
        .fontSize(13).fontColor(CommonStyles.TEXT_TERTIARY)
        .textAlign(TextAlign.Center)

      Column({ space: 12 }) {
        Text('可识别的情绪类型')
          .fontSize(15).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)

        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.emotions, (e: EmotionType) => {
            Row({ space: 6 }) {
              Text(e.emoji).fontSize(18)
              Text(e.name)
                .fontSize(12).fontWeight(FontWeight.Medium)
                .fontColor(CommonStyles.TEXT_SECONDARY)
            }
            .padding({ left: 12, right: 12, top: 7, bottom: 7 })
            .backgroundColor(e.color + '15')
            .borderRadius(CommonStyles.RADIUS_FULL)
            .margin({ right: 6, bottom: 6 })
          })
        }
      }
      .width('100%').padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(CommonStyles.RADIUS_LG)
      .shadow(CommonStyles.SHADOW_SM)

      this.FeatureCard('📸', '拍照识别', '使用相机拍摄宠物照片，AI自动分析情绪状态')
      this.FeatureCard('🖼️', '相册上传', '从相册选择已有照片进行情绪分析')
      this.FeatureCard('📊', '趋势追踪', '记录每次分析结果，追踪宠物情绪变化趋势')
      this.FeatureCard('💡', '护理建议', '根据情绪状态提供个性化的养护建议')

      Button('开始识别情绪', { type: ButtonType.Capsule })
        .width('100%').height(48).fontSize(16)
        .fontColor('#FFFFFF').fontWeight(FontWeight.Medium)
        .backgroundColor(CommonStyles.PRIMARY)
        .borderRadius(CommonStyles.RADIUS_FULL)
        .onClick(() => { this.startAnalysis(); })

      if (this.history.length > 0) {
        Text(`已有 ${this.history.length} 条识别记录`)
          .fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
          .onClick(() => { this.showHistory = true; })
      }
    }
    .width('100%').padding(24)
    .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
  }

  @Builder
  FeatureCard(icon: string, title: string, desc: string) {
    Row({ space: 12 }) {
      Text(icon).fontSize(22)
      Column({ space: 3 }) {
        Text(title).fontSize(14).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
        Text(desc).fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
      }.layoutWeight(1).alignItems(HorizontalAlign.Start)
    }
    .width('100%').padding(14)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_MD)
    .shadow(CommonStyles.SHADOW_SM)
  }

  // ========== 分析动画页面 ==========
  @Builder
  AnalyzingView() {
    Column({ space: 24 }) {
      Stack({ alignContent: Alignment.Center }) {
        Circle().width(120).height(120).fill(CommonStyles.PRIMARY + '10')

        Text(this.selectedPetName ? `${this.selectedPetName}` : '🐱')
          .fontSize(40)
      }

      Text('AI 正在分析情绪...')
        .fontSize(18).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)

      Progress({
        value: this.analysisProgress,
        total: 100,
        type: ProgressType.Linear
      })
        .width('80%')
        .color(CommonStyles.PRIMARY)
        .backgroundColor('#E5E7EB')
        .borderRadius(CommonStyles.RADIUS_FULL)

      Text(`${Math.round(this.analysisProgress)}%`)
        .fontSize(14).fontColor(CommonStyles.TEXT_TERTIARY)

      Column({ space: 8 }) {
        this.AnalysisStepItem('提取宠物面部特征', 20)
        this.AnalysisStepItem('分析表情微动作', 45)
        this.AnalysisStepItem('结合行为上下文判断', 70)
        this.AnalysisStepItem('生成情绪报告', 95)
      }
    }
    .width('100%').padding(40)
    .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
  }

  @Builder
  AnalysisStepItem(text: string, threshold: number) {
    Row({ space: 8 }) {
      Circle()
        .width(8).height(8)
        .fill(this.analysisProgress >= threshold ? CommonStyles.SUCCESS : '#D1D5DB')

      Text(text)
        .fontSize(12)
        .fontColor(this.analysisProgress >= threshold ? CommonStyles.TEXT_PRIMARY : CommonStyles.TEXT_TERTIARY)
    }
    .width('70%')
  }

  // ========== 结果展示页面 ==========
  @Builder
  ResultView() {
    if (this.currentResult) {
      Column({ space: 20 }) {
        Stack({ alignContent: Alignment.Center }) {
          Column()
            .width(160).height(160)
            .borderRadius(80)
            .backgroundColor(this.getEmotionById(this.currentResult!.emotion)?.color + '20' || '#F1F5F9')

          Text(this.currentResult.emoji)
            .fontSize(64)
        }

        Text(this.currentResult.emotion !== '' ? this.getEmotionById(this.currentResult!.emotion)?.name || '识别完成' : '识别完成')
          .fontSize(26).fontWeight(FontWeight.Bold)
          .fontColor(this.getEmotionById(this.currentResult!.emotion)?.color || CommonStyles.TEXT_PRIMARY)

        Text(this.getEmotionById(this.currentResult!.emotion)?.description || '')
          .fontSize(14).fontColor(CommonStyles.TEXT_SECONDARY)
          .textAlign(TextAlign.Center)

        Row({ space: 12 }) {
          Column({ space: 4 }) {
            Text('置信度').fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
            Text(`${this.currentResult.confidence}%`)
              .fontSize(22).fontWeight(FontWeight.Bold).fontColor(this.getEmotionById(this.currentResult!.emotion)?.color || CommonStyles.PRIMARY)
          }
          .padding(14)
          .backgroundColor('#FFFFFF')
          .borderRadius(CommonStyles.RADIUS_LG)
          .shadow(CommonStyles.SHADOW_SM)

          Column({ space: 4 }) {
            Text('宠物名称').fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
            Text(this.currentResult.petName)
              .fontSize(18).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
          }
          .padding(14)
          .backgroundColor('#FFFFFF')
          .borderRadius(CommonStyles.RADIUS_LG)
          .shadow(CommonStyles.SHADOW_SM)
        }

        if (this.currentResult.suggestions.length > 0) {
          Column({ space: 12 }) {
            Text('个性化建议')
              .fontSize(15).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)

            ForEach(this.currentResult.suggestions, (suggestion: string) => {
              Row({ space: 10 }) {
                Text('💡').fontSize(16)
                Text(suggestion).fontSize(13).fontColor(CommonStyles.TEXT_SECONDARY)
                  .layoutWeight(1)
              }
              .width('100%').padding(12)
              .backgroundColor('#FFFFFF')
              .borderRadius(CommonStyles.RADIUS_MD)
            })
          }
          .width('100%').padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(CommonStyles.RADIUS_LG)
          .shadow(CommonStyles.SM)
        }

        Row({ space: 12 }) {
          Button('保存到记录', { type: ButtonType.Capsule })
            .layoutWeight(1).height(42).fontSize(14)
            .fontColor(CommonStyles.PRIMARY)
            .backgroundColor(CommonStyles.PRIMARY + '15')
            .borderRadius(CommonStyles.RADIUS_FULL)
            .onClick(() => this.saveResult())

          Button('重新识别', { type: ButtonType.Capsule })
            .layoutWeight(1).height(42).fontSize(14)
            .fontColor('#FFFFFF')
            .backgroundColor(CommonStyles.PRIMARY)
            .borderRadius(CommonStyles.RADIUS_FULL)
            .onClick(() => this.startAnalysis())
        }

        Button('返回首页', { type: ButtonType.Capsule })
          .width('100%').height(38).fontSize(13)
          .fontColor(CommonStyles.TEXT_TERTIARY)
          .backgroundColor('transparent')
          .borderWidth(1).borderColor('#E5E7EB')
          .borderRadius(CommonStyles.RADIUS_FULL)
          .margin({ top: 4 })
          .onClick(() => { this.currentStep = 0; this.currentResult = null; })
      }
    }
  }

  // ========== 历史记录页面 ==========
  @Builder
  HistoryView() {
    Column({ space: 16 }) {
      Row() {
        Text('识别历史')
          .fontSize(18).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text(`${this.history.length}条`)
          .fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
      }

      ForEach(this.history, (record: EmotionResult) => {
        Row({ space: 12 }) {
          Stack({ alignContent: Alignment.Center }) {
            Circle().width(48).height(48).fill(this.getEmotionById(record.emotion)?.color + '20' || '#F1F5F9')
            Text(record.emoji).fontSize(24)
          }

          Column({ space: 4 }) {
            Row() {
              Text(record.petName)
                .fontSize(15).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
              Blank()
              Text(`${record.confidence}%`)
                .fontSize(13).fontWeight(FontWeight.Bold).fontColor(this.getEmotionById(record.emotion)?.color || CommonStyles.TEXT_PRIMARY)
            }.width('100%')

            Text(this.getEmotionById(record.emotion)?.name || record.emotion)
              .fontSize(13).fontColor(CommonStyles.TEXT_SECONDARY)

            Text(record.timestamp)
              .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Start)
        }
        .width('100%').padding(14)
        .backgroundColor('#FFFFFF')
        .borderRadius(CommonStyles.RADIUS_LG)
        .shadow(CommonStyles.SHADOW_SM)
      })

      Button('返回首页', { type: ButtonType.Capsule })
        .width('100%').height(42).fontSize(14)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .backgroundColor('#F1F5F9')
        .borderRadius(CommonStyles.RADIUS_FULL)
        .margin({ top: 12 })
        .onClick(() => { this.showHistory = false; })
    }
  }

  // ========== 核心逻辑 ==========

  private startAnalysis(): void {
    this.currentStep = 1;
    this.isAnalyzing = true;
    this.analysisProgress = 0;
    this.selectedPetName = ['小橘', '豆豆', '毛球', '团子'][Math.floor(Math.random() * 4)];

    const stages: string[] = [
      '正在提取特征...',
      '分析表情细节...',
      '解读肢体语言...',
      '综合评估中...',
      '生成报告...'
    ];

    let stageIndex: number = 0;

    const interval = setInterval(() => {
      this.analysisProgress += Math.random() * 12 + 3;

      if (this.analysisProgress >= 100) {
        this.analysisProgress = 100;
        clearInterval(interval);

        setTimeout(() => {
          this.generateResult();
          this.isAnalyzing = false;
          this.currentStep = 2;
        }, 500);
      }
    }, 250);
  }

  private generateResult(): void {
    const randomEmotion: EmotionType = this.emotions[Math.floor(Math.random() * this.emotions.length)];
    const confidence: number = Math.floor(Math.random() * 15) + 82;

    let suggestions: string[] = [];

    switch (randomEmotion.id) {
      case 'happy':
        suggestions = ['继续保持当前的互动方式', '可以引入新玩具增加趣味性', '情绪极佳，是训练的好时机'];
        break;
      case 'relaxed':
        suggestions = ['适合安静地陪伴在身边', '轻柔的抚摸会让它更放松', '避免突然的大声响惊吓'];
        break;
      case 'curious':
        suggestions = ['可以陪TA探索新环境', '新玩具或零食能激发更多兴趣', '好奇心强时学习能力也强'];
        break;
      case 'anxious':
        suggestions = ['用温和的语调安抚它', '提供一个安静安全的空间', '避免过多刺激，给些时间适应'];
        break;
      case 'sad':
        suggestions = ['多花时间陪伴和互动', '喜欢的零食能改善心情', '检查是否有身体不适的可能'];
        break;
      case 'angry':
        suggestions = ['保持距离，不要强行接触', '等TA冷静后再慢慢接近', '找出引起不安的原因并排除'];
        break;
      case 'sleepy':
        suggestions = ['让它安静休息', '准备一个舒适的睡觉地方', '醒来后可以适度活动'];
        break;
      case 'excited':
        suggestions = ['适合进行游戏和训练', '消耗多余精力有助于稳定情绪', '注意安全，避免过于激烈'];
        break;
      default:
        suggestions = ['继续观察宠物状态', '保持良好的互动习惯'];
        break;
    }

    this.currentResult = {
      id: Date.now().toString(),
      petName: this.selectedPetName,
      emotion: randomEmotion.id,
      emoji: randomEmotion.emoji,
      confidence,
      timestamp: new Date().toLocaleString(),
      suggestions
    };
  }

  private saveResult(): void {
    if (this.currentResult) {
      this.history.unshift(this.currentResult);
      promptAction.showToast({ message: '已保存到识别记录' });
    }
  }

  private getEmotionById(id: string): EmotionType | undefined {
    return this.emotions.find((e: EmotionType) => e.id === id);
  }
}
