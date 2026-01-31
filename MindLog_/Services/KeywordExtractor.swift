import Foundation

struct KeywordExtractor {
    static let library: [String: [String]] = [
        "time": ["早上", "早晨", "上午", "中午", "下午", "傍晚", "晚上", "深夜", "凌晨", "今天", "昨天", "明天", "周末", "假期"],
        "weather": ["晴天", "阴天", "雨天", "下雨", "阳光", "晴朗", "多云", "晚霞", "日落", "日出", "彩虹", "星空", "月光"],
        "emotion": ["开心", "快乐", "高兴", "愉快", "幸福", "满足", "欣慰", "放松", "平静", "舒适", "温暖", "感动", "激动", "难过", "伤心", "失落", "焦虑", "紧张", "疲惫"],
        "food": ["咖啡", "茶", "大麦茶", "奶茶", "果汁", "面条", "米饭", "面包", "蛋糕", "水果", "早餐", "午餐", "晚餐", "甜点", "零食"],
        "activity": ["散步", "跑步", "运动", "锻炼", "瑜伽", "阅读", "看书", "写作", "画画", "听音乐", "看电影", "逛街", "购物", "旅行", "聚会"],
        "nature": ["花", "树", "草", "叶子", "植物", "鸟", "猫", "狗", "麻雀", "蝴蝶", "山", "海", "河", "湖", "公园"],
        "objects": ["书", "诗集", "小说", "笔记本", "日记本", "照片", "相机", "手机", "电脑", "杯子", "茶壶", "窗户", "桌子", "椅子"]
    ]
    
    static func extract(from text: String) -> Keywords {
        var keywords = Keywords()
        
        // 提取时间词
        keywords.time = library["time"]?.filter { text.contains($0) } ?? []
        
        // 提取天气词
        keywords.weather = library["weather"]?.filter { text.contains($0) } ?? []
        
        // 提取情绪词
        keywords.emotion = library["emotion"]?.filter { text.contains($0) } ?? []
        
        // 提取食物词
        keywords.food = library["food"]?.filter { text.contains($0) } ?? []
        
        // 提取活动词
        keywords.activity = library["activity"]?.filter { text.contains($0) } ?? []
        
        // 提取自然词
        keywords.nature = library["nature"]?.filter { text.contains($0) } ?? []
        
        // 提取物品词
        keywords.objects = library["objects"]?.filter { text.contains($0) } ?? []
        
        return keywords
    }
}
