// 系统公告数据
export interface Notice {
  id: number;
  title: string;
  content: string;
  type: '系统' | '活动' | '维护' | '重要';
  isRead: boolean;
  createTime: string;
}

export interface Feedback {
  id: number;
  userId: number;
  userName: string;
  type: '建议' | '问题' | '投诉' | '其他';
  title: string;
  content: string;
  images?: string[];
  status: '待处理' | '处理中' | '已解决' | '已关闭';
  reply?: string;
  replyTime?: string;
  createTime: string;
  updateTime: string;
}

// 模拟公告数据
export const noticeList: Notice[] = [
  {
    id: 1,
    title: "平台系统升级通知",
    content: "为提供更好的服务，平台将在2026年4月15日00:00-06:00进行系统升级，期间将暂停服务，请提前做好安排。",
    type: "系统",
    isRead: false,
    createTime: "2026-04-10 09:00:00"
  },
  {
    id: 2,
    title: "五一劳动节领养优惠活动",
    content: "五一劳动节期间（4月28日-5月5日），成功领养宠物的用户可获得宠物用品大礼包一份！",
    type: "活动",
    isRead: false,
    createTime: "2026-04-08 14:30:00"
  },
  {
    id: 3,
    title: "关于领养审核流程优化的通知",
    content: "为进一步提升领养审核效率，我们对审核流程进行了优化，现在提交申请后将在3个工作日内完成审核。",
    type: "重要",
    isRead: true,
    createTime: "2026-04-05 10:15:00"
  },
  {
    id: 4,
    title: "宠物健康检查公益活动",
    content: "本周六（4月13日）在市民广场举办免费宠物健康检查活动，欢迎带宠物参加！",
    type: "活动",
    isRead: false,
    createTime: "2026-04-03 16:20:00"
  },
  {
    id: 5,
    title: "系统维护通知",
    content: "为提升系统稳定性，平台将于本周三（4月10日）凌晨2:00-4:00进行维护，期间可能无法正常访问。",
    type: "维护",
    isRead: true,
    createTime: "2026-04-01 11:45:00"
  },
  {
    id: 6,
    title: "用户信用分系统上线",
    content: "为建立更完善的领养体系，平台正式上线用户信用分系统，信用分将影响领养成功率。",
    type: "重要",
    isRead: false,
    createTime: "2026-03-28 09:30:00"
  },
  {
    id: 7,
    title: "春季宠物防疫提醒",
    content: "春季是宠物疾病高发期，请及时为宠物接种疫苗，做好驱虫工作。",
    type: "系统",
    isRead: false,
    createTime: "2026-03-25 15:10:00"
  },
  {
    id: 8,
    title: "领养合同电子化通知",
    content: "即日起，平台支持在线生成电子领养合同，方便快捷，具有法律效力。",
    type: "重要",
    isRead: false,
    createTime: "2026-03-20 13:25:00"
  }
];

// 模拟反馈数据
export const feedbackList: Feedback[] = [
  {
    id: 1,
    userId: 1,
    userName: "测试用户",
    type: "建议",
    title: "希望增加宠物视频功能",
    content: "建议在宠物详情页增加上传视频的功能，可以更直观地展示宠物的状态。",
    images: [],
    status: "已解决",
    reply: "感谢您的建议，我们已在开发计划中，预计下个版本上线。",
    replyTime: "2026-04-09 14:30:00",
    createTime: "2026-04-05 10:20:00",
    updateTime: "2026-04-09 14:30:00"
  },
  {
    id: 2,
    userId: 2,
    userName: "李四",
    type: "问题",
    title: "申请提交后无法查看进度",
    content: "提交领养申请后，在我的申请页面看不到审核进度，希望能优化。",
    images: [],
    status: "处理中",
    createTime: "2026-04-08 15:45:00",
    updateTime: "2026-04-08 15:45:00"
  },
  {
    id: 3,
    userId: 3,
    userName: "王五",
    type: "投诉",
    title: "宠物信息更新不及时",
    content: "有些宠物已经领养成功了，但平台上还显示可领养状态。",
    images: ["pets/pet_corgi_01.jpg"],
    status: "待处理",
    createTime: "2026-04-10 09:15:00",
    updateTime: "2026-04-10 09:15:00"
  },
  {
    id: 4,
    userId: 1,
    userName: "测试用户",
    type: "其他",
    title: "希望增加宠物分类筛选",
    content: "建议在宠物列表页增加更多筛选条件，比如年龄、性别、品种等。",
    images: [],
    status: "已解决",
    reply: "感谢您的建议，我们会在下个版本中增加更多筛选功能。",
    replyTime: "2026-04-07 11:20:00",
    createTime: "2026-04-03 16:30:00",
    updateTime: "2026-04-07 11:20:00"
  },
  {
    id: 5,
    userId: 2,
    userName: "李四",
    type: "问题",
    title: "图片上传失败",
    content: "在发布经验帖子时，图片上传经常失败，请检查。",
    images: ["pets/pet_orange_cat_01.jpg"],
    status: "已关闭",
    reply: "问题已修复，请重新尝试上传。",
    replyTime: "2026-04-06 10:10:00",
    createTime: "2026-04-01 14:25:00",
    updateTime: "2026-04-06 10:10:00"
  }
];

// 获取公告列表
export function getNotices(): Notice[] {
  return noticeList;
}

// 获取未读公告数量
export function getUnreadNoticeCount(): number {
  return noticeList.filter(notice => !notice.isRead).length;
}

// 标记公告为已读
export function markNoticeAsRead(noticeId: number): boolean {
  const noticeIndex = noticeList.findIndex(notice => notice.id === noticeId);
  if (noticeIndex !== -1) {
    noticeList[noticeIndex].isRead = true;
    return true;
  }
  return false;
}

// 标记所有公告为已读
export function markAllNoticesAsRead(): void {
  noticeList.forEach(notice => {
    notice.isRead = true;
  });
}

// 获取用户的反馈列表
export function getUserFeedbacks(userId: number): Feedback[] {
  return feedbackList.filter(feedback => feedback.userId === userId);
}

// 提交反馈数据接口
export interface FeedbackInput {
  userId: number;
  userName: string;
  type: '建议' | '问题' | '投诉' | '其他';
  title: string;
  content: string;
  images?: string[];
}

// 提交反馈
export function submitFeedback(feedbackData: FeedbackInput): Feedback | null {
  const newFeedback: Feedback = {
    id: feedbackList.length + 1,
    userId: feedbackData.userId,
    userName: feedbackData.userName,
    type: feedbackData.type,
    title: feedbackData.title,
    content: feedbackData.content,
    images: feedbackData.images || [],
    status: '待处理',
    createTime: new Date().toLocaleString('zh-CN'),
    updateTime: new Date().toLocaleString('zh-CN')
  };

  feedbackList.push(newFeedback);
  return newFeedback;
}

// 更新反馈状态
export function updateFeedbackStatus(feedbackId: number, status: '待处理' | '处理中' | '已解决' | '已关闭', reply?: string): boolean {
  const feedbackIndex = feedbackList.findIndex(feedback => feedback.id === feedbackId);
  if (feedbackIndex === -1) return false;

  feedbackList[feedbackIndex].status = status;
  if (reply) {
    feedbackList[feedbackIndex].reply = reply;
    feedbackList[feedbackIndex].replyTime = new Date().toLocaleString('zh-CN');
  }
  feedbackList[feedbackIndex].updateTime = new Date().toLocaleString('zh-CN');

  return true;
}

// 获取反馈统计
// 反馈统计接口
interface FeedbackStats {
  total: number;
  pending: number;
  processing: number;
  resolved: number;
  closed: number;
}

export function getFeedbackStats(userId: number): FeedbackStats {
  const userFeedbacks = getUserFeedbacks(userId);

  return {
    total: userFeedbacks.length,
    pending: userFeedbacks.filter(feedback => feedback.status === '待处理').length,
    processing: userFeedbacks.filter(feedback => feedback.status === '处理中').length,
    resolved: userFeedbacks.filter(feedback => feedback.status === '已解决').length,
    closed: userFeedbacks.filter(feedback => feedback.status === '已关闭').length
  };
}

// 获取最新公告
export function getLatestNotices(count: number = 3): Notice[] {
  const sortedNotices = noticeList.slice(); // 创建副本
  sortedNotices.sort((a, b) => new Date(b.createTime).getTime() - new Date(a.createTime).getTime());
  return sortedNotices.slice(0, count);
}

// 获取重要公告
export function getImportantNotices(): Notice[] {
  return noticeList.filter(notice => notice.type === '重要');
}

// 获取活动公告
export function getActivityNotices(): Notice[] {
  return noticeList.filter(notice => notice.type === '活动');
}