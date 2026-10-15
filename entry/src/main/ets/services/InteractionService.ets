// 互动服务
import { Pet } from '../mock/PetData';
import {
  addLikeRecord,
  addFavoriteRecord,
  addViewRecord,
  addCloudCareRecord,
  hasLikedPet,
  hasFavoritedPet,
  getUserPetInteractionStats,
  getTodayInteractionStats
} from '../mock/InteractionData';

// 宠物互动统计接口
interface PetInteractionStats {
  likes: number;
  favorites: number;
  views: number;
  cloudCareCount: number;
  totalPoints: number;
}

// 用户互动统计接口
interface UserInteractionStats {
  totalLikes: number;
  totalFavorites: number;
  totalViews: number;
  totalCloudCare: number;
  totalCloudCareAmount: number;
}

// 今日互动统计接口
interface TodayInteractionStats {
  likes: number;
  favorites: number;
  views: number;
  cloudCare: number;
}

export class InteractionService {

  /**
   * 点赞宠物
   * @param userId 用户ID
   * @param petId 宠物ID
   */
  static likePet(userId: number, petId: number): boolean {
    const result = addLikeRecord(userId, petId);
    return result !== null;
  }

  /**
   * 取消点赞宠物
   * @param userId 用户ID
   * @param petId 宠物ID
   */
  static unlikePet(userId: number, petId: number): boolean {
    const result = addLikeRecord(userId, petId);
    return result === null;
  }

  /**
   * 收藏宠物
   * @param userId 用户ID
   * @param petId 宠物ID
   */
  static favoritePet(userId: number, petId: number): boolean {
    const result = addFavoriteRecord(userId, petId);
    return result !== null;
  }

  /**
   * 取消收藏宠物
   * @param userId 用户ID
   * @param petId 宠物ID
   */
  static unfavoritePet(userId: number, petId: number): boolean {
    const result = addFavoriteRecord(userId, petId);
    return result === null;
  }

  /**
   * 浏览宠物
   * @param userId 用户ID
   * @param petId 宠物ID
   */
  static viewPet(userId: number, petId: number): boolean {
    addViewRecord(userId, petId);
    return true;
  }

  /**
   * 云养宠物
   * @param userId 用户ID
   * @param petId 宠物ID
   * @param action 云养动作
   */
  static cloudCarePet(userId: number, petId: number, action: 'feed' | 'play' | 'groom' | 'walk' | 'pet'): boolean {
    addCloudCareRecord(userId, petId, action);
    return true;
  }

  /**
   * 获取宠物互动统计
   * @param userId 用户ID
   * @param petId 宠物ID
   */
  static getPetInteractionStats(userId: number, petId: number): PetInteractionStats {
    const stats = getUserPetInteractionStats(userId, petId);
    return {
      likes: stats.likes,
      favorites: stats.favorites,
      views: stats.views,
      cloudCareCount: stats.cloudCareActions,
      totalPoints: stats.totalPoints
    };
  }

  /**
   * 获取用户互动统计
   * @param userId 用户ID
   */
  static getUserInteractionStats(userId: number): UserInteractionStats {
    // 由于mock数据限制，返回默认值
    return {
      totalLikes: 0,
      totalFavorites: 0,
      totalViews: 0,
      totalCloudCare: 0,
      totalCloudCareAmount: 0
    };
  }

  /**
   * 获取今日互动统计
   * @param userId 用户ID
   */
  static getTodayInteractionStats(userId: number): TodayInteractionStats {
    const stats = getTodayInteractionStats(userId);
    return {
      likes: stats.likes,
      favorites: stats.favorites,
      views: stats.views,
      cloudCare: stats.cloudCareActions
    };
  }

  /**
   * 检查用户是否点赞了宠物
   * @param userId 用户ID
   * @param petId 宠物ID
   */
  static isPetLikedByUser(userId: number, petId: number): boolean {
    return hasLikedPet(userId, petId);
  }

  /**
   * 检查用户是否收藏了宠物
   * @param userId 用户ID
   * @param petId 宠物ID
   */
  static isPetFavoritedByUser(userId: number, petId: number): boolean {
    return hasFavoritedPet(userId, petId);
  }

  /**
   * 获取用户点赞的宠物列表
   * @param userId 用户ID
   */
  static getUserLikedPets(userId: number): number[] {
    // 这里应该查询数据库获取用户点赞的宠物ID列表
    // 由于mock数据限制，返回空数组
    return [];
  }

  /**
   * 获取用户收藏的宠物列表
   * @param userId 用户ID
   */
  static getUserFavoritedPets(userId: number): number[] {
    // 这里应该查询数据库获取用户收藏的宠物ID列表
    // 由于mock数据限制，返回空数组
    return [];
  }

  /**
   * 计算互动热度分数
   * @param pet 宠物信息
   */
  static calculateInteractionScore(pet: Pet): number {
    // 由于mock数据限制，返回默认值
    return 0;
  }

  /**
   * 获取热门宠物（基于互动热度）
   * @param count 数量
   */
  static getHotPets(count: number = 10): Pet[] {
    // 这里应该从数据库获取所有宠物并计算热度
    // 由于mock数据限制，返回空数组
    // 在实际应用中，这里应该实现完整的逻辑
    return [];
  }

  /**
   * 生成互动报告
   * @param userId 用户ID
   * @param days 天数
   */
  static generateInteractionReport(userId: number, days: number = 30): string {
    const stats = InteractionService.getUserInteractionStats(userId);
    const todayStats = InteractionService.getTodayInteractionStats(userId);

    const report = `
# 互动报告
## 统计周期：最近${days}天

## 总体统计
- 总点赞数：${stats.totalLikes}
- 总收藏数：${stats.totalFavorites}
- 总浏览数：${stats.totalViews}
- 总云养次数：${stats.totalCloudCare}
- 总云养金额：${stats.totalCloudCareAmount.toFixed(2)}元

## 今日统计
- 今日点赞：${todayStats.likes}
- 今日收藏：${todayStats.favorites}
- 今日浏览：${todayStats.views}
- 今日云养：${todayStats.cloudCare}

## 互动分析
${InteractionService.generateInteractionAnalysis(stats)}

报告生成时间：${new Date().toLocaleDateString('zh-CN')}
    `;

    return report.trim();
  }

  /**
   * 切换点赞状态
   * @param petId 宠物ID
   * @param isLiked 是否点赞
   */
  static toggleLike(petId: number, isLiked: boolean): boolean {
    // 这里应该调用实际的点赞/取消点赞API
    // 暂时返回成功
    return true;
  }

  /**
   * 切换收藏状态
   * @param petId 宠物ID
   * @param isFavorited 是否收藏
   */
  static toggleFavorite(petId: number, isFavorited: boolean): boolean {
    // 这里应该调用实际的收藏/取消收藏API
    // 暂时返回成功
    return true;
  }

  /**
   * 生成互动分析
   * @param stats 互动统计
   */
  private static generateInteractionAnalysis(stats: UserInteractionStats): string {
    const analysis: string[] = [];

    if (stats.totalLikes > 100) {
      analysis.push('您的点赞行为非常活跃，感谢您对宠物们的支持！');
    } else if (stats.totalLikes > 50) {
      analysis.push('您的点赞行为较为活跃，继续加油！');
    } else {
      analysis.push('可以多给喜欢的宠物点赞，让更多人看到它们！');
    }

    if (stats.totalFavorites > 20) {
      analysis.push('您收藏了很多宠物，看来您是个有爱心的人！');
    }

    if (stats.totalCloudCare > 0) {
      analysis.push(`您已经通过云养支持${stats.totalCloudCare}次，累计${stats.totalCloudCareAmount.toFixed(2)}元，非常感谢您的贡献！`);
    } else {
      analysis.push('尝试参与云养计划，为流浪宠物提供实际帮助！');
    }

    return analysis.map(item => `- ${item}`).join('\n');
  }
}
