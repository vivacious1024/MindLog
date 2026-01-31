import SwiftUI

struct JournalCreationView: View {
    @State private var draft = JournalDraft()
    @State private var currentPage = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 步骤指示器
                StepIndicatorView(currentStep: draft.currentStep)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // 页面内容
                TabView(selection: $currentPage) {
                    Step1InputView(draft: draft)
                        .tag(0)
                    
                    Step2LayoutView(draft: draft)
                        .tag(1)
                    
                    Step3PreviewView(draft: draft)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .disabled(true) // 禁用滑动，只能通过按钮切换
                
                // 底部导航
                NavigationBarView(
                    currentStep: draft.currentStep,
                    canProceed: canProceed,
                    onPrevious: goToPreviousStep,
                    onNext: goToNextStep,
                    onReset: resetDraft
                )
            }
            .navigationTitle("MindLog")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("关闭") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var canProceed: Bool {
        switch draft.currentStep {
        case 1: return draft.canProceedFromStep1
        case 2: return draft.canProceedFromStep2
        default: return false
        }
    }
    
    private func goToPreviousStep() {
        withAnimation {
            draft.currentStep -= 1
            currentPage -= 1
        }
    }
    
    private func goToNextStep() {
        withAnimation {
            draft.currentStep += 1
            currentPage += 1
        }
    }
    
    private func resetDraft() {
        withAnimation {
            draft = JournalDraft()
            currentPage = 0
        }
    }
}

#Preview {
    JournalCreationView()
}
