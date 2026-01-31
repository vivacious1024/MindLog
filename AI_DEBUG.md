# AI 功能诊断指南

## 问题排查步骤

### 1. 确认 API Key 是否正确

API Key 已配置在：`GeminiService.swift:24`

```swift
private static let defaultAPIKey = "AIzaSyBoFLeSAatQlya0oS_Hq1ABLNrhcrslmUw"
```

### 2. 使用简单测试界面

1. 运行应用
2. 进入「我的」标签
3. 点击「**AI 简单测试（调试）**」
4. 点击「**开始分析**」按钮

**可能的结果：**

#### A. 如果显示 "AI功能正常工作"
- ✅ API Key 有效
- ✅ 网络连接正常
- ✅ Gemini API 可访问

**下一步：** 使用完整的 AI 功能测试界面

#### B. 如果显示 HTTP 错误（如 401, 403, 429）

| 状态码 | 原因 | 解决方法 |
|--------|------|----------|
| 401 | API Key 无效 | 检查 API Key 是否正确 |
| 403 | API 权限不足 | 确保 API Key 启用了 Gemini API |
| 429 | 请求过于频繁 | 等待几分钟后重试 |
| 400 | 请求格式错误 | 检查请求参数 |

#### C. 如果显示 "网络错误"
- 检查设备网络连接
- 确保能访问 Google 服务（可能需要 VPN）
- 检查防火墙设置

#### D. 如果按钮无反应
- 查看控制台日志（Xcode → Console）
- 检查是否有崩溃日志

### 3. 查看 Xcode 控制台日志

运行应用时，在 Xcode 底部打开 Console（Cmd + Shift + C）

查找以下类型的错误：
```
AI Analysis Error: ...
Gemini API Error: ...
```

### 4. 验证 API Key 权限

访问 [Google AI Studio](https://makersuite.google.com/app/apikey)
确认：
- ✅ API Key 存在且未删除
- ✅ 已启用 Gemini API
- ✅ 没有超过配额限制

### 5. 测试 API Key（手动）

在终端执行以下命令测试 API Key：

```bash
curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=AIzaSyBoFLeSAatQlya0oS_Hq1ABLNrhcrslmUw" \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [{
      "parts": [{"text": "你好"}]
    }]
  }'
```

**期望返回：** JSON 格式的 AI 回复
**错误返回：** 检查错误信息中的原因

## 常见问题

### Q: 点击 AI 按钮没反应
**A:**
1. 检查是否已输入内容
2. 查看控制台是否有错误日志
3. 使用"简单测试"界面验证基础功能

### Q: 显示"服务暂时不可用"
**A:**
1. 可能是网络问题，尝试切换网络
2. 检查是否需要 VPN 访问 Google 服务
3. 稍后重试（可能是 API 临时限流）

### Q: 分析结果为空
**A:**
1. 查看错误弹窗中的具体信息
2. 检查 API 返回的原始数据
3. 尝试使用更简单的输入文本测试

## 联系支持

如果以上步骤都无法解决问题，请提供：
1. 简单测试界面的错误信息
2. Xcode 控制台的完整日志
3. 您的网络环境描述（是否使用 VPN 等）
