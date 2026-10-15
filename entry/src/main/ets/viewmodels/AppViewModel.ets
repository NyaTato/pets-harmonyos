/**
 * 应用ViewModel
 * 管理应用全局状态和主题
 */

import { StorageUtils } from '../utils/StorageUtils';

// 应用主题
export type AppTheme = 'light' | 'dark' | 'auto';

// 应用状态接口
interface AppState {
  theme: AppTheme;
  isDarkMode: boolean;
  language: 'zh' | 'en';
  notificationsEnabled: boolean;
  loading: boolean;
  error: string | null;
}

// 应用ViewModel
export class AppViewModel {
  // 单例实例
  private static instance: AppViewModel;

  // 状态
  private state: AppState = {
    theme: 'auto',
    isDarkMode: false,
    language: 'zh',
    notificationsEnabled: true,
    loading: false,
    error: null
  };

  // 状态监听器
  private listeners: Array<(state: AppState) => void> = [];

  // 私有构造函数
  private constructor() {
    this.loadAppSettings();
    this.checkDarkMode();
  }

  // 获取单例实例
  public static getInstance(): AppViewModel {
    if (!AppViewModel.instance) {
      AppViewModel.instance = new AppViewModel();
    }
    return AppViewModel.instance;
  }

  // 获取当前状态
  public getState(): AppState {
    return { ...this.state };
  }

  // 注册状态监听器
  public subscribe(listener: (state: AppState) => void): () => void {
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
  private setState(newState: Partial<AppState>) {
    this.state = { ...this.state, ...newState };
    this.notifyListeners();
  }

  // 通知所有监听器
  private notifyListeners() {
    this.listeners.forEach(listener => listener(this.state));
  }

  // 加载应用设置
  private async loadAppSettings() {
    try {
      this.setState({ loading: true });

      const settings = await StorageUtils.getObject<Partial<AppState>>('appSettings');
      if (settings) {
        this.state = { ...this.state, ...settings };
        this.checkDarkMode();
      }
    } catch (error) {
      console.error('加载应用设置失败:', error);
    } finally {
      this.setState({ loading: false });
    }
  }

  // 检查深色模式
  private checkDarkMode() {
    if (this.state.theme === 'auto') {
      // 这里可以根据系统设置自动检测
      // 暂时设置为浅色模式
      this.state.isDarkMode = false;
    } else {
      this.state.isDarkMode = this.state.theme === 'dark';
    }
  }

  // 保存应用设置
  private async saveAppSettings() {
    try {
      await StorageUtils.setObject('appSettings', {
        theme: this.state.theme,
        language: this.state.language,
        notificationsEnabled: this.state.notificationsEnabled
      });
    } catch (error) {
      console.error('保存应用设置失败:', error);
    }
  }

  // 切换主题
  public async setTheme(theme: AppTheme): Promise<void> {
    try {
      this.setState({ loading: true });

      this.state.theme = theme;
      this.checkDarkMode();

      await this.saveAppSettings();
      this.notifyListeners();
    } catch (error) {
      console.error('切换主题失败:', error);
      this.setState({ error: '切换主题失败' });
    } finally {
      this.setState({ loading: false });
    }
  }

  // 切换深色模式
  public async toggleDarkMode(): Promise<void> {
    try {
      this.setState({ loading: true });

      this.state.isDarkMode = !this.state.isDarkMode;
      this.state.theme = this.state.isDarkMode ? 'dark' : 'light';

      await this.saveAppSettings();
      this.notifyListeners();
    } catch (error) {
      console.error('切换深色模式失败:', error);
      this.setState({ error: '切换深色模式失败' });
    } finally {
      this.setState({ loading: false });
    }
  }

  // 设置语言
  public async setLanguage(language: 'zh' | 'en'): Promise<void> {
    try {
      this.setState({ loading: true });

      this.state.language = language;

      await this.saveAppSettings();
      this.notifyListeners();
    } catch (error) {
      console.error('设置语言失败:', error);
      this.setState({ error: '设置语言失败' });
    } finally {
      this.setState({ loading: false });
    }
  }

  // 切换通知开关
  public async toggleNotifications(): Promise<void> {
    try {
      this.setState({ loading: true });

      this.state.notificationsEnabled = !this.state.notificationsEnabled;

      await this.saveAppSettings();
      this.notifyListeners();
    } catch (error) {
      console.error('切换通知开关失败', error);
      this.setState({ error: '切换通知开关失败' });
    } finally {
      this.setState({ loading: false });
    }
  }

  // 获取主题颜色
  public getThemeColors() {
    if (this.state.isDarkMode) {
      return {
        background: '#1A1A1A',
        surface: '#2D2D2D',
        text: '#FFFFFF',
        textSecondary: '#CCCCCC',
        border: '#404040',
        primary: '#4CAF50',
        secondary: '#2196F3',
        error: '#F44336',
        success: '#4CAF50',
        warning: '#FF9800'
      };
    } else {
      return {
        background: '#FFFFFF',
        surface: '#F5F5F5',
        text: '#333333',
        textSecondary: '#666666',
        border: '#E0E0E0',
        primary: '#4CAF50',
        secondary: '#2196F3',
        error: '#F44336',
        success: '#4CAF50',
        warning: '#FF9800'
      };
    }
  }

  // 获取当前主题
  public getTheme(): AppTheme {
    return this.state.theme;
  }

  // 是否深色模式
  public isDarkMode(): boolean {
    return this.state.isDarkMode;
  }

  // 获取当前语言
  public getLanguage(): 'zh' | 'en' {
    return this.state.language;
  }

  // 通知是否启用
  public isNotificationsEnabled(): boolean {
    return this.state.notificationsEnabled;
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

  // 重置应用设置
  public async resetSettings(): Promise<void> {
    try {
      this.setState({ loading: true });

      this.state = {
        theme: 'auto',
        isDarkMode: false,
        language: 'zh',
        notificationsEnabled: true,
        loading: false,
        error: null
      };

      await StorageUtils.remove('appSettings');
      this.notifyListeners();
    } catch (error) {
      console.error('重置设置失败:', error);
      this.setState({ error: '重置设置失败' });
    } finally {
      this.setState({ loading: false });
    }
  }
}