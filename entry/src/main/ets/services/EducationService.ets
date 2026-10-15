/**
 * 宠物教育服务
 * 提供养宠知识、培训教程等教育内容
 */

export interface EducationArticle {
  id: number;
  title: string;
  content: string;
  category: string;
  author: string;
  publishDate: string;
  readCount: number;
  likeCount: number;
  tags: string[];
  coverImage?: string;
  difficulty: 'beginner' | 'intermediate' | 'advanced';
  estimatedTime: number;
}

export interface TrainingVideo {
  id: number;
  title: string;
  description: string;
  videoUrl: string;
  duration: number;
  category: string;
  instructor: string;
  publishDate: string;
  viewCount: number;
  likeCount: number;
  difficulty: 'beginner' | 'intermediate' | 'advanced';
}

export interface FAQ {
  id: number;
  question: string;
  answer: string;
  category: string;
  helpfulCount: number;
}

interface RecommendedContent {
  articles: EducationArticle[];
  videos: TrainingVideo[];
  faqs: FAQ[];
}

interface LearningStats {
  totalArticlesRead: number;
  totalVideosWatched: number;
  totalTimeSpent: number;
  favoriteCategories: string[];
}

export class EducationService {
  private static articles: EducationArticle[] = [
    {
      id: 1,
      title: '新手养猫指南：从零开始',
      content: '养猫前需要准备哪些物品？如何选择适合的猫粮？猫咪的日常护理要点...',
      category: '猫咪养护',
      author: '宠物专家张医生',
      publishDate: '2024-01-15',
      readCount: 1250,
      likeCount: 89,
      tags: ['新手', '猫咪', '养护'],
      difficulty: 'beginner',
      estimatedTime: 8
    },
    {
      id: 2,
      title: '狗狗训练：基础指令教学',
      content: '如何训练狗狗坐下、握手、等待等基础指令？训练中的注意事项...',
      category: '狗狗训练',
      author: '训犬师李老师',
      publishDate: '2024-01-20',
      readCount: 980,
      likeCount: 76,
      tags: ['训练', '狗狗', '指令'],
      difficulty: 'beginner',
      estimatedTime: 10
    },
    {
      id: 3,
      title: '宠物健康饮食全攻略',
      content: '不同年龄、不同品种宠物的饮食需求分析，如何选择优质宠物食品...',
      category: '健康饮食',
      author: '宠物营养师王博士',
      publishDate: '2024-01-25',
      readCount: 1560,
      likeCount: 102,
      tags: ['饮食', '健康', '营养'],
      difficulty: 'intermediate',
      estimatedTime: 12
    },
    {
      id: 4,
      title: '猫咪行为解读：读懂你的猫',
      content: '猫咪的各种行为代表什么含义？如何正确理解猫咪的情绪和需求...',
      category: '行为解读',
      author: '动物行为学家赵教授',
      publishDate: '2024-02-01',
      readCount: 890,
      likeCount: 67,
      tags: ['行为', '猫咪', '心理'],
      difficulty: 'intermediate',
      estimatedTime: 15
    },
    {
      id: 5,
      title: '宠物急救知识手册',
      content: '宠物突发疾病或受伤时的急救措施，家庭常备宠物急救药品清单...',
      category: '健康急救',
      author: '兽医刘主任',
      publishDate: '2024-02-05',
      readCount: 2100,
      likeCount: 145,
      tags: ['急救', '健康', '安全'],
      difficulty: 'advanced',
      estimatedTime: 20
    }
  ];

  private static videos: TrainingVideo[] = [
    {
      id: 1,
      title: '猫咪洗澡教学视频',
      description: '详细讲解如何正确给猫咪洗澡，减少猫咪的应激反应',
      videoUrl: 'https://example.com/videos/cat-bath.mp4',
      duration: 480,
      category: '日常护理',
      instructor: '宠物美容师陈老师',
      publishDate: '2024-01-10',
      viewCount: 5600,
      likeCount: 320,
      difficulty: 'beginner'
    },
    {
      id: 2,
      title: '狗狗基础服从训练',
      description: '从零开始训练狗狗的基础服从指令',
      videoUrl: 'https://example.com/videos/dog-training.mp4',
      duration: 600,
      category: '行为训练',
      instructor: '专业训犬师张教练',
      publishDate: '2024-01-15',
      viewCount: 7800,
      likeCount: 450,
      difficulty: 'beginner'
    },
    {
      id: 3,
      title: '宠物美容技巧进阶',
      description: '专业宠物美容技巧，包括修剪、造型等',
      videoUrl: 'https://example.com/videos/grooming-advanced.mp4',
      duration: 900,
      category: '美容护理',
      instructor: '国际认证美容师李老师',
      publishDate: '2024-01-20',
      viewCount: 3200,
      likeCount: 210,
      difficulty: 'advanced'
    }
  ];

  private static faqs: FAQ[] = [
    {
      id: 1,
      question: '猫咪需要打哪些疫苗？',
      answer: '猫咪需要接种的核心疫苗包括猫三联（猫瘟、猫鼻支、猫杯状）和狂犬疫苗。建议在猫咪8周龄时开始接种。',
      category: '健康医疗',
      helpfulCount: 156
    },
    {
      id: 2,
      question: '狗狗每天需要遛多久？',
      answer: '小型犬每天建议遛30-60分钟，中型犬60-90分钟，大型犬90-120分钟。具体时间根据狗狗的年龄、品种和健康状况调整。',
      category: '日常养护',
      helpfulCount: 89
    },
    {
      id: 3,
      question: '如何判断宠物是否生病？',
      answer: '观察宠物的食欲、精神状态、排泄情况。如果出现食欲不振、精神萎靡、呕吐腹泻等症状，应及时就医。',
      category: '健康医疗',
      helpfulCount: 203
    },
    {
      id: 4,
      question: '宠物需要绝育吗？',
      answer: '绝育可以预防多种疾病，减少流浪动物数量。建议在宠物6-8个月大时进行绝育手术。',
      category: '健康医疗',
      helpfulCount: 178
    },
    {
      id: 5,
      question: '如何训练猫咪使用猫砂盆？',
      answer: '将猫咪放在猫砂盆中，引导它刨砂。在猫咪饭后或睡醒时带它到猫砂盆。及时清理猫砂盆保持干净。',
      category: '行为训练',
      helpfulCount: 94
    }
  ];

  private static API_DELAY = 300;

  static getArticles(category?: string, difficulty?: string): Promise<EducationArticle[]> {
    return new Promise((resolve) => {
      setTimeout(() => {
        let filteredArticles = [...EducationService.articles];
        if (category) {
          filteredArticles = filteredArticles.filter((article) => article.category === category);
        }
        if (difficulty) {
          filteredArticles = filteredArticles.filter((article) => article.difficulty === difficulty);
        }
        filteredArticles.sort((a, b) => b.readCount - a.readCount);
        resolve(filteredArticles);
      }, EducationService.API_DELAY);
    });
  }

  static getArticleById(id: number): Promise<EducationArticle | null> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const article = EducationService.articles.find((a) => a.id === id) || null;
        if (article) {
          article.readCount++;
        }
        resolve(article);
      }, EducationService.API_DELAY);
    });
  }

  static searchArticles(keyword: string): Promise<EducationArticle[]> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const searchTerm = keyword.toLowerCase();
        const results = EducationService.articles.filter((article) =>
          article.title.toLowerCase().includes(searchTerm) ||
          article.content.toLowerCase().includes(searchTerm) ||
          article.tags.some((tag) => tag.toLowerCase().includes(searchTerm))
        );
        resolve(results);
      }, EducationService.API_DELAY);
    });
  }

  static likeArticle(articleId: number): Promise<boolean> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const article = EducationService.articles.find((a) => a.id === articleId);
        if (article) {
          article.likeCount++;
          resolve(true);
        } else {
          resolve(false);
        }
      }, EducationService.API_DELAY);
    });
  }

  static getVideos(category?: string, difficulty?: string): Promise<TrainingVideo[]> {
    return new Promise((resolve) => {
      setTimeout(() => {
        let filteredVideos = [...EducationService.videos];
        if (category) {
          filteredVideos = filteredVideos.filter((video) => video.category === category);
        }
        if (difficulty) {
          filteredVideos = filteredVideos.filter((video) => video.difficulty === difficulty);
        }
        filteredVideos.sort((a, b) => b.viewCount - a.viewCount);
        resolve(filteredVideos);
      }, EducationService.API_DELAY);
    });
  }

  static getVideoById(id: number): Promise<TrainingVideo | null> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const video = EducationService.videos.find((v) => v.id === id) || null;
        if (video) {
          video.viewCount++;
        }
        resolve(video);
      }, EducationService.API_DELAY);
    });
  }

  static likeVideo(videoId: number): Promise<boolean> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const video = EducationService.videos.find((v) => v.id === videoId);
        if (video) {
          video.likeCount++;
          resolve(true);
        } else {
          resolve(false);
        }
      }, EducationService.API_DELAY);
    });
  }

  static getFAQs(category?: string): Promise<FAQ[]> {
    return new Promise((resolve) => {
      setTimeout(() => {
        let filteredFAQs = [...EducationService.faqs];
        if (category) {
          filteredFAQs = filteredFAQs.filter((faq) => faq.category === category);
        }
        filteredFAQs.sort((a, b) => b.helpfulCount - a.helpfulCount);
        resolve(filteredFAQs);
      }, EducationService.API_DELAY);
    });
  }

  static searchFAQs(keyword: string): Promise<FAQ[]> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const searchTerm = keyword.toLowerCase();
        const results = EducationService.faqs.filter((faq) =>
          faq.question.toLowerCase().includes(searchTerm) ||
          faq.answer.toLowerCase().includes(searchTerm)
        );
        resolve(results);
      }, EducationService.API_DELAY);
    });
  }

  static markFAQHelpful(faqId: number): Promise<boolean> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const faq = EducationService.faqs.find((f) => f.id === faqId);
        if (faq) {
          faq.helpfulCount++;
          resolve(true);
        } else {
          resolve(false);
        }
      }, EducationService.API_DELAY);
    });
  }

  static getCategories(): Promise<string[]> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const categories = new Set<string>();
        EducationService.articles.forEach((article) => categories.add(article.category));
        EducationService.videos.forEach((video) => categories.add(video.category));
        EducationService.faqs.forEach((faq) => categories.add(faq.category));
        resolve(Array.from(categories));
      }, EducationService.API_DELAY);
    });
  }

  static getPopularArticles(limit: number = 5): Promise<EducationArticle[]> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const popularArticles = [...EducationService.articles]
          .sort((a, b) => b.readCount - a.readCount)
          .slice(0, limit);
        resolve(popularArticles);
      }, EducationService.API_DELAY);
    });
  }

  static getRecommendedContent(userInterests: string[] = []): Promise<RecommendedContent> {
    return new Promise((resolve) => {
      setTimeout(() => {
        let recommendedArticles = [...EducationService.articles];
        let recommendedVideos = [...EducationService.videos];
        let recommendedFAQs = [...EducationService.faqs];

        if (userInterests.length > 0) {
          recommendedArticles = recommendedArticles.filter((article) =>
            userInterests.some((interest) =>
              article.title.includes(interest) ||
              article.tags.includes(interest) ||
              article.category.includes(interest)
            )
          );
          recommendedVideos = recommendedVideos.filter((video) =>
            userInterests.some((interest) =>
              video.title.includes(interest) ||
              video.category.includes(interest)
            )
          );
          recommendedFAQs = recommendedFAQs.filter((faq) =>
            userInterests.some((interest) =>
              faq.question.includes(interest) ||
              faq.category.includes(interest)
            )
          );
        }

        const popularArticles = [...EducationService.articles]
          .sort((a, b) => b.readCount - a.readCount)
          .slice(0, 3);

        if (recommendedArticles.length < 3) {
          recommendedArticles = [...recommendedArticles, ...popularArticles];
          recommendedArticles = Array.from(new Map(recommendedArticles.map((item) => [item.id, item])).values());
        }

        const result: RecommendedContent = {
          articles: recommendedArticles.slice(0, 5),
          videos: recommendedVideos.slice(0, 3),
          faqs: recommendedFAQs.slice(0, 5)
        };
        resolve(result);
      }, EducationService.API_DELAY);
    });
  }

  static getLearningStats(userId: number): Promise<LearningStats> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const result: LearningStats = {
          totalArticlesRead: Math.floor(Math.random() * 50),
          totalVideosWatched: Math.floor(Math.random() * 20),
          totalTimeSpent: Math.floor(Math.random() * 300),
          favoriteCategories: ['猫咪养护', '狗狗训练', '健康饮食']
        };
        resolve(result);
      }, EducationService.API_DELAY);
    });
  }
}