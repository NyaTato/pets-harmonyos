﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿import { CommonStyles } from '../common/css/CommonStyles';
import { RouterHelper } from '../router/RouterHelper';
import { Pet, petList } from '../mock/PetData';
import { promptAction } from '@kit.ArkUI';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';

interface PetLevelInfo {
  level: number;
  levelName: string;
  xpCurrent: number;
  xpToNext: number;
  totalXp: number;
}

interface Achievement {
  id: string;
  icon: string;
  name: string;
  desc: string;
  unlocked: boolean;
  unlockedAt?: string;
}

interface LevelPrivilege {
  level: number;
  privilege: string;
}

@Entry
@Component
struct PetLevelSystem {
  @State private selectedPetIndex: number = 0;
  @State private levelInfo: PetLevelInfo | null = null;
  @State private isLevelingUp: boolean = false;
  @State private showAchievement: boolean = false;
  @State private newAchievement: Achievement | null = null;

  private pets: Pet[] = [];
  private achievements: Achievement[] = [];
  private privileges: LevelPrivilege[] = [];

  private levelNames: string[] = ['萌新', '成长中', '小伙伴', '好伙伴', '家人', '挚爱', '灵魂伴侣'];
  private levelColors: string[] = ['#9CA3AF', '#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6', '#F43F5E'];

  aboutToAppear(): void {
    this.pets = petList.slice(0, 5);
    this.initAchievements();
    this.initPrivileges();
    if (this.pets.length > 0) {
      this.loadLevelData(this.pets[0].id);
    }
  }

  private initAchievements(): void {
    this.achievements = [
      { id: 'first_login', icon: '🎉', name: '初次见面', desc: '第一次查看宠物信息', unlocked: true, unlockedAt: '2024-01-15' },
      { id: 'first_like', icon: '❤️', name: '心动时刻', desc: '第一次为宠物点赞', unlocked: true, unlockedAt: '2024-01-16' },
      { id: 'share_card', icon: '🎴', name: '爱心传播者', desc: '生成第一张分享卡片', unlocked: false },
      { id: 'match_test', icon: '🎴', name: '缘分测试', desc: '完成宠物匹配测试', unlocked: true, unlockedAt: '2024-02-01' },
      { id: 'apply_adopt', icon: '📋', name: '正式申请', desc: '提交领养申请', unlocked: false },
      { id: 'week_active', icon: '🔥', name: '连续活跃', desc: '连续7天登录查看', unlocked: false },
      { id: 'collect_10', icon: '⭐', name: '收藏达人', desc: '收藏10只宠物', unlocked: false },
      { id: 'level_3', icon: '🏆', name: '好伙伴', desc: '宠物达到3级', unlocked: false }
    ];
  }

  private initPrivileges(): void {
    this.privileges = [
      { level: 1, privilege: '基础资料查看' },
      { level: 2, privilege: '收藏和点赞' },
      { level: 2, privilege: '浏览历史记录' },
      { level: 3, privilege: '发送消息给救助人' },
      { level: 3, privilege: '提交领养申请' },
      { level: 4, privilege: '优先审核通道' },
      { level: 4, privilege: '专属客服支持' },
      { level: 5, privilege: '免押金领养' },
      { level: 5, privilege: '新宠优先选择权' },
      { level: 6, privilege: '年度免费体检' },
      { level: 7, privilege: '一对一专属顾问' }
    ];
  }

  private loadLevelData(petId: number): void {
    const baseXp = petId * 137 % 5000;
    const level = Math.min(7, Math.floor(baseXp / 800) + 1);
    const xpInLevel = baseXp - (level - 1) * 800;
    const xpNeeded = level >= 7 ? 9999 : 800;

    this.levelInfo = {
      level: level,
      levelName: this.levelNames[level - 1] || '未知',
      xpCurrent: Math.min(xpInLevel, xpNeeded),
      xpToNext: xpNeeded,
      totalXp: baseXp
    };
  }

  private addXp(amount: number): void {
    if (!this.levelInfo || this.isLevelingUp) return;

    const newXp = this.levelInfo.xpCurrent + amount;
    if (newXp >= this.levelInfo.xpToNext && this.levelInfo.level < 7) {
      this.isLevelingUp = true;

      setTimeout(() => {
        if (this.levelInfo) {
          this.levelInfo.level++;
          this.levelInfo.levelName = this.levelNames[this.levelInfo.level - 1];
          this.levelInfo.xpCurrent = newXp - this.levelInfo.xpToNext;
          this.levelInfo.totalXp += newXp;

          const nextAch = this.achievements.find((a: Achievement) =>
            a.id === `level_${this.levelInfo!.level}` && !a.unlocked
          );
          if (nextAch) {
            nextAch.unlocked = true;
            nextAch.unlockedAt = new Date().toISOString().split('T')[0];
            this.newAchievement = nextAch;
            this.showAchievement = true;
          }
        }
        this.isLevelingUp = false;
        promptAction.showToast({ message: `升级了！当前等级: ${this.levelInfo?.levelName}` });
      }, 1200);
    } else {
      this.levelInfo.xpCurrent = newXp;
      this.levelInfo.totalXp += amount;
      promptAction.showToast({ message: `+${amount} 经验值` });
    }
  }

  build() {
    Column() {
      SafeArea({ edges: ['top'] }) {
        Row() {
          BackButton()
          Text('等级成长体系')
            .fontSize(18).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
            .layoutWeight(1)
        }
        .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })
        .backgroundColor('#FFFFFF')

        Scroll() {
          Column({ space: 20 }) {

            // 宠物选择器
            this.PetSelector()

            if (this.levelInfo) {
              // 等级展示卡片
              this.LevelCard()

              // 经验值操作区
              this.XpActions()

              // 成就徽章
              this.AchievementSection()

              // 等级特权
              this.PrivilegeSection()
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
  PetSelector() {
    Text('我的宠物')
      .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)

    Scroll() {
      Row({ space: 12 }) {
        ForEach(this.pets, (pet: Pet, index: number) => {
          Column({ space: 6 }) {
            Stack({ alignContent: Alignment.Bottom }) {
              Image(pet.images && pet.images.length > 0 ? $rawfile(pet.images[0]) : '')
                .width(60).height(60).objectFit(ImageFit.Cover)
                .borderRadius(30)

              if (this.selectedPetIndex === index) {
                Circle()
                  .width(60).height(60)
                  .fill(CommonStyles.PRIMARY)
                  .opacity(0.2)
              }
            }

            Text(pet.name)
              .fontSize(11).fontColor(CommonStyles.TEXT_SECONDARY)
              .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
              .width(64)
          }
          .onClick(() => {
            this.selectedPetIndex = index;
            this.loadLevelData(pet.id);
          })
        })
      }
    }
    .scrollable(ScrollDirection.Horizontal).scrollBar(BarState.Off)
    .width('100%').margin({ top: 12 })
  }

  @Builder
  LevelCard() {
    if (this.levelInfo === null) {
      Column({ space: 12 }) {
        Text('🐾').fontSize(40).fontColor(CommonStyles.TEXT_TERTIARY)
        Text('请选择一只宠物查看等级')
          .fontSize(14).fontColor(CommonStyles.TEXT_SECONDARY)
      }
      .width('100%').padding(32)
      .backgroundColor('#FFFFFF')
      .borderRadius(CommonStyles.RADIUS_LG)
      .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
    } else {
      Column({ space: 20 }) {
        Stack({ alignContent: Alignment.Center }) {
          Circle()
            .width(180).height(180)
            .fill('#F1F5F9')

          Progress({
            value: this.levelInfo.xpCurrent,
            total: this.levelInfo.xpToNext,
            type: ProgressType.Ring
          })
            .width(160).height(160)
            .color(this.levelColors[this.levelInfo.level - 1])
            .backgroundColor('#E5E7EB')

          Column({ space: 6 }) {
            Text(`Lv.${this.levelInfo.level}`)
              .fontSize(28).fontWeight(FontWeight.Bold)
              .fontColor(this.levelColors[this.levelInfo.level - 1])

            Text(this.levelInfo.levelName)
              .fontSize(15).fontColor(CommonStyles.TEXT_SECONDARY)

            Text(`${this.levelInfo.xpCurrent} / ${this.levelInfo.xpToNext} XP`)
              .fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
          }

          if (this.isLevelingUp) {
            Text('🎉 升级中...')
              .fontSize(16).fontWeight(FontWeight.Bold)
              .fontColor(CommonStyles.PRIMARY)
              .margin({ bottom: 100 })
          }
        }
        .width(220).height(220)

        Text(`总经验值: ${this.levelInfo.totalXp.toLocaleString()}`)
          .fontSize(13).fontColor(CommonStyles.TEXT_TERTIARY)

        Text(this.getLevelQuote())
          .fontSize(14).fontColor(CommonStyles.TEXT_SECONDARY)
          .textAlign(TextAlign.Center)
          .width('80%')
      }
      .width('100%').padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(CommonStyles.RADIUS_XL)
      .shadow(CommonStyles.SHADOW_LG)
      .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
    }
  }

  @Builder
  XpActions() {
    Column({ space: 14 }) {
      Text('获取经验值')
        .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)

      Grid() {
        this.XpActionItem('👀', '浏览详情', '+10', () => this.addXp(10))
        this.XpActionItem('❤️', '点赞宠物', '+5', () => this.addXp(5))
        this.XpActionItem('📝', '提交反馈', '+20', () => this.addXp(20))
        this.XpActionItem('📤', '分享卡片', '+15', () => this.addXp(15))
      }
      .columnsTemplate('1fr 1fr')
      .rowsGap(10).columnsGap(10)
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
  }

  @Builder
  XpActionItem(icon: string, label: string, xp: string, action: () => void) {
    Column({ space: 8 }) {
      Text(icon).fontSize(24)
      Text(label).fontSize(12).fontColor(CommonStyles.TEXT_SECONDARY)
      Text(xp).fontSize(11).fontWeight(FontWeight.Bold)
        .fontColor(CommonStyles.SUCCESS)
        .padding({ left: 6, right: 6, top: 2, bottom: 2 })
        .backgroundColor(CommonStyles.SUCCESS + '15')
        .borderRadius(CommonStyles.RADIUS_SM)
    }
    .height(76).layoutWeight(1)
    .backgroundColor('#F8FAFC')
    .borderRadius(CommonStyles.RADIUS_MD)
    .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
    .onClick(action)
  }

  @Builder
  AchievementSection() {
    Column({ space: 14 }) {
      Row() {
        Text('成就徽章')
          .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)
        Blank()
        Text(`${this.achievements.filter((a: Achievement) => a.unlocked).length}/${this.achievements.length}`)
          .fontSize(12).fontColor(CommonStyles.TEXT_TERTIARY)
      }

      Grid() {
        ForEach(this.achievements, (ach: Achievement) => {
          GridItem() {
            Column({ space: 8 }) {
              Stack({ alignContent: Alignment.Center }) {
                Circle()
                  .width(44).height(44)
                  .fill(ach.unlocked ? '#FEF3C7' : '#F1F5F9')

                Text(ach.icon)
                  .fontSize(20)
                  .opacity(ach.unlocked ? 1 : 0.4)
              }

              Text(ach.name)
                .fontSize(11)
                .fontWeight(ach.unlocked ? FontWeight.Medium : FontWeight.Normal)
                .fontColor(ach.unlocked ? CommonStyles.TEXT_PRIMARY : CommonStyles.TEXT_TERTIARY)
                .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })

              if (ach.unlocked && ach.unlockedAt) {
                Text(ach.unlockedAt)
                  .fontSize(9).fontColor(CommonStyles.SUCCESS)
              }
            }
            .padding(10)
            .backgroundColor('#FFFFFF')
            .borderRadius(CommonStyles.RADIUS_MD)
            .shadow(CommonStyles.SHADOW_SM)
            .opacity(ach.unlocked ? 1 : 0.6)
            .onClick(() => {
              if (ach.unlocked) {
                promptAction.showToast({ message: `${ach.name}: ${ach.desc}` });
              } else {
                promptAction.showToast({ message: '完成对应任务后解锁' });
              }
            })
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsGap(10).columnsGap(10)
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
  }

  @Builder
  PrivilegeSection() {
    Column({ space: 14 }) {
      Text('等级特权解锁')
        .fontSize(17).fontWeight(FontWeight.Bold).fontColor(CommonStyles.TEXT_PRIMARY)

      Column({ space: 0 }) {
        ForEach([1, 2, 3, 4, 5, 6, 7], (lv: number) => {
          Row() {
            Text(`Lv.${lv}`)
              .width(40).fontSize(12).fontWeight(FontWeight.Bold)
              .fontColor(lv <= this.levelInfo!.level ? this.levelColors[lv - 1] : '#D1D5DB')

            Column() {
              ForEach(this.getPrivilegesForLevel(lv), (priv: LevelPrivilege) => {
                Text(priv.privilege)
                  .fontSize(11).fontColor(
                    lv <= this.levelInfo!.level ? CommonStyles.TEXT_PRIMARY : CommonStyles.TEXT_TERTIARY
                  )
                  .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
              })
            }
            .layoutWeight(1)

            Text(lv <= this.levelInfo!.level ? '已解锁' : `${lv}级`)
              .fontSize(10)
              .fontColor(lv <= this.levelInfo!.level ? CommonStyles.SUCCESS : '#D1D5DB')
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .backgroundColor(lv <= this.levelInfo!.level ? CommonStyles.SUCCESS + '15': '#F1F5F9')
              .borderRadius(CommonStyles.RADIUS_FULL)
          }
          .width('100%')
          .padding(12)
          .margin({ bottom: 6 })
          .backgroundColor('#FFFFFF')
          .borderRadius(CommonStyles.RADIUS_MD)
          .opacity(lv <= this.levelInfo!.level + 1 ? 1 : 0.5)
        })
      }
    }
    .width('100%').padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
  }

  private getLevelQuote(): string {
    const quotes: string[] = [
      '每个生命都值得被温柔以待',
      '陪伴是最长情的告白',
      '从陌生到熟悉，只需要一个眼神',
      'TA在等你，给TA一个家',
      '爱是双向奔赴的温暖',
      '最好的关系是彼此成就',
      '灵魂伴侣，命中注定'
    ];
    return quotes[Math.min(this.levelInfo!.level - 1, quotes.length - 1)];
  }

  private getPrivilegesForLevel(lv: number): LevelPrivilege[] {
    return this.privileges.filter((p: LevelPrivilege) => p.level <= lv).slice(0, 2);
  }
}
