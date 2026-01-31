import SwiftUI

struct NavigationBarView: View {
    let currentStep: Int
    let canProceed: Bool
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onReset: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // 上一步按钮
            if currentStep > 1 {
                Button {
                    onPrevious()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("上一步")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            
            // 下一步/重新开始按钮
            if currentStep < 3 {
                Button {
                    onNext()
                } label: {
                    HStack {
                        Text("下一步")
                        Image(systemName: "chevron.right")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.pink)
                .disabled(!canProceed)
            } else {
                Button {
                    onReset()
                } label: {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("重新开始")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 8, y: -4)
    }
}

#Preview {
    VStack {
        Spacer()
        NavigationBarView(
            currentStep: 1,
            canProceed: true,
            onPrevious: {},
            onNext: {},
            onReset: {}
        )
    }
}
