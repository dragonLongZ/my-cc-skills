# my-cc-skills

> Claude Code 实用技能库 & Prompt 集合，汇总自实际开发工作中的经验积累。

## 目录结构

```
my-cc-skills/
├── prompt/                          # Prompt 模板
│   └── 工程师行为准则.md             # Senior Software Engineer 行为准则
├── skills/                          # Claude Code 技能
│   ├── code-reverse-engineering/    # 代码逆向分析
│   ├── docx/                        # Word 文档处理
│   ├── drawio/                      # draw.io 图表生成
│   ├── pdf/                         # PDF 处理
│   └── xlsx/                        # Excel 表格处理
└── LICENSE
```

## Skills

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

- 支持流程图、架构图、ER 图等多种图表类型
- 直接生成 mxGraphModel XML 格式
- 支持 draw.io CLI 导出

**许可**: 同根目录 [MIT](LICENSE)

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

### xlsx — Excel 表格处理

Excel 电子表格（`.xlsx`/`.xlsm`/`.csv`/`.tsv`）的创建、编辑和分析。

- 使用 pandas 进行数据分析，openpyxl 进行格式化和公式
- 财务模型标准：颜色编码、数字格式、公式构造规则
- 公式重计算：LibreOffice 自动重算并验证错误

**许可**: [Anthropic 专有许可](skills/xlsx/LICENSE.txt) — Anthropic, PBC (2025)

## Prompts

### 工程师行为准则

定义 AI 在 agentic coding 工作流中作为高级软件工程师的行为规范。

- **核心行为**: 假设声明、混乱管理、必要时的反驳、简单性执行、范围纪律、死代码卫生
- **杠杆模式**: 声明式优于命令式、测试优先、先简单后优化、内联计划
- **输出标准**: 代码质量、沟通、变更描述
- **失败模式**: 列出 12 种需要避免的常见错误

**许可**: [MIT](prompt/LICENSE) — Elon Z (2026)

---

## 许可

| 模块 | 许可 | 作者 |
|------|------|------|
| code-reverse-engineering | MIT | Elon Z (2026) |
| 工程师行为准则 | MIT | Elon Z (2026) |
| drawio | MIT | — |
| docx | Anthropic 专有许可 | Anthropic, PBC (2025) |
| pdf | Anthropic 专有许可 | Anthropic, PBC (2025) |
| xlsx | Anthropic 专有许可 | Anthropic, PBC (2025) |

自研内容采用 [MIT License](LICENSE)，其他来自 Anthropic 官方 Skill 目录的内容采用其对应的 [Anthropic 专有许可](skills/docx/LICENSE.txt)。
