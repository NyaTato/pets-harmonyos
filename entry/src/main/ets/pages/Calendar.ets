﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿﻿import { CommonStyles } from '../common/css/CommonStyles';
import { SafeArea } from '../components/SafeArea';
import { BackButton } from '../components/BackButton';
import { promptAction } from '@kit.ArkUI';

interface CareTask {
  id: string;
  title: string;
  category: TaskCategory;
  petName: string;
  date: string;
  time: string;
  repeat: RepeatType;
  notes: string;
  completed: boolean;
  completedAt: string | null;
}

type TaskCategory = 'feeding' | 'walking' | 'bathing' | 'vaccination' | 'deworming'
  | 'grooming' | 'medicine' | 'vet' | 'birthday';

type RepeatType = 'none' | 'daily' | 'weekly' | 'monthly';
type ViewMode = 'month' | 'week' | 'day';

interface CategoryInfo {
  label: string;
  emoji: string;
  color: string;
  bgColor: string;
}

interface StatusInfo {
  text: string;
  color: string;
}

const CATEGORY_CONFIG_MAP: Map<TaskCategory, CategoryInfo> = new Map();
CATEGORY_CONFIG_MAP.set('feeding', { label: '喂食', emoji: '🍖', color: '#F59E0B', bgColor: '#FEF3C7' });
CATEGORY_CONFIG_MAP.set('walking', { label: '散步', emoji: '🏃', color: '#10B981', bgColor: '#D1FAE5' });
CATEGORY_CONFIG_MAP.set('bathing', { label: '洗澡', emoji: '🛁', color: '#3B82F6', bgColor: '#DBEAFE' });
CATEGORY_CONFIG_MAP.set('vaccination', { label: '疫苗', emoji: '💉', color: '#EF4444', bgColor: '#FEE2E2' });
CATEGORY_CONFIG_MAP.set('deworming', { label: '驱虫', emoji: '💊', color: '#8B5CF6', bgColor: '#EDE9FE' });
CATEGORY_CONFIG_MAP.set('grooming', { label: '美容', emoji: '✂️', color: '#EC4899', bgColor: '#FCE7F3' });
CATEGORY_CONFIG_MAP.set('medicine', { label: '用药', emoji: '🏥', color: '#06B6D4', bgColor: '#CFFAFE' });
CATEGORY_CONFIG_MAP.set('vet', { label: '就诊', emoji: '🩺', color: '#F97316', bgColor: '#FFEDD5' });
CATEGORY_CONFIG_MAP.set('birthday', { label: '纪念日', emoji: '🎂', color: '#EAB308', bgColor: '#FEF9C3' });

const REPEAT_LABELS_MAP: Map<RepeatType, string> = new Map();
REPEAT_LABELS_MAP.set('none', '不重复');
REPEAT_LABELS_MAP.set('daily', '每天');
REPEAT_LABELS_MAP.set('weekly', '每周');
REPEAT_LABELS_MAP.set('monthly', '每月');

@Entry
@Component
struct PetCalendar {
  @State private currentYear: number = new Date().getFullYear();
  @State private currentMonth: number = new Date().getMonth() + 1;
  @State private selectedDate: string = this.formatDate(new Date());
  @State private viewMode: ViewMode = 'month';
  @State private tasks: CareTask[] = [];
  @State private showAddDialog: boolean = false;
  @State private showDetailPanel: boolean = false;
  @State private editingTask: CareTask | null = null;
  @State private showDeleteConfirm: boolean = false;
  @State private taskToDelete: string | null = null;

  private pets: string[] = ['小橘', '旺财', '咪咪', '豆豆'];

  aboutToAppear(): void {
    this.initMockTasks();
  }

  private initMockTasks(): void {
    const today: Date = new Date();
    const todayStr: string = this.formatDate(today);
    const tomorrow: Date = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);
    const tomorrowStr: string = this.formatDate(tomorrow);
    const yesterday: Date = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);
    const yesterdayStr: string = this.formatDate(yesterday);
    const nextWeek: Date = new Date(today);
    nextWeek.setDate(nextWeek.getDate() + 7);
    const nextWeekStr: string = this.formatDate(nextWeek);

    this.tasks = [
      { id: 't1', title: '早餐喂食', category: 'feeding', petName: '小橘', date: todayStr, time: '08:00', repeat: 'daily', notes: '猫粮30g+湿粮半罐', completed: true, completedAt: todayStr + ' 08:05' },
      { id: 't2', title: '上午遛狗', category: 'walking', petName: '旺财', date: todayStr, time: '09:30', repeat: 'daily', notes: '公园路线，约30分钟', completed: false, completedAt: null },
      { id: 't3', title: '午餐喂食', category: 'feeding', petName: '小橘', date: todayStr, time: '12:00', repeat: 'daily', notes: '', completed: false, completedAt: null },
      { id: 't4', title: '洗澡美容', category: 'bathing', petName: '咪咪', date: todayStr, time: '15:00', repeat: 'none', notes: '使用宠物专用沐浴露', completed: false, completedAt: null },
      { id: 't5', title: '晚餐喂食', category: 'feeding', petName: '小橘', date: todayStr, time: '18:30', repeat: 'daily', notes: '', completed: false, completedAt: null },
      { id: 't6', title: '晚上遛狗', category: 'walking', petName: '旺财', date: todayStr, time: '20:00', repeat: 'daily', notes: '小区内短途散步', completed: false, completedAt: null },
      { id: 't7', title: '驱虫提醒', category: 'deworming', petName: '豆豆', date: tomorrowStr, time: '10:00', repeat: 'monthly', notes: '体内驱虫药', completed: false, completedAt: null },
      { id: 't8', title: '疫苗接种', category: 'vaccination', petName: '旺财', date: nextWeekStr, time: '14:00', repeat: 'none', notes: '狂犬疫苗年度接种', completed: false, completedAt: null },
      { id: 't9', title: '小橘生日', category: 'birthday', petName: '小橘', date: this.formatDate(new Date(today.getFullYear(), 5, 15)), time: '00:00', repeat: 'yearly' as RepeatType, notes: '领养3周年纪念', completed: false, completedAt: null },
      { id: 't10', title: '体检预约', category: 'vet', petName: '咪咪', date: nextWeekStr, time: '10:30', repeat: 'none', notes: '年度健康检查', completed: false, completedAt: null },
      { id: 't11', title: '昨日喂食', category: 'feeding', petName: '小橘', date: yesterdayStr, time: '08:00', repeat: 'daily', notes: '', completed: true, completedAt: yesterdayStr + ' 08:10' },
      { id: 't12', title: '指甲修剪', category: 'grooming', petName: '豆豆', date: nextWeekStr, time: '16:00', repeat: 'monthly', notes: '', completed: false, completedAt: null }
    ];
  }

  private formatDate(d: Date): string {
    const y: number = d.getFullYear();
    const m: string = String(d.getMonth() + 1).padStart(2, '0');
    const dd: string = String(d.getDate()).padStart(2, '0');
    return `${y}-${m}-${dd}`;
  }

  private getDaysInMonth(year: number, month: number): number {
    return new Date(year, month, 0).getDate();
  }

  private getFirstDayOfMonth(year: number, month: number): number {
    return new Date(year, month - 1, 1).getDay();
  }

  private getTasksForDate(dateStr: string): CareTask[] {
    return this.tasks.filter((t: CareTask) => t.date === dateStr);
  }

  private getTodayTasks(): CareTask[] {
    return this.getTasksForDate(this.selectedDate);
  }

  private getUpcomingTasks(): CareTask[] {
    const today: Date = new Date();
    const todayStr: string = this.formatDate(today);
    return this.tasks
      .filter((t: CareTask) => t.date >= todayStr && !t.completed)
      .sort((a: CareTask, b: CareTask) => {
        if (a.date !== b.date) return a.date.localeCompare(b.date);
        return a.time.localeCompare(b.time);
      })
      .slice(0, 8);
  }

  private toggleComplete(taskId: string): void {
    const idx: number = this.tasks.findIndex((t: CareTask) => t.id === taskId);
    if (idx >= 0) {
      this.tasks[idx].completed = !this.tasks[idx].completed;
      this.tasks[idx].completedAt = this.tasks[idx].completed ? this.formatDate(new Date()) + ' ' + new Date().toTimeString().slice(0, 5) : null;
    }
  }

  private deleteTask(taskId: string): void {
    this.tasks = this.tasks.filter((t: CareTask) => t.id !== taskId);
    this.showDeleteConfirm = false;
    this.taskToDelete = null;
  }

  private addTask(task: CareTask): void {
    this.tasks = [...this.tasks, task];
    this.showAddDialog = false;
  }

  private updateTask(task: CareTask): void {
    const idx: number = this.tasks.findIndex((t: CareTask) => t.id === task.id);
    if (idx >= 0) {
      this.tasks[idx] = task;
    }
    this.editingTask = null;
    this.showDetailPanel = false;
  }

  private prevMonth(): void {
    if (this.currentMonth === 1) {
      this.currentMonth = 12;
      this.currentYear--;
    } else {
      this.currentMonth--;
    }
  }

  private nextMonth(): void {
    if (this.currentMonth === 12) {
      this.currentMonth = 1;
      this.currentYear++;
    } else {
      this.currentMonth++;
    }
  }

  private goToToday(): void {
    const today: Date = new Date();
    this.currentYear = today.getFullYear();
    this.currentMonth = today.getMonth() + 1;
    this.selectedDate = this.formatDate(today);
  }

  private getStatusInfo(task: CareTask): StatusInfo {
    const today: string = this.formatDate(new Date());
    if (task.completed) return { text: '已完成', color: '#10B981' };
    if (task.date < today) return { text: '已逾期', color: '#EF4444' };
    if (task.date === today && task.time < new Date().toTimeString().slice(0, 5)) return { text: '进行中', color: '#F59E0B' };
    return { text: '待完成', color: '#6B7280' };
  }

  private getCategoryConfig(cat: TaskCategory): CategoryInfo {
    return CATEGORY_CONFIG_MAP.get(cat)!;
  }

  private getRepeatLabel(repeat: RepeatType): string {
    return REPEAT_LABELS_MAP.get(repeat)!;
  }

  private buildCalendarCells(): GridItemModel[] {
    const totalDays: number = this.getDaysInMonth(this.currentYear, this.currentMonth);
    const firstDay: number = this.getFirstDayOfMonth(this.currentYear, this.currentMonth);
    const cells: GridItemModel[] = [];
    for (let i: number = 0; i < firstDay; i++) {
      cells.push({ day: 0, dateStr: '', hasTask: false, isSelected: false, isToday: false });
    }
    for (let d: number = 1; d <= totalDays; d++) {
      const ds: string = `${this.currentYear}-${String(this.currentMonth).padStart(2, '0')}-${String(d).padStart(2, '0')}`;
      cells.push({
        day: d,
        dateStr: ds,
        hasTask: this.getTasksForDate(ds).length > 0,
        isSelected: ds === this.selectedDate,
        isToday: ds === this.formatDate(new Date())
      });
    }
    return cells;
  }

  private getWeekRows(): GridItemModel[][] {
    const allCells: GridItemModel[] = this.buildCalendarCells();
    const weeks: GridItemModel[][] = [];
    for (let i: number = 0; i < allCells.length; i += 7) {
      weeks.push(allCells.slice(i, i + 7));
    }
    return weeks;
  }

  build() {
    Column() {
      SafeArea({ edges: ['top'] }) {
        Column() {
          Row() {
            BackButton()
            Text('宠物护理日历')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .layoutWeight(1)
            Text('今天')
              .fontSize(14)
              .fontColor(CommonStyles.PRIMARY)
              .onClick(() => this.goToToday())
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 16, bottom: 12 })

          Scroll() {
            Column({ space: 16 }) {
              this.CalendarHeader()
              this.CalendarGrid()
              this.TodayScheduleCard()
              this.UpcomingCard()
            }
            .width('100%')
            .padding({ left: 20, right: 20, bottom: 40 })
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)
          .layoutWeight(1)
          .backgroundColor('#F8FAFC')

          this.FloatingAddButton()
        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: '45mm' })
    .bindContentCover(this.showAddDialog, this.AddTaskDialog(), { modalTransition: ModalTransition.NONE })
    .bindContentCover(this.showDetailPanel, this.TaskDetailPanel(), { modalTransition: ModalTransition.NONE })
    .bindContentCover(this.showDeleteConfirm, this.DeleteConfirmDialog(), { modalTransition: ModalTransition.NONE })
  }

  @Builder
  CalendarHeader() {
    Column({ space: 12 }) {
      Row() {
        Text(`${this.currentYear}年${this.currentMonth}月`)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')
          .layoutWeight(1)

        Row({ space: 8 }) {
          this.ViewModeBtn('月', 'month')
          this.ViewModeBtn('周', 'week')
          this.ViewModeBtn('日', 'day')
        }
        .backgroundColor('#F1F5F9')
        .borderRadius(8)
        .padding(4)
      }

      Row() {
        Text('<')
          .fontSize(20)
          .fontColor('#64748B')
          .width(36)
          .height(36)
          .textAlign(TextAlign.Center)
          .onClick(() => this.prevMonth())

        Text(`${this.getMonthDays()}项任务`)
          .fontSize(14)
          .fontColor('#64748B')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('>')
          .fontSize(20)
          .fontColor('#64748B')
          .width(36)
          .height(36)
          .textAlign(TextAlign.Center)
          .onClick(() => this.nextMonth())
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }

  @Builder
  ViewModeBtn(label: string, mode: ViewMode) {
    Text(label)
      .fontSize(13)
      .fontWeight(this.viewMode === mode ? FontWeight.Medium : FontWeight.Normal)
      .fontColor(this.viewMode === mode ? '#FFFFFF' : '#64748B')
      .backgroundColor(this.viewMode === mode ? CommonStyles.PRIMARY : 'transparent')
      .borderRadius(6)
      .padding({ left: 12, right: 12, top: 6, bottom: 6 })
      .onClick(() => { this.viewMode = mode; })
  }

  @Builder
  CalendarGrid() {
    Column({ space: 6 }) {
      Row() {
        ForEach(['日', '一', '二', '三', '四', '五', '六'], (day: string) => {
          Text(day)
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor('#94A3B8')
            .width(0)
            .layoutWeight(1)
            .height(36)
            .textAlign(TextAlign.Center)
        })
      }
      .width('100%')

      ForEach(this.getWeekRows(), (week: GridItemModel[], weekIdx: number) => {
        Row() {
          ForEach(week, (cell: GridItemModel) => {
            if (cell.day === 0) {
              Text('')
                .width(0)
                .layoutWeight(1)
                .height(44)
            } else {
              Stack({ alignContent: Alignment.BottomEnd }) {
                Text(String(cell.day))
                  .fontSize(15)
                  .fontWeight(cell.isToday ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor(cell.isSelected ? '#FFFFFF' : (cell.isToday ? CommonStyles.PRIMARY : '#334155'))
                  .width('100%')
                  .height('100%')
                  .textAlign(TextAlign.Center)
                  .backgroundColor(cell.isSelected ? CommonStyles.PRIMARY : (cell.isToday ? '#EFF6FF' : 'transparent'))
                  .borderRadius(22)

                if (cell.hasTask) {
                  Text('')
                    .size({ width: 6, height: 6 })
                    .backgroundColor(cell.isSelected ? '#FFFFFF' : CommonStyles.PRIMARY)
                    .borderRadius(3)
                    .margin({ right: 4, bottom: 4 })
                }
              }
              .width(0)
              .layoutWeight(1)
              .height(44)
              .onClick(() => { this.selectedDate = cell.dateStr; })
            }
          }, (cell: GridItemModel) => cell.dateStr + '_' + String(cell.day))
        }
        .width('100%')
      }, (_: GridItemModel[], weekIdx: number) => String(weekIdx))
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }

  @Builder
  TodayScheduleCard() {
    Column({ space: 12 }) {
      Row() {
        Text('今日日程')
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
        Text(`${this.selectedDate}`)
          .fontSize(13)
          .fontColor('#94A3B8')
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }
      .width('100%')

      if (this.getTodayTasks().length === 0) {
        this.EmptyState('今日暂无护理任务', '点击右下角按钮添加新任务')
      } else {
        ForEach(this.getTodayTasks(), (task: CareTask) => {
          this.TaskRow(task)
        }, (task: CareTask) => task.id)
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }

  @Builder
  UpcomingCard() {
    Column({ space: 12 }) {
      Row() {
        Text('即将到来')
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
        Text(`${this.getUpcomingTasks().length}项待办`)
          .fontSize(13)
          .fontColor(CommonStyles.PRIMARY)
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }
      .width('100%')

      if (this.getUpcomingTasks().length === 0) {
        this.EmptyState('没有即将到来的任务', '所有任务都已完成')
      } else {
        ForEach(this.getUpcomingTasks(), (task: CareTask) => {
          this.TaskMiniRow(task)
        }, (task: CareTask) => task.id)
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }

  @Builder
  TaskRow(task: CareTask) {
    Row({ space: 12 }) {
      Stack() {
        Text(this.getCategoryConfig(task.category).emoji)
          .fontSize(22)
      }
      .size({ width: 44, height: 44 })
      .backgroundColor(this.getCategoryConfig(task.category).bgColor)
      .borderRadius(12)

      Column({ space: 4 }) {
        Row({ space: 8 }) {
          Text(task.title)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor(task.completed ? '#9CA3AF' : '#1A1A1A')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)

          Text(this.getStatusInfo(task).text)
            .fontSize(11)
            .fontColor(this.getStatusInfo(task).color)
            .backgroundColor(this.getStatusInfo(task).color + '18')
            .borderRadius(4)
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
        }

        Row({ space: 8 }) {
          Text(`🐾 ${task.petName}`)
            .fontSize(12)
            .fontColor('#6B7280')
          Text(task.time)
            .fontSize(12)
            .fontColor('#94A3B8')
          if (task.repeat !== 'none') {
            Text(`🔄 ${this.getRepeatLabel(task.repeat)}`)
              .fontSize(11)
              .fontColor('#8B5CF6')
          }
          Text(this.getCategoryConfig(task.category).label)
            .fontSize(11)
            .fontColor(this.getCategoryConfig(task.category).color)
            .backgroundColor(this.getCategoryConfig(task.category).bgColor)
            .borderRadius(4)
            .padding({ left: 4, right: 4, top: 1, bottom: 1 })
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Column({ space: 6 }) {
        Checkbox()
          .select(task.completed)
          .onChange((val: boolean) => {
            if (val !== undefined) {
              this.toggleComplete(task.id);
            }
          })
          .width(24)
          .height(24)

        Text('详情')
          .fontSize(11)
          .fontColor(CommonStyles.PRIMARY)
          .onClick(() => {
            this.editingTask = task;
            this.showDetailPanel = true;
          })
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor(task.completed ? '#F9FAFB' : '#FFFFFF')
    .borderRadius(12)
    .opacity(task.completed ? 0.75 : 1)
  }

  @Builder
  TaskMiniRow(task: CareTask) {
    Row({ space: 10 }) {
      Text(this.getCategoryConfig(task.category).emoji)
        .fontSize(18)

      Column({ space: 2 }) {
        Text(task.title)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1E293B')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Row({ space: 6 }) {
          Text(task.date.slice(5))
            .fontSize(12)
            .fontColor('#64748B')
          Text(task.time)
            .fontSize(12)
            .fontColor('#94A3B8')
          Text(`🐾${task.petName}`)
            .fontSize(11)
            .fontColor('#9CA3AF')
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Text(this.getCategoryConfig(task.category).label)
        .fontSize(11)
        .fontColor(this.getCategoryConfig(task.category).color)
        .backgroundColor(this.getCategoryConfig(task.category).bgColor)
        .borderRadius(4)
        .padding({ left: 5, right: 5, top: 2, bottom: 2 })
    }
    .width('100%')
    .padding({ left: 8, right: 8, top: 10, bottom: 10 })
    .backgroundColor('#FAFBFC')
    .borderRadius(10)
    .onClick(() => {
      this.editingTask = task;
      this.showDetailPanel = true;
    })
  }

  @Builder
  EmptyState(title: string, desc: string) {
    Column({ space: 10 }) {
      Text('📋')
        .fontSize(40)
      Text(title)
        .fontSize(15)
        .fontColor('#6B7280')
      Text(desc)
        .fontSize(13)
        .fontColor('#9CA3AF')
    }
    .width('100%')
    .padding({ top: 32, bottom: 24 })
  }

  @Builder
  FloatingAddButton() {
    Stack() {
      Column()
        .width(56)
        .height(56)
        .borderRadius(28)
        .backgroundColor(CommonStyles.PRIMARY)
        .shadow({
          radius: 8,
          color: 'rgba(59,130,246,0.35)',
          offsetX: 0,
          offsetY: 4
        })
        .onClick(() => { this.showAddDialog = true; })

      Text('+')
        .fontSize(28)
        .fontWeight(FontWeight.Lighter)
        .fontColor('#FFFFFF')
    }
    .position({ x: '85%', y: '80%' })
    .markAnchor({ x: '50%', y: '50%' })
    .zIndex(100)
  }

  @Builder
  AddTaskDialog() {
    Column() {
      AddTaskForm({ onSubmit: (task: CareTask) => this.addTask(task), onCancel: () => { this.showAddDialog = false; }, pets: this.pets })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgba(0,0,0,0.4)')
  }

  @Builder
  TaskDetailPanel() {
    Column() {
      if (this.editingTask !== null) {
        TaskDetailView({
          task: this.editingTask!,
          onComplete: () => this.toggleComplete(this.editingTask!.id),
          onEdit: (updated: CareTask) => this.updateTask(updated),
          onDelete: () => { this.taskToDelete = this.editingTask!.id; this.showDeleteConfirm = true; },
          onClose: () => { this.showDetailPanel = false; this.editingTask = null; }
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgba(0,0,0,0.4)')
  }

  @Builder
  DeleteConfirmDialog() {
    Column() {
      Column({ space: 20 }) {
        Text('⚠️')
          .fontSize(48)
        Text('确认删除此任务？')
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
            .fontColor('#1A1A1A')
        Text('删除后无法恢复')
          .fontSize(14)
          .fontColor('#6B7280')

        Row({ space: 12 }) {
          Text('取消')
            .fontSize(15)
            .fontColor('#6B7280')
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .padding({ top: 12, bottom: 12 })
            .backgroundColor('#F1F5F9')
            .borderRadius(10)
            .onClick(() => { this.showDeleteConfirm = false; this.taskToDelete = null; })

          Text('确认删除')
            .fontSize(15)
            .fontColor('#FFFFFF')
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .padding({ top: 12, bottom: 12 })
            .backgroundColor('#EF4444')
            .borderRadius(10)
            .onClick(() => { if (this.taskToDelete !== null) { this.deleteTask(this.taskToDelete); } })
        }
        .width('100%')
      }
      .width('85%')
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(20)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('rgba(0,0,0,0.4)')
  }

  private getMonthDays(): number {
    let count: number = 0;
    for (let d: number = 1; d <= this.getDaysInMonth(this.currentYear, this.currentMonth); d++) {
      const ds: string = `${this.currentYear}-${String(this.currentMonth).padStart(2, '0')}-${String(d).padStart(2, '0')}`;
      count += this.getTasksForDate(ds).length;
    }
    return count;
  }
}

interface GridItemModel {
  day: number;
  dateStr: string;
  hasTask: boolean;
  isSelected: boolean;
  isToday: boolean;
}

interface RepeatOptionItem {
  key: RepeatType;
  label: string;
}

@Component
struct AddTaskForm {
  @State private title: string = '';
  @State private category: TaskCategory = 'feeding';
  @State private petIdx: number = 0;
  @State private date: string = '';
  @State private time: string = '09:00';
  @State private repeat: RepeatType = 'none';
  @State private notes: string = '';
  private onSubmit!: (task: CareTask) => void;
  private onCancel!: () => void;
  private pets!: string[];

  private allCategories: TaskCategory[] = ['feeding', 'walking', 'bathing', 'vaccination', 'deworming', 'grooming', 'medicine', 'vet', 'birthday'];

  private repeatOptions: RepeatOptionItem[] = [
    { key: 'none' as RepeatType, label: '不重复' },
    { key: 'daily' as RepeatType, label: '每天' },
    { key: 'weekly' as RepeatType, label: '每周' },
    { key: 'monthly' as RepeatType, label: '每月' }
  ];

  private getCategoryEmoji(cat: TaskCategory): string {
    return CATEGORY_CONFIG_MAP.get(cat)!.emoji;
  }

  private getCategoryLabel(cat: TaskCategory): string {
    return CATEGORY_CONFIG_MAP.get(cat)!.label;
  }

  private getCategoryColor(cat: TaskCategory): string {
    return CATEGORY_CONFIG_MAP.get(cat)!.color;
  }

  private getCategoryBgColor(cat: TaskCategory): string {
    return CATEGORY_CONFIG_MAP.get(cat)!.bgColor;
  }

  aboutToAppear(): void {
    this.date = this.formatDate(new Date());
  }

  private formatDate(d: Date): string {
    const y: number = d.getFullYear();
    const m: string = String(d.getMonth() + 1).padStart(2, '0');
    const dd: string = String(d.getDate()).padStart(2, '0');
    return `${y}-${m}-${dd}`;
  }

  handleSubmit(): void {
    if (!this.title.trim()) {
      promptAction.showToast({ message: '请输入任务标题' });
      return;
    }
    const task: CareTask = {
      id: `t_${Date.now()}`,
      title: this.title.trim(),
      category: this.category,
      petName: this.pets[this.petIdx],
      date: this.date,
      time: this.time,
      repeat: this.repeat,
      notes: this.notes.trim(),
      completed: false,
      completedAt: null
    };
    this.onSubmit(task);
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 16 }) {
          Row() {
            Text('新增护理任务')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1A1A1A')
              .layoutWeight(1)
            Text('✕')
              .fontSize(22)
              .fontColor('#9CA3AF')
              .onClick(() => this.onCancel())
          }
          .width('100%')

          TextInput({ placeholder: '例如：早餐喂食、下午遛狗...', text: this.title })
            .onChange((v: string) => { this.title = v; })
            .width('100%')
            .height(48)
            .fontSize(15)
            .backgroundColor('#F8FAFC')
            .borderRadius(10)
            .padding({ left: 14 })

          Text('任务类型')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#374151')
            .width('100%')

          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.allCategories, (cat: TaskCategory) => {
              Text(`${this.getCategoryEmoji(cat)} ${this.getCategoryLabel(cat)}`)
                .fontSize(13)
                .fontColor(this.category === cat ? '#FFFFFF' : this.getCategoryColor(cat))
                .backgroundColor(this.category === cat ? this.getCategoryColor(cat) : this.getCategoryBgColor(cat))
                .borderRadius(8)
                .padding({ left: 10, right: 10, top: 7, bottom: 7 })
                .margin({ right: 8, bottom: 8 })
                .onClick(() => { this.category = cat; })
            })
          }
          .width('100%')

          Text('选择宠物')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#374151')
            .width('100%')

          Row({ space: 8 }) {
            ForEach(this.pets, (pet: string, idx: number) => {
              Text(pet)
                .fontSize(14)
                .fontColor(this.petIdx === idx ? '#FFFFFF' : '#4B5563')
                .backgroundColor(this.petIdx === idx ? CommonStyles.PRIMARY : '#F1F5F9')
                .borderRadius(20)
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                .onClick(() => { this.petIdx = idx; })
            })
          }
          .width('100%')

          Row({ space: 12 }) {
            Column({ space: 6 }) {
              Text('日期')
                .fontSize(13)
                .fontColor('#6B7280')
              DatePicker({
                start: new Date('2024-01-01'),
                end: new Date('2030-12-31'),
                selected: new Date(this.date.replace(/-/g, '/'))
              })
                .onChange((value: DatePickerResult) => {
                  const y: number = value.year ?? new Date().getFullYear();
                  const m: number = value.month ?? (new Date().getMonth() + 1);
                  const d: number = value.day ?? new Date().getDate();
                  this.date = `${y}-${String(m).padStart(2,'0')}-${String(d).padStart(2,'0')}`;
                })
                .layoutWeight(1)
            }
            .layoutWeight(1)

            Column({ space: 6 }) {
              Text('时间')
                .fontSize(13)
                .fontColor('#6B7280')
              TimePicker({ selected: new Date(`2000-01-01 ${this.time}`) })
                .useMilitaryTime(true)
                .onChange((value: TimePickerResult) => {
                  const h: number = value.hour ?? 9;
                  const min: number = value.minute ?? 0;
                  this.time = `${String(h).padStart(2,'0')}:${String(min).padStart(2,'0')}`;
                })
                .layoutWeight(1)
            }
            .layoutWeight(1)
          }
          .width('100%')

          Text('重复频率')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#374151')
            .width('100%')

          Row({ space: 8 }) {
            ForEach(this.repeatOptions, (item: RepeatOptionItem) => {
              Text(item.label)
                .fontSize(13)
                .fontColor(this.repeat === item.key ? '#FFFFFF' : '#4B5563')
                .backgroundColor(this.repeat === item.key ? CommonStyles.PRIMARY : '#F1F5F9')
                .borderRadius(8)
                .padding({ left: 14, right: 14, top: 8, bottom: 8 })
                .onClick(() => { this.repeat = item.key; })
            })
          }
          .width('100%')

          TextArea({ placeholder: '备注信息（可选）...', text: this.notes })
            .onChange((v: string) => { this.notes = v; })
            .width('100%')
            .height(70)
            .fontSize(14)
            .backgroundColor('#F8FAFC')
            .borderRadius(10)
            .padding(12)

          Button('创建任务')
            .width('100%')
            .height(46)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF')
            .backgroundColor(CommonStyles.PRIMARY)
            .borderRadius(12)
            .onClick(() => this.handleSubmit())
        }
        .width('100%')
        .padding(20)
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius({ topLeft: 24, topRight: 24 })
  }
}

@Component
struct TaskDetailView {
  @Prop private task: CareTask;
  private onComplete!: () => void;
  private onEdit!: (task: CareTask) => void;
  private onDelete!: () => void;
  private onClose!: () => void;

  private getTaskCatInfo(): CategoryInfo {
    return CATEGORY_CONFIG_MAP.get(this.task.category)!;
  }

  private getTaskStatusInfo(): StatusInfo {
    const today: string = new Date().toISOString().slice(0, 10);
    if (this.task.completed) return { text: '已完成', color: '#10B981' };
    if (this.task.date < today) return { text: '已逾期', color: '#EF4444' };
    if (this.task.date === today) return { text: '今日待办', color: '#F59E0B' };
    return { text: '即将到来', color: '#3B82F6' };
  }

  build() {
    Column() {
      Column({ space: 20 }) {
        Row() {
          Text('任务详情')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .layoutWeight(1)
          Text('✕')
            .fontSize(22)
            .fontColor('#9CA3AF')
            .onClick(() => this.onClose())
        }
        .width('100%')

        Column({ space: 16 }) {
          Stack({ alignContent: Alignment.Center }) {
            Text(this.getTaskCatInfo().emoji)
              .fontSize(48)
          }
          .size({ width: 80, height: 80 })
          .backgroundColor(this.getTaskCatInfo().bgColor)
          .borderRadius(20)

          Text(this.task.title)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .textAlign(TextAlign.Center)

          Text(this.getTaskStatusInfo().text)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.getTaskStatusInfo().color)
            .backgroundColor(this.getTaskStatusInfo().color + '18')
            .borderRadius(6)
            .padding({ left: 12, right: 12, top: 4, bottom: 4 })
        }
        .width('100%')

        Column({ space: 14 }) {
          this.DetailItem('任务类型', `${this.getTaskCatInfo().emoji} ${this.getTaskCatInfo().label}`, this.getTaskCatInfo().color);
          this.DetailItem('关联宠物', `🐾 ${this.task.petName}`, '#6B7280');
          this.DetailItem('计划时间', `📅 ${this.task.date} ${this.task.time}`, '#6B7280');
          this.DetailItem('重复设置', `🔄 ${REPEAT_LABELS_MAP.get(this.task.repeat)!}`, '#8B5CF6');

          if (this.task.notes) {
            this.DetailItem('备注说明', this.task.notes, '#6B7280');
          }

          if (this.task.completed && this.task.completedAt) {
            this.DetailItem('完成时间', `✅ ${this.task.completedAt}`, '#10B981');
          }
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#F8FAFC')
        .borderRadius(14)

        Column({ space: 10 }) {
          if (!this.task.completed) {
            Button('标记为已完成')
              .width('100%')
              .height(44)
              .fontSize(15)
              .fontColor('#FFFFFF')
              .backgroundColor('#10B981')
              .borderRadius(10)
              .onClick(() => this.onComplete())
          }

          Button('编辑任务')
            .width('100%')
            .height(44)
            .fontSize(15)
            .fontColor(CommonStyles.PRIMARY)
            .backgroundColor(CommonStyles.PRIMARY + '15')
            .borderRadius(10)
            .onClick(() => this.onEdit(this.task))

          Button('删除任务')
            .width('100%')
            .height(44)
            .fontSize(15)
            .fontColor('#EF4444')
            .backgroundColor('#FEF2F2')
            .borderRadius(10)
            .onClick(() => this.onDelete())

          Button('关闭')
            .width('100%')
            .height(40)
            .fontSize(14)
            .fontColor('#6B7280')
            .backgroundColor('#F1F5F9')
            .borderRadius(10)
            .onClick(() => this.onClose())
        }
        .width('100%')
      }
      .width('90%')
      .constraintSize({ maxHeight: '88%' })
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(24)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.End)
  }

  @Builder
  DetailItem(label: string, value: string, valueColor: string) {
    Row() {
      Text(label)
        .fontSize(13)
        .fontColor('#9CA3AF')
        .width(80)
      Text(value)
        .fontSize(14)
        .fontColor(valueColor)
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)
        .textAlign(TextAlign.End)
    }
    .width('100%')
  }

  private getTaskStatus(t: CareTask): StatusInfo {
    const today: string = new Date().toISOString().slice(0, 10);
    if (t.completed) return { text: '已完成', color: '#10B981' };
    if (t.date < today) return { text: '已逾期', color: '#EF4444' };
    if (t.date === today) return { text: '今日待办', color: '#F59E0B' };
    return { text: '即将到来', color: '#3B82F6' };
  }
}
