// 主题助手 - 简化深色模式支持
import { ThemeUtils } from './ThemeUtils';
import { TextStyle, CardStyle, ListItemStyle, ButtonStyle, InputStyle, TagStyle, ContainerStyle, DividerStyle, ShadowOptions, IconStyle, BorderStyle } from './StyleTypes';
import { CommonStyles } from './CommonStyles';

// 主题样式构建器
export class ThemeHelper {
  // 获取主题相关的文本样式
  static textStyle(size: 'xs' | 'sm' | 'md' | 'lg' | 'xl' | '2xl' | '3xl' | '4xl' = 'md',
                   weight: 'normal' | 'medium' | 'semibold' | 'bold' = 'normal',
                   type: 'primary' | 'secondary' | 'tertiary' | 'light' = 'primary'): TextStyle {
    return {
      fontSize: ThemeUtils.getFontSize(size),
      fontWeight: ThemeUtils.getFontWeight(weight),
      fontColor: ThemeUtils.getTextColor(type)
    };
  }

  // 获取卡片样式
  static cardStyle(): CardStyle {
    const cardStyle = ThemeUtils.getCardStyle();
    return {
      width: cardStyle.width,
      backgroundColor: cardStyle.backgroundColor,
      borderRadius: ThemeUtils.getBorderRadius('lg'),
      padding: {
        left: ThemeUtils.getSpacing('lg'),
        right: ThemeUtils.getSpacing('lg'),
        top: ThemeUtils.getSpacing('lg'),
        bottom: ThemeUtils.getSpacing('lg')
      },
      shadow: ThemeUtils.getShadow('md')
    };
  }

  // 获取列表项样式
  static listItemStyle(): ListItemStyle {
    const listItemStyle = ThemeUtils.getListItemStyle();
    return {
      width: listItemStyle.width,
      height: listItemStyle.height,
      backgroundColor: listItemStyle.backgroundColor,
      borderRadius: ThemeUtils.getBorderRadius('md'),
      padding: {
        left: ThemeUtils.getSpacing('md'),
        right: ThemeUtils.getSpacing('md'),
        top: ThemeUtils.getSpacing('md'),
        bottom: ThemeUtils.getSpacing('md')
      },
      margin: { bottom: ThemeUtils.getSpacing('sm') }
    };
  }

  // 获取按钮样式
  static buttonStyle(type: 'primary' | 'secondary' | 'text' = 'primary', disabled: boolean = false): ButtonStyle {
    const baseStyle: ButtonStyle = {
      width: '100%',
      height: 56,
      borderRadius: ThemeUtils.getBorderRadius('lg'),
      stateEffect: true,
      fontSize: 0, // 将在下面设置
      fontWeight: 0, // 将在下面设置
      fontColor: '', // 将在下面设置
      backgroundColor: '' // 将在下面设置
    };

    switch (type) {
      case 'primary':
        return {
          width: baseStyle.width,
          height: baseStyle.height,
          borderRadius: baseStyle.borderRadius,
          stateEffect: baseStyle.stateEffect,
          fontSize: ThemeUtils.getFontSize('lg'),
          fontWeight: ThemeUtils.getFontWeight('bold'),
          fontColor: ThemeUtils.getWhiteColor(),
          backgroundColor: disabled ? ThemeUtils.getGrayColor(300) : ThemeUtils.getPrimaryColor(),
          padding: {
            left: ThemeUtils.getSpacing('lg'),
            right: ThemeUtils.getSpacing('lg'),
            top: ThemeUtils.getSpacing('md'),
            bottom: ThemeUtils.getSpacing('md')
          }
        } as ButtonStyle;
      case 'secondary':
        return {
          width: baseStyle.width,
          height: baseStyle.height,
          borderRadius: baseStyle.borderRadius,
          stateEffect: baseStyle.stateEffect,
          fontSize: ThemeUtils.getFontSize('lg'),
          fontWeight: ThemeUtils.getFontWeight('medium'),
          fontColor: ThemeUtils.getPrimaryColor(),
          backgroundColor: ThemeUtils.getWhiteColor(),
          padding: {
            left: ThemeUtils.getSpacing('lg'),
            right: ThemeUtils.getSpacing('lg'),
            top: ThemeUtils.getSpacing('md'),
            bottom: ThemeUtils.getSpacing('md')
          },
          border: {
            width: 1,
            color: ThemeUtils.getPrimaryColor()
          }
        } as ButtonStyle;
      case 'text':
        return {
          width: 'auto',
          height: 40,
          fontSize: ThemeUtils.getFontSize('md'),
          fontWeight: ThemeUtils.getFontWeight('medium'),
          fontColor: disabled ? ThemeUtils.getGrayColor(400) : ThemeUtils.getPrimaryColor(),
          backgroundColor: Color.Transparent,
          borderRadius: 0,
          stateEffect: true,
          padding: {
            left: ThemeUtils.getSpacing('md'),
            right: ThemeUtils.getSpacing('md'),
            top: ThemeUtils.getSpacing('sm'),
            bottom: ThemeUtils.getSpacing('sm')
          }
        } as ButtonStyle;
      default:
        return {
          width: baseStyle.width,
          height: baseStyle.height,
          borderRadius: baseStyle.borderRadius,
          stateEffect: baseStyle.stateEffect,
          fontSize: ThemeUtils.getFontSize('lg'),
          fontWeight: ThemeUtils.getFontWeight('bold'),
          fontColor: ThemeUtils.getWhiteColor(),
          backgroundColor: disabled ? ThemeUtils.getGrayColor(300) : ThemeUtils.getPrimaryColor(),
          padding: {
            left: ThemeUtils.getSpacing('lg'),
            right: ThemeUtils.getSpacing('lg'),
            top: ThemeUtils.getSpacing('md'),
            bottom: ThemeUtils.getSpacing('md')
          }
        } as ButtonStyle;
    }
  }

  // 获取输入框样式
  static inputStyle(hasError: boolean = false): InputStyle {
    return {
      width: '100%',
      height: 52,
      fontSize: ThemeUtils.getFontSize('md'),
      backgroundColor: ThemeUtils.getWhiteColor(),
      borderRadius: ThemeUtils.getBorderRadius('lg'),
      padding: {
        left: ThemeUtils.getSpacing('lg'),
        right: ThemeUtils.getSpacing('lg'),
        top: ThemeUtils.getSpacing('md'),
        bottom: ThemeUtils.getSpacing('md')
      },
      border: {
        width: hasError ? 2 : 1,
        color: hasError ? ThemeUtils.getDangerColor() : ThemeUtils.getGrayColor(300),
        radius: ThemeUtils.getBorderRadius('lg'),
        style: BorderStyle.Solid
      }
    };
  }

  // 获取标签样式
  static tagStyle(type: 'primary' | 'success' | 'warning' | 'danger' | 'info' = 'primary'): TagStyle {
    const baseStyle = {
      fontSize: ThemeUtils.getFontSize('xs'),
      fontColor: ThemeUtils.getWhiteColor(),
      backgroundColor: ThemeUtils.getPrimaryColor(),
      padding: {
        left: ThemeUtils.getSpacing('sm'),
        right: ThemeUtils.getSpacing('sm'),
        top: 2,
        bottom: 2
      },
      borderRadius: ThemeUtils.getBorderRadius('sm'),
      fontWeight: 400
    } as TagStyle;

    switch (type) {
      case 'primary':
        return {
          fontSize: baseStyle.fontSize,
          fontColor: baseStyle.fontColor,
          padding: baseStyle.padding,
          borderRadius: baseStyle.borderRadius,
          backgroundColor: ThemeUtils.getPrimaryColor(),
          fontWeight: baseStyle.fontWeight
        } as TagStyle;
      case 'success':
        return {
          fontSize: baseStyle.fontSize,
          fontColor: baseStyle.fontColor,
          padding: baseStyle.padding,
          borderRadius: baseStyle.borderRadius,
          backgroundColor: ThemeUtils.getSuccessColor(),
          fontWeight: baseStyle.fontWeight
        } as TagStyle;
      case 'warning':
        return {
          fontSize: baseStyle.fontSize,
          fontColor: baseStyle.fontColor,
          padding: baseStyle.padding,
          borderRadius: baseStyle.borderRadius,
          backgroundColor: ThemeUtils.getWarningColor(),
          fontWeight: baseStyle.fontWeight
        } as TagStyle;
      case 'danger':
        return {
          fontSize: baseStyle.fontSize,
          fontColor: baseStyle.fontColor,
          padding: baseStyle.padding,
          borderRadius: baseStyle.borderRadius,
          backgroundColor: ThemeUtils.getDangerColor(),
          fontWeight: baseStyle.fontWeight
        } as TagStyle;
      case 'info':
        return {
          fontSize: baseStyle.fontSize,
          fontColor: baseStyle.fontColor,
          padding: baseStyle.padding,
          borderRadius: baseStyle.borderRadius,
          backgroundColor: ThemeUtils.getInfoColor(),
          fontWeight: baseStyle.fontWeight
        } as TagStyle;
      default:
        return baseStyle;
    }
  }

  // 获取容器样式
  static containerStyle(): ContainerStyle {
    return {
      backgroundColor: ThemeUtils.getBackgroundColor(),
      padding: ThemeUtils.getSpacing('md')
    } as ContainerStyle;
  }

  // 获取分割线样式
  static dividerStyle(): DividerStyle {
    return {
      width: '100%',
      height: 1,
      color: ThemeUtils.getGrayColor(200),
      strokeWidth: 1
    } as DividerStyle;
  }

  // 获取间距
  static space(size: 'xs' | 'sm' | 'md' | 'lg' | 'xl' | '2xl' | '3xl' | '4xl'): number {
    return ThemeUtils.getSpacing(size);
  }

  // 获取圆角
  static radius(size: 'sm' | 'md' | 'lg' | 'xl' | '2xl' | 'full'): number {
    return ThemeUtils.getBorderRadius(size);
  }

  // 获取阴影
  static shadow(size: 'sm' | 'md' | 'lg' | 'xl'): ShadowOptions {
    return ThemeUtils.getShadow(size);
  }

  // 获取图标样式
  static iconStyle(size: 'small' | 'medium' | 'large' = 'medium'): IconStyle {
    switch (size) {
      case 'small':
        return { width: 20, height: 20, color: CommonStyles.TEXT_PRIMARY };
      case 'medium':
        return { width: 24, height: 24, color: CommonStyles.TEXT_PRIMARY };
      case 'large':
        return { width: 32, height: 32, color: CommonStyles.TEXT_PRIMARY };
      default:
        return { width: 24, height: 24, color: CommonStyles.TEXT_PRIMARY };
    }
  }
}