import { CommonStyles } from '../common/css/CommonStyles';
import { RouterHelper } from '../router/RouterHelper';
import { Pet, petList } from '../mock/PetData';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

interface FilterCategory {
  id: string;
  name: string;
}

interface SortOption {
  id: string;
  name: string;
}

@Component
export struct PetList {
  @State private pets: Pet[] = [];
  @State private filteredPets: Pet[] = [];
  @State private isLoading: boolean = false;
  @State private selectedCategory: string = 'all';
  @State private searchKeyword: string = '';
  @State private isGridView: boolean = true;

  private allPets: Pet[] = [];

  private categories: FilterCategory[] = [
    { id: 'all', name: '全部' },
    { id: 'cat', name: '猫咪' },
    { id: 'dog', name: '狗狗' },
    { id: 'other', name: '其他' }
  ];

  private sortOptions: SortOption[] = [
    { id: 'default', name: '默认排序' },
    { id: 'age', name: '年龄排序' },
    { id: 'likes', name: '最受欢迎' }
  ];

  aboutToAppear(): void {
    this.loadPets();
  }

  private loadPets(): void {
    this.isLoading = true;

    setTimeout(() => {
      this.allPets = [...petList];
      this.applyFilters();
      this.isLoading = false;
    }, 500);
  }

  private applyFilters(): void {
    let result: Pet[] = [...this.allPets];

    if (this.selectedCategory !== 'all') {
      const targetType = this.selectedCategory;
      result = result.filter((p: Pet) => p.type === targetType);
    }

    if (this.searchKeyword.trim()) {
      const keyword = this.searchKeyword.toLowerCase().trim();
      result = result.filter((p: Pet) =>
        p.name.toLowerCase().includes(keyword) ||
        p.breed.toLowerCase().includes(keyword) ||
        (p.location && p.location.toLowerCase().includes(keyword))
      );
    }

    this.filteredPets = result;
    this.pets = result;
  }

  private selectCategory(id: string): void {
    this.selectedCategory = id;
    this.applyFilters();
  }

  private onSearchChange(value: string): void {
    this.searchKeyword = value;
    this.applyFilters();
  }

  build() {
    Column() {
      // ===== 顶部导航栏 =====
      Row({ space: CommonStyles.SPACE_MD }) {
        BackButton()

        Text('领养中心')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Blank()

        Text(this.isGridView ? '☰' : '⊞')
          .fontSize(22)
          .onClick(() => {
            this.isGridView = !this.isGridView;
          })
      }
      .width('100%')
      .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG, top: 16, bottom: 16 })
      .backgroundColor('#FFFFFF')

      // ===== 搜索栏 =====
      Row() {
        TextInput({
          placeholder: '搜索宠物名称、品种...',
          text: this.searchKeyword
        })
          .placeholderColor(CommonStyles.TEXT_TERTIARY)
          .placeholderFont({ size: 14 })
          .fontSize(14)
          .fontColor(CommonStyles.TEXT_PRIMARY)
          .layoutWeight(1)
          .height(44)
          .backgroundColor('#F8FAFC')
          .borderRadius(CommonStyles.RADIUS_FULL)
          .padding({ left: 16 })
          .onChange((value: string) => {
            this.onSearchChange(value);
          })

        if (this.searchKeyword.length > 0) {
          Text('✕')
            .fontSize(16)
            .fontColor(CommonStyles.TEXT_TERTIARY)
            .margin({ left: 12 })
            .onClick(() => {
              this.searchKeyword = '';
              this.applyFilters();
            })
        }
      }
      .width('100%')
      .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG, bottom: 12 })

      // ===== 分类标签栏 =====
      Scroll() {
        Row({ space: 10 }) {
          ForEach(this.categories, (category: FilterCategory) => {
            Text(category.name)
              .fontSize(13)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.selectedCategory === category.id ? '#FFFFFF' : CommonStyles.TEXT_SECONDARY)
              .padding({ left: 18, right: 18, top: 9, bottom: 9 })
              .borderRadius(CommonStyles.RADIUS_FULL)
              .backgroundColor(this.selectedCategory === category.id ? CommonStyles.PRIMARY : '#F1F5F9')
              .onClick(() => {
                this.selectCategory(category.id);
              })
          })
        }
        .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')

      // ===== 结果统计 + 排序 =====
      Row({ space: 12 }) {
        Text(`共 ${this.pets.length} 只宠物`)
          .fontSize(13)
          .fontColor(CommonStyles.TEXT_SECONDARY)

        Blank()
      }
      .width('100%')
      .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG, top: 12, bottom: 4 })

      // ===== 宠物列表内容区域 =====
      if (this.isLoading) {
        Column() {
          Text('加载中...')
            .fontSize(15)
            .fontColor(CommonStyles.TEXT_TERTIARY)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else if (this.pets.length > 0) {
        Scroll() {
          if (this.isGridView) {
            Grid() {
              ForEach(this.pets, (pet: Pet) => {
                GridItem() {
                  this.PetGridCard(pet)
                }
              }, (pet: Pet) => pet.id.toString())
            }
            .columnsTemplate('1fr 1fr')
            .rowsGap(16)
            .columnsGap(16)
            .width('100%')
            .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG, bottom: 24 })
          } else {
            Column({ space: 12 }) {
              ForEach(this.pets, (pet: Pet) => {
                this.PetListItem(pet)
              }, (pet: Pet) => pet.id.toString())
            }
            .width('100%')
            .padding({ left: CommonStyles.SPACE_LG, right: CommonStyles.SPACE_LG, bottom: 24 })
          }
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .layoutWeight(1)
      } else {
        Column({ space: 20 }) {
          Text('🔍')
            .fontSize(32)
            .fontColor(CommonStyles.TEXT_TERTIARY)

          Text('未找到符合条件的宠物')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor(CommonStyles.TEXT_PRIMARY)

          Text('试试调整筛选条件或搜索关键词')
            .fontSize(14)
            .fontColor(CommonStyles.TEXT_TERTIARY)

          Button('重置筛选', { type: ButtonType.Capsule })
            .height(40)
            .fontSize(14)
            .fontColor(CommonStyles.PRIMARY)
            .backgroundColor(CommonStyles.PRIMARY_BG)
            .borderRadius(CommonStyles.RADIUS_FULL)
            .margin({ top: 8 })
            .onClick(() => {
              this.selectedCategory = 'all';
              this.searchKeyword = '';
              this.applyFilters();
            })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(CommonStyles.BG_LIGHT)
  }

  @Builder
  PetGridCard(pet: Pet) {
    Column({ space: 12 }) {
      Stack({ alignContent: Alignment.Bottom }) {
        Image(pet.images && pet.images.length > 0 ? $rawfile(pet.images[0]) : '')
          .width('100%')
          .height(160)
          .objectFit(ImageFit.Cover)
          .borderRadius({ topLeft: CommonStyles.RADIUS_MD, topRight: CommonStyles.RADIUS_MD })

        Column()
          .width('100%')
          .height(60)
          .linearGradient({
            angle: 180,
            colors: [['rgba(0,0,0,0)', 0.0], ['rgba(0,0,0,0.5)', 1.0]]
          })
          .borderRadius({ bottomLeft: CommonStyles.RADIUS_MD, bottomRight: CommonStyles.RADIUS_MD })

        if (pet.adoptionStatus === 'available') {
          Text('可领养')
            .fontSize(11)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Medium)
            .padding({ left: 10, right: 10, top: 6, bottom: 6 })
            .backgroundColor(CommonStyles.SUCCESS + 'CC')
            .borderRadius(CommonStyles.RADIUS_FULL)
            .position({ x: 10, y: 10 })
        }
      }

      Column({ space: 6 }) {
        Row() {
          Text(pet.name)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)

          Text(pet.gender === 'male' ? '♂' : '♀')
            .fontSize(14)
        }
        .width('100%')

        Row() {
          Text(pet.breed)
            .fontSize(13)
            .fontColor(CommonStyles.TEXT_SECONDARY)

          Text(` · ${pet.age}岁`)
            .fontSize(13)
            .fontColor(CommonStyles.TEXT_SECONDARY)

          Blank()

          Text(pet.location?.split(' ')[0] || '')
            .fontSize(12)
            .fontColor(CommonStyles.TEXT_TERTIARY)
        }
        .width('100%')

        Row() {
          Row({ space: 4 }) {
            Text('♥')
              .fontSize(13)
              .fontColor(CommonStyles.DANGER)

            Text(`${pet.likes}`)
              .fontSize(12)
              .fontColor(CommonStyles.TEXT_TERTIARY)
          }

          Blank()

          Text('⭐')
            .fontSize(18)
        }
        .width('100%')
      }
      .padding({ left: 12, right: 12, bottom: 12 })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_MD)
    .shadow(CommonStyles.SHADOW_SM)
    .onClick(() => {
      RouterHelper.navigateToPetDetail(pet.id);
    })
  }

  @Builder
  PetListItem(pet: Pet) {
    Row({ space: 12 }) {
      Stack({ alignContent: Alignment.Bottom }) {
        Image(pet.images && pet.images.length > 0 ? $rawfile(pet.images[0]) : '')
          .width(120)
          .height(120)
          .objectFit(ImageFit.Cover)
          .borderRadius(CommonStyles.RADIUS_MD)

        Column()
          .width(120)
          .height(45)
          .linearGradient({
            angle: 180,
            colors: [['rgba(0,0,0,0)', 0.0], ['rgba(0,0,0,0.5)', 1.0]]
          })
          .borderRadius({ bottomLeft: CommonStyles.RADIUS_MD, bottomRight: CommonStyles.RADIUS_MD })
      }

      Column({ space: 8 }) {
        Row() {
          Text(pet.name)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor(CommonStyles.TEXT_PRIMARY)
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(pet.gender === 'male' ? '♂' : '♀')
            .fontSize(16)
        }
        .width('100%')

        Text(pet.breed)
          .fontSize(14)
          .fontColor(CommonStyles.TEXT_SECONDARY)

        Row({ space: 8 }) {
          Text(`${pet.age}岁`)
            .fontSize(13)
            .fontColor(CommonStyles.TEXT_TERTIARY)

          Text(pet.location || '')
            .fontSize(13)
            .fontColor(CommonStyles.TEXT_TERTIARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .width('100%')

        Row() {
          Row({ space: 4 }) {
            Text('♥')
              .fontSize(14)
              .fontColor(CommonStyles.DANGER)

            Text(`${pet.likes}`)
              .fontSize(13)
              .fontColor(CommonStyles.TEXT_TERTIARY)
          }

          Blank()

          if (pet.adoptionStatus === 'available') {
            Text('可领养')
              .fontSize(11)
              .fontColor(CommonStyles.SUCCESS)
              .fontWeight(FontWeight.Medium)
              .padding({ left: 10, right: 10, top: 5, bottom: 5 })
              .backgroundColor(CommonStyles.SUCCESS + '20')
              .borderRadius(CommonStyles.RADIUS_FULL)
          }
        }
        .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_MD)
    .shadow(CommonStyles.SHADOW_SM)
    .onClick(() => {
      RouterHelper.navigateToPetDetail(pet.id);
    })
  }
}
