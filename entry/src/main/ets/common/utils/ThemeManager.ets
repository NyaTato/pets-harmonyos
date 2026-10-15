/**
 * 主题管理工具类
 * 用于管理深色模式和主题切换
 */
import { CommonStyles } from '../css/CommonStyles';

export class ThemeManager {
  // 存储深色模式状态
  private static isDarkMode: boolean = false;

  /**
   * 初始化主题
   */
  static initTheme(): void {
    // 这里可以从本地存储读取用户设置
    // 暂时使用默认值
    ThemeManager.isDarkMode = false;
  }

  /**
   * 获取当前是否为深色模式
   */
  static getDarkMode(): boolean {
    return ThemeManager.isDarkMode;
  }

  /**
   * 设置深色模式
   */
  static setDarkMode(isDark: boolean): void {
    ThemeManager.isDarkMode = isDark;
  }

  /**
   * 切换深色模式
   */
  static toggleDarkMode(): boolean {
    ThemeManager.isDarkMode = !ThemeManager.isDarkMode;
    ThemeManager.setDarkMode(ThemeManager.isDarkMode);
    return ThemeManager.isDarkMode;
  }

  /**
   * 获取主题相关颜色
   */
  static getThemeColors(): ThemeColors {
    return ThemeManager.isDarkMode ? darkThemeColors : lightThemeColors;
  }

  /**
   * 获取背景颜色
   */
  static getBackgroundColor(): string {
    return ThemeManager.isDarkMode ? CommonStyles.BG_DARK : CommonStyles.BG_LIGHT;
  }

  /**
   * 获取卡片背景颜色
   */
  static getCardBackgroundColor(): string {
    return ThemeManager.isDarkMode ? CommonStyles.GRAY_800 : CommonStyles.WHITE;
  }

  /**
   * 获取文字颜色
   */
  static getTextColor(): string {
    return ThemeManager.isDarkMode ? CommonStyles.TEXT_LIGHT : CommonStyles.TEXT_PRIMARY;
  }

  /**
   * 获取次要文字颜色
   */
  static getSecondaryTextColor(): string {
    return ThemeManager.isDarkMode ? CommonStyles.GRAY_400 : CommonStyles.TEXT_SECONDARY;
  }
}

// 主题颜色定义
interface ThemeColors {
  background: string;
  cardBackground: string;
  textPrimary: string;
  textSecondary: string;
  borderColor: string;
  shadowColor: string;
}

// 浅色主题
const lightThemeColors: ThemeColors = {
  background: CommonStyles.BG_LIGHT,
  cardBackground: CommonStyles.WHITE,
  textPrimary: CommonStyles.TEXT_PRIMARY,
  textSecondary: CommonStyles.TEXT_SECONDARY,
  borderColor: CommonStyles.GRAY_200,
  shadowColor: '#0F172A1A'
};

// 深色主题
const darkThemeColors: ThemeColors = {
  background: CommonStyles.BG_DARK,
  cardBackground: CommonStyles.GRAY_800,
  textPrimary: CommonStyles.TEXT_LIGHT,
  textSecondary: CommonStyles.GRAY_400,
  borderColor: CommonStyles.GRAY_700,
  shadowColor: '#0000004D'
};