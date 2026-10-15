/**
 * 动画工具类 - 简化版本
 * 提供统一的页面切换动画和交互效果
 */

// 页面切换动画类型
export type PageTransitionType =
  | 'slideRight'    // 从右滑入
  | 'slideLeft'     // 从左滑入
  | 'slideUp'       // 从下往上滑入
  | 'slideDown'     // 从上往下滑入
  | 'fade'          // 淡入淡出
  | 'scale'         // 缩放
  | 'flip'          // 翻转
  | 'rotate'        // 旋转
  | 'bounce'        // 弹跳
  | 'zoom'          // 放大进入
  | 'none';         // 无动画

// 动画配置接口
export interface AnimationConfig {
  duration: number;
  curve: string;
  translateX?: number;
  translateY?: number;
  scaleX?: number;
  scaleY?: number;
  rotate?: number;
  opacity?: number;
}

// 复杂动画配置接口
export interface ComplexAnimationConfig extends AnimationConfig {
  onFrame?: (value: number) => { transform?: { scale?: number; translateX?: number; translateY?: number; rotate?: number }; opacity?: number };
  iterations?: number;
  delay?: number;
}

export class AnimationUtils {
  // 动画配置映射
  private static readonly ANIMATION_CONFIGS: Record<string, AnimationConfig> = {
    slideRight: { duration: 300, curve: 'Curves.EaseOut' },
    slideLeft: { duration: 300, curve: 'Curves.EaseOut' },
    slideUp: { duration: 350, curve: 'Curves.EaseOut' },
    slideDown: { duration: 350, curve: 'Curves.EaseOut' },
    fade: { duration: 250, curve: 'Curves.Linear' },
    scale: { duration: 400, curve: 'Curves.EaseInOut' },
    flip: { duration: 500, curve: 'Curves.EaseInOut' },
    rotate: { duration: 600, curve: 'Curves.EaseInOut' },
    bounce: { duration: 800, curve: 'Curves.BounceOut' },
    zoom: { duration: 450, curve: 'Curves.EaseOut' },
    none: { duration: 0, curve: 'Curves.Linear' }
  } as Record<string, AnimationConfig>;

  // 默认动画配置
  private static readonly DEFAULT_CONFIG: AnimationConfig = {
    duration: 300,
    curve: 'Curves.EaseInOut'
  };

  /**
   * 获取页面切换动画配置
   */
  static getPageTransition(type: PageTransitionType = 'slideRight'): AnimationConfig {
    const config = AnimationUtils.ANIMATION_CONFIGS[type] || AnimationUtils.DEFAULT_CONFIG;

    switch (type) {
      case 'slideRight':
        return {
          duration: config.duration,
          curve: config.curve,
          onEnter: (value: number) => ({
            transform: { translateX: `${(1 - value) * 100}%` }
          }),
          onExit: (value: number) => ({
            transform: { translateX: `${-value * 100}%` }
          })
        };

      case 'slideLeft':
        return {
          duration: config.duration,
          curve: config.curve,
          onEnter: (value: number) => ({
            transform: { translateX: `${-(1 - value) * 100}%` }
          }),
          onExit: (value: number) => ({
            transform: { translateX: `${value * 100}%` }
          })
        };

      case 'slideUp':
        return {
          duration: config.duration,
          curve: config.curve,
          onEnter: (value: number) => ({
            transform: { translateY: `${(1 - value) * 100}%` }
          }),
          onExit: (value: number) => ({
            transform: { translateY: `${-value * 100}%` }
          })
        };

      case 'slideDown':
        return {
          duration: config.duration,
          curve: config.curve,
          onEnter: (value: number) => ({
            transform: { translateY: `${-(1 - value) * 100}%` }
          }),
          onExit: (value: number) => ({
            transform: { translateY: `${value * 100}%` }
          })
        };

      case 'fade':
        return {
          duration: config.duration,
          curve: config.curve,
          onEnter: (value: number) => ({
            opacity: value
          }),
          onExit: (value: number) => ({
            opacity: 1 - value
          })
        };

      case 'scale':
        return {
          duration: config.duration,
          curve: config.curve,
          onEnter: (value: number) => ({
            transform: { scale: value }
          }),
          onExit: (value: number) => ({
            transform: { scale: 1 - value }
          })
        };

      case 'flip':
        return {
          duration: config.duration,
          curve: config.curve,
          onEnter: (value: number) => ({
            transform: { rotateY: `${(1 - value) * 180}deg` }
          }),
          onExit: (value: number) => ({
            transform: { rotateY: `${value * 180}deg` }
          })
        };

      case 'rotate':
        return {
          duration: config.duration,
          curve: config.curve,
          onEnter: (value: number) => ({
            transform: { rotate: `${(1 - value) * 360}deg` }
          }),
          onExit: (value: number) => ({
            transform: { rotate: `${value * 360}deg` }
          })
        };

      case 'bounce':
        return {
          duration: config.duration,
          curve: config.curve,
          onEnter: (value: number) => ({
            transform: {
              translateY: `${Math.sin(value * Math.PI * 2) * 50 * (1 - value)}%`,
              scale: 0.5 + value * 0.5
            }
          }),
          onExit: (value: number) => ({
            transform: {
              translateY: `${Math.sin((1 - value) * Math.PI * 2) * 50 * value}%`,
              scale: 1 - value * 0.5
            }
          })
        };

      case 'zoom':
        return {
          duration: config.duration,
          curve: config.curve,
          onEnter: (value: number) => ({
            transform: { scale: 0.5 + value * 0.5 },
            opacity: value
          }),
          onExit: (value: number) => ({
            transform: { scale: 1.5 - value * 0.5 },
            opacity: 1 - value
          })
        };

      default:
        return {
          duration: 0,
          curve: 'Curves.Linear'
        };
    }
  }

  /**
   * 创建按钮点击动画
   */
  static createButtonAnimation(): ComplexAnimationConfig {
    return {
      duration: 150,
      curve: 'Curves.EaseOut',
      onFrame: (value: number) => ({
        transform: { scale: 1 - value * 0.1 }
      })
    };
  }

  /**
   * 创建卡片悬停动画
   */
  static createCardHoverAnimation(): ComplexAnimationConfig {
    return {
      duration: 200,
      curve: 'Curves.EaseOut',
      onFrame: (value: number) => ({
        transform: {
          translateY: -value * 4,
          scale: 1 + value * 0.02
        },
        shadow: {
          radius: 10 + value * 10,
          color: '#00000020',
          offsetX: 0,
          offsetY: 2 + value * 4
        }
      })
    };
  }

  /**
   * 创建加载动画
   */
  static createLoadingAnimation(): ComplexAnimationConfig {
    return {
      duration: 1000,
      curve: 'Curves.Linear',
      iterations: -1, // 无限循环
      onFrame: (value: number) => ({
        transform: { rotate: `${value * 360}deg` }
      })
    };
  }

  /**
   * 创建列表项入场动画
   * @param index 列表项索引
   * @param total 总项数
   */
  static createListItemAnimation(index: number, total: number): ComplexAnimationConfig {
    const delay = Math.min(index * 50, 300); // 最大延迟300ms
    return {
      duration: 400,
      curve: 'Curves.EaseOut',
      delay: delay,
      onEnter: (value: number) => ({
        opacity: value,
        transform: { translateY: (1 - value) * 20 }
      })
    };
  }

  /**
   * 创建震动动画（用于错误提示）
   */
  static createShakeAnimation(): ComplexAnimationConfig {
    return {
      duration: 500,
      curve: 'Curves.EaseInOut',
      onFrame: (value: number) => ({
        transform: { translateX: Math.sin(value * Math.PI * 10) * 10 }
      })
    };
  }

  /**
   * 创建心跳动画（用于重要提示）
   */
  static createHeartbeatAnimation(): ComplexAnimationConfig {
    return {
      duration: 800,
      curve: 'Curves.EaseInOut',
      iterations: 3, // 重复3次
      onFrame: (value: number) => ({
        transform: { scale: 1 + Math.sin(value * Math.PI * 2) * 0.1 }
      })
    };
  }

  /**
   * 创建进度条动画
   */
  static createProgressAnimation(): ComplexAnimationConfig {
    return {
      duration: 1000,
      curve: 'Curves.EaseInOut',
      onFrame: (value: number) => ({
        width: `${value * 100}%`
      })
    };
  }

  /**
   * 创建淡入动画
   */
  static createFadeInAnimation(duration: number = 300, delay: number = 0): ComplexAnimationConfig {
    return {
      duration: duration,
      curve: 'Curves.EaseOut',
      delay: delay,
      onEnter: (value: number) => ({
        opacity: value
      })
    };
  }

  /**
   * 创建淡出动画
   */
  static createFadeOutAnimation(duration: number = 300, delay: number = 0): ComplexAnimationConfig {
    return {
      duration: duration,
      curve: 'Curves.EaseIn',
      delay: delay,
      onExit: (value: number) => ({
        opacity: 1 - value
      })
    };
  }

  /**
   * 创建缩放动画
   */
  static createScaleAnimation(
    from: number = 0,
    to: number = 1,
    duration: number = 300
  ): ComplexAnimationConfig {
    return {
      duration: duration,
      curve: 'Curves.EaseOut',
      onEnter: (value: number) => ({
        transform: { scale: from + (to - from) * value }
      })
    };
  }
}