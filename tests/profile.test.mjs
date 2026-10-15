import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const mine = readFileSync(new URL('../entry/src/main/ets/pages/Mine.ets', import.meta.url), 'utf8');
const growth = readFileSync(new URL('../entry/src/main/ets/pages/PetGrowthProfile.ets', import.meta.url), 'utf8');

test('profile statistics are derived from this user’s mock records', () => {
  assert.doesNotMatch(mine, /Math\.random\s*\(/);
  assert.match(mine, /getUserFavoriteRecords\s*\(\s*currentUser\.id\s*\)/);
  assert.match(mine, /getUserViewRecords\s*\(\s*currentUser\.id\s*\)/);
  assert.match(mine, /getUserApplies\s*\(\s*currentUser\.id\s*\)/);
});

// 结构回归：收藏统计数字必须直接绑定 this.favoriteCount，而不是作为普通值参数
// 传给 @Builder StatItem（按值参数不会随 @State 变化重建）。此检查仅证明源码结构，
// 不能代替真机/模拟器上的界面验收。
test('favorite count is bound to reactive state instead of passed by value into StatItem', () => {
  assert.doesNotMatch(mine, /StatItem\([^)]*favoriteCount/);
  assert.match(mine, /Text\(this\.favoriteCount\.toString\(\)\)/);
});

test('growth record buttons do not pretend to open nonexistent forms', () => {
  assert.doesNotMatch(growth, /正在打开记录表单|添加健康记录\.\.\.|体重记录功能\.\.\.|护理记录功能\.\.\./);
});
