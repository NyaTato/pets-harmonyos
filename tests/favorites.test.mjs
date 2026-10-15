import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { stripTypeScriptTypes } from 'node:module';

const source = (path) => readFileSync(new URL(path, import.meta.url), 'utf8');

async function freshInteractions() {
  const arkts = source('../entry/src/main/ets/mock/InteractionData.ets');
  const javascript = stripTypeScriptTypes(arkts, { mode: 'strip' });
  return import(`data:text/javascript;base64,${Buffer.from(javascript).toString('base64')}#${Math.random()}`);
}

test('favorite records toggle once, remain user-specific, and never duplicate', async () => {
  const records = await freshInteractions();
  const user = 9876;
  const pet = 1;
  assert.equal(records.hasFavoritedPet(user, pet), false);
  records.addFavoriteRecord(user, pet);
  assert.equal(records.hasFavoritedPet(user, pet), true);
  assert.equal(records.getUserFavoriteRecords(user).filter((item) => item.petId === pet).length, 1);
  records.addFavoriteRecord(user, pet);
  assert.equal(records.hasFavoritedPet(user, pet), false);
  assert.equal(records.getUserFavoriteRecords(user).length, 0);
  assert.equal(records.hasFavoritedPet(1, pet), true);
});

test('favorite record IDs remain unique after removing an earlier record', async () => {
  const records = await freshInteractions();
  records.addFavoriteRecord(1, 5);
  records.addFavoriteRecord(9876, 2);
  const ids = records.favoriteRecords.map((record) => record.id);
  assert.equal(new Set(ids).size, ids.length);
});

test('detail and favorites pages use the same record source', () => {
  const detail = source('../entry/src/main/ets/pages/Detail.ets');
  const favorites = source('../entry/src/main/ets/pages/MyFavorites.ets');
  assert.match(detail, /hasFavoritedPet\s*\(/);
  assert.match(detail, /addFavoriteRecord\s*\(/);
  assert.match(favorites, /getUserFavoritePets\s*\(/);
  assert.match(favorites, /addFavoriteRecord\s*\(/);
  assert.doesNotMatch(detail, /this\.isFavorite\s*=\s*this\.pet\.isFavorited/);
});

test('favorite change notification drives personal-center recount (2->1->2)', async () => {
  const records = await freshInteractions();
  assert.equal(typeof records.subscribeFavoriteChanges, 'function');
  assert.equal(typeof records.getFavoriteVersion, 'function');

  // 模拟 Mine：订阅后按当前用户重读收藏数
  let mineCount = records.getUserFavoriteRecords(1).length;
  assert.equal(mineCount, 2);
  const seenVersions = [];
  const unsubscribe = records.subscribeFavoriteChanges((version) => {
    seenVersions.push(version);
    mineCount = records.getUserFavoriteRecords(1).length;
  });

  // 我的收藏取消橘猫：Mine 应被推送并重读为 1
  records.addFavoriteRecord(1, 1);
  assert.equal(mineCount, 1);
  assert.equal(records.getUserFavoriteRecords(1).length, 1);

  // 详情重新收藏：Mine 应被推送并恢复为 2，无重复
  records.addFavoriteRecord(1, 1);
  assert.equal(mineCount, 2);
  assert.deepEqual(records.getUserFavoriteRecords(1).map((item) => item.petId).sort(), [1, 5]);

  // 其他用户变更也会推送版本号，但当前用户计数只跟随自身记录
  const before = mineCount;
  records.addFavoriteRecord(2, 4);
  assert.equal(records.getUserFavoriteRecords(1).length, before);
  records.addFavoriteRecord(2, 4);

  // 取消订阅后不再推送
  const pushed = seenVersions.length;
  assert.ok(pushed >= 3);
  unsubscribe();
  records.addFavoriteRecord(1, 1);
  assert.equal(seenVersions.length, pushed);
  // 恢复默认数据，避免影响其他用例（每个用例 fresh 模块已隔离，此处仅复位本模块）
  records.addFavoriteRecord(1, 1);
});

test('mine survives push/back without losing subscription and refreshes on return/tab (2->1->2)', async () => {
  const records = await freshInteractions();
  const userId = 1;
  // 按 Mine.ets 修正后的生命周期建模：appear 订阅；disappear 刻意不取消；
  // MainTab 返回/切 Tab 时走外部刷新（补订阅 + 按当前用户重读）。
  const mine = {
    count: 0,
    uid: userId,
    unsubscribe: null,
    pushes: 0,
    load(uid) {
      mine.uid = uid;
      mine.count = uid == null ? 0 : records.getUserFavoriteRecords(uid).length;
    },
    ensureSubscribed() {
      if (mine.unsubscribe) {
        return;
      }
      mine.unsubscribe = records.subscribeFavoriteChanges(() => {
        mine.pushes += 1;
        // 与 Mine.loadUserInfo 一致：每次推送都按“当前”用户重读，不捕获旧 uid。
        mine.count = mine.uid == null ? 0 : records.getUserFavoriteRecords(mine.uid).length;
      });
    },
    appear(uid) {
      mine.load(uid);
      mine.ensureSubscribed();
    },
    // 模拟 push MyFavorites/Detail：旧缺陷在此取消订阅，新逻辑必须保持订阅。
    disappearForPush() {
    },
    // 模拟 MainTab.onPageShow 自增 refreshKey / Tab 选中变化触发的 @Watch。
    externalRefresh(uid) {
      mine.ensureSubscribed();
      mine.load(uid);
    },
    destroy() {
      if (mine.unsubscribe) {
        mine.unsubscribe();
        mine.unsubscribe = null;
      }
    }
  };

  // 进入个人中心：默认 2 条（橘猫 1、波斯猫 5）。
  mine.appear(userId);
  assert.equal(mine.count, 2);

  // push 我的收藏：disappear 不得丢订阅。
  mine.disappearForPush();
  // 在我的收藏取消橘猫：推送应直接把 Mine 从 2 带到 1。
  records.addFavoriteRecord(userId, 1);
  assert.equal(mine.pushes, 1);
  assert.equal(mine.count, 1);
  assert.equal(records.getUserFavoriteRecords(userId).length, mine.count);

  // 路由返回个人中心：MainTab 刷新戳变化再重读，仍为 1。
  mine.externalRefresh(userId);
  assert.equal(mine.count, 1);

  // 切到底部领养 Tab 再回个人中心：重读仍为 1，不回弹到 2。
  mine.externalRefresh(userId);
  assert.equal(mine.count, 1);

  // 从详情重新收藏橘猫：推送把 Mine 从 1 带回 2，无重复。
  records.addFavoriteRecord(userId, 1);
  assert.equal(mine.count, 2);
  assert.deepEqual(records.getUserFavoriteRecords(userId).map((item) => item.petId).sort(), [1, 5]);
  mine.externalRefresh(userId);
  assert.equal(mine.count, 2);

  // 无登录显示 0，不能混入其他用户记录。
  mine.load(null);
  assert.equal(mine.count, 0);
  assert.equal(records.getUserFavoriteRecords(2).length, 1);
  mine.load(userId);
  assert.equal(mine.count, 2);

  // 只有真正销毁才取消订阅：销毁后推送不再进入。
  const pushesBeforeDestroy = mine.pushes;
  mine.destroy();
  records.addFavoriteRecord(userId, 1);
  assert.equal(mine.pushes, pushesBeforeDestroy);
  assert.equal(mine.count, 2);
  records.addFavoriteRecord(userId, 1);
});

test('personal center count follows unfavorite/refavorite and stays user-specific', async () => {
  const records = await freshInteractions();
  // 缺陷复现：默认用户 1 有 2 条收藏（宠物 1 橘猫、宠物 5 波斯猫）
  assert.equal(records.getUserFavoriteRecords(1).length, 2);
  // 在“我的收藏”取消橘猫后，个人中心重读应为 1，且与列表长度一致
  records.addFavoriteRecord(1, 1);
  assert.equal(records.hasFavoritedPet(1, 1), false);
  assert.equal(records.getUserFavoriteRecords(1).length, 1);
  // 其他用户记录不受影响，无登录/未知用户显示 0
  assert.equal(records.getUserFavoriteRecords(2).length, 1);
  assert.equal(records.getUserFavoriteRecords(999999).length, 0);
  // 从详情重新收藏后，个人中心重读应恢复为 2，且无重复记录
  records.addFavoriteRecord(1, 1);
  assert.equal(records.hasFavoritedPet(1, 1), true);
  const userPets = records.getUserFavoriteRecords(1).map((item) => item.petId).sort();
  assert.deepEqual(userPets, [1, 5]);
});
