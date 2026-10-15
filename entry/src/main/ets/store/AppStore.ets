// 应用状态管理
import { User } from '../mock/UserData';
import { Pet } from '../mock/PetData';
import { Notice } from '../mock/NoticeData';
import { Apply } from '../mock/ApplyData';

// 应用状态接口
export interface AppState {
  // 用户相关
  currentUser: User | null;
  isLoggedIn: boolean;

  // 数据相关
  pets: Pet[];
  notices: Notice[];
  applies: Apply[];

  // UI状态
  isLoading: boolean;
  error: string | null;
  theme: 'light' | 'dark';
  language: string;
  notificationEnabled: boolean;

  // 缓存数据
  cachedPets: Map<number, Pet>;
  cachedNotices: Map<number, Notice>;

  // 搜索和筛选状态
  searchKeyword: string;
  selectedPetType: string;
  selectedNoticeType: string;

  // 页面状态
  currentPage: string;
  pageParams: Record<string, string>;
}

// 初始状态
const initialState: AppState = {
  currentUser: null,
  isLoggedIn: false,
  pets: [],
  notices: [],
  applies: [],
  isLoading: false,
  error: null,
  theme: 'light',
  language: 'zh-CN',
  notificationEnabled: true,
  cachedPets: new Map(),
  cachedNotices: new Map(),
  searchKeyword: '',
  selectedPetType: '全部',
  selectedNoticeType: '全部',
  currentPage: 'home',
  pageParams: {}
};

// 应用存储
export class AppStore {
  private static instance: AppStore;
  private state: AppState = initialState;
  private listeners: Array<(state: AppState) => void> = [];
  private readonly PREFERENCES_NAME = 'app_preferences';
  private readonly USER_KEY = 'current_user';
  private readonly THEME_KEY = 'app_theme';

  private constructor() {
    // 私有构造函数，单例模式
    this.loadPersistedData();
  }

  // 加载持久化数据
  private loadPersistedData(): void {
    try {
      // 加载用户数据
      const savedUser = this.loadUserFromStorage();
      if (savedUser) {
        this.state.currentUser = savedUser;
        this.state.isLoggedIn = true;
      }

      // 加载主题设置
      const savedTheme = this.loadThemeFromStorage();
      this.state.theme = savedTheme;
    } catch (error) {
      console.error('Failed to load persisted data:', error);
    }
  }

  // 获取单例实例
  static getInstance(): AppStore {
    if (!AppStore.instance) {
      AppStore.instance = new AppStore();
    }
    return AppStore.instance;
  }

  // 获取当前状态
  getState(): AppState {
    return this.state;
  }

  // 订阅状态变化
  subscribe(listener: (state: AppState) => void): () => void {
    this.listeners.push(listener);

    // 返回取消订阅函数
    return () => {
      const index = this.listeners.indexOf(listener);
      if (index > -1) {
        this.listeners.splice(index, 1);
      }
    };
  }

  // 初始化持久化存储（简化版本）
  private initPreferences(): void {
  }

  private saveUserToStorage(user: User | null): void {
    try {
    } catch (error) {
      console.error('Failed to save user to storage:', error);
    }
  }

  // 从持久化存储加载用户数据（简化版本）
  private loadUserFromStorage(): User | null {
    try {
      return null;
    } catch (error) {
      console.error('Failed to load user from storage:', error);
      return null;
    }
  }

  private saveThemeToStorage(theme: 'light' | 'dark'): void {
    try {
    } catch (error) {
      console.error('Failed to save theme to storage:', error);
    }
  }

  // 从持久化存储加载主题设置（简化版本）
  private loadThemeFromStorage(): 'light' | 'dark' {
    try {
      return 'light';
    } catch (error) {
      console.error('Failed to load theme from storage:', error);
      return 'light';
    }
  }

  // 通知所有监听器
  private notifyListeners(): void {
    const currentState = this.getState();
    this.listeners.forEach(listener => {
      listener(currentState);
    });
  }

  // 更新状态
  private setState(newState: Partial<AppState>): void {
    // 手动合并状态对象，避免使用Object.assign
    const mergedState: AppState = {
      currentUser: newState.currentUser !== undefined ? newState.currentUser : this.state.currentUser,
      isLoggedIn: newState.isLoggedIn !== undefined ? newState.isLoggedIn : this.state.isLoggedIn,
      pets: newState.pets !== undefined ? newState.pets : this.state.pets,
      notices: newState.notices !== undefined ? newState.notices : this.state.notices,
      applies: newState.applies !== undefined ? newState.applies : this.state.applies,
      isLoading: newState.isLoading !== undefined ? newState.isLoading : this.state.isLoading,
      error: newState.error !== undefined ? newState.error : this.state.error,
      theme: newState.theme !== undefined ? newState.theme : this.state.theme,
      language: newState.language !== undefined ? newState.language : this.state.language,
      notificationEnabled: newState.notificationEnabled !== undefined ? newState.notificationEnabled : this.state.notificationEnabled,
      cachedPets: newState.cachedPets !== undefined ? newState.cachedPets : this.state.cachedPets,
      cachedNotices: newState.cachedNotices !== undefined ? newState.cachedNotices : this.state.cachedNotices,
      searchKeyword: newState.searchKeyword !== undefined ? newState.searchKeyword : this.state.searchKeyword,
      selectedPetType: newState.selectedPetType !== undefined ? newState.selectedPetType : this.state.selectedPetType,
      selectedNoticeType: newState.selectedNoticeType !== undefined ? newState.selectedNoticeType : this.state.selectedNoticeType,
      currentPage: newState.currentPage !== undefined ? newState.currentPage : this.state.currentPage,
      pageParams: newState.pageParams !== undefined ? newState.pageParams : this.state.pageParams
    };
    this.state = mergedState;
    this.notifyListeners();
  }

  // Action: 设置用户
  setUser(user: User | null): void {
    this.setState({
      currentUser: user,
      isLoggedIn: !!user
    });

    // 保存到持久化存储
    this.saveUserToStorage(user);
  }

  // Action: 清除用户
  clearUser(): void {
    this.setState({
      currentUser: null,
      isLoggedIn: false
    });

    // 从持久化存储中移除
    this.saveUserToStorage(null);
  }

  // Action: 设置宠物列表
  setPets(pets: Pet[]): void {
    this.setState({ pets });

    // 更新缓存
    const newCache = new Map(this.state.cachedPets);
    pets.forEach(pet => {
      newCache.set(pet.id, pet);
    });
    this.setState({ cachedPets: newCache });
  }

  // Action: 添加宠物
  addPet(pet: Pet): void {
    const updatedPets = [...this.state.pets, pet];
    this.setPets(updatedPets);
  }

  // Action: 更新宠物
  updatePet(updatedPet: Pet): void {
    const updatedPets = this.state.pets.map(pet =>
    pet.id === updatedPet.id ? updatedPet : pet
    );
    this.setPets(updatedPets);
  }

  // Action: 删除宠物
  deletePet(petId: number): void {
    const updatedPets = this.state.pets.filter(pet => pet.id !== petId);
    this.setPets(updatedPets);

    // 从缓存中移除
    const newCache = new Map(this.state.cachedPets);
    newCache.delete(petId);
    this.setState({ cachedPets: newCache });
  }

  // Action: 设置公告列表
  setNotices(notices: Notice[]): void {
    this.setState({ notices });

    // 更新缓存
    const newCache = new Map(this.state.cachedNotices);
    notices.forEach(notice => {
      newCache.set(notice.id, notice);
    });
    this.setState({ cachedNotices: newCache });
  }

  // Action: 设置申请列表
  setApplies(applies: Apply[]): void {
    this.setState({ applies });
  }

  // Action: 设置加载状态
  setLoading(isLoading: boolean): void {
    this.setState({ isLoading });
  }

  // Action: 设置错误
  setError(error: string | null): void {
    this.setState({ error });
  }

  // Action: 设置搜索关键词
  setSearchKeyword(keyword: string): void {
    this.setState({ searchKeyword: keyword });
  }

  // Action: 设置选中的宠物类型
  setSelectedPetType(type: string): void {
    this.setState({ selectedPetType: type });
  }

  // Action: 设置选中的公告类型
  setSelectedNoticeType(type: string): void {
    this.setState({ selectedNoticeType: type });
  }

  // Action: 设置当前页面
  setCurrentPage(page: string, params?: Record<string, string>): void {
    this.setState({
      currentPage: page,
      pageParams: params || {}
    });
  }

  // Action: 切换主题
  toggleTheme(): void {
    const newTheme = this.state.theme === 'light' ? 'dark' : 'light';
    this.setState({ theme: newTheme });
    this.saveThemeToStorage(newTheme);
  }

  // Action: 设置主题
  setTheme(theme: 'light' | 'dark'): void {
    this.setState({ theme });
    this.saveThemeToStorage(theme);
  }

  // Selector: 获取过滤后的宠物列表
  getFilteredPets(): Pet[] {
    let filteredPets = this.state.pets;

    // 按类型筛选
    if (this.state.selectedPetType !== '全部') {
      filteredPets = filteredPets.filter(pet => pet.type === this.state.selectedPetType);
    }

    // 按关键词搜索
    if (this.state.searchKeyword.trim()) {
      const keyword = this.state.searchKeyword.toLowerCase().trim();
      filteredPets = filteredPets.filter(pet =>
      pet.name.toLowerCase().includes(keyword) ||
      pet.type.toLowerCase().includes(keyword) ||
      (pet.desc && pet.desc.toLowerCase().includes(keyword)) ||
        (pet.breed && pet.breed.toLowerCase().includes(keyword))
      );
    }

    return filteredPets;
  }

  // Selector: 获取过滤后的公告列表
  getFilteredNotices(): Notice[] {
    let filteredNotices = this.state.notices;

    // 按类型筛选
    if (this.state.selectedNoticeType !== '全部') {
      filteredNotices = filteredNotices.filter(notice => notice.type === this.state.selectedNoticeType);
    }

    return filteredNotices;
  }

  // Selector: 获取未读公告数量
  getUnreadNoticeCount(): number {
    return this.state.notices.filter(notice => !notice.isRead).length;
  }

  // Selector: 获取待处理申请数量
  getPendingApplyCount(): number {
    return this.state.applies.filter(apply => apply.status === '待审核').length;
  }

  // Selector: 根据ID获取宠物
  getPetById(id: number): Pet | undefined {
    return this.state.cachedPets.get(id);
  }

  // Selector: 根据ID获取公告
  getNoticeById(id: number): Notice | undefined {
    return this.state.cachedNotices.get(id);
  }

  // Selector: 获取用户申请
  getUserApplies(): Apply[] {
    if (!this.state.currentUser) {
      return [];
    }
    return this.state.applies.filter(apply => apply.userId === this.state.currentUser!.id);
  }

  // 重置状态
  reset(): void {
    this.state = initialState;
    this.notifyListeners();
  }
}

// 导出单例实例
export const appStore = AppStore.getInstance();

// 简化状态管理辅助函数
export function connect<T extends Partial<AppState>>(mapState: (state: AppState) => T): (Component: object) => object {
  // 返回一个简单的包装函数，实际项目中应使用@State和@Link装饰器
  return (Component: object) => {
    return Component;
  };
}