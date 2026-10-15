import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { stripTypeScriptTypes } from 'node:module';

test('mock login rejects an incorrect password and accepts a demo account', async () => {
  const source = readFileSync(new URL('../entry/src/main/ets/mock/UserData.ets', import.meta.url), 'utf8');
  const javascript = stripTypeScriptTypes(source, { mode: 'strip' });
  const users = await import(`data:text/javascript;base64,${Buffer.from(javascript).toString('base64')}`);
  const demo = users.userList[0];
  assert.equal(users.login(demo.username, 'invalid-password').success, false);
  const result = users.login(demo.username, demo.password);
  assert.equal(result.success, true);
  assert.equal(result.user.id, demo.id);
});

test('ApiService login delegates to mock credential validation', () => {
  const source = readFileSync(new URL('../entry/src/main/ets/services/ApiService.ets', import.meta.url), 'utf8');
  assert.match(source, /loginMock\s*\(\s*username\s*,\s*password\s*\)/);
  assert.match(source, /result\.success\s*&&\s*result\.user/);
});
