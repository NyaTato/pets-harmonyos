﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿import { CommonStyles } from '../common/css/CommonStyles';
import { RouterHelper } from '../router/RouterHelper';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';
import { petList, Pet } from '../mock/PetData';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct ARPreview {
  @State private selectedPet: Pet | null = null;
  @State private arMode: boolean = false;
  @State private zoomLevel: number = 1.0;
  @State private rotation: number = 0;
  @State private posX: number = 50;
  @State private posY: number = 40;
  @State private savedPhotos: number = 0;
  @State private showGrid: boolean = true;
  @State private pets: Pet[] = [];
  @State private showPetDetail: boolean = false;

  aboutToAppear(): void {
    this.pets = petList.filter((p: Pet) => p.adoptionStatus === 'available').slice(0, 6);
  }

  build() {
    Column() {
      SafeArea({ edges: ['top'] }) {
        Row() {
          BackButton()
          Text('图片预览（模拟演示）')
            .fontSize(18).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
            .layoutWeight(1)
          if (this.arMode) {
            Text('退出预览')
              .fontSize(14).fontColor('#EF4444').fontWeight(FontWeight.Medium)
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .backgroundColor('#FEF2F2')
              .borderRadius(CommonStyles.RADIUS_FULL)
              .onClick(() => { this.arMode = false; })
          }
        }
        .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })
        .backgroundColor('#FFFFFF')

        if (!this.arMode) {
          this.PetSelectionView()
        } else {
          this.ARCameraView()
        }
      }
    }
    .width('100%').height('100%')
    .padding({ top: '45mm' })
  }

  // ==================== 宠物选择视图 ====================
  @Builder
  PetSelectionView() {
    Scroll() {
      Column({ space: 20 }) {

        this.HeroSection()

        Column({ space: 14 }) {
          Row() {
            Text('选择要预览的宠物')
              .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
            Blank()
            Text(`${this.pets.length}只可预览`)
              .fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
              .backgroundColor('#F1F5F9')
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .borderRadius(CommonStyles.RADIUS_FULL)
          }.width('100%')

          ForEach(this.pets, (pet: Pet) => {
            this.PetSelectCard(pet)
          })
        }

        Button('进入图片互动演示', { type: ButtonType.Capsule })
          .width('100%').height(52).fontSize(17)
          .fontColor('#FFFFFF').fontWeight(FontWeight.Medium)
          .backgroundColor(this.selectedPet ? '#6366F1' : '#D1D5DB')
          .borderRadius(16)
          .shadow(this.selectedPet ? { color: 'rgba(99,102,241,0.35)', radius: 16, offsetX: 0, offsetY: 4 } : undefined)
          .enabled(this.selectedPet !== null)
          .margin({ top: 8 })
          .onClick(() => {
            if (this.selectedPet) {
              this.arMode = true;
              promptAction.showToast({ message: `已进入图片演示: ${this.selectedPet.name}；未使用相机` });
            } else {
              promptAction.showToast({ message: '请先选择一只宠物' });
            }
          })

        if (this.savedPhotos > 0) {
          Row({ space: 6 }) {
            Text('📸').fontSize(14)
            Text(`已模拟拍照 ${this.savedPhotos} 次（未保存文件）`)
              .fontSize(13).fontColor(CommonStyles.SUCCESS).fontWeight(FontWeight.Medium)
          }
          .padding({ left: 14, right: 14, top: 8, bottom: 8 })
          .backgroundColor('#ECFDF5')
          .borderRadius(CommonStyles.RADIUS_FULL)
          .margin({ top: 10 })
        }

        this.FeatureIntro()

      }
      .width('100%').padding({ left: 16, right: 16, bottom: 32 })
    }
    .scrollable(ScrollDirection.Vertical).scrollBar(BarState.Off)
    .layoutWeight(1).backgroundColor('#F8FAFC')
  }

  // ==================== Hero 区域 ====================
  @Builder
  HeroSection() {
    Column({ space: 12 }) {
      Stack({ alignContent: Alignment.Bottom }) {
        Column()
          .width(90).height(90)
          .borderRadius(50)
          .backgroundColor('rgba(99,102,241,0.08)')
        Text('📱').fontSize(48)
      }

      Text('图片互动预览')
        .fontSize(26).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)

      Text('本页使用本地图片模拟位置、缩放与旋转；没有接入相机或 AR 引擎')
        .fontSize(14).fontColor(CommonStyles.TEXT_SECONDARY)
        .textAlign(TextAlign.Center)
        .lineHeight(20)

      Row({ space: 16 }) {
        this.StatBadge('🖼️', '演示素材', '本地图片')
        this.StatBadge('↔️', '交互方式', '手动调整')
        this.StatBadge('📱', '设备能力', '未接入')
      }
    }
    .width('100%').padding({ top: 20, bottom: 16, left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .shadow({ color: 'rgba(99,102,241,0.10)', radius: 20, offsetX: 0, offsetY: 4 })
  }

  @Builder
  StatBadge(icon: string, label: string, value: string) {
    Column({ space: 3 }) {
      Text(icon).fontSize(16)
      Text(label).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
      Text(value).fontSize(13).fontWeight(FontWeight.Bold).fontColor('#6366F1')
    }
    .layoutWeight(1)
    .padding(10)
    .backgroundColor('#EEF2FF')
    .borderRadius(12)
  }

  // ==================== 宠物选择卡片 ====================
  @Builder
  PetSelectCard(pet: Pet) {
    Row({ space: 14 }) {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Image(pet.images && pet.images.length > 0 ? $rawfile(pet.images[0]) : '')
          .width(80).height(80).objectFit(ImageFit.Cover)
          .borderRadius(16)

        if (this.selectedPet?.id === pet.id) {
          Text('✓').fontSize(14).fontColor('#FFFFFF').fontWeight(FontWeight.Bold)
            .width(24).height(24)
            .backgroundColor('#6366F1')
            .borderRadius(12)
            .position({ x: 56, y: 56 })
            .textAlign(TextAlign.Center)
        }
      }

      Column({ space: 5 }) {
        Text(pet.name)
          .fontSize(16).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
        Row({ space: 6 }) {
          Text(`${pet.breed}`).fontSize(13).fontColor(CommonStyles.TEXT_SECONDARY)
          Text('·').fontSize(13).fontColor(CommonStyles.TEXT_TERTIARY)
          Text(`${pet.age}岁`).fontSize(13).fontColor(CommonStyles.TEXT_SECONDARY)
          Text('·').fontSize(13).fontColor(CommonStyles.TEXT_TERTIARY)
          Text(pet.gender === 'male' ? '公' : '母').fontSize(13).fontColor(CommonStyles.TEXT_SECONDARY)
        }
        Text(pet.healthStatus ? pet.healthStatus : '')
          .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })

        Row({ space: 6 }) {
          if (pet.adoptionStatus === 'available') {
            Text('可领养').fontSize(11).fontColor('#10B981').fontWeight(FontWeight.Medium)
              .padding({ left: 8, right: 8, top: 3, bottom: 3 })
              .backgroundColor('#ECFDF5')
              .borderRadius(CommonStyles.RADIUS_FULL)
          } else {
            Text('已预约').fontSize(11).fontColor('#F59E0B').fontWeight(FontWeight.Medium)
              .padding({ left: 8, right: 8, top: 3, bottom: 3 })
              .backgroundColor('#FEF3C7')
              .borderRadius(CommonStyles.RADIUS_FULL)
          }
          Text(`${pet.weight || '?'}kg`).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
        }
      }
      .layoutWeight(1).alignItems(HorizontalAlign.Start)
    }
    .width('100%').padding(14)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .border({
      width: this.selectedPet?.id === pet.id ? 2 : 1,
      color: this.selectedPet?.id === pet.id ? '#6366F1' : '#F1F5F9',
      radius: 16
    })
    .shadow(
      this.selectedPet?.id === pet.id
        ? { color: 'rgba(99,102,241,0.15)', radius: 12, offsetX: 0, offsetY: 2 }
        : { color: 'rgba(0,0,0,0.04)', radius: 8, offsetX: 0, offsetY: 1 }
    )
    .onClick(() => { this.selectedPet = pet; })
  }

  // ==================== 功能介绍 ====================
  @Builder
  FeatureIntro() {
    Column({ space: 14 }) {
      Row() {
        Text('✨ 核心能力')
          .fontSize(16).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text('Image demo')
          .fontSize(11).fontColor('#6366F1').fontWeight(FontWeight.Medium)
          .backgroundColor('#EEF2FF')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(CommonStyles.RADIUS_FULL)
      }.width('100%')

      this.FeatureItem('👁️', '图片展示', '使用本地示例图片，不识别真实物体', '#6366F1')
      this.FeatureItem('🏠', '位置调整', '手动移动与缩放图片，不测量真实房间', '#8B5CF6')
      this.FeatureItem('📐', '精确尺寸测量', '直观展示宠物实际尺寸，帮助规划活动空间', '#A78BFA')
      this.FeatureItem('💫', '流畅交互体验', '高帧率渲染+低延迟响应，带来沉浸式体验', '#C4B5FD')
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .shadow({ color: 'rgba(99,102,241,0.06)', radius: 16, offsetX: 0, offsetY: 2 })
    .margin({ top: 8 })
  }

  @Builder
  FeatureItem(icon: string, title: string, desc: string, accentColor: string) {
    Row({ space: 12 }) {
      Text(icon).fontSize(22)
        .width(38).height(38)
        .backgroundColor(accentColor + '15')
        .borderRadius(10)
        .textAlign(TextAlign.Center)
      Column({ space: 3 }) {
        Text(title).fontSize(14).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
        Text(desc).fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY).lineHeight(17)
      }
      .layoutWeight(1).alignItems(HorizontalAlign.Start)
    }
    .width('100%').padding(12)
    .backgroundColor('#F8FAFC')
    .borderRadius(12)
  }

  // ==================== AR 相机视图 ====================
  @Builder
  ARCameraView() {
    Stack({ alignContent: Alignment.Top }) {

      Column()
        .width('100%').height('100%')
        .linearGradient({
          angle: 180,
          colors: [['#0F0F23', 0], ['#1A1A3E', 0.5], ['#0D0D1F', 1]]
        })

      Text('图片互动演示 · 非相机画面')
        .fontSize(13).fontColor('rgba(255,255,255,0.4)')
        .margin({ top: 30 })
        .letterSpacing(1)

      if (this.showGrid) {
        Column({ space: 0 }) {
          ForEach([0, 1, 2, 3, 4, 5, 6, 7], (_row: number) => {
            Row({ space: 0 }) {
              ForEach([0, 1, 2, 3, 4, 5, 6, 7], (_col: number) => {
                Column()
                  .width('12.5%').height(50)
                  .border({ width: 0.5, color: 'rgba(99,102,241,0.10)' })
              })
            }
          })
        }
        .width('92%')
      }

      if (this.selectedPet) {
        Stack({ alignContent: Alignment.Bottom }) {
          Column() {
            Image(this.selectedPet.images && this.selectedPet.images.length > 0 ? $rawfile(this.selectedPet.images[0]) : '')
              .width(150 * this.zoomLevel)
              .height(150 * this.zoomLevel)
              .objectFit(ImageFit.Cover)
              .borderRadius(20)
              .rotate({ angle: this.rotation })
              .shadow({
                color: 'rgba(99,102,241,0.45)',
                radius: 30,
                offsetX: 0,
                offsetY: 8
              })
              .border({
                width: 2,
                color: 'rgba(165,180,252,0.5)',
                radius: 20
              })
          }
          .animation({
            duration: 2000,
            curve: Curve.EaseInOut,
            iterations: -1
          })
          .scale({ x: 1.02, y: 1.02 })

          Row() {
            Column({ space: 2 }) {
              Text(this.selectedPet.name)
                .fontSize(15).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
              Text(`${this.selectedPet.breed} · ${Math.round(this.zoomLevel * 100)}%`)
                .fontSize(11).fontColor('rgba(255,255,255,0.65)')
            }
            .alignItems(HorizontalAlign.Start)
            Blank()
            if (this.savedPhotos > 0) {
              Text(`📸 ${this.savedPhotos}`)
                .fontSize(11).fontColor('#A5B4FC').fontWeight(FontWeight.Medium)
                .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                .backgroundColor('rgba(99,102,241,0.25)')
                .borderRadius(8)
            }
          }
          .width(150 * this.zoomLevel)
          .padding({ left: 12, right: 12, top: 8, bottom: 8 })
          .backgroundColor('rgba(15,15,35,0.75)')
          .backdropBlur(10)
          .borderRadius({ bottomLeft: 16, bottomRight: 16 })
        }
        .translate({ x: `${this.posX - 50}%`, y: `${this.posY - 45}%` })
      }

      Column() {
        Row() {
          Text('🎮 控制面板')
            .fontSize(14).fontWeight(FontWeight.Bold).fontColor('#1E1B4B')
          Blank()
          Text('Image Demo Mode')
            .fontSize(10).fontColor('#6366F1').fontWeight(FontWeight.Medium)
            .padding({ left: 8, right: 8, top: 3, bottom: 3 })
            .backgroundColor('#EEF2FF')
            .borderRadius(8)
        }
        .width('100%')

        Row({ space: 8 }) {
          this.CtrlBtn('🔍+', '放大', () => { this.zoomLevel = Math.min(2.0, this.zoomLevel + 0.15); })
          this.CtrlBtn('🔍-', '缩小', () => { this.zoomLevel = Math.max(0.5, this.zoomLevel - 0.15); })
          this.CtrlBtn('↺', '左旋转', () => { this.rotation -= 15; })
          this.CtrlBtn('↻', '右旋转', () => { this.rotation += 15; })
        }

        Column({ space: 6 }) {
          Text('水平位置').fontSize(11).fontColor('#64748B').width('100%')
          Slider({
            value: this.posX,
            min: 0,
            max: 100,
            style: SliderStyle.OutSet
          })
            .blockColor('#6366F1')
            .trackColor('#E2E8F0')
            .selectedColor('#6366F1')
            .onChange((value: number) => { this.posX = value; })
        }

        Column({ space: 6 }) {
          Text('垂直位置').fontSize(11).fontColor('#64748B').width('100%')
          Slider({
            value: this.posY,
            min: 10,
            max: 80,
            style: SliderStyle.OutSet
          })
            .blockColor('#6366F1')
            .trackColor('#E2E8F0')
            .selectedColor('#6366F1')
            .onChange((value: number) => { this.posY = value; })
        }

        Divider().color('#F1F5F9')

        Row({ space: 8 }) {
          Button(this.showGrid ? '📊 隐藏网格' : '📊 显示网格', { type: ButtonType.Capsule })
            .layoutWeight(1).height(36).fontSize(12)
            .fontColor('#334155')
            .backgroundColor('#F1F5F9')
            .borderRadius(10)
            .onClick(() => { this.showGrid = !this.showGrid; })

          Button('模拟拍照（不保存）', { type: ButtonType.Capsule })
            .layoutWeight(1).height(36).fontSize(12)
            .fontColor('#FFFFFF').fontWeight(FontWeight.Medium)
            .backgroundColor('#6366F1')
            .borderRadius(10)
            .shadow({ color: 'rgba(99,102,241,0.3)', radius: 8, offsetX: 0, offsetY: 2 })
            .onClick(() => {
              this.savedPhotos++;
              promptAction.showToast({ message: `仅模拟拍照：${this.selectedPet!.name}，没有保存照片` });
            })
        }

        Button('🔄 重置所有操作', { type: ButtonType.Capsule })
          .width('100%').height(34).fontSize(12)
          .fontColor('#64748B')
          .backgroundColor('transparent')
          .borderWidth(1).borderColor('#E2E8F0')
          .borderRadius(10)
          .margin({ top: 4 })
          .onClick(() => {
            this.zoomLevel = 1.0;
            this.rotation = 0;
            this.posX = 50;
            this.posY = 40;
          })
      }
      .width('92%').padding(16)
      .backgroundColor('rgba(255,255,255,0.96)')
      .borderRadius(20)
      .shadow({ color: 'rgba(0,0,0,0.15)', radius: 24, offsetX: 0, offsetY: 8 })
      .position({ x: '4%', y: '72%' })
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%').layoutWeight(1)
  }

  // ==================== 控制按钮 ====================
  @Builder
  CtrlBtn(icon: string, label: string, action: () => void) {
    Column({ space: 2 }) {
      Text(icon).fontSize(18)
      Text(label).fontSize(9).fontColor('#64748B')
    }
    .width(62)
    .padding(6)
    .backgroundColor('#F8FAFC')
    .borderRadius(10)
    .onClick(action)
  }
}
