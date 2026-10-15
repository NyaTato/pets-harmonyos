// 宠物领养合同页 - PDF合同生成
import { RouterHelper, RouteParams } from '../router/RouterHelper';
import { CommonStyles } from '../common/css/CommonStyles';
import { PDFContractGenerator, ContractData } from '../utils/PDFContractGenerator';
import { getApplyById } from '../mock/ApplyData';
import { getPetById, Pet } from '../mock/PetData';
import { AppStore } from '../store/AppStore';
import { promptAction } from '@kit.ArkUI';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

interface ContractTerm {
  id: number;
  title: string;
  content: string;
  required: boolean;
}

@Entry
@Component
struct Contract {
  @State private contractData: ContractData | null = null;
  @State private isLoading: boolean = true;
  @State private applyId: number = 1;

  aboutToAppear(): void {
    this.loadContractData();
  }

  private loadContractData(): void {
    this.isLoading = true;

    const params: RouteParams = RouterHelper.getParams();
    this.applyId = params.applyId ? parseInt(params.applyId) : 1;

    setTimeout(() => {
      try {
        const apply = getApplyById(this.applyId);
        if (apply && apply.petId) {
          const pet = getPetById(apply.petId);
          const store = AppStore.getInstance();
          const user = store.getState().currentUser;

          if (pet && user) {
            this.contractData = {
              petName: pet.name,
              petType: pet.type === 'cat' ? '猫咪' : pet.type === 'dog' ? '狗狗' : '其他',
              petBreed: pet.breed,
              petAge: pet.age,
              petGender: pet.gender === 'male' ? '公' : '母',
              adopterName: user.nickname || '未知',
              adopterIdCard: '**************' + Math.floor(Math.random() * 1000).toString().padStart(3, '0'),
              adopterPhone: user.phone || '未填写',
              adopterAddress: apply.address || '未填写地址',
              adoptionDate: new Date().toISOString().split('T')[0],
              adoptionFee: 0,
              trialPeriod: 30,
              terms: [
                { id: 1, title: '宠物基本信息', content: `领养${pet.name}是${pet.breed}，${pet.age}岁，${pet.gender === 'male' ? '公' : '母'}性一只`, required: true },
                { id: 2, title: '领养人责任', content: '保证提供足够食物、水和安全环境，定期带宠物去医院检查', required: true },
                { id: 3, title: '平台权利', content: '平台有权进行不定期回访，确认宠物生活状况', required: true },
                { id: 4, title: '退养条款', content: `领养后30天内，如无法继续饲养，必须联系平台进行退养，不得私自转让`, required: false }
              ]
            };
          }
        }
      } catch (error) {
        console.error('加载合同数据失败:', error);
      }

      this.isLoading = false;
    }, 500);
  }

  build() {
    Column() {
      SafeArea({
        edges: ['top', 'bottom']
      }) {
        Column() {
          Row() {
            BackButton()

            Text('宠物领养合同')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(CommonStyles.TEXT_PRIMARY)
              .layoutWeight(1)

            Text('')
              .width(24)
          }
          .width('100%')
          .padding({ left: CommonStyles.LG, right: CommonStyles.LG, top: 16, bottom: 16 })
          .backgroundColor('#FFFFFF')

          Scroll() {
            Column({ space: 24 }) {
              if (this.isLoading) {
                this.LoadingState()
              } else if (!this.contractData) {
                this.ErrorState()
              } else {
                this.ContractContent()
              }
            }
            .width('100%')
            .padding({ left: CommonStyles.LG, right: CommonStyles.LG, bottom: 60 })
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)
          .layoutWeight(1)
          .backgroundColor('#F5F7FA')
        }
        .width('100%')
        .height('100%')
        .padding({ top: '45mm' })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  @Builder
  LoadingState() {
    Column({ space: 16 }) {
      LoadingProgress()
        .color(CommonStyles.PRIMARY)
        .width(48)
        .height(48)
        .margin({ top: 80 })

      Text('正在生成合同...')
        .fontSize(16)
        .fontColor(CommonStyles.TEXT_SECONDARY)
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  ErrorState() {
    Column({ space: 24 }) {
      Text('📄')
        .fontSize(80)

      Text('合同加载失败')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.TEXT_PRIMARY)

      Text('未找到对应的申请记录，请检查状态')
        .fontSize(15)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .textAlign(TextAlign.Center)
        .width('80%')

      Button('返回', { type: ButtonType.Capsule })
        .width(200)
        .height(44)
        .fontSize(16)
        .fontColor('#FFFFFF')
        .backgroundColor(CommonStyles.PRIMARY)
        .borderRadius(22)
        .margin({ top: 24 })
        .onClick(() => RouterHelper.back())
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding({ top: 80 })
  }

  @Builder
  ContractContent() {
    Column({ space: 20 }) {
      // 合同标题区
      Column({ space: 12 }) {
        Text('📋 宠物领养服务合同')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        Row({ space: 8 }) {
          Text(`合同编号: AD-${Date.now().toString().slice(-8)}`)
            .fontSize(13)
            .fontColor(CommonStyles.TEXT_TERTIARY)

          Text(`签署日期: ${this.contractData!.adoptionDate}`)
            .fontSize(13)
            .fontColor(CommonStyles.TEXT_TERTIARY)
        }
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow(CommonStyles.SHADOW_MD)

      // 宠物信息卡片
      Column({ space: 12 }) {
        Text('宠物信息')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        this.InfoRow('姓名', this.contractData!.petName)
        this.InfoRow('种类', `${this.contractData!.petType} - ${this.contractData!.petBreed}`)
        this.InfoRow('年龄', `${this.contractData!.petAge} 岁`)
        this.InfoRow('性别', this.contractData!.petGender)
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow(CommonStyles.SHADOW_SM)

      // 领养人信息卡片
      Column({ space: 12 }) {
        Text('领养人信息')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        this.InfoRow('姓名', this.contractData!.adopterName)
        this.InfoRow('联系电话', this.contractData!.adopterPhone)
        this.InfoRow('居住地址', this.contractData!.adopterAddress)
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow(CommonStyles.SM)

      // 合同条款
      Column({ space: 16 }) {
        Text('📝 合同条款')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        ForEach(this.contractData!.terms, (term: ContractTerm) => {
          Column({ space: 8 }) {
            Row({ space: 8 }) {
              Text(`${term.id}.`)
                .fontSize(15)
                .fontWeight(FontWeight.Medium)
                .fontColor(CommonStyles.PRIMARY)

              Text(term.title)
                .fontSize(15)
                .fontWeight(FontWeight.Medium)
                .fontColor(CommonStyles.TEXT_PRIMARY)

              if (term.required) {
                Text('*必读')
                  .fontSize(11)
                  .fontColor(CommonStyles.DANGER)
                  .backgroundColor('#FEE2E2')
                  .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                  .borderRadius(4)
              }
            }
            .width('100%')

            Text(term.content)
              .fontSize(14)
              .fontColor(CommonStyles.TEXT_SECONDARY)
              .lineHeight(22)
              .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor(term.required ? '#FFFBEB' : '#F9FAFB')
          .borderRadius(12)
        })
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .shadow(CommonStyles.SM)

      // 签名按钮
      Button('确认并签署合同', { type: ButtonType.Capsule })
        .width('100%')
        .height(52)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .backgroundColor(CommonStyles.PRIMARY)
        .borderRadius(26)
        .shadow(CommonStyles.SHADOW_BRAND_OLD)
        .margin({ top: 16 })
        .onClick(() => {
          promptAction.showToast({
            message: '合同签署成功！',
            duration: 3000
          });
          setTimeout(() => {
            RouterHelper.back();
          }, 1500);
        })
    }
  }

  @Builder
  InfoRow(label: string, value: string) {
    Row() {
      Text(`${label}:`)
        .fontSize(14)
        .fontColor(CommonStyles.TEXT_SECONDARY)
        .width(90)

      Text(value)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonStyles.TEXT_PRIMARY)
        .layoutWeight(1)
        .textAlign(TextAlign.End)
    }
    .width('100%')
    .padding({ top: 6, bottom: 6 })
  }
}
