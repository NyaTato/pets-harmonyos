import { CommonStyles } from './CommonStyles';
import {
  SimpleBorderOptions,
  PaddingOptions,
  BorderOptions,
  ShadowOptions,
  MarginOptions,
  InputErrorStyle,
  CardStyleDark,
  ListItemDarkStyle,
  TextStyle,
  ContainerPaddingStyle,
  SectionMarginStyle,
  LoadingContainerStyle,
  EmptyStateStyle,
  ErrorContainerStyle,
  ButtonStyle,
  InputStyle,
  CardStyle,
  TagStyle,
  AvatarStyle,
  BadgeStyle,
  ProgressStyle,
  SwitchStyle,
  SliderStyle,
  TabStyle,
  ListItemStyle,
  GridItemStyle,
  ModalStyle,
  ToastStyle,
  LoadingStyle,
  DividerStyle,
  IconStyle,
  ImageStyle,
  TextAreaStyle,
  CheckboxStyle,
  RadioStyle,
  TitleStyle,
  TextSimpleStyle,
  PickerStyle,
  DatePickerStyle,
  TimePickerStyle,
  RatingStyle,
  SearchStyle
} from './StyleTypes';

export class ComponentStyles {
  // ==================== 按钮样式系统 ====================

  // 主要操作按钮 (AI/主品牌色)
  static readonly BUTTON_PRIMARY: ButtonStyle = {
    width: '100%',
    height: CommonStyles.BUTTON_HEIGHT_MD,
    fontSize: CommonStyles.FONT_SIZE_BODY,
    fontWeight: CommonStyles.FONT_WEIGHT_SEMIBOLD,
    fontColor: CommonStyles.WHITE,
    backgroundColor: CommonStyles.PRIMARY,
    borderRadius: CommonStyles.RADIUS_LG,
    stateEffect: true,
    shadow: CommonStyles.SHADOW_BRAND_TEAL
  };

  // AR科技按钮 (AR/未来感)
  static readonly BUTTON_AR: ButtonStyle = {
    width: '100%',
    height: CommonStyles.BUTTON_HEIGHT_MD,
    fontSize: CommonStyles.FONT_SIZE_BODY,
    fontWeight: CommonStyles.FONT_WEIGHT_SEMIBOLD,
    fontColor: CommonStyles.WHITE,
    backgroundColor: CommonStyles.AR,
    borderRadius: CommonStyles.RADIUS_LG,
    stateEffect: true,
    shadow: CommonStyles.SHADOW_AR_TEAL
  };

  // IoT守护按钮 (IoT/温暖行动)
  static readonly BUTTON_IOT: ButtonStyle = {
    width: '100%',
    height: CommonStyles.BUTTON_HEIGHT_MD,
    fontSize: CommonStyles.FONT_SIZE_BODY,
    fontWeight: CommonStyles.FONT_WEIGHT_SEMIBOLD,
    fontColor: CommonStyles.WHITE,
    backgroundColor: CommonStyles.IOT,
    borderRadius: CommonStyles.RADIUS_LG,
    stateEffect: true,
    shadow: CommonStyles.SHADOW_IOT_TEAL
  };

  // 次要按钮（描边）
  static readonly BUTTON_SECONDARY: ButtonStyle = {
    width: '100%',
    height: CommonStyles.BUTTON_HEIGHT_MD,
    fontSize: CommonStyles.FONT_SIZE_BODY,
    fontWeight: CommonStyles.FONT_WEIGHT_SEMIBOLD,
    fontColor: CommonStyles.PRIMARY,
    backgroundColor: CommonStyles.WHITE,
    borderRadius: CommonStyles.RADIUS_LG,
    border: {
      width: 1.5,
      color: CommonStyles.PRIMARY,
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_LG
    },
    stateEffect: true
  };

  // 文字按钮
  static readonly BUTTON_TEXT: ButtonStyle = {
    width: 'auto',
    height: CommonStyles.BUTTON_HEIGHT_SM,
    fontSize: CommonStyles.FONT_SIZE_BODY_SMALL,
    fontWeight: CommonStyles.FONT_WEIGHT_MEDIUM,
    fontColor: CommonStyles.PRIMARY,
    backgroundColor: Color.Transparent,
    borderRadius: 0,
    stateEffect: true
  };

  // 禁用按钮
  static readonly BUTTON_DISABLED: ButtonStyle = {
    width: '100%',
    height: CommonStyles.BUTTON_HEIGHT_MD,
    fontSize: CommonStyles.FONT_SIZE_BODY,
    fontWeight: CommonStyles.FONT_WEIGHT_SEMIBOLD,
    fontColor: CommonStyles.TEXT_DISABLED,
    backgroundColor: CommonStyles.GRAY_200,
    borderRadius: CommonStyles.RADIUS_LG,
    stateEffect: false
  };

  // 小型按钮
  static readonly BUTTON_SMALL: ButtonStyle = {
    width: 'auto',
    height: CommonStyles.BUTTON_HEIGHT_ICON,
    fontSize: CommonStyles.FONT_SIZE_BODY_SMALL,
    fontWeight: CommonStyles.FONT_WEIGHT_MEDIUM,
    fontColor: CommonStyles.PRIMARY,
    backgroundColor: CommonStyles.WHITE,
    borderRadius: CommonStyles.RADIUS_MD,
    border: {
      width: 1,
      color: CommonStyles.BORDER_DEFAULT,
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_MD
    },
    stateEffect: true,
    padding: {
      left: CommonStyles.SM,
      right: CommonStyles.SM,
      top: CommonStyles.XS,
      bottom: CommonStyles.XS
    }
  };

  // 危险按钮
  static readonly BUTTON_DANGER: ButtonStyle = {
    width: '100%',
    height: CommonStyles.BUTTON_HEIGHT_MD,
    fontSize: CommonStyles.FONT_SIZE_BODY,
    fontWeight: CommonStyles.FONT_WEIGHT_SEMIBOLD,
    fontColor: CommonStyles.WHITE,
    backgroundColor: CommonStyles.DANGER,
    borderRadius: CommonStyles.RADIUS_LG,
    stateEffect: true
  };

  // 成功按钮
  static readonly BUTTON_SUCCESS: ButtonStyle = {
    width: '100%',
    height: CommonStyles.BUTTON_HEIGHT_MD,
    fontSize: CommonStyles.FONT_SIZE_BODY,
    fontWeight: CommonStyles.FONT_WEIGHT_SEMIBOLD,
    fontColor: CommonStyles.WHITE,
    backgroundColor: CommonStyles.SUCCESS,
    borderRadius: CommonStyles.RADIUS_LG,
    stateEffect: true
  };

  // 向后兼容 - PRIMARY_BUTTON
  static readonly PRIMARY_BUTTON: ButtonStyle = ComponentStyles.BUTTON_PRIMARY;

  // 向后兼容 - SECONDARY_BUTTON
  static readonly SECONDARY_BUTTON: ButtonStyle = ComponentStyles.BUTTON_SECONDARY;

  // ==================== 输入框样式系统 ====================

  // 标准输入框
  static readonly INPUT_STANDARD: InputStyle = {
    width: '100%',
    height: CommonStyles.INPUT_HEIGHT,
    fontSize: CommonStyles.FONT_SIZE_BODY,
    backgroundColor: CommonStyles.WHITE,
    borderRadius: CommonStyles.RADIUS_LG,
    padding: {
      left: CommonStyles.LG,
      right: CommonStyles.LG,
      top: CommonStyles.MD,
      bottom: CommonStyles.MD
    },
    border: {
      width: 1,
      color: CommonStyles.BORDER_DEFAULT,
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_LG
    }
  };

  // 聚焦状态（不使用展开运算符）
  static readonly INPUT_FOCUSED: InputStyle = {
    width: '100%',
    height: CommonStyles.INPUT_HEIGHT,
    fontSize: CommonStyles.FONT_SIZE_BODY,
    backgroundColor: CommonStyles.WHITE,
    borderRadius: CommonStyles.RADIUS_LG,
    padding: {
      left: CommonStyles.LG,
      right: CommonStyles.LG,
      top: CommonStyles.MD,
      bottom: CommonStyles.MD
    },
    border: {
      width: 2,
      color: CommonStyles.PRIMARY,
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_LG
    },
    shadow: CommonStyles.SHADOW_SM
  };

  // 错误状态（不使用展开运算符）
  static readonly INPUT_ERROR: InputStyle = {
    width: '100%',
    height: CommonStyles.INPUT_HEIGHT,
    fontSize: CommonStyles.FONT_SIZE_BODY,
    backgroundColor: CommonStyles.WHITE,
    borderRadius: CommonStyles.RADIUS_LG,
    padding: {
      left: CommonStyles.LG,
      right: CommonStyles.LG,
      top: CommonStyles.MD,
      bottom: CommonStyles.MD
    },
    border: {
      width: 2,
      color: CommonStyles.DANGER,
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_LG
    }
  };

  // 禁用状态（不使用展开运算符）
  static readonly INPUT_DISABLED: InputStyle = {
    width: '100%',
    height: CommonStyles.INPUT_HEIGHT,
    fontSize: CommonStyles.FONT_SIZE_BODY,
    backgroundColor: CommonStyles.GRAY_100,
    borderRadius: CommonStyles.RADIUS_LG,
    padding: {
      left: CommonStyles.LG,
      right: CommonStyles.LG,
      top: CommonStyles.MD,
      bottom: CommonStyles.MD
    },
    border: {
      width: 1,
      color: CommonStyles.GRAY_200,
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_LG
    }
  };

  // 向后兼容
  static readonly INPUT_STYLE: InputStyle = ComponentStyles.INPUT_STANDARD;
  static readonly INPUT_ERROR_STYLE: InputErrorStyle = {
    border: {
      width: 2,
      color: CommonStyles.DANGER,
      radius: CommonStyles.RADIUS_LG
    }
  };

  // ==================== 卡片样式系统 ====================

  // 标准卡片
  static readonly CARD_STANDARD: CardStyle = {
    width: '100%',
    backgroundColor: CommonStyles.WHITE,
    borderRadius: CommonStyles.RADIUS_XL,
    padding: {
      left: CommonStyles.CARD_INNER_PADDING,
      right: CommonStyles.CARD_INNER_PADDING,
      top: CommonStyles.CARD_INNER_PADDING,
      bottom: CommonStyles.CARD_INNER_PADDING
    },
    border: {
      width: 1,
      color: CommonStyles.BORDER_SUBTLE,
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_XL
    },
    shadow: CommonStyles.SHADOW_SM
  };

  // 品牌卡片（带发光效果）- 不使用展开运算符
  static readonly CARD_BRAND: CardStyle = {
    width: '100%',
    backgroundColor: CommonStyles.WHITE,
    borderRadius: CommonStyles.RADIUS_XL,
    padding: {
      left: CommonStyles.CARD_INNER_PADDING,
      right: CommonStyles.CARD_INNER_PADDING,
      top: CommonStyles.CARD_INNER_PADDING,
      bottom: CommonStyles.CARD_INNER_PADDING
    },
    border: {
      width: 1,
      color: CommonStyles.BORDER_BRAND,
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_XL
    },
    shadow: CommonStyles.SHADOW_BRAND_TEAL
  };

  // AR主题卡片 - 不使用展开运算符
  static readonly CARD_AR: CardStyle = {
    width: '100%',
    backgroundColor: CommonStyles.WHITE,
    borderRadius: CommonStyles.RADIUS_XL,
    padding: {
      left: CommonStyles.CARD_INNER_PADDING,
      right: CommonStyles.CARD_INNER_PADDING,
      top: CommonStyles.CARD_INNER_PADDING,
      bottom: CommonStyles.CARD_INNER_PADDING
    },
    border: {
      width: 1,
      color: CommonStyles.AR_LIGHT,
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_XL
    },
    shadow: CommonStyles.SHADOW_AR_TEAL
  };

  // IoT主题卡片 - 不使用展开运算符
  static readonly CARD_IOT: CardStyle = {
    width: '100%',
    backgroundColor: CommonStyles.WHITE,
    borderRadius: CommonStyles.RADIUS_XL,
    padding: {
      left: CommonStyles.CARD_INNER_PADDING,
      right: CommonStyles.CARD_INNER_PADDING,
      top: CommonStyles.CARD_INNER_PADDING,
      bottom: CommonStyles.CARD_INNER_PADDING
    },
    border: {
      width: 1,
      color: CommonStyles.IOT_LIGHT,
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_XL
    },
    shadow: CommonStyles.SHADOW_IOT_TEAL
  };

  // 可交互卡片（悬停效果）- 不使用展开运算符
  static readonly CARD_INTERACTIVE: CardStyle = {
    width: '100%',
    backgroundColor: CommonStyles.WHITE,
    borderRadius: CommonStyles.RADIUS_XL,
    padding: {
      left: CommonStyles.CARD_INNER_PADDING,
      right: CommonStyles.CARD_INNER_PADDING,
      top: CommonStyles.CARD_INNER_PADDING,
      bottom: CommonStyles.CARD_INNER_PADDING
    },
    border: {
      width: 1,
      color: CommonStyles.BORDER_DEFAULT,
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_XL
    },
    shadow: CommonStyles.SHADOW_MD
  };

  // 紧凑卡片
  static readonly CARD_COMPACT: CardStyle = {
    width: '100%',
    backgroundColor: CommonStyles.WHITE,
    borderRadius: CommonStyles.RADIUS_LG,
    padding: {
      left: CommonStyles.MD,
      right: CommonStyles.MD,
      top: CommonStyles.MD,
      bottom: CommonStyles.MD
    },
    border: {
      width: 1,
      color: CommonStyles.BORDER_SUBTLE,
      style: BorderStyle.Solid,
      radius: CommonStyles.RADIUS_LG
    },
    shadow: CommonStyles.SHADOW_XS
  };

  // 深色模式卡片
  static readonly CARD_DARK: CardStyleDark = {
    backgroundColor: CommonStyles.GRAY_800,
    shadow: CommonStyles.SHADOW_SM
  };

  // 向后兼容
  static readonly CARD_STYLE: CardStyle = ComponentStyles.CARD_STANDARD;
  static readonly CARD_STYLE_MOBILE: CardStyle = ComponentStyles.CARD_STANDARD;
  static readonly CARD_STYLE_COMPACT: CardStyle = ComponentStyles.CARD_COMPACT;
  static readonly CARD_STYLE_INTERACTIVE: CardStyle = ComponentStyles.CARD_INTERACTIVE;

  // ==================== 标签样式系统 ====================

  // 主标签（品牌色）
  static readonly TAG_PRIMARY: TagStyle = {
    fontSize: CommonStyles.FONT_SIZE_CAPTION,
    fontColor: CommonStyles.WHITE,
    backgroundColor: CommonStyles.PRIMARY,
    padding: {
      left: CommonStyles.SM,
      right: CommonStyles.SM,
      top: 2,
      bottom: 2
    },
    borderRadius: CommonStyles.RADIUS_SM
  };

  // AR标签 - 不使用展开运算符
  static readonly TAG_AR: TagStyle = {
    fontSize: CommonStyles.FONT_SIZE_CAPTION,
    fontColor: CommonStyles.WHITE,
    backgroundColor: CommonStyles.AR,
    padding: {
      left: CommonStyles.SM,
      right: CommonStyles.SM,
      top: 2,
      bottom: 2
    },
    borderRadius: CommonStyles.RADIUS_SM
  };

  // IoT标签 - 不使用展开运算符
  static readonly TAG_IOT: TagStyle = {
    fontSize: CommonStyles.FONT_SIZE_CAPTION,
    fontColor: CommonStyles.WHITE,
    backgroundColor: CommonStyles.IOT,
    padding: {
      left: CommonStyles.SM,
      right: CommonStyles.SM,
      top: 2,
      bottom: 2
    },
    borderRadius: CommonStyles.RADIUS_SM
  };

  // 成功标签 - 不使用展开运算符
  static readonly TAG_SUCCESS: TagStyle = {
    fontSize: CommonStyles.FONT_SIZE_CAPTION,
    fontColor: CommonStyles.WHITE,
    backgroundColor: CommonStyles.SUCCESS,
    padding: {
      left: CommonStyles.SM,
      right: CommonStyles.SM,
      top: 2,
      bottom: 2
    },
    borderRadius: CommonStyles.RADIUS_SM
  };

  // 警告标签 - 不使用展开运算符
  static readonly TAG_WARNING: TagStyle = {
    fontSize: CommonStyles.FONT_SIZE_CAPTION,
    fontColor: CommonStyles.WHITE,
    backgroundColor: CommonStyles.WARNING,
    padding: {
      left: CommonStyles.SM,
      right: CommonStyles.SM,
      top: 2,
      bottom: 2
    },
    borderRadius: CommonStyles.RADIUS_SM
  };

  // 危险标签 - 不使用展开运算符
  static readonly TAG_DANGER: TagStyle = {
    fontSize: CommonStyles.FONT_SIZE_CAPTION,
    fontColor: CommonStyles.WHITE,
    backgroundColor: CommonStyles.DANGER,
    padding: {
      left: CommonStyles.SM,
      right: CommonStyles.SM,
      top: 2,
      bottom: 2
    },
    borderRadius: CommonStyles.RADIUS_SM
  };

  // 信息标签 - 不使用展开运算符
  static readonly TAG_INFO: TagStyle = {
    fontSize: CommonStyles.FONT_SIZE_CAPTION,
    fontColor: CommonStyles.WHITE,
    backgroundColor: CommonStyles.INFO,
    padding: {
      left: CommonStyles.SM,
      right: CommonStyles.SM,
      top: 2,
      bottom: 2
    },
    borderRadius: CommonStyles.RADIUS_SM
  };

  // 浅色标签（用于次级信息）
  static readonly TAG_LIGHT: TagStyle = {
    fontSize: CommonStyles.FONT_SIZE_CAPTION,
    fontColor: CommonStyles.PRIMARY,
    backgroundColor: CommonStyles.PRIMARY_BG,
    padding: {
      left: CommonStyles.SM,
      right: CommonStyles.SM,
      top: 2,
      bottom: 2
    },
    borderRadius: CommonStyles.RADIUS_SM
  };

  // ==================== 列表项样式 ====================

  static readonly LIST_ITEM: ListItemStyle = {
    width: '100%',
    height: 0,
    backgroundColor: CommonStyles.WHITE,
    borderRadius: CommonStyles.RADIUS_MD,
    padding: {
      left: CommonStyles.MD,
      right: CommonStyles.MD,
      top: CommonStyles.MD,
      bottom: CommonStyles.MD
    },
    margin: { bottom: CommonStyles.SM }
  };

  static readonly LIST_ITEM_DARK: ListItemDarkStyle = {
    backgroundColor: CommonStyles.GRAY_800
  };

  // ==================== 标题样式系统 ====================

  static readonly TITLE_DISPLAY: TitleStyle = {
    fontSize: CommonStyles.FONT_SIZE_DISPLAY,
    fontWeight: CommonStyles.FONT_WEIGHT_BOLD,
    fontColor: CommonStyles.TEXT_PRIMARY
  };

  static readonly TITLE_H1: TitleStyle = {
    fontSize: CommonStyles.FONT_SIZE_H1,
    fontWeight: CommonStyles.FONT_WEIGHT_BOLD,
    fontColor: CommonStyles.TEXT_PRIMARY
  };

  static readonly TITLE_H2: TitleStyle = {
    fontSize: CommonStyles.FONT_SIZE_H2,
    fontWeight: CommonStyles.FONT_WEIGHT_SEMIBOLD,
    fontColor: CommonStyles.TEXT_PRIMARY
  };

  static readonly TITLE_H3: TitleStyle = {
    fontSize: CommonStyles.FONT_SIZE_H3,
    fontWeight: CommonStyles.FONT_WEIGHT_SEMIBOLD,
    fontColor: CommonStyles.TEXT_PRIMARY
  };

  // 向后兼容
  static readonly TITLE_LARGE: TitleStyle = ComponentStyles.TITLE_H1;
  static readonly TITLE_MEDIUM: TitleStyle = ComponentStyles.TITLE_H2;
  static readonly TITLE_SMALL: TitleStyle = ComponentStyles.TITLE_H3;

  // ==================== 文本样式系统 ====================

  static readonly TEXT_BODY_LARGE: TextSimpleStyle = {
    fontSize: CommonStyles.FONT_SIZE_BODY_LARGE,
    fontColor: CommonStyles.TEXT_PRIMARY
  };

  static readonly TEXT_BODY: TextSimpleStyle = {
    fontSize: CommonStyles.FONT_SIZE_BODY,
    fontColor: CommonStyles.TEXT_PRIMARY
  };

  static readonly TEXT_BODY_SMALL: TextSimpleStyle = {
    fontSize: CommonStyles.FONT_SIZE_BODY_SMALL,
    fontColor: CommonStyles.TEXT_SECONDARY
  };

  static readonly TEXT_SECONDARY: TextSimpleStyle = {
    fontSize: CommonStyles.FONT_SIZE_BODY_SMALL,
    fontColor: CommonStyles.TEXT_SECONDARY
  };

  static readonly TEXT_TERTIARY: TextSimpleStyle = {
    fontSize: CommonStyles.FONT_SIZE_CAPTION,
    fontColor: CommonStyles.TEXT_TERTIARY
  };

  // 向后兼容
  static readonly TEXT_PRIMARY_SIMPLE: TextSimpleStyle = ComponentStyles.TEXT_BODY;

  // ==================== 图标样式 ====================

  static readonly ICON_XXS: IconStyle = {
    width: CommonStyles.ICON_SIZE_XXS,
    height: CommonStyles.ICON_SIZE_XXS,
    color: CommonStyles.TEXT_PRIMARY
  };

  static readonly ICON_XS: IconStyle = {
    width: CommonStyles.ICON_SIZE_XS,
    height: CommonStyles.ICON_SIZE_XS,
    color: CommonStyles.TEXT_PRIMARY
  };

  static readonly ICON_SM: IconStyle = {
    width: CommonStyles.ICON_SIZE_SM,
    height: CommonStyles.ICON_SIZE_SM,
    color: CommonStyles.TEXT_PRIMARY
  };

  static readonly ICON_MD: IconStyle = {
    width: CommonStyles.ICON_SIZE_MD,
    height: CommonStyles.ICON_SIZE_MD,
    color: CommonStyles.TEXT_PRIMARY
  };

  static readonly ICON_LG: IconStyle = {
    width: CommonStyles.ICON_SIZE_LG,
    height: CommonStyles.ICON_SIZE_LG,
    color: CommonStyles.TEXT_PRIMARY
  };

  static readonly ICON_XL: IconStyle = {
    width: CommonStyles.ICON_SIZE_XL,
    height: CommonStyles.ICON_SIZE_XL,
    color: CommonStyles.TEXT_PRIMARY
  };

  // 向后兼容
  static readonly ICON_SMALL: IconStyle = ComponentStyles.ICON_SM;
  static readonly ICON_MEDIUM: IconStyle = ComponentStyles.ICON_MD;
  static readonly ICON_LARGE: IconStyle = ComponentStyles.ICON_LG;

  // ==================== 分割线样式 ====================

  static readonly DIVIDER: DividerStyle = {
    width: '100%',
    height: 1,
    color: CommonStyles.BORDER_DEFAULT,
    strokeWidth: 1
  };

  static readonly DIVIDER_THICK: DividerStyle = {
    width: '100%',
    height: 8,
    color: CommonStyles.BG_SURFACE,
    strokeWidth: 8
  };

  // ==================== 状态容器样式 ====================

  // 加载状态
  static readonly LOADING_CONTAINER: LoadingContainerStyle = {
    width: '100%',
    height: 300,
    justifyContent: 'center',
    alignItems: 'center'
  };

  // 空状态
  static readonly EMPTY_STATE: EmptyStateStyle = {
    width: '100%',
    height: 350,
    justifyContent: 'center',
    alignItems: 'center'
  };

  // 错误状态
  static readonly ERROR_CONTAINER: ErrorContainerStyle = {
    width: '100%',
    padding: CommonStyles.XL as number,
    backgroundColor: CommonStyles.DANGER_BG,
    borderRadius: CommonStyles.RADIUS_MD,
    justifyContent: 'center',
    alignItems: 'center'
  };

  // 提示状态
  static readonly TIP_CONTAINER: LoadingContainerStyle = {
    width: '100%',
    height: 60,
    justifyContent: FlexAlign.Start,
    alignItems: FlexAlign.Start,
    padding: { left: CommonStyles.LG, right: CommonStyles.LG, top: CommonStyles.MD, bottom: CommonStyles.MD }
  };

  // ==================== 间距容器 ====================

  static readonly CONTAINER_PADDING: ContainerPaddingStyle = {
    padding: {
      left: CommonStyles.PAGE_PADDING_H,
      right: CommonStyles.PAGE_PADDING_H,
      top: CommonStyles.PAGE_PADDING_V_TOP,
      bottom: CommonStyles.PAGE_PADDING_V_BOTTOM
    }
  };

  static readonly SECTION_MARGIN: SectionMarginStyle = {
    margin: {
      top: CommonStyles.SECTION_GAP,
      bottom: CommonStyles.SECTION_GAP
    }
  };

  // ==================== 工具方法 ====================

  /**
   * 根据模块获取卡片样式
   */
  static getCardStyle(module?: 'ar' | 'ai' | 'iot' | 'default', isDarkMode: boolean = false): CardStyle {
    if (isDarkMode) {
      return {
        width: ComponentStyles.CARD_STANDARD.width,
        backgroundColor: ComponentStyles.CARD_DARK.backgroundColor,
        borderRadius: ComponentStyles.CARD_STANDARD.borderRadius,
        padding: ComponentStyles.CARD_STANDARD.padding,
        shadow: ComponentStyles.CARD_DARK.shadow
      };
    }

    switch (module) {
      case 'ar':
        return ComponentStyles.CARD_AR;
      case 'ai':
        return ComponentStyles.CARD_BRAND;
      case 'iot':
        return ComponentStyles.CARD_IOT;
      default:
        return ComponentStyles.CARD_STANDARD;
    }
  }

  /**
   * 根据模块获取按钮样式
   */
  static getButtonStyle(module?: 'ar' | 'ai' | 'iot' | 'default'): ButtonStyle {
    switch (module) {
      case 'ar':
        return ComponentStyles.BUTTON_AR;
      case 'ai':
        return ComponentStyles.BUTTON_PRIMARY;
      case 'iot':
        return ComponentStyles.BUTTON_IOT;
      default:
        return ComponentStyles.BUTTON_PRIMARY;
    }
  }

  /**
   * 获取列表项样式
   */
  static getListItemStyle(isDarkMode: boolean = false): ListItemStyle {
    const baseStyle = ComponentStyles.LIST_ITEM;
    if (isDarkMode) {
      const darkStyle = ComponentStyles.LIST_ITEM_DARK;
      return {
        width: baseStyle.width,
        height: baseStyle.height,
        backgroundColor: darkStyle.backgroundColor,
        borderRadius: baseStyle.borderRadius,
        padding: baseStyle.padding,
        margin: baseStyle.margin
      } as ListItemStyle;
    }
    return baseStyle;
  }

  /**
   * 获取文本颜色
   */
  static getTextColor(isDarkMode: boolean = false, type: 'primary' | 'secondary' | 'tertiary' | 'light' = 'primary'): string {
    if (isDarkMode) {
      switch (type) {
        case 'primary': return CommonStyles.TEXT_INVERSE;
        case 'secondary': return CommonStyles.TEXT_TERTIARY;
        case 'tertiary': return CommonStyles.TEXT_DISABLED;
        case 'light': return CommonStyles.TEXT_INVERSE;
        default: return CommonStyles.TEXT_INVERSE;
      }
    } else {
      switch (type) {
        case 'primary': return CommonStyles.TEXT_PRIMARY;
        case 'secondary': return CommonStyles.TEXT_SECONDARY;
        case 'tertiary': return CommonStyles.TEXT_TERTIARY;
        case 'light': return CommonStyles.TEXT_DISABLED;
        default: return CommonStyles.TEXT_PRIMARY;
      }
    }
  }

  /**
   * 获取背景颜色
   */
  static getBackgroundColor(isDarkMode: boolean = false): string {
    return isDarkMode ? CommonStyles.BLACK : CommonStyles.BG_SURFACE;
  }

  /**
   * 获取主题色
   */
  static getThemeColor(module: 'ar' | 'ai' | 'iot' | 'default' = 'default'): string {
    return CommonStyles.getThemeColor(module);
  }
}
