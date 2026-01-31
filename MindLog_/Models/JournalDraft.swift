import Foundation
import SwiftUI

@Observable
@MainActor
class JournalDraft {
    var text: String = ""
    var keywords: Keywords = Keywords()
    var selectedLayout: LayoutStyle? = nil
    var currentStep: Int = 1
    
    var canProceedFromStep1: Bool {
        text.count >= 20 && !keywords.isEmpty
    }
    
    var canProceedFromStep2: Bool {
        selectedLayout != nil
    }
}

struct Keywords {
    var time: [String] = []
    var weather: [String] = []
    var emotion: [String] = []
    var food: [String] = []
    var activity: [String] = []
    var nature: [String] = []
    var objects: [String] = []
    
    var isEmpty: Bool {
        time.isEmpty && weather.isEmpty && emotion.isEmpty &&
        food.isEmpty && activity.isEmpty && nature.isEmpty && objects.isEmpty
    }
    
    var allKeywords: [(category: String, words: [String], icon: String)] {
        [
            ("时间", time, "⏰"),
            ("天气", weather, "🌤️"),
            ("情绪", emotion, "💭"),
            ("食物", food, "🍽️"),
            ("活动", activity, "🎯"),
            ("自然", nature, "🌿"),
            ("物品", objects, "📦")
        ].filter { !$0.words.isEmpty }
    }
}
