// 推荐服务
import { Pet, petList } from '../mock/PetData';
import { currentUser } from '../mock/UserData';
import { getUserPreferences, updateUserPreferences, UserPreferences } from '../mock/UserData';
import { getInteractionStats, getUserInteractionHistory } from '../mock/InteractionData';

// 测试结果接口
export interface TestResult {
  petType?: string;
  matchScore?: number;
  compatibility?: number;
  recommendations?: string[];
}

export class RecommendationService {

  /**
   * 获取个性化推荐宠物
   * @param count 推荐数量，默认5个
   */
  static getPersonalizedRecommendations(count: number = 5): Pet[] {
    const user = currentUser;
    if (!user) {
      // 如果用户未登录，返回热门宠物
      return this.getPopularPets(count);
    }

    // 获取用户偏好
    const preferences = getUserPreferences(user.id);

    // 获取用户互动历史
    const interactionHistory = getUserInteractionHistory(user.id);

    // 基于偏好和互动历史计算推荐分数
    const scoredPets = petList.map(pet => {
      let score = 0;

      // 1. 基于宠物类型的偏好
      if (preferences.preferredPetTypes.includes(pet.type)) {
        score += 30;
      }

      // 2. 基于宠物年龄的偏好
      if (preferences.preferredAgeRange) {
        const age = pet.age;
        if (age >= preferences.preferredAgeRange.min && age <= preferences.preferredAgeRange.max) {
          score += 20;
        }
      }

      // 3. 基于互动历史
      const userInteractions = interactionHistory.filter(interaction =>
        interaction.petId === pet.id
      );

      if (userInteractions.length > 0) {
        // 用户曾经互动过，增加分数
        score += 15;

        // 根据互动类型增加分数
        const likes = userInteractions.filter(i => i.type === 'like').length;
        const favorites = userInteractions.filter(i => i.type === 'favorite').length;
        const views = userInteractions.filter(i => i.type === 'view').length;

        score += likes * 5;
        score += favorites * 8;
        score += views * 2;
      }

      // 4. 基于宠物热度
      score += Math.min(pet.likes + pet.favorites + pet.views, 50);

      // 5. 基于领养状态（优先推荐可领养的）
      if (pet.adoptionStatus === 'available') {
        score += 25;
      }

      return { pet, score };
    });

    // 按分数排序并返回前N个
    return scoredPets
      .sort((a, b) => b.score - a.score)
      .slice(0, count)
      .map(item => item.pet);
  }

  /**
   * 获取热门宠物（基于互动数据）
   */
  static getPopularPets(count: number = 5): Pet[] {
    return [...petList]
      .sort((a, b) => {
        // 计算热度分数：点赞*3 + 收藏*5 + 浏览
        const scoreA = a.likes * 3 + a.favorites * 5 + a.views;
        const scoreB = b.likes * 3 + b.favorites * 5 + b.views;
        return scoreB - scoreA;
      })
      .slice(0, count);
  }

  /**
   * 获取相似宠物推荐
   * @param petId 参考宠物ID
   * @param count 推荐数量，默认5个
   */
  static getSimilarPets(petId: number, count: number = 3): Pet[] {
    const referencePet = petList.find(pet => pet.id === petId);
    if (!referencePet) {
      return [];
    }

    // 计算相似度分数
    const similarPets = petList
      .filter(pet => pet.id !== petId) // 排除自己
      .map(pet => {
        let similarityScore = 0;

        // 1. 类型相同
        if (pet.type === referencePet.type) {
          similarityScore += 40;
        }

        // 2. 品种相似（如果有品种信息）
        if (pet.breed && referencePet.breed && pet.breed === referencePet.breed) {
          similarityScore += 30;
        }

        // 3. 年龄相近
        const refAge = referencePet.age;
        const petAge = pet.age;
        const ageDiff = Math.abs(refAge - petAge);
        if (ageDiff <= 1) {
          similarityScore += 15;
        } else if (ageDiff <= 3) {
          similarityScore += 10;
        }

        // 4. 健康状况相似
        if (pet.health === referencePet.health) {
          similarityScore += 10;
        }

        // 5. 领养状态相同
        if (pet.adoptionStatus === referencePet.adoptionStatus) {
          similarityScore += 5;
        }

        return { pet, similarityScore };
      })
      .sort((a, b) => b.similarityScore - a.similarityScore)
      .slice(0, count)
      .map(item => item.pet);

    return similarPets;
  }

  /**
   * 基于用户测试结果推荐宠物
   * @param testResult 匹配测试结果
   * @param count 推荐数量，默认5个
   */
  static getRecommendationsByTestResult(testResult: TestResult, count: number = 5): Pet[] {
    const petType = testResult?.petType;
    if (!petType) {
      return this.getPopularPets(count);
    }

    // 筛选该类型的宠物
    const typePets = petList.filter(pet => pet.type === petType);

    // 根据匹配度分数排序
    return typePets
      .sort((a, b) => {
        // 优先推荐可领养的
        if (a.adoptionStatus === 'available' && b.adoptionStatus !== 'available') return -1;
        if (a.adoptionStatus !== 'available' && b.adoptionStatus === 'available') return 1;

        // 然后按热度排序
        const scoreA = a.likes * 3 + a.favorites * 5 + a.views;
        const scoreB = b.likes * 3 + b.favorites * 5 + b.views;
        return scoreB - scoreA;
      })
      .slice(0, count);
  }

  /**
   * 更新用户偏好
   * @param userId 用户ID
   * @param likedPetIds 用户喜欢的宠物ID列表
   */
  static updateUserPreferencesFromLikes(userId: number, likedPetIds: number[]): void {
    const likedPets = petList.filter(pet => likedPetIds.includes(pet.id));

    if (likedPets.length === 0) {
      return;
    }

    // 分析喜欢的宠物的特征
    const petTypes = new Set<string>();
    const ages: number[] = [];

    likedPets.forEach(pet => {
      petTypes.add(pet.type);
      ages.push(pet.age);
    });

    // 计算平均年龄
    const avgAge = ages.reduce((sum, age) => sum + age, 0) / ages.length;

    // 更新用户偏好
    const newPreferences: UserPreferences = {
      preferredPetTypes: Array.from(petTypes),
      preferredAgeRange: {
        min: Math.max(0, Math.floor(avgAge) - 2),
        max: Math.ceil(avgAge) + 2
      },
      lastUpdated: new Date().toISOString()
    };

    updateUserPreferences(userId, newPreferences);
  }
}
