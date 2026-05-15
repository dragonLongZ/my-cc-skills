---
name: dubbo-remote-service
description: >
  根据业务模块中的本地 Service 方法生成对应的 Dubbo 远程服务接口，供其他微服务模块跨模块调用。
  当用户想要"生成远程接口"、"给其他模块调用"、"生成 Dubbo 服务"、"生成 remote api"、"把某个方法暴露为 Dubbo 服务"时使用此 skill。
  也适用于追加方法到已有的 Remote 接口。
---

## 概述

本项目基于 Dubbo 3.x 进行微服务间 RPC 通信。Dubbo 服务的接口定义在 `cyf-api-xxx` 模块中，实现类放在业务模块的 `dubbo/` 包下。调用方通过 `@DubboReference` 注入接口代理进行远程调用。

## 目录结构

```
cyf-api-xxx/                          # Dubbo 接口定义（API 层）
  └── com/cyf/xxx/api/
      ├── RemoteXxxService.java       # 接口
      └── domain/vo/
          └── RemoteXxxVo.java        # 远程响应对象

cyf-cloud-xxx/                        # Dubbo 实现（业务模块）
  └── com/cyf/xxx/dubbo/
      └── RemoteXxxServiceImpl.java   # 实现类
```

## 执行步骤

### 1. 确定模块映射

根据本地 Service 所在的模块，确定对应的 cyf-api 模块和 cyf-cloud 模块：

| 业务模块 | API 模块 | 接口包路径 | 实现包路径 |
|----------|----------|-----------|-----------|
| cyf-cloud-member | cyf-api-member | `com.cyf.member.api` | `com.cyf.member.dubbo` |
| cyf-cloud-parking | cyf-api-parking | `com.cyf.parking.api` | `com.cyf.parking.dubbo` |
| cyf-cloud-pay | cyf-api-pay | `com.cyf.order.api` | `com.cyf.pay.dubbo` |
| cyf-cloud-station | cyf-api-station | `com.cyf.station.api` | `com.cyf.station.dubbo` |
| cyf-cloud-charge | cyf-api-charge | `com.cyf.charge.api` | `com.cyf.charge.dubbo` |
| cyf-cloud-system | cyf-api-system | `com.cyf.system.api` | `com.cyf.system.dubbo` |
| cyf-cloud-resource | cyf-api-resource | `com.cyf.resource.api` | `com.cyf.resource.dubbo` |

### 2. 检查是否已有对应的 Remote 接口

在对应的 `cyf-api-xxx` 模块中搜索 `Remote{EntityName}Service` 接口：

- **已存在** → 直接在该接口中追加方法声明，在对应的 `dubbo/` 实现类中追加实现方法
- **不存在** → 需要创建三个文件（见步骤 3）

命名规律：本地 Service `IMemberCarVehicleService` → Remote 接口 `RemoteMemberCarVehicleService` → 实现类 `RemoteMemberCarVehicleImpl`。

### 3. 新建时创建三个文件

#### 3a. RemoteXxxVo（API 模块 `domain/vo/` 目录）

- 类名 `Remote{EntityName}Vo`，实现 `Serializable`
- 字段只包含调用方真正需要的，不要照搬全部字段
- `Date` 类型字段加 `@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")`
- JavaDoc 注释每个字段
- 使用 `@Data`（Lombok）
- 必须包含 `@Serial private static final long serialVersionUID = 1L`

#### 3b. RemoteXxxService（API 模块 `api/` 目录）

- 纯接口，无注解
- 方法签名与本地 Service 保持一致（参数类型、返回类型）
- 返回类型使用刚创建的 RemoteXxxVo
- 写 JavaDoc 注释

#### 3c. RemoteXxxServiceImpl（业务模块 `dubbo/` 目录）

标准模板：

```java
@RequiredArgsConstructor
@Service
@DubboService
@Slf4j
@Validated
public class RemoteXxxServiceImpl implements RemoteXxxService {

    private final ILocalService localService;

    @Override
    public ReturnType methodName(ParamType param) {
        // 委托给本地 Service，转换返回值
    }
}
```

注解说明：
- `@RequiredArgsConstructor` — Lombok 构造器注入
- `@Service` — Spring Bean
- `@DubboService` — Dubbo 服务暴露（必须）
- `@Slf4j` — 日志（member 和 parking 模块习惯加此注解）
- `@Validated` — 参数校验（member 和 parking 模块习惯加此注解）

### 4. 对象转换

根据项目习惯，使用以下转换方式之一：

- **单对象**：`BeanUtil.copyProperties(localVo, RemoteXxxVo.class)`（Hutool）
- **List**：`BeanUtil.copyToList(localVoList, RemoteXxxVo.class)`
- 如果目标字段较少也可以用手动 Builder 模式

注入依赖：通过构造器注入本地 Service（`@RequiredArgsConstructor` + `private final`），不要用 `@Autowired`。

### 5. 特殊情况处理

- **`@TenantIgnore`**：如果方法需要跨租户查询（不限制当前租户），在实现方法上加 `@TenantIgnore` 注解
- **基本类型返回**：如果方法返回 `Long`、`boolean`、`void` 等简单类型，不需要创建 VO，直接在接口中声明即可
- **已有接口追加方法**：只需改两处 — 接口加方法声明 + 实现类加方法实现，不需要创建 VO

### 6. 完成后告知用户

生成完毕后，告知用户如何在其他模块调用：

```java
@DubboReference
private RemoteXxxService remoteXxxService;

// 调用示例
RemoteXxxVo result = remoteXxxService.methodName(params);
```

提醒：调用方模块的 `pom.xml` 需要依赖对应的 `cyf-api-xxx` 模块。