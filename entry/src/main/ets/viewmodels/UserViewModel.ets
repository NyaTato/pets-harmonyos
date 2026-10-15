/**
 * 用户ViewModel
 * 管理用户相关的状态和数据
 */

import { User } from '../common/types/index';
import { StorageUtils } from '../utils/StorageUtils';

// 用户状态接口
interface UserState {
  currentUser: User | null;
  isLoggedIn: boolean;
  loading: boolean;
  error: string | null;
}

// 用户ViewModel类
export class UserViewModel {
  // 单例实例
  private static instance: UserViewModel;

  // 状态
  private state: UserState = {
    currentUser: null,
    isLoggedIn: false,
    loading: false,
    error: null
  };

  // 状态监听器
  private listeners: Array<(state: UserState) => void> = [];

  // 私有构造函数
  private constructor() {
    this.loadUserFromStorage();
  }

  // 获取单例实例
  public static getInstance(): UserViewModel {
    if (!UserViewModel.instance) {
      UserViewModel.instance = new UserViewModel();
    }
    return UserViewModel.instance;
  }

  // 获取当前状态
  public getState(): UserState {
    // 手动复制状态对象
    return {
      currentUser: this.state.currentUser,
      isLoggedIn: this.state.isLoggedIn,
      loading: this.state.loading,
      error: this.state.error
    };
  }

  // 注册状态监听器
  public subscribe(listener: (state: UserState) => void): () => void {
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
  private setState(newState: Partial<UserState>) {
    // 手动合并状态
    for (const key in newState) {
      if (Object.prototype.hasOwnProperty.call(newState, key)) {
        // 使用类型断言
        (this.state as Record<string, unknown>)[key] = (newState as Record<string, unknown>)[key];
      }
    }
    this.notifyListeners();
  }

  // 通知所有监听器
  private notifyListeners() {
    this.listeners.forEach(listener => listener(this.state));
  }

  // 从本地存储加载用户信息
  private async loadUserFromStorage() {
    try {
      this.setState({ loading: true });

      const storage = await StorageUtils.getInstance();
      const savedUser = await storage.getObject<User>('currentUser', null);
      if (savedUser) {
        this.state.currentUser = savedUser;
        this.state.isLoggedIn = true;
        this.notifyListeners();
      }
    } catch (error) {
      console.error('加载用户信息失败:', error);
    } finally {
      this.setState({ loading: false });
    }
  }

  // 登录
  public async login(username: string, password: string): Promise<boolean> {
    try {
      this.setState({ loading: true, error: null });

      // 模拟网络请求延迟
      await new Promise(resolve => setTimeout(resolve, 500));

      // 模拟用户数据
      const mockUsers: User[] = [
        {
          id: 1,
          username: 'admin',
          password: 'admin123',
          nickname: '管理员',
          avatar: '',
          phone: '00000000000',
          email: 'admin@example.com',
          role: 'admin',
          creditScore: 100,
          level: 10,
          experience: 9999,
          createTime: new Date().toISOString(),
          updateTime: new Date().toISOString()
        },
        {
          id: 2,
          username: 'user',
          password: 'user123',
          nickname: '普通用户',
          avatar: '',
          phone: '00000000000',
          email: 'user@example.com',
          role: 'user',
          creditScore: 80,
          level: 5,
          experience: 1000,
          createTime: new Date().toISOString(),
          updateTime: new Date().toISOString()
        }
      ];

      // 查找用户
      const user = mockUsers.find(u => u.username === username && u.password === password);

      if (user) {
        // 更新当前用户
        this.state.currentUser = user;
        this.state.isLoggedIn = true;

        // 保存到本地存储
        const storage = await StorageUtils.getInstance();
        await storage.setObject('currentUser', user);

        this.notifyListeners();
        return true;
      } else {
        this.setState({ error: '用户名或密码错误' });
        return false;
      }
    } catch (error) {
      this.setState({ error: '登录失败，请稍后重试' });
      return false;
    } finally {
      this.setState({ loading: false });
    }
  }

  // 注册
  public async register(userData: Partial<User>): Promise<boolean> {
    try {
      this.setState({ loading: true, error: null });

      // 模拟网络请求延迟
      await new Promise(resolve => setTimeout(resolve, 500));

      // 检查必要字段
      if (!userData.username || !userData.password) {
        this.setState({ error: '用户名和密码不能为空' });
        return false;
      }

      // 模拟注册成功
      const newUser: User = {
        id: Math.floor(Math.random() * 10000) + 1000,
        username: userData.username,
        password: userData.password,
        nickname: userData.nickname || userData.username,
        avatar: userData.avatar || '',
        phone: userData.phone || '',
        email: userData.email || '',
        role: 'user',
        creditScore: 60,
        level: 1,
        experience: 0,
        createTime: new Date().toISOString(),
        updateTime: new Date().toISOString()
      };

      // 自动登录
      this.state.currentUser = newUser;
      this.state.isLoggedIn = true;

      // 保存到本地存储
      const storage = await StorageUtils.getInstance();
      await storage.setObject('currentUser', newUser);

      this.notifyListeners();
      return true;
    } catch (error) {
      this.setState({ error: '注册失败，请稍后重试' });
      return false;
    } finally {
      this.setState({ loading: false });
    }
  }

  // 退出登录
  public async logout(): Promise<void> {
    try {
      this.setState({ loading: true });

      // 模拟网络请求延迟
      await new Promise(resolve => setTimeout(resolve, 300));

      // 清除用户信息
      this.state.currentUser = null;
      this.state.isLoggedIn = false;

      // 清除本地存储
      const storage = await StorageUtils.getInstance();
      await storage.removeItem('currentUser');

      this.notifyListeners();
    } catch (error) {
      console.error('退出登录失败', error);
    } finally {
      this.setState({ loading: false });
    }
  }

  // 更新用户信息
  public async updateUser(userData: Partial<User>): Promise<boolean> {
    try {
      this.setState({ loading: true, error: null });

      if (!this.state.currentUser) {
        this.setState({ error: '用户未登录' });
        return false;
      }

      // 模拟网络请求延迟
      await new Promise(resolve => setTimeout(resolve, 500));

      // 更新用户信息
      const updatedUser: User = {
        id: this.state.currentUser.id,
        username: userData.username || this.state.currentUser.username,
        password: userData.password || this.state.currentUser.password,
        nickname: userData.nickname || this.state.currentUser.nickname,
        avatar: userData.avatar || this.state.currentUser.avatar,
        phone: userData.phone || this.state.currentUser.phone,
        email: userData.email || this.state.currentUser.email,
        role: this.state.currentUser.role,
        creditScore: this.state.currentUser.creditScore,
        level: this.state.currentUser.level,
        experience: this.state.currentUser.experience,
        createTime: this.state.currentUser.createTime,
        updateTime: new Date().toISOString()
      };

      this.state.currentUser = updatedUser;

      // 更新本地存储
      const storage = await StorageUtils.getInstance();
      await storage.setObject('currentUser', updatedUser);

      this.notifyListeners();
      return true;
    } catch (error) {
      this.setState({ error: '更新用户信息失败' });
      return false;
    } finally {
      this.setState({ loading: false });
    }
  }

  // 修改密码
  public async changePassword(oldPassword: string, newPassword: string): Promise<boolean> {
    try {
      this.setState({ loading: true, error: null });

      if (!this.state.currentUser) {
        this.setState({ error: '用户未登录' });
        return false;
      }

      // 检查旧密码
      if (this.state.currentUser.password !== oldPassword) {
        this.setState({ error: '旧密码错误' });
        return false;
      }

      // 模拟网络请求延迟
      await new Promise(resolve => setTimeout(resolve, 500));

      // 更新密码
      this.state.currentUser.password = newPassword;
      this.state.currentUser.updateTime = new Date().toISOString();

      // 更新本地存储
      const storage = await StorageUtils.getInstance();
      await storage.setObject('currentUser', this.state.currentUser);

      this.notifyListeners();
      return true;
    } catch (error) {
      this.setState({ error: '修改密码失败' });
      return false;
    } finally {
      this.setState({ loading: false });
    }
  }

  // 增加经验值
  public async addExperience(amount: number): Promise<void> {
    try {
      if (!this.state.currentUser) return;

      const oldLevel = this.state.currentUser.level;
      this.state.currentUser.experience += amount;

      // 检查是否升级
      const newLevel = this.calculateLevel(this.state.currentUser.experience);
      if (newLevel > oldLevel) {
        this.state.currentUser.level = newLevel;
        // 这里可以触发升级事件
      }

      this.state.currentUser.updateTime = new Date().toISOString();

      // 更新本地存储
      const storage = await StorageUtils.getInstance();
      await storage.setObject('currentUser', this.state.currentUser);

      this.notifyListeners();
    } catch (error) {
      console.error('增加经验值失败', error);
    }
  }

  // 增加信用分
  public async addCreditScore(amount: number): Promise<void> {
    try {
      if (!this.state.currentUser) return;

      this.state.currentUser.creditScore = Math.min(100, this.state.currentUser.creditScore + amount);
      this.state.currentUser.updateTime = new Date().toISOString();

      // 更新本地存储
      const storage = await StorageUtils.getInstance();
      await storage.setObject('currentUser', this.state.currentUser);

      this.notifyListeners();
    } catch (error) {
      console.error('增加信用分失败', error);
    }
  }

  // 根据经验值计算等级
  private calculateLevel(experience: number): number {
    const levels = [
      0,    // Lv.1
      100,  // Lv.2
      300,  // Lv.3
      600,  // Lv.4
      1000, // Lv.5
      1500, // Lv.6
      2100, // Lv.7
      2800, // Lv.8
      3600, // Lv.9
      4500  // Lv.10
    ];

    for (let i = levels.length - 1; i >= 0; i--) {
      if (experience >= levels[i]) {
        return i + 1;
      }
    }

    return 1;
  }

  // 获取当前用户
  public getCurrentUser(): User | null {
    return this.state.currentUser;
  }

  // 检查是否已登录
  public isLoggedIn(): boolean {
    return this.state.isLoggedIn;
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