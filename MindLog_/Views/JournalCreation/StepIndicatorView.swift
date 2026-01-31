import SwiftUI

struct StepIndicatorView: View {
    let currentStep: Int
    
    private let steps = [
        (number: 1, label: "输入"),
        (number: 2, label: "风格"),
        (number: 3, label: "预览")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.number) { index, step in
                // 步骤圆圈
                VStack(spacing: 8) {
                    Circle()
                        .fill(stepColor(for: step.number))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Text("\(step.number)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(stepTextColor(for: step.number))
                        )
                    
                    Text(step.label)
                        .font(.caption)
                        .fontWeight(currentStep == step.number ? .semibold : .regular)
                        .foregroundStyle(currentStep == step.number ? .pink : .secondary)
                }
                .frame(maxWidth: .infinity)
                
                // 连接线
                if index < steps.count - 1 {
                    Rectangle()
                        .fill(currentStep > step.number ? Color.pink : Color.gray.opacity(0.3))
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 28)
                }
            }
        }
        .padding(.vertical, 12)
    }
    
    private func stepColor(for stepNumber: Int) -> Color {
        if currentStep > stepNumber {
            return .pink
        } else if currentStep == stepNumber {
            return .pink
        } else {
            return Color.gray.opacity(0.2)
        }
    }
    
    private func stepTextColor(for stepNumber: Int) -> Color {
        if currentStep >= stepNumber {
            return .white
        } else {
            return .gray
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        StepIndicatorView(currentStep: 1)
        StepIndicatorView(currentStep: 2)
        StepIndicatorView(currentStep: 3)
    }
    .padding()
}
