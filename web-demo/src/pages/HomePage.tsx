import React from 'react';
import { motion } from 'framer-motion';
import { Calendar, Image as ImageIcon } from 'lucide-react';
import { GlassCard } from '../components/GlassCard';
import { moodTypes, type DiaryEntry } from '../data/mockData';
import { useTheme } from '../context/ThemeContext';

interface HomePageProps {
  diaries: DiaryEntry[];
}

export const HomePage: React.FC<HomePageProps> = ({ diaries }) => {
  const { colors } = useTheme();

  return (
    <div
      className="w-full min-h-screen"
    >
      {/* Container - 响应式宽度 */}
      <div className="w-full mx-auto px-4 md:!px-20 pb-36 page-container">
        {/* Journal List - Masonry Layout (Responsive: 1 -> 2 -> 3 cols) */}
        <div className="columns-1 md:columns-2 xl:columns-3 gap-8 mt-8">
          {diaries.map((diary, index) => {
            const mood = moodTypes[diary.mood];
            // Predefined rotation angles to ensure liveliness (no zero values)
            const rotations = [2, -1.5, 1.5, -2, 1, -2.5];
            const rotation = rotations[index % rotations.length];

            return (
              <motion.div
                key={diary.id}
                initial={{ opacity: 0, scale: 0.9, y: 50, rotate: rotation }}
                whileInView={{ opacity: 1, scale: 1, y: 0, rotate: rotation }}
                viewport={{ once: true, margin: "-50px" }}
                whileHover={{ y: -10, rotate: 0, scale: 1.02, transition: { duration: 0.3 } }}
                transition={{
                  type: "spring",
                  stiffness: 200,
                  damping: 25,
                  delay: index * 0.05
                }}
                className="break-inside-avoid mb-12 inline-block w-full"
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
                    {/* Image - More Prominent */}
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
                              <ImageIcon size={16} />
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
