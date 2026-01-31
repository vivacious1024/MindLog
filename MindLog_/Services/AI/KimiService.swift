//
//  KimiService.swift
//  MindLog_
//
//  月之暗面 Kimi API 服务实现
//

import Foundation

/// Kimi API 服务实现
final class KimiService {
    @MainActor
    static let shared = KimiService()

    // MARK: - Properties

    private let apiKey: String
    private let baseURL: String
    private let model: String
    private let session: URLSession
    private let apiQueue = APIQueue()

    // MARK: - 默认配置

    private static let defaultAPIKey = "sk-Sol55HFIGAybAcqoC5lAausrtONYSU09eMHPc6uZWctZcVbv"
    private static let defaultBaseURL = "https://api.moonshot.cn/v1"
    private static let defaultModel = "kimi-k2-turbo-preview"

    // MARK: - Initialization

    init(apiKey: String? = nil) {
        self.apiKey = apiKey ?? Self.defaultAPIKey
        self.baseURL = Self.defaultBaseURL
        self.model = Self.defaultModel

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 300
        self.session = URLSession(configuration: config)
    }

    // MARK: - Content Analysis

    func analyzeContent(text: String, base64Images: [String]?) async throws -> AIAnalysisResult {
        await apiQueue.waitForSlot()

        // 构建系统提示
        let systemPrompt = """
        你是 MindLog 日记应用的 AI 助手。请分析以下日记内容，提取关键信息。

        分析要求：
        1. **标签（tags）**：生成 3-5 个标签，用于分类和检索
        2. **总结（summary）**：用 1-2 句话概括日记核心内容
        3. **情感评分（sentimentScore）**：0-1 的分数，0=最消极，0.5=中性，1=最积极
        4. **待办事项（todos）**：提取明确的待办事项，包含标题和优先级（低/中/高）
        5. **购物清单（shoppingList）**：提取需要购买的物品
        6. **日程安排（schedule）**：提取具体的日程信息

        日记内容：
        \(text)

        请严格返回以下 JSON 格式（不要添加任何其他文字）：
        {
            "tags": ["标签1", "标签2", "标签3"],
            "summary": "总结内容",
            "sentimentScore": 0.7,
            "todos": [
                {"title": "待办标题", "priority": "高"}
            ],
            "shoppingList": [
                {"name": "商品名", "quantity": "数量", "category": "类别"}
            ],
            "schedule": [
                {"title": "日程标题", "location": "地点", "notes": "备注"}
            ]
        }
        """

        // 构建消息
        var messages: [[String: Any]] = [
            ["role": "system", "content": "你是 MindLog 日记应用的 AI 助手。"],
            ["role": "user", "content": systemPrompt]
        ]

        // 如果有图片，添加到内容中
        if let images = base64Images, !images.isEmpty {
            var contentArray: [[String: Any]] = [
                ["type": "text", "text": systemPrompt]
            ]

            for imageBase64 in images.prefix(3) {
                contentArray.append([
                    "type": "image_url",
                    "image_url": [
                        "url": "data:image/jpeg;base64,\(imageBase64)"
                    ]
                ])
            }

            messages[1]["content"] = contentArray
        }

        let requestBody: [String: Any] = [
            "model": model,
            "messages": messages,
            "temperature": 0.7,
            "max_tokens": 2048,
            "response_format": ["type": "json_object"]
        ]

        // 发送请求
        let response: KimiResponse = try await performRequest(body: requestBody)

        // 解析结果
        guard let choice = response.choices.first,
              let message = choice.message else {
            throw AIServiceError.invalidResponse
        }

        let content = message.content

        // 解析 JSON
        guard let data = content.data(using: .utf8),
              let result = try? JSONDecoder().decode(AIAnalysisResult.self, from: data) else {
            throw AIServiceError.decodingFailed
        }

        return result
    }

    // MARK: - Chat Response

    func generateChatResponse(
        message: String,
        conversationHistory: [ChatMessage],
        personality: ChatPersonality
    ) async throws -> String {
        await apiQueue.waitForSlot()

        // 构建消息
        var messages: [[String: Any]] = [
            ["role": "system", "content": personality.systemPrompt]
        ]

        // 添加历史对话
        for chatMessage in conversationHistory.suffix(10) {
            let role = chatMessage.role == .user ? "user" : "assistant"
            messages.append([
                "role": role,
                "content": chatMessage.content
            ])
        }

        // 添加当前消息
        messages.append([
            "role": "user",
            "content": message
        ])

        let requestBody: [String: Any] = [
            "model": model,
            "messages": messages,
            "temperature": 0.8,
            "max_tokens": 1024
        ]

        let response: KimiResponse = try await performRequest(body: requestBody)

        guard let choice = response.choices.first,
              let message = choice.message else {
            throw AIServiceError.invalidResponse
        }

        return message.content
    }

    // MARK: - Review Report

    func generateReviewReport(
        entries: [JournalEntryForAnalysis],
        startDate: Date,
        endDate: Date,
        type: ReviewType
    ) async throws -> ReviewReportData {
        await apiQueue.waitForSlot()

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "zh_CN")

        // 构建日记摘要
        var entriesSummary = ""
        for (index, entry) in entries.enumerated() {
            let moodStr = entry.moodEmoji ?? "😐"
            entriesSummary += """
            \(index + 1). \(entry.title) (\(dateFormatter.string(from: entry.date)))
               心情：\(moodStr)
               内容：\(entry.content ?? "无内容")
               标签：\(entry.aiTags?.joined(separator: ", ") ?? "无")

            """
        }

        let prompt = """
        你是 MindLog 日记应用的复盘助手。请基于以下日记内容生成\(type.rawValue)。

        时间范围：\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))
        日记数量：\(entries.count)篇

        日记内容：
        \(entriesSummary)

        请分析并返回以下 JSON 格式：
        {
            "summary": "总体总结",
            "emotionCurve": [
                {"date": "2026-01-31T00:00:00Z", "score": 0.7}
            ],
            "keyEvents": ["关键事件1", "关键事件2"],
            "growthInsights": ["成长洞察1"],
            "todoCompletion": {
                "total": 10,
                "completed": 7,
                "completionRate": 0.7,
                "insights": ["分析"]
            },
            "nextPeriodSuggestions": ["建议1"]
        }

        注意：emotionCurve 的日期使用 ISO 8601 格式（带 Z 后缀）
        """

        let requestBody: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "system", "content": "你是 MindLog 的复盘助手。"],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7,
            "max_tokens": 4096,
            "response_format": ["type": "json_object"]
        ]

        let response: KimiResponse = try await performRequest(body: requestBody)

        guard let choice = response.choices.first,
              let message = choice.message else {
            throw AIServiceError.invalidResponse
        }

        let content = message.content

        // 解析 JSON
        guard let data = content.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw AIServiceError.decodingFailed
        }

        let summary = json["summary"] as? String ?? ""

        // 解析情感曲线
        var emotionPoints: [EmotionPoint] = []
        if let curveData = json["emotionCurve"] as? [[String: Any]] {
            for point in curveData {
                if let dateStr = point["date"] as? String,
                   let score = point["score"] as? Double {
                    // Kimi 返回的是 ISO8601 格式
                    let formatter = ISO8601DateFormatter()
                    formatter.formatOptions = [.withInternetDateTime]
                    if let date = formatter.date(from: dateStr) {
                        emotionPoints.append(EmotionPoint(id: UUID(), date: date, score: score))
                    }
                }
            }
        }

        let keyEvents = json["keyEvents"] as? [String] ?? []
        let growthInsights = json["growthInsights"] as? [String] ?? []
        let nextSuggestions = json["nextPeriodSuggestions"] as? [String] ?? []

        // 解析待办完成情况
        var todoAnalysis: TodoAnalysis?
        if let todoData = json["todoCompletion"] as? [String: Any] {
            let total = todoData["total"] as? Int ?? 0
            let completed = todoData["completed"] as? Int ?? 0
            let rate = todoData["completionRate"] as? Double ?? 0.0
            let insights = todoData["insights"] as? [String] ?? []
            todoAnalysis = TodoAnalysis(total: total, completed: completed, completionRate: rate, insights: insights)
        }

        return ReviewReportData(
            type: type,
            startDate: startDate,
            endDate: endDate,
            summary: summary,
            emotionCurve: emotionPoints,
            keyEvents: keyEvents,
            growthInsights: growthInsights,
            todoCompletion: todoAnalysis ?? TodoAnalysis(total: 0, completed: 0, completionRate: 0, insights: []),
            nextPeriodSuggestions: nextSuggestions
        )
    }

    // MARK: - Layout Generation

    func generateLayout(
        content: String,
        template: LayoutTemplate,
        imageCount: Int
    ) async throws -> String {
        await apiQueue.waitForSlot()

        let prompt: String
        if template == .auto {
            prompt = """
            你是 MindLog 的布局设计师。请根据以下日记内容，自动选择最合适的布局模板并生成布局配置。

            日记内容：\(content)
            图片数量：\(imageCount)

            可选模板：minimal, classic, story, todo, artistic

            请返回布局配置 JSON：
            {
                "template": "选择的模板",
                "sections": [
                    {
                        "type": "title",
                        "frame": {"x": 0.0, "y": 0.0, "width": 1.0, "height": 0.1}
                    }
                ]
            }
            """
        } else {
            prompt = """
            你是 MindLog 的布局设计师。请为以下日记内容生成"\(template.rawValue)"风格的布局配置。

            日记内容：\(content)
            图片数量：\(imageCount)

            请返回布局配置 JSON。
            """
        }

        let requestBody: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "system", "content": "你是布局设计助手。"],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.6,
            "max_tokens": 2048
        ]

        let response: KimiResponse = try await performRequest(body: requestBody)

        guard let choice = response.choices.first,
              let message = choice.message else {
            throw AIServiceError.invalidResponse
        }

        return message.content
    }

    // MARK: - Helper Methods

    private func performRequest(body: [String: Any]) async throws -> KimiResponse {
        guard let url = URL(string: "\(baseURL)/chat/completions") else {
            throw AIServiceError.serviceUnavailable
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            throw AIServiceError.encodingFailed
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw AIServiceError.invalidResponse
            }

            if httpResponse.statusCode == 429 {
                throw AIServiceError.rateLimitExceeded
            }

            if httpResponse.statusCode != 200 {
                if let errorStr = String(data: data, encoding: .utf8) {
                    print("Kimi API Error: \(errorStr)")
                }
                throw AIServiceError.serviceUnavailable
            }

            let result = try JSONDecoder().decode(KimiResponse.self, from: data)
            return result

        } catch let error as AIServiceError {
            throw error
        } catch {
            throw AIServiceError.networkError(error)
        }
    }
}

// MARK: - Kimi Response Models

struct KimiResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [KimiChoice]
}

struct KimiChoice: Codable {
    let index: Int
    let message: KimiMessage?
    let finishReason: String?
}

struct KimiMessage: Codable {
    let role: String?
    let content: String
}
