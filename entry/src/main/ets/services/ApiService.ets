// 统一API服务
import { Pet, petList, getPetById, getPetsByType, getAvailablePets } from '../mock/PetData';
import { User, currentUser, updateUserInfo, login as loginMock } from '../mock/UserData';
import { Notice, getNotices, markNoticeAsRead } from '../mock/NoticeData';
import { Apply, getUserApplies, getPetApplies, createApply, updateApplyStatus } from '../mock/ApplyData';
import {
  addLikeRecord,
  addFavoriteRecord,
  addViewRecord,
  addCloudCareRecord
} from '../mock/InteractionData';
import { CalendarEvent, getPetCalendarEvents, addCalendarEvent, deleteCalendarEvent } from '../mock/CalendarData';
import { MatchResult, calculateMatchResult, testHistories } from '../mock/MatchTestData';
import { Post, getPostById, searchPosts, createPost } from '../mock/PostData';
import { appStore } from '../store/AppStore';

interface InitAppDataResult {
  pets: Pet[];
  notices: Notice[];
  user: User | null;
}

interface RefreshDataResult {
  pets: Pet[];
  notices: Notice[];
  applies: Apply[];
}

export class ApiService {
  private static readonly API_DELAY: number = 300;

  private static simulateApiCall<T>(callback: () => T): Promise<T> {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        try {
          const result = callback();
          resolve(result);
        } catch (error) {
          console.error('API调用失败:', error);
          reject(error instanceof Error ? error : new Error('API调用失败'));
        }
      }, ApiService.API_DELAY);
    });
  }

  static async getCurrentUser(): Promise<User | null> {
    return ApiService.simulateApiCall(() => {
      const user = currentUser;
      if (user) {
        appStore.setUser(user);
      }
      return user;
    });
  }

  static async login(username: string, password: string): Promise<User | null> {
    return ApiService.simulateApiCall(() => {
      const result = loginMock(username, password);
      if (result.success && result.user) {
        appStore.setUser(result.user);
        return result.user;
      }
      return null;
    });
  }

  static async logout(): Promise<boolean> {
    return ApiService.simulateApiCall(() => {
      appStore.clearUser();
      return true;
    });
  }

  static async updateUserInfo(userId: number, userData: Partial<User>): Promise<boolean> {
    return ApiService.simulateApiCall(() => {
      const success = updateUserInfo(userId, userData);
      if (success && currentUser && currentUser.id === userId) {
        appStore.setUser(currentUser);
      }
      return success;
    });
  }

  static async getAllPets(): Promise<Pet[]> {
    return ApiService.simulateApiCall(() => {
      const pets = petList;
      appStore.setPets(pets);
      return pets;
    });
  }

  static async getPet(id: number): Promise<Pet | null> {
    return ApiService.simulateApiCall(() => {
      return getPetById(id);
    });
  }

  static async getPetsByType(type: string): Promise<Pet[]> {
    return ApiService.simulateApiCall(() => {
      return getPetsByType(type);
    });
  }

  static async getAvailablePets(): Promise<Pet[]> {
    return ApiService.simulateApiCall(() => {
      return getAvailablePets();
    });
  }

  static async getAllNotices(): Promise<Notice[]> {
    return ApiService.simulateApiCall(() => {
      const notices = getNotices();
      appStore.setNotices(notices);
      return notices;
    });
  }

  static async getNotice(id: number): Promise<Notice | undefined> {
    return ApiService.simulateApiCall(() => {
      return getNotices().find(notice => notice.id === id);
    });
  }

  static async markNoticeAsRead(id: number): Promise<boolean> {
    return ApiService.simulateApiCall(() => {
      return markNoticeAsRead(id);
    });
  }

  static async getUserApplies(userId: number): Promise<Apply[]> {
    return ApiService.simulateApiCall(() => {
      const applies = getUserApplies(userId);
      appStore.setApplies(applies);
      return applies;
    });
  }

  static async getPetApplies(petId: number): Promise<Apply[]> {
    return ApiService.simulateApiCall(() => {
      return getPetApplies(petId);
    });
  }

  static async createApply(applyData: Apply): Promise<Apply | null> {
    return ApiService.simulateApiCall(() => {
      return createApply(applyData);
    });
  }

  static async updateApplyStatus(applyId: number, status: string): Promise<boolean> {
    return ApiService.simulateApiCall(() => {
      return updateApplyStatus(applyId, status);
    });
  }

  static async getPetInteractionStats(petId: number): Promise<Record<string, Object>> {
    return ApiService.simulateApiCall(() => {
      return {};
    });
  }

  static async getUserInteractionStats(userId: number): Promise<Record<string, Object>> {
    return ApiService.simulateApiCall(() => {
      return {};
    });
  }

  static async likePet(userId: number, petId: number): Promise<boolean> {
    return ApiService.simulateApiCall(() => {
      return addLikeRecord(userId, petId);
    });
  }

  static async unlikePet(userId: number, petId: number): Promise<boolean> {
    return ApiService.simulateApiCall(() => {
      return true;
    });
  }

  static async favoritePet(userId: number, petId: number): Promise<boolean> {
    return ApiService.simulateApiCall(() => {
      return addFavoriteRecord(userId, petId);
    });
  }

  static async unfavoritePet(userId: number, petId: number): Promise<boolean> {
    return ApiService.simulateApiCall(() => {
      return true;
    });
  }

  static async viewPet(userId: number, petId: number): Promise<boolean> {
    return ApiService.simulateApiCall(() => {
      return addViewRecord(userId, petId);
    });
  }

  static async cloudCarePet(userId: number, petId: number, amount: number): Promise<boolean> {
    return ApiService.simulateApiCall(() => {
      return addCloudCareRecord(userId, petId, amount);
    });
  }

  static async getPetCalendarEvents(petId: number): Promise<CalendarEvent[]> {
    return ApiService.simulateApiCall(() => {
      return getPetCalendarEvents(petId);
    });
  }

  static async addCalendarEvent(event: CalendarEvent): Promise<CalendarEvent> {
    return ApiService.simulateApiCall(() => {
      return addCalendarEvent(event);
    });
  }

  static async completeCalendarEvent(eventId: number): Promise<boolean> {
    return ApiService.simulateApiCall(() => {
      return deleteCalendarEvent(eventId);
    });
  }

  static async calculateMatchResult(answers: Record<string, number>): Promise<MatchResult> {
    return ApiService.simulateApiCall(() => {
      return calculateMatchResult(answers);
    });
  }

  static async getTestHistories(userId: number): Promise<MatchResult[]> {
    return ApiService.simulateApiCall(() => {
      return testHistories;
    });
  }

  static async getPost(id: number): Promise<Post | null> {
    return ApiService.simulateApiCall(() => {
      return getPostById(id);
    });
  }

  static async getPostsByCategory(category: string): Promise<Post[]> {
    return ApiService.simulateApiCall(() => {
      return [];
    });
  }

  static async searchPosts(keyword: string): Promise<Post[]> {
    return ApiService.simulateApiCall(() => {
      return searchPosts(keyword);
    });
  }

  static async createPost(postData: Post): Promise<Post | null> {
    return ApiService.simulateApiCall(() => {
      return createPost(postData);
    });
  }

  static async initializeAppData(): Promise<InitAppDataResult> {
    try {
      appStore.setLoading(true);
      const pets = await ApiService.getAllPets();
      const notices = await ApiService.getAllNotices();
      const user = await ApiService.getCurrentUser();
      const result: InitAppDataResult = { pets: pets, notices: notices, user: user };
      return result;
    } catch (error) {
      appStore.setError('初始化数据失败');
      throw new Error('初始化数据失败');
    } finally {
      appStore.setLoading(false);
    }
  }

  static async refreshAllData(): Promise<RefreshDataResult> {
    try {
      appStore.setLoading(true);
      const pets = await ApiService.getAllPets();
      const notices = await ApiService.getAllNotices();
      let applies: Apply[] = [];
      const user = appStore.getState().currentUser;
      if (user) {
        applies = await ApiService.getUserApplies(user.id);
      }
      const result: RefreshDataResult = { pets: pets, notices: notices, applies: applies };
      return result;
    } catch (error) {
      appStore.setError('刷新数据失败');
      throw new Error('刷新数据失败');
    } finally {
      appStore.setLoading(false);
    }
  }

  private static handleApiError(error: Error): never {
    console.error('API错误:', error);
    appStore.setError(error.message || '请求失败，请稍后重试');
    throw error;
  }

  static clearError(): void {
    appStore.setError(null);
  }
}
