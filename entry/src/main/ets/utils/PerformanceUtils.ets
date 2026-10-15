/**
 * 性能优化工具
 * 提供性能监控、优化建议和性能分析功能
 */

// 性能指标接口
interface PerformanceMetrics {
  fps: number; // 帧率
  memoryUsage: number; // 内存使用（MB）
  renderTime: number; // 渲染时间（ms）
  loadTime: number; // 加载时间（ms）
  interactionDelay: number; // 交互延迟（ms）
}

// 性能监控配置
interface PerformanceConfig {
  enabled: boolean;
  sampleInterval: number; // 采样间隔（ms）
  maxSamples: number; // 最大样本数
  warningThresholds: {
    fps: number; // FPS警告阈值
    memory: number; // 内存警告阈值（MB）
    renderTime: number; // 渲染时间警告阈值（ms）
  };
}

export class PerformanceUtils {
  // 性能监控配置
  private static config: PerformanceConfig = {
    enabled: true,
    sampleInterval: 1000, // 1秒采样一次
    maxSamples: 60, // 保留60个样本（1分钟数据）
    warningThresholds: {
      fps: 30, // 低于30FPS警告
      memory: 100, // 超过100MB警告
      renderTime: 16 // 超过16ms警告（60FPS对应每帧16.67ms）
    }
  };

  // 性能数据存储
  private static metrics: PerformanceMetrics[] = [];
  private static monitoringInterval: number | null = null;
  private static listeners: Array<(metrics: PerformanceMetrics) => void> = [];

  /**
   * 开始性能监控
   */
  static startMonitoring(): void {
    if (!this.config.enabled || this.monitoringInterval !== null) {
      return;
    }

    this.monitoringInterval = setInterval(() => {
      const metrics = this.collectMetrics();
      this.metrics.push(metrics);

      // 保持最大样本数
      if (this.metrics.length > this.config.maxSamples) {
        this.metrics.shift();
      }

      // 通知监听者
      this.notifyListeners(metrics);

      // 检查性能警告
      this.checkPerformanceWarnings(metrics);

    }, this.config.sampleInterval) as unknown as number;
  }

  /**
   * 停止性能监控
   */
  static stopMonitoring(): void {
    if (this.monitoringInterval !== null) {
      clearInterval(this.monitoringInterval);
      this.monitoringInterval = null;
    }
  }

  /**
   * 收集性能指标
   */
  private static collectMetrics(): PerformanceMetrics {
    // 这里实际项目中可以使用Performance API
    // 现在返回模拟数据
    return {
      fps: this.calculateFPS(),
      memoryUsage: this.getMemoryUsage(),
      renderTime: this.getRenderTime(),
      loadTime: this.getLoadTime(),
      interactionDelay: this.getInteractionDelay()
    };
  }

  /**
   * 计算FPS（模拟）
   */
  private static calculateFPS(): number {
    // 模拟FPS计算
    const baseFPS = 60;
    const variation = Math.random() * 10 - 5; // -5到5的随机变化
    return Math.max(30, Math.min(120, baseFPS + variation));
  }

  /**
   * 获取内存使用（模拟）
   */
  private static getMemoryUsage(): number {
    // 模拟内存使用（MB）
    const baseMemory = 50;
    const variation = Math.random() * 20; // 0到20MB的随机变化
    return Math.round((baseMemory + variation) * 10) / 10;
  }

  /**
   * 获取渲染时间（模拟）
   */
  private static getRenderTime(): number {
    // 模拟渲染时间（ms）
    const baseTime = 8;
    const variation = Math.random() * 10; // 0到10ms的随机变化
    return Math.round((baseTime + variation) * 10) / 10;
  }

  /**
   * 获取加载时间（模拟）
   */
  private static getLoadTime(): number {
    // 模拟加载时间（ms）
    return Math.round(Math.random() * 1000); // 0-1000ms随机
  }

  /**
   * 获取交互延迟（模拟）
   */
  private static getInteractionDelay(): number {
    // 模拟交互延迟（ms）
    return Math.round(Math.random() * 100); // 0-100ms随机
  }

  /**
   * 检查性能警告
   */
  private static checkPerformanceWarnings(metrics: PerformanceMetrics): void {
    const warnings: string[] = [];

    if (metrics.fps < this.config.warningThresholds.fps) {
      warnings.push(`低帧率警告 ${metrics.fps.toFixed(1)} FPS`);
    }

    if (metrics.memoryUsage > this.config.warningThresholds.memory) {
      warnings.push(`高内存使用 ${metrics.memoryUsage.toFixed(1)} MB`);
    }

    if (metrics.renderTime > this.config.warningThresholds.renderTime) {
      warnings.push(`长渲染时间 ${metrics.renderTime.toFixed(1)} ms`);
    }

    if (warnings.length > 0) {
      console.warn('性能警告:', warnings.join(', '));
    }
  }

  /**
   * 注册性能监听者
   */
  static addListener(listener: (metrics: PerformanceMetrics) => void): () => void {
    this.listeners.push(listener);
    return () => {
      const index = this.listeners.indexOf(listener);
      if (index > -1) {
        this.listeners.splice(index, 1);
      }
    };
  }

  /**
   * 通知监听者
   */
  private static notifyListeners(metrics: PerformanceMetrics): void {
    this.listeners.forEach(listener => listener(metrics));
  }

  /**
   * 获取性能报告
   */
  static getPerformanceReport(): {
    current: PerformanceMetrics;
    average: PerformanceMetrics;
    warnings: string[];
    suggestions: string[];
  } {
    if (this.metrics.length === 0) {
      const emptyMetrics: PerformanceMetrics = {
        fps: 0,
        memoryUsage: 0,
        renderTime: 0,
        loadTime: 0,
        interactionDelay: 0
      };

      return {
        current: emptyMetrics,
        average: emptyMetrics,
        warnings: [],
        suggestions: []
      };
    }

    const current = this.metrics[this.metrics.length - 1];

    // 计算平均值
    const average: PerformanceMetrics = {
      fps: this.metrics.reduce((sum, m) => sum + m.fps, 0) / this.metrics.length,
      memoryUsage: this.metrics.reduce((sum, m) => sum + m.memoryUsage, 0) / this.metrics.length,
      renderTime: this.metrics.reduce((sum, m) => sum + m.renderTime, 0) / this.metrics.length,
      loadTime: this.metrics.reduce((sum, m) => sum + m.loadTime, 0) / this.metrics.length,
      interactionDelay: this.metrics.reduce((sum, m) => sum + m.interactionDelay, 0) / this.metrics.length
    };

    // 生成警告
    const warnings: string[] = [];
    if (average.fps < this.config.warningThresholds.fps) {
      warnings.push(`平均帧率较低: ${average.fps.toFixed(1)} FPS`);
    }
    if (average.memoryUsage > this.config.warningThresholds.memory) {
      warnings.push(`平均内存使用较高: ${average.memoryUsage.toFixed(1)} MB`);
    }
    if (average.renderTime > this.config.warningThresholds.renderTime) {
      warnings.push(`平均渲染时间较长: ${average.renderTime.toFixed(1)} ms`);
    }

    // 生成优化建议
    const suggestions = this.generateOptimizationSuggestions(average);

    return {
      current,
      average,
      warnings,
      suggestions
    };
  }

  /**
   * 生成优化建议
   */
  private static generateOptimizationSuggestions(metrics: PerformanceMetrics): string[] {
    const suggestions: string[] = [];

    if (metrics.fps < 45) {
      suggestions.push('优化建议: 减少页面中的复杂动画和特效');
      suggestions.push('优化建议: 使用图片懒加载和缓存');
      suggestions.push('优化建议: 避免在渲染循环中进行复杂计算');
    }

    if (metrics.memoryUsage > 80) {
      suggestions.push('优化建议: 及时释放不再使用的资源');
      suggestions.push('优化建议: 使用对象池管理频繁创建的对象');
      suggestions.push('优化建议: 压缩图片资源大小');
    }

    if (metrics.renderTime > 12) {
      suggestions.push('优化建议: 减少组件嵌套层级');
      suggestions.push('优化建议: 使用Flex布局代替复杂定位');
      suggestions.push('优化建议: 避免频繁的组件重渲染');
    }

    if (metrics.interactionDelay > 50) {
      suggestions.push('优化建议: 减少事件处理函数的复杂度');
      suggestions.push('优化建议: 使用防抖和节流优化频繁触发的事件');
      suggestions.push('优化建议: 避免在UI线程进行大量计算');
    }

    // 通用建议
    suggestions.push('通用建议: 使用LazyForEach优化长列表渲染');
    suggestions.push('通用建议: 合理使用@State和@Prop减少不必要的重渲染');
    suggestions.push('通用建议: 使用缓存机制减少重复计算');

    return suggestions;
  }

  /**
   * 性能分析：测量函数执行时间
   */
  static measureExecution<T>(name: string, fn: () => T): T {
    const startTime = performance.now();
    const result = fn();
    const endTime = performance.now();
    const duration = endTime - startTime;

    if (duration > 100) {
      console.warn(`[性能警告] ${name} 执行时间过长: ${duration.toFixed(2)}ms`);
    }

    return result;
  }

  /**
   * 性能分析：异步函数执行时间
   */
  static async measureAsyncExecution<T>(name: string, fn: () => Promise<T>): Promise<T> {
    const startTime = performance.now();
    const result = await fn();
    const endTime = performance.now();
    const duration = endTime - startTime;

    if (duration > 500) {
      console.warn(`[性能警告] ${name} 执行时间过长: ${duration.toFixed(2)}ms`);
    }

    return result;
  }

  /**
   * 内存使用分析
   */
  static analyzeMemoryUsage(): {
    total: number;
    used: number;
    free: number;
    percentage: number;
  } {
    // 模拟内存分析
    const total = 256; // 假设总内存56MB
    const used = this.getMemoryUsage();
    const free = total - used;
    const percentage = (used / total) * 100;

    return {
      total,
      used,
      free,
      percentage
    };
  }

  /**
   * 渲染性能分析
   */
  static analyzeRenderPerformance(): {
    frameCount: number;
    averageFPS: number;
    minFPS: number;
    maxFPS: number;
    jankFrames: number; // 卡顿帧数（渲染时间超过6.67ms）
  } {
    if (this.metrics.length === 0) {
      return {
        frameCount: 0,
        averageFPS: 0,
        minFPS: 0,
        maxFPS: 0,
        jankFrames: 0
      };
    }

    const fpsValues = this.metrics.map(m => m.fps);
    const renderTimes = this.metrics.map(m => m.renderTime);

    return {
      frameCount: this.metrics.length,
      averageFPS: fpsValues.reduce((sum, fps) => sum + fps, 0) / fpsValues.length,
      minFPS: Math.min(...fpsValues),
      maxFPS: Math.max(...fpsValues),
      jankFrames: renderTimes.filter(time => time > 16.67).length
    };
  }

  /**
   * 获取性能优化建议
   */
  static getOptimizationSuggestions(): Array<{
    priority: 'high' | 'medium' | 'low';
    description: string;
    action: string;
  }> {
    const report = this.getPerformanceReport();
    const suggestions: Array<{
      priority: 'high' | 'medium' | 'low';
      description: string;
      action: string;
    }> = [];

    // 根据性能数据生成建议
    if (report.average.fps < 30) {
      suggestions.push({
        priority: 'high',
        description: '帧率过低，影响用户体验',
        action: '优化动画和渲染性能'
      });
    }

    if (report.average.memoryUsage > 100) {
      suggestions.push({
        priority: 'high',
        description: '内存使用过高，可能导致应用崩溃',
        action: '优化内存管理，及时释放资源',
      });
    }

    if (report.average.renderTime > 20) {
      suggestions.push({
        priority: 'medium',
        description: '渲染时间过长，影响交互响应',
        action: '优化UI组件结构和布局'
      });
    }

    if (report.average.interactionDelay > 100) {
      suggestions.push({
        priority: 'medium',
        description: '交互延迟较高，影响操作流畅度',
        action: '优化事件处理逻辑，减少阻塞操作',
      });
    }

    // 通用建议
    suggestions.push({
      priority: 'low',
      description: '定期清理缓存数据',
      action: '实现自动缓存清理机制'
    });

    suggestions.push({
      priority: 'low',
      description: '优化图片加载策略',
      action: '实现图片懒加载和渐进式加载',
    });

    return suggestions;
  }

  /**
   * 重置性能数据
   */
  static resetMetrics(): void {
    this.metrics = [];
  }

  /**
   * 导出性能数据
   */
  static exportMetrics(): string {
    return JSON.stringify({
      config: this.config,
      metrics: this.metrics,
      report: this.getPerformanceReport(),
      timestamp: new Date().toISOString()
    }, null, 2);
  }

  /**
   * 导入性能数据
   */
  static importMetrics(data: string): boolean {
    try {
      const parsed = JSON.parse(data);
      if (parsed.metrics && Array.isArray(parsed.metrics)) {
        this.metrics = parsed.metrics;
        return true;
      }
    } catch (error) {
      console.error('导入性能数据失败:', error);
    }
    return false;
  }
}
