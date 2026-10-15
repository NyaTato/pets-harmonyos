/**
 * 组件类型定义
 */

// 位置数据
export interface LocationData {
  latitude: number;
  longitude: number;
  timestamp: string;
}

// 宠物类型
export interface PetType {
  id: number;
  name: string;
  icon: string;
  description: string;
  unlocked: boolean;
  unlockDate?: string;
}

// 宠物互动动作
export interface PetInteraction {
  id: number;
  name: string;
  icon: string;
  description: string;
  energyCost: number;
  happinessGain: number;
}

// 分享卡片主题
export interface ShareCardTheme {
  id: number;
  name: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
}

// 宠物声音数据
export interface PetSound {
  id: number;
  name: string;
  description: string;
  soundText: string;
}

// 图片数据
export interface ImageData {
  id: number;
  url: string;
  title: string;
  description: string;
}

// 合同数据
export interface ContractData {
  petName: string;
  petType: string;
  petAge: number;
  adopterName: string;
  adopterIdCard: string;
  adopterPhone: string;
  adopterAddress: string;
  adoptionDate: string;
  adoptionFee: number;
  trialPeriod: number;
  terms: string[];
}

// 宠物云养状态
export interface PetCloudStatus {
  name: string;
  type: string;
  level: number;
  exp: number;
  happiness: number;
  energy: number;
  lastFeedTime: string;
  lastPlayTime: string;
}

// 走失预警配置
export interface LostWarningConfig {
  petName: string;
  petType: string;
  petImage: string;
  safeRadius: number;
  isEnabled: boolean;
  lastLocation: LocationData;
}

// 手势事件类型
export interface GestureEventInfo {
  type: string;
  scale?: number;
  offsetX?: number;
  offsetY?: number;
}

// 动画配置
export interface AnimationConfig {
  duration: number;
  curve: string;
  delay?: number;
  onEnter?: (value: number) => void;
  onExit?: (value: number) => void;
  onFrame?: (value: number) => void;
  iterations?: number;
}
