// 领养申请数据
export interface Apply {
  id: number;
  petId: number;
  userId: number;
  petName: string;
  userName: string;
  phone: string;
  address: string;
  experience: string;
  status: '待审核' | '已通过' | '已驳回' | '已完成';
  reason?: string; // 申请理由
  reviewer?: string; // 审核人
  reviewTime?: string; // 审核时间
  reviewNote?: string; // 审核备注
  createTime: string;
  updateTime: string;
}

export interface ApplyData {
  userId: number;
  petId: number;
  petName: string;
  userName: string;
  phone: string;
  address: string;
  experience: string;
  reason?: string;
  status?: string;
}

// 模拟领养申请数据
export const applyList: Apply[] = [
  {
    id: 1,
    petId: 1,
    userId: 1,
    petName: "橘猫",
    userName: "测试用户",
    phone: "00000000000",
    address: "广州市天河区珠江新城花城大道88号",
    experience: "2年养猫经验，家里已有一只猫，有稳定住房",
    status: "待审核",
    reason: "非常喜欢猫咪，看到这只橘猫特别有眼缘，希望能给它一个温暖的家",
    createTime: "2026-04-10 14:30:00",
    updateTime: "2026-04-10 14:30:00"
  },
  {
    id: 2,
    petId: 3,
    userId: 1,
    petName: "柯基",
    userName: "测试用户",
    phone: "00000000000",
    address: "广州市天河区珠江新城花城大道88号",
    experience: "1年养狗经验，每天有固定时间遛狗",
    status: "已通过",
    reason: "一直想养一只柯基，看到这只柯基特别可爱，希望能领养",
    reviewer: "管理员",
    reviewTime: "2026-04-11 10:15:00",
    reviewNote: "申请人条件符合，通过审核",
    createTime: "2026-04-09 09:20:00",
    updateTime: "2026-04-11 10:15:00"
  },
  {
    id: 3,
    petId: 2,
    userId: 2,
    petName: "布偶",
    userName: "李四",
    phone: "00000000000",
    address: "北京市朝阳区建国门外大街1号",
    experience: "3年养猫经验，有布偶猫饲养经验",
    status: "已完成",
    reason: "特别喜欢布偶猫，家里条件适合养长毛猫",
    reviewer: "管理员",
    reviewTime: "2026-04-08 16:45:00",
    reviewNote: "领养成功，已完成交接",
    createTime: "2026-04-07 11:10:00",
    updateTime: "2026-04-09 14:20:00"
  },
  {
    id: 4,
    petId: 4,
    userId: 3,
    petName: "金毛",
    userName: "王五",
    phone: "00000000000",
    address: "上海市浦东新区陆家嘴环路100号",
    experience: "无养狗经验，但有养猫经验",
    status: "已驳回",
    reason: "家里空间太小，不适合养大型犬",
    reviewer: "管理员",
    reviewTime: "2026-04-12 09:30:00",
    reviewNote: "申请人居住环境不适合饲养大型犬",
    createTime: "2026-04-11 15:45:00",
    updateTime: "2026-04-12 09:30:00"
  },
  {
    id: 5,
    petId: 5,
    userId: 1,
    petName: "英短",
    userName: "测试用户",
    phone: "00000000000",
    address: "广州市天河区珠江新城花城大道88号",
    experience: "2年养猫经验，家里已有一只猫，有稳定住房",
    status: "待审核",
    reason: "想给家里的猫咪找个伴",
    createTime: "2026-04-13 11:20:00",
    updateTime: "2026-04-13 11:20:00"
  },
  {
    id: 6,
    petId: 6,
    userId: 4,
    petName: "哈士奇",
    userName: "赵六",
    phone: "00000000000",
    address: "深圳市南山区科技园科苑路123号",
    experience: "有养狗经验，家里有院子",
    status: "已通过",
    reason: "喜欢哈士奇的活泼性格，有足够空间饲养",
    reviewer: "管理员",
    reviewTime: "2026-04-12 14:00:00",
    reviewNote: "申请人条件良好，通过审核",
    createTime: "2026-04-10 16:30:00",
    updateTime: "2026-04-12 14:00:00"
  },
  {
    id: 7,
    petId: 7,
    userId: 2,
    petName: "波斯猫",
    userName: "李四",
    phone: "00000000000",
    address: "北京市朝阳区建国门外大街1号",
    experience: "3年养猫经验，有长毛猫饲养经验",
    status: "已完成",
    reason: "喜欢波斯猫的优雅气质",
    reviewer: "管理员",
    reviewTime: "2026-04-09 13:15:00",
    reviewNote: "领养完成，交接顺利",
    createTime: "2026-04-08 10:45:00",
    updateTime: "2026-04-10 11:20:00"
  }
];

// 创建新申请
export function createApply(data: ApplyData): Apply {
  const newApply: Apply = {
    id: applyList.length + 1,
    petId: data.petId,
    userId: data.userId,
    petName: data.petName,
    userName: data.userName,
    phone: data.phone,
    address: data.address,
    experience: data.experience,
    status: '待审核', // 默认状态
    reason: data.reason,
    createTime: new Date().toLocaleString('zh-CN'),
    updateTime: new Date().toLocaleString('zh-CN')
  };

  applyList.push(newApply);
  return newApply;
}

// 更新申请状态
export function updateApplyStatus(applyId: number, status: '待审核' | '已通过' | '已驳回' | '已完成', reviewer?: string, reviewNote?: string): boolean {
  const applyIndex = applyList.findIndex(apply => apply.id === applyId);

  if (applyIndex !== -1) {
    applyList[applyIndex].status = status;
    if (reviewer) applyList[applyIndex].reviewer = reviewer;
    if (reviewNote) applyList[applyIndex].reviewNote = reviewNote;
    applyList[applyIndex].reviewTime = new Date().toLocaleString('zh-CN');
    applyList[applyIndex].updateTime = new Date().toLocaleString('zh-CN');
    return true;
  }

  return false;
}

// 获取用户申请统计
export interface ApplyStats {
  pending: number;
  approved: number;
  rejected: number;
  completed: number;
  total: number;
}

export function getUserApplyStats(userId: number): ApplyStats {
  const userApplies = applyList.filter(apply => apply.userId === userId);
  const pending = userApplies.filter(apply => apply.status === '待审核').length;
  const approved = userApplies.filter(apply => apply.status === '已通过').length;
  const rejected = userApplies.filter(apply => apply.status === '已驳回').length;
  const completed = userApplies.filter(apply => apply.status === '已完成').length;

  return {
    pending,
    approved,
    rejected,
    completed,
    total: pending + approved + rejected + completed
  };
}

// 检查用户是否可以申请
export function canUserApply(petId: number, userId: number): boolean {
  // 检查用户是否已有待审核或已通过的申请
  const existingApply = applyList.find(apply =>
  apply.petId === petId &&
    apply.userId === userId &&
    (apply.status === '待审核' || apply.status === '已通过')
  );

  return !existingApply;
}

// 获取用户的所有申请
export function getUserApplies(userId: number): Apply[] {
  return applyList.filter(apply => apply.userId === userId);
}

// 获取宠物的所有申请
export function getPetApplies(petId: number): Apply[] {
  return applyList.filter(apply => apply.petId === petId);
}

// 根据ID获取申请
export function getApplyById(applyId: number): Apply | undefined {
  return applyList.find(apply => apply.id === applyId);
}