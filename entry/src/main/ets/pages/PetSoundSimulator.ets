import { CommonStyles } from '../common/css/CommonStyles';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';
import { promptAction } from '@kit.ArkUI';

interface SoundItem {
  id: string;
  emoji: string;
  name: string;
  petType: string;
  category: string;
  duration: string;
  description: string;
}

interface PlayHistory {
  sound: SoundItem;
  playedAt: string;
}

@Entry
@Component
struct PetSoundSimulator {
  @State private selectedCategory: string = 'all';
  @State private selectedPetType: string = 'all';
  @State private currentPlaying: string = '';
  @State private isPlaying: boolean = false;
  @State private volume: number = 70;
  @State private favorites: string[] = [];
  @State private playHistory: PlayHistory[] = [];
  @State private searchKeyword: string = '';
  @State private filteredSounds: SoundItem[] = [];

  private allSounds: SoundItem[] = [
    { id: 'cat_meow1', emoji: '🐱', name: '猫咪叫唤', petType: 'cat', category: '日常', duration: '0:03', description: '猫咪的普通叫声' },
    { id: 'cat_purr', emoji: '😺', name: '呼噜声', petType: 'cat', category: '舒适', duration: '0:05', description: '猫咪满足时的呼噜声' },
    { id: 'cat_hiss', emoji: '😾', name: '哈气声', petType: 'cat', category: '警告', duration: '0:02', description: '猫咪生气或害怕时的哈气' },
    { id: 'cat_chirp', emoji: '🐱', name: '小猫叫', petType: 'cat', category: '日常', duration: '0:04', description: '小猫咪的可爱叫声' },
    { id: 'dog_bark1', emoji: '🐕', name: '汪汪叫', petType: 'dog', category: '日常', duration: '0:03', description: '狗狗兴奋时的叫声' },
    { id: 'dog_whine', emoji: '🐶', name: '呜呜声', petType: 'dog', category: '情绪', duration: '0:04', description: '狗狗想要关注时的呜咽' },
    { id: 'dog_growl', emoji: '😠', name: '低吼声', petType: 'dog', category: '警告', duration: '0:03', description: '狗狗威胁时的低吼' },
    { id: 'dog_howl', emoji: '🐺', name: '嚎叫声', petType: 'dog', category: '沟通', duration: '0:06', description: '狗狗孤独时的嚎叫' },
    { id: 'bird_tweet', emoji: '🐦', name: '鸟鸣声', petType: 'other', category: '日常', duration: '0:03', description: '小鸟清脆的叫声' },
    { id: 'rabbit_squeak', emoji: '🐰', name: '吱吱声', petType: 'other', category: '日常', duration: '0:02', description: '兔子受到惊吓时的声音' },
    { id: 'hamster_squeak', emoji: '🐹', name: '吱吱叫', petType: 'other', category: '日常', duration: '0:02', description: '仓鼠的吱吱叫声' },
    { id: 'fish_bubble', emoji: '🐟', name: '水泡声', petType: 'other', category: '特殊', duration: '0:05', description: '鱼缸中气泡的声音' }
  ];

  aboutToAppear(): void {
    this.filteredSounds = this.allSounds;
  }

  build() {
    Column() {
      SafeArea({ edges: ['top'] }) {
        // 导航栏
        Row() {
          BackButton()
          Text('🔊 宠物声音模拟器')
            .fontSize(18).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
            .layoutWeight(1)
        }
        .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })
        .backgroundColor('#FFFFFF')

        // 搜索框
        this.SearchBar()

        // 分类筛选
        this.CategoryFilter()

        // 声音列表
        this.SoundList()

        // 播放控制
        if (this.currentPlaying) {
          this.PlayingControl()
        }
      }
    }
    .width('100%').height('100%')
    .padding({ top: '45mm' })
    .backgroundColor('#F8FAFC')
  }

  // ==================== 搜索栏 ====================
  @Builder
  SearchBar() {
    Row({ space: 12 }) {
      TextInput({ placeholder: '搜索声音...', text: this.searchKeyword })
        .layoutWeight(1)
        .height(40)
        .fontSize(14)
        .backgroundColor('#FFFFFF')
        .borderRadius(20)
        .padding({ left: 16, right: 16 })
        .onChange((value: string) => {
          this.searchKeyword = value;
          this.filterSounds();
        })
    }
    .width('100%').padding({ left: 16, right: 16, bottom: 12 })
  }

  // ==================== 分类筛选 ====================
  @Builder
  CategoryFilter() {
    Scroll() {
      Row({ space: 8 }) {
        this.CategoryChip('全部', 'all')
        this.CategoryChip('猫咪 🐱', 'cat')
        this.CategoryChip('狗狗 🐶', 'dog')
        this.CategoryChip('其他 🐾', 'other')
      }
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .width('100%').padding({ left: 16, right: 16, bottom: 12 })
  }

  @Builder
  CategoryChip(label: string, type: string) {
    Text(label)
      .fontSize(13)
      .fontColor(this.selectedPetType === type ? '#FFFFFF' : '#64748B')
      .fontWeight(this.selectedPetType === type ? FontWeight.Medium : FontWeight.Normal)
      .padding({ left: 14, right: 14, top: 8, bottom: 8 })
      .backgroundColor(this.selectedPetType === type ? '#6366F1' : '#FFFFFF')
      .borderRadius(20)
      .shadow(this.selectedPetType === type ? { color: 'rgba(99,102,241,0.25)', radius: 8, offsetX: 0, offsetY: 2 } : undefined)
      .onClick(() => {
        this.selectedPetType = type;
        this.filterSounds();
      })
  }

  // ==================== 声音列表 ====================
  @Builder
  SoundList() {
    List({ space: 12 }) {
      ForEach(this.filteredSounds, (sound: SoundItem) => {
        ListItem() {
          this.SoundCard(sound)
        }
      })
    }
    .width('100%').layoutWeight(1)
    .padding({ left: 16, right: 16 })
    .scrollBar(BarState.Off)
  }

  @Builder
  SoundCard(sound: SoundItem) {
    Row() {
      // 左侧：图标（固定尺寸）
      Text(sound.emoji)
        .fontSize(32)
        .width(56).height(56)
        .backgroundColor('#F1F5F9')
        .borderRadius(14)
        .textAlign(TextAlign.Center)

      // 中间：信息区（弹性布局，允许文本截断）
      Column({ space: 4 }) {
        Text(sound.name)
          .fontSize(15).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Row({ space: 8 }) {
          Text(sound.petType === 'cat' ? '猫咪' : sound.petType === 'dog' ? '狗狗' : '其他')
            .fontSize(11).fontColor('#6366F1')
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .backgroundColor('#EEF2FF')
            .borderRadius(8)

          Text(`⏱️ ${sound.duration}`)
            .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
        }

        Text(sound.description)
          .fontSize(12).fontColor(CommonStyles.TEXT_SECONDARY)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      // 右侧：操作按钮（固定宽度容器）
      Column({ space: 10 }) {
        Button(this.currentPlaying === sound.id ? '⏸' : '▶️', { type: ButtonType.Capsule })
          .width(50).height(50)
          .fontSize(22)
          .fontColor(this.currentPlaying === sound.id ? '#FFFFFF' : '#6366F1')
          .backgroundColor(this.currentPlaying === sound.id ? '#6366F1' : '#EEF2FF')
          .borderRadius(16)
          .shadow(this.currentPlaying === sound.id ? { color: 'rgba(99,102,241,0.35)', radius: 10, offsetX: 0, offsetY: 3 } : undefined)
          .onClick(() => this.playSound(sound))

        Button(this.favorites.includes(sound.id) ? '❤️' : '🤍', { type: ButtonType.Capsule })
          .width(50).height(38)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.favorites.includes(sound.id) ? '#EF4444' : '#94A3B8')
          .backgroundColor(this.favorites.includes(sound.id) ? '#FEF2F2' : '#F8FAFC')
          .borderRadius(12)
          .onClick(() => this.toggleFavorite(sound.id))
      }
      .width(60)
      .constraintSize({ minWidth: 60 })  // ArkUI 方式：设置最小宽度
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
      .padding({ top: 4, bottom: 4 })
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({ color: 'rgba(0,0,0,0.04)', radius: 10, offsetX: 0, offsetY: 1 })
  }

  // ==================== 播放控制 ====================
  @Builder
  PlayingControl() {
    Column({ space: 12 }) {
      Row() {
        Text('正在播放')
          .fontSize(13).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text(`${this.volume}%`)
          .fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
      }.width('100%')

      Slider({
        value: this.volume,
        min: 0,
        max: 100,
        style: SliderStyle.OutSet
      })
        .blockColor('#6366F1')
        .trackColor('#E2E8F0')
        .selectedColor('#6366F1')
        .onChange((value: number) => { this.volume = value; })

      Row({ space: 10 }) {
        Button('⏹ 暂停', { type: ButtonType.Capsule })
          .layoutWeight(1).height(38).fontSize(13)
          .fontColor('#64748B')
          .backgroundColor('#F1F5F9')
          .borderRadius(10)
          .onClick(() => this.stopPlaying())

        Button('停止播放', { type: ButtonType.Capsule })
          .layoutWeight(1).height(38).fontSize(13)
          .fontColor('#FFFFFF')
          .backgroundColor('#EF4444')
          .borderRadius(10)
          .onClick(() => this.stopPlaying())
      }
    }
    .width('100%').padding(16)
    .margin({ top: 8 })
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .shadow({ color: 'rgba(99,102,241,0.08)', radius: 12, offsetX: 0, offsetY: 2 })
  }

  // ==================== 方法 ====================
  private filterSounds(): void {
    let filtered = this.allSounds;

    if (this.selectedPetType !== 'all') {
      filtered = filtered.filter((s: SoundItem) => s.petType === this.selectedPetType);
    }

    if (this.searchKeyword.trim()) {
      const keyword = this.searchKeyword.toLowerCase();
      filtered = filtered.filter((s: SoundItem) =>
        s.name.toLowerCase().includes(keyword) ||
        s.description.toLowerCase().includes(keyword)
      );
    }

    this.filteredSounds = filtered;
  }

  private playSound(sound: SoundItem): void {
    this.currentPlaying = sound.id;
    this.isPlaying = true;

    promptAction.showToast({
      message: `播放: ${sound.name} ${sound.emoji}`,
      duration: 2000
    });

    setTimeout(() => {
      if (this.currentPlaying === sound.id) {
        this.playHistory.unshift({
          sound: sound,
          playedAt: new Date().toLocaleTimeString()
        });
        if (this.playHistory.length > 10) {
          this.playHistory.pop();
        }
        this.stopPlaying();
      }
    }, 3000);
  }

  private stopPlaying(): void {
    this.currentPlaying = '';
    this.isPlaying = false;
  }

  private toggleFavorite(soundId: string): void {
    const index = this.favorites.indexOf(soundId);
    if (index >= 0) {
      this.favorites.splice(index, 1);
      promptAction.showToast({ message: '已取消收藏' });
    } else {
      this.favorites.push(soundId);
      promptAction.showToast({ message: '已添加到收藏' });
    }
  }
}
