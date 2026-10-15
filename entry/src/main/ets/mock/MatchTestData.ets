// 宠物匹配测试数据
import { Pet, petList } from './PetData';

export interface MatchQuestion {
  id: number;
  question: string;
  options: MatchOption[];
  weight: number; // 问题权重
}

export interface MatchOption {
  id: number;
  text: string;
  scores: Record<string, number>; // 宠物类型得分
}

export interface MatchResult {
  petType: string; // 猫、狗、其他
  score: number; // 匹配度分数0-100
  levelText: string; // 匹配等级文本
  description: string;
  recommendation: string[];
  suitablePets: number[]; // 推荐的宠物ID
}

// 匹配测试问题
export const matchQuestions: MatchQuestion[] = [
  {
    id: 1,
    question: "您每天有多少时间可以陪伴宠物？",
    options: [
      { id: 1, text: "少于1小时", scores: { "猫": 80, "狗": 30, "其他": 90 } },
      { id: 2, text: "1-3小时", scores: { "猫": 90, "狗": 60, "其他": 80 } },
      { id: 3, text: "3-5小时", scores: { "猫": 70, "狗": 80, "其他": 60 } },
      { id: 4, text: "5小时以上", scores: { "猫": 60, "狗": 100, "其他": 50 } }
    ],
    weight: 20
  },
  {
    id: 2,
    question: "您的居住环境如何？",
    options: [
      { id: 1, text: "小户型公寓", scores: { "猫": 90, "狗": 40, "其他": 100 } },
      { id: 2, text: "中等户型", scores: { "猫": 80, "狗": 70, "其他": 80 } },
      { id: 3, text: "大户型/别墅", scores: { "猫": 70, "狗": 90, "其他": 60 } },
      { id: 4, text: "有院子/花园", scores: { "猫": 60, "狗": 100, "其他": 50 } }
    ],
    weight: 15
  },
  {
    id: 3,
    question: "您是否有养宠经验？",
    options: [
      { id: 1, text: "完全没有经验", scores: { "猫": 70, "狗": 50, "其他": 90 } },
      { id: 2, text: "有一些经验", scores: { "猫": 80, "狗": 70, "其他": 80 } },
      { id: 3, text: "经验丰富", scores: { "猫": 90, "狗": 90, "其他": 70 } }
    ],
    weight: 15
  },
  {
    id: 4,
    question: "您希望宠物的活动水平如何？",
    options: [
      { id: 1, text: "安静温顺", scores: { "猫": 90, "狗": 40, "其他": 80 } },
      { id: 2, text: "适中活动", scores: { "猫": 80, "狗": 80, "其他": 70 } },
      { id: 3, text: "活泼好动", scores: { "猫": 60, "狗": 100, "其他": 50 } }
    ],
    weight: 15
  },
  {
    id: 5,
    question: "您对宠物掉毛的接受程度？",
    options: [
      { id: 1, text: "不能接受掉毛", scores: { "猫": 30, "狗": 40, "其他": 100 } },
      { id: 2, text: "可以接受少量掉毛", scores: { "猫": 70, "狗": 60, "其他": 80 } },
      { id: 3, text: "不介意掉毛", scores: { "猫": 100, "狗": 90, "其他": 60 } }
    ],
    weight: 10
  },
  {
    id: 6,
    question: "您的家庭情况如何？",
    options: [
      { id: 1, text: "单身", scores: { "猫": 80, "狗": 70, "其他": 90 } },
      { id: 2, text: "情侣/夫妻", scores: { "猫": 85, "狗": 80, "其他": 80 } },
      { id: 3, text: "有小孩", scores: { "猫": 70, "狗": 90, "其他": 60 } },
      { id: 4, text: "有老人", scores: { "猫": 90, "狗": 60, "其他": 70 } }
    ],
    weight: 10
  },
  {
    id: 7,
    question: "您能接受的宠物护理时间？",
    options: [
      { id: 1, text: "很少时间护理", scores: { "猫": 80, "狗": 40, "其他": 90 } },
      { id: 2, text: "每天30分钟左右", scores: { "猫": 90, "狗": 70, "其他": 80 } },
      { id: 3, text: "每天1小时以上", scores: { "猫": 70, "狗": 100, "其他": 60 } }
    ],
    weight: 10
  },
  {
    id: 8,
    question: "您的经济预算如何？",
    options: [
      { id: 1, text: "预算有限", scores: { "猫": 70, "狗": 50, "其他": 90 } },
      { id: 2, text: "中等预算", scores: { "猫": 80, "dog": 80, "其他": 80 } },
      { id: 3, text: "预算充足", scores: { "猫": 90, "狗": 100, "其他": 70 } }
    ],
    weight: 5
  }
];

// 匹配结果描述
export const matchResults: Record<string, MatchResult> = {
  "猫": {
    petType: "猫",
    score: 0,
    levelText: "非常适合",
    description: "猫咪独立、爱干净、适合室内饲养，不需要每天遛，适合生活节奏快、居住空间有限的人群。",
    recommendation: [
      "准备猫砂盆和猫砂",
      "定期梳理毛发",
      "准备猫抓板和玩具",
      "定期接种疫苗和驱虫",
      "提供安静舒适的环境"
    ],
    suitablePets: [1, 2, 5, 8, 11, 14] // 猫类宠物ID
  },
  "狗": {
    petType: "狗",
    score: 0,
    levelText: "很适合",
    description: "狗狗忠诚、活泼、需要较多陪伴和运动，适合有足够时间和空间、喜欢户外活动的人群。",
    recommendation: [
      "每天至少遛狗2次",
      "进行社会化训练",
      "定期洗澡和美容",
      "准备足够的玩具",
      "建立明确的规则和界限"
    ],
    suitablePets: [3, 4, 6, 9, 12, 15] // 狗类宠物ID
  },
  "其他": {
    petType: "其他",
    score: 0,
    levelText: "比较适合",
    description: "其他小宠物如仓鼠、兔子、龙猫等，饲养相对简单，适合新手或时间有限的人群。",
    recommendation: [
      "准备合适的笼具",
      "保持环境清洁",
      "提供专用食物",
      "注意温度和湿度",
      "定期健康检查"
    ],
    suitablePets: [7, 10, 13] // 其他宠物ID
  }
};

// 计算匹配结果
export function calculateMatchResult(answers: Record<number, number>): MatchResult {
  // 初始化得分
  const scores: Record<string, number> = {
    "猫": 0,
    "狗": 0,
    "其他": 0
  };

  // 计算每个问题的得分
  const answerKeys = Object.keys(answers);
  for (let i = 0; i < answerKeys.length; i++) {
    const questionIdStr = answerKeys[i];
    const questionId: number = parseInt(questionIdStr);
    const optionId: number = answers[questionId];
    const question = matchQuestions.find(q => q.id === questionId);
    const option = question?.options.find(o => o.id === optionId);

    if (question && option) {
      const petTypes = Object.keys(scores);
      for (let j = 0; j < petTypes.length; j++) {
        const petType = petTypes[j];
        scores[petType] += (option.scores[petType] || 0) * (question.weight / 100);
      }
    }
  }

  // 找到最高分的宠物类型
  let maxScore = 0;
  let matchedPetType = "猫";

  const scoreKeys = Object.keys(scores);
  for (let i = 0; i < scoreKeys.length; i++) {
    const petType = scoreKeys[i];
    const score = scores[petType];
    if (score > maxScore) {
      maxScore = score;
      matchedPetType = petType;
    }
  }

  // 获取匹配结果
  const baseResult = matchResults[matchedPetType];
  const result: MatchResult = {
    petType: baseResult.petType,
    score: Math.min(Math.round(maxScore), 100),
    levelText: baseResult.levelText,
    description: baseResult.description,
    recommendation: baseResult.recommendation,
    suitablePets: baseResult.suitablePets
  };

  return result;
}

// 获取测试进度
export function getTestProgress(answers: Record<number, number>): number {
  const totalQuestions = matchQuestions.length;
  const answeredQuestions = Object.keys(answers).length;
  return Math.round((answeredQuestions / totalQuestions) * 100);
}

// 获取推荐宠物（根据匹配结果）
export function getRecommendedPetsByMatch(result: MatchResult, count: number = 3): Pet[] {
  // 获取该类型的宠物
  let suitablePets: Pet[] = [];

  // 过滤符合条件的宠物
  for (const pet of petList) {
    if (pet.type === result.petType && pet.adoptionStatus === 'available') {
      suitablePets.push(pet);
    }
  }

  // 如果没有足够数量的宠物，补充其他类型的宠物
  if (suitablePets.length < count) {
    const otherPets: Pet[] = [];
    for (const pet of petList) {
      if (pet.type !== result.petType && pet.adoptionStatus === 'available') {
        otherPets.push(pet);
        if (otherPets.length >= count - suitablePets.length) {
          break;
        }
      }
    }
    // 合并数组
    for (const pet of otherPets) {
      suitablePets.push(pet);
    }
  }

  // 按点赞数排序
  suitablePets.sort((a: Pet, b: Pet) => b.likes - a.likes);

  // 返回指定数量的宠物
  return suitablePets.slice(0, count);
}

// 获取测试建议
export function getTestSuggestions(answers: Record<number, number>): string[] {
  const suggestions: string[] = [];

  // 根据答案给出个性化建议
  if (answers[1] === 1) { // 时间少于1小时
    suggestions.push("由于您时间有限，建议选择独立性较强的宠物，如猫咪或其他小宠物。");
  } else if (answers[1] === 4) { // 时间5小时以上
    suggestions.push("您有充足的时间，可以考虑需要较多陪伴的狗狗。");
  }

  if (answers[2] === 1) { // 小户型公寓
    suggestions.push("小户型公寓适合体型较小、活动需求不高的宠物。");
  } else if (answers[2] === 4) { // 有院子
    suggestions.push("有院子的环境非常适合需要活动空间的狗狗。");
  }

  if (answers[3] === 1) { // 没有经验
    suggestions.push("作为新手，建议从饲养相对简单的宠物开始。");
  }

  if (answers[5] === 1) { // 不能接受掉毛
    suggestions.push("如果您不能接受掉毛，可以考虑无毛猫或掉毛少的犬种。");
  }

  if (answers[6] === 3) { // 有小孩
    suggestions.push("有小孩的家庭需要选择性格温顺、对孩子友好的宠物。");
  }

  if (answers[6] === 4) { // 有老人
    suggestions.push("有老人的家庭适合选择安静、不需要太多运动的宠物。");
  }

  return suggestions;
}

// 获取测试历史记录
export interface TestHistory {
  id: number;
  userId: number;
  score: number;
  levelText: string;
  result: MatchResult;
  answers: Record<number, number>;
  timestamp: string;
}

// 保存测试记录的数据接口
export interface SaveTestHistoryData {
  userId: number;
  score: number;
  levelText: string;
  answers: Record<number, number>;
  timestamp: string;
}

// 模拟测试历史记录
export const testHistories: TestHistory[] = [
  {
    id: 1,
    userId: 1,
    score: 85,
    levelText: "非常适合",
    result: {
      petType: "猫",
      score: 85,
      levelText: "非常适合",
      description: "猫咪独立、爱干净、适合室内饲养，不需要每天遛，适合生活节奏快、居住空间有限的人群。",
      recommendation: [
        "准备猫砂盆和猫砂",
        "定期梳理毛发",
        "准备猫抓板和玩具",
        "定期接种疫苗和驱虫",
        "提供安静舒适的环境"
      ],
      suitablePets: [1, 2, 5]
    },
    answers: { 1: 2, 2: 1, 3: 2, 4: 1, 5: 2, 6: 1, 7: 2, 8: 2 },
    timestamp: "2026-04-10T14:30:00"
  },
  {
    id: 2,
    userId: 2,
    score: 78,
    levelText: "很适合",
    result: {
      petType: "狗",
      score: 78,
      levelText: "很适合",
      description: "狗狗忠诚、活泼、需要较多陪伴和运动，适合有足够时间和空间、喜欢户外活动的人群。",
      recommendation: [
        "每天至少遛狗2次",
        "进行社会化训练",
        "定期洗澡和美容",
        "准备足够的玩具",
        "建立明确的规则和界限"
      ],
      suitablePets: [3, 4, 6]
    },
    answers: { 1: 3, 2: 3, 3: 3, 4: 2, 5: 3, 6: 3, 7: 3, 8: 3 },
    timestamp: "2026-04-09T10:15:00"
  }
];

// 保存测试记录（支持对象参数）
export function saveTestHistory(historyData: SaveTestHistoryData): TestHistory {
  const newHistory: TestHistory = {
    id: testHistories.length + 1,
    userId: historyData.userId,
    score: historyData.score,
    levelText: historyData.levelText,
    result: {
      petType: "",
      score: historyData.score,
      levelText: historyData.levelText,
      description: "",
      recommendation: [],
      suitablePets: []
    },
    answers: historyData.answers,
    timestamp: historyData.timestamp
  };

  testHistories.push(newHistory);
  return newHistory;
}

// 获取用户的测试历史
export function getUserTestHistories(userId: number): TestHistory[] {
  return testHistories.filter(history => history.userId === userId);
}

// 获取最新的测试结果
export function getUserLatestTestResult(userId: number): MatchResult | null {
  const userHistories = getUserTestHistories(userId);
  if (userHistories.length === 0) return null;

  // 按时间排序，获取最新的
  const latestHistory = userHistories.sort((a, b) =>
    new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime()
  )[0];

  return latestHistory.result;
}

// 获取测试统计数据
interface TestStats {
  totalTests: number;
  catPercentage: number;
  dogPercentage: number;
  otherPercentage: number;
  averageScore: number;
}

export function getTestStats(): TestStats {
  const totalTests = testHistories.length;
  if (totalTests === 0) {
    return {
      totalTests: 0,
      catPercentage: 0,
      dogPercentage: 0,
      otherPercentage: 0,
      averageScore: 0
    };
  }

  const catTests = testHistories.filter(h => h.result.petType === "猫").length;
  const dogTests = testHistories.filter(h => h.result.petType === "狗").length;
  const otherTests = testHistories.filter(h => h.result.petType === "其他").length;

  const totalScore = testHistories.reduce((sum, history) => sum + history.result.score, 0);

  return {
    totalTests,
    catPercentage: Math.round((catTests / totalTests) * 100),
    dogPercentage: Math.round((dogTests / totalTests) * 100),
    otherPercentage: Math.round((otherTests / totalTests) * 100),
    averageScore: Math.round(totalScore / totalTests)
  } as TestStats;
}