/**
 * 资源管理器 - 统一管理应用中的所有资源引用
 */

// 图片资源接口
interface ImageResources {
  BACK: string;
  ADD: string;
  CLOSE: string;
  SEARCH: string;
  REFRESH: string;
  ARROW_RIGHT: string;
  ERROR: string;
  SUCCESS: string;
  NO_DATA: string;
  EMPTY: string;
  USER_DEFAULT: string;
  AVATAR_PLACEHOLDER: string;
  PET_DEFAULT: string;
  PET_PLACEHOLDER: string;
  LOGO: string;
  MATCH_ICON: string;
  CALENDAR_ICON: string;
  POST_ICON: string;
  NOTICE_ICON: string;
  LEVEL: string;
  APPLY: string;
  FAVORITE: string;
  HISTORY: string;
  ADDRESS: string;
  POST: string;
  COMMENT: string;
  NIGHT: string;
  NOTIFICATION: string;
  PRIVACY: string;
  ABOUT: string;
  HELP: string;
  FEEDBACK: string;
  LIKE_OUTLINE: string;
  LIKE_FILLED: string;
  FAVORITE_OUTLINE: string;
  FAVORITE_FILLED: string;
  EYE: string;
  UNREAD: string;
  NO_ADDRESS: string;
  NO_COMMENT: string;
  IMAGE: string;
  NO_NOTICE: string;
  WECHAT: string;
  QQ: string;
  WEIBO: string;
  SUN: string;
  MOON: string;
}

// 颜色资源接口
interface ColorResources {
  PRIMARY: string;
  PRIMARY_LIGHT: string;
  PRIMARY_DARK: string;
  SECONDARY: string;
  SECONDARY_LIGHT: string;
  SECONDARY_DARK: string;
  ACCENT: string;
  BACKGROUND: string;
  SURFACE: string;
  ERROR: string;
  WARNING: string;
  INFO: string;
  SUCCESS: string;
  TEXT_PRIMARY: string;
  TEXT_SECONDARY: string;
  TEXT_DISABLED: string;
  DIVIDER: string;
  DARK_BACKGROUND: string;
  DARK_SURFACE: string;
  DARK_TEXT_PRIMARY: string;
  DARK_TEXT_SECONDARY: string;
}

// 字符串资源接口
interface StringResources {
  APP_NAME: string;
  APP_SLOGAN: string;
  LOGIN_TITLE: string;
  REGISTER_TITLE: string;
  HOME_TITLE: string;
  PET_LIST_TITLE: string;
  PET_DETAIL_TITLE: string;
  APPLY_TITLE: string;
  MY_APPLY_TITLE: string;
  ADDRESS_TITLE: string;
  MINE_TITLE: string;
  POST_LIST_TITLE: string;
  COMMENT_TITLE: string;
  FEEDBACK_TITLE: string;
  NOTICE_TITLE: string;
  MATCH_TEST_TITLE: string;
  CONTRACT_TITLE: string;
}

// 尺寸资源接口
interface DimensionResources {
  SPACE_XS: number;
  SPACE_SM: number;
  SPACE_MD: number;
  SPACE_LG: number;
  SPACE_XL: number;
  RADIUS_SM: number;
  RADIUS_MD: number;
  RADIUS_LG: number;
  RADIUS_XL: number;
  FONT_SIZE_XS: number;
  FONT_SIZE_SM: number;
  FONT_SIZE_MD: number;
  FONT_SIZE_LG: number;
  FONT_SIZE_XL: number;
  FONT_SIZE_XXL: number;
  ICON_SIZE_SM: number;
  ICON_SIZE_MD: number;
  ICON_SIZE_LG: number;
  ICON_SIZE_XL: number;
}

// 动画资源接口
interface AnimationResources {
  DURATION_FAST: number;
  DURATION_NORMAL: number;
  DURATION_SLOW: number;
  EASING_STANDARD: string;
  EASING_DECELERATE: string;
  EASING_ACCELERATE: string;
}

export class ResourceManager {
  // 图片资源
  static readonly IMAGES: ImageResources = {
    BACK: 'common/images/back.png',
    ADD: 'common/images/add.png',
    CLOSE: 'common/images/close.png',
    SEARCH: 'common/images/search.png',
    REFRESH: 'common/images/refresh.png',
    ARROW_RIGHT: 'common/images/arrow_right.png',
    ERROR: 'common/images/error.png',
    SUCCESS: 'common/images/success.png',
    NO_DATA: 'common/images/no_data.png',
    EMPTY: 'common/images/empty.png',
    USER_DEFAULT: 'common/images/user_default.png',
    AVATAR_PLACEHOLDER: 'common/images/avatar_placeholder.png',
    PET_DEFAULT: 'common/images/pet_default.png',
    PET_PLACEHOLDER: 'common/images/pet_placeholder.png',
    LOGO: 'common/images/logo.png',
    MATCH_ICON: 'common/images/match_icon.png',
    CALENDAR_ICON: 'common/images/calendar_icon.png',
    POST_ICON: 'common/images/post_icon.png',
    NOTICE_ICON: 'common/images/notice_icon.png',
    LEVEL: 'common/images/level.png',
    APPLY: 'common/images/apply.png',
    FAVORITE: 'common/images/favorite.png',
    HISTORY: 'common/images/history.png',
    ADDRESS: 'common/images/address.png',
    POST: 'common/images/post.png',
    COMMENT: 'common/images/comment.png',
    NIGHT: 'common/images/night.png',
    NOTIFICATION: 'common/images/notification.png',
    PRIVACY: 'common/images/privacy.png',
    ABOUT: 'common/images/about.png',
    HELP: 'common/images/help.png',
    FEEDBACK: 'common/images/feedback.png',
    LIKE_OUTLINE: 'common/images/like_outline.png',
    LIKE_FILLED: 'common/images/like_filled.png',
    FAVORITE_OUTLINE: 'common/images/favorite_outline.png',
    FAVORITE_FILLED: 'common/images/favorite_filled.png',
    EYE: 'common/images/eye.png',
    UNREAD: 'common/images/unread.png',
    NO_ADDRESS: 'common/images/no_address.png',
    NO_COMMENT: 'common/images/no_comment.png',
    IMAGE: 'common/images/image.png',
    NO_NOTICE: 'common/images/no_notice.png',
    WECHAT: 'common/images/wechat.png',
    QQ: 'common/images/qq.png',
    WEIBO: 'common/images/weibo.png',
    SUN: 'common/images/sun.png',
    MOON: 'common/images/moon.png'
  };

  // 颜色资源
  static readonly COLORS: ColorResources = {
    PRIMARY: '#FF6B35',
    PRIMARY_LIGHT: '#FF9A76',
    PRIMARY_DARK: '#D84315',
    SECONDARY: '#4CAF50',
    SECONDARY_LIGHT: '#80E27E',
    SECONDARY_DARK: '#087F23',
    ACCENT: '#FF9800',
    BACKGROUND: '#F5F5F5',
    SURFACE: '#FFFFFF',
    ERROR: '#F44336',
    WARNING: '#FFC107',
    INFO: '#2196F3',
    SUCCESS: '#4CAF50',
    TEXT_PRIMARY: '#212121',
    TEXT_SECONDARY: '#757575',
    TEXT_DISABLED: '#9E9E9E',
    DIVIDER: '#E0E0E0',

    // 深色模式颜色
    DARK_BACKGROUND: '#121212',
    DARK_SURFACE: '#1E1E1E',
    DARK_TEXT_PRIMARY: '#FFFFFF',
    DARK_TEXT_SECONDARY: '#B0B0B0'
  };

  // 字符串资源（可以从string.json读取）
  static readonly STRINGS: StringResources = {
    APP_NAME: '鸿蒙宠物领养平台',
    APP_SLOGAN: '让爱宠找到温暖的家',
    LOGIN_TITLE: '登录',
    REGISTER_TITLE: '注册',
    HOME_TITLE: '首页',
    PET_LIST_TITLE: '宠物列表',
    PET_DETAIL_TITLE: '宠物详情',
    APPLY_TITLE: '领养申请',
    MY_APPLY_TITLE: '我的申请',
    ADDRESS_TITLE: '地址管理',
    MINE_TITLE: '个人中心',
    POST_LIST_TITLE: '经验分享',
    COMMENT_TITLE: '评论',
    FEEDBACK_TITLE: '意见反馈',
    NOTICE_TITLE: '系统公告',
    MATCH_TEST_TITLE: '宠物匹配测试',
    CONTRACT_TITLE: '领养合同'
  };

  // 尺寸资源
  static readonly DIMENSIONS: DimensionResources = {
    // 间距
    SPACE_XS: 4,
    SPACE_SM: 8,
    SPACE_MD: 16,
    SPACE_LG: 24,
    SPACE_XL: 32,

    // 圆角
    RADIUS_SM: 4,
    RADIUS_MD: 8,
    RADIUS_LG: 16,
    RADIUS_XL: 24,

    // 字体大小
    FONT_SIZE_XS: 12,
    FONT_SIZE_SM: 14,
    FONT_SIZE_MD: 16,
    FONT_SIZE_LG: 18,
    FONT_SIZE_XL: 20,
    FONT_SIZE_XXL: 24,

    // 图标大小
    ICON_SIZE_SM: 20,
    ICON_SIZE_MD: 24,
    ICON_SIZE_LG: 32,
    ICON_SIZE_XL: 48
  };

  // 动画资源
  static readonly ANIMATIONS: AnimationResources = {
    DURATION_FAST: 100,
    DURATION_NORMAL: 300,
    DURATION_SLOW: 500,
    EASING_STANDARD: 'cubic-bezier(0.4, 0.0, 0.2, 1)',
    EASING_DECELERATE: 'cubic-bezier(0.0, 0.0, 0.2, 1)',
    EASING_ACCELERATE: 'cubic-bezier(0.4, 0.0, 1, 1)'
  };
}