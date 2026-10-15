# 验证与已知限制

## 可在当前命令环境执行

```text
node --disable-warning=ExperimentalWarning --test tests/*.test.mjs
git diff --check
```

收藏与登录测试执行 `mock/InteractionData.ets`、`mock/UserData.ets` 中的实际逻辑，并检查页面或服务接线；个人中心统计检查以源码结构为主。Node.js 24 的类型剥离能力用于测试纯数据模块；它不编译 ArkUI 页面。`git diff --check` 只检查已跟踪差异，不检查未跟踪文件的代码质量。

## 已在模拟器验证（2026-10-15，OpenHarmony 6.0.2.130）与仍缺少的证据

| 流程 | 已有证据 | 仍缺少的证据 |
| --- | --- | --- |
| 宠物浏览与详情 | `PetList.ets`、`Detail.ets` 源码、HAP 编译及模拟器页面检查 | 物理真机、跨重启行为 |
| 收藏与取消收藏 | `InteractionData.ets` 业务测试、两页接线检查及模拟器复测 2→1→2 通过 | 物理真机、跨重启持久化 |
| 领养申请 | `Apply.ets` 和 `mock/ApplyData.ets` 源码及模拟器提交检查：`00000000000` 被拦截，`13800000000` 下居住选项“否”→“是”并滚动保持，提交成功反馈后“我的申请”新增第 4 条待审核 Mock 记录 | 物理真机、服务端持久化；有提交后列表截图，无成功提示截图 |
| 社区、消息、个人中心 | 页面源码、Mock 数据及模拟器交互检查；个人中心申请数和“我的申请”统计卡均从 3 变 4 | 物理真机、线上数据接入 |
| 推荐、图片预览、走失预警 | 本地演示页面源码及模拟器页面检查，已去除虚构指标；AI/AR/IoT 均为 Mock/演示，没有真实模型、AR 引擎、设备 | 真实 AI/AR/IoT 不在本项目现有能力内 |

1. 同步依赖并构建 `entry`，记录版本、退出码及完整错误。
2. 在手机模拟器或真机启动，确认 Splash、登录、五个主标签页可进入。
3. 在详情收藏一只原先未收藏的宠物；进入“我的收藏”确认出现；取消后返回详情确认心形状态取消；重复点击并检查无重复项。
4. 清空当前用户收藏并检查空状态；退出应用再进入，明确记录内存 Mock 状态是否重置。
5. 检查领养申请、社区、成长档案、推荐、AR、预警页面。演示功能只验收其页面行为，不按真实 API、AR、IoT 能力验收。
6. 在运行设备上采集真实截图，核对其中只出现可公开占位素材，然后放入 `docs/screenshots/`。

2026-10-14 已使用本机 DevEco Studio 附带的 Hvigor：

```text
D:\apps\DevEco Studio\tools\node\node.exe D:\apps\DevEco Studio\tools\hvigor\bin\hvigorw.js assembleHap
```

早期尝试因未设置 `DEVECO_SDK_HOME`、SDK 路径层级不对和不适用的 `--mode debug` 参数失败；最终将 `DEVECO_SDK_HOME` **仅对构建子进程**设为 `D:\apps\DevEco Studio\sdk` 后，`assembleHap` 返回 `BUILD SUCCESSFUL`、进程退出码 0，生成未签名 HAP。随后将 `SafeArea.edges` 改为组件可传入属性并再次成功构建，相关警告由 17 条降为 0；日志仍记录 142 条其他 ArkTS 警告，主要涉及弃用的提示 API、异常处理提示和少量组件属性声明，另有未配置签名提示。完整日志留在被 Git 忽略的 `.build-temp/`。**截至该次构建时安装启动尚未验证，后续已于 2026-10-15 在模拟器上补充安装启动与页面复测，物理真机与跨重启持久化仍未验证**。现有 `entry/src/test/LocalUnit.test.ets` 与 `entry/src/ohosTest/ets/test/Ability.test.ets` 为基础模板测试，不能作为业务质量证明。

2026-10-15 补充验证：

```text
node --disable-warning=ExperimentalWarning --test tests/*.test.mjs
```

29/29 通过，覆盖 Mock 登录/收藏、展示边界及本地素材路径检查；该命令不编译 ArkUI 页面，不能证明设备功能通过；
设备功能以同日模拟器复测为准。

Hvigor `assembleHap` 成功，仍有 ArkTS 警告、产物未签名；反馈页和 Mock 反馈已改用仓库内自绘占位 JPEG。
同日已将该未签名 HAP 在 OpenHarmony 6.0.2.130 模拟器上安装启动并完成上述页面复测；申请和收藏数据均为内存 Mock，
不是服务端持久化。`docs/screenshots/` 中 01–09 共九张为真实模拟器截图；
其中 `06-adoption-form-emulator.png` 是表单初始画面，`09-my-apply-emulator.png` 是提交后的列表状态，本仓库没有提交成功提示截图。

## 发布前的阻塞

- 已有未签名 HAP 编译及模拟器安装启动证据，但物理真机、线上后端、跨重启持久化证据缺失。
- 已有九张模拟器截图，但没有提交成功提示截图；不得声称截图覆盖了成功提示页面。
- 网络来源原图的再分发授权未取得，因此只能发布自行绘制的占位资源；被 Git 忽略的 `.asset_backup/` 不得发布；需核对最终 Git 文件清单。
- 项目代码已采用 MIT 许可证；原始网络图片未获再分发授权，不得发布。
- 不得编造奖项、用户、性能或覆盖率；AI/AR/IoT 均为 Mock/演示。
