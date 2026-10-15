// 健康服务
import { Pet } from '../mock/PetData';
import { CalendarEvent, addCalendarEvent, getPetCalendarEvents, completeCalendarEvent } from '../mock/CalendarData';
import { PetMoodRecord, addPetMoodRecord, getPetMoodRecords } from '../mock/InteractionData';

export class HealthService {

  /**
   * 创建宠物健康提醒
   * @param petId 宠物ID
   * @param eventType 事件类型：vaccine（疫苗）、deworming（驱虫）、bath（洗澡）、checkup（体检）
   * @param date 日期（YYYY-MM-DD格式）
   * @param description 描述
   */
  static createHealthReminder(
    petId: number,
    eventType: string,
    date: string,
    description: string
  ): CalendarEvent {
    const event: CalendarEvent = {
      id: Date.now(),
      petId,
      title: this.getEventTitle(eventType),
      description,
      date,
      time: '09:00',
      type: 'health',
      isCompleted: false,
      createdAt: new Date().toISOString()
    };

    return addCalendarEvent(event);
  }

  /**
   * 获取事件标题
   */
  private static getEventTitle(eventType: string): string {
    const titles: Record<string, string> = {
      'vaccine': '疫苗提醒',
      'deworming': '驱虫提醒',
      'bath': '洗澡提醒',
      'checkup': '体检提醒',
      'medication': '用药提醒',
      'grooming': '美容提醒'
    };

    return titles[eventType] || '健康提醒';
  }

  /**
   * 获取宠物健康日历事件
   * @param petId 宠物ID
   */
  static getPetHealthEvents(petId: number): CalendarEvent[] {
    return getPetCalendarEvents(petId).filter(event => event.type === 'health');
  }

  /**
   * 获取今日健康提醒
   * @param petId 宠物ID
   */
  static getTodayHealthReminders(petId: number): CalendarEvent[] {
    const today = new Date().toISOString().split('T')[0];
    return this.getPetHealthEvents(petId)
      .filter(event => event.date === today && !event.isCompleted);
  }

  /**
   * 完成健康提醒
   * @param eventId 事件ID
   */
  static completeHealthReminder(eventId: number): boolean {
    return completeCalendarEvent(eventId);
  }

  /**
   * 记录宠物心情
   * @param petId 宠物ID
   * @param mood 心情：happy（开心）、normal（普通）、sad（难过）、lonely（孤独）
   * @param notes 备注
   */
  static recordPetMood(petId: number, mood: string, notes?: string): PetMoodRecord {
    const record: PetMoodRecord = {
      id: Date.now(),
      petId,
      mood,
      notes: notes || '',
      recordedAt: new Date().toISOString()
    };

    return addPetMoodRecord(record);
  }

  /**
   * 获取宠物心情记录
   * @param petId 宠物ID
   * @param days 最近多少天，默认7天
   */
  static getPetMoodHistory(petId: number, days: number = 7): PetMoodRecord[] {
    const records = getPetMoodRecords(petId);
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);

    return records.filter(record => {
      const recordDate = new Date(record.recordedAt);
      return recordDate >= cutoffDate;
    });
  }

  /**
   * 获取宠物心情统计
   * @param petId 宠物ID
   * @param days 最近多少天，默认7天
   */
  static getPetMoodStats(petId: number, days: number = 7): Record<string, number> {
    const records = this.getPetMoodHistory(petId, days);
    const stats: Record<string, number> = {
      'happy': 0,
      'normal': 0,
      'sad': 0,
      'lonely': 0
    };

    records.forEach(record => {
      if (stats[record.mood] !== undefined) {
        stats[record.mood]++;
      }
    });

    return stats;
  }

  /**
   * 分析宠物健康建议
   * @param pet 宠物信息
   * @param moodStats 心情统计
   */
  static analyzeHealthAdvice(pet: Pet, moodStats: Record<string, number>): string[] {
    const advice: string[] = [];

    // 基于宠物类型的基础建议
    if (pet.type === 'cat') {
      advice.push('定期梳理毛发，防止毛球症');
      advice.push('提供足够的猫抓板，保护家具');
      advice.push('保持猫砂盆清洁，每天清理1-2次');
    } else if (pet.type === 'dog') {
      advice.push('每天保证足够的运动量');
      advice.push('定期进行社会化训练');
      advice.push('注意牙齿清洁，预防牙结石');
    }

    // 基于年龄的建议
    const age = pet.age;
    if (age < 1) {
      advice.push('幼年期需要更多营养，选择专用幼宠粮');
      advice.push('按时完成疫苗接种计划');
    } else if (age > 7) {
      advice.push('老年宠物需要定期体检');
      advice.push('注意关节健康，提供柔软舒适的休息环境');
    }

    // 基于心情统计的建议
    const totalRecords = Object.values(moodStats).reduce((sum, count) => sum + count, 0);
    if (totalRecords > 0) {
      const sadRatio = moodStats['sad'] / totalRecords;
      const lonelyRatio = moodStats['lonely'] / totalRecords;

      if (sadRatio > 0.3) {
        advice.push('宠物最近情绪较低落，建议增加互动和陪伴');
      }

      if (lonelyRatio > 0.3) {
        advice.push('宠物表现出孤独感，考虑增加社交活动或同伴');
      }
    }

    // 基于健康状态的建议
    if (pet.health.includes('良好')) {
      advice.push('继续保持良好的健康状态，定期体检');
    } else if (pet.health.includes('一般')) {
      advice.push('注意观察宠物状态，如有异常及时就医');
    } else if (pet.health.includes('需要关注')) {
      advice.push('建议尽快安排专业兽医检查');
    }

    return advice.slice(0, 5); // 返回最多5条建议
  }

  /**
   * 生成健康报告
   * @param pet 宠物信息
   * @param days 统计天数，默认30天
   */
  static generateHealthReport(pet: Pet, days: number = 30): string {
    const moodStats = this.getPetMoodStats(pet.id, days);
    const healthEvents = this.getPetHealthEvents(pet.id);
    const completedEvents = healthEvents.filter(event => event.isCompleted);
    const pendingEvents = healthEvents.filter(event => !event.isCompleted);

    const report = `
# ${pet.name} 健康报告
## 基本信息
- 品种：${pet.type}${pet.breed ? `（${pet.breed}）` : ''}
- 年龄：${pet.age}岁
- 性别：${pet.gender}
- 健康状况：${pet.health}

## 心情统计（最近${days}天）
- 开心：${moodStats['happy']}次
- 普通：${moodStats['normal']}次
- 难过：${moodStats['sad']}次
- 孤独：${moodStats['lonely']}次

## 健康提醒
- 已完成：${completedEvents.length}次
- 待完成：${pendingEvents.length}次

## 健康建议
${this.analyzeHealthAdvice(pet, moodStats).map(item => `- ${item}`).join('\n')}

报告生成时间：${new Date().toLocaleDateString('zh-CN')}
    `;

    return report.trim();
  }
}
