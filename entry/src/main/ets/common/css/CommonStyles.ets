import { ShadowOptions } from './StyleTypes';

export class CommonStyles {

  // ==================== 三色品牌体系 (核心) ====================

  // 主品牌色 - 青碧色 Teal (AI/智能/成长/生命)
  static readonly PRIMARY: string = '#14B8A6';
  static readonly PRIMARY_DARK: string = '#0D9488';
  static readonly PRIMARY_LIGHT: string = '#5EEAD4';
  static readonly PRIMARY_BG: string = '#F0FDFA';
  static readonly PRIMARY_SUBTLE: string = '#CCFBF1';

  // AR科技色 - 靛蓝 Indigo (AR/未来/沉浸/创新)
  static readonly AR: string = '#6366F1';
  static readonly AR_DARK: string = '#4F46E5';
  static readonly AR_LIGHT: string = '#A5B4FC';
  static readonly AR_BG: string = '#EEF2FF';
  static readonly AR_GLOW: string = 'rgba(99,102,241,0.25)';
  static readonly AR_SUBTLE: string = '#C7D2FE';

  // IoT守护色 - 琥珀 Amber (IoT/守护/温暖/行动)
  static readonly IOT: string = '#F59E0B';
  static readonly IOT_DARK: string = '#D97706';
  static readonly IOT_LIGHT: string = '#FCD34D';
  static readonly IOT_BG: string = '#FFFBEB';
  static readonly IOT_ALERT: string = '#EF4444';

  // 辅助色 - 橙色（保留向后兼容）
  static readonly SECONDARY: string = '#FB923C';
  static readonly SECONDARY_DARK: string = '#EA580C';
  static readonly SECONDARY_LIGHT: string = '#FED7AA';

  // ==================== 功能语义色 ====================

  static readonly SUCCESS: string = '#10B981';
  static readonly SUCCESS_LIGHT: string = '#D1FAE5';
  static readonly SUCCESS_BG: string = '#ECFDF5';
  static readonly SUCCESS_COLOR: string = '#10B981';

  static readonly WARNING: string = '#F59E0B';
  static readonly WARNING_LIGHT: string = '#FEF3C7';
  static readonly WARNING_BG: string = '#FFFBEB';
  static readonly WARNING_COLOR: string = '#F59E0B';

  static readonly DANGER: string = '#EF4444';
  static readonly DANGER_LIGHT: string = '#FEE2E2';
  static readonly DANGER_BG: string = '#FEF2F2';
  static readonly DANGER_COLOR: string = '#EF4444';

  static readonly INFO: string = '#3B82F6';
  static readonly INFO_LIGHT: string = '#DBEAFE';
  static readonly INFO_BG: string = '#EFF6FF';
  static readonly INFO_COLOR: string = '#3B82F6';

  // 向后兼容别名
  static readonly PRIMARY_COLOR: string = '#14B8A6';
  static readonly SECONDARY_COLOR: string = '#FB923C';

  // ==================== 灰度色阶 (向后兼容) ====================

  static readonly GRAY_50: string = '#F8FAFC';
  static readonly GRAY_100: string = '#F1F5F9';
  static readonly GRAY_200: string = '#E2E8F0';
  static readonly GRAY_300: string = '#CBD5E1';
  static readonly GRAY_400: string = '#94A3B8';
  static readonly GRAY_500: string = '#64748B';
  static readonly GRAY_600: string = '#475569';
  static readonly GRAY_700: string = '#334155';
  static readonly GRAY_800: string = '#1E293B';
  static readonly GRAY_900: string = '#0F172A';

  // ==================== 中性灰度系统 (Slate) ====================

  static readonly WHITE: string = '#FFFFFF';
  static readonly BLACK: string = '#0F172A';

  // 文字层级
  static readonly TEXT_PRIMARY: string = '#0F172A';
  static readonly TEXT_SECONDARY: string = '#334155';
  static readonly TEXT_TERTIARY: string = '#64748B';
  static readonly TEXT_DISABLED: string = '#94A3B8';
  static readonly TEXT_PLACEHOLDER: string = '#CBD5E1';
  static readonly TEXT_INVERSE: string = '#FFFFFF';
  static readonly TEXT_PRIMARY_BRAND: string = '#14B8A6';
  static readonly TEXT_LIGHT: string = '#94A3B8';

  // 背景层级
  static readonly BG_BASE: string = '#FFFFFF';
  static readonly BG_SURFACE: string = '#F8FAFC';
  static readonly BG_ELEVATED: string = '#F1F5F9';
  static readonly BG_MUTED: string = '#E2E8F0';
  static readonly BG_OVERLAY: string = 'rgba(15,23,42,0.5)';

  // 向后兼容
  static readonly BG_PRIMARY: string = '#FFFFFF';
  static readonly BG_SECONDARY: string = '#F8FAFC';
  static readonly BG_TERTIARY: string = '#F1F5F9';
  static readonly COLOR_BG: string = '#F8FAFC';
  static readonly BG_LIGHT: string = '#F8FAFC';
  static readonly BG_DARK: string = '#0F172A';

  // 边框
  static readonly BORDER_DEFAULT: string = '#E2E8F0';
  static readonly BORDER_STRONG: string = '#CBD5E1';
  static readonly BORDER_SUBTLE: string = '#F1F5F9';
  static readonly BORDER_BRAND: string = '#99F6E4';
  static readonly BORDER_FOCUS: string = '#14B8A6';

  // 向后兼容
  static readonly BORDER_LIGHT: string = '#E2E8F0';

  // ==================== 渐变色库 ====================

  // 品牌主渐变
  static readonly GRADIENT_BRAND: string = 'linear-gradient(135deg, #14B8A6 0%, #06B6D4 50%, #3B82F6 100%)';

  // AR科技渐变
  static readonly GRADIENT_AR: string = 'linear-gradient(135deg, #6366F1 0%, #8B5CF6 50%, #A78BFA 100%)';

  // 温暖守护渐变
  static readonly GRADIENT_IOT: string = 'linear-gradient(135deg, #F59E0B 0%, #FB923C 50%, #EF4444 100%)';

  // 成功渐变
  static readonly GRADIENT_SUCCESS: string = 'linear-gradient(135deg, #10B981 0%, #34D399 100%)';

  // 卡片微妙渐变
  static readonly GRADIENT_CARD: string = 'linear-gradient(180deg, #FFFFFF 0%, #F8FAFC 100%)';

  // 背景氛围渐变
  static readonly GRADIENT_ATMOSPHERE: string = 'linear-gradient(180deg, #F0FDFA 0%, #FFFFFF 30%, #F8FAFC 100%)';

  // 向后兼容
  static readonly GRADIENT_WARM: string = 'linear-gradient(135deg, #FB923C 0%, #EF4444 100%)';
  static readonly GRADIENT_COOL: string = 'linear-gradient(135deg, #3B82F6 0%, #8B5CF6 100%)';
  static readonly GRADIENT_BG: string = 'linear-gradient(180deg, #F0FDFA 0%, #CCFBF1 50%, #FFFFFF 100%)';

  // ==================== 圆角规范 (更圆润友好) ====================

  static readonly RADIUS_NONE: number = 0;
  static readonly RADIUS_XS: number = 6;
  static readonly RADIUS_SM: number = 8;
  static readonly RADIUS_MD: number = 12;
  static readonly RADIUS_LG: number = 16;
  static readonly RADIUS_XL: number = 20;
  static readonly RADIUS_2XL: number = 24;
  static readonly RADIUS_FULL: number = 999;

  // 向后兼容
  static readonly RADIUS_SM_OLD: number = 8;

  // ==================== 阴影系统 (增强) ====================

  static readonly SHADOW_NONE: ShadowOptions = { radius: 0, color: 'transparent', offsetX: 0, offsetY: 0 };
  static readonly SHADOW_XS: ShadowOptions = { radius: 2, color: 'rgba(15,23,42,0.04)', offsetX: 0, offsetY: 1 };
  static readonly SHADOW_SM: ShadowOptions = { radius: 4, color: 'rgba(15,23,42,0.06)', offsetX: 0, offsetY: 1 };
  static readonly SHADOW_MD: ShadowOptions = { radius: 8, color: 'rgba(15,23,42,0.08)', offsetX: 0, offsetY: 2 };
  static readonly SHADOW_LG: ShadowOptions = { radius: 16, color: 'rgba(15,23,42,0.10)', offsetX: 0, offsetY: 4 };
  static readonly SHADOW_XL: ShadowOptions = { radius: 20, color: 'rgba(15,23,42,0.12)', offsetX: 0, offsetY: 8 };

  // 品牌发光阴影
  static readonly SHADOW_BRAND_TEAL: ShadowOptions = { radius: 16, color: 'rgba(20,184,166,0.35)', offsetX: 0, offsetY: 4 };
  static readonly SHADOW_AR_TEAL: ShadowOptions = { radius: 16, color: 'rgba(99,102,241,0.35)', offsetX: 0, offsetY: 4 };
  static readonly SHADOW_IOT_TEAL: ShadowOptions = { radius: 16, color: 'rgba(245,158,11,0.30)', offsetX: 0, offsetY: 4 };

  // 内阴影
  static readonly SHADOW_INNER: string = 'inset 0 2px 4px rgba(0,0,0,0.06)';

  // 向后兼容
  static readonly SHADOW_SM_OLD: ShadowOptions = { radius: 2, color: '#0F172A08', offsetX: 0, offsetY: 1 };
  static readonly SHADOW_MD_OLD: ShadowOptions = { radius: 4, color: '#0F172A12', offsetX: 0, offsetY: 2 };
  static readonly SHADOW_LG_OLD: ShadowOptions = { radius: 10, color: '#0F172A14', offsetX: 0, offsetY: 4 };
  static readonly SHADOW_XL_OLD: ShadowOptions = { radius: 20, color: '#0F172A18', offsetX: 0, offsetY: 8 };
  static readonly SHADOW_BRAND_OLD: ShadowOptions = { radius: 16, color: '#2DD4BF40', offsetX: 0, offsetY: 8 };

  // ==================== 间距系统 (基于4px网格) ====================

  static readonly SPACE_XXS: number = 2;
  static readonly SPACE_XS: number = 4;
  static readonly SPACE_SM: number = 8;
  static readonly SPACE_MD: number = 12;
  static readonly SPACE_LG: number = 16;
  static readonly SPACE_XL: number = 20;
  static readonly SPACE_2XL: number = 24;
  static readonly SPACE_3XL: number = 32;
  static readonly SPACE_4XL: number = 48;
  static readonly SPACE_5XL: number = 64;

  // 别名
  static readonly XS: number = 4;
  static readonly SM: number = 8;
  static readonly MD: number = 12;
  static readonly LG: number = 16;
  static readonly XL: number = 20;
  static readonly XXL: number = 24;

  // 向后兼容
  static readonly SPACE_0: number = 0;
  static readonly SPACE_1: number = 4;
  static readonly SPACE_2: number = 8;
  static readonly SPACE_3: number = 12;
  static readonly SPACE_4: number = 16;
  static readonly SPACE_5: number = 20;
  static readonly SPACE_6: number = 24;
  static readonly SPACE_7: number = 28;
  static readonly SPACE_8: number = 32;
  static readonly SPACE_9: number = 40;
  static readonly SPACE_10: number = 48;

  // ==================== 字体排版层级 ====================

  // Display (巨型标题)
  static readonly FONT_SIZE_DISPLAY: number = 32;

  // 标题层级
  static readonly FONT_SIZE_H1: number = 24;
  static readonly FONT_SIZE_H2: number = 20;
  static readonly FONT_SIZE_H3: number = 17;

  // 正文
  static readonly FONT_SIZE_BODY_LARGE: number = 16;
  static readonly FONT_SIZE_BODY: number = 15;
  static readonly FONT_SIZE_BODY_SMALL: number = 13;

  // 辅助文字
  static readonly FONT_SIZE_CAPTION: number = 12;
  static readonly FONT_SIZE_OVERLINE: number = 11;

  // 数据展示 (大号数字)
  static readonly FONT_SIZE_DATA_LG: number = 28;
  static readonly FONT_SIZE_DATA_XL: number = 36;
  static readonly FONT_SIZE_DATA_2XL: number = 48;

  // 别名
  static readonly FONT_SIZE_XS: number = 11;
  static readonly FONT_SIZE_SM: number = 13;
  static readonly FONT_SIZE_MD: number = 15;
  static readonly FONT_SIZE_LG: number = 17;
  static readonly FONT_SIZE_XL: number = 20;
  static readonly FONT_SIZE_2XL: number = 24;
  static readonly FONT_SIZE_3XL: number = 28;
  static readonly FONT_SIZE_4XL: number = 32;

  // 字重
  static readonly FONT_WEIGHT_NORMAL: number = 400;
  static readonly FONT_WEIGHT_MEDIUM: number = 500;
  static readonly FONT_WEIGHT_SEMIBOLD: number = 600;
  static readonly FONT_WEIGHT_BOLD: number = 700;

  // 行高
  static readonly LINE_HEIGHT_TIGHT: number = 1.2;
  static readonly LINE_HEIGHT_NORMAL: number = 1.35;
  static readonly LINE_HEIGHT_RELAXED: number = 1.4;
  static readonly LINE_HEIGHT_LOOSE: number = 1.5;

  // 向后兼容
  static readonly LINE_HEIGHT_TIGHT_OLD: number = 1.25;
  static readonly LINE_HEIGHT_NORMAL_OLD: number = 1.5;
  static readonly LINE_HEIGHT_RELAXED_OLD: number = 1.75;

  // ==================== 按钮尺寸规范 ====================

  static readonly BUTTON_HEIGHT_ICON: number = 36;
  static readonly BUTTON_HEIGHT_SM: number = 38;
  static readonly BUTTON_HEIGHT_MD: number = 44;
  static readonly BUTTON_HEIGHT_LG: number = 48;
  static readonly BUTTON_HEIGHT_XL: number = 52;
  static readonly BUTTON_HEIGHT_2XL: number = 60;

  // 按钮宽度
  static readonly BUTTON_WIDTH_SM: number = 80;
  static readonly BUTTON_WIDTH_MD: number = 120;
  static readonly BUTTON_WIDTH_LG: number = 160;
  static readonly BUTTON_WIDTH_XL: number = 200;
  static readonly BUTTON_WIDTH_2XL: number = 240;

  // 向后兼容
  static readonly BUTTON_HEIGHT_SM_OLD: number = 36;
  static readonly BUTTON_HEIGHT_MD_OLD: number = 44;
  static readonly BUTTON_HEIGHT_LG_OLD: number = 52;
  static readonly BUTTON_HEIGHT_XL_OLD: number = 60;

  // ==================== 输入框尺寸 ====================

  static readonly INPUT_HEIGHT: number = 52;
  static readonly INPUT_HEIGHT_MD: number = 48;

  // ==================== 图标尺寸 ====================

  static readonly ICON_SIZE_XXS: number = 12;
  static readonly ICON_SIZE_XS: number = 16;
  static readonly ICON_SIZE_SM: number = 20;
  static readonly ICON_SIZE_MD: number = 24;   // 标准
  static readonly ICON_SIZE_LG: number = 28;
  static readonly ICON_SIZE_XL: number = 32;
  static readonly ICON_SIZE_2XL: number = 40;  // 功能入口
  static readonly ICON_SIZE_TOUCH: number = 44; // 触摸目标最小

  // 向后兼容
  static readonly ICON_SIZE_SM_OLD: number = 20;
  static readonly ICON_SIZE_MD_OLD: number = 24;
  static readonly ICON_SIZE_LG_OLD: number = 32;
  static readonly ICON_SIZE_XL_OLD: number = 40;
  static readonly ICON_SIZE_2XL_OLD: number = 48;
  static readonly ICON_SIZE_3XL_OLD: number = 56;
  static readonly ICON_SIZE_TOUCH_OLD: number = 44;

  // ==================== 头像尺寸 ====================

  static readonly AVATAR_SIZE_XS: number = 32;
  static readonly AVATAR_SIZE_SM: number = 40;
  static readonly AVATAR_SIZE_MD: number = 48;
  static readonly AVATAR_SIZE_LG: number = 64;
  static readonly AVATAR_SIZE_XL: number = 80;
  static readonly AVATAR_SIZE_2XL: number = 96;
  static readonly AVATAR_SIZE_HERO: number = 120;

  // ==================== 尺寸预设 ====================

  static readonly SIZE_SM: number = 32;
  static readonly SIZE_MD: number = 48;
  static readonly SIZE_LG: number = 64;
  static readonly SIZE_XL: number = 96;
  static readonly SIZE_2XL: number = 128;

  // ==================== 导航栏高度 ====================

  static readonly NAV_BAR_HEIGHT: number = 56;
  static readonly TAB_BAR_HEIGHT: number = 60;
  static readonly TAB_BAR_HEIGHT_WITH_SAFE_AREA: string = 'calc(60vp + env(safe-area-inset-bottom))';
  static readonly SAFE_AREA_BOTTOM: string = 'env(safe-area-inset-bottom)';

  // ==================== 动画时长 ====================

  static readonly ANIMATION_FAST: number = 150;
  static readonly ANIMATION_NORMAL: number = 250;
  static readonly ANIMATION_SLOW: number = 350;
  static readonly ANIMATION_SPRING: number = 400;
  static readonly ANIMATION_PAGE_TRANSITION: number = 300;

  // ==================== 页面布局常量 ====================

  static readonly PAGE_PADDING_H: number = 16;
  static readonly PAGE_PADDING_V_TOP: number = 16;
  static readonly PAGE_PADDING_V_BOTTOM: number = 32;
  static readonly SECTION_GAP: number = 18;
  static readonly CARD_INNER_PADDING: number = 16;
  static readonly CARD_GAP: number = 12;

  // ==================== 状态颜色映射工具方法 ====================

  /**
   * 根据模块获取主题色
   */
  static getThemeColor(module: 'ar' | 'ai' | 'iot' | 'default'): string {
    switch (module) {
      case 'ar': return CommonStyles.AR;
      case 'ai': return CommonStyles.PRIMARY;
      case 'iot': return CommonStyles.IOT;
      default: return CommonStyles.PRIMARY;
    }
  }

  /**
   * 根据分值返回状态色 (>80绿 / 60-80黄 / <60红)
   */
  static getScoreColor(score: number): string {
    if (score >= 95) return '#10B981';
    if (score >= 85) return '#14B8A6';
    if (score >= 70) return '#F59E0B';
    return '#EF4444';
  }
}
