---
name: entity-field-change
description: >
  修改或删除项目实体类中的字段定义，并自动同步所有关联文件。当用户要求"修改实体字段"、"改字段类型"、"把XX字段改为Long"、"字段同步"、"更新XX字段"、"删除字段"、"数据库中删了某字段请同步实体"、"这个字段不要了"、"移除XX字段"时使用此 skill。适用于基于 RuoYi-Cloud-Plus 框架的微服务项目。
---

## 概述

本项目中，一个实体字段同时存在于 **4 个文件**中。修改字段类型或名称时，必须同步更新所有文件，否则会导致字段映射丢失、Excel 导出缺失、Dubbo 调用返回空字段等问题。

## 必须同步的 4 个文件

| 文件类型 | 位置 | 说明 |
|----------|------|------|
| Entity | `domain/XxxEntity.java` | 数据库映射实体，`@TableName` 注解 |
| BO | `domain/bo/XxxBo.java` | 业务入参对象，含 `@NotNull`/`@NotBlank` 等校验注解 |
| VO | `domain/vo/XxxVo.java` | 视图出参对象，含 `@ExcelProperty` 注解 |
| RemoteVo | `cyf-api-*/domain/vo/RemoteXxxVo.java` | Dubbo 远程调用响应对象 |

## 执行步骤

### 1. 定位所有相关文件

使用 Grep 搜索当前字段的完整声明（`private <类型> <字段名>`），找出所有包含该字段的文件：

```
Grep: private String parkingLotId
```

确认搜索范围覆盖：
- 业务模块的 `domain/`、`domain/bo/`、`domain/vo/` 目录
- 对应 `cyf-api-*/domain/vo/` 目录

如果用户指定的模块有多个关联模块，也要搜索那些模块的 RemoteVo。

### 2. 修改每个文件

**Entity** — 直接改字段类型即可：
```java
private Long parkingLotId;  // 原来是 String
```

**BO** — 修改字段类型的同时注意：
- `String` 类型使用 `@NotBlank` 校验注解
- 非 `String` 类型（`Long`、`Integer`、`Date` 等）使用 `@NotNull` 校验注解
```java
@NotNull(message = "车位编号不能为空", groups = { AddGroup.class, EditGroup.class })
private Long parkingLotId;  // 原来: @NotBlank + String
```

**VO** — 直接改字段类型，`@ExcelProperty` 注解不变：
```java
private Long parkingLotId;
```

**RemoteVo** — 直接改字段类型：
```java
private Long parkingLotId;
```

### 3. 类型变更检查清单

| 原类型 → 新类型 | 注意事项 |
|----------------|----------|
| `String` → `Long`/`Integer` | `@NotBlank` → `@NotNull` |
| `String` → `LocalDateTime`/`Date` | 保持 `@NotNull`，添加 `@JsonFormat` |
| `Date` → `LocalDateTime` | 校验注解不变，序列化注解不变 |
| 枚举 → `String`/`Long` | 确认数据库中存储的值格式 |

### 4. 发现异常主动提醒

如果发现以下问题，主动提醒用户而非直接修改：

- **字段类型与注释不匹配**：注释写"状态 0-可用 1-已过期"但类型是 `Date`，应建议改为 `Long`
- **字段名拼写不一致**：不同文件中的字段名拼写差异
- **数据库列名映射**：如果加了 `@TableField` 注解，确认数据库列名与字段类型的兼容性

### 4.5 字段删除处理

当用户要求删除某个字段时（如"数据库中我删了，请删除对应的实体字段"）：

1. **Entity** — 直接删除该字段及其 `@TableField` 等注解
2. **BO** — 删除该字段及其校验注解
3. **VO** — 删除该字段及其 `@ExcelProperty` 注解
4. **RemoteVo** — 删除该字段

删除后需额外检查：
- 各文件中是否有使用该字段的 getter/setter 调用，一并清理
- Controller/Service 中是否有该字段的业务逻辑引用
- BO/VO 中是否有 `@ExcelProperty` 等注解引用该字段

### 5. 完成后确认

告知用户修改了哪些文件，以及类型变更的连带修改（如校验注解变更）。