// AppIcon - 统一图标组件 (使用 Emoji 临时方案)
// 设计原则：统一管理所有图标，后续可无缝替换为 SVG/IconFont

import { CommonStyles } from '../common/css/CommonStyles';

@Component
export struct AppIcon {
  @Prop name: string = 'star';
  @Prop iconSize: number = CommonStyles.ICON_SIZE_MD;
  @Prop color: string = CommonStyles.TEXT_PRIMARY;

  build() {
    Text(this.getIconEmoji())
      .fontSize(this.iconSize)
      .fontColor(this.color)
      .textAlign(TextAlign.Center)
  }

  private getIconEmoji(): string {
    const iconMap: Record<string, string> = {
      // 导航类
      'back': '←',
      'close': '✕',
      'menu': '☰',

      // Tab栏
      'home': '🏠',
      'home-active': '🏠',
      'pet': '🐾',
      'pet-active': '🐾',
      'community': '📝',
      'community-active': '📝',
      'message': '💬',
      'message-active': '💬',
      'profile': '👤',
      'profile-active': '👤',

      // 操作类
      'search': '🔍',
      'filter': '⚙️',
      'add': '+',
      'more': '⋯',
      'share': '↗',
      'edit': '✏️',
      'delete': '🗑️',
      'copy': '📋',

      // 状态类
      'success': '✅',
      'error': '❌',
      'warning': '⚠️',
      'info': 'ℹ️',

      // 交互类
      'heart': '♡',
      'heart-filled': '♥',
      'star': '☆',
      'star-filled': '★',
      'like': '👍',
      'comment': '💬',
      'collect': '⭐',
      'eye': '👁️',

      // 用户类
      'user': '👤',
      'users': '👥',
      'avatar': '😊',
      'crown': '👑',
      'medal': '🏅',

      // 宠物类
      'cat': '🐱',
      'dog': '🐕',
      'bird': '🐦',
      'fish': '🐟',
      'rabbit': '🐰',
      'paw': '🐾',
      'bone': '🦴',
      'food': '🍖',

      // 位置类
      'location': '📍',
      'map': '🗺️',
      'pin': '📌',

      // 时间类
      'clock': '🕐',
      'calendar': '📅',

      // 文件类
      'image': '🖼️',
      'camera': '📷',
      'file': '📄',
      'document': '📋',

      // 通信类
      'phone': '📞',
      'mail': '✉️',
      'bell': '🔔',
      'notification': '🔔',

      // 设置类
      'settings': '⚙️',
      'gear': '⚙️',
      'lock': '🔒',
      'key': '🔑',

      // 安全类
      'shield': '🛡️',
      'check-circle': '✅',
      'alert-circle': '⚠️',

      // 媒体类
      'play': '▶',
      'pause': '⏸',
      'stop': '⏹',
      'refresh': '🔄',
      'download': '⬇',
      'upload': '⬆',

      // 方向类
      'arrow-left': '←',
      'arrow-right': '→',
      'arrow-up': '↑',
      'arrow-down': '↓',
      'chevron-left': '‹',
      'chevron-right': '›',
      'chevron-up': '△',
      'chevron-down': '▽',

      // 社交类
      'wechat': '💬',
      'weibo': '📢',
      'qq': '🐧',
      'link': '🔗',

      // 情感类
      'happy': '😊',
      'sad': '😢',
      'love': '❤️',
      'fire': '🔥',
      'sparkle': '✨',
      'thumbs-up': '👍',
      'celebration': '🎉',

      // 其他
      'logo': '🐾',
      'brand': '🌿',
      'safety': '🛡️',
      'health': '💊',
      'vaccine': '💉',
      'certificate': '📜',
      'contract': '📝',
      'adoption': '🏠',
    };

    return iconMap[this.name] || '●';
  }
}