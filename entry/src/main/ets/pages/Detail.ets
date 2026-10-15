﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿import { RouterHelper, RouteParams } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { getPetById, getPetsByType, Pet } from '../mock/PetData';
import { AppStore } from '../store/AppStore';
import { hasFavoritedPet, addFavoriteRecord } from '../mock/InteractionData';
import promptAction from '@ohos.promptAction';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

@Entry
@Component
export struct Detail {
  @State private pet: Pet | null = null;
  @State private isLoading: boolean = true;
  @State private isFavorite: boolean = false;
  @State private currentImageIndex: number = 0;
  @State private showImageGallery: boolean = false;
  @State private similarPets: Pet[] = [];
  @State private showContactDialog: boolean = false;

  aboutToAppear(): void {
    this.loadPetDetail();
  }

  // 从收藏页返回等场景重新显示时，重新查询收藏状态
  onPageShow(): void {
    this.syncFavoriteState();
  }

  private loadPetDetail(): void {
    this.isLoading = true;

    const params: RouteParams = RouterHelper.getParams() as RouteParams;
    const petId = params?.petId || '1';

    setTimeout(() => {
      this.pet = getPetById(parseInt(petId));
      this.isLoading = false;

      if (this.pet) {
        // 收藏状态以互动记录为准
        this.syncFavoriteState();
        // 加载相似宠物
        this.loadSimilarPets();
      }
    }, 300);
  }

  // 当前宠物 ID（宠物未加载完成时回退到路由参数）
  private getCurrentPetId(): number {
    if (this.pet) {
      return this.pet.id;
    }
    const params: RouteParams = RouterHelper.getParams() as RouteParams;
    return parseInt(params?.petId || '1');
  }

  // 根据互动记录同步收藏状态
  private syncFavoriteState(): void {
    const currentUser = AppStore.getInstance().getState().currentUser;
    if (!currentUser) {
      this.isFavorite = false;
      return;
    }
    this.isFavorite = hasFavoritedPet(currentUser.id, this.getCurrentPetId());
  }

  private loadSimilarPets(): void {
    if (this.pet && this.pet.type) {
      const allPets = getPetsByType(this.pet.type);
      // 过滤掉当前宠物，取前3只相似的
      this.similarPets = allPets
        .filter((p: Pet) => p.id !== this.pet?.id)
        .slice(0, 3);
    }
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top', 'bottom']
      }) {
        if (this.isLoading) {
          this.LoadingState()
        } else if (!this.pet) {
          this.ErrorState()
        } else if (this.showImageGallery) {
          this.ImageGalleryView()
        } else {
          this.MainContent()
        }
      }

      // 联系人对话框
      if (this.showContactDialog) {
        this.ContactDialog()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(CommonStyles.BG_SECONDARY)
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

      Text('正在加载宠物信息...')
        .fontSize(15)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .margin({ top: 16 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // ========== Error State ==========
  @Builder
  ErrorState() {
    Column({ space: 24 }) {
      Text('😢')
        .fontSize(80)

      Text('宠物信息不存在')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)

      Text('该宠物可能已被领养或下架')
        .fontSize(15)
        .fontColor(CommonStyles.TEXT_SECONDARY)

      Button('返回列表', { type: ButtonType.Capsule })
        .margin({ top: 24 })
        .height(44)
        .padding({ left: 32, right: 32 })
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.WHITE)
        .backgroundColor(CommonStyles.PRIMARY)
        .borderRadius(CommonStyles.RADIUS_FULL)
        .onClick(() => {
          RouterHelper.back();
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // ========== Image Gallery View ==========
  @Builder
  ImageGalleryView() {
    Stack({ alignContent: Alignment.Top }) {
      // 大图显示
      Image(this.pet?.images?.[this.currentImageIndex] ? $rawfile(this.pet.images[this.currentImageIndex]) : '')
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
        .backgroundColor('#000000')

      // 顶部操作栏
      Row() {
        Text('✕')
          .fontSize(28)
          .fontColor('#FFFFFF')
          .padding(12)
          .onClick(() => {
            this.showImageGallery = false;
          })

        Blank()

        Text(`${this.currentImageIndex + 1} / ${this.pet?.images?.length || 1}`)
          .fontSize(16)
          .fontColor('#FFFFFF')

        Blank()

        Text('')
          .width(40)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 40 })

      // 底部缩略图指示器
      if ((this.pet?.images?.length || 0) > 1) {
        Row({ space: 8 }) {
          ForEach(this.pet?.images || [], (image: string, index: number) => {
            Image($rawfile(image))
              .width(index === this.currentImageIndex ? 60 : 40)
              .height(60)
              .objectFit(ImageFit.Cover)
              .borderRadius(8)
              .border({
                width: index === this.currentImageIndex ? 2 : 0,
                color: '#FFFFFF'
              })
              .opacity(index === this.currentImageIndex ? 1 : 0.6)
              .onClick(() => {
                this.currentImageIndex = index;
              })
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding(16)
        .position({ bottom: 0 })
        .backgroundColor('rgba(0,0,0,0.5)')
      }

      // 左右切换按钮
      if (this.currentImageIndex > 0) {
        Column() {
          Text('‹')
            .fontSize(48)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
        }
        .width(50)
        .height(100)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .position({ x: 8, y: '50%' })
        .translate({ y: -50 })
        .backgroundColor('rgba(0,0,0,0.3)')
        .borderRadius(25)
        .onClick(() => {
          this.currentImageIndex--;
        })
      }

      if (this.currentImageIndex < (this.pet?.images?.length || 1) - 1) {
        Column() {
          Text('›')
            .fontSize(48)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
        }
        .width(50)
        .height(100)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .position({ x: '100%', y: '50%' })
        .translate({ x: -58, y: -50 })
        .backgroundColor('rgba(0,0,0,0.3)')
        .borderRadius(25)
        .onClick(() => {
          this.currentImageIndex++;
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
  }

  // ========== Main Content ==========
  @Builder
  MainContent() {
    Scroll() {
      Column({ space: 24 }) {

        // ===== 1. 图片轮播区域（可点击放大）=====
        this.ImageCarousel()

        // ===== 2. 基本信息 =====
        this.BasicInfoSection()

        // ===== 3. 详细描述 =====
        this.DescriptionSection()

        // ===== 4. 基本属性网格 =====
        this.AttributesSection()

        // ===== 5. 性格与特点（新增）=====
        this.PersonalitySection()

        // ===== 6. 健康状况（新增）=====
        this.HealthSection()

        // ===== 7. 领养要求（新增）=====
        this.RequirementsSection()

        // ===== 8. 相似宠物推荐（新增）=====
        if (this.similarPets.length > 0) {
          this.SimilarPetsSection()
        }

        // ===== 9. 操作按钮区 =====
        this.ActionButtons()

      }
      .width('100%')
      .padding({ left: CommonStyles.LG, right: CommonStyles.LG, bottom: 32 })
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .layoutWeight(1)
    .backgroundColor(CommonStyles.BG_SECONDARY)
  }

  // ========== Image Carousel ==========
  @Builder
  ImageCarousel() {
    Stack({ alignContent: Alignment.Bottom }) {
      // 主图（可点击）
      Image(this.pet?.images?.[0] ? $rawfile(this.pet.images[0]) : '')
        .width('100%')
        .height(360)
        .objectFit(ImageFit.Cover)
        .onClick(() => {
          this.showImageGallery = true;
          this.currentImageIndex = 0;
        })

      // 渐变遮罩
      Column()
        .width('100%')
        .height(140)
        .linearGradient({
          angle: 180,
          colors: [['rgba(0,0,0,0)', 0.0], ['rgba(0,0,0,0.6)', 1.0]]
        })

      // 返回按钮
      BackButton({
        color: '#FFFFFF',
        iconSize: 26,
        bgColor: 'rgba(0,0,0,0.3)'
      })
        .position({ x: 16, y: 50 })

      // 收藏按钮
      Text(this.isFavorite ? '♥' : '♡')
        .fontSize(30)
        .fontColor(this.isFavorite ? CommonStyles.DANGER : '#FFFFFF')
        .padding(12)
        .backgroundColor('rgba(255,255,255,0.25)')
        .borderRadius(CommonStyles.RADIUS_FULL)
        .position({ x: '85%', y: 50 })
        .onClick(() => {
          this.toggleFavorite();
        })

      // 图片数量提示
      if ((this.pet?.images?.length || 0) > 1) {
        Row({ space: 6 }) {
          Text('📷')
            .fontSize(14)

          Text(`${this.pet?.images?.length || 1} 张照片`)
            .fontSize(13)
            .fontColor('#FFFFFF')
        }
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .backgroundColor('rgba(0,0,0,0.4)')
        .borderRadius(CommonStyles.RADIUS_FULL)
        .position({ right: 16, y: 280 })
      }

      // 点击查看提示
      Row({ space: 6 }) {
        Text('🔍')
          .fontSize(14)

        Text('点击查看大图')
          .fontSize(13)
          .fontColor('#FFFFFF80')
      }
      .position({ left: 16, bottom: 20 })
    }
    .width('100%')
  }

  // ========== Basic Info Section ==========
  @Builder
  BasicInfoSection() {
    Column({ space: 18 }) {
      // 名称行
      Row() {
        Text(this.pet?.name || '小可爱')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .layoutWeight(1)

        Text(this.pet?.gender === 'male' ? '♂️' : '♀️')
          .fontSize(28)
      }
      .width('100%')

      // 标签行：品种·年龄·位置
      Row({ space: 12 }) {
        this.InfoTag('🏷️', this.pet?.breed || '混血')
        this.InfoTag('📅', `${this.pet?.age}岁`)
        this.InfoTag('📍', this.pet?.location?.split(',')[0] || '')
      }
      .width('100%')

      // 状态标签行
      Row() {
        if (this.pet?.adoptionStatus === 'available') {
          this.StatusBadge('✅ 可领养', CommonStyles.SUCCESS, CommonStyles.SUCCESS_LIGHT)
        }

        Blank()

        this.StatusBadge(`👀 ${this.pet?.views || 999} 次浏览`, CommonStyles.INFO, CommonStyles.INFO_LIGHT)
        this.StatusBadge(`♥ ${this.pet?.likes || 128}`, CommonStyles.DANGER, CommonStyles.DANGER_LIGHT)
      }
      .width('100%')
    }
    .width('100%')
    .padding(22)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_LG)
    .margin({ top: -50 })
  }

  // ========== Description Section ==========
  @Builder
  DescriptionSection() {
    Column({ space: 14 }) {
      Text('关于我 📝')
        .fontSize(19)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      Text(this.pet?.description || '这是一只非常可爱的宠物，性格温顺，喜欢和人互动。它能很快适应新环境，对小朋友和其他宠物都很友好。希望能找到一个温暖的家，给它无尽的爱和关怀。')
        .fontSize(15)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .lineHeight(23)
        .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  // ========== Attributes Section ==========
  @Builder
  AttributesSection() {
    Column({ space: 16 }) {
      Text('基本信息 📋')
        .fontSize(19)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      Grid() {
        this.InfoGridItem('品种', this.pet?.breed || '-')
        this.InfoGridItem('年龄', `${this.pet?.age}岁`)
        this.InfoGridItem('性别', this.pet?.gender === 'male' ? '公' : '母')
        this.InfoGridItem('体重', `${this.pet?.weight || '-'}kg`)
        this.InfoGridItem('颜色', this.pet?.color || '-')
        this.InfoGridItem('绝育', this.pet?.isSterilized ? '是' : '否')
      }
      .columnsTemplate('1fr 1fr')
      .rowsGap(14)
      .columnsGap(14)
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  // ========== Personality Section (NEW) ==========
  @Builder
  PersonalitySection() {
    Column({ space: 16 }) {
      Text('性格特点 🌟')
        .fontSize(19)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      // 性格标签
      Flex({ wrap: FlexWrap.Wrap }) {
        this.PersonalityTag('😊 温顺亲人')
        this.PersonalityTag('🎾 活泼好动')
        this.PersonalityTag('🧘‍♂️ 安静独立')
        this.PersonalityTag('💪 健康强壮')
        this.PersonalityTag('🧠 聪明伶俐')
        this.PersonalityTag('❤️ 粘人撒娇')
      }
      .width('100%')

      Divider().color(CommonStyles.BORDER_LIGHT).margin({ top: 8, bottom: 8 })

      // 性格描述
      Text(`这只${this.pet?.type || '宠物'}性格非常温顺，喜欢和人亲近，对陌生人也十分友好。它精力充沛，喜欢玩耍，但也能安静地陪伴在主人身边。经过基本的训练，能够听懂简单的指令。适合有爱心、有耐心的家庭饲养。`)
        .fontSize(14)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .lineHeight(21)
        .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  // ========== Health Section (NEW) ==========
  @Builder
  HealthSection() {
    Column({ space: 16 }) {
      Text('健康状况 💊')
        .fontSize(19)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      // 健康状态标签
      Row({ space: 10 }) {
        this.HealthTag('✅ 已疫苗', true)
        this.HealthTag('✅ 已驱虫', true)
        this.HealthTag('⏳ 待体检', false)
      }
      .width('100%')

      Divider().color(CommonStyles.BORDER_LIGHT).margin({ top: 8, bottom: 8 })

      // 健康说明
      Text(this.pet?.healthStatus || '这只宠物身体健康，已完成基础的疫苗接种和驱虫工作。最近一次体检结果显示一切正常，无遗传疾病史。建议新主人定期带它进行健康检查，保持良好的饮食和运动习惯。')
        .fontSize(14)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .lineHeight(21)
        .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  // ========== Requirements Section (NEW) ==========
  @Builder
  RequirementsSection() {
    Column({ space: 16 }) {
      Text('领养要求 📋')
        .fontSize(19)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .width('100%')

      // 要求列表
      Column({ space: 12 }) {
        this.RequirementItem('🏠', '稳定的居住环境，房东允许养宠')
        this.RequirementItem('⏰', '每天有足够的时间陪伴和照顾')
        this.RequirementItem('💰', '有能力承担食物、医疗等基本费用')
        this.RequirementItem('❤️', '承诺不遗弃，善待宠物一生')
        this.RequirementItem('🏥', '定期带宠物进行疫苗接种和体检')
        this.RequirementItem('📞', '接受回访，配合了解宠物适应情况')
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  // ========== Similar Pets Section (NEW) ==========
  @Builder
  SimilarPetsSection() {
    Column({ space: 18 }) {
      // 标题行
      Row() {
        Text('相似宠物推荐 🐾')
          .fontSize(19)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Blank()

        Text('查看更多 →')
          .fontSize(15)
          .fontColor(CommonStyles.PRIMARY)
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            RouterHelper.navigateToPetList();
          })
      }
      .width('100%')

      // 宠物卡片列表（简化版）
      Scroll() {
        Row({ space: 14 }) {
          ForEach(this.similarPets, (pet: Pet) => {
            this.SimilarPetCard(pet)
          })
        }
        .padding({ top: 4, bottom: 4 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_XL)
    .shadow(CommonStyles.SHADOW_MD)
  }

  // ========== Action Buttons ==========
  @Builder
  ActionButtons() {
    Column({ space: 16 }) {
      // 主要CTA按钮 - 统一样式
      Button('立即申请领养', { type: ButtonType.Capsule, stateEffect: true })
        .width('100%')
        .height(CommonStyles.BUTTON_HEIGHT_XL)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.WHITE)
        .backgroundColor(CommonStyles.PRIMARY)
        .borderRadius(CommonStyles.RADIUS_FULL)
        .shadow(CommonStyles.SHADOW_BRAND_OLD)
        .onClick(() => {
          const params: RouteParams = { petId: this.pet?.id.toString() };
          RouterHelper.pushUrl("pages/Apply", params);
        })

      // 次要操作按钮组
      Row({ space: 12 }) {
        this.ActionButton('联系救助人', () => {
          this.showContactDialog = true;
        })

        this.ActionButton('↗ 分享给好友', () => {
          promptAction.showToast({
            message: `已复制"${this.pet?.name}"的分享链接`,
            duration: 2000
          });
        })

        this.ActionButton('❓ 常见问题', () => {
          RouterHelper.pushUrl("pages/Notice");
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(20)
    .padding({ bottom: 32 })
  }

  // ========== Reusable Builder Components ==========

  @Builder
  InfoTag(icon: string, text: string) {
    Row({ space: 6 }) {
      Text(icon)
        .fontSize(14)

      Text(text)
        .fontSize(14)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .fontWeight(FontWeight.Medium)
    }
    .padding({ left: 14, right: 14, top: 8, bottom: 8 })
    .backgroundColor(CommonStyles.BG_TERTIARY)
    .borderRadius(CommonStyles.RADIUS_FULL)
  }

  @Builder
  StatusBadge(text: string, textColor: string, bgColor: string) {
    Text(text)
      .fontSize(13)
      .fontColor(textColor)
      .fontWeight(FontWeight.Medium)
      .padding({ left: 14, right: 14, top: 7, bottom: 7 })
      .backgroundColor(bgColor)
      .borderRadius(CommonStyles.RADIUS_FULL)
  }

  @Builder
  InfoGridItem(label: string, value: string) {
    Column({ space: 6 }) {
      Text(label)
        .fontSize(13)
        .fontColor(CommonStyles.TEXT_TERTIARY)

      Text(value)
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
    }
    .padding(14)
    .backgroundColor(CommonStyles.BG_TERTIARY)
    .borderRadius(CommonStyles.RADIUS_MD)
  }

  @Builder
  PersonalityTag(text: string) {
    Text(text)
      .fontSize(13)
      .fontColor(CommonStyles.PRIMARY_DARK)
      .fontWeight(FontWeight.Medium)
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(CommonStyles.PRIMARY_LIGHT)
      .borderRadius(CommonStyles.RADIUS_FULL)
      .margin({ right: 8, bottom: 8 })
  }

  @Builder
  HealthTag(text: string, isCompleted: boolean) {
    Text(text)
      .fontSize(13)
      .fontColor(isCompleted ? CommonStyles.SUCCESS : CommonStyles.TEXT_TERTIARY)
      .fontWeight(FontWeight.Medium)
      .padding({ left: 14, right: 14, top: 7, bottom: 7 })
      .backgroundColor(isCompleted ? CommonStyles.SUCCESS_LIGHT : CommonStyles.GRAY_100)
      .borderRadius(CommonStyles.RADIUS_FULL)
  }

  @Builder
  ActionButton(text: string, onClick: () => void) {
    Button(text, { type: ButtonType.Normal })
      .layoutWeight(1)
      .height(46)
      .fontSize(14)
      .fontWeight(FontWeight.Medium)
      .fontColor(CommonStyles.PRIMARY_DARK)
      .backgroundColor(CommonStyles.PRIMARY_BG)
      .borderRadius(CommonStyles.RADIUS_MD)
      .onClick(onClick)
  }

  @Builder
  SimilarPetCard(pet: Pet) {
    Column({ space: 10 }) {
      // 图片
      Image(pet.images?.[0] ? $rawfile(pet.images[0]) : '')
        .width('100%')
        .height(140)
        .objectFit(ImageFit.Cover)
        .borderRadius({ topLeft: CommonStyles.RADIUS_LG, topRight: CommonStyles.RADIUS_LG })
        .onClick(() => {
          const params: RouteParams = { petId: pet.id.toString() };
          RouterHelper.replaceUrl("pages/Detail", params);
        })

      // 信息
      Column({ space: 6 }) {
        Text(pet.name || '小可爱')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Row({ space: 8 }) {
          Text(`${pet.age}岁`)
            .fontSize(13)
            .fontColor(CommonStyles.TEXT_TERTIARY)

          Text('·')
            .fontColor(CommonStyles.TEXT_TERTIARY)

          Text(pet.breed || '混血')
            .fontSize(13)
            .fontColor(CommonStyles.TEXT_TERTIARY)

          Blank()

          Text(pet.gender === 'male' ? '♂️' : '♀️')
            .fontSize(16)
        }
        .width('100%')
      }
      .padding({ left: 12, right: 12, bottom: 10 })
    }
    .width(200)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
  }

  // ========== RequirementItem Builder ==========
  @Builder
  RequirementItem(icon: string, text: string) {
    Row({ space: 10 }) {
      Text(icon)
        .fontSize(18)

      Text(text)
        .fontSize(14)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .layoutWeight(1)
    }
    .width('100%')
    .padding({ left: 4, right: 4, top: 6, bottom: 6 })
  }

  // ========== Contact Dialog ==========
  @Builder
  ContactDialog() {
    Column() {
      // 遮罩层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#00000080')
        .onClick(() => {
          this.showContactDialog = false;
        })

      // 对话框内容
      Column({ space: 20 }) {
        // 标题
        Text('联系救助人')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Divider()

        // 联系方式卡片
        Column({ space: 16 }) {
          this.ContactInfoItem('👤 救助人姓名', '宠缘志愿者团队')
          this.ContactInfoItem('📱 联系电话', '400-888-PETS (7300)')
          this.ContactInfoItem('📧 电子邮件', 'support@example.com')
          this.ContactInfoItem('📍 所在地区', this.pet?.location || '未知')
          this.ContactInfoItem('⏰ 服务时间', '9:00 - 21:00 (全年无休)')
        }
        .width('100%')
        .padding(20)
        .backgroundColor('#F9FAFB')
        .borderRadius(16)

        // 操作按钮
        Row({ space: 12 }) {
          Button('拨打电话', { type: ButtonType.Capsule })
            .layoutWeight(1)
            .height(44)
            .fontSize(15)
            .fontColor('#FFFFFF')
            .backgroundColor(CommonStyles.PRIMARY)
            .borderRadius(22)
            .onClick(() => {
              promptAction.showToast({
                message: '正在拨打救助电话...',
                duration: 2000
              });
              this.showContactDialog = false;
            })

          Button('发送消息', { type: ButtonType.Normal })
            .layoutWeight(1)
            .height(44)
            .fontSize(15)
            .fontColor(CommonStyles.PRIMARY)
            .backgroundColor('#E0F2FE')
            .borderRadius(22)
            .onClick(() => {
              RouterHelper.pushUrl("pages/Messages");
              this.showContactDialog = false;
            })
        }
        .width('100%')

        // 关闭按钮
        Button('关闭', { type: ButtonType.Normal })
          .width('100%')
          .height(40)
          .fontSize(14)
          .fontColor(CommonStyles.TEXT_TERTIARY)
          .backgroundColor('transparent')
          .onClick(() => {
            this.showContactDialog = false;
          })
      }
      .width('85%')
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(20)
      .shadow({ radius: 20, color: 'rgba(0,0,0,0.15)', offsetX: 0, offsetY: 8 })
      .position({ x: 0, y: '30%' })
    }
    .width('100%')
    .height('100%')
    .position({ x: 0, y: 0 })
  }

  @Builder
  ContactInfoItem(label: string, value: string) {
    Column({ space: 6 }) {
      Text(label)
        .fontSize(12)
        .fontColor(CommonStyles.TEXT_TERTIARY)

      Text(value)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
  }

  // ========== Action Methods ==========
  private toggleFavorite(): void {
    const currentUser = AppStore.getInstance().getState().currentUser;
    if (!currentUser) {
      RouterHelper.replaceUrl("pages/Login");
      return;
    }

    if (!this.pet) {
      return;
    }

    // 通过互动记录切换收藏，再按记录回读状态
    addFavoriteRecord(currentUser.id, this.pet.id);
    this.isFavorite = hasFavoritedPet(currentUser.id, this.pet.id);

    promptAction.showToast({
      message: this.isFavorite ? '已添加到收藏 ❤️' : '已取消收藏'
    });
  }
}