import { CommonStyles } from '../common/css/CommonStyles';

interface SizeConfig {
  circleSize: number;
  fontSize: number;
  strokeWidth: number;
}

interface IconConfig {
  icon: string;
  color: string;
}

interface ScoreComposition {
  name: string;
  value: number;
  color: string;
}

@Component
export struct CreditScoreDisplay {
  @Prop score: number = 0; // 0-100
  @Prop showDetails: boolean = true;
  @Prop displaySize: 'small' | 'medium' | 'large' = 'medium';

  private getSizeConfig(): SizeConfig {
    switch (this.displaySize) {
      case 'small':
        return { circleSize: 60, fontSize: 16, strokeWidth: 6 } as SizeConfig;
      case 'large':
        return { circleSize: 120, fontSize: 24, strokeWidth: 10 } as SizeConfig;
      case 'medium':
      default:
        return { circleSize: 80, fontSize: 20, strokeWidth: 8 } as SizeConfig;
    }
  }

  private getScoreColor(): string {
    if (this.score >= 90) return '#34C759'; // 优秀 - 绿色
    if (this.score >= 80) return '#5AC8FA'; // 良好 - 蓝色
    if (this.score >= 70) return '#FF9500'; // 中等 - 橙色
    if (this.score >= 60) return '#AF52DE'; // 一般 - 紫色
    return '#FF3B30'; // 较差 - 红色
  }

  private getScoreLevel(): string {
    if (this.score >= 90) return '优秀';
    if (this.score >= 80) return '良好';
    if (this.score >= 70) return '中等';
    if (this.score >= 60) return '一般';
    return '较差';
  }

  private getScoreDescription(): string {
    if (this.score >= 90) return '信用极好，领养成功能率很高';
    if (this.score >= 80) return '信用良好，适合领养宠物';
    if (this.score >= 70) return '信用中等，可以尝试领养';
    if (this.score >= 60) return '信用一般，需要提升信用分';
    return '信用较差，建议先提升信用分';
  }

  build() {
    Column({ space: CommonStyles.SPACE_MD }) {
      // 信用分圆形图表
      Stack() {
        // 背景圆
        Circle({ width: this.getSizeConfig().circleSize, height: this.getSizeConfig().circleSize })
          .fill(CommonStyles.GRAY_100)

        // 进度圆环
        Circle({ width: this.getSizeConfig().circleSize, height: this.getSizeConfig().circleSize })
          .fillOpacity(0)
          .stroke(this.getScoreColor())
          .strokeWidth(this.getSizeConfig().strokeWidth)
          .strokeDashArray([this.score * 3.6, 360])

        // 分数显示
        Column() {
          Text(this.score.toString())
            .fontSize(this.getSizeConfig().fontSize)
            .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
            .fontColor(CommonStyles.TEXT_PRIMARY)

          Text('分')
            .fontSize(this.getSizeConfig().fontSize * 0.6)
            .fontColor(CommonStyles.TEXT_SECONDARY)
            .margin({ top: -4 })
        }
      }
      .width(this.getSizeConfig().circleSize)
      .height(this.getSizeConfig().circleSize)

      // 信用等级和描述
      Column() {
        if (this.showDetails) {
          Column({ space: CommonStyles.SPACE_XS }) {
            // 信用等级
            Row({ space: CommonStyles.SPACE_SM }) {
              Text(this.getScoreLevel())
                .fontSize(CommonStyles.FONT_SIZE_LG)
                .fontWeight(CommonStyles.FONT_WEIGHT_BOLD)
                .fontColor(this.getScoreColor())

              // 等级图标
              this.getLevelIcon(this.getScoreLevel())
            }

            // 信用描述
            Text(this.getScoreDescription())
              .fontSize(CommonStyles.FONT_SIZE_SM)
              .fontColor(CommonStyles.TEXT_SECONDARY)
              .textAlign(TextAlign.Center)
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .width('80%')
          }
          .width('100%')
        }
      }
    }
    .padding(CommonStyles.SPACE_MD)
    .backgroundColor(CommonStyles.WHITE)
    .borderRadius(CommonStyles.RADIUS_LG)
    .shadow(CommonStyles.SHADOW_SM)
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  getLevelIconConfig(level: string): IconConfig {
    if (level === '优秀') {
      return { icon: '⭐', color: '#FFD700' };
    } else if (level === '良好') {
      return { icon: '👍', color: '#34C759' };
    } else if (level === '中等') {
      return { icon: '👉', color: '#FF9500' };
    } else if (level === '一般') {
      return { icon: '👌', color: '#AF52DE' };
    } else if (level === '较差') {
      return { icon: '⚠️', color: '#FF3B30' };
    }
    return { icon: '👌', color: '#AF52DE' };
  }

  @Builder
  getLevelIcon(level: string) {
    Text(this.getLevelIconConfig(level).icon)
      .fontSize(20)
      .fontColor(this.getLevelIconConfig(level).color)
  }

  // 获取信用分建议
  getScoreSuggestions(): string[] {
    const suggestions: string[] = [];

    if (this.score < 60) {
      suggestions.push('完善个人信息，完成实名认证');
      suggestions.push('多参与社区互动，发表优质内容');
      suggestions.push('按时完成宠物云养任务');
      suggestions.push('遵守社区规则，避免违规行为');
    } else if (this.score < 70) {
      suggestions.push('保持良好互动记录');
      suggestions.push('参与更多宠物相关活动');
      suggestions.push('完善领养申请资料');
    } else if (this.score < 80) {
      suggestions.push('继续保持良好信用记录');
      suggestions.push('帮助其他用户解决问题');
      suggestions.push('分享养宠经验');
    } else if (this.score < 90) {
      suggestions.push('信用良好，继续保持');
      suggestions.push('可以考虑申请领养');
      suggestions.push('分享你的养宠故事');
    } else {
      suggestions.push('信用极好，是优质领养人');
      suggestions.push('可以优先获得领养资格');
      suggestions.push('考虑成为社区志愿者');
    }

    return suggestions;
  }

  // 获取信用分历史趋势（模拟数据）
  getScoreHistory(): number[] {
    // 生成模拟历史数据
    const history: number[] = [];
    let currentScore = Math.max(60, this.score - 20);

    for (let i = 0; i < 6; i++) {
      history.push(currentScore);
      currentScore += Math.floor(Math.random() * 10) + 5;
      if (currentScore > this.score) {
        currentScore = this.score;
      }
    }
    history.push(this.score);

    return history;
  }

  // 获取信用分构成（模拟数据）
  getScoreComposition(): ScoreComposition[] {
    const composition: ScoreComposition[] = [
      { name: '基本信息', value: 20, color: '#4A90E2' },
      { name: '互动记录', value: 30, color: '#34C759' },
      { name: '社区贡献', value: 25, color: '#FF9500' },
      { name: '信用历史', value: 15, color: '#AF52DE' },
      { name: '其他因素', value: 10, color: '#8E8E93' }
    ];
    return composition;
  }
}
