import Ability from '@ohos.app.ability.UIAbility';
import Window from '@ohos.window';
import { RouterConfig } from '../router/RouterConfig';
import { CommonStyles } from '../common/css/CommonStyles';
import { currentUser } from '../mock/UserData';
import { initExampleData } from '../mock/PetMoodSystem';
import { getUnreadNoticeCount } from '../mock/NoticeData';
import { AppStore } from '../store/AppStore';
import Want from '@ohos.app.ability.Want';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import type { BusinessError } from '@ohos.base';

// 用户接口
interface UserInfo {
  id: number;
  username: string;
}

// 应用状态接口
interface AppState {
  timestamp: string;
  user: UserInfo | null;
}

// 通知接口
interface NotificationData {
  title: string;
  content?: string;
  type?: string;
}

export default class EntryAbility extends Ability {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    this.initApp();
  }

  onDestroy() {
  }

  onWindowStageCreate(windowStage: Window.WindowStage) {

    // 设置窗口属性
    windowStage.loadContent('pages/Splash', (err, data) => {
      if (err.code) {
        console.error('Failed to load the content. Cause:' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in loading the content.');
    });

    // 设置窗口样式
    windowStage.getMainWindow((err, window) => {
      if (err.code) {
        console.error('Failed to obtain the main window. Cause: ' + JSON.stringify(err));
        return;
      }

      // 设置窗口背景色
      window.setWindowBackgroundColor(CommonStyles.BG_LIGHT);

      // 设置窗口布局
      window.setWindowLayoutFullScreen(true);
      window.setWindowSystemBarProperties({
        statusBarColor: CommonStyles.PRIMARY_COLOR,
        statusBarContentColor: CommonStyles.WHITE,
        navigationBarColor: CommonStyles.WHITE,
        navigationBarContentColor: CommonStyles.TEXT_PRIMARY
      });

      // 获取安全区域信息并设置窗口安全区域
      window.getWindowAvoidArea(Window.AvoidAreaType.TYPE_SYSTEM);
    });
  }

  onWindowStageDestroy() {
  }

  onForeground() {
    this.checkAppUpdate();
    this.syncUserData();
  }

  onBackground() {
    this.saveAppState();
  }

  private initApp() {
    this.initUserData();
    this.initPetMoodSystem();
    this.initNotificationSystem();
    this.checkAppUpdate();
    this.syncAppData();
  }

  private initUserData() {
    if (currentUser) {
      AppStore.getInstance().setUser(currentUser);
    } else {
      AppStore.getInstance().clearUser();
    }
  }

  private initPetMoodSystem() {
    try {
      initExampleData();
    } catch (error) {
      console.error('宠物情绪系统初始化失败', error);
    }
  }

  private initNotificationSystem() {
    setInterval(() => {
      this.checkNotifications();
    }, 300000);
  }

  private checkNotifications() {
    const unreadCount = getUnreadNoticeCount();
  }

  private checkAppUpdate() {
  }

  private syncUserData() {
    if (currentUser) {
    }
  }

  private syncAppData() {
    setTimeout(() => {
    }, 1000);
  }

  private saveAppState() {
    const appState: AppState = {
      timestamp: new Date().toISOString(),
      user: currentUser ? {
        id: currentUser.id,
        username: currentUser.username
      } as UserInfo : null
    };
  }

  // 处理推送通知
  private handlePushNotification(notification: NotificationData) {
    this.showNotification(notification);
    this.updateNotificationBadge();
  }

  // 显示通知
  private showNotification(notification: NotificationData) {
  }

  private updateNotificationBadge() {
    const unreadCount = getUnreadNoticeCount();
  }

  // 处理深链
  private handleDeepLink(url: string) {
    try {
      const urlParts = url.split('?');
      const path = urlParts[0];
      const params: Record<string, string> = {};

      if (urlParts.length > 1) {
        const queryString = urlParts[1];
        const pairs = queryString.split('&');
        for (const pair of pairs) {
          const parts = pair.split('=');
          const key = parts[0];
          const value = parts[1];
          if (key && value) {
            params[decodeURIComponent(key)] = decodeURIComponent(value);
          }
        }
      }

      this.navigateByDeepLink(path, params);
    } catch (error) {
      console.error('解析深链接失败', error);
    }
  }

  // 根据深链接跳转
  private navigateByDeepLink(path: string, params: Record<string, string>) {
    switch (path) {
      case '/pet':
        if (params.id) {
          RouterConfig.navigateToPetDetail(parseInt(params.id));
        }
        break;
      case '/post':
        break;
      case '/apply':
        if (params.id) {
          RouterConfig.navigateToApply(parseInt(params.id));
        }
        break;
      default:
        break;
    }
  }

  // 处理权限请求
  private handlePermissionRequest(permissions: string[]): Promise<number[]> {
    return Promise.resolve(permissions.map(() => 0));
  }

  private checkPermissions(permissions: string[]): Promise<boolean[]> {
    return Promise.resolve(permissions.map(() => true));
  }

  private showPermissionExplanation(permissions: string[]): Promise<boolean> {
    return Promise.resolve(true);
  }
}