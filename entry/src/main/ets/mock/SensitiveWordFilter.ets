// Trie字典树敏感词过滤
class TrieNode {
  isEnd: boolean = false;
  children: Map<string, TrieNode> = new Map();
}

// 定义过滤结果接口
interface FilterResult {
  hasSensitive: boolean;
  filteredText: string;
  sensitiveWords: string[];
}

export class SensitiveWordFilter {
  private root: TrieNode;

  constructor() {
    this.root = new TrieNode();
  }

  // 添加敏感词
  addWord(word: string): void {
    let node = this.root;
    for (const char of word) {
      if (!node.children.has(char)) {
        node.children.set(char, new TrieNode());
      }
      node = node.children.get(char)!;
    }
    node.isEnd = true;
  }

  // 批量添加敏感词
  addWords(words: string[]): void {
    for (const word of words) {
      this.addWord(word);
    }
  }

  // 检查是否包含敏感词
  containsSensitiveWord(text: string): boolean {
    const length = text.length;
    for (let i = 0; i < length; i++) {
      let node: TrieNode | undefined = this.root;
      for (let j = i; j < length; j++) {
        const char = text[j];
        node = node?.children.get(char);
        if (!node) {
          break;
        }
        if (node.isEnd) {
          return true;
        }
      }
    }
    return false;
  }

  // 获取所有敏感词
  getSensitiveWords(text: string): string[] {
    const sensitiveWords: string[] = [];
    const length = text.length;

    for (let i = 0; i < length; i++) {
      let node: TrieNode | undefined = this.root;
      for (let j = i; j < length; j++) {
        const char = text[j];
        node = node?.children.get(char);
        if (!node) {
          break;
        }
        if (node.isEnd) {
          sensitiveWords.push(text.substring(i, j + 1));
          break;
        }
      }
    }

    return sensitiveWords;
  }

  // 过滤敏感词（替换为*）
  filterText(text: string, replaceChar: string = '*'): string {
    const length = text.length;
    let result = text;
    const sensitiveWords = this.getSensitiveWords(text);

    for (const word of sensitiveWords) {
      const replacement = replaceChar.repeat(word.length);
      result = result.replace(new RegExp(word, 'g'), replacement);
    }

    return result;
  }

  // 检查并过滤文本
  checkAndFilter(text: string): FilterResult {
    const sensitiveWords = this.getSensitiveWords(text);
    const hasSensitive = sensitiveWords.length > 0;
    const filteredText = hasSensitive ? this.filterText(text) : text;

    const result: FilterResult = {
      hasSensitive: hasSensitive,
      filteredText: filteredText,
      sensitiveWords: sensitiveWords
    };

    return result;
  }
}

// 预定义的敏感词库
export const defaultSensitiveWords: string[] = [
  // 政治相关
  "反动", "分裂", "颠覆", "暴乱", "示威",

  // 暴力相关
  "杀人", "放火", "抢劫", "强奸", "暴力",

  // 色情相关
  "色情", "淫秽", "嫖娼", "卖淫", "性交",

  // 侮辱性词汇
  "傻逼", "草泥马", "妈的", "混蛋", "白痴",

  // 广告相关
  "赌博", "彩票", "毒品", "迷药", "假证",

  // 其他
  "法轮功", "邪教", "迷信", "诈骗"
];

// 创建默认的敏感词过滤器
export function createDefaultFilter(): SensitiveWordFilter {
  const filter = new SensitiveWordFilter();
  filter.addWords(defaultSensitiveWords);
  return filter;
}

// 过滤帖子标题和内容
interface PostFilterResult {
  title: FilterResult;
  content: FilterResult;
  hasSensitive: boolean;
}

export function filterPost(title: string, content: string): PostFilterResult {
  const filter = createDefaultFilter();
  const titleResult = filter.checkAndFilter(title);
  const contentResult = filter.checkAndFilter(content);

  return {
    title: titleResult,
    content: contentResult,
    hasSensitive: titleResult.hasSensitive || contentResult.hasSensitive
  };
}