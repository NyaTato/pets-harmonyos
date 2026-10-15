// 经验帖子数据
export interface Post {
  id: number;
  title: string;
  content: string;
  author: string;
  authorAvatar: string;
  category: string; // 分类：饲养经验、健康护理、行为训练、日常护理
  tags: string[];
  likes: number;
  comments: number;
  views: number;
  favorites: number; // 收藏
  isLiked: boolean;
  isFavorited: boolean;
  createTime: string;
  updateTime: string;
}

export interface Comment {
  id: number;
  postId: number;
  userId: number;
  userName: string;
  userAvatar: string;
  content: string;
  likes: number;
  replies: Reply[];
  createTime: string;
  updateTime: string;
  isLiked: boolean;
}

export interface Reply {
  id: number;
  commentId: number;
  userId: number;
  userName: string;
  userAvatar: string;
  content: string;
  likes: number;
  createTime: string;
  isLiked: boolean;
}

// 模拟帖子数据
export const postList: Post[] = [
  {
    id: 1,
    title: "新手养猫指南：从零开始的猫咪饲养经验",
    content: "养猫需要准备哪些东西？如何让猫咪快速适应新环境？本文分享新手养猫的完整流程和注意事项",
    author: "猫奴小张",
    authorAvatar: 'avatars/avatar_author_catlover.jpg',
    category: "饲养经验",
    tags: ["新手", "猫咪", "饲养"],
    likes: 128,
    comments: 24,
    views: 1560,
    favorites: 45,
    isLiked: false,
    isFavorited: false,
    createTime: "2026-03-15 10:30:00",
    updateTime: "2026-03-15 10:30:00"
  },
  {
    id: 2,
    title: "狗狗日常训练：如何教会狗狗基本指令",
    content: "坐下、握手、等待...这些基本指令如何训练？分享我的训练经验和技巧",
    author: "狗狗训练师",
    authorAvatar: 'avatars/avatar_author_trainer.jpg',
    category: "行为训练",
    tags: ["训练", "狗狗", "指令"],
    likes: 89,
    comments: 18,
    views: 980,
    favorites: 32,
    isLiked: false,
    isFavorited: false,
    createTime: "2026-03-18 14:20:00",
    updateTime: "2026-03-18 14:20:00"
  },
  {
    id: 3,
    title: "猫咪常见疾病预防与护理",
    content: "猫咪常见的疾病有哪些？如何预防和早期发现？分享一些实用的护理知识",
    author: "宠物医生",
    authorAvatar: 'avatars/avatar_author_vet.jpg',
    category: "健康护理",
    tags: ["健康", "疾病", "护理"],
    likes: 156,
    comments: 32,
    views: 2100,
    favorites: 67,
    isLiked: false,
    isFavorited: false,
    createTime: "2026-03-20 09:15:00",
    updateTime: "2026-03-20 09:15:00"
  },
  {
    id: 4,
    title: "如何为宠物选择合适的粮食",
    content: "市面上的宠物粮种类繁多，如何根据宠物的年龄、品种、健康状况选择合适的粮食",
    author: "营养专家",
    authorAvatar: 'avatars/avatar_author_nutrition.jpg',
    category: "日常护理",
    tags: ["粮食", "营养", "选择"],
    likes: 76,
    comments: 15,
    views: 890,
    favorites: 28,
    isLiked: false,
    isFavorited: false,
    createTime: "2026-03-22 16:45:00",
    updateTime: "2026-03-22 16:45:00"
  },
  {
    id: 5,
    title: "狗狗社会化训练的重要性",
    content: "狗狗社会化训练对性格形成至关重要，分享如何进行有效的社交训练",
    author: "训犬师老王",
    authorAvatar: 'avatars/avatar_author_5.jpg',
    category: "行为训练",
    tags: ["社会化", "训练", "性格"],
    likes: 94,
    comments: 21,
    views: 1120,
    favorites: 39,
    isLiked: false,
    isFavorited: false,
    createTime: "2026-03-25 11:30:00",
    updateTime: "2026-03-25 11:30:00"
  },
  {
    id: 6,
    title: "猫咪绝育的利与弊",
    content: "猫咪绝育有哪些好处和注意事项？什么时候是最佳绝育时间？",
    author: "兽医小李",
    authorAvatar: 'avatars/avatar_author_6.jpg',
    category: "健康护理",
    tags: ["绝育", "健康", "手术"],
    likes: 112,
    comments: 28,
    views: 1450,
    favorites: 52,
    isLiked: false,
    isFavorited: false,
    createTime: "2026-03-28 13:20:00",
    updateTime: "2026-03-28 13:20:00"
  },
  {
    id: 7,
    title: "如何给宠物洗澡？详细步骤分享",
    content: "给宠物洗澡需要注意哪些事项？水温、洗浴用品、吹干技巧全攻略",
    author: "宠物美容师",
    authorAvatar: 'avatars/avatar_author_7.jpg',
    category: "日常护理",
    tags: ["洗澡", "美容", "护理"],
    likes: 68,
    comments: 12,
    views: 780,
    favorites: 24,
    isLiked: false,
    isFavorited: false,
    createTime: "2026-04-01 15:40:00",
    updateTime: "2026-04-01 15:40:00"
  },
  {
    id: 8,
    title: "领养宠物前的心理准备",
    content: "领养宠物不是一时冲动，需要做好哪些心理准备和经济准备",
    author: "心理咨询师",
    authorAvatar: 'avatars/avatar_author_8.jpg',
    category: "饲养经验",
    tags: ["领养", "心理", "准备"],
    likes: 102,
    comments: 19,
    views: 1250,
    favorites: 41,
    isLiked: false,
    isFavorited: false,
    createTime: "2026-04-03 10:10:00",
    updateTime: "2026-04-03 10:10:00"
  },
  {
    id: 9,
    title: "宠物疫苗接种时间表",
    content: "宠物需要接种哪些疫苗？什么时间接种？完整的疫苗接种计划表",
    author: "宠物医生",
    authorAvatar: 'avatars/avatar_author_9.jpg',
    category: "健康护理",
    tags: ["疫苗", "健康", "预防"],
    likes: 145,
    comments: 31,
    views: 1980,
    favorites: 63,
    isLiked: false,
    isFavorited: false,
    createTime: "2026-04-05 14:55:00",
    updateTime: "2026-04-05 14:55:00"
  },
  {
    id: 10,
    title: "如何训练猫咪使用猫砂",
    content: "新猫到家不会用猫砂？分享几个训练技巧，让猫咪快速学会使用猫砂",
    author: "资深猫奴",
    authorAvatar: 'avatars/avatar_author_9.jpg',
    category: "行为训练",
    tags: ["猫砂", "训练", "猫咪"],
    likes: 83,
    comments: 16,
    views: 920,
    favorites: 35,
    isLiked: false,
    isFavorited: false,
    createTime: "2026-04-08 09:25:00",
    updateTime: "2026-04-08 09:25:00"
  }
];

// 模拟评论数据
export const commentList: Comment[] = [
  {
    id: 1,
    postId: 1,
    userId: 1,
    userName: "测试用户",
    userAvatar: 'avatars/avatar_user_zhangsan.jpg',
    content: "非常实用的指南，对我这个新手帮助很大",
    likes: 12,
    replies: [
      {
        id: 1,
        commentId: 1,
        userId: 2,
        userName: "李四",
        userAvatar: 'avatars/avatar_user_lisi.jpg',
        content: "确实，我也是按照这个指南养猫的，效果很好",
        likes: 3,
        createTime: "2026-03-15 11:30:00",
        isLiked: false
      }
    ],
    createTime: "2026-03-15 11:00:00",
    updateTime: "2026-03-15 11:00:00",
    isLiked: false
  },
  {
    id: 2,
    postId: 1,
    userId: 3,
    userName: "王五",
    userAvatar: 'avatars/avatar_user_wangwu.jpg',
    content: "请问猫咪多大可以开始训练？",
    likes: 5,
    replies: [
      {
        id: 2,
        commentId: 2,
        userId: 1,
        userName: "猫奴小张",
        userAvatar: 'avatars/avatar_author_catlover.jpg',
        content: "一般2-4个月就可以开始基础训练",
        likes: 2,
        createTime: "2026-03-15 12:15:00",
        isLiked: false
      }
    ],
    createTime: "2026-03-15 11:45:00",
    updateTime: "2026-03-15 11:45:00",
    isLiked: false
  },
  {
    id: 3,
    postId: 2,
    userId: 2,
    userName: "李四",
    userAvatar: 'avatars/avatar_user_lisi.jpg',
    content: "训练狗狗确实需要耐心，谢谢分享！",
    likes: 8,
    replies: [],
    createTime: "2026-03-18 15:30:00",
    updateTime: "2026-03-18 15:30:00",
    isLiked: false
  }
];

// 获取帖子列表
export function getPosts(category?: string): Post[] {
  if (category) {
    return postList.filter(post => post.category === category);
  }
  return postList;
}

// 获取帖子详情
export function getPostById(postId: number): Post | null {
  const post = postList.find(post => post.id === postId);
  return post || null;
}

// 获取帖子的评论
export function getPostComments(postId: number): Comment[] {
  return commentList.filter(comment => comment.postId === postId);
}

// 点赞帖子
export function likePost(postId: number): boolean {
  const postIndex = postList.findIndex(post => post.id === postId);
  if (postIndex !== -1) {
    if (postList[postIndex].isLiked) {
      postList[postIndex].likes--;
      postList[postIndex].isLiked = false;
    } else {
      postList[postIndex].likes++;
      postList[postIndex].isLiked = true;
    }
    return true;
  }
  return false;
}

// 收藏帖子
export function favoritePost(postId: number): boolean {
  const postIndex = postList.findIndex(post => post.id === postId);
  if (postIndex !== -1) {
    postList[postIndex].isFavorited = !postList[postIndex].isFavorited;
    return true;
  }
  return false;
}

// 增加帖子浏览量
export function incrementPostViews(postId: number): boolean {
  const postIndex = postList.findIndex(post => post.id === postId);
  if (postIndex !== -1) {
    postList[postIndex].views++;
    return true;
  }
  return false;
}

// 发布新帖子的参数接口
export interface CreatePostInput {
  title: string;
  content: string;
  author: string;
  authorAvatar: string;
  category: string;
  tags: string[];
}

// 发布新帖子
export function createPost(postData: CreatePostInput): Post | null {
  const newPost: Post = {
    id: postList.length + 1,
    title: postData.title,
    content: postData.content,
    author: postData.author,
    authorAvatar: postData.authorAvatar,
    category: postData.category,
    tags: postData.tags,
    likes: 0,
    comments: 0,
    views: 0,
    favorites: 0,
    isLiked: false,
    isFavorited: false,
    createTime: new Date().toLocaleString('zh-CN'),
    updateTime: new Date().toLocaleString('zh-CN')
  };

  postList.unshift(newPost); // 新帖子放在最前面
  return newPost;
}

// 添加评论
export function addComment(postId: number, userId: number, userName: string, userAvatar: string, content: string): Comment | null {
  const postIndex = postList.findIndex(post => post.id === postId);
  if (postIndex === -1) return null;

  const newComment: Comment = {
    id: commentList.length + 1,
    postId,
    userId,
    userName,
    userAvatar,
    content,
    likes: 0,
    replies: [],
    createTime: new Date().toLocaleString('zh-CN'),
    updateTime: new Date().toLocaleString('zh-CN'),
    isLiked: false
  };

  commentList.push(newComment);
  postList[postIndex].comments++;

  return newComment;
}

// 回复评论
export function addReply(commentId: number, userId: number, userName: string, userAvatar: string, content: string): Reply | null {
  const commentIndex = commentList.findIndex(comment => comment.id === commentId);
  if (commentIndex === -1) return null;

  const newReply: Reply = {
    id: commentList[commentIndex].replies.length + 1,
    commentId,
    userId,
    userName,
    userAvatar,
    content,
    likes: 0,
    createTime: new Date().toLocaleString('zh-CN'),
    isLiked: false
  };

  commentList[commentIndex].replies.push(newReply);
  return newReply;
}

// 点赞评论
export function likeComment(commentId: number): boolean {
  const commentIndex = commentList.findIndex(comment => comment.id === commentId);
  if (commentIndex !== -1) {
    commentList[commentIndex].likes++;
    return true;
  }
  return false;
}

// 点赞回复
export function likeReply(commentId: number, replyId: number): boolean {
  const commentIndex = commentList.findIndex(comment => comment.id === commentId);
  if (commentIndex === -1) return false;

  const replyIndex = commentList[commentIndex].replies.findIndex(reply => reply.id === replyId);
  if (replyIndex === -1) return false;

  commentList[commentIndex].replies[replyIndex].likes++;
  return true;
}

// 获取热门帖子
export function getHotPosts(count: number = 5): Post[] {
  return [...postList]
    .sort((a, b) => b.views - a.views)
    .slice(0, count);
}

// 获取最新帖子
export function getLatestPosts(count: number = 5): Post[] {
  return [...postList]
    .sort((a, b) => new Date(b.createTime).getTime() - new Date(a.createTime).getTime())
    .slice(0, count);
}

// 搜索帖子
export function searchPosts(keyword: string): Post[] {
  const lowerKeyword = keyword.toLowerCase();
  return postList.filter(post =>
  post.title.toLowerCase().includes(lowerKeyword) ||
  post.content.toLowerCase().includes(lowerKeyword) ||
  post.tags.some(tag => tag.toLowerCase().includes(lowerKeyword))
  );
}