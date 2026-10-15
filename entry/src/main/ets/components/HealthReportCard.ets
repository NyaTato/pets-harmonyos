// 健康报告卡片组件
import { CommonStyles } from '../common/css/CommonStyles';
import { Pet } from '../mock/PetData';
import { HealthService } from '../services/HealthService';
import { DateUtils } from '../utils/DateUtils';

@Component
export struct HealthReportCard {
  @Prop pet: Pet;
  @Prop showDetails: boolean = false;
  // 使用普通属性而不是@Prop，因为@Prop不支持函数类型
  private onViewReport?: () => void;

  @State private moodStats: Record<string, number> = {};
  @State private healthAdvice: string[] = [];
  @State private isLoading: boolean = true;

  aboutToAppear() {
    this.loadHealthData();
  }

  private async loadHealthData() {
    this.isLoading = true;

    // 模拟加载延迟
    setTimeout(() => {
      this.moodStats = HealthService.getPetMoodStats(this.pet.id, 7);
      this.healthAdvice = HealthService.analyzeHealthAdvice(this.pet, this.moodStats);
      this.isLoading = false;
    }, 300);
  }

  // 获取心情图标
  private getMoodIcon(mood: string): string {
    const icons: Record<string, string> = {
      'happy': 'common/images/mood_happy.png',
      'normal': 'common/images/mood_normal.png',
      'sad': 'common/images/mood_sad.png',
      'lonely': 'common/images/mood_lonely.png'
    };
    return icons[mood] || 'common/images/mood_normal.png';
  }

  // 获取心情颜色
  private getMoodColor(mood: string): string {
    const colors: Record<string, string> = {
      'happy': CommonStyles.SUCCESS_COLOR,
      'normal': CommonStyles.INFO_COLOR,
      'sad': CommonStyles.WARNING_COLOR,
      'lonely': CommonStyles.DANGER_COLOR
    };
    return colors[mood] || CommonStyles.TEXT_TERTIARY;
  }

  // 获取心情文本
  private getMoodText(mood: string): string {
    const texts: Record<string, string> = {
      'happy': '开心',
      'normal': '普通',
      'sad': '难过',
      'lonely': '孤独'
    };
    return texts[mood] || mood;
  }

  build() {
    Column({ space: CommonStyles.SPACE_MD }) {
      // 标题栏
      Row({ space: CommonStyles.SPACE_SM }) {
        Image('common/images/health_icon.png')
          .width(20)
          .height(20)
          .objectFit(ImageFit.Contain)

        Text('健康报告')
          .fontSize(CommonStyles.FONT_SIZE_LG)
          .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
          .fontColor(CommonStyles.TEXT_PRIMARY)

        if (this.pet.health.includes('需要关注')) {
          Text('需关注')
            .fontSize(CommonStyles.FONT_SIZE_XS)
            .fontColor(CommonStyles.WHITE)
            .backgroundColor(CommonStyles.DANGER_COLOR)
            .padding({
              left: CommonStyles.SPACE_SM,
              right: CommonStyles.SPACE_SM,
              top: 2,
              bottom: 2
            })
            .borderRadius(CommonStyles.RADIUS_SM)
            .margin({ left: CommonStyles.SPACE_SM })
        }
      }
      .width('100%')

      if (this.isLoading) {
        // 加载中
        Row() {
          LoadingProgress()
            .width(20)
            .height(20)
            .color($r('app.color.primary'))

          Text('加载健康数据....')
            .fontSize(CommonStyles.FONT_SIZE_SM)
            .fontColor(CommonStyles.TEXT_TERTIARY)
            .margin({ left: CommonStyles.SPACE_SM })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding(CommonStyles.SPACE_MD)
      } else {
        // 基本信息
        Row({ space: CommonStyles.SPACE_LG }) {
          // 健康状况
          Column({ space: CommonStyles.SPACE_XS }) {
            Text('健康状况')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(CommonStyles.TEXT_TERTIARY)

            Text(this.pet.health)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
              .fontColor(this.getHealthColor())
          }
          .layoutWeight(1)

          // 疫苗接种
          Column({ space: CommonStyles.SPACE_XS }) {
            Text('疫苗接种')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(CommonStyles.TEXT_TERTIARY)

            Text(this.pet.vaccine)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
              .fontColor(CommonStyles.TEXT_PRIMARY)
          }
          .layoutWeight(1)

          // 绝育情况
          Column({ space: CommonStyles.SPACE_XS }) {
            Text('绝育情况')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(CommonStyles.TEXT_TERTIARY)

            Text(this.pet.sterilize)
              .fontSize(CommonStyles.FONT_SIZE_MD)
              .fontWeight(CommonStyles.FONT_WEIGHT_MEDIUM)
              .fontColor(CommonStyles.TEXT_PRIMARY)
          }
          .layoutWeight(1)
        }
        .width('100%')
        .padding({ top: CommonStyles.SPACE_SM, bottom: CommonStyles.SPACE_SM })

        // 心情统计
        if (Object.keys(this.moodStats).length > 0) {
          Column({ space: CommonStyles.SPACE_SM }) {
            Text('最近7天心情记录')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(CommonStyles.TEXT_TERTIARY)
              .width('100%')

            Row({ space: CommonStyles.SPACE_MD }) {
              ForEach(Object.keys(this.moodStats), (mood: string) => {
                Column({ space: CommonStyles.SPACE_XS }) {
                  Image(this.getMoodIcon(mood))
                    .width(24)
                    .height(24)
                    .objectFit(ImageFit.Contain)

                  Text(this.getMoodText(mood))
                    .fontSize(CommonStyles.FONT_SIZE_XS)
                    .fontColor(CommonStyles.TEXT_SECONDARY)

                  Text(this.moodStats[mood].toString())
                    .fontSize(CommonStyles.FONT_SIZE_MD)
                    .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
                    .fontColor(this.getMoodColor(mood))
                }
                .layoutWeight(1)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
              })
            }
            .width('100%')
            .padding(CommonStyles.SPACE_SM)
            .backgroundColor(CommonStyles.GRAY_500)
            .borderRadius(CommonStyles.RADIUS_MD)
          }
          .width('100%')
        }

        // 健康建议
        if (this.healthAdvice.length > 0 && this.showDetails) {
          Column({ space: CommonStyles.SPACE_SM }) {
            Text('健康建议')
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(CommonStyles.TEXT_TERTIARY)
              .width('100%')

            Column({ space: CommonStyles.SPACE_XS }) {
              ForEach(this.healthAdvice, (advice: string, index: number) => {
                Row({ space: CommonStyles.SPACE_SM }) {
                  Text('•')
                    .fontSize(CommonStyles.FONT_SIZE_SM)
                    .fontColor(CommonStyles.PRIMARY_COLOR)

                  Text(advice)
                    .fontSize(CommonStyles.FONT_SIZE_SM)
                    .fontColor(CommonStyles.TEXT_SECONDARY)
                    .layoutWeight(1)
                }
                .width('100%')
              })
            }
            .padding(CommonStyles.SPACE_SM)
            .backgroundColor(CommonStyles.GRAY_100)
            .borderRadius(CommonStyles.RADIUS_MD)
          }
          .width('100%')
        }

        // 操作按钮
        if (!this.showDetails) {
          Button('查看详细报告')
            .width('100%')
            .height(36)
            .fontSize(CommonStyles.FONT_SIZE_MD)
            .fontColor(CommonStyles.PRIMARY_COLOR)
            .backgroundColor(CommonStyles.WHITE)
            .border({
              width: 1,
              color: CommonStyles.PRIMARY_COLOR
            })
            .borderRadius(CommonStyles.RADIUS_MD)
            .onClick(() => {
              if (this.onViewReport) {
                this.onViewReport();
              }
            })
            .margin({ top: CommonStyles.SPACE_SM })
        }
      }
    }
    .width('100%')
    .padding(CommonStyles.SPACE_LG)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
  }

  private getHealthColor(): string {
    if (this.pet.health.includes('良好')) {
      return CommonStyles.SUCCESS_COLOR;
    } else if (this.pet.health.includes('一般')) {
      return CommonStyles.WARNING_COLOR;
    } else if (this.pet.health.includes('需要关注')) {
      return CommonStyles.DANGER_COLOR;
    } else {
      return CommonStyles.TEXT_PRIMARY;
    }
  }
}
