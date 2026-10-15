// 通用类型定义

// 用户类型
export interface User {
  id: number;
  username: string;
  password: string;
  nickname: string;
  avatar: string;
  phone: string;
  email: string;
  role: 'visitor' | 'user' | 'admin';
  creditScore: number;
  level: number;
  experience: number;
  createTime: string;
  updateTime: string;
}

// 宠物类型
export interface Pet {
  id: number;
  name: string;
  type: 'cat' | 'dog' | 'other';
  breed: string;
  age: number;
  gender: 'male' | 'female';
  weight: number;
  color: string;
  description: string;
  images: string[];
  vaccines: string[];
  isSterilized: boolean;
  healthStatus: 'excellent' | 'good' | 'fair' | 'poor';
  adoptionStatus: 'available' | 'pending' | 'adopted';
  location: string;
  ownerId?: number;
  createTime: string;
  updateTime: string;
  likes: number;
  views: number;
  favorites: number;
  // 兼容旧属性
  pics?: string[];
  status?: string;
  desc?: string;
  mood?: string;
  health?: string;
  isLiked?: boolean; // 是否已点赞
  isFavorited?: boolean; // 是否已收藏
}

// 宠物情绪类型
export interface PetMood {
  petId: number;
  mood: 'happy' | 'normal' | 'sad' | 'lonely';
  lastInteractionTime: string;
  interactionCount: number;
}

// 地址类型
export interface Address {
  id: number;
  userId: number;
  name: string;
  phone: string;
  province: string;
  city: string;
  district: string;
  detail: string;
  isDefault: boolean;
  createTime: string;
  updateTime: string;
}

// 领养申请类型
export interface AdoptionApply {
  id: number;
  userId: number;
  petId: number;
  applyTime: string;
  status: 'pending' | 'approved' | 'rejected' | 'completed';
  reason: string;
  familyInfo: string;
  workInfo: string;
  experience: string;
  housingCondition: string;
  interviewTime?: string;
  notes?: string;
  createTime: string;
  updateTime: string;
}

// 帖子类型
export interface Post {
  id: number;
  userId: number;
  userName: string;
  userAvatar: string;
  title: string;
  content: string;
  images: string[];
  category: string;
  likes: number;
  comments: number;
  views: number;
  isLiked: boolean;
  isFavorited: boolean;
  createTime: string;
  updateTime: string;
}

// 评论类型
export interface Comment {
  id: number;
  postId: number;
  userId: number;
  userName: string;
  userAvatar: string;
  content: string;
  likes: number;
  replies: Comment[];
  createTime: string;
  updateTime: string;
  isLiked: boolean;
}

// 公告类型
export interface Notice {
  id: number;
  title: string;
  content: string;
  type: 'system' | 'activity' | 'maintenance';
  createTime: string;
  updateTime: string;
}

// 反馈类型
export interface Feedback {
  id: number;
  userId: number;
  userName: string;
  type: string;
  title: string;
  content: string;
  images: string[];
  status: 'pending' | 'processing' | 'resolved' | 'closed';
  reply?: string;
  createTime: string;
  updateTime: string;
}

// 互动类型
export interface Interaction {
  id: number;
  userId: number;
  targetType: 'pet' | 'post' | 'comment';
  targetId: number;
  type: 'like' | 'favorite' | 'view';
  createTime: string;
}

// 匹配测试问题类型
export interface MatchQuestion {
  id: number;
  question: string;
  options: {
    text: string;
    value: number;
  }[];
}

// 匹配测试结果类型
export interface MatchResult {
  score: number;
  recommendation: string;
  suitablePets: number[]; // pet IDs
}

// 日历提醒类型
export interface CalendarReminder {
  id: number;
  userId: number;
  petId: number;
  type: 'vaccine' | 'deworming' | 'checkup' | 'other';
  title: string;
  description: string;
  date: string;
  isCompleted: boolean;
  createTime: string;
  updateTime: string;
}

// 宠物匹配度类型
export interface PetMatch {
  petId: number;
  matchScore: number;
  reasons: string[];
}

// 敏感词节点类型
export interface TrieNode {
  children: Map<string, TrieNode>;
  isEnd: boolean;
}

// 用户会话类型
export interface UserSession {
  userId: number;
  username: string;
  nickname: string;
  avatar: string;
  role: 'visitor' | 'user' | 'admin';
  token?: string;
  loginTime: string;
}

// 响应类型
export interface ApiResponse<T> {
  code: number;
  message: string;
  data: T;
  timestamp: string;
}

// 分页类型
export interface Pagination<T> {
  list: T[];
  total: number;
  page: number;
  pageSize: number;
  totalPages: number;
}

// 表单验证结果类型
export interface ValidationResult {
  isValid: boolean;
  errors: string[];
}

// 文件上传类型
export interface UploadFile {
  uri: string;
  name: string;
  size: number;
  type: string;
}

// 通知类型
export interface Notification {
  id: number;
  userId: number;
  type: 'system' | 'application' | 'interaction' | 'reminder';
  title: string;
  content: string;
  isRead: boolean;
  createTime: string;
}

// 系统配置类型
export interface SystemConfig {
  theme: 'light' | 'dark' | 'auto';
  language: 'zh' | 'en';
  notificationEnabled: boolean;
  autoLogin: boolean;
  fontSize: 'small' | 'medium' | 'large';
}

// 宠物健康记录类型
export interface HealthRecord {
  id: number;
  petId: number;
  type: 'vaccine' | 'checkup' | 'surgery' | 'other';
  description: string;
  date: string;
  doctor?: string;
  hospital?: string;
  notes?: string;
  createTime: string;
}

// 宠物喂养记录类型
export interface FeedingRecord {
  id: number;
  petId: number;
  foodType: string;
  amount: string;
  time: string;
  notes?: string;
  createTime: string;
}

// 用户成就类型
export interface Achievement {
  id: number;
  userId: number;
  type: 'adoption' | 'interaction' | 'post' | 'level';
  title: string;
  description: string;
  icon: string;
  achievedTime: string;
}

// 宠物领养合同类型
export interface AdoptionContract {
  id: number;
  applyId: number;
  userId: number;
  petId: number;
  contractNumber: string;
  content: string;
  signDate: string;
  effectiveDate: string;
  expirationDate?: string;
  status: 'draft' | 'signed' | 'expired' | 'terminated';
  createTime: string;
  updateTime: string;
}
