/**
 * 图片处理工具类
 * 提供图片加载、缓存、压缩等功能
 */

import { CommonStyles } from '../common/css/CommonStyles';

// 图片缓存接口
interface ImageCache {
  [key: string]: {
    data: string; // Base64 或 URL
    timestamp: number;
    size: number;
  };
}

export class ImageUtils {
  // 图片缓存
  private static cache: ImageCache = {};

  // 最大缓存大小（5MB）
  private static readonly MAX_CACHE_SIZE = 5 * 1024 * 1024;

  // 当前缓存大小
  private static currentCacheSize = 0;

  /**
   * 加载图片
   * @param url 图片URL
   * @param useCache 是否使用缓存
   */
  static async loadImage(url: string, useCache: boolean = true): Promise<string> {
    // 检查缓存
    if (useCache && this.cache[url]) {
      const cached = this.cache[url];
      // 检查缓存是否过期（24小时）
      if (Date.now() - cached.timestamp < 24 * 60 * 60 * 1000) {
        return cached.data;
      } else {
        // 缓存过期，删除
        this.removeFromCache(url);
      }
    }

    try {
      // 模拟图片加载
      await new Promise(resolve => setTimeout(resolve, 300));

      // 这里实际项目中会使用网络请求加载图片
      // 现在返回模拟的Base64数据或URL
      const imageData = url || 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';

      // 添加到缓存
      if (useCache) {
        this.addToCache(url, imageData);
      }

      return imageData;
    } catch (error) {
      console.error('加载图片失败:', error);
      return 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';
    }
  }

  /**
   * 批量加载图片
   * @param urls 图片URL数组
   * @param useCache 是否使用缓存
   */
  static async loadImages(urls: string[], useCache: boolean = true): Promise<string[]> {
    const promises = urls.map(url => this.loadImage(url, useCache));
    return Promise.all(promises);
  }

  /**
   * 添加到缓存
   */
  private static addToCache(url: string, data: string): void {
    const size = this.estimateSize(data);

    // 检查缓存是否已满
    if (this.currentCacheSize + size > this.MAX_CACHE_SIZE) {
      this.clearOldestCache();
    }

    this.cache[url] = {
      data,
      timestamp: Date.now(),
      size
    };

    this.currentCacheSize += size;
  }

  /**
   * 从缓存中移除
   */
  private static removeFromCache(url: string): void {
    const cached = this.cache[url];
    if (cached) {
      this.currentCacheSize -= cached.size;
      delete this.cache[url];
    }
  }

  /**
   * 清除最旧的缓存
   */
  private static clearOldestCache(): void {
    let oldestKey: string | null = null;
    let oldestTime = Date.now();

    for (const [key, value] of Object.entries(this.cache)) {
      if (value.timestamp < oldestTime) {
        oldestTime = value.timestamp;
        oldestKey = key;
      }
    }

    if (oldestKey) {
      this.removeFromCache(oldestKey);
    }
  }

  /**
   * 估算数据大小
   */
  private static estimateSize(data: string): number {
    // 简单估算：Base64字符串长度 * 0.75
    if (data.startsWith('data:image')) {
      return Math.floor(data.length * 0.75);
    }
    // URL 大小估算
    return data.length;
  }

  /**
   * 清除所有缓存
   */
  static clearCache(): void {
    this.cache = {};
    this.currentCacheSize = 0;
  }

  /**
   * 获取缓存信息
   */
  static getCacheInfo(): { count: number, size: number } {
    return {
      count: Object.keys(this.cache).length,
      size: this.currentCacheSize
    };
  }

  /**
   * 生成占位图片
   * @param width 宽度
   * @param height 高度
   * @param text 文字
   * @param bgColor 背景颜色
   * @param textColor 文字颜色
   */
  static generatePlaceholder(
    width: number,
    height: number,
    text: string = '图片',
    bgColor: string = CommonStyles.GRAY_100,
    textColor: string = CommonStyles.TEXT_SECONDARY
  ): string {
    // 这里实际项目中可以使用Canvas生成占位图
    // 现在返回一个简单的SVG
    return `data:image/svg+xml;base64,${btoa(`
      <svg width="${width}" height="${height}" xmlns="http://www.w3.org/2000/svg">
        <rect width="100%" height="100%" fill="${bgColor}"/>
        <text
          x="50%"
          y="50%"
          text-anchor="middle"
          dy=".3em"
          fill="${textColor}"
          font-family="Arial, sans-serif"
          font-size="${Math.min(width, height) / 5}"
        >${text}</text>
      </svg>
    `)}`;
  }

  /**
   * 压缩图片（模拟）
   * @param imageData 图片数据
   * @param quality 质量 0-1
   * @param maxWidth 最大宽度
   * @param maxHeight 最大高度
   */
  static async compressImage(
    imageData: string,
    quality: number = 0.8,
    maxWidth: number = 800,
    maxHeight: number = 800
  ): Promise<string> {
    // 这里实际项目中可以使用Canvas进行图片压缩
    // 现在返回原数据
    return imageData;
  }

  /**
   * 获取图片尺寸
   * @param url 图片URL
   */
  static async getImageSize(url: string): Promise<{ width: number, height: number }> {
    try {
      // 模拟获取图片尺寸
      await new Promise(resolve => setTimeout(resolve, 100));

      // 返回默认尺寸
      return { width: 800, height: 600 };
    } catch (error) {
      console.error('获取图片尺寸失败:', error);
      return { width: 0, height: 0 };
    }
  }

  /**
   * 预加载图片
   * @param urls 图片URL数组
   */
  static async preloadImages(urls: string[]): Promise<void> {
    const promises = urls.map(url => {
      return new Promise<void>((resolve) => {
        // 创建图片对象预加载
        const img = new Image();
        img.onload = () => resolve();
        img.onerror = () => resolve();
        img.src = url;
      });
    });

    await Promise.all(promises);
  }

  /**
   * 懒加载图片
   * @param element 图片元素
   * @param src 图片URL
   * @param placeholder 占位图
   */
  static lazyLoadImage(element: Image, src: string, placeholder?: string): void {
    // 这里实际项目中可以实现图片懒加载
    // 现在直接设置图片
    if (element && element.src) {
      element.src = src;
    }
  }

  /**
   * 生成图片URL（处理相对路径）
   * @param path 图片路径
   */
  static getImageUrl(path: string): string {
    if (path.startsWith('http://') || path.startsWith('https://') || path.startsWith('data:')) {
      return path;
    }

    // 处理相对路径
    if (path.startsWith('./') || path.startsWith('../')) {
      // 这里可以添加基础URL
      return `https://example.com${path}`;
    }

    // 默认返回原路径
    return path;
  }

  /**
   * 检查图片是否有效
   * @param url 图片URL
   */
  static async isValidImage(url: string): Promise<boolean> {
    try {
      // 模拟检查
      await new Promise(resolve => setTimeout(resolve, 50));

      // 简单检查URL格式
      if (!url || url.trim() === '') {
        return false;
      }

      // 检查常见图片格式
      const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.svg'];
      const hasValidExtension = imageExtensions.some(ext =>
        url.toLowerCase().endsWith(ext) ||
        url.toLowerCase().includes(`.${ext}?`)
      );

      if (!hasValidExtension && !url.startsWith('data:image')) {
        return false;
      }

      return true;
    } catch (error) {
      console.error('检查图片有效性失败', error);
      return false;
    }
  }

  /**
   * 获取图片格式
   * @param url 图片URL
   */
  static getImageFormat(url: string): string {
    if (url.startsWith('data:image')) {
      const match = url.match(/data:image\/([^;]+)/);
      return match ? match[1] : 'unknown';
    }

    const extension = url.split('.').pop()?.toLowerCase() || '';
    const formatMap: Record<string, string> = {
      'jpg': 'jpeg',
      'jpeg': 'jpeg',
      'png': 'png',
      'gif': 'gif',
      'webp': 'webp',
      'svg': 'svg+xml'
    };

    return formatMap[extension] || 'unknown';
  }

  /**
   * 计算图片文件大小（模拟）
   * @param url 图片URL
   */
  static async getFileSize(url: string): Promise<number> {
    try {
      // 模拟获取文件大小
      await new Promise(resolve => setTimeout(resolve, 50));

      // 根据URL长度估算大小
      if (url.startsWith('data:')) {
        // Base64数据
        return Math.floor(url.length * 0.75);
      } else {
        // 根据URL路径估算
        if (url.includes('large')) return 1024 * 1024; // 1MB
        if (url.includes('medium')) return 512 * 1024; // 512KB
        if (url.includes('small')) return 256 * 1024; // 256KB
        return 100 * 1024; // 默认100KB
      }
    } catch (error) {
      console.error('获取图片大小失败:', error);
      return 0;
    }
  }
}
