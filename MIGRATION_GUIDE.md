# OpenClaw Clone 迁移指南

本指南帮助您将 OpenClaw 从一台电脑克隆到另一台电脑，保留所有配置、凭证和记忆。

## 脚本说明

| 脚本 | 用途 |
|-----|------|
| `pack.sh` | 旧电脑端 - 打包数据 |
| `restore.sh` | 新电脑端 - 恢复数据 |
| `verify.sh` | 验证安装状态 |

## 快速开始

### 第一步：旧电脑打包

```bash
git clone https://github.com/zrh091110225/openclaw-clone.git
cd openclaw-clone
./pack.sh
```

脚本会：
1. 检查并停止 OpenClaw Gateway
2. 让你选择要打包的模块
3. 生成迁移包到 `~/openclaw-migration/`

### 第二步：传输迁移包

将 `~/openclaw-migration/` 目录复制到新电脑：
- U 盘
- 局域网传输 (SCP, Rsync)
- AirDrop / 隔空投送

### 第三步：新电脑恢复

```bash
git clone https://github.com/zrh091110225/openclaw-clone.git
cd openclaw-clone
./restore.sh
```

脚本会：
1. 检查 OpenClaw 安装状态（未安装则提示安装）
2. 停止 Gateway
3. 备份现有数据（如果有）
4. 恢复数据并修复权限
5. **运行 `openclaw doctor`**（官方推荐的关键步骤）
6. 启动 Gateway 并验证

### 第四步：验证

```bash
./verify.sh
```

## 模块说明

| 模块 | 说明 | 默认 | 跨平台 |
|-----|------|:----:|:------:|
| config | openclaw.json - 模型、渠道、认证配置 | ✅ | ✅ |
| credentials | 渠道凭证 - 飞书/Telegram等 token | ✅ | ✅ |
| workspace | 工作区 - AGENTS.md、SOUL.md、记忆等 | ✅ | ✅ |
| memory | 对话历史 | ✅ | ✅ |
| cron | 定时任务 | ❌ | ✅ |
| devices | 设备配对 | ❌ | ⚠️ |
| extensions | 已安装扩展 | ❌ | ❌ |

**注意**：
- extensions 跨平台不兼容，建议在新电脑重新安装
- devices 与硬件绑定，需在新电脑重新配对

## 常见问题

### Q: 迁移后渠道需要重新登录吗？
A: 不需要。credentials 目录包含了渠道状态，迁移后自动保留。

### Q: 跨平台迁移（Mac → Linux）有影响吗？
A: 核心数据（config/credentials/workspace/memory）完全兼容。extensions 需要重新安装。

### Q: 迁移包安全吗？
A: 迁移包包含敏感数据，建议：
- 使用加密压缩传输
- 迁移完成后及时删除
- 如怀疑泄露，轮换 API 密钥

### Q: 官方文档推荐什么步骤？
A: 官方强调使用 `openclaw doctor` 修复配置，本脚本已集成此步骤。

## 验证清单

迁移完成后，请确认：
- [ ] `openclaw status` 显示 Gateway 正在运行
- [ ] 各渠道仍然连接（无需重新登录）
- [ ] 工作区文件存在（记忆、配置）
- [ ] 对话历史完整

## 相关文档

- [OpenClaw 官方文档](https://docs.openclaw.ai)
- [OpenClaw Doctor](https://docs.openclaw.ai/gateway/doctor)
- [数据存储位置 FAQ](https://docs.openclaw.ai/help/faq#where-does-openclaw-store-its-data)
