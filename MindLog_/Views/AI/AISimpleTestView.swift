//
//  AISimpleTestView.swift
//  MindLog_
//
//  简化版 AI 测试，用于调试
//

import SwiftUI

/// 简化版 AI 测试界面
struct AISimpleTestView: View {
    @State private var inputText = "今天和朋友去吃了意大利餐，非常开心！需要买：面粉、番茄酱、橄榄油。明天下午3点看牙医。"
    @State private var isAnalyzing = false
    @State private var resultText = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("AI 简单测试")
                        .font(.title2)
                        .fontWeight(.bold)

                    // 输入框
                    VStack(alignment: .leading, spacing: 8) {
                        Text("输入内容：")
                            .font(.headline)
                        TextEditor(text: $inputText)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }

                    // 分析按钮
                    Button {
                        Task {
                            await performAnalysis()
                        }
                    } label: {
                        HStack {
                            if isAnalyzing {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            } else {
                                Text("开始分析")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(inputText.isEmpty || isAnalyzing)

                    // 错误提示
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }

                    // 结果展示
                    if !resultText.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("分析结果：")
                                .font(.headline)
                            Text(resultText)
                                .font(.body)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("AI 简单测试")
        }
    }

    private func performAnalysis() async {
        isAnalyzing = true
        errorMessage = nil
        resultText = ""

        // 先测试 API Key 是否可用
        let apiKey = "sk-Sol55HFIGAybAcqoC5lAausrtONYSU09eMHPc6uZWctZcVbv"
        let baseURL = "https://api.moonshot.cn/v1/chat/completions"

        // 构建简单的请求
        let prompt = """
        你是一个测试助手。请简单回复：AI功能正常工作。

        用户输入：\(inputText)
        """

        let requestBody: [String: Any] = [
            "model": "kimi-k2-turbo-preview",
            "messages": [
                ["role": "system", "content": "你是测试助手。"],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7
        ]

        guard let url = URL(string: baseURL) else {
            await MainActor.run {
                errorMessage = "无法创建 URL"
                isAnalyzing = false
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            await MainActor.run {
                errorMessage = "请求数据编码失败：\(error.localizedDescription)"
                isAnalyzing = false
            }
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                await MainActor.run {
                    if httpResponse.statusCode == 200 {
                        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let choices = json["choices"] as? [[String: Any]],
                           let first = choices.first,
                           let message = first["message"] as? [String: Any],
                           let content = message["content"] as? String {
                            resultText = content
                        } else {
                            resultText = String(data: data, encoding: .utf8) ?? "无法解析响应"
                        }
                    } else {
                        errorMessage = "HTTP 错误：\(httpResponse.statusCode)\n\(String(data: data, encoding: .utf8) ?? "")"
                    }
                    isAnalyzing = false
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = "网络错误：\(error.localizedDescription)"
                isAnalyzing = false
            }
        }
    }
}

#Preview {
    AISimpleTestView()
}
