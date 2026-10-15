// 存储工具类（简化版本）
// 在实际应用中，应该使用@ohos.data.storage
// 这里使用内存存储作为简化实现

// 存储键名类型定义
interface StorageKeys {
  USER_TOKEN: string;
  USER_INFO: string;
  USER_PREFERENCES: string;
  SEARCH_HISTORY: string;
  NOTIFICATION_SETTINGS: string;
  THEME_MODE: string;
  LANGUAGE: string;
  FIRST_LAUNCH: string;
  REMEMBER_ME: string;
  SAVED_USERNAME: string;
  SAVED_PASSWORD: string;
}

export class StorageUtils {
  private static instance: StorageUtils | null = null;
  private storage: Map<string, string> = new Map();

  // 存储键名常量
  static readonly KEYS: StorageKeys = {
    USER_TOKEN: 'user_token',
    USER_INFO: 'user_info',
    USER_PREFERENCES: 'user_preferences',
    SEARCH_HISTORY: 'search_history',
    NOTIFICATION_SETTINGS: 'notification_settings',
    THEME_MODE: 'theme_mode',
    LANGUAGE: 'language',
    FIRST_LAUNCH: 'first_launch',
    REMEMBER_ME: 'remember_me',
    SAVED_USERNAME: 'saved_username',
    SAVED_PASSWORD: 'saved_password' // 注意：实际应用中密码应该加密存储
  };

  private constructor() {
    // 私有构造函数，单例模式
  }

  /**
   * 获取存储实例
   */
  static getInstance(): StorageUtils {
    if (!StorageUtils.instance) {
      StorageUtils.instance = new StorageUtils();
    }
    return StorageUtils.instance;
  }

  /**
   * 设置字符串值
   */
  setString(key: string, value: string): void {
    try {
      this.storage.set(key, value);
    } catch (error) {
      console.error('Failed to set string:', error);
    }
  }

  /**
   * 获取字符串值
   */
  getString(key: string, defaultValue: string = ''): string {
    try {
      return this.storage.get(key) || defaultValue;
    } catch (error) {
      console.error('Failed to get string:', error);
      return defaultValue;
    }
  }

  /**
   * 删除存储值
   */
  remove(key: string): void {
    try {
      this.storage.delete(key);
    } catch (error) {
      console.error('Failed to remove item:', error);
    }
  }

  /**
   * 清空所有存储
   */
  clear(): void {
    try {
      this.storage.clear();
    } catch (error) {
      console.error('Failed to clear storage:', error);
    }
  }

  /**
   * 设置JSON对象
   */
  setObject(key: string, value: object): void {
    try {
      const jsonString = JSON.stringify(value);
      this.storage.set(key, jsonString);
    } catch (error) {
      console.error('Failed to set object:', error);
    }
  }

  /**
   * 获取JSON对象
   */
  getObject<T>(key: string, defaultValue: T): T {
    try {
      const jsonString = this.storage.get(key);
      if (jsonString) {
        return JSON.parse(jsonString) as T;
      }
      return defaultValue;
    } catch (error) {
      console.error('Failed to get object:', error);
      return defaultValue;
    }
  }

  /**
   * 检查键是否存在
   */
  has(key: string): boolean {
    try {
      return this.storage.has(key);
    } catch (error) {
      console.error('Failed to check key:', error);
      return false;
    }
  }
}