import SwiftUI
import Photos

struct Step3PreviewView: View {
    @Bindable var draft: JournalDraft
    @State private var renderedImage: UIImage?
    @State private var isRendering = false
    @State private var showingSaveAlert = false
    @State private var saveAlertMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 标题
                VStack(spacing: 8) {
                    Text("你的专属手帐")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("预览最终效果，并保存到相册")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top)
                
                // 预览图
                if let image = renderedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 12))
                        .shadow(radius: 8)
                        .padding(.horizontal)
                } else if isRendering {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("正在生成手帐...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(height: 400)
                }
                
                // 操作按钮
                if renderedImage != nil {
                    VStack(spacing: 12) {
                        Button {
                            saveImage()
                        } label: {
                            Label("保存到相册", systemImage: "square.and.arrow.down")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.pink)
                        
                        Button {
                            shareImage()
                        } label: {
                            Label("分享手帐", systemImage: "square.and.arrow.up")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .task {
            await renderJournal()
        }
        .alert("提示", isPresented: $showingSaveAlert) {
            Button("确定", role: .cancel) {}
        } message: {
            Text(saveAlertMessage)
        }
    }
    
    @MainActor
    private func renderJournal() async {
        isRendering = true
        
        // 模拟渲染延迟
        try? await Task.sleep(for: .seconds(1))
        
        if let layout = draft.selectedLayout {
            renderedImage = JournalRenderer.render(
                text: draft.text,
                keywords: draft.keywords,
                layout: layout
            )
        }
        
        isRendering = false
    }
    
    private func saveImage() {
        guard let image = renderedImage else { return }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                DispatchQueue.main.async {
                    saveAlertMessage = "手帐已保存到相册 ✨"
                    showingSaveAlert = true
                }
            } else {
                DispatchQueue.main.async {
                    saveAlertMessage = "请在设置中允许访问相册"
                    showingSaveAlert = true
                }
            }
        }
    }
    
    private func shareImage() {
        guard let image = renderedImage else { return }
        
        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            
            // 查找最顶层的 presented view controller
            var topVC = rootVC
            while let presented = topVC.presentedViewController {
                topVC = presented
            }
            
            topVC.present(activityVC, animated: true)
        }
    }
}

#Preview {
    @Previewable @State var draft = JournalDraft()
    draft.text = "今天天气真好，阳光明媚。"
    draft.selectedLayout = .vintage
    draft.keywords = KeywordExtractor.extract(from: draft.text)
    
    return Step3PreviewView(draft: draft)
}
