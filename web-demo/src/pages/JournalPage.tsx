import React from 'react';
import { motion } from 'framer-motion';
import { Calendar, Search } from 'lucide-react';
import { GlassCard } from '../components/GlassCard';
import { moodTypes, type DiaryEntry } from '../data/mockData';
import { useTheme } from '../context/ThemeContext';

interface JournalPageProps {
    diaries: DiaryEntry[];
}

export const JournalPage: React.FC<JournalPageProps> = ({ diaries }) => {
    const { colors } = useTheme();

    const [columns, setColumns] = React.useState(1);
    const [searchQuery, setSearchQuery] = React.useState('');

    React.useEffect(() => {
        const updateColumns = () => {
            if (window.innerWidth >= 1280) setColumns(3); // Large screens
            else if (window.innerWidth >= 768) setColumns(2); // Medium screens
            else setColumns(1); // Mobile
        };

        updateColumns();
        window.addEventListener('resize', updateColumns);
        return () => window.removeEventListener('resize', updateColumns);
    }, []);

    // Filter diaries based on search query
    const filteredDiaries = React.useMemo(() => {
        return diaries.filter(diary =>
            diary.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
            diary.content.toLowerCase().includes(searchQuery.toLowerCase()) ||
            diary.aiTags?.some(tag => tag.toLowerCase().includes(searchQuery.toLowerCase()))
        );
    }, [diaries, searchQuery]);

    // Distribute diaries into columns
    const distributedDiaries = React.useMemo(() => {
        const cols: DiaryEntry[][] = Array.from({ length: columns }, () => []);
        filteredDiaries.forEach((diary, index) => {
            cols[index % columns].push(diary);
        });
        return cols;
    }, [filteredDiaries, columns]);

    return (
        <div
            className="w-full min-h-screen pt-32 pb-36 px-4 md:px-8"
        >
            <div className="w-full max-w-[1600px] mx-auto">
                {/* Search Header */}
                <div className="mb-12 flex flex-col items-center md:items-start space-y-6">
                    <motion.h1
                        initial={{ opacity: 0, y: -20 }}
                        animate={{ opacity: 1, y: 0 }}
                        className="text-4xl md:text-5xl font-bold tracking-tight pl-2"
                        style={{ color: colors.text }}
                    >
                        我的手帐
                    </motion.h1>

                    <motion.div
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: 0.1 }}
                        className="relative w-full max-w-lg"
                    >
                        <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                            <Search size={20} className="text-gray-400" />
                        </div>
                        <input
                            type="text"
                            placeholder="搜索记忆、标签..."
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                            className="w-full py-4 pl-12 pr-6 rounded-2xl border-none outline-none text-lg shadow-sm transition-all focus:shadow-md focus:ring-2 focus:ring-black/5"
                            style={{
                                backgroundColor: 'rgba(255, 255, 255, 0.6)',
                                backdropFilter: 'blur(10px)',
                                color: colors.text
                            }}
                        />
                    </motion.div>
                </div>

                <div className="flex gap-8 items-start">
                    {distributedDiaries.map((colDiaries, colIndex) => (
                        <div key={colIndex} className="flex-1 flex flex-col gap-8">
                            {colDiaries.map((diary, index) => {
                                const mood = moodTypes[diary.mood];
                                // Unique rotation calculation based on diary id or content to be stable
                                const seed = diary.id.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
                                const rotations = [1, -1.5, 2, -1, 1.5, -2];
                                const rotation = rotations[seed % rotations.length];

                                return (
                                    <motion.div
                                        key={diary.id}
                                        initial={{ opacity: 0, y: 50, rotate: rotation }}
                                        whileInView={{ opacity: 1, y: 0, rotate: rotation }}
                                        viewport={{ once: true, margin: "-50px" }}
                                        whileHover={{ y: -10, rotate: 0, scale: 1.02, transition: { duration: 0.3 } }}
                                        transition={{
                                            type: "spring",
                                            stiffness: 200,
                                            damping: 25,
                                            delay: index * 0.05
                                        }}
                                        className="w-full"
                                    >
                                        <GlassCard
                                            className="cursor-pointer flex flex-col group relative overflow-hidden transition-all duration-500"
                                            hover={false}
                                            padding="large"
                                        >
                                            {/* Custom Hover Effect Container */}
                                            <motion.div
                                                className="absolute inset-0 z-0 bg-white/0 transition-colors duration-500 group-hover:bg-white/20"
                                            />

                                            <motion.div
                                                whileHover={{ scale: 1.01 }}
                                                whileTap={{ scale: 0.98 }}
                                                transition={{ type: "spring", stiffness: 300, damping: 25 }}
                                                className="relative z-10"
                                            >
                                                {/* Image */}
                                                {diary.image && (
                                                    <div className="mb-6 rounded-2xl overflow-hidden shadow-sm relative aspect-[4/3] group-hover:shadow-md transition-all duration-500">
                                                        <div className="absolute inset-0 bg-black/5 z-10 transition-opacity group-hover:opacity-0" />
                                                        <img
                                                            src={diary.image}
                                                            alt=""
                                                            className="absolute inset-0 w-full h-full object-cover transition-transform duration-700 ease-out group-hover:scale-105"
                                                        />
                                                    </div>
                                                )}

                                                {/* Header Row: Title & Date & Mood */}
                                                <div className="flex flex-col gap-3 mb-4">
                                                    <div className="flex items-start justify-between">
                                                        <div className="flex flex-col gap-1">
                                                            <h3
                                                                className="font-bold text-2xl leading-tight tracking-tight"
                                                                style={{ color: colors.text }}
                                                            >
                                                                {diary.title}
                                                            </h3>
                                                        </div>

                                                        {mood && (
                                                            <div
                                                                className="flex items-center justify-center w-10 h-10 rounded-full"
                                                                style={{
                                                                    backgroundColor: `${mood.color}15`,
                                                                    color: mood.color,
                                                                }}
                                                            >
                                                                <span className="text-xl">{mood.emoji}</span>
                                                            </div>
                                                        )}
                                                    </div>
                                                </div>

                                                {/* Content Preview */}
                                                <p
                                                    className="text-lg leading-relaxed mb-6 opacity-80 line-clamp-4 font-normal"
                                                    style={{ color: colors.text }}
                                                >
                                                    {diary.content}
                                                </p>

                                                {/* Footer: Tags & Metrics */}
                                                <div className="flex flex-col gap-4">
                                                    {/* AI Tags */}
                                                    {diary.aiTags && diary.aiTags.length > 0 && (
                                                        <div className="flex flex-wrap gap-2">
                                                            {diary.aiTags.map((tag) => (
                                                                <span
                                                                    key={tag}
                                                                    className="px-3 py-1.5 rounded-lg text-sm font-medium transition-colors hover:bg-purple-100/50"
                                                                    style={{
                                                                        backgroundColor: 'rgba(147, 51, 234, 0.05)',
                                                                        color: '#9333ea'
                                                                    }}
                                                                >
                                                                    #{tag}
                                                                </span>
                                                            ))}
                                                        </div>
                                                    )}

                                                    {/* Divider */}
                                                    <div className="h-px w-full bg-black/5" />

                                                    {/* Bottom Metadata */}
                                                    <div className="flex items-center justify-between opacity-60">
                                                        <div className="flex items-center gap-4 text-sm font-medium" style={{ color: colors.text }}>
                                                            {diary.image && (
                                                                <div className="flex items-center gap-1.5">
                                                                    <Calendar size={16} />
                                                                    <span>Image</span>
                                                                </div>
                                                            )}
                                                            <div className="flex items-center gap-1.5">
                                                                <Calendar size={16} />
                                                                <span>{diary.date}</span>
                                                            </div>
                                                        </div>

                                                        {diary.aiSentimentScore !== undefined && (
                                                            <SentimentIndicator score={diary.aiSentimentScore} />
                                                        )}
                                                    </div>
                                                </div>
                                            </motion.div>
                                        </GlassCard>
                                    </motion.div>
                                );
                            })}
                        </div>
                    ))}
                </div>
            </div>
        </div>
    );
};

// 情感评分指示器
const SentimentIndicator: React.FC<{ score: number }> = ({ score }) => {
    const getConfig = () => {
        if (score >= 0.7) {
            return { icon: '😊', color: '#22C55E', label: '积极' };
        } else if (score >= 0.4) {
            return { icon: '🙂', color: '#F97316', label: '中性' };
        } else {
            return { icon: '😔', color: '#EF4444', label: '低落' };
        }
    };

    const { icon, color } = getConfig();

    return (
        <div
            className="flex items-center gap-1.5 text-sm font-medium"
            style={{ color }}
        >
            <span className="text-base">{icon}</span>
            <span>{Math.round(score * 100)}%</span>
        </div>
    );
};
