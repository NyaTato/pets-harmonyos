// 路由配置 - 使用RouterHelper统一管理路由跳转
import { RouterHelper, RouteParams } from './RouterHelper';

interface Pages {
  SPLASH: string;
  LOGIN: string;
  REGISTER: string;
  INDEX: string;
  PET_LIST: string;
  PET_DETAIL: string;
  APPLY: string;
  MY_APPLY: string;
  ADDRESS_LIST: string;
  MINE: string;
  EDIT_PROFILE: string;
  POST_LIST: string;
  POST_QUESTION: string;
  SHARE_RANK: string;
  COMMENT: string;
  MY_COMMENTS: string;
  MY_FAVORITES: string;
  BROWSE_HISTORY: string;
  FEEDBACK: string;
  NOTICE: string;
  MATCH_TEST: string;
  CONTRACT: string;
  INNOVATION_DEMO: string;
}

export class RouterConfig {
  // 页面路由路径
  static readonly PAGES: Pages = {
    SPLASH: 'pages/Splash',
    LOGIN: 'pages/Login',
    REGISTER: 'pages/Register',
    INDEX: 'pages/MainTab',
    PET_LIST: 'pages/PetList',
    PET_DETAIL: 'pages/Detail',
    APPLY: 'pages/Apply',
    MY_APPLY: 'pages/MyApply',
    ADDRESS_LIST: 'pages/AddressList',
    MINE: 'pages/Mine',
    EDIT_PROFILE: 'pages/EditProfile',
    POST_LIST: 'pages/PostList',
    POST_QUESTION: 'pages/PostQuestion',
    SHARE_RANK: 'pages/ShareRank',
    COMMENT: 'pages/Comment',
    MY_COMMENTS: 'pages/MyComments',
    MY_FAVORITES: 'pages/MyFavorites',
    BROWSE_HISTORY: 'pages/BrowseHistory',
    FEEDBACK: 'pages/Feedback',
    NOTICE: 'pages/Notice',
    MATCH_TEST: 'pages/MatchTest',
    CONTRACT: 'pages/Contract',
    INNOVATION_DEMO: 'pages/InnovationDemo'
  };

  // 跳转到启动页
  static navigateToSplash(): void {
    RouterHelper.navigateToSplash();
  }

  // 跳转到登录页
  static navigateToLogin(): void {
    RouterHelper.navigateToLogin();
  }

  // 跳转到注册页
  static navigateToRegister(): void {
    RouterHelper.navigateToRegister();
  }

  // 跳转到忘记密码页
  static navigateToForgotPassword(): void {
    RouterHelper.navigateToForgotPassword();
  }

  // 跳转到首页
  static navigateToIndex(): void {
    RouterHelper.navigateToIndex();
  }

  // 跳转到宠物列表页
  static navigateToPetList(): void {
    RouterHelper.navigateToPetList();
  }

  // 跳转到宠物详情页
  static navigateToPetDetail(petId: number): void {
    RouterHelper.navigateToPetDetail(petId);
  }

  // 跳转到领养申请页
  static navigateToApply(petId: number): void {
    RouterHelper.navigateToApply(petId);
  }

  // 跳转到我的申请页
  static navigateToMyApply(): void {
    RouterHelper.navigateToMyApply();
  }

  // 跳转到地址管理页
  static navigateToAddressList(): void {
    RouterHelper.navigateToAddressList();
  }

  // 跳转到个人中心页
  static navigateToMine(): void {
    RouterHelper.navigateToMine();
  }

  // 跳转到编辑资料页
  static navigateToEditProfile(): void {
    RouterHelper.navigateToEditProfile();
  }

  // 跳转到我的评论页
  static navigateToMyComments(): void {
    RouterHelper.navigateToMyComments();
  }

  // 跳转到我的收藏页
  static navigateToMyFavorites(): void {
    RouterHelper.navigateToMyFavorites();
  }

  // 跳转到浏览记录页
  static navigateToBrowseHistory(): void {
    RouterHelper.navigateToBrowseHistory();
  }

  // 跳转到经验帖子列表页
  static navigateToPostList(): void {
    RouterHelper.navigateToPostList();
  }

  // 跳转到评论页
  static navigateToComment(postId: number): void {
    RouterHelper.navigateToComment(postId);
  }

  // 跳转到意见反馈页
  static navigateToFeedback(): void {
    RouterHelper.navigateToFeedback();
  }

  // 跳转到系统公告页
  static navigateToNotice(): void {
    RouterHelper.navigateToNotice();
  }

  // 跳转到养宠日历页
  static navigateToCalendar(): void {
    RouterHelper.navigateToCalendar();
  }

  // 跳转到宠物匹配测试页
  static navigateToMatchTest(): void {
    RouterHelper.navigateToMatchTest();
  }

  // 跳转到领养合同预览页
  static navigateToContract(applyId: number): void {
    RouterHelper.navigateToContract(applyId);
  }

  // 跳转到创新功能演示页
  static navigateToInnovationDemo(): void {
    RouterHelper.navigateToInnovationDemo();
  }

  // 跳转到 AR 实景预览页
  static navigateToARPreview(): void {
    RouterHelper.navigateToARPreview();
  }

  // 跳转到宠物声音模拟器页
  static navigateToPetSoundSimulator(): void {
    RouterHelper.navigateToPetSoundSimulator();
  }

  // 跳转到云养宠模式页
  static navigateToPetCloudAdoption(): void {
    RouterHelper.navigateToPetCloudAdoption();
  }

  // 跳转到宠物走失预警页
  static navigateToPetLostWarning(): void {
    RouterHelper.navigateToPetLostWarning();
  }

  // 跳转到智能推荐系统页
  static navigateToSmartRecommendation(): void {
    RouterHelper.navigateToSmartRecommendation();
  }

  // 跳转到分享卡片生成器页
  static navigateToShareCardGenerator(): void {
    RouterHelper.navigateToShareCardGenerator();
  }

  // 跳转到信用分展示页
  static navigateToCreditScoreDisplay(): void {
    RouterHelper.navigateToCreditScoreDisplay();
  }

  // 跳转到宠物情绪识别页
  static navigateToMoodDisplay(): void {
    RouterHelper.navigateToMoodDisplay();
  }

  // 跳转到宠物等级系统页
  static navigateToPetLevelSystem(): void {
    RouterHelper.navigateToPetLevelSystem();
  }

  // 返回上一页
  static back(): void {
    RouterHelper.back();
  }

  // 获取路由参数
  static getParams(): RouteParams {
    return RouterHelper.getParams();
  }

  // 清空路由栈并跳转到首页
  static clearAndNavigateToIndex(): void {
    RouterHelper.clearAndNavigateToIndex();
  }
}
