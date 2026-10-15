// 状态管理工具函数
import { appStore, AppState } from '../store/AppStore';

// 状态选择器类型
type Selector<T> = (state: AppState) => T;

// 状态监听器类型
type Listener<T> = (value: T) => void;

// 状态管理类
export class StateManager<T> {
  private selector: Selector<T>;
  private listeners: Set<Listener<T>> = new Set();
  private currentValue: T;
  private unsubscribe: (() => void) | null = null;

  constructor(selector: Selector<T>) {
    this.selector = selector;
    this.currentValue = selector(appStore.getState());

    // 订阅全局状态变化
    this.unsubscribe = appStore.subscribe((state: AppState) => {
      const newValue = selector(state);
      if (JSON.stringify(this.currentValue) !== JSON.stringify(newValue)) {
        this.currentValue = newValue;
        this.notifyListeners();
      }
    });
  }

  // 获取当前值
  getValue(): T {
    return this.currentValue;
  }

  // 订阅变化
  subscribe(listener: Listener<T>): () => void {
    this.listeners.add(listener);

    // 立即调用一次
    listener(this.currentValue);

    // 返回取消订阅函数
    return () => {
      this.listeners.delete(listener);
    };
  }

  // 通知所有监听器
  private notifyListeners(): void {
    this.listeners.forEach(listener => {
      listener(this.currentValue);
    });
  }

  // 清理
  dispose(): void {
    if (this.unsubscribe) {
      this.unsubscribe();
    }
    this.listeners.clear();
  }
}

// 常用的状态选择器
export const stateSelectors = {
  // 用户相关
  currentUser: (state: AppState) => state.currentUser,
  isLoggedIn: (state: AppState) => state.isLoggedIn,

  // 数据相关
  pets: (state: AppState) => state.pets,
  filteredPets: (state: AppState) => appStore.getFilteredPets(),
  notices: (state: AppState) => state.notices,
  filteredNotices: (state: AppState) => appStore.getFilteredNotices(),
  applies: (state: AppState) => state.applies,

  // UI状态
  isLoading: (state: AppState) => state.isLoading,
  error: (state: AppState) => state.error,
  theme: (state: AppState) => state.theme,

  // 搜索和筛选状态
  searchKeyword: (state: AppState) => state.searchKeyword,
  selectedPetType: (state: AppState) => state.selectedPetType,
  selectedNoticeType: (state: AppState) => state.selectedNoticeType,

  // 计算值
  unreadNoticeCount: (state: AppState) => appStore.getUnreadNoticeCount(),
  pendingApplyCount: (state: AppState) => appStore.getPendingApplyCount(),

  // 页面状态
  currentPage: (state: AppState) => state.currentPage,
  pageParams: (state: AppState) => state.pageParams
};

// 状态管理器实例
export const stateManagers = {
  currentUser: new StateManager(stateSelectors.currentUser),
  isLoggedIn: new StateManager(stateSelectors.isLoggedIn),
  pets: new StateManager(stateSelectors.pets),
  filteredPets: new StateManager(stateSelectors.filteredPets),
  notices: new StateManager(stateSelectors.notices),
  filteredNotices: new StateManager(stateSelectors.filteredNotices),
  applies: new StateManager(stateSelectors.applies),
  isLoading: new StateManager(stateSelectors.isLoading),
  error: new StateManager(stateSelectors.error),
  theme: new StateManager(stateSelectors.theme),
  searchKeyword: new StateManager(stateSelectors.searchKeyword),
  selectedPetType: new StateManager(stateSelectors.selectedPetType),
  selectedNoticeType: new StateManager(stateSelectors.selectedNoticeType),
  unreadNoticeCount: new StateManager(stateSelectors.unreadNoticeCount),
  pendingApplyCount: new StateManager(stateSelectors.pendingApplyCount),
  currentPage: new StateManager(stateSelectors.currentPage),
  pageParams: new StateManager(stateSelectors.pageParams)
};

// 清理所有状态管理器
export function disposeAllStateManagers(): void {
  Object.values(stateManagers).forEach(manager => {
    manager.dispose();
  });
}

// 状态绑定装饰器（简化版）
export function bindState<T>(selector: Selector<T>) {
  return function (target: object, propertyKey: string) {
    const manager = new StateManager(selector);

    // 在组件挂载时订阅
    const originalAboutToAppear = target.aboutToAppear;
    target.aboutToAppear = function () {
      if (originalAboutToAppear) {
        originalAboutToAppear.call(this);
      }

      // 保存取消订阅函数
      this[`${propertyKey}Unsubscribe`] = manager.subscribe((value: T) => {
        this[propertyKey] = value;
      });
    };

    // 在组件卸载时取消订阅
    const originalAboutToDisappear = target.aboutToDisappear;
    target.aboutToDisappear = function () {
      if (originalAboutToDisappear) {
        originalAboutToDisappear.call(this);
      }

      if (this[`${propertyKey}Unsubscribe`]) {
        this[`${propertyKey}Unsubscribe`]();
      }
    };

    // 初始化值
    Object.defineProperty(target, propertyKey, {
      get: function () {
        return manager.getValue();
      },
      set: function (value: T) {
        // 状态管理器是只读的，不能直接设置
        console.warn(`不能直接设置 ${propertyKey}，请使用appStore的action`);
      },
      enumerable: true,
      configurable: true
    });
  };
}

// 简化状态访问的Hook风格函数
export function useState<T>(selector: Selector<T>): T {
  const manager = new StateManager(selector);
  let unsubscribe: (() => void) | null = null;

  // 在ArkTS中，我们需要在组件生命周期中管理订阅
  // 这里返回当前值和一个更新函数
  const value = manager.getValue();

  // 返回一个清理函数
  const cleanup = () => {
    if (unsubscribe) {
      unsubscribe();
      manager.dispose();
    }
  };

  // 注意：在ArkTS中，我们需要在组件的aboutToAppear和aboutToDisappear中管理订阅
  // 这里只是返回当前值，实际使用需要在组件中处理订阅

  return value;
}

// 组合选择器
export function combineSelectors<A, B, R>(
  selectorA: Selector<A>,
  selectorB: Selector<B>,
  combiner: (a: A, b: B) => R
): Selector<R> {
  return (state: AppState) => combiner(selectorA(state), selectorB(state));
}

// 示例：组合当前用户和加载状态
export const userWithLoading = combineSelectors(
  stateSelectors.currentUser,
  stateSelectors.isLoading,
  (user, isLoading) => ({ user, isLoading })
);

// 示例：组合宠物列表和筛选状态
export const petsWithFilter = combineSelectors(
  stateSelectors.pets,
  stateSelectors.selectedPetType,
  (pets, selectedType) => ({
    pets,
    selectedType,
    filteredCount: pets.filter(pet => selectedType === '全部' || pet.type === selectedType).length
  })
);

// 状态工具函数
export class StateUtils {
  // 重置所有筛选状态
  static resetFilters(): void {
    appStore.setSearchKeyword('');
    appStore.setSelectedPetType('全部');
    appStore.setSelectedNoticeType('全部');
  }

  // 设置错误并自动清除
  static setErrorWithTimeout(error: string, timeout: number = 3000): void {
    appStore.setError(error);
    setTimeout(() => {
      appStore.setError(null);
    }, timeout);
  }

  // 批量更新状态
  static batchUpdate(updates: Partial<AppState>): void {
    appStore.setState(updates);
  }

  // 获取状态快照
  static getStateSnapshot(): AppState {
    return appStore.getState();
  }

  // 恢复状态快照
  static restoreStateSnapshot(snapshot: Partial<AppState>): void {
    appStore.setState(snapshot);
  }

  // 检查是否有未保存的更改
  static hasUnsavedChanges(): boolean {
    const state = appStore.getState();
    // 这里可以根据实际业务逻辑检查是否有未保存的更改
    return false;
  }

  // 保存状态到本地存储
  static async saveStateToStorage(): Promise<boolean> {
    try {
      const state = appStore.getState();
      // 这里可以实现将状态保存到本地存储
      // 例如：await StorageUtils.getInstance().setObject('app_state', state);
      return true;
    } catch (error) {
      console.error('保存状态失败', error);
      return false;
    }
  }

  // 从本地存储加载状态
  static async loadStateFromStorage(): Promise<boolean> {
    try {
      // 这里可以实现从本地存储加载状态
      // 例如：const savedState = await StorageUtils.getInstance().getObject<Partial<AppState>>('app_state', {});
      // appStore.setState(savedState);
      return true;
    } catch (error) {
      console.error('加载状态失败', error);
      return false;
    }
  }
}