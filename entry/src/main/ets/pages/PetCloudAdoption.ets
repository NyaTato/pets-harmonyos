﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿import { CommonStyles } from '../common/css/CommonStyles';
import { RouterHelper } from '../router/RouterHelper';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';
import { petList, Pet } from '../mock/PetData';
import { promptAction } from '@kit.ArkUI';

interface CloudPet {
  pet: Pet;
  adoptedAt: string;
  feedCount: number;
  playCount: number;
  lastInteraction: string;
  affectionLevel: number;
  messages: CloudMessage[];
}

interface CloudMessage {
  id: number;
  from: string;
  content: string;
  time: string;
}

@Entry
@Component
struct PetCloudAdoption {
  @State private selectedCloudPet: CloudPet | null = null;
  @State private cloudPets: CloudPet[] = [];
  @State private showDetail: boolean = false;

  aboutToAppear(): void {
    const availablePets: Pet[] = petList.filter((p: Pet) => p.adoptionStatus === 'available').slice(0, 6);
    this.cloudPets = availablePets.map((pet: Pet): CloudPet => ({
      pet,
      adoptedAt: this.randomPastDate(),
      feedCount: Math.floor(Math.random() * 30) + 5,
      playCount: Math.floor(Math.random() * 20) + 3,
      lastInteraction: this.randomPastTime(),
      affectionLevel: Math.min(100, Math.floor(Math.random() * 60) + 20),
      messages: [
        { id: 1, from: '救助人', content: `${pet.name}今天胃口很好，吃了两顿饭！`, time: '10:30' },
        { id: 2, from: '救助人', content: `刚刚带${pet.name}去散步了，很乖哦~`, time: '14:20' }
      ]
    }));
  }

  build() {
    Column() {
      SafeArea({ edges: ['top'] }) {
        Row() {
          BackButton()
          Text('云养宠模式')
            .fontSize(18).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
            .layoutWeight(1)
          if (this.showDetail) {
            Text('返回列表')
              .fontSize(14).fontColor(CommonStyles.PRIMARY)
              .onClick(() => { this.showDetail = false; })
          }
        }
        .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })
        .backgroundColor('#FFFFFF')

        if (!this.showDetail) {
          this.CloudPetListView()
        } else if (this.selectedCloudPet) {
          this.CloudPetDetailView()
        }
      }
    }
    .width('100%').height('100%')
    .padding({ top: '45mm' })
  }

  @Builder
  CloudPetListView() {
    Scroll() {
      Column({ space: 20 }) {
        Text('☁️ 云养宠')
          .fontSize(22).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)

        Text('无法实体领养？云养宠让您远程关注流浪动物的成长，用爱心跨越距离')
          .fontSize(13).fontColor(CommonStyles.TEXT_TERTIARY)
          .textAlign(TextAlign.Center)

        Row({ space: 12 }) {
          this.StatCard(`${this.cloudPets.length}`, '只可云养')
          this.StatCard(this.cloudPets.reduce((sum: number, cp: CloudPet) => sum + cp.feedCount, 0).toString(), '次投喂')
          this.StatCard(this.cloudPets.reduce((sum: number, cp: CloudPet) => sum + cp.playCount, 0).toString(), '次互动')
        }

        Column({ space: 12 }) {
          ForEach(this.cloudPets, (cp: CloudPet) => {
            this.CloudPetCard(cp)
          })
        }

        this.HowItWorks()
      }
      .width('100%').padding({ left: 16, right: 16, bottom: 32 })
    }
    .scrollable(ScrollDirection.Vertical).scrollBar(BarState.Off)
    .layoutWeight(1).backgroundColor('#F8FAFC')
  }

  @Builder
  StatCard(value: string, label: string) {
    Column({ space: 4 }) {
      Text(value).fontSize(22).fontWeight(FontWeight.Bold).fontColor(CommonStyles.PRIMARY)
      Text(label).fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
    }
    .layoutWeight(1)
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_MD)
    .shadow(CommonStyles.SHADOW_SM)
  }

  @Builder
  CloudPetCard(cp: CloudPet) {
    Row({ space: 12 }) {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Image(cp.pet.images && cp.pet.images.length > 0 ? $rawfile(cp.pet.images[0]) : '')
          .width(80).height(80).objectFit(ImageFit.Cover)
          .borderRadius(CommonStyles.RADIUS_MD)

        Text(`亲密度 ${cp.affectionLevel}%`)
          .fontSize(9).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .backgroundColor(cp.affectionLevel >= 70 ? CommonStyles.SUCCESS : cp.affectionLevel >= 40 ? CommonStyles.PRIMARY : '#F59E0B')
          .borderRadius(CommonStyles.RADIUS_SM)
      }

      Column({ space: 6 }) {
        Row() {
          Text(cp.pet.name)
            .fontSize(16).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
          Blank()
          Text(cp.pet.breed).fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
        }.width('100%')

        Text(`${cp.pet.age}岁 · ${cp.pet.gender === 'male' ? '♂' : '♀'}`)
          .fontSize(13).fontColor(CommonStyles.TEXT_SECONDARY)

        Row({ space: 8 }) {
          Text(`🍖 ${cp.feedCount}次投喂`)
            .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
          Text(`🎾 ${cp.playCount}次互动`)
            .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
        }

        Text(`上次互动: ${cp.lastInteraction}`)
          .fontSize(11).fontColor(CommonStyles.TEXT_TERTIARY)
      }
      .layoutWeight(1).alignItems(HorizontalAlign.Start)

      Text('›').fontSize(20).fontColor('#D1D5DB')
    }
    .width('100%').padding(14)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
    .onClick(() => {
      this.selectedCloudPet = cp;
      this.showDetail = true;
    })
  }

  @Builder
  CloudPetDetailView() {
    Scroll() {
      Column({ space: 16 }) {

        Stack({ alignContent: Alignment.Bottom }) {
          if (this.selectedCloudPet && this.selectedCloudPet.pet.images && this.selectedCloudPet.pet.images.length > 0) {
            Image($rawfile(this.selectedCloudPet.pet.images[0]))
              .width('100%').height(200).objectFit(ImageFit.Cover)
              .borderRadius({ topLeft: CommonStyles.RADIUS_XL, topRight: CommonStyles.RADIUS_XL })
          }

          Column().width('100%').height(60)
            .linearGradient({ angle: 180, colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0.4)', 1]] })

          Row() {
            Text(this.selectedCloudPet?.pet.name || '')
              .fontSize(24).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
            Blank()
            Column({ space: 2 }) {
              Text('亲密度').fontSize(10).fontColor('rgba(255,255,255,0.7)')
              Text(`${this.selectedCloudPet?.affectionLevel || 0}%`)
                .fontSize(18).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
            }
          }
          .width('100%').padding(16)
        }
        .margin({ left: -16, right: -16 })

        Row({ space: 10 }) {
          this.ActionBtn('🍖 远程投喂', () => this.doAction('feed'))
          this.ActionBtn('🎾 互动玩耍', () => this.doAction('play'))
          this.ActionBtn('💬 发消息', () => this.doAction('message'))
          this.ActionBtn('❤️ 表达爱意', () => this.doAction('love'))
        }

        this.AffectionProgress()

        this.GrowthStats()

        this.MessageList()

        Button('申请转为实体领养', { type: ButtonType.Capsule })
          .width('100%').height(44).fontSize(14)
          .fontColor(CommonStyles.PRIMARY)
          .backgroundColor(CommonStyles.PRIMARY + '15')
          .borderRadius(CommonStyles.RADIUS_FULL)
          .onClick(() => {
            RouterHelper.navigateToApply(this.selectedCloudPet!.pet.id);
            promptAction.showToast({ message: `正在为 ${this.selectedCloudPet!.pet.name} 准备领养申请` });
          })
      }
      .width('100%').padding({ left: 16, right: 16, bottom: 32 })
    }
    .scrollable(ScrollDirection.Vertical).scrollBar(BarState.Off)
    .layoutWeight(1).backgroundColor('#F8FAFC')
  }

  @Builder
  ActionBtn(label: string, action: () => void) {
    Column({ space: 4 }) {
      Text(label.split(' ')[0]).fontSize(22)
      Text(label.substring(2)).fontSize(10).fontColor(CommonStyles.TEXT_SECONDARY)
    }
    .layoutWeight(1)
    .height(64)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
    .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
    .onClick(action)
  }

  @Builder
  AffectionProgress() {
    Column({ space: 10 }) {
      Row() {
        Text('亲密度成长').fontSize(15).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text(`${this.selectedCloudPet?.affectionLevel || 0} / 100`).fontSize(13).fontColor(CommonStyles.PRIMARY)
      }

      Progress({
        value: this.selectedCloudPet?.affectionLevel || 0,
        total: 100,
        type: ProgressType.Linear
      })
        .width('100%')
        .color((this.selectedCloudPet?.affectionLevel || 0) >= 70 ? CommonStyles.SUCCESS : CommonStyles.PRIMARY)
        .backgroundColor('#E5E7EB')
        .borderRadius(CommonStyles.RADIUS_FULL)

      Text((this.selectedCloudPet?.affectionLevel || 0) >= 80 ? '💕 TA已经非常信任你了！' :
        (this.selectedCloudPet?.affectionLevel || 0) >= 50 ? '🌱 继续互动，关系会更亲密哦' :
        '🌱 刚开始建立联系，多来互动吧！')
        .fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SM)
  }

  @Builder
  GrowthStats() {
    Column({ space: 14 }) {
      Text('成长数据').fontSize(15).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)

      Row({ space: 12 }) {
        this.DataItem('🍖', '累计投喂', `${this.selectedCloudPet?.feedCount || 0}次`)
        this.DataItem('🎾', '互动玩耍', `${this.selectedCloudPet?.playCount || 0}次`)
        this.DataItem('📅', '云养天数', this.calcDays())
      }

      Row({ space: 12 }) {
        this.DataItem('💬', '消息数', `${this.selectedCloudPet?.messages.length || 0}`)
        this.DataItem('⭐', '状态', this.selectedCloudPet?.pet.adoptionStatus === 'available' ? '健康' : '观察中')
        this.DataItem('📍', '位置', this.selectedCloudPet?.pet.location || '未知')
      }
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SM)
  }

  @Builder
  DataItem(icon: string, label: string, value: string) {
    Column({ space: 4 }) {
      Text(icon).fontSize(20)
      Text(value).fontSize(14).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
      Text(label).fontSize(10).fontColor(CommonStyles.TEXT_TERTIARY)
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  MessageList() {
    Column({ space: 12 }) {
      Row() {
        Text('救助站消息').fontSize(15).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text(`${this.selectedCloudPet?.messages.length || 0}`).fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
      }

      ForEach(this.selectedCloudPet?.messages || [], (msg: CloudMessage) => {
        Row({ space: 10 }) {
          Circle()
            .width(36).height(36)
            .fill(msg.from === '救助人' ? '#DBEAFE' : '#FEF3C7')

          Text(msg.from === '救助人' ? '👩‍⚕️' : '😊')
            .fontSize(16)

          Column({ space: 4 }) {
            Text(msg.from === '救助人' ? msg.from : '我')
              .fontSize(12).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
            Text(msg.content).fontSize(13).fontColor(CommonStyles.TEXT_SECONDARY)
            Text(msg.time).fontSize(10).fontColor(CommonStyles.TEXT_TERTIARY)
          }
          .layoutWeight(1).alignItems(HorizontalAlign.Start)
        }
        .width('100%').padding(12)
        .backgroundColor('#F8FAFC')
        .borderRadius(CommonStyles.RADIUS_MD)
      })
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SM)
  }

  @Builder
  HowItWorks() {
    Column({ space: 14 }) {
      Text('云养宠如何工作')
        .fontSize(16).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)

      this.StepItem('1', '选择一只宠物', '浏览可云养的流浪动物，选择你想关注的那一只')
      this.StepItem('2', '远程互动', '通过投喂、玩耍、发消息等方式与TA互动')
      this.StepItem('3', '查看成长', '实时了解TA的生活状态、健康状况和成长数据')
      this.StepItem('4', '升级领养', '当条件成熟时，可将云养转为正式领养')
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SM)
    .margin({ top: 8 })
  }

  @Builder
  StepItem(num: string, title: string, desc: string) {
    Row({ space: 12 }) {
      Text(num)
        .fontSize(14).fontWeight(FontWeight.Bold).fontColor('#FFFFFF')
        .width(24).height(24)
        .backgroundColor(CommonStyles.PRIMARY)
        .borderRadius(12)
        .textAlign(TextAlign.Center)
        .padding({ top: 4 })

      Column({ space: 2 }) {
        Text(title).fontSize(14).fontWeight(FontWeight.Medium).fontColor(CommonStyles.TEXT_PRIMARY)
        Text(desc).fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
      }
      .layoutWeight(1).alignItems(HorizontalAlign.Start)
    }
  }

  private doAction(action: string): void {
    if (!this.selectedCloudPet) return;

    switch (action) {
      case 'feed':
        this.selectedCloudPet.feedCount++;
        this.updateAffection(3);
        promptAction.showToast({ message: `已为 ${this.selectedCloudPet.pet.name} 投喂一次！` });
        break;
      case 'play':
        this.selectedCloudPet.playCount++;
        this.updateAffection(5);
        promptAction.showToast({ message: `和 ${this.selectedCloudPet.pet.name} 玩耍了一会！` });
        break;
      case 'love':
        this.updateAffection(2);
        promptAction.showToast({ message: `${this.selectedCloudPet.pet.name} 感受到了你的爱意！` });
        break;
      case 'message':
        const newMsg: CloudMessage = {
          id: Date.now(),
          from: '我',
          content: ['加油好好吃饭哦！', '想你了～', '要乖乖的呀！', '今天也要开心！'][Math.floor(Math.random() * 4)],
          time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
        };
        this.selectedCloudPet.messages.unshift(newMsg);
        this.updateAffection(1);
        promptAction.showToast({ message: '消息已发送给救助站' });
        break;
    }
    this.selectedCloudPet.lastInteraction = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  }

  private updateAffection(amount: number): void {
    if (this.selectedCloudPet) {
      this.selectedCloudPet.affectionLevel = Math.min(100, this.selectedCloudPet.affectionLevel + amount);
    }
  }

  private calcDays(): string {
    if (!this.selectedCloudPet) return '0天';
    const start: Date = new Date(this.selectedCloudPet.adoptedAt);
    const now: Date = new Date();
    const diff: number = Math.floor((now.getTime() - start.getTime()) / (1000 * 60 * 60 * 24));
    return `${diff}天`;
  }

  private randomPastDate(): string {
    const daysAgo: number = Math.floor(Math.random() * 30) + 1;
    const d: Date = new Date();
    d.setDate(d.getDate() - daysAgo);
    return d.toISOString().split('T')[0];
  }

  private randomPastTime(): string {
    const hours: number = Math.floor(Math.random() * 12) + 1;
    const mins: number = Math.floor(Math.random() * 60);
    return `${hours.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}`;
  }
}
