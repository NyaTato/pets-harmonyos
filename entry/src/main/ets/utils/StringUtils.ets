// 字符串工具类
export class StringUtils {

  /**
   * 截断字符串
   * @param str 原始字符串
   * @param maxLength 最大长度
   * @param suffix 后缀，默认'...'
   */
  static truncate(str: string, maxLength: number, suffix: string = '...'): string {
    if (!str || str.length <= maxLength) {
      return str;
    }
    return str.substring(0, maxLength) + suffix;
  }

  /**
   * 隐藏敏感信息（如手机号、邮箱）
   * @param str 原始字符串
   * @param start 开始保留的字符串
   * @param end 结束保留的字符数
   * @param maskChar 掩码字符，默认*'
   */
  static maskSensitiveInfo(str: string, start: number = 3, end: number = 4, maskChar: string = '*'): string {
    if (!str || str.length <= start + end) {
      return str;
    }

    const visibleStart = str.substring(0, start);
    const visibleEnd = str.substring(str.length - end);
    const maskLength = str.length - start - end;
    const mask = maskChar.repeat(maskLength);

    return visibleStart + mask + visibleEnd;
  }

  /**
   * 格式化手机号（如：138****8888）
   * @param phone 手机号
   */
  static formatPhone(phone: string): string {
    if (!phone || phone.length !== 11) {
      return phone;
    }
    return phone.substring(0, 3) + '****' + phone.substring(7);
  }

  /**
   * 格式化银行卡号（如：**** **** **** 1234）
   * @param cardNumber 银行卡号
   */
  static formatBankCard(cardNumber: string): string {
    if (!cardNumber || cardNumber.length < 4) {
      return cardNumber;
    }

    const lastFour = cardNumber.substring(cardNumber.length - 4);
    const maskedPart = '*'.repeat(Math.max(0, cardNumber.length - 4));

    // 每4位加一个空格
    const formatted = (maskedPart + lastFour).replace(/(.{4})/g, '$1 ').trim();
    return formatted;
  }

  /**
   * 格式化金额（如：1,234.56）
   * @param amount 金额
   * @param decimals 小数位数，默认2
   */
  static formatAmount(amount: number | string, decimals: number = 2): string {
    const num = typeof amount === 'string' ? parseFloat(amount) : amount;

    if (isNaN(num)) {
      return '0.00';
    }

    // 保留小数位数
    const fixedNum = num.toFixed(decimals);

    // 添加千位分隔符
    const parts = fixedNum.split('.');
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');

    return parts.join('.');
  }

  /**
   * 格式化文件大小
   * @param bytes 字节数
   */
  static formatFileSize(bytes: number): string {
    if (bytes === 0) return '0 B';

    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));

    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  }

  /**
   * 移除HTML标签
   * @param html HTML字符串
   */
  static stripHtmlTags(html: string): string {
    return html.replace(/<[^>]*>/g, '');
  }

  /**
   * 转义HTML特殊字符
   * @param str 原始字符串
   */
  static escapeHtml(str: string): string {
    const escapeMap: Record<string, string> = {
      '&': '&amp;',
      '<': '&lt;',
      '>': '&gt;',
      '"': '&quot;',
      "'": '&#39;'
    };

    return str.replace(/[&<>"']/g, char => escapeMap[char] || char);
  }

  /**
   * 反转义HTML特殊字符
   * @param str 转义后的字符串
   */
  static unescapeHtml(str: string): string {
    const unescapeMap: Record<string, string> = {
      '&amp;': '&',
      '&lt;': '<',
      '&gt;': '>',
      '&quot;': '"',
      '&#39;': "'"
    };

    return str.replace(/&(amp|lt|gt|quot|#39);/g, entity => unescapeMap[entity] || entity);
  }

  /**
   * 转换为驼峰命名
   * @param str 原始字符串
   */
  static toCamelCase(str: string): string {
    return str.replace(/[-_\s]+(.)?/g, (_, c) => c ? c.toUpperCase() : '')
               .replace(/^(.)/, c => c.toLowerCase());
  }

  /**
   * 转换为帕斯卡命名
   * @param str 原始字符串
   */
  static toPascalCase(str: string): string {
    return str.replace(/[-_\s]+(.)?/g, (_, c) => c ? c.toUpperCase() : '')
               .replace(/^(.)/, c => c.toUpperCase());
  }

  /**
   * 转换为烤肉串命名
   * @param str 原始字符串
   */
  static toKebabCase(str: string): string {
    return str.replace(/([a-z])([A-Z])/g, '$1-$2')
               .replace(/[\s_]+/g, '-')
               .toLowerCase();
  }

  /**
   * 转换为蛇形命名
   * @param str 原始字符串
   */
  static toSnakeCase(str: string): string {
    return str.replace(/([a-z])([A-Z])/g, '$1_$2')
               .replace(/[\s-]+/g, '_')
               .toLowerCase();
  }

  /**
   * 生成随机字符串
   * @param length 长度
   * @param charset 字符串
   */
  static randomString(length: number = 8, charset: string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'): string {
    let result = '';
    const charsetLength = charset.length;

    for (let i = 0; i < length; i++) {
      result += charset.charAt(Math.floor(Math.random() * charsetLength));
    }

    return result;
  }

  /**
   * 生成UUID
   */
  static generateUUID(): string {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, c => {
      const r = Math.random() * 16 | 0;
      const v = c === 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }

  /**
   * 检查字符串是否为空或仅包含空格
   * @param str 字符串
   */
  static isEmpty(str: string): boolean {
    return !str || str.trim().length === 0;
  }

  /**
   * 检查字符串是否为数字
   * @param str 字符串
   */
  static isNumeric(str: string): boolean {
    return !isNaN(parseFloat(str)) && isFinite(Number(str));
  }

  /**
   * 检查字符串是否为整数
   * @param str 字符串
   */
  static isInteger(str: string): boolean {
    return /^-?\d+$/.test(str);
  }

  /**
   * 检查字符串是否为邮箱
   * @param str 字符串
   */
  static isEmail(str: string): boolean {
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    return emailRegex.test(str);
  }

  /**
   * 检查字符串是否为URL
   * @param str 字符串
   */
  static isUrl(str: string): boolean {
    try {
      new URL(str);
      return true;
    } catch {
      return false;
    }
  }

  /**
   * 提取字符串中的数字
   * @param str 字符串
   */
  static extractNumbers(str: string): string {
    return str.replace(/\D/g, '');
  }

  /**
   * 提取字符串中的字母
   * @param str 字符串
   */
  static extractLetters(str: string): string {
    return str.replace(/[^a-zA-Z]/g, '');
  }

  /**
   * 计算字符串的字节长度（中文算2个字节）
   * @param str 字符串
   */
  static getByteLength(str: string): number {
    let length = 0;
    for (let i = 0; i < str.length; i++) {
      const charCode = str.charCodeAt(i);
      if (charCode >= 0 && charCode <= 128) {
        length += 1;
      } else {
        length += 2;
      }
    }
    return length;
  }

  /**
   * 限制字符串的字节长度
   * @param str 字符串
   * @param maxBytes 最大字节数
   * @param suffix 后缀
   */
  static limitByteLength(str: string, maxBytes: number, suffix: string = '...'): string {
    let byteLength = 0;
    let result = '';

    for (let i = 0; i < str.length; i++) {
      const char = str[i];
      const charCode = str.charCodeAt(i);
      const charBytes = (charCode >= 0 && charCode <= 128) ? 1 : 2;

      if (byteLength + charBytes > maxBytes) {
        break;
      }

      result += char;
      byteLength += charBytes;
    }

    if (result.length < str.length) {
      result += suffix;
    }

    return result;
  }

  /**
   * 字符串首字母大写
   * @param str 字符串
   */
  static capitalize(str: string): string {
    if (!str) return '';
    return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
  }

  /**
   * 字符串每个单词首字母大写
   * @param str 字符串
   */
  static capitalizeWords(str: string): string {
    if (!str) return '';
    return str.split(' ')
      .map(word => this.capitalize(word))
      .join(' ');
  }
}
