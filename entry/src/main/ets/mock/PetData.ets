import { getUserFavoriteRecords, getUserLikeRecords } from './InteractionData';

// 宠物数据 - 使用统一的Pet接口
export interface Pet {
  id: number;
  name: string;
  type: 'cat' | 'dog' | 'other';
  breed: string;
  age: number;
  gender: 'male' | 'female';
  weight: number;
  color: string;
  description: string;
  images: string[];
  vaccines: string[];
  isSterilized: boolean;
  healthStatus: 'excellent' | 'good' | 'fair' | 'poor';
  adoptionStatus: 'available' | 'pending' | 'adopted';
  location: string;
  ownerId?: number;
  createTime: string;
  updateTime: string;
  likes: number;
  views: number;
  favorites: number;
  isLiked?: boolean; // 是否已点赞
  isFavorited?: boolean; // 是否已收藏
  // 兼容旧属性
  pics?: string[];
  status?: string;
  desc?: string;
  mood?: string;
  health?: string;
}

export const petList: Pet[] = [
  {
    id: 1,
    name: "橘猫",
    type: "cat" as "cat" | "dog" | "other",
    breed: "中华田园猫",
    age: 2,
    gender: "male" as "male" | "female",
    weight: 4.5,
    color: "橘色",
    description: "性格温顺，粘人，会用猫砂，无攻击性。喜欢被抚摸，适合家庭饲养。",
    images: [
      'pets/pet_orange_cat_01.jpg',
      'pets/pet_orange_cat_02.jpg',
      'pets/pet_orange_cat_03.jpg'
    ] as string[],
    vaccines: ["猫三联", "狂犬疫苗"] as string[],
    isSterilized: true,
    healthStatus: "excellent" as "excellent" | "good" | "fair" | "poor",
    adoptionStatus: "available" as "available" | "pending" | "adopted",
    location: "北京市朝阳区",
    createTime: "2026-03-15",
    updateTime: "2026-03-15",
    likes: 128,
    views: 342,
    favorites: 56
  } as Pet,
  {
    id: 2,
    name: "布偶",
    type: "cat" as "cat" | "dog" | "other",
    breed: "布偶猫",
    age: 0.6, // 7个月约等于0.6年
    gender: "female" as "male" | "female",
    weight: 3.2,
    color: "白色",
    description: "温顺安静，适合公寓饲养。蓝眼睛，长毛，需要定期梳理。",
    images: [
      'pets/pet_ragdoll_01.jpg',
      'pets/pet_ragdoll_02.jpg'
    ] as string[],
    vaccines: ["猫三联", "狂犬疫苗"] as string[],
    isSterilized: false,
    healthStatus: "good" as "excellent" | "good" | "fair" | "poor",
    adoptionStatus: "available" as "available" | "pending" | "adopted",
    location: "上海市浦东新区",
    createTime: "2026-03-20",
    updateTime: "2026-03-20",
    likes: 89,
    views: 215,
    favorites: 42
  } as Pet,
  {
    id: 3,
    name: "柯基",
    type: "dog" as "cat" | "dog" | "other",
    breed: "威尔士柯基犬",
    age: 1,
    gender: "male" as "male" | "female",
    weight: 12,
    color: "黄白色",
    description: "活泼亲人，无攻击性，会基本指令。短腿大屁股，非常可爱。",
    images: [
      'pets/pet_corgi_01.jpg',
      'pets/pet_corgi_02.jpg',
      'pets/pet_corgi_03.jpg'
    ] as string[],
    vaccines: ["犬五联", "狂犬疫苗"] as string[],
    isSterilized: true,
    healthStatus: "good" as "excellent" | "good" | "fair" | "poor",
    adoptionStatus: "available" as "available" | "pending" | "adopted",
    location: "广州市天河区",
    createTime: "2026-03-10",
    updateTime: "2026-03-10",
    likes: 156,
    views: 421,
    favorites: 78
  } as Pet,
  {
    id: 4,
    name: "金毛",
    type: "dog" as "cat" | "dog" | "other",
    breed: "金毛寻回犬",
    age: 3,
    gender: "female" as "male" | "female",
    weight: 28,
    color: "金色",
    description: "温顺友善，喜欢小孩，非常适合家庭饲养。",
    images: [
      'pets/pet_golden_retriever_01.jpg',
      'pets/pet_golden_retriever_02.jpg'
    ] as string[],
    vaccines: ["犬五联", "狂犬疫苗"] as string[],
    isSterilized: true,
    healthStatus: "excellent" as "excellent" | "good" | "fair" | "poor",
    adoptionStatus: "available" as "available" | "pending" | "adopted",
    location: "深圳市南山区",
    createTime: "2026-03-05",
    updateTime: "2026-03-05",
    likes: 210,
    views: 532,
    favorites: 95
  } as Pet,
  {
    id: 5,
    name: "波斯猫",
    type: "cat" as "cat" | "dog" | "other",
    breed: "波斯猫",
    age: 1.5,
    gender: "male" as "male" | "female",
    weight: 3.8,
    color: "白色",
    description: "安静优雅，长毛需要每天梳理。性格独立但亲人。",
    images: [
      'pets/pet_persian_01.jpg',
      'pets/pet_persian_02.jpg',
      'pets/pet_persian_03.jpg'
    ] as string[],
    vaccines: ["猫三联", "狂犬疫苗"] as string[],
    isSterilized: true,
    healthStatus: "good" as "excellent" | "good" | "fair" | "poor",
    adoptionStatus: "available" as "available" | "pending" | "adopted",
    location: "杭州市西湖区",
    createTime: "2026-03-25",
    updateTime: "2026-03-25",
    likes: 95,
    views: 187,
    favorites: 38
  } as Pet,
  {
    id: 6,
    name: "泰迪",
    type: "dog" as "cat" | "dog" | "other",
    breed: "泰迪犬",
    age: 0.67, // 8个月约等于0.67年
    gender: "female" as "male" | "female",
    weight: 5.2,
    color: "棕色",
    description: "聪明活泼，不掉毛，适合公寓饲养。需要定期美容。",
    images: [
      'pets/pet_poodle_01.jpg',
      'pets/pet_poodle_02.jpg'
    ] as string[],
    vaccines: ["犬五联", "狂犬疫苗"] as string[],
    isSterilized: false,
    healthStatus: "good" as "excellent" | "good" | "fair" | "poor",
    adoptionStatus: "available" as "available" | "pending" | "adopted",
    location: "成都市锦江区",
    createTime: "2026-04-01",
    updateTime: "2026-04-01",
    likes: 142,
    views: 298,
    favorites: 61
  } as Pet,
  {
    id: 7,
    name: "仓鼠",
    type: "other" as "cat" | "dog" | "other",
    breed: "金丝熊",
    age: 0.25, // 3个月约等于0.25年
    gender: "male" as "male" | "female",
    weight: 0.12,
    color: "金色",
    description: "小巧可爱，适合小朋友饲养。需要专用笼子和跑轮。",
    images: [
      'pets/pet_hamster_01.jpg'
    ] as string[],
    vaccines: [] as string[],
    isSterilized: false,
    healthStatus: "excellent" as "excellent" | "good" | "fair" | "poor",
    adoptionStatus: "available" as "available" | "pending" | "adopted",
    location: "南京市鼓楼区",
    createTime: "2026-03-28",
    updateTime: "2026-03-28",
    likes: 67,
    views: 154,
    favorites: 29
  } as Pet,
  {
    id: 8,
    name: "英短",
    type: "cat" as "cat" | "dog" | "other",
    breed: "英国短毛猫",
    age: 1,
    gender: "female" as "male" | "female",
    weight: 4.0,
    color: "蓝色",
    description: "性格温和，适应力强，短毛易打理。喜欢安静的环境。",
    images: [
      'pets/pet_british_shorthair_01.jpg',
      'pets/pet_british_shorthair_02.jpg'
    ] as string[],
    vaccines: ["猫三联", "狂犬疫苗"] as string[],
    isSterilized: true,
    healthStatus: "excellent" as "excellent" | "good" | "fair" | "poor",
    adoptionStatus: "available" as "available" | "pending" | "adopted",
    location: "武汉市江汉区",
    createTime: "2026-03-18",
    updateTime: "2026-03-18",
    likes: 112,
    views: 278,
    favorites: 45
  } as Pet,
  {
    id: 9,
    name: "哈士奇",
    type: "dog" as "cat" | "dog" | "other",
    breed: "西伯利亚雪橇犬",
    age: 2,
    gender: "male" as "male" | "female",
    weight: 25,
    color: "黑白",
    description: "精力旺盛，需要大量运动。性格友善但有点调皮。",
    images: [
      'pets/pet_husky_01.jpg',
      'pets/pet_husky_02.jpg'
    ] as string[],
    vaccines: ["犬五联", "狂犬疫苗"] as string[],
    isSterilized: true,
    healthStatus: "excellent" as "excellent" | "good" | "fair" | "poor",
    adoptionStatus: "available" as "available" | "pending" | "adopted",
    location: "西安市雁塔区",
    createTime: "2026-03-12",
    updateTime: "2026-03-12",
    likes: 178,
    views: 421,
    favorites: 82
  } as Pet,
  {
    id: 10,
    name: "兔子",
    type: "other" as "cat" | "dog" | "other",
    breed: "垂耳兔",
    age: 0.5,
    gender: "female" as "male" | "female",
    weight: 1.5,
    color: "白色",
    description: "温顺可爱，适合室内饲养。需要定期清理笼子。",
    images: [
      'pets/pet_rabbit_01.jpg'
    ] as string[],
    vaccines: [] as string[],
    isSterilized: false,
    healthStatus: "good" as "excellent" | "good" | "fair" | "poor",
    adoptionStatus: "available" as "available" | "pending" | "adopted",
    location: "重庆市渝中区",
    createTime: "2026-03-30",
    updateTime: "2026-03-30",
    likes: 53,
    views: 132,
    favorites: 21
  } as Pet
];

// 根据ID获取宠物信息
export function getPetById(id: number): Pet | null {
  const pet = petList.find(p => p.id === id);
  return pet || null;
}

// 获取所有宠物
export function getAllPets(): Pet[] {
  return petList;
}

// 根据类型筛选宠物
export function getPetsByType(type: 'cat' | 'dog' | 'other'): Pet[] {
  return petList.filter(pet => pet.type === type);
}

// 根据状态筛选宠物
export function getPetsByStatus(status: 'available' | 'pending' | 'adopted'): Pet[] {
  return petList.filter(pet => pet.adoptionStatus === status);
}

// 搜索宠物
export function searchPets(keyword: string): Pet[] {
  const lowerKeyword = keyword.toLowerCase();
  return petList.filter(pet =>
    pet.name.toLowerCase().includes(lowerKeyword) ||
    pet.breed.toLowerCase().includes(lowerKeyword) ||
    pet.description.toLowerCase().includes(lowerKeyword)
  );
}

// 获取热门宠物（按点赞数排序）
export function getPopularPets(limit: number = 5): Pet[] {
  return [...petList]
    .sort((a, b) => b.likes - a.likes)
    .slice(0, limit);
}

// 获取最新宠物（按创建时间排序）
export function getLatestPets(limit: number = 5): Pet[] {
  return [...petList]
    .sort((a, b) => new Date(b.createTime).getTime() - new Date(a.createTime).getTime())
    .slice(0, limit);
}

// 更新宠物信息
export function updatePet(id: number, updates: Record<string, string | number | boolean>): boolean {
  const index = petList.findIndex(p => p.id === id);
  if (index !== -1) {
    // 手动合并更新，避免使用展开运算符
    const originalPet = petList[index];
    const updatedPet: Pet = {
      id: originalPet.id,
      name: (updates.name as string) || originalPet.name,
      type: (updates.type as 'cat' | 'dog' | 'other') || originalPet.type,
      breed: (updates.breed as string) || originalPet.breed,
      age: (updates.age as number) || originalPet.age,
      gender: (updates.gender as 'male' | 'female') || originalPet.gender,
      weight: (updates.weight as number) || originalPet.weight,
      color: (updates.color as string) || originalPet.color,
      description: (updates.description as string) || originalPet.description,
      images: originalPet.images,
      vaccines: originalPet.vaccines,
      isSterilized: updates.isSterilized !== undefined ? (updates.isSterilized as boolean) : originalPet.isSterilized,
      healthStatus: (updates.healthStatus as 'excellent' | 'good' | 'fair' | 'poor') || originalPet.healthStatus,
      adoptionStatus: (updates.adoptionStatus as 'available' | 'pending' | 'adopted') || originalPet.adoptionStatus,
      location: (updates.location as string) || originalPet.location,
      ownerId: updates.ownerId !== undefined ? (updates.ownerId as number) : originalPet.ownerId,
      createTime: originalPet.createTime,
      updateTime: new Date().toISOString().split('T')[0],
      likes: updates.likes !== undefined ? (updates.likes as number) : originalPet.likes,
      views: updates.views !== undefined ? (updates.views as number) : originalPet.views,
      favorites: updates.favorites !== undefined ? (updates.favorites as number) : originalPet.favorites,
      isLiked: updates.isLiked !== undefined ? (updates.isLiked as boolean) : originalPet.isLiked,
      isFavorited: updates.isFavorited !== undefined ? (updates.isFavorited as boolean) : originalPet.isFavorited,
      pics: originalPet.pics,
      desc: updates.desc as string | undefined || originalPet.desc,
      mood: updates.mood as string | undefined || originalPet.mood,
      health: updates.health as string | undefined || originalPet.health
    } as Pet;
    petList[index] = updatedPet;
    return true;
  }
  return false;
}

// 添加新宠物
export function addPet(pet: Record<string, string | number | boolean>): Pet {
  const newId = Math.max(...petList.map(p => p.id)) + 1;
  const newPet: Pet = {
    id: newId,
    name: (pet.name as string) || '',
    type: (pet.type as 'cat' | 'dog' | 'other') || 'other',
    breed: (pet.breed as string) || '',
    age: (pet.age as number) || 0,
    gender: (pet.gender as 'male' | 'female') || 'male',
    weight: (pet.weight as number) || 0,
    color: (pet.color as string) || '',
    description: (pet.description as string) || '',
    images: [],
    vaccines: [],
    isSterilized: (pet.isSterilized as boolean) || false,
    healthStatus: (pet.healthStatus as 'excellent' | 'good' | 'fair' | 'poor') || 'good',
    adoptionStatus: (pet.adoptionStatus as 'available' | 'pending' | 'adopted') || 'available',
    location: (pet.location as string) || '',
    ownerId: pet.ownerId,
    createTime: new Date().toISOString().split('T')[0],
    updateTime: new Date().toISOString().split('T')[0],
    likes: (pet.likes as number) || 0,
    views: (pet.views as number) || 0,
    favorites: (pet.favorites as number) || 0,
    isLiked: pet.isLiked as boolean | undefined,
    isFavorited: pet.isFavorited as boolean | undefined,
    pics: [],
    desc: pet.desc as string | undefined,
    mood: pet.mood as string | undefined,
    health: pet.health as string | undefined
  } as Pet;
  petList.push(newPet);
  return newPet;
}

// 删除宠物
export function deletePet(id: number): boolean {
  const index = petList.findIndex(p => p.id === id);
  if (index !== -1) {
    petList.splice(index, 1);
    return true;
  }
  return false;
}

// 获取用户收藏的宠物
export function getUserFavoritePets(userId: number): Pet[] {
  const favoriteRecords = getUserFavoriteRecords(userId);
  return petList.filter(pet => favoriteRecords.some(fav => fav.petId === pet.id));
}

// 获取用户点赞的宠物
export function getUserLikedPets(userId: number): Pet[] {
  const likeRecords = getUserLikeRecords(userId);
  return petList.filter(pet => likeRecords.some(like => like.petId === pet.id));
}

// 更新宠物点赞状态
export function updatePetLikeStatus(petId: number, isLiked: boolean): boolean {
  const pet = petList.find(p => p.id === petId);
  if (pet) {
    pet.isLiked = isLiked;
    pet.likes = isLiked ? pet.likes + 1 : Math.max(0, pet.likes - 1);
    return true;
  }
  return false;
}

// 更新宠物收藏状态
export function updatePetFavoriteStatus(petId: number, isFavorited: boolean): boolean {
  const pet = petList.find(p => p.id === petId);
  if (pet) {
    pet.isFavorited = isFavorited;
    pet.favorites = isFavorited ? pet.favorites + 1 : Math.max(0, pet.favorites - 1);
    return true;
  }
  return false;
}

// 获取推荐宠物
export function getRecommendedPets(count: number = 3): Pet[] {
  // 简单实现：返回最受欢迎的宠物
  return [...petList]
    .sort((a, b) => b.likes - a.likes)
    .slice(0, count);
}