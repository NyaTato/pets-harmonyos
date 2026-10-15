// 主题工具类 - 统一管理深色模式样式
import { CommonStyles } from './CommonStyles';
import { ComponentStyles } from './ComponentStyles';
import { AppStore } from '../../store/AppStore';
import {
  CardStyle,
  ListItemStyle,
  ShadowOptions,
  ContainerPaddingStyle,
  SectionMarginStyle,
  LoadingContainerStyle,
  EmptyStateStyle,
  ErrorContainerStyle,
  DividerStyle
} from './StyleTypes';

export class ThemeUtils {
  // 获取当前主题模式
  static getCurrentTheme(): 'light' | 'dark' {
    const store = AppStore.getInstance();
    const state = store.getState();
    return state.theme || 'light';
  }

  // 获取是否深色模式
  static isDarkMode(): boolean {
    return ThemeUtils.getCurrentTheme() === 'dark';
  }

  // 获取文本颜色
  static getTextColor(type: 'primary' | 'secondary' | 'tertiary' | 'light' = 'primary'): string {
    const isDarkMode = ThemeUtils.isDarkMode();
    return ComponentStyles.getTextColor(isDarkMode, type);
  }

  // 获取背景颜色
  static getBackgroundColor(): string {
    const isDarkMode = ThemeUtils.isDarkMode();
    return ComponentStyles.getBackgroundColor(isDarkMode);
  }

  // 获取卡片样式
  static getCardStyle(): CardStyle {
    const isDarkMode = ThemeUtils.isDarkMode();
    return ComponentStyles.getCardStyle(isDarkMode);
  }

  // 获取列表项样式
  static getListItemStyle(): ListItemStyle {
    const isDarkMode = ThemeUtils.isDarkMode();
    return ComponentStyles.getListItemStyle(isDarkMode);
  }

  // 获取主要颜色
  static getPrimaryColor(): string {
    return CommonStyles.PRIMARY_COLOR;
  }

  // 获取成功颜色
  static getSuccessColor(): string {
    return CommonStyles.SUCCESS_COLOR;
  }

  // 获取警告颜色
  static getWarningColor(): string {
    return CommonStyles.WARNING_COLOR;
  }

  // 获取危险颜色
  static getDangerColor(): string {
    return CommonStyles.DANGER_COLOR;
  }

  // 获取信息颜色
  static getInfoColor(): string {
    return CommonStyles.INFO_COLOR;
  }

  // 获取白色
  static getWhiteColor(): string {
    return CommonStyles.WHITE;
  }

  // 获取灰色
  static getGrayColor(level: 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900): string {
    switch (level) {
      case 100: return CommonStyles.GRAY_100;
      case 200: return CommonStyles.GRAY_200;
      case 300: return CommonStyles.GRAY_300;
      case 400: return CommonStyles.GRAY_400;
      case 500: return CommonStyles.GRAY_500;
      case 600: return CommonStyles.GRAY_600;
      case 700: return CommonStyles.GRAY_700;
      case 800: return CommonStyles.GRAY_800;
      case 900: return CommonStyles.GRAY_900;
      default: return CommonStyles.GRAY_300;
    }
  }

  // 获取阴影
  static getShadow(size: 'sm' | 'md' | 'lg' | 'xl'): ShadowOptions {
    switch (size) {
      case 'sm': return CommonStyles.SHADOW_SM;
      case 'md': return CommonStyles.SHADOW_MD;
      case 'lg': return CommonStyles.SHADOW_LG;
      case 'xl': return CommonStyles.SHADOW_XL;
      default: return CommonStyles.SHADOW_MD;
    }
  }

  // 获取圆角
  static getBorderRadius(size: 'sm' | 'md' | 'lg' | 'xl' | '2xl' | 'full'): number {
    switch (size) {
      case 'sm': return CommonStyles.RADIUS_SM;
      case 'md': return CommonStyles.RADIUS_MD;
      case 'lg': return CommonStyles.RADIUS_LG;
      case 'xl': return CommonStyles.RADIUS_XL;
      case '2xl': return CommonStyles.RADIUS_2XL;
      case 'full': return CommonStyles.RADIUS_FULL;
      default: return CommonStyles.RADIUS_MD;
    }
  }

  // 获取间距
  static getSpacing(size: 'xs' | 'sm' | 'md' | 'lg' | 'xl' | '2xl' | '3xl' | '4xl'): number {
    switch (size) {
      case 'xs': return CommonStyles.SPACE_XS;
      case 'sm': return CommonStyles.SPACE_SM;
      case 'md': return CommonStyles.SPACE_MD;
      case 'lg': return CommonStyles.SPACE_LG;
      case 'xl': return CommonStyles.SPACE_XL;
      case '2xl': return CommonStyles.SPACE_2XL;
      case '3xl': return CommonStyles.SPACE_3XL;
      case '4xl': return CommonStyles.SPACE_4XL;
      default: return CommonStyles.SPACE_MD;
    }
  }

  // 获取字体大小
  static getFontSize(size: 'xs' | 'sm' | 'md' | 'lg' | 'xl' | '2xl' | '3xl' | '4xl'): number {
    switch (size) {
      case 'xs': return CommonStyles.FONT_SIZE_XS;
      case 'sm': return CommonStyles.FONT_SIZE_SM;
      case 'md': return CommonStyles.FONT_SIZE_MD;
      case 'lg': return CommonStyles.FONT_SIZE_LG;
      case 'xl': return CommonStyles.FONT_SIZE_XL;
      case '2xl': return CommonStyles.FONT_SIZE_2XL;
      case '3xl': return CommonStyles.FONT_SIZE_3XL;
      case '4xl': return CommonStyles.FONT_SIZE_4XL;
      default: return CommonStyles.FONT_SIZE_MD;
    }
  }

  // 获取字体粗细
  static getFontWeight(weight: 'normal' | 'medium' | 'semibold' | 'bold'): number {
    switch (weight) {
      case 'normal': return CommonStyles.FONT_WEIGHT_NORMAL;
      case 'medium': return CommonStyles.FONT_WEIGHT_MEDIUM;
      case 'semibold': return CommonStyles.FONT_WEIGHT_SEMIBOLD;
      case 'bold': return CommonStyles.FONT_WEIGHT_BOLD;
      default: return CommonStyles.FONT_WEIGHT_NORMAL;
    }
  }

  // 获取容器内边距
  static getContainerPadding(): ContainerPaddingStyle {
    return ComponentStyles.CONTAINER_PADDING;
  }

  // 获取区块外边距
  static getSectionMargin(): SectionMarginStyle {
    return ComponentStyles.SECTION_MARGIN;
  }

  // 获取分割线样式
  static getDividerStyle(): DividerStyle {
    return ComponentStyles.DIVIDER;
  }

  // 获取加载容器样式
  static getLoadingContainerStyle(): LoadingContainerStyle {
    return ComponentStyles.LOADING_CONTAINER;
  }

  // 获取空状态样式
  static getEmptyStateStyle(): EmptyStateStyle {
    return ComponentStyles.EMPTY_STATE;
  }

  // 获取错误容器样式
  static getErrorContainerStyle(): ErrorContainerStyle {
    return ComponentStyles.ERROR_CONTAINER;
  }
}