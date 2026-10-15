# 本地开发与运行

## 环境

项目配置指定 HarmonyOS SDK 目标和兼容版本 `6.0.2(22)`，Stage 模型，单 `entry` 模块，手机设备。依赖声明见根目录和 `entry/oh-package.json5`；不要提交本机 `local.properties`、`oh_modules`、构建缓存或签名文件。

1. 在 DevEco Studio 中打开仓库根目录，安装或选择与项目配置匹配的 HarmonyOS SDK。
2. 让 IDE 同步依赖；如果同步失败，记录 IDE、SDK 和错误输出，不要修改版本来掩盖失败。
3. 选择 `entry` 模块和手机模拟器或真机，按 IDE 的 **Run** 操作构建、安装、启动。真机使用个人调试签名，密钥不得加入仓库。[官方真机运行说明](https://developer.huawei.com/consumer/cn/doc/HarmonyOS-Guides/ide-hmos-run-device)
4. 启动后先检查 `Splash → MainTab → PetList → Detail`，再按 [`testing.md`](testing.md) 检查收藏及其他演示流程。

本仓库没有自带 `hvigorw`，但本地 DevEco Studio 安装目录带有 Hvigor、Node 和 HDC。2026-10-14 在**仅针对构建子进程**设置 `DEVECO_SDK_HOME=D:\apps\DevEco Studio\sdk` 与项目内的 `HVIGOR_USER_HOME` 后，运行：

```text
D:\apps\DevEco Studio\tools\node\node.exe D:\apps\DevEco Studio\tools\hvigor\bin\hvigorw.js assembleHap
```

该命令完成 ArkTS 编译和 `entry/build/default/outputs/default/entry-default-unsigned.hap` 打包。前几次试验因 SDK 路径层级或不适用的 `--mode debug` 参数失败，完整日志保存在被 Git 忽略的 `.build-temp/`。构建仍有部分 ArkTS 警告；因为 `signingConfigs` 为空，产物未签名。未修改系统环境变量或签名配置。

2026-10-15 已将上述未签名 HAP 在 OpenHarmony 6.0.2.130 模拟器上成功安装启动，并检查了首页、列表、详情、
收藏/取消、我的收藏、领养申请、社区和个人中心。收藏及个人中心计数 2→1→2 的设备复测通过；
领养申请中无效手机号 `00000000000` 被拦截，改用纯演示号码 `13800000000` 后两个居住选项可以从“否”切成“是”
并在页面滚动后保持，提交后出现成功反馈，返回详情后“我的申请”新增第 4 条待审核 Mock 记录，
个人中心申请数和“我的申请”统计卡均从 3 变 4。以上仅是模拟器、内存 Mock 证据，不是物理真机、线上后端或跨重启持久化证据。

## 数据及资源

账号、宠物、帖子、通知都是本地示例数据。`ApiService` 不连接网络服务。`tools/generate_placeholder_assets.py` 使用 Pillow 绘制仓库中的宠物、头像和图标占位资源；运行 App 不需要 Pillow，只有重新生成占位图时才需要。原网络图片仅存在 Git 忽略的本地 `.asset_backup/`。克隆仓库后不需要备份目录即可展示占位图。不要把 `html/` 早期参考资料当作真实 App 截图。
