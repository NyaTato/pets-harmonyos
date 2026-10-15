// 智能养宠日历数据
export interface CalendarEvent {
  id: number;
  petId: number;
  petName: string;
  type: 'vaccine' | 'deworm' | 'bath' | 'groom' | 'vet' | 'other'; // 疫苗、驱虫、洗澡、美容、看兽医、其他
  title: string;
  description: string;
  date: string; // YYYY-MM-DD
  time?: string; // HH:mm
  isCompleted: boolean;
  reminderDays: number; // 提前几天提醒
  repeat: 'none' | 'weekly' | 'monthly' | 'yearly'; // 重复周期
  createTime: string;
}

export interface Reminder {
  id: number;
  eventId: number;
  userId: number;
  reminderTime: string;
  isRead: boolean;
  createTime: string;
}

// 模拟日历事件数据
export const calendarEvents: CalendarEvent[] = [
  {
    id: 1,
    petId: 1,
    petName: "橘猫",
    type: "vaccine",
    title: "年度疫苗接种",
    description: "带橘猫去接种年度疫苗，包括猫三联和狂犬疫苗",
    date: "2026-05-15",
    time: "09:00",
    isCompleted: false,
    reminderDays: 7,
    repeat: "yearly",
    createTime: "2026-04-01 10:00:00"
  },
  {
    id: 2,
    petId: 1,
    petName: "橘猫",
    type: "deworm",
    title: "体内驱虫",
    description: "每月一次的体内驱虫，使用拜耳驱虫药",
    date: "2026-04-20",
    time: "08:00",
    isCompleted: false,
    reminderDays: 1,
    repeat: "monthly",
    createTime: "2026-04-01 10:05:00"
  },
  {
    id: 3,
    petId: 1,
    petName: "橘猫",
    type: "bath",
    title: "洗澡美容",
    description: "给橘猫洗澡、梳毛、剪指甲",
    date: "2026-04-25",
    time: "14:00",
    isCompleted: false,
    reminderDays: 2,
    repeat: "monthly",
    createTime: "2026-04-01 10:10:00"
  },
  {
    id: 4,
    petId: 3,
    petName: "柯基",
    type: "vet",
    title: "年度体检",
    description: "带柯基去做年度全面体检",
    date: "2026-06-10",
    time: "10:30",
    isCompleted: false,
    reminderDays: 14,
    repeat: "yearly",
    createTime: "2026-04-02 09:00:00"
  },
  {
    id: 5,
    petId: 3,
    petName: "柯基",
    type: "deworm",
    title: "体外驱虫",
    description: "每月一次的体外驱虫，使用福来恩",
    date: "2026-04-18",
    time: "08:00",
    isCompleted: false,
    reminderDays: 1,
    repeat: "monthly",
    createTime: "2026-04-02 09:05:00"
  },
  {
    id: 6,
    petId: 2,
    petName: "布偶",
    type: "groom",
    title: "美容修剪",
    description: "布偶猫长毛需要定期美容修剪",
    date: "2026-04-22",
    time: "15:00",
    isCompleted: false,
    reminderDays: 3,
    repeat: "monthly",
    createTime: "2026-04-03 11:00:00"
  },
  {
    id: 7,
    petId: 4,
    petName: "金毛",
    type: "other",
    title: "回访检查",
    description: "领养后的第一次回访检查",
    date: "2026-05-05",
    time: "11:00",
    isCompleted: false,
    reminderDays: 3,
    repeat: "none",
    createTime: "2026-04-05 14:00:00"
  },
  {
    id: 8,
    petId: 5,
    petName: "波斯猫",
    type: "bath",
    title: "洗澡护理",
    description: "波斯猫需要特别护理的长毛洗澡",
    date: "2026-04-28",
    time: "16:00",
    isCompleted: false,
    reminderDays: 2,
    repeat: "monthly",
    createTime: "2026-04-06 10:30:00"
  }
];

// 模拟提醒数据
export const reminders: Reminder[] = [
  {
    id: 1,
    eventId: 2,
    userId: 1,
    reminderTime: "2026-04-19 08:00:00",
    isRead: false,
    createTime: "2026-04-01 10:05:00"
  },
  {
    id: 2,
    eventId: 5,
    userId: 1,
    reminderTime: "2026-04-17 08:00:00",
    isRead: false,
    createTime: "2026-04-02 09:05:00"
  },
  {
    id: 3,
    eventId: 6,
    userId: 2,
    reminderTime: "2026-04-19 15:00:00",
    isRead: true,
    createTime: "2026-04-03 11:00:00"
  }
];

// 获取用户的日历事件
export function getUserCalendarEvents(userId: number): CalendarEvent[] {
  // 这里假设用户只能看到自己领养的宠物的事件
  // 在实际应用中，需要根据用户领养的宠物来过滤
  return calendarEvents;
}

// 获取宠物的事件
export function getPetCalendarEvents(petId: number): CalendarEvent[] {
  return calendarEvents.filter(event => event.petId === petId);
}

// 获取今日事件
export function getTodayEvents(): CalendarEvent[] {
  const today = new Date().toISOString().split('T')[0];
  return calendarEvents.filter(event => event.date === today && !event.isCompleted);
}

// 获取即将到期的事件（未来7天内）
export function getUpcomingEvents(days: number = 7): CalendarEvent[] {
  const today = new Date();
  const futureDate = new Date();
  futureDate.setDate(today.getDate() + days);

  const todayStr = today.toISOString().split('T')[0];
  const futureStr = futureDate.toISOString().split('T')[0];

  return calendarEvents.filter(event => {
    const eventDate = new Date(event.date);
    return eventDate >= today && eventDate <= new Date(futureStr) && !event.isCompleted;
  });
}

// 添加日历事件
export function addCalendarEvent(eventData: CalendarEvent): CalendarEvent {
  const newEvent: CalendarEvent = {
    id: calendarEvents.length + 1,
    petId: eventData.petId,
    petName: eventData.petName,
    type: eventData.type,
    title: eventData.title,
    description: eventData.description,
    date: eventData.date,
    time: eventData.time,
    isCompleted: eventData.isCompleted,
    reminderDays: eventData.reminderDays,
    repeat: eventData.repeat,
    createTime: new Date().toLocaleString('zh-CN')
  };

  calendarEvents.push(newEvent);

  // 如果需要，创建提醒
  if (eventData.reminderDays > 0) {
    const reminderDate = new Date(eventData.date);
    reminderDate.setDate(reminderDate.getDate() - eventData.reminderDays);

    const newReminder: Reminder = {
      id: reminders.length + 1,
      eventId: newEvent.id,
      userId: 1, // 这里需要根据实际情况设置用户ID
      reminderTime: reminderDate.toISOString().split('T')[0] + ' 08:00:00',
      isRead: false,
      createTime: new Date().toLocaleString('zh-CN')
    };

    reminders.push(newReminder);
  }

  return newEvent;
}

// 更新事件状态
export function updateCalendarEventStatus(eventId: number, isCompleted: boolean): boolean {
  const eventIndex = calendarEvents.findIndex(event => event.id === eventId);
  if (eventIndex === -1) return false;

  calendarEvents[eventIndex].isCompleted = isCompleted;
  return true;
}

// 删除日历事件
export function deleteCalendarEvent(eventId: number): boolean {
  const eventIndex = calendarEvents.findIndex(event => event.id === eventId);
  if (eventIndex === -1) return false;

  // 同时删除相关的提醒
  const reminderIndices = reminders
    .map((reminder, index) => reminder.eventId === eventId ? index : -1)
    .filter(index => index !== -1);

  // 从后往前删除，避免索引变化
  reminderIndices.reverse().forEach(index => {
    reminders.splice(index, 1);
  });

  calendarEvents.splice(eventIndex, 1);
  return true;
}

// 获取未读提醒
export function getUnreadReminders(userId: number): Reminder[] {
  const now = new Date().toLocaleString('zh-CN');
  return reminders.filter(reminder =>
  reminder.userId === userId &&
    !reminder.isRead &&
    reminder.reminderTime <= now
  );
}

// 标记提醒为已读
export function markReminderAsRead(reminderId: number): boolean {
  const reminderIndex = reminders.findIndex(reminder => reminder.id === reminderId);
  if (reminderIndex === -1) return false;

  reminders[reminderIndex].isRead = true;
  return true;
}

// 生成重复事件
export function generateRecurringEvents(event: CalendarEvent, count: number = 12): CalendarEvent[] {
  const newEvents: CalendarEvent[] = [];
  const baseDate = new Date(event.date);

  for (let i = 1; i <= count; i++) {
    const newDate = new Date(baseDate);

    switch (event.repeat) {
      case 'weekly':
        newDate.setDate(newDate.getDate() + (7 * i));
        break;
      case 'monthly':
        newDate.setMonth(newDate.getMonth() + i);
        break;
      case 'yearly':
        newDate.setFullYear(newDate.getFullYear() + i);
        break;
      default:
        continue;
    }

    const newEvent: CalendarEvent = {
      id: calendarEvents.length + newEvents.length + 1,
      petId: event.petId,
      petName: event.petName,
      type: event.type,
      title: event.title,
      description: event.description,
      date: newDate.toISOString().split('T')[0],
      time: event.time,
      isCompleted: false,
      reminderDays: event.reminderDays,
      repeat: event.repeat,
      createTime: new Date().toLocaleString('zh-CN')
    };

    newEvents.push(newEvent);
  }

  return newEvents;
}

// 获取事件类型统计
export function getEventTypeStats(): Record<string, number> {
  const stats: Record<string, number> = {
    vaccine: 0,
    deworm: 0,
    bath: 0,
    groom: 0,
    vet: 0,
    other: 0
  };

  calendarEvents.forEach(event => {
    stats[event.type]++;
  });

  return stats;
}

// 获取月度事件统计
export function getMonthlyEventStats(year: number, month: number): Record<string, number> {
  const monthStr = month.toString().padStart(2, '0');
  const prefix = `${year}-${monthStr}`;

  const stats: Record<string, number> = {};

  calendarEvents.forEach(event => {
    if (event.date.startsWith(prefix)) {
      const day = event.date.split('-')[2];
      stats[day] = (stats[day] || 0) + 1;
    }
  });

  return stats;
}

// 获取事件类型的中文名称
export function getEventTypeName(type: string): string {
  const typeNames: Record<string, string> = {
    'vaccine': '疫苗接种',
    'deworm': '驱虫',
    'bath': '洗澡',
    'groom': '美容',
    'vet': '看兽医',
    'other': '其他'
  };
  return typeNames[type] || type;
}

// 获取事件类型的图标
export function getEventTypeIcon(type: string): string {
  const typeIcons: Record<string, string> = {
    'vaccine': '💉',
    'deworm': '🐛',
    'bath': '🛁',
    'groom': '✂️',
    'vet': '🏥',
    'other': '📅'
  };
  return typeIcons[type] || '📅';
}

// 获取事件类型的颜色
export function getEventTypeColor(type: CalendarEvent['type']): string {
  const typeColors: Record<string, string> = {
    'vaccine': '#FF6B6B', // 红色
    'deworm': '#34C759',  // 绿色
    'bath': '#5AC8FA',    // 蓝色
    'groom': '#AF52DE',   // 紫色
    'vet': '#FF9500',     // 橙色
    'other': '#8E8E93'    // 灰色
  };
  return typeColors[type] || '#8E8E93';
}