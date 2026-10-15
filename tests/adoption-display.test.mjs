import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

// 结构回归测试：防止数字/boolean 被当普通值参数传入多参数 @Builder（按值拷贝，
// @State 更新后不重建，出现申请数/统计卡停留旧值、是否选项点击无变化）。
// 注意：本文件只能证明源码结构，没有在 HarmonyOS 模拟器/真机上做界面验收，
// 不能替代设备验收。

const mine = readFileSync(new URL('../entry/src/main/ets/pages/Mine.ets', import.meta.url), 'utf8');
const myApply = readFileSync(new URL('../entry/src/main/ets/pages/MyApply.ets', import.meta.url), 'utf8');
const apply = readFileSync(new URL('../entry/src/main/ets/pages/Apply.ets', import.meta.url), 'utf8');

test('mine apply count binds reactive state instead of StatItem by-value param', () => {
  // 不允许把 applyCount 当普通值传进三参数 StatItem
  assert.doesNotMatch(mine, /StatItem\([^)]*applyCount/);
  // 申请数字直接读既有 @State applyCount，保持与收藏数修复一致的内联绑定
  assert.match(mine, /Text\(this\.applyCount\.toString\(\)\)/);
  // 仍从既有数据源派生，不新增第二份申请数据
  assert.match(mine, /getUserApplies\s*\(\s*currentUser\.id\s*\)/);
  assert.match(mine, /applyCount\s*=\s*getUserApplies/);
  assert.doesNotMatch(mine, /@State[^;]*applyList|@State[^;]*applies\b/);
  // 保留收藏数修复
  assert.match(mine, /Text\(this\.favoriteCount\.toString\(\)\)/);
  assert.doesNotMatch(mine, /StatItem\([^)]*favoriteCount/);
});

test('myApply stat cards bind reactive stats instead of by-value StatCard param', () => {
  // StatCard 定义不得再接受动态 value:string 参数，只允许静态 key
  assert.doesNotMatch(myApply, /StatCard\(\s*emoji:[^)]*value:\s*string/);
  // 调用处不得把 stats 求值后传入
  assert.doesNotMatch(myApply, /StatCard\([^)]*this\.stats/);
  assert.doesNotMatch(myApply, /StatCard\([^)]*stats\?/);
  // 数值在 StatCard 内部直接读 @State stats，保证异步回填后更新
  assert.match(myApply, /this\.stats\?\.total/);
  assert.match(myApply, /this\.stats\?\.pending/);
  assert.match(myApply, /this\.stats\?\.approved/);
  assert.match(myApply, /this\.stats\?\.rejected/);
  assert.match(myApply, /this\.stats\?\.completed/);
  // 异步完成后与 getUserApplyStats 一致，手动刷新/取消重载走同一路径
  assert.match(myApply, /this\.stats\s*=\s*getUserApplyStats\s*\(\s*currentUser\.id\s*\)/);
  assert.match(myApply, /loadApplies\(\)/);
  assert.match(myApply, /cancelApply[\s\S]*loadApplies/);
  // 保留列表和筛选布局，不重写页面
  assert.match(myApply, /StatusFilter\(\)/);
  assert.match(myApply, /ApplyList\(\)/);
  assert.match(myApply, /ForEach\(this\.applies/);
});

test('apply toggle fields bind reactive formData instead of by-value boolean', () => {
  // ToggleField 定义不得再接受普通 boolean 值参数
  assert.doesNotMatch(apply, /ToggleField\(\s*label:\s*string\s*,\s*value:\s*boolean/);
  // 调用处不得把 boolean 状态当值传入，只允许静态 fieldKey
  assert.doesNotMatch(apply, /ToggleField\([^)]*formData\.(hasYard|petAllowed)/);
  assert.doesNotMatch(apply, /ToggleField\([^)]*this\.formData/);
  assert.match(apply, /ToggleField\('是否有庭院或阳台',\s*'hasYard'/);
  assert.match(apply, /ToggleField\('居住地是否允许养宠物',\s*'petAllowed'/);
  // 显示与切换都直接读写 @State formData，随滚动保持
  assert.match(apply, /this\.formData\.hasYard \? '✓ 是' : '✗ 否'/);
  assert.match(apply, /this\.formData\.petAllowed \? '✓ 是' : '✗ 否'/);
  assert.match(apply, /onChange\(!this\.formData\.hasYard\)/);
  assert.match(apply, /onChange\(!this\.formData\.petAllowed\)/);
  // 保留现有表单校验和提交逻辑
  assert.match(apply, /\/\^1\[3-9\]\\d\{9\}\$\//);
  assert.match(apply, /请选择居住类型/);
  assert.match(apply, /请填写领养计划/);
  assert.match(apply, /请阅读并同意领养协议/);
  assert.match(apply, /createApply\s*\(/);
});
