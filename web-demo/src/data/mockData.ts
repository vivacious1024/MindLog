// 心情类型 - 匹配原生 iOS 项目
export interface MoodType {
  emoji: string;
  label: string;
  color: string;
}

export const moodTypes: Record<string, MoodType> = {
  amazing: { emoji: '😄', label: '太棒了', color: '#FACC15' },
  happy: { emoji: '🙂', label: '开心', color: '#22C55E' },
  neutral: { emoji: '😐', label: '平静', color: '#9CA3AF' },
  sad: { emoji: '😢', label: '难过', color: '#3B82F6' },
  angry: { emoji: '😠', label: '愤怒', color: '#EF4444' },
  anxious: { emoji: '😰', label: '焦虑', color: '#F97316' },
  grateful: { emoji: '🙏', label: '感恩', color: '#EC4899' },
  tired: { emoji: '😴', label: '疲惫', color: '#A855F7' },
};

export const moodOptions = Object.entries(moodTypes).map(([key, value]) => ({
  id: key,
  ...value,
}));

export interface DiaryEntry {
  id: string;
  title: string;
  date: string;
  mood: keyof typeof moodTypes;
  content: string;
  aiTags?: string[];
  aiSentimentScore?: number;
  attachmentCount?: number;
  image?: string;
}

export const mockDiaries: DiaryEntry[] = [
  {
    id: '1',
    title: '美好的一天',
    date: '2月2日',
    mood: 'happy',
    content: '今天天气很好，心情也很棒！去公园散步了，看到了很多美丽的花朵。春天真的来了，一切都充满了希望。',
    aiTags: ['生活', '自然', '快乐'],
    aiSentimentScore: 0.85,
    image: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop',
  },
  {
    id: '2',
    title: '工作总结',
    date: '2月1日',
    mood: 'amazing',
    content: '今天完成了项目的重要里程碑，团队很给力！虽然有些累，但是看到成果很有成就感。',
    aiTags: ['工作', '成就', '团队'],
    aiSentimentScore: 0.75,
  },
  {
    id: '3',
    title: '有点焦虑',
    date: '1月31日',
    mood: 'anxious',
    content: '今天工作压力有点大，需要调整心态。深呼吸，一切都会好起来的。',
    aiTags: ['情绪', '压力'],
    aiSentimentScore: 0.35,
  },
  {
    id: '4',
    title: '感恩的心',
    date: '1月30日',
    mood: 'grateful',
    content: '收到了朋友寄来的生日礼物，虽然生日已经过了一周，但这份心意让我很感动。',
    aiTags: ['友情', '感恩'],
    aiSentimentScore: 0.82,
    image: 'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=400&h=300&fit=crop',
  },
  {
    id: '5',
    title: '需要休息',
    date: '1月29日',
    mood: 'tired',
    content: '连续加班第三天，身体有些吃不消。提醒自己要注意休息，健康才是最重要的。',
    aiTags: ['健康', '工作'],
    aiSentimentScore: 0.45,
  },
];

export const mockAIResponses = [
  '我理解你的感受。有时候生活会给我们一些挑战，但请记住，每一次低谷都是成长的机会。',
  '感谢你愿意和我分享这些。你的感受都是有效的，我会一直在这里倾听。',
  '听起来你今天经历了很多。不妨给自己一些时间，做一些让自己放松的事情。',
  '你已经做得很好了。记得对自己温柔一点，你值得被善待。',
];
