/**
 * 宠物ViewModel
 * 管理宠物相关的状态和数据
 */

import { Pet } from '../common/types/index';
import { pets } from '../mock/PetData';
import { petMoods, updatePetMood } from '../mock/PetMoodSystem';
import { StorageUtils } from '../utils/StorageUtils';

// 宠物状态接口
interface PetState {
  pets: Pet[];
  filteredPets: Pet[];
  currentPet: Pet | null;
  loading: boolean;
  error: string | null;
  filter: {
    type: 'all' | 'cat' | 'dog' | 'other';
    status: 'all' | 'available' | 'pending' | 'adopted';
    search: string;
  };
}

// 宠物ViewModel
export class PetViewModel {
  // 单例实例
  private static instance: PetViewModel;

  // 状态
  private state: PetState = {
    pets: [],
    filteredPets: [],
    currentPet: null,
    loading: false,
    error: null,
    filter: {
      type: 'all',
      status: 'all',
      search: ''
    }
  };

  // 状态监听器
  private listeners: Array<(state: PetState) => void> = [];

  // 私有构造函数
  private constructor() {
    this.loadPets();
  }

  // 获取单例实例
  public static getInstance(): PetViewModel {
    if (!PetViewModel.instance) {
      PetViewModel.instance = new PetViewModel();
    }
    return PetViewModel.instance;
  }

  // 获取当前状态
  public getState(): PetState {
    return { ...this.state };
  }

  // 注册状态监听器
  public subscribe(listener: (state: PetState) => void): () => void {
    this.listeners.push(listener);
    // 立即通知当前状态
    listener(this.state);

    // 返回取消订阅函数
    return () => {
      const index = this.listeners.indexOf(listener);
      if (index > -1) {
        this.listeners.splice(index, 1);
      }
    };
  }

  // 更新状态并通知监听器
  private setState(newState: Partial<PetState>) {
    this.state = { ...this.state, ...newState };
    this.notifyListeners();
  }

  // 通知所有监听器
  private notifyListeners() {
    this.listeners.forEach(listener => listener(this.state));
  }

  // 加载宠物数据
  private async loadPets() {
    try {
      this.setState({ loading: true });

      // 从mock数据加载
      this.state.pets = [...pets];
      this.applyFilters();

      // 尝试从本地存储加载收藏状态
      const favorites = await StorageUtils.getObject<number[]>('favoritePets') || [];
      this.state.pets.forEach(pet => {
        pet.isFavorited = favorites.includes(pet.id);
      });

    } catch (error) {
      console.error('加载宠物数据失败:', error);
      this.setState({ error: '加载宠物数据失败' });
    } finally {
      this.setState({ loading: false });
    }
  }

  // 应用过滤器
  private applyFilters() {
    let filtered = [...this.state.pets];

    // 按类型过滤
    if (this.state.filter.type !== 'all') {
      filtered = filtered.filter(pet => pet.type === this.state.filter.type);
    }

    // 按状态过滤
    if (this.state.filter.status !== 'all') {
      filtered = filtered.filter(pet => pet.adoptionStatus === this.state.filter.status);
    }

    // 按搜索词过滤
    if (this.state.filter.search.trim()) {
      const search = this.state.filter.search.toLowerCase();
      filtered = filtered.filter(pet =>
        pet.name.toLowerCase().includes(search) ||
        pet.breed.toLowerCase().includes(search) ||
        pet.description.toLowerCase().includes(search)
      );
    }

    this.state.filteredPets = filtered;
  }

  // 设置过滤器
  public setFilter(filter: Partial<PetState['filter']>) {
    this.state.filter = { ...this.state.filter, ...filter };
    this.applyFilters();
    this.notifyListeners();
  }

  // 获取宠物详情
  public async getPetById(id: number): Promise<Pet | null> {
    try {
      this.setState({ loading: true });

      // 模拟网络请求延迟
      await new Promise(resolve => setTimeout(resolve, 300));

      const pet = this.state.pets.find(p => p.id === id) || null;
      this.state.currentPet = pet;

      // 增加浏览记录
      if (pet) {
        await this.addViewCount(pet.id);
      }

      this.notifyListeners();
      return pet;
    } catch (error) {
      console.error('获取宠物详情失败:', error);
      this.setState({ error: '获取宠物详情失败' });
      return null;
    } finally {
      this.setState({ loading: false });
    }
  }

  // 增加浏览数
  private async addViewCount(petId: number) {
    try {
      const pet = this.state.pets.find(p => p.id === petId);
      if (pet) {
        pet.views = (pet.views || 0) + 1;

        // 更新本地存储中的浏览记录
        const viewHistory = await StorageUtils.getObject<number[]>('petViewHistory') || [];
        if (!viewHistory.includes(petId)) {
          viewHistory.unshift(petId);
          // 只保留最近的50条记录
          if (viewHistory.length > 50) {
            viewHistory.pop();
          }
          await StorageUtils.setObject('petViewHistory', viewHistory);
        }

        this.notifyListeners();
      }
    } catch (error) {
      console.error('增加浏览数失败', error);
    }
  }

  // 点赞宠物
  public async likePet(petId: number): Promise<boolean> {
    try {
      const pet = this.state.pets.find(p => p.id === petId);
      if (!pet) return false;

      // 检查是否已经点赞
      const likedPets = await StorageUtils.getObject<number[]>('likedPets') || [];
      if (likedPets.includes(petId)) {
        // 取消点赞
        pet.likes = Math.max(0, pet.likes - 1);
        const index = likedPets.indexOf(petId);
        likedPets.splice(index, 1);
      } else {
        // 点赞
        pet.likes = (pet.likes || 0) + 1;
        likedPets.push(petId);

        // 更新宠物情绪（点赞会让宠物开心）
        updatePetMood(petId, 'happy');
      }

      // 保存点赞状态
      await StorageUtils.setObject('likedPets', likedPets);

      this.notifyListeners();
      return true;
    } catch (error) {
      console.error('点赞宠物失败:', error);
      return false;
    }
  }

  // 收藏宠物
  public async favoritePet(petId: number): Promise<boolean> {
    try {
      const pet = this.state.pets.find(p => p.id === petId);
      if (!pet) return false;

      // 检查是否已经收藏
      const favoritePets = await StorageUtils.getObject<number[]>('favoritePets') || [];
      if (favoritePets.includes(petId)) {
        // 取消收藏
        pet.favorites = Math.max(0, pet.favorites - 1);
        const index = favoritePets.indexOf(petId);
        favoritePets.splice(index, 1);
        pet.isFavorited = false;
      } else {
        // 收藏
        pet.favorites = (pet.favorites || 0) + 1;
        favoritePets.push(petId);
        pet.isFavorited = true;

        // 更新宠物情绪（收藏会让宠物开心）
        updatePetMood(petId, 'happy');
      }

      // 保存收藏状态
      await StorageUtils.setObject('favoritePets', favoritePets);

      this.notifyListeners();
      return true;
    } catch (error) {
      console.error('收藏宠物失败:', error);
      return false;
    }
  }

  // 获取推荐宠物
  public getRecommendedPets(limit: number = 5): Pet[] {
    // 简单的推荐算法：按热度（点赞+收藏+浏览）排序
    return [...this.state.pets]
      .sort((a, b) => {
        const scoreA = (a.likes || 0) + (a.favorites || 0) + (a.views || 0);
        const scoreB = (b.likes || 0) + (b.favorites || 0) + (b.views || 0);
        return scoreB - scoreA;
      })
      .slice(0, limit);
  }

  // 获取宠物情绪
  public getPetMood(petId: number): string {
    const mood = petMoods.find(m => m.petId === petId);
    return mood ? mood.mood : 'normal';
  }

  // 获取用户收藏的宠物
  public async getFavoritePets(): Promise<Pet[]> {
    try {
      const favoritePets = await StorageUtils.getObject<number[]>('favoritePets') || [];
      return this.state.pets.filter(pet => favoritePets.includes(pet.id));
    } catch (error) {
      console.error('获取收藏宠物失败:', error);
      return [];
    }
  }

  // 获取用户浏览历史
  public async getViewHistory(): Promise<Pet[]> {
    try {
      const viewHistory = await StorageUtils.getObject<number[]>('petViewHistory') || [];
      // 按浏览时间倒序排列
      const historyPets = viewHistory
        .map(id => this.state.pets.find(pet => pet.id === id))
        .filter(pet => pet !== undefined) as Pet[];
      return historyPets;
    } catch (error) {
      console.error('获取浏览历史失败:', error);
      return [];
    }
  }

  // 搜索宠物
  public searchPets(keyword: string): Pet[] {
    if (!keyword.trim()) {
      return this.state.filteredPets;
    }

    const search = keyword.toLowerCase();
    return this.state.filteredPets.filter(pet =>
      pet.name.toLowerCase().includes(search) ||
      pet.breed.toLowerCase().includes(search) ||
      pet.description.toLowerCase().includes(search)
    );
  }

  // 刷新宠物数据
  public async refreshPets(): Promise<void> {
    await this.loadPets();
  }

  // 获取当前宠物
  public getCurrentPet(): Pet | null {
    return this.state.currentPet;
  }

  // 获取加载状态
  public isLoading(): boolean {
    return this.state.loading;
  }

  // 获取错误信息
  public getError(): string | null {
    return this.state.error;
  }

  // 清除错误信息
  public clearError(): void {
    this.setState({ error: null });
  }
}
