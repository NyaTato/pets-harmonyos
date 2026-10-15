// 验证工具类
// 密码验证结果接口
interface PasswordValidationResult {
  isValid: boolean;
  strength: 'weak' | 'medium' | 'strong';
  message: string;
}

// 用户名验证结果接口
interface UsernameValidationResult {
  isValid: boolean;
  message: string;
}

// 邮箱验证结果接口
interface EmailValidationResult {
  isValid: boolean;
  message: string;
}

// 手机号验证结果接口
interface PhoneValidationResult {
  isValid: boolean;
  message: string;
}

// 验证码验证结果接口
interface CodeValidationResult {
  isValid: boolean;
  message: string;
}

// 金额验证结果接口
interface AmountValidationResult {
  isValid: boolean;
  message: string;
  value: number;
}

// 文件大小验证结果接口
interface FileSizeValidationResult {
  isValid: boolean;
  message: string;
}

// 文件类型验证结果接口
interface FileTypeValidationResult {
  isValid: boolean;
  message: string;
}

// 必填验证结果接口
interface RequiredValidationResult {
  isValid: boolean;
  message: string;
}

// 长度验证结果接口
interface LengthValidationResult {
  isValid: boolean;
  message: string;
}

// 批量验证结果接口
interface BatchValidationResult {
  isValid: boolean;
  messages: string[];
}

// 验证项接口
interface ValidationItem {
  isValid: boolean;
  message: string;
}

export class ValidationUtils {

  /**
   * 验证手机号格式
   * @param phone 手机号
   */
  static isValidPhone(phone: string): boolean {
    const phoneRegex = /^1[3-9]\d{9}$/;
    return phoneRegex.test(phone);
  }

  /**
   * 验证邮箱格式
   * @param email 邮箱
   */
  static isValidEmail(email: string): boolean {
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    return emailRegex.test(email);
  }

  /**
   * 验证密码强度
   * @param password 密码
   * @param minLength 最小长度，默认8
   */
  static isValidPassword(password: string, minLength: number = 8): PasswordValidationResult {
    if (password.length < minLength) {
      return {
        isValid: false,
        strength: 'weak',
        message: `密码长度至少${minLength}位`
      };
    }

    // 检查密码复杂度
    let score = 0;

    // 包含小写字母
    if (/[a-z]/.test(password)) score++;

    // 包含大写字母
    if (/[A-Z]/.test(password)) score++;

    // 包含数字
    if (/[0-9]/.test(password)) score++;

    // 包含特殊字符
    if (/[^a-zA-Z0-9]/.test(password)) score++;

    let strength: 'weak' | 'medium' | 'strong' = 'weak';
    let message = '';

    if (score >= 4) {
      strength = 'strong';
      message = '密码强度：强';
    } else if (score >= 3) {
      strength = 'medium';
      message = '密码强度：中';
    } else {
      strength = 'weak';
      message = '密码强度：弱，建议包含大小写字母、数字和特殊字符';
    }

    return {
      isValid: true,
      strength,
      message
    };
  }

  /**
   * 验证用户名
   * @param username 用户名
   * @param minLength 最小长度，默认2
   * @param maxLength 最大长度，默认20
   */
  static isValidUsername(username: string, minLength: number = 2, maxLength: number = 20): UsernameValidationResult {
    if (username.length < minLength) {
      return {
        isValid: false,
        message: `用户名长度至少为${minLength}位`
      };
    }

    if (username.length > maxLength) {
      return {
        isValid: false,
        message: `用户名长度不能超过${maxLength}位`
      };
    }

    // 只能包含中文、英文、数字和下划线
    const usernameRegex = /^[\u4e00-\u9fa5a-zA-Z0-9_]+$/;
    if (!usernameRegex.test(username)) {
      return {
        isValid: false,
        message: '用户名只能包含中文、英文、数字和下划线'
      };
    }

    return {
      isValid: true,
      message: '用户名格式正确'
    };
  }

  /**
   * 验证身份证号（简单验证）
   * @param idCard 身份证号
   */
  static isValidIdCard(idCard: string): boolean {
    // 简单的身份证验证，实际项目中需要更复杂的验证
    const idCardRegex = /^[1-9]\d{5}(19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/;
    return idCardRegex.test(idCard);
  }

  /**
   * 验证日期格式（YYYY-MM-DD）
   * @param date 日期字符串
   */
  static isValidDate(date: string): boolean {
    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (!dateRegex.test(date)) {
      return false;
    }

    const parts = date.split('-').map(Number);
    const year = parts[0];
    const month = parts[1];
    const day = parts[2];
    const dateObj = new Date(year, month - 1, day);

    return dateObj.getFullYear() === year &&
           dateObj.getMonth() === month - 1 &&
           dateObj.getDate() === day;
  }

  /**
   * 验证年龄范围
   * @param age 年龄
   * @param min 最小年龄，默认0
   * @param max 最大年龄，默认150
   */
  static isValidAge(age: number, min: number = 0, max: number = 150): boolean {
    return age >= min && age <= max;
  }

  /**
   * 验证金额格式
   * @param amount 金额字符串
   * @param min 最小金额，默认0
   * @param max 最大金额，默认1000000
   */
  static isValidAmount(amount: string, min: number = 0, max: number = 1000000): AmountValidationResult {
    // 验证是否为数字
    const num = parseFloat(amount);
    if (isNaN(num)) {
      return {
        isValid: false,
        message: '请输入有效的金额',
        value: 0
      };
    }

    // 验证小数位数（最多2位）
    const decimalPart = amount.split('.')[1];
    if (decimalPart && decimalPart.length > 2) {
      return {
        isValid: false,
        message: '金额最多支持两位小数',
        value: num
      };
    }

    // 验证范围
    if (num < min) {
      return {
        isValid: false,
        message: `金额不能小于${min}`,
        value: num
      };
    }

    if (num > max) {
      return {
        isValid: false,
        message: `金额不能大于${max}`,
        value: num
      };
    }

    return {
      isValid: true,
      message: '金额格式正确',
      value: num
    };
  }

  /**
   * 验证URL格式
   * @param url URL字符串
   */
  static isValidUrl(url: string): boolean {
    try {
      // 使用正则表达式验证URL格式
      const urlPattern = new RegExp(
        '^(https?:\\/\\/)?' + // 协议
        '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|' + // 域名
        '((\\d{1,3}\\.){3}\\d{1,3}))' + // 或IP地址
        '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*' + // 端口和路径
        '(\\?[;&a-z\\d%_.~+=-]*)?' + // 查询字符串
        '(\\#[-a-z\\d_]*)?$', 'i' // 片段标识符
      );
      return urlPattern.test(url);
    } catch {
      return false;
    }
  }

  /**
   * 验证文件大小
   * @param size 文件大小（字节）
   * @param maxSize 最大大小（字节），默认10MB
   */
  static isValidFileSize(size: number, maxSize: number = 10 * 1024 * 1024): boolean {
    return size <= maxSize;
  }

  /**
   * 验证文件类型
   * @param fileName 文件名
   * @param allowedTypes 允许的类型数组，如['image/jpeg', 'image/png']
   */
  static isValidFileType(fileName: string, allowedTypes: string[]): boolean {
    const extension = fileName.toLowerCase().split('.').pop();
    if (!extension) return false;

    const typeMap: Record<string, string[]> = {
      'jpg': ['image/jpeg'],
      'jpeg': ['image/jpeg'],
      'png': ['image/png'],
      'gif': ['image/gif'],
      'pdf': ['application/pdf'],
      'doc': ['application/msword'],
      'docx': ['application/vnd.openxmlformats-officedocument.wordprocessingml.document'],
      'xls': ['application/vnd.ms-excel'],
      'xlsx': ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
    };

    const allowedExtensions = Object.keys(typeMap).filter(ext =>
      typeMap[ext].some(type => allowedTypes.includes(type))
    );

    return allowedExtensions.includes(extension);
  }

  /**
   * 验证必填字段
   * @param value 字段值
   * @param fieldName 字段名称
   */
  static validateRequired(value: string, fieldName: string): RequiredValidationResult {
    if (!value || value.trim() === '') {
      return {
        isValid: false,
        message: `${fieldName}不能为空`
      };
    }

    return {
      isValid: true,
      message: ''
    };
  }

  /**
   * 验证长度范围
   * @param value 字段值
   * @param fieldName 字段名称
   * @param min 最小长度
   * @param max 最大长度
   */
  static validateLength(value: string, fieldName: string, min: number, max: number): LengthValidationResult {
    if (value.length < min) {
      return {
        isValid: false,
        message: `${fieldName}长度不能少于${min}个字符`
      };
    }

    if (value.length > max) {
      return {
        isValid: false,
        message: `${fieldName}长度不能超过${max}个字符`
      };
    }

    return {
      isValid: true,
      message: ''
    };
  }

  /**
   * 批量验证字段
   * @param validations 验证结果数组
   */
  static batchValidate(validations: Array<ValidationItem>): BatchValidationResult {
    const invalidResults = validations.filter(v => !v.isValid);
    const messages = invalidResults.map(v => v.message);

    return {
      isValid: invalidResults.length === 0,
      messages
    };
  }
}
