import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, existsSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const root = fileURLToPath(new URL('../', import.meta.url));
const feedback = readFileSync(path.join(root, 'entry/src/main/ets/pages/Feedback.ets'), 'utf8');
const notices = readFileSync(path.join(root, 'entry/src/main/ets/mock/NoticeData.ets'), 'utf8');

test('feedback mock images use packaged placeholders instead of remote photos', () => {
  assert.doesNotMatch(feedback + notices, /https?:\/\//i);
  assert.match(feedback, /Image\(\$rawfile\(image\)\)/);
  assert.match(feedback, /示例图片|示例图/);

  const selector = feedback.match(/private selectImage\(\): void \{([\s\S]*?)\n  \}/)?.[1];
  assert.ok(selector, 'feedback image selector exists');
  const paths = [...selector.matchAll(/['"]((?:pets|avatars)\/[^'"]+\.jpg)['"]/g)]
    .map((match) => match[1]);
  assert.ok(paths.length > 0, 'image selector uses local packaged images');
  for (const name of paths) {
    assert.ok(existsSync(path.join(root, 'entry/src/main/resources/rawfile', name)), name);
  }
});

test('seeded feedback references only packaged images when images are present', () => {
  const imageFields = [...notices.matchAll(/images:\s*\[([^\]]*)\]/g)];
  assert.ok(imageFields.length > 0);
  for (const field of imageFields) {
    for (const [, name] of field[1].matchAll(/['"]([^'"]+)['"]/g)) {
      assert.match(name, /^(pets|avatars)\/[^/]+\.jpg$/);
      assert.ok(existsSync(path.join(root, 'entry/src/main/resources/rawfile', name)), name);
    }
  }
});
