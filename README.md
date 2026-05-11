# my-cc-skills

> Claude Code 实用技能库 & Prompt 集合，汇总自实际开发工作中的经验积累。

## 目录结构

```
my-cc-skills/
├── prompt/                          # Prompt 模板
│   └── 工程师行为准则.md             # Senior Software Engineer 行为准则
├── skills/                          # Claude Code 技能
│   ├── ascii-er-diagram/            # ASCII ER 图生成
│   ├── caveman/                     # (开发中)
│   ├── code-reverse-engineering/    # 代码逆向分析
│   ├── docx/                        # Word 文档处理
│   ├── drawio/                      # draw.io 图表生成
│   ├── grill-me/                    # 设计方案压力测试
│   ├── pdf/                         # PDF 处理
│   ├── readme-commit-push/          # README 更新 + Git 提交推送
│   ├── skill-creator/               # Skill 创建与优化
│   └── xlsx/                        # Excel 表格处理
├── hooks/                           # Claude Code 钩子脚本
│   └── windows-notification/        # Windows 桌面通知
└── LICENSE
```

## Skills

### ascii-er-diagram — ASCII ER 图生成

生成数据库表的纯文本 ASCII 格式 ER 图。

- 中文表名和字段含义，附带业务用途说明
- 外键关联写明具体字段名（格式 `FK 字段名 → 父表.字段名`）
- 多态关联、状态枚举值自动标注
- 表数量超过 10 张时自动附加外键关系汇总表
- 按功能域分组输出，主表在上、从表在下
- **关键验证规则**：表使用验证（以实际业务调用为准而非类名）、关系基数判断（基于业务逻辑而非数据库约束）、搜索结果交叉验证（Grep 二次验证核心引用）

**许可**: [MIT](skills/ascii-er-diagram/LICENSE) — Elon Z (2026)

---

### code-reverse-engineering — 代码逆向分析

基于真实代码而非假设进行业务逻辑分析的技能。

- 禁止基于方法名/参数名做假设，必须查看实际实现
- 包含历史教训案例、验证 Checklist、常见陷阱对照表
- 配置 `auto_load: true`，分析代码时自动加载

**许可**: [MIT](skills/code-reverse-engineering/LICENSE) — Elon Z (2026)

---

### docx — Word 文档处理

完整的 `.docx` 文件创建、读取、编辑和处理能力。

- **创建**: 使用 docx-js 生成，支持表格、图片、目录、页眉页脚、脚注等
- **编辑**: Unpack → 编辑 XML → Pack 三步流程
- **高级特性**: 修订痕迹、批注、格式转换、LibreOffice 集成

**许可**: [Anthropic 专有许可](skills/docx/LICENSE.txt) — Anthropic, PBC (2025)

---

### drawio — draw.io 图表生成

生成 draw.io 图表文件，支持导出为 PNG/SVG/PDF。

- 支持流程图、架构图、ER 图、序列图、类图等多种图表类型
- 直接生成 mxGraphModel XML 格式
- 支持 draw.io CLI 导出，自动适配 WSL2/macOS/Linux/Windows 平台
- 集成边路由后处理优化（@drawio/postprocess）
- 包含完整的 XML 参考规范和故障排除指南

**许可**: [Apache 2.0](skills/drawio/LICENSE) — JGraph Ltd (2025)

---

### grill-me — 设计方案压力测试

针对计划或设计对用户进行深度追问，直到达成共识，逐一解决决策树的每个分支。

- 当用户想要压力测试计划、被"拷问"设计方案，或提到"grill me"、"拷问我"、"挑战我的方案"时使用
- 通过递进式追问帮助发现设计盲点和权衡缺失

**许可**: [MIT](skills/grill-me/LICENSE) — Matt Pocock (2026)

---

### pdf — PDF 处理

PDF 文件的全面处理能力。

- 文本/表格提取（pdfplumber）
- 合并、分割、旋转、水印、密码保护
- 可填写表单处理（pypdf/pdf-lib）
- OCR 扫描 PDF（pytesseract）
- 图片提取（pdfimages/poppler）
- 新 PDF 创建（reportlab）

**许可**: [Anthropic 专有许可](skills/pdf/LICENSE.txt) — Anthropic, PBC (2025)

---

### readme-commit-push — README 更新 + Git 提交推送

根据项目最新代码变更自动更新 README 文档，创建规范的 git commit，并推送到远程仓库。

- 自动分析 git diff 和最近提交记录，理解变更类型
- 按功能新增、Bug 修复、重构优化等类型智能判断是否需要更新 README
- 遵循项目现有 README 风格进行更新
- 生成符合规范的 commit message（feat/fix/docs/refactor/chore）
- 自动 push 到远程仓库
- 内置安全检查，避免误提交敏感文件或构建产物

**许可**: [MIT](skills/readme-commit-push/LICENSE) — Elon Z (2026)

---

### skill-creator — Skill 创建与优化

创建新 Skill、迭代优化已有 Skill，并通过量化评估验证效果。

- 从需求到草稿再到测试用例的完整创建流程
- 支持批量运行测试 prompt 并量化评估 Skill 表现
- 内置 eval-viewer 可视化查看运行结果
- Skill 描述优化器，自动提升 Skill 触发准确率

**许可**: [Anthropic 专有许可](skills/skill-creator/LICENSE.txt) — Anthropic, PBC (2025)

---

### xlsx — Excel 表格处理

Excel 电子表格（`.xlsx`/`.xlsm`/`.csv`/`.tsv`）的创建、编辑和分析。

- 使用 pandas 进行数据分析，openpyxl 进行格式化和公式
- 财务模型标准：颜色编码、数字格式、公式构造规则
- 公式重计算：LibreOffice 自动重算并验证错误

**许可**: [Anthropic 专有许可](skills/xlsx/LICENSE.txt) — Anthropic, PBC (2025)

## Hooks

### windows-notification — Windows 桌面通知

Claude Code 的 Windows 桌面通知钩子，在 AI 等待用户输入、需要审批或任务完成时弹出通知窗口。

- **触发时机**: `AskUserQuestion` 钩子（AI 等待回复）、`PermissionRequest` 钩子（需要审批）、`Stop` 钩子（任务完成）
- **实现方式**: 基于 WPF 自定义窗口，无边框半透明设计，屏幕居中显示，紫色主题带发光阴影
- **用户体验**: 400ms 淡入动画，10 秒自动关闭，点击任意位置手动关闭，不抢夺输入焦点
- **技术细节**: PowerShell 脚本 + WPF XAML，通过 `DropShadowEffect` 实现发光效果

#### 实际运行效果图
需要审批
<img width="248" height="156" alt="image" src="https://github.com/user-attachments/assets/1c7831db-3010-45f4-b1fe-7d2e376ae15b" />

任务完成
<img width="246" height="153" alt="image" src="https://github.com/user-attachments/assets/62502c03-9177-4b39-aa84-c324fe0715d5" />



**许可**: MIT — Elon Z (2026)

---

## Prompts

### 工程师行为准则

定义 AI 在 agentic coding 工作流中作为高级软件工程师的行为规范。

- **核心行为**: 分析（使用 code-reverse-engineering skill）、假设声明、混乱管理、必要时的反驳、简单性执行、范围纪律、死代码卫生
- **杠杆模式**: 声明式优于命令式、测试优先、先简单后优化、内联计划
- **输出标准**: 代码质量、沟通、变更描述
- **失败模式**: 列出 12 种需要避免的常见错误

**许可**: [MIT](prompt/LICENSE) — Elon Z (2026)

---

## 许可

| 模块 | 许可 | 作者 |
|------|------|------|
| ascii-er-diagram | MIT | Elon Z (2026) |
| code-reverse-engineering | MIT | Elon Z (2026) |
| grill-me | MIT | Matt Pocock (2026) |
| readme-commit-push | MIT | Elon Z (2026) |
| 工程师行为准则 | MIT | Elon Z (2026) |
| drawio | Apache 2.0 | JGraph Ltd (2025) |
| docx | Anthropic 专有许可 | Anthropic, PBC (2025) |
| pdf | Anthropic 专有许可 | Anthropic, PBC (2025) |
| skill-creator | Anthropic 专有许可 | Anthropic, PBC (2025) |
| xlsx | Anthropic 专有许可 | Anthropic, PBC (2025) |
| windows-notification | MIT | Elon Z (2026) |

自研内容采用 [MIT License](LICENSE)，drawio 技能采用 [Apache 2.0 License](skills/drawio/LICENSE)（JGraph Ltd），grill-me 技能采用 [MIT License](skills/grill-me/LICENSE)（Matt Pocock），其他来自 Anthropic 官方 Skill 目录的内容采用其对应的 [Anthropic 专有许可](skills/docx/LICENSE.txt)。
