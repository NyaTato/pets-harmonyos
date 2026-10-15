// 用户数据
export interface User {
  id: number;
  username: string;
  password: string;
  nickname: string;
  avatar: string;
  phone: string;
  email: string;
  signature?: string; // 个性签名
  bio?: string; // 个人简介
  role: 'visitor' | 'user' | 'admin'; // 游客/普通用户/管理员
  creditScore: number; // 信用分 0-100
  level: number; // 等级
  experience: number; // 经验值
  medals: string[]; // 勋章
  createdAt: string;
  lastLogin: string;
}

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
}

// 模拟用户数据
export const userList: User[] = [
  {
    id: 1,
    username: "zhangsan",
    password: "123456",
    nickname: "测试用户",
    avatar: 'avatars/avatar_user_zhangsan.jpg',
    phone: "00000000000",
    email: "zhangsan@example.com",
    role: "user",
    creditScore: 85,
    level: 3,
    experience: 450,
    medals: ["新手领养人", "爱宠达人", "活跃用户"],
    createdAt: "2026-01-15",
    lastLogin: "2026-04-11"
  },
  {
    id: 2,
    username: "lisi",
    password: "123456",
    nickname: "李四",
    avatar: 'avatars/avatar_user_lisi.jpg',
    phone: "00000000000",
    email: "lisi@example.com",
    role: "user",
    creditScore: 92,
    level: 5,
    experience: 1200,
    medals: ["资深领养人", "爱心大使", "社区贡献者"],
    createdAt: "2025-11-20",
    lastLogin: "2026-04-10"
  },
  {
    id: 3,
    username: "wangwu",
    password: "123456",
    nickname: "王五",
    avatar: 'avatars/avatar_user_wangwu.jpg',
    phone: "00000000000",
    email: "wangwu@example.com",
    role: "user",
    creditScore: 78,
    level: 2,
    experience: 280,
    medals: ["新手领养人"],
    createdAt: "2026-02-10",
    lastLogin: "2026-04-09"
  },
  {
    id: 4,
    username: "admin",
    password: "admin123",
    nickname: "管理员",
    avatar: 'avatars/avatar_admin.jpg',
    phone: "00000000000",
    email: "admin@example.com",
    role: "admin",
    creditScore: 100,
    level: 10,
    experience: 5000,
    medals: ["系统管理员", "超级版主", "社区守护者"],
    createdAt: "2025-10-01",
    lastLogin: "2026-04-11"
  }
];

// 模拟地址数据
export const addressList: Address[] = [
  {
    id: 1,
    userId: 1,
    name: "测试用户",
    phone: "00000000000",
    province: "广东省",
    city: "广州市",
    district: "天河区",
    detail: "珠江新城花城大道88号",
    isDefault: true
  },
  {
    id: 2,
    userId: 1,
    name: "测试用户",
    phone: "00000000000",
    province: "广东省",
    city: "深圳市",
    district: "南山区",
    detail: "科技园科苑路123号",
    isDefault: false
  },
  {
    id: 3,
    userId: 2,
    name: "李四",
    phone: "00000000000",
    province: "北京市",
    city: "北京市",
    district: "朝阳区",
    detail: "建国门外大街1号",
    isDefault: true
  },
  {
    id: 4,
    userId: 3,
    name: "王五",
    phone: "00000000000",
    province: "上海市",
    city: "上海市",
    district: "浦东新区",
    detail: "陆家嘴环路1000号",
    isDefault: true
  }
];

// 当前登录用户（模拟）
export let currentUser: User | null = userList[0];

// 登录响应接口
export interface LoginResponse {
  success: boolean;
  user?: User;
  message?: string;
}

// 用户登录
export function login(username: string, password: string): LoginResponse {
  const user = userList.find(u => u.username === username && u.password === password);
  if (user) {
    currentUser = user;
    user.lastLogin = new Date().toISOString().split('T')[0];
    return {
      success: true,
      user: user
    };
  }
  return {
    success: false,
    message: '用户名或密码错误'
  };
}

// 用户注册接口
export interface RegisterUserData {
  username: string;
  password: string;
  nickname: string;
  phone: string;
  email: string;
  avatar: string;
}

// 用户注册
export function register(userData: RegisterUserData): User | null {
  // 检查用户名是否已存在
  if (userList.some(u => u.username === userData.username)) {
    return null;
  }

  const newUser: User = {
    id: userList.length + 1,
    username: userData.username,
    password: userData.password,
    nickname: userData.nickname,
    phone: userData.phone,
    email: userData.email,
    avatar: userData.avatar,
    role: 'user', // 默认角色
    creditScore: 60, // 初始信用分
    level: 1,
    experience: 0,
    medals: ["新用户"],
    createdAt: new Date().toISOString().split('T')[0],
    lastLogin: new Date().toISOString().split('T')[0]
  };

  userList.push(newUser);
  currentUser = newUser;
  return newUser;
}

// 用户退出登录
export function logout(): void {
  currentUser = null;
}

// 修改密码
export function changePassword(userId: number, oldPassword: string, newPassword: string): boolean {
  const userIndex = userList.findIndex(u => u.id === userId);
  if (userIndex !== -1 && userList[userIndex].password === oldPassword) {
    userList[userIndex].password = newPassword;
    if (currentUser && currentUser.id === userId) {
      currentUser.password = newPassword;
    }
    return true;
  }
  return false;
}

// 更新用户信息
export function updateUserInfo(userId: number, userInfo: Partial<User>): boolean {
  const userIndex = userList.findIndex(u => u.id === userId);
  if (userIndex !== -1) {
    // 手动合并对象
    const updatedUser = userList[userIndex];
    if (userInfo.username !== undefined) updatedUser.username = userInfo.username;
    if (userInfo.password !== undefined) updatedUser.password = userInfo.password;
    if (userInfo.nickname !== undefined) updatedUser.nickname = userInfo.nickname;
    if (userInfo.phone !== undefined) updatedUser.phone = userInfo.phone;
    if (userInfo.email !== undefined) updatedUser.email = userInfo.email;
    if (userInfo.avatar !== undefined) updatedUser.avatar = userInfo.avatar;
    if (userInfo.role !== undefined) updatedUser.role = userInfo.role;
    if (userInfo.creditScore !== undefined) updatedUser.creditScore = userInfo.creditScore;
    if (userInfo.level !== undefined) updatedUser.level = userInfo.level;
    if (userInfo.experience !== undefined) updatedUser.experience = userInfo.experience;
    if (userInfo.medals !== undefined) updatedUser.medals = userInfo.medals;
    if (userInfo.createdAt !== undefined) updatedUser.createdAt = userInfo.createdAt;
    if (userInfo.lastLogin !== undefined) updatedUser.lastLogin = userInfo.lastLogin;

    userList[userIndex] = updatedUser;
    if (currentUser && currentUser.id === userId) {
      // 手动合并currentUser
      if (userInfo.username !== undefined) currentUser.username = userInfo.username;
      if (userInfo.password !== undefined) currentUser.password = userInfo.password;
      if (userInfo.nickname !== undefined) currentUser.nickname = userInfo.nickname;
      if (userInfo.phone !== undefined) currentUser.phone = userInfo.phone;
      if (userInfo.email !== undefined) currentUser.email = userInfo.email;
      if (userInfo.avatar !== undefined) currentUser.avatar = userInfo.avatar;
      if (userInfo.role !== undefined) currentUser.role = userInfo.role;
      if (userInfo.creditScore !== undefined) currentUser.creditScore = userInfo.creditScore;
      if (userInfo.level !== undefined) currentUser.level = userInfo.level;
      if (userInfo.experience !== undefined) currentUser.experience = userInfo.experience;
      if (userInfo.medals !== undefined) currentUser.medals = userInfo.medals;
      if (userInfo.createdAt !== undefined) currentUser.createdAt = userInfo.createdAt;
      if (userInfo.lastLogin !== undefined) currentUser.lastLogin = userInfo.lastLogin;
    }
    return true;
  }
  return false;
}

// 获取用户地址列表
export function getUserAddresses(userId: number): Address[] {
  return addressList.filter(addr => addr.userId === userId);
}

// 添加地址接口
export interface AddressInput {
  name: string;
  phone: string;
  province: string;
  city: string;
  district: string;
  detail: string;
  isDefault: boolean;
  userId?: number;
}

// 添加地址
export function addAddress(address: AddressInput): Address | null {
  if (!currentUser) return null;

  const newAddress: Address = {
    id: addressList.length + 1,
    name: address.name,
    phone: address.phone,
    province: address.province,
    city: address.city,
    district: address.district,
    detail: address.detail,
    isDefault: address.isDefault,
    userId: currentUser.id
  };

  // 如果设置为默认地址，取消其他默认地址
  if (newAddress.isDefault) {
    addressList.forEach(addr => {
      if (addr.userId === currentUser!.id && addr.isDefault) {
        addr.isDefault = false;
      }
    });
  }

  addressList.push(newAddress);
  return newAddress;
}

// 更新地址
export function updateAddress(addressId: number, addressData: Partial<Address>): boolean {
  const addressIndex = addressList.findIndex(addr => addr.id === addressId);
  if (addressIndex === -1) return false;

  // 如果设置为默认地址，取消其他默认地址
  if (addressData.isDefault === true) {
    addressList.forEach(addr => {
      if (addr.userId === addressList[addressIndex].userId && addr.isDefault) {
        addr.isDefault = false;
      }
    });
  }

  // 手动合并地址数据
  const updatedAddress = addressList[addressIndex];
  if (addressData.name !== undefined) updatedAddress.name = addressData.name;
  if (addressData.phone !== undefined) updatedAddress.phone = addressData.phone;
  if (addressData.province !== undefined) updatedAddress.province = addressData.province;
  if (addressData.city !== undefined) updatedAddress.city = addressData.city;
  if (addressData.district !== undefined) updatedAddress.district = addressData.district;
  if (addressData.detail !== undefined) updatedAddress.detail = addressData.detail;
  if (addressData.isDefault !== undefined) updatedAddress.isDefault = addressData.isDefault;
  if (addressData.userId !== undefined) updatedAddress.userId = addressData.userId;

  addressList[addressIndex] = updatedAddress;
  return true;
}

// 删除地址
export function deleteAddress(addressId: number): boolean {
  const addressIndex = addressList.findIndex(addr => addr.id === addressId);
  if (addressIndex === -1) return false;

  addressList.splice(addressIndex, 1);
  return true;
}

// 获取默认地址
export function getDefaultAddress(userId: number): Address | undefined {
  return addressList.find(addr => addr.userId === userId && addr.isDefault);
}

// 计算信用分
export function calculateCreditScore(userId: number): number {
  const user = userList.find(u => u.id === userId);
  if (!user) return 0;

  let score = 60; // 基础分

  // 根据等级加分
  score += user.level * 2;

  // 根据经验值加分
  score += Math.min(Math.floor(user.experience / 100), 20);

  // 根据勋章数量加分
  score += user.medals.length * 3;

  // 根据注册时长加分（每月加1分，最高20分）
  const createdDate = new Date(user.createdAt);
  const now = new Date();
  const monthsDiff = (now.getFullYear() - createdDate.getFullYear()) * 12 +
    (now.getMonth() - createdDate.getMonth());
  score += Math.min(Math.max(monthsDiff, 0), 20);

  // 根据最后登录时间（最近登录加分）
  const lastLoginDate = new Date(user.lastLogin);
  const daysSinceLastLogin = Math.floor((now.getTime() - lastLoginDate.getTime()) / (1000 * 60 * 60 * 24));
  if (daysSinceLastLogin <= 7) {
    score += 5;
  } else if (daysSinceLastLogin <= 30) {
    score += 2;
  }

  return Math.min(Math.max(score, 0), 100);
}

// 更新用户信用分
export function updateUserCreditScore(userId: number): boolean {
  const userIndex = userList.findIndex(u => u.id === userId);
  if (userIndex === -1) return false;

  userList[userIndex].creditScore = calculateCreditScore(userId);
  if (currentUser && currentUser.id === userId) {
    currentUser.creditScore = userList[userIndex].creditScore;
  }
  return true;
}

// 增加用户经验值
export function addUserExperience(userId: number, exp: number): boolean {
  const userIndex = userList.findIndex(u => u.id === userId);
  if (userIndex === -1) return false;

  userList[userIndex].experience += exp;

  // 检查是否升级（每100经验升级）
  const newLevel = Math.floor(userList[userIndex].experience / 100) + 1;
  if (newLevel > userList[userIndex].level) {
    userList[userIndex].level = newLevel;
    // 添加等级勋章
    if (newLevel >= 5 && !userList[userIndex].medals.includes("资深用户")) {
      userList[userIndex].medals.push("资深用户");
    }
    if (newLevel >= 10 && !userList[userIndex].medals.includes("顶级用户")) {
      userList[userIndex].medals.push("顶级用户");
    }
  }

  if (currentUser && currentUser.id === userId) {
    currentUser.experience = userList[userIndex].experience;
    currentUser.level = userList[userIndex].level;
    currentUser.medals = [...userList[userIndex].medals];
  }

  // 更新信用分
  updateUserCreditScore(userId);

  return true;
}

// 添加用户勋章
export function addUserMedal(userId: number, medal: string): boolean {
  const userIndex = userList.findIndex(u => u.id === userId);
  if (userIndex === -1) return false;

  if (!userList[userIndex].medals.includes(medal)) {
    userList[userIndex].medals.push(medal);
    if (currentUser && currentUser.id === userId) {
      currentUser.medals = [...userList[userIndex].medals];
    }
    // 更新信用分
    updateUserCreditScore(userId);
    return true;
  }
  return false;
}