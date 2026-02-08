import { mockDiaries } from '../data/mockData';

// Interfaces
export interface AIAnalysisResult {
    tags: string[];
    summary: string;
    sentimentScore: number;
    todos: { title: string; priority: string }[];
    shoppingList: { name: string; quantity: string; category: string }[];
    schedule: { title: string; location: string; notes: string }[];
}

export type ChatPersonality = 'warm' | 'professional' | 'optimistic' | 'philosophical' | 'concise';

// Mock responses for web-demo
const healingResponses = [
    "我听到了你的心声。无论发生什么，都要记得照顾好自己。",
    "深呼吸... 这种感觉我能理解。你已经做得很好的。",
    "偶尔停下来休息一下也是可以的，不要对自己太苛刻。",
    "你的感受很重要。愿意多和我说说吗？",
    "每一份情绪都是生命的礼物，即使是悲伤也试图告诉我们些什么。",
    "我在听。你并不孤单。",
    "今天的月色很美，希望你的心情也能像这月光一样温柔。"
];

// Helper delay
const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export const aiService = {
    // Analyze content (Mocked)
    analyzeContent: async (text: string, images: string[] = []): Promise<AIAnalysisResult> => {
        await delay(1500); // Simulate processing
        return {
            tags: ['生活', '感悟', 'AI记录'],
            summary: text.slice(0, 50) + "...",
            sentimentScore: Math.random(), // Random sentiment
            todos: [],
            shoppingList: [],
            schedule: []
        };
    },

    // Chat with AI (Mocked with Tool Calling Logic)
    chat: async (message: string, history: any[], personality: ChatPersonality): Promise<{ text: string; actions?: { label: string; handlerId: string; style?: 'primary' | 'secondary' }[] }> => {
        await delay(1000 + Math.random() * 1000); // Simulate thinking

        // 1. Tool Call Detection: Summary / Card Generation
        if (message.includes("总结") || message.includes("生成") || message.includes("卡片")) {
            return {
                text: "好的，我来帮你总结。在这之前，能告诉我你此刻的心情关键词吗？",
                actions: [
                    { label: "开心 \uD83D\uDE0A", handlerId: "mood_happy", style: 'primary' },
                    { label: "平静 \uD83D\uDE0C", handlerId: "mood_calm", style: 'secondary' },
                    { label: "焦虑 \uD83D\uDE1F", handlerId: "mood_anxious", style: 'secondary' },
                    { label: "难过 \uD83D\uDE22", handlerId: "mood_sad", style: 'secondary' }
                ]
            };
        }

        // 2. Tool Call Execution: Generate Card (based on mood keywords)
        const moodKeywords = ["开心", "快乐", "愉悦", "平静", "安宁", "焦虑", "难过", "伤心", "愤怒", "生气"];
        const foundMood = moodKeywords.find(k => message.includes(k));

        if (foundMood) {
            return {
                text: `收到！捕捉到你的心情是【${foundMood}】。\n\n我已为你生成了日记卡片：\n-------------------\n📅 日期：${new Date().toLocaleDateString()}\n😊 心情：${foundMood}\n📝 摘要：${history[history.length - 1]?.content || "记录当下的美好..."}\n-------------------\n（已自动保存到手帐页）`
            };
        }

        // 3. Default Healing Response
        return {
            text: healingResponses[Math.floor(Math.random() * healingResponses.length)]
        };
    },

    // Generate Image (Mocked)
    generateImage: async (prompt: string): Promise<string> => {
        await delay(3000); // Simulate generation
        return "https://images.unsplash.com/photo-1499750310159-5b5f8ea37dd1?w=800&auto=format&fit=crop&q=60";
    },

    // Generate Review Report (Mocked)
    generateReport: async () => {
        console.log("Generating report...");
        await delay(2000);
        return "Report generated!";
    }
};
