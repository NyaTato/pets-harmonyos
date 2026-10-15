import { CommonStyles } from '../common/css/CommonStyles';
import { RouterHelper } from '../router/RouterHelper';
import { Pet, petList } from '../mock/PetData';
import { AppStore } from '../store/AppStore';
import { promptAction } from '@kit.ArkUI';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

interface CardTemplate {
  id: string;
  name: string;
  preview: string;
  bgGradient: string[];
  accentColor: string;
}

interface GeneratedCard {
  pet: Pet;
  template: CardTemplate;
  timestamp: string;
}

@Entry
@Component
struct ShareCardGenerator {
  @State private step: number = 1; // 1=选择宠物, 2=选择模板, 3=预览
  @State private selectedPet: Pet | null = null;
  @State private selectedTemplate: CardTemplate | null = null;
  @State private pets: Pet[] = [];
  @State private savedCards: GeneratedCard[] = [];

  private templates: CardTemplate[] = [
    { id: 'warm', name: '温暖治愈', preview: '❤️', bgGradient: ['#FFE4E6', '#FFF0F3'], accentColor: '#F43F5E' },
    { id: 'fresh', name: '清新自然', preview: '🌿', bgGradient: ['#D1FAE5', '#ECFDF5'], accentColor: '#10B981' },
    { id: 'elegant', name: '优雅高级', preview: '✨', bgGradient: ['#EDE9FE', '#F5F3FF'], accentColor: '#8B5CF6' },
    { id: 'ocean', name: '海洋清新', preview: '🌊', bgGradient: ['#DBEAFE', '#EFF6FF'], accentColor: '#3B82F6' }
  ];

  aboutToAppear(): void {
    this.pets = petList.filter((p: Pet) => p.adoptionStatus === 'available').slice(0, 8);
  }

  build() {
    Column() {
      SafeArea({ edges: ['top'] }) {
        // 导航栏
        Row() {
          BackButton()
          Text('🎴 分享卡片生成器')
            .fontSize(18).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
            .layoutWeight(1)
          if (this.step > 1) {
            Text('上一步')
              .fontSize(14).fontColor(CommonStyles.PRIMARY)
              .onClick(() => { this.step--; })
          }
        }
        .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })
        .backgroundColor('#FFFFFF')

        // 步骤指示器
        Row({ space: 0 }) {
          this.StepIndicator(1, '选择宠物')
          this.StepLine(this.step > 1)
          this.StepIndicator(2, '选择模板')
          this.StepLine(this.step > 2)
          this.StepIndicator(3, '预览卡片')
        }
        .width('100%').padding({ left: 24, right: 24, bottom: 16 })
        .justifyContent(FlexAlign.Center)

        Scroll() {
          Column({ space: 20 }) {
            if (this.step === 1) {
              this.PetSelectionStep()
            } else if (this.step === 2) {
              this.TemplateSelectionStep()
            } else {
              this.PreviewStep()
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

  @Builder
  StepIndicator(num: number, label: string) {
    Column({ space: 4 }) {
      Stack({ alignContent: Alignment.Center }) {
        Circle()
          .width(24).height(24)
          .fill(this.step >= num ? CommonStyles.PRIMARY : '#D1D5DB')

        Text(`${num}`)
          .fontSize(11).fontColor(this.step >= num ? '#FFFFFF' : '#9CA3AF')
          .fontWeight(FontWeight.Bold)
      }

      Text(label)
        .fontSize(10).fontColor(this.step >= num ? CommonStyles.PRIMARY : '#9CA3AF')
    }
  }

  @Builder
  StepLine(active: boolean) {
    Column()
      .width(30).height(2)
      .backgroundColor(active ? CommonStyles.PRIMARY : '#D1D5DB')
      .margin({ top: 10 })
  }

  // ========== 步骤1: 选择宠物 ==========
  @Builder
  PetSelectionStep() {
    Column({ space: 14 }) {
      Text('选择要分享的宠物')
        .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)

      Text('为您心爱的宠物生成精美分享卡片，让TA找到温暖的家')
        .fontSize(13).fontColor(CommonStyles.TEXT_SECONDARY)

      if (this.pets.length > 0) {
        Scroll() {
          Row({ space: 12 }) {
            ForEach(this.pets, (pet: Pet) => {
              this.PetCardItem(pet)
            })
          }
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .width('100%')

        Button('下一步: 选择模板', { type: ButtonType.Capsule })
          .width('100%').height(44).fontSize(15)
          .fontColor('#FFFFFF').fontWeight(FontWeight.Medium)
          .backgroundColor(this.selectedPet ? CommonStyles.PRIMARY : '#D1D5DB')
          .borderRadius(CommonStyles.RADIUS_FULL)
          .enabled(this.selectedPet !== null)
          .margin({ top: 16 })
          .onClick(() => {
            if (this.selectedPet) {
              this.step = 2;
            } else {
              promptAction.showToast({ message: '请先选择一只宠物' });
            }
          })
      } else {
        this.EmptyState('🐾', '暂无可分享的宠物', '当前列表中没有可用的宠物')
      }
    }
  }

  // ========== 步骤2: 选择模板 ==========
  @Builder
  TemplateSelectionStep() {
    Column({ space: 14 }) {
      Row() {
        Text('选择卡片模板')
          .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text(`已选: ${this.selectedPet?.name || ''}`)
          .fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
      }

      Grid() {
        ForEach(this.templates, (tpl: CardTemplate) => {
          GridItem() {
            Column({ space: 10 }) {
              Stack({ alignContent: Alignment.Center }) {
                Column()
                  .width('100%').height(100)
                  .linearGradient({
                    angle: 135,
                    colors: [[tpl.bgGradient[0], 0], [tpl.bgGradient[1], 1]]
                  })
                  .borderRadius(CommonStyles.RADIUS_MD)

                Text(tpl.preview).fontSize(32)
              }

              Text(tpl.name)
                .fontSize(13).fontWeight(FontWeight.Medium)
                .fontColor(CommonStyles.TEXT_PRIMARY)

              if (this.selectedTemplate?.id === tpl.id) {
                Row() {
                  Blank()
                  Circle().width(18).height(18).fill(CommonStyles.SUCCESS)
                }
                .width('100%')
              }
            }
            .padding(12)
            .backgroundColor('#FFFFFF')
            .borderRadius(CommonStyles.RADIUS_MD)
            .border({
              width: this.selectedTemplate?.id === tpl.id ? 2 : 0,
              color: this.selectedTemplate?.id === tpl.id ? CommonStyles.PRIMARY : '#FFFFFF',
              radius: CommonStyles.RADIUS_MD
            })
            .shadow(this.selectedTemplate?.id === tpl.id ? CommonStyles.SHADOW_BRAND_OLD : CommonStyles.SHADOW_SM)
            .onClick(() => { this.selectedTemplate = tpl; })
          }
        })
      }
      .columnsTemplate('1fr 1fr')
      .rowsGap(14).columnsGap(14)

      Row({ space: 12 }) {
        Button('返回修改', { type: ButtonType.Capsule })
          .layoutWeight(1).height(42).fontSize(14)
          .fontColor(CommonStyles.TEXT_SECONDARY)
          .backgroundColor('#F1F5F9').borderRadius(CommonStyles.RADIUS_FULL)
          .onClick(() => { this.step = 1; })

        Button('生成卡片', { type: ButtonType.Capsule })
          .layoutWeight(1).height(42).fontSize(14)
          .fontColor('#FFFFFF').fontWeight(FontWeight.Medium)
          .backgroundColor(this.selectedTemplate ? CommonStyles.SUCCESS : '#D1D5DB')
          .borderRadius(CommonStyles.RADIUS_FULL)
          .enabled(this.selectedTemplate !== null)
          .onClick(() => {
            if (this.selectedTemplate) {
              this.step = 3;
            } else {
              promptAction.showToast({ message: '请先选择一个模板' });
            }
          })
      }.width('100%').margin({ top: 12 })
    }
  }

  // ========== 步骤3: 预览和保存 ==========
  @Builder
  PreviewStep() {
    Column({ space: 20 }) {
      Text('卡片预览')
        .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)

      if (this.selectedPet && this.selectedTemplate) {
        // 生成的卡片预览
        Stack({ alignContent: Alignment.Bottom }) {
          Column()
            .width('100%').height(380)
            .linearGradient({
              angle: 135,
              colors: [[this.selectedTemplate.bgGradient[0], 0], [this.selectedTemplate.bgGradient[1], 1]]
            })
            .borderRadius(CommonStyles.RADIUS_LG)
            .shadow(CommonStyles.SHADOW_XL)
            .justifyContent(FlexAlign.Start).alignItems(HorizontalAlign.Start)
            .padding(24)

          Column({ space: 16 }) {
            Text('寻找温暖的家')
              .fontSize(20).fontWeight(FontWeight.Bold)
              .fontColor(this.selectedTemplate.accentColor)

            Divider().color(this.selectedTemplate.accentColor + '30')

            // 宠物信息区
            Row({ space: 14 }) {
              Image(this.selectedPet.images && this.selectedPet.images.length > 0 ? $rawfile(this.selectedPet.images[0]) : '')
                .width(90).height(90).objectFit(ImageFit.Cover)
                .borderRadius(CommonStyles.RADIUS_MD)

              Column({ space: 6 }) {
                Text(this.selectedPet.name)
                  .fontSize(22).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)

                Text(`${this.selectedPet.breed} · ${this.selectedPet.age}岁`)
                  .fontSize(14).fontColor(CommonStyles.TEXT_SECONDARY)

                Row({ space: 6 }) {
                  Text(this.selectedPet.gender === 'male' ? '♂ 公' : '♀ 母')
                    .fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
                  Text('·').fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
                  Text(this.selectedPet.location || '')
                    .fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
                }
              }
              .layoutWeight(1).alignItems(HorizontalAlign.Start)
            }
            .width('100%')

            // 状态标签
            Row({ space: 8 }) {
              if (this.selectedPet.adoptionStatus === 'available') {
                Text('可领养')
                  .fontSize(11).fontColor('#FFFFFF').fontWeight(FontWeight.Medium)
                  .padding({ left: 10, right: 10, top: 5, bottom: 5 })
                  .backgroundColor(CommonStyles.SUCCESS)
                  .borderRadius(CommonStyles.RADIUS_FULL)
              }
              Text(`❤️ ${this.selectedPet.likes} 喜欢`)
                .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
                .padding({ left: 10, right: 10, top: 5, bottom: 5 })
                .backgroundColor('#F1F5F9')
                .borderRadius(CommonStyles.RADIUS_FULL)
            }

            Blank()

            // 底部品牌信息
            Row() {
              Text('爱宠领')
                .fontSize(18).fontWeight(FontWeight.Bold)
                .fontColor(CommonStyles.PRIMARY)
              Blank()
              Text('扫码了解更多')
                .fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
            }
            .width('100%')
            .padding({ top: 12 })
            .border({ width: { top: 1 }, color: '#E5E7EB' })
          }
        }

        // 操作按钮
        Column({ space: 12 }) {
          Button('保存到相册', { type: ButtonType.Capsule })
            .width('100%').height(46).fontSize(15)
            .fontColor('#FFFFFF').fontWeight(FontWeight.Medium)
            .backgroundColor(CommonStyles.PRIMARY)
            .borderRadius(CommonStyles.RADIUS_FULL)
            .onClick(() => {
              const card: GeneratedCard = {
                pet: this.selectedPet!,
                template: this.selectedTemplate!,
                timestamp: new Date().toISOString()
              };
              this.savedCards.push(card);
              promptAction.showToast({ message: '卡片已保存到相册' });
            })

          Row({ space: 12 }) {
            Button('重新开始', { type: ButtonType.Capsule })
              .layoutWeight(1).height(42).fontSize(14)
              .fontColor(CommonStyles.TEXT_SECONDARY)
              .backgroundColor('#F1F5F9').borderRadius(CommonStyles.RADIUS_FULL)
              .onClick(() => { this.step = 1; this.selectedPet = null; this.selectedTemplate = null; })

            Button('分享给朋友', { type: ButtonType.Capsule })
              .layoutWeight(1).height(42).fontSize(14)
              .fontColor('#FFFFFF')
              .backgroundColor(this.selectedTemplate.accentColor)
              .borderRadius(CommonStyles.RADIUS_FULL)
              .onClick(() => {
                promptAction.showToast({ message: '已复制分享链接' });
              })
          }
        }

        // 已保存的卡片统计
        if (this.savedCards.length > 0) {
          Text(`已生成 ${this.savedCards.length} 张卡片`)
            .fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
            .textAlign(TextAlign.Center).width('100%')
            .margin({ top: 8 })
        }
      }
    }
  }

  @Builder
  PetCardItem(pet: Pet) {
    Column({ space: 8 }) {
      Stack({ alignContent: Alignment.Bottom }) {
        Image(pet.images && pet.images.length > 0 ? $rawfile(pet.images[0]) : '')
          .width('100%').height(130).objectFit(ImageFit.Cover)
          .borderRadius({ topLeft: CommonStyles.RADIUS_MD, topRight: CommonStyles.RADIUS_MD })
        Column().width('100%').height(40)
          .linearGradient({ angle: 180, colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0.4)', 1]] })
          .borderRadius({ bottomLeft: CommonStyles.RADIUS_MD, bottomRight: CommonStyles.RADIUS_MD })
      }

      Row() {
        Text(pet.name).fontSize(13).fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY).maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis }).layoutWeight(1)
        Text(pet.breed).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
      }.width('100%')
    }
    .padding({ left: 10, right: 10, bottom: 8 })
    .backgroundColor('#FFFFFF'
      + (this.selectedPet?.id === pet.id ? '' : ''))
    .borderRadius(CommonStyles.RADIUS_MD)
    .border({
      width: this.selectedPet?.id === pet.id ? 2 : 0,
      color: CommonStyles.PRIMARY,
      radius: CommonStyles.RADIUS_MD
    })
    .shadow(this.selectedPet?.id === pet.id ? CommonStyles.SHADOW_BRAND_OLD : CommonStyles.SHADOW_SM)
    .onClick(() => {
      this.selectedPet = pet;
    })
    .width(160)
  }

  @Builder
  EmptyState(icon: string, title: string, desc: string) {
    Column({ space: 14 }) {
      Text(icon).fontSize(40).fontColor(CommonStyles.TEXT_TERTIARY)
      Text(title).fontSize(16).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
      Text(desc).fontSize(13).fontColor(CommonStyles.TEXT_TERTIARY)
    }
    .width('100%').padding(40)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
    .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
    .margin({ top: 24 })
  }
}
