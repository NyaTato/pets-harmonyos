import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const page = (name) => readFileSync(new URL(`../entry/src/main/ets/pages/${name}.ets`, import.meta.url), 'utf8');

test('home labels and demo pages disclose simulated AI, AR, and IoT', () => {
  const home = page('Index');
  const recommendation = page('SmartRecommendation');
  const ar = page('ARPreview');
  const iot = page('PetLostWarning');
  const demo = page('InnovationDemo');
  const match = page('MatchTest');
  assert.match(home, /推荐匹配（演示）/);
  assert.match(home, /图片预览（演示）/);
  assert.match(home, /走失预警（模拟）/);
  assert.match(recommendation, /不调用 AI 模型/);
  assert.match(ar, /没有接入相机或 AR 引擎/);
  assert.match(iot, /未连接定位设备或通知服务/);
  assert.match(demo, /功能演示中心/);
  assert.match(demo, /所有入口均按演示功能展示/);
  assert.match(match, /95（示例）/);
});

test('demo pages do not publish invented performance or adoption metrics', () => {
  const text = [page('SmartRecommendation'), page('ARPreview'), page('PetLostWarning'),
    page('InnovationDemo')].join('\n');
  assert.doesNotMatch(text, /96\.3%|12K\+|12,000\+|1,247只|60FPS|±3cm|99\.7%|64\.3%|12,847|34,521|5,632/);
  assert.doesNotMatch(text, /节省约40%|500万只宠物走失|已自动启动三级响应/);
});
