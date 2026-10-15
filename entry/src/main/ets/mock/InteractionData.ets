// 互动行为数据
export interface LikeRecord {
  id: number;
  userId: number;
  petId: number;
  createTime: string;
}

export interface FavoriteRecord {
  id: number;
  userId: number;
  petId: number;
  createTime: string;
}

export interface ViewRecord {
  id: number;
  userId: number;
  petId: number;
  viewTime: string;
  duration: number; // 浏览时长（秒）
}

export interface PetMoodRecord {
  id: number;
  petId: number;
  mood: string; // 开心、普通、委屈、孤独、兴奋、平静
  reason: string; // 情绪变化原因
  createTime: string;
}

export interface CloudCareRecord {
  id: number;
  userId: number;
  petId: number;
  action: 'feed' | 'play' | 'groom' | 'walk' | 'pet'; // 喂食、玩耍、梳毛、遛弯、抚摸
  points: number; // 获得积分
  createTime: string;
}

// 模拟点赞记录
export const likeRecords: LikeRecord[] = [
  { id: 1, userId: 1, petId: 1, createTime: "2026-04-10 10:30:00" },
  { id: 2, userId: 1, petId: 3, createTime: "2026-04-10 11:15:00" },
  { id: 3, userId: 2, petId: 1, createTime: "2026-04-09 14:20:00" },
  { id: 4, userId: 2, petId: 4, createTime: "2026-04-09 15:45:00" },
  { id: 5, userId: 3, petId: 2, createTime: "2026-04-08 09:30:00" }
];

// 模拟收藏记录
export const favoriteRecords: FavoriteRecord[] = [
  { id: 1, userId: 1, petId: 1, createTime: "2026-04-10 10:35:00" },
  { id: 2, userId: 1, petId: 5, createTime: "2026-04-10 16:20:00" },
  { id: 3, userId: 2, petId: 3, createTime: "2026-04-09 14:25:00" },
  { id: 4, userId: 3, petId: 1, createTime: "2026-04-08 09:35:00" }
];

// 模拟浏览记录
export const viewRecords: ViewRecord[] = [
  { id: 1, userId: 1, petId: 1, viewTime: "2026-04-11 09:15:00", duration: 120 },
  { id: 2, userId: 1, petId: 3, viewTime: "2026-04-11 09:30:00", duration: 180 },
  { id: 3, userId: 1, petId: 5, viewTime: "2026-04-11 10:00:00", duration: 90 },
  { id: 4, userId: 2, petId: 1, viewTime: "2026-04-10 14:20:00", duration: 150 },
  { id: 5, userId: 2, petId: 4, viewTime: "2026-04-10 15:00:00", duration: 200 },
  { id: 6, userId: 3, petId: 2, viewTime: "2026-04-09 10:30:00", duration: 100 }
];

// 模拟宠物情绪记录
export const petMoodRecords: PetMoodRecord[] = [
  { id: 1, petId: 1, mood: "开心", reason: "被点赞", createTime: "2026-04-11 09:20:00" },
  { id: 2, petId: 1, mood: "兴奋", reason: "被收藏", createTime: "2026-04-11 09:25:00" },
  { id: 3, petId: 3, mood: "普通", reason: "正常状态", createTime: "2026-04-11 09:30:00" },
  { id: 4, petId: 5, mood: "委屈", reason: "长时间未被关注", createTime: "2026-04-10 18:00:00" },
  { id: 5, petId: 2, mood: "孤独", reason: "没有互动", createTime: "2026-04-10 20:00:00" }
];

// 模拟云养记录
export const cloudCareRecords: CloudCareRecord[] = [
  { id: 1, userId: 1, petId: 1, action: "feed", points: 10, createTime: "2026-04-11 08:30:00" },
  { id: 2, userId: 1, petId: 1, action: "play", points: 15, createTime: "2026-04-11 09:00:00" },
  { id: 3, userId: 1, petId: 3, action: "feed", points: 10, createTime: "2026-04-11 09:15:00" },
  { id: 4, userId: 2, petId: 1, action: "groom", points: 20, createTime: "2026-04-10 14:30:00" },
  { id: 5, userId: 2, petId: 4, action: "walk", points: 25, createTime: "2026-04-10 15:00:00" },
  { id: 6, userId: 3, petId: 2, action: "pet", points: 5, createTime: "2026-04-09 10:45:00" }
];

// 收藏变更轻量通知：Detail / MyFavorites 写入记录后同步推送，Mine 订阅后重读计数。
// 仅内存事件分发，不做持久化、不做轮询。
let favoriteVersion: number = 0;
let favoriteChangeListeners: Array<(version: number) => void> = [];

export function getFavoriteVersion(): number {
  return favoriteVersion;
}

export function subscribeFavoriteChanges(listener: (version: number) => void): () => void {
  favoriteChangeListeners.push(listener);
  return () => {
    const index = favoriteChangeListeners.indexOf(listener);
    if (index !== -1) {
      favoriteChangeListeners.splice(index, 1);
    }
  };
}

function notifyFavoriteChanged(): void {
  favoriteVersion++;
  const listenersCopy = favoriteChangeListeners.slice();
  for (let i = 0; i < listenersCopy.length; i++) {
    try {
      listenersCopy[i](favoriteVersion);
    } catch (e) {
      console.error('favorite change listener failed:', e);
    }
  }
}

// 检查用户是否点赞过宠物
export function hasLikedPet(userId: number, petId: number): boolean {
  return likeRecords.some(record => record.userId === userId && record.petId === petId);
}

// 检查用户是否收藏过宠物
export function hasFavoritedPet(userId: number, petId: number): boolean {
  return favoriteRecords.some(record => record.userId === userId && record.petId === petId);
}

// 添加点赞记录
export function addLikeRecord(userId: number, petId: number): LikeRecord | null {
  if (hasLikedPet(userId, petId)) {
    // 如果已经点赞过，取消点赞
    const index = likeRecords.findIndex(record => record.userId === userId && record.petId === petId);
    if (index !== -1) {
      likeRecords.splice(index, 1);
    }
    return null;
  }

  const newRecord: LikeRecord = {
    id: likeRecords.length + 1,
    userId,
    petId,
    createTime: new Date().toLocaleString('zh-CN')
  };

  likeRecords.push(newRecord);

  // 更新宠物情绪（被点赞会开心）
  updatePetMood(petId, "开心", "被用户点赞");

  return newRecord;
}

// 添加收藏记录
export function addFavoriteRecord(userId: number, petId: number): FavoriteRecord | null {
  if (hasFavoritedPet(userId, petId)) {
    // 如果已经收藏过，取消收藏
    const index = favoriteRecords.findIndex(record => record.userId === userId && record.petId === petId);
    if (index !== -1) {
      favoriteRecords.splice(index, 1);
    }
    notifyFavoriteChanged();
    return null;
  }

  // 取现存最大 ID 加 1，避免删除记录后 ID 重复
  let maxId = 0;
  favoriteRecords.forEach((record: FavoriteRecord) => {
    if (record.id > maxId) {
      maxId = record.id;
    }
  });

  const newRecord: FavoriteRecord = {
    id: maxId + 1,
    userId,
    petId,
    createTime: new Date().toLocaleString('zh-CN')
  };

  favoriteRecords.push(newRecord);

  // 更新宠物情绪（被收藏会兴奋）
  updatePetMood(petId, "兴奋", "被用户收藏");

  notifyFavoriteChanged();
  return newRecord;
}

// 添加浏览记录
export function addViewRecord(userId: number, petId: number, duration: number = 60): ViewRecord {
  const newRecord: ViewRecord = {
    id: viewRecords.length + 1,
    userId,
    petId,
    viewTime: new Date().toLocaleString('zh-CN'),
    duration
  };

  viewRecords.push(newRecord);
  return newRecord;
}

// 获取用户的点赞记录
export function getUserLikeRecords(userId: number): LikeRecord[] {
  return likeRecords.filter(record => record.userId === userId);
}

// 获取用户的收藏记录
export function getUserFavoriteRecords(userId: number): FavoriteRecord[] {
  return favoriteRecords.filter(record => record.userId === userId);
}

// 获取用户的浏览记录
export function getUserViewRecords(userId: number): ViewRecord[] {
  return viewRecords.filter(record => record.userId === userId);
}

// 获取用户的云养记录
export function getUserCloudCareRecords(userId: number): CloudCareRecord[] {
  return cloudCareRecords.filter(record => record.userId === userId);
}

// 获取用户云养积分
export function getUserCloudCarePoints(userId: number): number {
  return cloudCareRecords
    .filter(record => record.userId === userId)
    .reduce((total, record) => total + record.points, 0);
}

// 添加云养记录
type CloudCareAction = 'feed' | 'play' | 'groom' | 'walk' | 'pet';

export function addCloudCareRecord(userId: number, petId: number, action: CloudCareAction): CloudCareRecord {
  // 不同动作获得不同积分
  const pointsMap: Record<CloudCareAction, number> = {
    'feed': 10,
    'play': 15,
    'groom': 20,
    'walk': 25,
    'pet': 5
  };

  const newRecord: CloudCareRecord = {
    id: cloudCareRecords.length + 1,
    userId,
    petId,
    action,
    points: pointsMap[action],
    createTime: new Date().toLocaleString('zh-CN')
  } as CloudCareRecord;

  cloudCareRecords.push(newRecord);

  // 更新宠物情绪（被云养会开心）
  const moodMap: Record<'feed' | 'play' | 'groom' | 'walk' | 'pet', string> = {
    'feed': "开心",
    'play': "兴奋",
    'groom': "开心",
    'walk': "兴奋",
    'pet': "平静"
  } as Record<'feed' | 'play' | 'groom' | 'walk' | 'pet', string>;

  const mood = moodMap[action];
  updatePetMood(petId, mood, `被用户${getActionName(action)}`);

  return newRecord;
}

// 获取动作名称
function getActionName(action: 'feed' | 'play' | 'groom' | 'walk' | 'pet'): string {
  const actionNames: Record<'feed' | 'play' | 'groom' | 'walk' | 'pet', string> = {
    'feed': '喂食',
    'play': '玩耍',
    'groom': '梳毛',
    'walk': '遛弯',
    'pet': '抚摸'
  } as Record<'feed' | 'play' | 'groom' | 'walk' | 'pet', string>;
  return actionNames[action];
}

// 更新宠物情绪
export function updatePetMood(petId: number, mood: string, reason: string): PetMoodRecord {
  const newRecord: PetMoodRecord = {
    id: petMoodRecords.length + 1,
    petId,
    mood,
    reason,
    createTime: new Date().toLocaleString('zh-CN')
  } as PetMoodRecord;

  petMoodRecords.push(newRecord);
  return newRecord;
}

// 获取宠物最近情绪
export function getPetRecentMood(petId: number): PetMoodRecord | undefined {
  const petRecords = petMoodRecords.filter(record => record.petId === petId);
  if (petRecords.length === 0) return undefined;

  // 返回最新的情绪记录
  return petRecords.sort((a, b) =>
  new Date(b.createTime).getTime() - new Date(a.createTime).getTime()
  )[0];
}

// 获取宠物情绪历史
export function getPetMoodHistory(petId: number, limit: number = 10): PetMoodRecord[] {
  return petMoodRecords
    .filter(record => record.petId === petId)
    .sort((a, b) => new Date(b.createTime).getTime() - new Date(a.createTime).getTime())
    .slice(0, limit);
}

interface InteractionStats {
  likes: number;
  favorites: number;
  views: number;
  cloudCareActions: number;
  totalPoints: number;
}

// 获取用户与宠物的互动统计
export function getUserPetInteractionStats(userId: number, petId: number): InteractionStats {
  const userLikes = likeRecords.filter(record => record.userId === userId && record.petId === petId).length;
  const userFavorites = favoriteRecords.filter(record => record.userId === userId && record.petId === petId).length;
  const userViews = viewRecords.filter(record => record.userId === userId && record.petId === petId).length;
  const userCloudCare = cloudCareRecords.filter(record => record.userId === userId && record.petId === petId);

  return {
    likes: userLikes,
    favorites: userFavorites,
    views: userViews,
    cloudCareActions: userCloudCare.length,
    totalPoints: userCloudCare.reduce((total, record) => total + record.points, 0)
  } as InteractionStats;
}

interface PetInteraction {
  petId: number;
  interactionCount: number;
}

// 获取用户最常互动的宠物
export function getUserMostInteractedPets(userId: number, limit: number = 5): PetInteraction[] {
  const petInteractions = new Map<number, number>();

  // 统计所有互动
  [...likeRecords, ...favoriteRecords, ...viewRecords, ...cloudCareRecords]
    .filter(record => record.userId === userId)
    .forEach(record => {
      const count = petInteractions.get(record.petId) || 0;
      petInteractions.set(record.petId, count + 1);
    });

  // 转换为数组并排序
  return Array.from(petInteractions.entries())
    .map((entry: [number, number]) => ({ petId: entry[0], interactionCount: entry[1] } as PetInteraction))
    .sort((a, b) => b.interactionCount - a.interactionCount)
    .slice(0, limit);
}

// 获取今日互动统计
interface TodayInteractionStats {
  likes: number;
  favorites: number;
  views: number;
  cloudCareActions: number;
}

export function getTodayInteractionStats(userId: number): TodayInteractionStats {
  const today = new Date().toLocaleDateString('zh-CN');

  const todayLikes = likeRecords.filter(record =>
  record.userId === userId &&
    new Date(record.createTime).toLocaleDateString('zh-CN') === today
  ).length;

  const todayFavorites = favoriteRecords.filter(record =>
  record.userId === userId &&
    new Date(record.createTime).toLocaleDateString('zh-CN') === today
  ).length;

  const todayViews = viewRecords.filter(record =>
  record.userId === userId &&
    new Date(record.viewTime).toLocaleDateString('zh-CN') === today
  ).length;

  const todayCloudCare = cloudCareRecords.filter(record =>
  record.userId === userId &&
    new Date(record.createTime).toLocaleDateString('zh-CN') === today
  ).length;

  return {
    likes: todayLikes,
    favorites: todayFavorites,
    views: todayViews,
    cloudCareActions: todayCloudCare
  } as TodayInteractionStats;
}