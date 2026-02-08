import React from 'react';
import { motion } from 'framer-motion';
import { Sparkles, Check, Heart, Mail, Search } from 'lucide-react';
import { useTheme } from '../context/ThemeContext';
import { GlassCard } from '../components/GlassCard';

interface ThemeCardProps {
    id: string;
    name: string;
    description: string;
    colors: string[];
    author: string;
    isCurrent: boolean;
    onSelect: () => void;
}

const ThemeCard: React.FC<ThemeCardProps> = ({
    name,
    description,
    colors: themeColors,
    author,
    isCurrent,
    onSelect,
}) => {
    const { colors } = useTheme();

    return (
        <GlassCard className="h-full" padding="large" hover={false}>
            <div className="flex flex-col h-full">
                {/* Author Header */}
                <div className="flex items-center gap-4 mb-5">
                    <div className="w-10 h-10 rounded-full bg-gradient-to-tr from-gray-200 to-gray-100 flex items-center justify-center shadow-sm shrink-0">
                        <Sparkles size={18} className="text-gray-500" />
                    </div>
                    <div>
                        <h3 className="text-base font-bold" style={{ color: colors.text }}>
                            {author}
                        </h3>
                        <p className="text-xs opacity-60 font-medium" style={{ color: colors.text }}>
                            官方设计
                        </p>
                    </div>
                </div>

                {/* Content */}
                <div className="mb-6 flex-grow">
                    <h2 className="text-2xl font-bold mb-3 tracking-tight leading-tight" style={{ color: colors.text }}>
                        {name}
                    </h2>
                    <p className="text-base opacity-80 leading-relaxed" style={{ color: colors.text }}>
                        {description}
                    </p>
                </div>

                {/* Color Bubbles Preview */}
                <div className="flex items-center gap-[-10px] mb-8 pl-3">
                    {themeColors.map((c, i) => (
                        <div
                            key={i}
                            className="w-10 h-10 rounded-full border-4 border-white shadow-md -ml-4 first:ml-0 transform transition-all duration-300 hover:scale-110 hover:z-10 hover:shadow-lg"
                            style={{ backgroundColor: c }}
                        />
                    ))}
                </div>

                {/* Action Button & Social */}
                <div className="flex items-center justify-between mt-auto pt-4">
                    <button
                        onClick={onSelect}
                        disabled={isCurrent}
                        className={`
              flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-bold transition-all
              ${isCurrent
                                ? 'bg-black/5 cursor-default'
                                : 'shadow-md hover:shadow-lg hover:-translate-y-0.5 active:scale-95 text-white'
                            }
            `}
                        style={{
                            backgroundColor: isCurrent ? undefined : themeColors[1], // Primary color
                            color: isCurrent ? colors.textSecondary : '#fff'
                        }}
                    >
                        {isCurrent ? (
                            <>
                                <Check size={16} />
                                <span>已应用</span>
                            </>
                        ) : (
                            <>
                                <Sparkles size={16} />
                                <span>试用</span>
                            </>
                        )}
                    </button>

                    <div className="flex items-center gap-4 opacity-50">
                        <div className="flex items-center gap-1 text-xs font-medium">
                            <Heart size={16} />
                            <span>2.4k</span>
                        </div>
                        <div className="flex items-center gap-1 text-xs font-medium">
                            <Mail size={16} />
                            <span>86</span>
                        </div>
                    </div>
                </div>
            </div>
        </GlassCard>
    );
};

export const CommunityPage: React.FC = () => {
    const { theme, setTheme, colors } = useTheme();

    const themes = [
        {
            id: 'matcha',
            name: 'Matcha Latte 抹茶拿铁',
            description: '清新自然，带来宁静与治愈的写作体验。仿佛置身于初春的茶园。',
            colors: ['#FDFCF8', '#A8C2A4', '#F2E6D8', '#E8A09A'],
            author: 'MindLog Design',
        },
        {
            id: 'ocean',
            name: 'Ocean Breeze 海盐微风',
            description: '广阔海洋的清新气息，让思绪随波逐流。适合沉思与放松。',
            colors: ['#F0FBFD', '#8CD1CA', '#D3EEEC', '#FFAB91'],
            author: 'BlueSky Creator',
        },
        {
            id: 'taro',
            name: 'Taro Cloud 芋泥波波',
            description: '梦幻的紫色，温柔而神秘，像一口甜甜的芋泥蛋糕。',
            colors: ['#F6F7FB', '#B8B8E0', '#D6E4FF', '#FFD180'],
            author: 'Dreamer',
        },
        {
            id: 'peach',
            name: 'Peach Oolong 蜜桃乌龙',
            description: '甜美的粉色，满满少女心，记录每一个心动的瞬间。',
            colors: ['#FFFAF5', '#FFCCBC', '#FFE0B2', '#81C784'],
            author: 'Sweetie',
        },
    ];

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

    const filteredThemes = React.useMemo(() => {
        return themes.filter(t =>
            t.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
            t.description.toLowerCase().includes(searchQuery.toLowerCase()) ||
            t.author.toLowerCase().includes(searchQuery.toLowerCase())
        );
    }, [themes, searchQuery]);

    const distributedThemes = React.useMemo(() => {
        const cols = Array.from({ length: columns }, () => [] as typeof themes);
        filteredThemes.forEach((t, index) => {
            cols[index % columns].push(t);
        });
        return cols;
    }, [filteredThemes, columns]);

    return (
        <div
            className="w-full min-h-screen pt-32 pb-36 px-4 md:px-8"
        >
            <div className="w-full max-w-[1600px] mx-auto">
                {/* Header */}
                <div className="mb-12 pl-2">
                    <div className="flex flex-col md:flex-row md:items-end justify-between gap-8">
                        <div>
                            <motion.div
                                initial={{ opacity: 0, scale: 0.9 }}
                                animate={{ opacity: 1, scale: 1 }}
                                className="inline-block px-4 py-1.5 rounded-full bg-white/50 backdrop-blur-sm text-sm font-medium mb-4 shadow-sm border border-white/40"
                                style={{ color: colors.primary }}
                            >
                                主题工坊
                            </motion.div>
                            <h1 className="text-4xl md:text-5xl font-bold mb-4 tracking-tight" style={{ color: colors.text }}>
                                发现你的风格
                            </h1>
                            <p className="text-lg opacity-70 font-medium max-w-2xl" style={{ color: colors.text }}>
                                探索并应用社区创造的精美界面
                            </p>
                        </div>

                        {/* Search Bar */}
                        <motion.div
                            initial={{ opacity: 0, x: 20 }}
                            animate={{ opacity: 1, x: 0 }}
                            className="relative w-full md:w-80"
                        >
                            <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                                <Search size={20} className="text-gray-400" />
                            </div>
                            <input
                                type="text"
                                placeholder="搜索主题..."
                                value={searchQuery}
                                onChange={(e) => setSearchQuery(e.target.value)}
                                className="w-full py-3 pl-12 pr-6 rounded-2xl border-none outline-none shadow-sm transition-all focus:shadow-md focus:ring-2 focus:ring-black/5"
                                style={{
                                    backgroundColor: 'rgba(255, 255, 255, 0.6)',
                                    backdropFilter: 'blur(10px)',
                                    color: colors.text
                                }}
                            />
                        </motion.div>
                    </div>
                </div>

                {/* Theme Grid - Distributed Masonry Layout */}
                <div className="flex gap-8 items-start">
                    {distributedThemes.map((colThemes, colIndex) => (
                        <div key={colIndex} className="flex-1 flex flex-col gap-8">
                            {colThemes.map((t, index) => {
                                // Predefined rotation angles like HomePage
                                const rotations = [1.5, -2, 2.5, -1.5, 2, -1];
                                const rotation = rotations[index % rotations.length];

                                return (
                                    <motion.div
                                        key={t.id}
                                        className="w-full"
                                        initial={{ opacity: 0, y: 50, rotate: rotation }}
                                        whileInView={{ opacity: 1, y: 0, rotate: rotation }}
                                        viewport={{ once: true }}
                                        whileHover={{ y: -10, rotate: 0, scale: 1.02, transition: { duration: 0.3 } }}
                                        transition={{
                                            type: "spring",
                                            stiffness: 200,
                                            damping: 25,
                                            delay: index * 0.1
                                        }}
                                    >
                                        <ThemeCard
                                            {...t}
                                            isCurrent={theme === t.id}
                                            onSelect={() => setTheme(t.id as any)}
                                        />
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
