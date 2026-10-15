// 宠物情绪系统
export interface MoodData {
  mood: string; // 当前情绪
  level: number; // 情绪等级 0-100
  lastUpdate: string; // 最后更新时间
  history: MoodHistory[]; // 情绪历史
}

export interface MoodHistory {
  mood: string;
  level: number;
  reason: string;
  timestamp: string;
}

export interface MoodEffect {
  mood: string;
  emoji: string;
  color: string;
  description: string;
  effects: string[];
}

// 情绪定义 - 使用类型安全的对象
const happyEffect: MoodEffect = {
  mood: '开心',
  emoji: '😊',
  color: '#34C759', // 绿色
  description: '宠物心情很好，活泼可爱',
  effects: ['互动效率+20%', '健康恢复+10%', '亲密度增长加速']
};

const excitedEffect: MoodEffect = {
  mood: '兴奋',
  emoji: '🤩',
  color: '#FF9500', // 橙色
  description: '宠物非常兴奋，精力充沛',
  effects: ['活动需求增加', '食欲增加', '需要更多陪伴']
};

const calmEffect: MoodEffect = {
  mood: '平静',
  emoji: '😌',
  color: '#5AC8FA', // 蓝色
  description: '宠物状态平稳，正常活动',
  effects: ['正常互动效率', '正常健康恢复', '稳定成长']
};

const normalEffect: MoodEffect = {
  mood: '普通',
  emoji: '😐',
  color: '#8E8E93', // 灰色
  description: '宠物情绪一般，需要关怀',
  effects: ['正常互动效率', '健康恢复正常', '需要适当关注']
};

const sadEffect: MoodEffect = {
  mood: '委屈',
  emoji: '😔',
  color: '#AF52DE', // 紫色
  description: '宠物有点不开心，需要安慰',
  effects: ['互动效率-10%', '健康恢复减慢', '需要安慰']
};

const lonelyEffect: MoodEffect = {
  mood: '孤独',
  emoji: '😢',
  color: '#FF3B30', // 红色
  description: '宠物感到孤独，需要陪伴',
  effects: ['互动效率-20%', '健康恢复-15%', '亲密度下降']
};

const angryEffect: MoodEffect = {
  mood: '生气',
  emoji: '😠',
  color: '#FF2D55', // 红色
  description: '宠物生气了，需要小心对待',
  effects: ['互动效率-30%', '可能拒绝互动', '需要耐心安抚']
};

const sickEffect: MoodEffect = {
  mood: '生病',
  emoji: '🤒',
  color: '#5856D6', // 紫色
  description: '宠物身体不适，需要照顾',
  effects: ['互动效率-50%', '健康值下降', '需要医疗照顾']
};

// 定义情绪效果映射类型
interface MoodEffectsMap {
  开心: MoodEffect;
  兴奋: MoodEffect;
  平静: MoodEffect;
  普通: MoodEffect;
  委屈: MoodEffect;
  孤独: MoodEffect;
  生气: MoodEffect;
  生病: MoodEffect;
}

export const MOOD_EFFECTS: MoodEffectsMap = {
  '开心': happyEffect,
  '兴奋': excitedEffect,
  '平静': calmEffect,
  '普通': normalEffect,
  '委屈': sadEffect,
  '孤独': lonelyEffect,
  '生气': angryEffect,
  '生病': sickEffect
};

// 情绪变化原因
const positiveReasons: string[] = [
  '被点赞',
  '被收藏',
  '被喂食',
  '被抚摸',
  '被夸奖',
  '获得新玩具',
  '外出散步',
  '与其他宠物玩耍'
];

const negativeReasons: string[] = [
  '被忽视',
  '被批评',
  '饥饿',
  '生病',
  '环境变化',
  '与其他宠物冲突',
  '天气不好',
  '孤独'
];

// 定义情绪变化原因类型
interface MoodChangeReasonsMap {
  POSITIVE: string[];
  NEGATIVE: string[];
}

export const MOOD_CHANGE_REASONS: MoodChangeReasonsMap = {
  POSITIVE: positiveReasons,
  NEGATIVE: negativeReasons
};

// 模拟宠物情绪数据
const petMoods: Map<number, MoodData> = new Map();

// 初始化宠物情绪
export function initPetMoods(petIds: number[]): void {
  petIds.forEach(petId => {
    if (!petMoods.has(petId)) {
      const initialMood = Math.random() > 0.7 ? '开心' :
        Math.random() > 0.5 ? '平静' :
          Math.random() > 0.3 ? '普通' : '委屈';

      petMoods.set(petId, {
        mood: initialMood,
        level: getRandomInt(60, 90),
        lastUpdate: new Date().toISOString(),
        history: [{
          mood: initialMood,
          level: getRandomInt(60, 90),
          reason: '初始状态',
          timestamp: new Date().toISOString()
        }]
      });
    }
  });
}

// 获取宠物情绪
export function getPetMood(petId: number): MoodData | undefined {
  return petMoods.get(petId);
}

// 更新宠物情绪
export function updatePetMood(petId: number, newMood: string, reason: string): MoodData | null {
  const moodData = petMoods.get(petId);
  if (!moodData) return null;

  // 计算情绪等级变化
  const moodEffects = getMoodEffect(newMood);
  let levelChange = 0;

  if (MOOD_CHANGE_REASONS.POSITIVE.includes(reason)) {
    levelChange = getRandomInt(5, 15);
  } else if (MOOD_CHANGE_REASONS.NEGATIVE.includes(reason)) {
    levelChange = getRandomInt(-15, -5);
  } else {
    levelChange = getRandomInt(-5, 5);
  }

  const newLevel = Math.max(0, Math.min(100, moodData.level + levelChange));

  // 创建新的情绪记录
  const newMoodData: MoodData = {
    mood: newMood,
    level: newLevel,
    lastUpdate: new Date().toISOString(),
    history: moodData.history.concat({
      mood: newMood,
      level: newLevel,
      reason: reason,
      timestamp: new Date().toISOString()
    }).slice(-10) // 只保留最近10条记录
  };

  petMoods.set(petId, newMoodData);
  return newMoodData;
}

// 根据互动更新情绪
export function updateMoodByInteraction(petId: number, interactionType: string): MoodData | null {
  let reason = '正常互动';
  if (interactionType === 'like') {
    reason = '被点赞';
  } else if (interactionType === 'favorite') {
    reason = '被收藏';
  } else if (interactionType === 'view') {
    reason = '被浏览';
  } else if (interactionType === 'feed') {
    reason = '被喂食';
  } else if (interactionType === 'play') {
    reason = '被玩耍';
  } else if (interactionType === 'groom') {
    reason = '被梳理';
  } else if (interactionType === 'pet') {
    reason = '被抚摸';
  } else if (interactionType === 'ignore') {
    reason = '被忽视';
  }

  const moodChange = getMoodChangeByInteraction(interactionType);

  return updatePetMood(petId, moodChange, reason);
}

// 根据互动类型获取情绪变化
function getMoodChangeByInteraction(interactionType: string): string {
  if (interactionType === 'like') return '开心';
  if (interactionType === 'favorite') return '兴奋';
  if (interactionType === 'view') return '平静';
  if (interactionType === 'feed') return '开心';
  if (interactionType === 'play') return '兴奋';
  if (interactionType === 'groom') return '平静';
  if (interactionType === 'pet') return '开心';
  if (interactionType === 'ignore') return '委屈';
  return '普通';
}

// 自动更新情绪（模拟时间流逝）
export function autoUpdateMoods(): void {
  const now = new Date();

  petMoods.forEach((moodData, petId) => {
    const lastUpdate = new Date(moodData.lastUpdate);
    const hoursSinceUpdate = (now.getTime() - lastUpdate.getTime()) / (1000 * 60 * 60);

    // 如果超过2小时未更新，情绪可能变差
    if (hoursSinceUpdate > 2) {
      const newMood = moodData.level > 50 ? '普通' : '委屈';
      const reason = hoursSinceUpdate > 4 ? '长时间未互动' : '需要关怀';

      updatePetMood(petId, newMood, reason);
    }

    // 随机情绪波动
    if (Math.random() < 0.3) { // 30%概率发生情绪波动
      const randomChange = getRandomInt(-10, 10);
      const newLevel = Math.max(0, Math.min(100, moodData.level + randomChange));

      let newMood = moodData.mood;
      if (newLevel > 80) newMood = '开心';
      else if (newLevel > 60) newMood = '平静';
      else if (newLevel > 40) newMood = '普通';
      else if (newLevel > 20) newMood = '委屈';
      else newMood = '孤独';

      if (newMood !== moodData.mood) {
        updatePetMood(petId, newMood, '自然情绪波动');
      }
    }
  });
}

// 获取情绪趋势
export function getMoodTrend(petId: number): 'improving' | 'declining' | 'stable' {
  const moodData = petMoods.get(petId);
  if (!moodData || moodData.history.length < 2) return 'stable';

  const recentHistory = moodData.history.slice(-3);
  if (recentHistory.length < 2) return 'stable';

  const firstLevel = recentHistory[0].level;
  const lastLevel = recentHistory[recentHistory.length - 1].level;
  const difference = lastLevel - firstLevel;

  if (difference > 5) return 'improving';
  if (difference < -5) return 'declining';
  return 'stable';
}

// 获取情绪建议
export function getMoodSuggestions(petId: number): string[] {
  const moodData = petMoods.get(petId);
  if (!moodData) return ['暂无数据'];

  const suggestions: string[] = [];
  const moodEffect = getMoodEffect(moodData.mood);

  // 根据情绪给出建议
  switch (moodData.mood) {
    case '开心':
      suggestions.push('宠物心情很好，继续保持！');
      suggestions.push('可以尝试教它新技能');
      suggestions.push('适合进行互动游戏');
      break;
    case '兴奋':
      suggestions.push('宠物很兴奋，需要消耗精力');
      suggestions.push('带它出去散步或玩耍');
      suggestions.push('注意安全，避免过度兴奋');
      break;
    case '平静':
      suggestions.push('宠物状态平稳，正常照顾即可');
      suggestions.push('可以适当进行训练');
      suggestions.push('保持日常互动');
      break;
    case '普通':
      suggestions.push('宠物情绪一般，需要更多关怀');
      suggestions.push('多陪伴，增加互动');
      suggestions.push('检查食物和环境是否舒适');
      break;
    case '委屈':
      suggestions.push('宠物有点不开心，需要安慰');
      suggestions.push('给予零食或玩具');
      suggestions.push('多抚摸和说话安抚');
      break;
    case '孤独':
      suggestions.push('宠物感到孤独，需要陪伴');
      suggestions.push('增加互动时间');
      suggestions.push('考虑给它找个伙伴');
      break;
    case '生气':
      suggestions.push('宠物生气了，小心对待');
      suggestions.push('不要强迫互动');
      suggestions.push('给予空间，等它平静');
      break;
    case '生病':
      suggestions.push('宠物可能生病了，需要照顾');
      suggestions.push('检查身体状态');
      suggestions.push('如有需要，及时就医');
      break;
  }

  // 根据情绪等级给出额外建议
  if (moodData.level < 30) {
    suggestions.push('情绪较低，需要特别关怀');
    suggestions.push('考虑咨询宠物行为专家');
  } else if (moodData.level > 80) {
    suggestions.push('情绪很好，适合进行社交活动');
  }

  // 添加情绪效果说明
  if (moodEffect && moodEffect.effects) {
    for (let i = 0; i < moodEffect.effects.length; i++) {
      suggestions.push(`效果：${moodEffect.effects[i]}`);
    }
  }

  return suggestions;
}

// 图表数据接口
interface ChartData {
  labels: string[];
  data: number[];
}

// 获取情绪历史图表数据
export function getMoodHistoryChartData(petId: number): ChartData {
  const moodData = petMoods.get(petId);
  if (!moodData) {
    const emptyChartData: ChartData = { labels: [], data: [] };
    return emptyChartData;
  }

  const labels = moodData.history.map(record => {
    const date = new Date(record.timestamp);
    return `${date.getHours()}:${date.getMinutes().toString().padStart(2, '0')}`;
  });

  const data = moodData.history.map(record => record.level);

  const chartData: ChartData = { labels, data };
  return chartData;
}

// 情绪统计接口
interface MoodStats {
  averageMoodLevel: number;
  moodChanges: number;
  positiveChanges: number;
  negativeChanges: number;
  mostCommonMood: string;
}

// 获取情绪统计
export function getMoodStats(petId: number): MoodStats {
  const moodData = petMoods.get(petId);
  if (!moodData || moodData.history.length === 0) {
    const emptyStats: MoodStats = {
      averageMoodLevel: 0,
      moodChanges: 0,
      positiveChanges: 0,
      negativeChanges: 0,
      mostCommonMood: '未知'
    };
    return emptyStats;
  }

  const totalLevel = moodData.history.reduce((sum, record) => sum + record.level, 0);
  const averageMoodLevel = Math.round(totalLevel / moodData.history.length);

  let moodChanges = 0;
  let positiveChanges = 0;
  let negativeChanges = 0;
  const moodCounts: Record<string, number> = {};

  for (let i = 1; i < moodData.history.length; i++) {
    const prevMood = moodData.history[i - 1].mood;
    const currMood = moodData.history[i].mood;

    if (prevMood !== currMood) {
      moodChanges++;

      const prevLevel = moodData.history[i - 1].level;
      const currLevel = moodData.history[i].level;

      if (currLevel > prevLevel) {
        positiveChanges++;
      } else if (currLevel < prevLevel) {
        negativeChanges++;
      }
    }

    moodCounts[currMood] = (moodCounts[currMood] || 0) + 1;
  }

  let mostCommonMood = '未知';
  let maxCount = 0;
  const moodKeys = Object.keys(moodCounts);
  for (let i = 0; i < moodKeys.length; i++) {
    const mood = moodKeys[i];
    const count = moodCounts[mood];
    if (count > maxCount) {
      maxCount = count;
      mostCommonMood = mood;
    }
  }

  const stats: MoodStats = {
    averageMoodLevel,
    moodChanges,
    positiveChanges,
    negativeChanges,
    mostCommonMood
  };
  return stats;
}

// 宠物情绪状态接口
interface PetMoodStatus {
  petId: number;
  mood: string;
  level: number;
  emoji: string;
  color: string;
}

// 获取所有宠物情绪状态
export function getAllPetMoods(): PetMoodStatus[] {
  const result: PetMoodStatus[] = [];

  petMoods.forEach((moodData, petId) => {
    const moodEffect = getMoodEffect(moodData.mood) || getMoodEffect('普通');
    if (moodEffect) {
      result.push({
        petId,
        mood: moodData.mood,
        level: moodData.level,
        emoji: moodEffect.emoji,
        color: moodEffect.color
      });
    }
  });

  return result;
}

// 情绪排行榜项接口
interface MoodRankingItem {
  petId: number;
  mood: string;
  level: number;
  rank: number;
}

// 获取情绪排行榜
export function getMoodRanking(): MoodRankingItem[] {
  const allMoods = getAllPetMoods();

  const sortedMoods = allMoods.sort((a, b) => b.level - a.level);
  const ranking: MoodRankingItem[] = [];

  for (let i = 0; i < sortedMoods.length; i++) {
    const item = sortedMoods[i];
    const rankingItem: MoodRankingItem = {
      petId: item.petId,
      mood: item.mood,
      level: item.level,
      rank: i + 1
    };
    ranking.push(rankingItem);
  }

  return ranking;
}

// 随机数生成辅助函数
function getRandomInt(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

// 初始化示例数据
export function initExampleData(): void {
  const petIds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  initPetMoods(petIds);

  // 模拟一些互动
  setTimeout(() => {
    updateMoodByInteraction(1, 'like');
    updateMoodByInteraction(1, 'favorite');
    updateMoodByInteraction(3, 'feed');
    updateMoodByInteraction(5, 'play');
    updateMoodByInteraction(7, 'ignore');
  }, 1000);

  // 定期自动更新情绪
  setInterval(() => {
    autoUpdateMoods();
  }, 5 * 60 * 1000); // 5分钟更新一次
}

// 获取情绪效果
function getMoodEffect(mood: string): MoodEffect | undefined {
  switch (mood) {
    case '开心':
      return MOOD_EFFECTS.开心;
    case '兴奋':
      return MOOD_EFFECTS.兴奋;
    case '平静':
      return MOOD_EFFECTS.平静;
    case '普通':
      return MOOD_EFFECTS.普通;
    case '委屈':
      return MOOD_EFFECTS.委屈;
    case '孤独':
      return MOOD_EFFECTS.孤独;
    case '生气':
      return MOOD_EFFECTS.生气;
    case '生病':
      return MOOD_EFFECTS.生病;
    default:
      return undefined;
  }
}