# 简历项目经历（已有模拟器验证，仅限如实表述）

**宠缘 · HarmonyOS 宠物领养交互原型｜独立开发**

独立使用 ArkTS、ArkUI 与 Stage 模型开发鸿蒙宠物领养交互原型，实现宠物浏览、详情、收藏、领养申请和社区页面。按组件、路由与 Mock 数据组织工程，统一详情页、收藏页及个人中心的内存状态，补充可执行测试。通过 Hvigor 构建，并在 OpenHarmony 模拟器复测收藏同步和申请提交；以自绘占位图处理公开素材风险。AI、AR、IoT 仅为演示，未接入真实服务。

可根据投递岗位选择以下**有源码依据**的亮点，不要把全部堆入简历：

- ArkUI 页面与五标签导航组织：[`MainTab.ets`](../entry/src/main/ets/pages/MainTab.ets)、[`RouterHelper.ets`](../entry/src/main/ets/router/RouterHelper.ets)。
- 宠物列表筛选、详情与领养申请的页面交互：[`PetList.ets`](../entry/src/main/ets/pages/PetList.ets)、[`Detail.ets`](../entry/src/main/ets/pages/Detail.ets)、[`Apply.ets`](../entry/src/main/ets/pages/Apply.ets)。数据为 Mock。
- 按用户区分的收藏互动记录与状态一致性验证：[`InteractionData.ets`](../entry/src/main/ets/mock/InteractionData.ets)、[`favorites.test.mjs`](../tests/favorites.test.mjs)。使用前应确认测试最终通过。
- 明确演示与真实接入边界，并处理公开素材授权风险：[`architecture.md`](architecture.md)、[`generate_placeholder_assets.py`](../tools/generate_placeholder_assets.py)。

**使用条件：** 已有 ArkTS 编译、未签名 HAP 打包及模拟器安装启动复测记录，但不宣称物理真机验收、真实 AI/AR/IoT 接入、线上运营、奖项、用户规模、性能或覆盖率。已核对九张模拟器截图（01–09），其中 `06-adoption-form-emulator.png` 为表单初始画面，`09-my-apply-emulator.png` 为提交后的列表状态；没有成功提示截图。项目代码采用 MIT 许可证，原始网络图片不得发布。
