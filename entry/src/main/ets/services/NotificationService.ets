// 通知服务
import { Notice, getNotices, getUnreadNoticeCount, markNoticeAsRead } from '../mock/NoticeData';
import { CalendarEvent, getTodayEvents } from '../mock/CalendarData';
import { Apply, getUserApplies, getUserApplyStats } from '../mock/ApplyData';

// 通知摘要接口
interface NotificationSummary {
  unreadNotices: number;
  todayReminders: number;
  pendingApplies: number;
  totalNotifications: number;
}

// 通知统计接口
interface NotificationStats {
  important: number;
  activity: number;
  system: number;
  maintenance: number;
}

export class NotificationService {

  /**
   * 获取用户通知摘要
   * @param userId 用户ID
   */
  static getUserNotificationSummary(userId: number): NotificationSummary {
    const unreadNotices = getUnreadNoticeCount();
    const todayReminders = getTodayEvents().length;
    const applyStats = getUserApplyStats(userId);

    return {
      unreadNotices,
      todayReminders,
      pendingApplies: applyStats.pending,
      totalNotifications: unreadNotices + todayReminders + applyStats.pending
    };
  }

  /**
   * 获取重要通知
   */
  static getImportantNotices(): Notice[] {
    const allNotices = getNotices();
    return allNotices
      .filter(notice => notice.type === '重要')
      .sort((a, b) => new Date(b.createTime).getTime() - new Date(a.createTime).getTime())
      .slice(0, 5);
  }

  /**
   * 获取活动通知
   */
  static getActivityNotices(): Notice[] {
    const allNotices = getNotices();
    return allNotices
      .filter(notice => notice.type === '活动')
      .sort((a, b) => new Date(b.createTime).getTime() - new Date(a.createTime).getTime())
      .slice(0, 5);
  }

  /**
   * 获取今日提醒
   * @param userId 用户ID
   */
  static getTodayReminders(userId: number): CalendarEvent[] {
    return getTodayEvents().filter(event => !event.isCompleted);
  }

  /**
   * 获取申请状态通知
   * @param userId 用户ID
   */
  static getApplyNotifications(userId: number): Apply[] {
    const userApplies = getUserApplies(userId);
    return userApplies
      .filter(apply => apply.status === '待审核')
      .sort((a, b) => new Date(b.createTime).getTime() - new Date(a.createTime).getTime());
  }

  /**
   * 标记通知为已读
   * @param noticeId 通知ID
   */
  static markNoticeAsRead(noticeId: number): boolean {
    return markNoticeAsRead(noticeId);
  }

  /**
   * 批量标记通知为已读
   * @param noticeIds 通知ID数组
   */
  static markNoticesAsRead(noticeIds: number[]): number {
    let markedCount = 0;
    noticeIds.forEach(noticeId => {
      if (markNoticeAsRead(noticeId)) {
        markedCount++;
      }
    });
    return markedCount;
  }

  /**
   * 获取通知分类统计
   */
  static getNotificationStats(): NotificationStats {
    const allNotices = getNotices();

    return {
      important: allNotices.filter(notice => notice.type === '重要').length,
      activity: allNotices.filter(notice => notice.type === '活动').length,
      system: allNotices.filter(notice => notice.type === '系统').length,
      maintenance: allNotices.filter(notice => notice.type === '维护').length
    };
  }

  /**
   * 生成通知摘要消息
   * @param summary 通知摘要
   */
  static generateSummaryMessage(summary: NotificationSummary): string {
    const messages: string[] = [];

    if (summary.unreadNotices > 0) {
      messages.push(`您有${summary.unreadNotices}条未读通知`);
    }

    if (summary.todayReminders > 0) {
      messages.push(`今日${summary.todayReminders}个待办事项`);
    }

    if (summary.pendingApplies > 0) {
      messages.push(`您有${summary.pendingApplies}个申请待处理`);
    }

    if (messages.length === 0) {
      return '暂无新通知';
    }

    return messages.join('、');
  }

  /**
   * 检查是否有紧急通知
   * @param userId 用户ID
   */
  static hasUrgentNotifications(userId: number): boolean {
    const summary = NotificationService.getUserNotificationSummary(userId);
    const importantNotices = NotificationService.getImportantNotices();

    // 有重要通知或待处理的申请
    return importantNotices.length > 0 || summary.pendingApplies > 0;
  }

  /**
   * 获取通知优先级
   * @param notice 通知
   */
  static getNoticePriority(notice: Notice): number {
    const priorities: Record<string, number> = {
      '重要': 3,
      '活动': 2,
      '系统': 1,
      '维护': 1
    };

    return priorities[notice.type] || 0;
  }

  /**
   * 获取排序后的通知列表
   * @param type 通知类型，可选
   */
  static getSortedNotices(type?: string): Notice[] {
    let notices = getNotices();

    if (type) {
      notices = notices.filter(notice => notice.type === type);
    }

    return notices.sort((a, b) => {
      // 首先按优先级排序
      const priorityDiff = NotificationService.getNoticePriority(b) - NotificationService.getNoticePriority(a);
      if (priorityDiff !== 0) {
        return priorityDiff;
      }

      // 然后按创建时间排序（最新的在前）
      return new Date(b.createTime).getTime() - new Date(a.createTime).getTime();
    });
  }

  /**
   * 创建模拟通知（用于测试）
   */
  static createMockNotice(title: string, content: string, type: string = '系统'): Notice {
    const notices = getNotices();
    const maxId = notices.length > 0 ? Math.max(...notices.map(n => n.id)) : 0;

    const newNotice: Notice = {
      id: maxId + 1,
      title,
      content,
      type: type as '系统' | '活动' | '维护' | '重要',
      isRead: false,
      createTime: new Date().toISOString()
    };

    // 注意：这里只是返回模拟数据，不会实际保存
    // 在实际应用中，这里应该调用数据层的添加方法
    return newNotice;
  }
}
