// 日期工具类
export class DateUtils {

  /**
   * 格式化日期
   * @param date 日期对象或字符串
   * @param format 格式，默认'YYYY-MM-DD'
   */
  static formatDate(date: Date | string, format: string = 'YYYY-MM-DD'): string {
    const d = typeof date === 'string' ? new Date(date) : date;

    if (isNaN(d.getTime())) {
      return '';
    }

    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    const hours = String(d.getHours()).padStart(2, '0');
    const minutes = String(d.getMinutes()).padStart(2, '0');
    const seconds = String(d.getSeconds()).padStart(2, '0');

    return format
      .replace('YYYY', String(year))
      .replace('MM', month)
      .replace('DD', day)
      .replace('HH', hours)
      .replace('mm', minutes)
      .replace('ss', seconds);
  }

  /**
   * 获取相对时间描述（如：刚刚、分钟前、小时前等）
   * @param date 日期对象或字符串
   */
  static getRelativeTime(date: Date | string): string {
    const d = typeof date === 'string' ? new Date(date) : date;
    const now = new Date();
    const diffMs = now.getTime() - d.getTime();

    if (diffMs < 0) {
      return '未来';
    }

    const diffSeconds = Math.floor(diffMs / 1000);
    const diffMinutes = Math.floor(diffSeconds / 60);
    const diffHours = Math.floor(diffMinutes / 60);
    const diffDays = Math.floor(diffHours / 24);
    const diffMonths = Math.floor(diffDays / 30);
    const diffYears = Math.floor(diffDays / 365);

    if (diffSeconds < 60) {
      return '刚刚';
    } else if (diffMinutes < 60) {
      return `${diffMinutes}分钟前`;
    } else if (diffHours < 24) {
      return `${diffHours}小时前`;
    } else if (diffDays < 30) {
      return `${diffDays}天前`;
    } else if (diffMonths < 12) {
      return `${diffMonths}个月前`;
    } else {
      return `${diffYears}年前`;
    }
  }

  /**
   * 获取星期几
   * @param date 日期对象或字符串
   */
  static getWeekday(date: Date | string): string {
    const d = typeof date === 'string' ? new Date(date) : date;
    const weekdays = ['日', '一', '二', '三', '四', '五', '六'];
    return `星期${weekdays[d.getDay()]}`;
  }

  /**
   * 获取月份名称
   * @param month 月份(1-12)
   */
  static getMonthName(month: number): string {
    const months = [
      '一月', '二月', '三月', '四月', '五月', '六月',
      '七月', '八月', '九月', '十月', '十一月', '十二月'
    ];
    return months[month - 1] || '';
  }

  /**
   * 获取日期范围
   * @param startDate 开始日期
   * @param endDate 结束日期
   */
  static getDateRange(startDate: Date | string, endDate: Date | string): string {
    const start = typeof startDate === 'string' ? new Date(startDate) : startDate;
    const end = typeof endDate === 'string' ? new Date(endDate) : endDate;

    const startStr = this.formatDate(start, 'YYYY年MM月DD日');
    const endStr = this.formatDate(end, 'YYYY年MM月DD日');

    if (startStr === endStr) {
      return startStr;
    }

    return `${startStr} - ${endStr}`;
  }

  /**
   * 计算年龄
   * @param birthDate 出生日期
   */
  static calculateAge(birthDate: Date | string): number {
    const birth = typeof birthDate === 'string' ? new Date(birthDate) : birthDate;
    const today = new Date();

    let age = today.getFullYear() - birth.getFullYear();
    const monthDiff = today.getMonth() - birth.getMonth();

    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())) {
      age--;
    }

    return age;
  }

  /**
   * 计算日期差（天数）
   * @param date1 日期1
   * @param date2 日期2
   */
  static getDaysDifference(date1: Date | string, date2: Date | string): number {
    const d1 = typeof date1 === 'string' ? new Date(date1) : date1;
    const d2 = typeof date2 === 'string' ? new Date(date2) : date2;

    // 清除时间部分，只比较日期
    const utc1 = Date.UTC(d1.getFullYear(), d1.getMonth(), d1.getDate());
    const utc2 = Date.UTC(d2.getFullYear(), d2.getMonth(), d2.getDate());

    return Math.floor((utc2 - utc1) / (1000 * 60 * 60 * 24));
  }

  /**
   * 添加天数
   * @param date 日期
   * @param days 天数
   */
  static addDays(date: Date | string, days: number): Date {
    const d = typeof date === 'string' ? new Date(date) : new Date(date.getTime());
    d.setDate(d.getDate() + days);
    return d;
  }

  /**
   * 添加月份
   * @param date 日期
   * @param months 月数
   */
  static addMonths(date: Date | string, months: number): Date {
    const d = typeof date === 'string' ? new Date(date) : new Date(date.getTime());
    d.setMonth(d.getMonth() + months);
    return d;
  }

  /**
   * 添加年份
   * @param date 日期
   * @param years 年数
   */
  static addYears(date: Date | string, years: number): Date {
    const d = typeof date === 'string' ? new Date(date) : new Date(date.getTime());
    d.setFullYear(d.getFullYear() + years);
    return d;
  }

  /**
   * 获取月份的第一天
   * @param date 日期
   */
  static getFirstDayOfMonth(date: Date | string): Date {
    const d = typeof date === 'string' ? new Date(date) : new Date(date.getTime());
    return new Date(d.getFullYear(), d.getMonth(), 1);
  }

  /**
   * 获取月份的最后一天
   * @param date 日期
   */
  static getLastDayOfMonth(date: Date | string): Date {
    const d = typeof date === 'string' ? new Date(date) : new Date(date.getTime());
    return new Date(d.getFullYear(), d.getMonth() + 1, 0);
  }

  /**
   * 获取一周的开始日期（周一）
   * @param date 日期
   */
  static getStartOfWeek(date: Date | string): Date {
    const d = typeof date === 'string' ? new Date(date) : new Date(date.getTime());
    const day = d.getDay();
    const diff = day === 0 ? 6 : day - 1; // 如果是周日，返回上周一
    return this.addDays(d, -diff);
  }

  /**
   * 获取一周的结束日期（周日）
   * @param date 日期
   */
  static getEndOfWeek(date: Date | string): Date {
    const start = this.getStartOfWeek(date);
    return this.addDays(start, 6);
  }

  /**
   * 检查是否为今天
   * @param date 日期
   */
  static isToday(date: Date | string): boolean {
    const d = typeof date === 'string' ? new Date(date) : date;
    const today = new Date();

    return d.getDate() === today.getDate() &&
           d.getMonth() === today.getMonth() &&
           d.getFullYear() === today.getFullYear();
  }

  /**
   * 检查是否为昨天
   * @param date 日期
   */
  static isYesterday(date: Date | string): boolean {
    const d = typeof date === 'string' ? new Date(date) : date;
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);

    return d.getDate() === yesterday.getDate() &&
           d.getMonth() === yesterday.getMonth() &&
           d.getFullYear() === yesterday.getFullYear();
  }

  /**
   * 检查是否为明天
   * @param date 日期
   */
  static isTomorrow(date: Date | string): boolean {
    const d = typeof date === 'string' ? new Date(date) : date;
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);

    return d.getDate() === tomorrow.getDate() &&
           d.getMonth() === tomorrow.getMonth() &&
           d.getFullYear() === tomorrow.getFullYear();
  }

  /**
   * 获取时间段的友好显示
   * @param startDate 开始时间
   * @param endDate 结束时间
   */
  static getFriendlyTimeRange(startDate: Date | string, endDate: Date | string): string {
    const start = typeof startDate === 'string' ? new Date(startDate) : startDate;
    const end = typeof endDate === 'string' ? new Date(endDate) : endDate;

    if (this.isToday(start) && this.isToday(end)) {
      return `今天 ${this.formatDate(start, 'HH:mm')} - ${this.formatDate(end, 'HH:mm')}`;
    }

    if (this.isToday(start)) {
      return `今天 ${this.formatDate(start, 'HH:mm')} - ${this.formatDate(end, 'MM月DD日 HH:mm')}`;
    }

    return `${this.formatDate(start, 'MM月DD日 HH:mm')} - ${this.formatDate(end, 'MM月DD日 HH:mm')}`;
  }

  /**
   * 获取倒计时
   * @param targetDate 目标日期
   */
  static getCountdown(targetDate: Date | string): {
    days: number;
    hours: number;
    minutes: number;
    seconds: number;
    isExpired: boolean;
  } {
    const target = typeof targetDate === 'string' ? new Date(targetDate) : targetDate;
    const now = new Date();
    const diffMs = target.getTime() - now.getTime();

    if (diffMs <= 0) {
      return {
        days: 0,
        hours: 0,
        minutes: 0,
        seconds: 0,
        isExpired: true
      };
    }

    const days = Math.floor(diffMs / (1000 * 60 * 60 * 24));
    const hours = Math.floor((diffMs % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((diffMs % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((diffMs % (1000 * 60)) / 1000);

    return {
      days,
      hours,
      minutes,
      seconds,
      isExpired: false
    };
  }

  /**
   * 格式化倒计时
   * @param targetDate 目标日期
   */
  static formatCountdown(targetDate: Date | string): string {
    const countdown = this.getCountdown(targetDate);

    if (countdown.isExpired) {
      return '已过期';
    }

    if (countdown.days > 0) {
      return `${countdown.days}天 ${countdown.hours}小时`;
    } else if (countdown.hours > 0) {
      return `${countdown.hours}小时${countdown.minutes}分钟`;
    } else if (countdown.minutes > 0) {
      return `${countdown.minutes}分钟${countdown.seconds}秒`;
    } else {
      return `${countdown.seconds}秒`;
    }
  }
}
