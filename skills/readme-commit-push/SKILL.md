---
name: readme-commit-push
description: >
  根据项目最新代码变更自动更新 README 文档，创建规范的 git commit，并推送到远程仓库。
  当用户要求"创建 commit 并更新 README 后提交"、"更新 README 并 push"、"同步 README 后提交"、
  "commit and update readme"、"更新文档后提交"等场景时使用。
  也适用于用户想快速完成"变更分析 → README 更新 → 生成 commit → 推送"全流程的场景。
  只要涉及 README 更新 + git commit + push 的组合操作，都应使用此 skill。
---

# README Commit Push 工作流

## 触发时机

当你需要完成以下动作时激活：
- 代码有变更，需要同步更新 README 文档
- 需要将变更 commit 并 push，同时确保 README 保持最新
- 用户说了类似"更新 README 后提交"、"commit and push"、"同步文档"等指令

## 工作流程

按以下顺序执行，每步完成后才进入下一步。

### 第一步：分析变更

1. 运行 `git status` 查看当前工作区状态
2. 运行 `git diff` 查看未暂存的变更
3. 运行 `git diff --cached` 查看已暂存的变更
4. 运行 `git log --oneline -5` 查看最近 5 次提交记录
5. 如果有新增/修改的文件，使用 Read 工具查看关键文件内容，理解变更的实际含义

**判断变更类型**：
- **功能新增**：新模块、新接口、新配置文件
- **Bug 修复**：修复逻辑错误、边界条件、异常处理
- **重构优化**：代码结构调整、性能优化、依赖更新
- **文档/配置**：仅文档变更、环境变量修改、CI/CD 变更
- **Skills 变更**：新增/修改/删除了 skills 目录下的技能

### 第二步：更新 README

根据第一步分析的变更内容，更新 README.md：

1. **读取当前 README**，了解现有结构和风格
2. **定位需要更新的章节**：
   - 如果是功能新增，在对应模块章节添加新内容
   - 如果是 Bug 修复，在更新日志或变更说明中记录
   - 如果是 Skills 变更，更新 Skills 列表章节
   - 如果是小修小补，确认 README 是否真的需要更新——如果变更与 README 描述的模块无关，跳过 README 更新，直接 commit
3. **遵循项目现有的 README 风格**（参考同目录其他 skill 的描述方式）
4. **保持简洁**，不要堆砌细节，只写用户需要知道的内容

**重要**：如果代码变更与 README 描述的模块/功能无关，**不要强行更新 README**。没有意义的文档更新比不更新更糟糕。

### 第三步：创建 Commit

1. 暂存变更：
   - README 有更新：`git add README.md` + 其他变更文件
   - README 无需更新：仅 `git add` 代码变更文件
2. 生成符合规范的 commit message：

   ```
   <type>(<scope>): <简短描述>

   <详细说明（可选，描述变更内容和原因）>

   Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
   ```

   **type 选择**：
   - `feat`：新增功能或 skill
   - `fix`：Bug 修复
   - `docs`：仅文档变更
   - `refactor`：重构（非功能变更）
   - `chore`：构建/工具/配置变更
   - `update`：README 同步更新（与其他 type 合并使用）

   **示例**：
   ```
   feat(skills): 新增 readme-commit-push 技能

   支持根据代码变更自动更新 README 并创建 commit 推送。
   整合 git diff 分析、README 更新、commit 生成、push 全流程。

   Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
   ```

3. 创建提交

### 第四步：推送

1. 检查当前分支是否跟踪远程分支
2. 如果没有远程跟踪，先 `git push -u origin <branch>`
3. 如果已有跟踪，直接 `git push`

## 常见场景处理

### 场景 1：新增了 Skill

- README 的 Skills 章节添加新 skill 的简要说明
- 如果有独立 README.md，也更新该 skill 的描述

### 场景 2：修改了已有 Skill

- 如果修改涉及功能变化（新增特性、行为变更），更新 README 中该 skill 的描述
- 如果只是内部重构（性能优化、代码整理），README 无需更新

### 场景 3：仅代码变更（不涉及 Skill）

- 检查项目 README 是否有对应模块需要更新
- 如果没有，直接 commit 代码变更，跳过 README 更新

### 场景 4：多个变更混合

- 合并为一个 commit，commit message 涵盖所有主要变更
- README 中只写值得对外说明的变更，不要记录每个小修改

## 安全检查清单

在 commit 之前，确认：

- [ ] 没有误提交敏感文件（`.env`、密钥、token 等）
- [ ] 没有提交大型构建产物或依赖（`node_modules`、`dist/` 等）
- [ ] commit message 准确描述了变更内容
- [ ] 如果 README 有更新，变更是有意义的，不是机械堆砌
