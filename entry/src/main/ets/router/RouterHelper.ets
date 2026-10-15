// 路由助手类
import { router } from '@kit.ArkUI';

// 定义路由参数接口
interface RouterParams {
  url: string;
  params?: Record<string, string | number | boolean>;
}

// 定义路由参数接口
export interface RouteParams {
  petId?: string;
  petName?: string;
  postId?: string;
  applyId?: string;
  type?: string;
}

export class RouterHelper {
  // 替换当前页面
  static replaceUrl(url: string, params?: RouteParams): void {
    try {
      const routerParams: RouterParams = { url };
      if (params) {
        // 将RouteParams转换为Record<string, string | number | boolean>
        const recordParams: Record<string, string | number | boolean> = {};
        // 手动处理每个可能的属性
        if (params.petId !== undefined) {
          recordParams.petId = params.petId;
        }
        if (params.petName !== undefined) {
          recordParams.petName = params.petName;
        }
        if (params.postId !== undefined) {
          recordParams.postId = params.postId;
        }
        if (params.applyId !== undefined) {
          recordParams.applyId = params.applyId;
        }
        if (params.type !== undefined) {
          recordParams.type = params.type;
        }
        routerParams.params = recordParams;
      }
      router.replaceUrl(routerParams);
    } catch (error) {
      console.error('replaceUrl调用失败:', error);
    }
  }

  // 跳转到新页面
  static pushUrl(url: string, params?: RouteParams): void {
    try {
      const routerParams: RouterParams = { url };
      if (params) {
        // 将RouteParams转换为Record<string, string | number | boolean>
        const recordParams: Record<string, string | number | boolean> = {};
        // 手动处理每个可能的属性
        if (params.petId !== undefined) {
          recordParams.petId = params.petId;
        }
        if (params.petName !== undefined) {
          recordParams.petName = params.petName;
        }
        if (params.postId !== undefined) {
          recordParams.postId = params.postId;
        }
        if (params.applyId !== undefined) {
          recordParams.applyId = params.applyId;
        }
        if (params.type !== undefined) {
          recordParams.type = params.type;
        }
        routerParams.params = recordParams;
      }
      router.pushUrl(routerParams);
    } catch (error) {
      console.error('pushUrl调用失败:', error);
    }
  }

  // 返回上一页
  static back(): void {
    try {
      router.back();
    } catch (error) {
      console.error('back调用失败:', error);
    }
  }

  // 清空路由栈
  static clear(): void {
    try {
      router.clear();
    } catch (error) {
      console.error('clear调用失败:', error);
    }
  }

  // 获取当前路由参数
  static getParams(): RouteParams {
    try {
      const params = router.getParams() as Record<string, string | number | boolean>;
      // 将Record<string, string | number | boolean>转换为RouteParams
      const routeParams: RouteParams = {};
      if (params.petId !== undefined) {
        routeParams.petId = params.petId as string;
      }
      if (params.petName !== undefined) {
        routeParams.petName = params.petName as string;
      }
      if (params.postId !== undefined) {
        routeParams.postId = params.postId as string;
      }
      if (params.applyId !== undefined) {
        routeParams.applyId = params.applyId as string;
      }
      if (params.type !== undefined) {
        routeParams.type = params.type as string;
      }
      return routeParams;
    } catch (error) {
      console.error('获取路由参数失败:', error);
      return {} as RouteParams;
    }
  }

  // 获取当前路由路径
  static getUrl(): string {
    try {
      // @ohos.router 模块可能没有 getUrl 方法，返回空字符串作为默认值
      return '';
    } catch (error) {
      console.error('获取路由路径失败:', error);
      return '';
    }
  }

  // 获取路由栈长度
  static getLength(): number {
    try {
      const length = router.getLength();
      return typeof length === 'string' ? parseInt(length) : length;
    } catch (error) {
      console.error('获取路由栈长度失败', error);
      return 0;
    }
  }

  // 路由状态监听
  static onStateChange(callback: (state: Record<string, Object>) => void): void {
    try {
      // @ohos.router 模块可能没有 onStateChange 方法
      console.warn('onStateChange 方法可能不支持');
    } catch (error) {
      console.error('路由状态监听失败', error);
    }
  }

  // 移除路由状态监听
  static offStateChange(callback: (state: Record<string, Object>) => void): void {
    try {
      // @ohos.router 模块可能没有 offStateChange 方法
      console.warn('offStateChange 方法可能不支持');
    } catch (error) {
      console.error('移除路由状态监听失败', error);
    }
  }

  // 跳转到首页
  static navigateToHome(): void {
    RouterHelper.replaceUrl('pages/MainTab');
  }

  // 跳转到宠物列表页
  static navigateToPetList(): void {
    RouterHelper.pushUrl('pages/PetList');
  }

  // 跳转到宠物详情页
  static navigateToPetDetail(petId: number): void {
    const params: RouteParams = { petId: petId.toString() };
    RouterHelper.pushUrl('pages/Detail', params);
  }

  // 跳转到领养申请页
  static navigateToApply(petId: number, petName?: string): void {
    const params: RouteParams = { petId: petId.toString() };
    if (petName) {
      params.petName = petName;
    }
    RouterHelper.pushUrl('pages/Apply', params);
  }

  // 跳转到我的申请页
  static navigateToMyApply(): void {
    RouterHelper.pushUrl('pages/MyApply');
  }

  // 跳转到分享排行页
  static navigateToShareRank(): void {
    RouterHelper.pushUrl('pages/PostList');
  }

  // 跳转到分享提问窗口
  static navigateToShareQuestion(): void {
    // pages/PostQuestion 页面不存在，跳转到帖子列表页
    RouterHelper.pushUrl('pages/PostList');
  }

  // 跳转到评论页
  static navigateToComment(postId: number): void {
    const params: RouteParams = { postId: postId.toString() };
    RouterHelper.pushUrl('pages/Comment', params);
  }

  // 跳转到意见反馈页
  static navigateToFeedback(): void {
    RouterHelper.pushUrl('pages/Feedback');
  }

  // 跳转到匹配测试页
  static navigateToMatchTest(): void {
    RouterHelper.pushUrl('pages/MatchTest');
  }

  // 跳转到领养合同预览页
  static navigateToContract(applyId: number): void {
    const params: RouteParams = { applyId: applyId.toString() };
    RouterHelper.pushUrl('pages/Contract', params);
  }

  // 跳转到启动页
  static navigateToSplash(): void {
    RouterHelper.replaceUrl('pages/Splash');
  }

  // 跳转到登录页
  static navigateToLogin(): void {
    RouterHelper.pushUrl('pages/Login');
  }

  // 跳转到注册页
  static navigateToRegister(): void {
    RouterHelper.pushUrl('pages/Register');
  }

  // 跳转到忘记密码页
  static navigateToForgotPassword(): void {
    RouterHelper.pushUrl('pages/ForgotPassword');
  }

  // 跳转到主Tab页
  static navigateToMainTab(): void {
    RouterHelper.replaceUrl('pages/MainTab');
  }

  // 跳转到首页（旧方法，保持兼容性）
  static navigateToIndex(): void {
    RouterHelper.replaceUrl('pages/MainTab');
  }

  // 跳转到地址管理页
  static navigateToAddressList(): void {
    RouterHelper.pushUrl('pages/AddressList');
  }

  // 跳转到个人中心页
  static navigateToMine(): void {
    RouterHelper.pushUrl('pages/Mine');
  }

  // 跳转到编辑资料页
  static navigateToEditProfile(): void {
    RouterHelper.pushUrl('pages/EditProfile');
  }

  // 跳转到我的评论页
  static navigateToMyComments(): void {
    RouterHelper.pushUrl('pages/MyComments');
  }

  // 跳转到我的收藏页
  static navigateToMyFavorites(): void {
    RouterHelper.pushUrl('pages/MyFavorites');
  }

  // 跳转到浏览记录页
  static navigateToBrowseHistory(): void {
    RouterHelper.pushUrl('pages/BrowseHistory');
  }

  // 跳转到帖子列表页
  static navigateToPostList(): void {
    RouterHelper.pushUrl('pages/PostList');
  }

  // 跳转到通知页
  static navigateToNotice(): void {
    RouterHelper.pushUrl('pages/Notice');
  }

  // 跳转到养宠日历页
  static navigateToCalendar(): void {
    RouterHelper.pushUrl('pages/Calendar');
  }

  // 跳转到创新功能演示页
  static navigateToInnovationDemo(): void {
    RouterHelper.pushUrl('pages/InnovationDemo');
  }

  // 跳转到 AR 实景预览页
  static navigateToARPreview(): void {
    RouterHelper.pushUrl('pages/ARPreview');
  }

  // 跳转到宠物声音模拟器页
  static navigateToPetSoundSimulator(): void {
    RouterHelper.pushUrl('pages/PetSoundSimulator');
  }

  // 跳转到云养宠模式页
  static navigateToPetCloudAdoption(): void {
    RouterHelper.pushUrl('pages/PetCloudAdoption');
  }

  // 跳转到宠物走失预警页
  static navigateToPetLostWarning(): void {
    RouterHelper.pushUrl('pages/PetLostWarning');
  }

  // 跳转到智能推荐系统页
  static navigateToSmartRecommendation(): void {
    RouterHelper.pushUrl('pages/SmartRecommendation');
  }

  // 跳转到分享卡片生成器页
  static navigateToShareCardGenerator(): void {
    RouterHelper.pushUrl('pages/ShareCardGenerator');
  }

  // 跳转到信用分展示页
  static navigateToCreditScoreDisplay(): void {
    RouterHelper.pushUrl('pages/CreditScoreDisplay');
  }

  // 跳转到宠物情绪识别页
  static navigateToMoodDisplay(): void {
    RouterHelper.pushUrl('pages/MoodDisplay');
  }

  // 跳转到宠物等级系统页
  static navigateToPetLevelSystem(): void {
    RouterHelper.pushUrl('pages/PetLevelSystem');
  }

  // 清空并跳转到首页
  static clearAndNavigateToIndex(): void {
    RouterHelper.clear();
    RouterHelper.replaceUrl('pages/MainTab');
  }
}
