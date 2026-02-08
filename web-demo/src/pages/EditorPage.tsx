import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { ImagePlus, X, Sparkles, Loader2, Save } from 'lucide-react';
import { MoodPicker } from '../components/MoodPicker';
import { aiService } from '../services/ai';
import { useTheme } from '../context/ThemeContext';
import type { DiaryEntry } from '../data/mockData';

interface EditorPageProps {
  onClose: () => void;
  onSave: (diary: DiaryEntry) => void;
}

export const EditorPage: React.FC<EditorPageProps> = ({ onClose, onSave }) => {
  const { colors } = useTheme();
  const [title, setTitle] = useState('');
  const [selectedMood, setSelectedMood] = useState('');
  const [content, setContent] = useState('');
  const [isGenerating, setIsGenerating] = useState(false);

  const createDiaryEntry = (analysis?: any, imageUrl?: string): DiaryEntry => {
    return {
      id: Date.now().toString(),
      title: title || '无题',
      date: new Date().toLocaleDateString('zh-CN', { month: 'long', day: 'numeric' }),
      mood: selectedMood as any || 'neutral',
      content: content,
      aiTags: analysis?.tags || [],
      aiSentimentScore: analysis?.sentimentScore,
      image: imageUrl,
    };
  };

  const handleSimpleSave = () => {
    if (!content.trim()) return;
    const entry = createDiaryEntry();
    onSave(entry);
  };

  const handleAISave = async () => {
    if (!content.trim() || isGenerating) return;

    setIsGenerating(true);
    try {
      // 1. Analyze Content
      const analysis = await aiService.analyzeContent(content);

      // 2. Generate Image (based on summary or content)
      const imageUrl = await aiService.generateImage(analysis.summary);

      // 3. Create Entry
      const entry = createDiaryEntry(analysis, imageUrl);

      // 4. Save
      onSave(entry);
    } catch (e) {
      console.error("AI Generation failed", e);
      // Fallback to simple save
      handleSimpleSave();
    } finally {
      setIsGenerating(false);
    }
  };

  const canSubmit = title.trim() && content.trim();

  return (
    <motion.div
      className="fixed inset-0 z-50 flex items-center justify-center p-4"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
    >
      {/* 背景遮罩 */}
      <motion.div
        className="absolute inset-0 bg-black/30 backdrop-blur-sm"
        onClick={onClose}
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
      />

      {/* 编辑器卡片 */}
      <motion.div
        className="relative w-full max-w-lg md:max-w-3xl max-h-[90vh] overflow-y-auto glass-card p-0"
        initial={{ scale: 0.95, opacity: 0, y: 30 }}
        animate={{ scale: 1, opacity: 1, y: 0 }}
        exit={{ scale: 0.95, opacity: 0, y: 30 }}
        transition={{ type: 'spring', stiffness: 300, damping: 30 }}
      >
        {/* Header */}
        <div
          className="sticky top-0 flex items-center justify-between p-4 border-b z-10 backdrop-blur-md"
          style={{
            backgroundColor: 'rgba(255,255,255,0.8)',
            borderColor: `${colors.text}10`,
          }}
        >
          <button
            onClick={onClose}
            className="w-9 h-9 rounded-full flex items-center justify-center btn-press"
            style={{ backgroundColor: `${colors.text}10` }}
          >
            <X size={20} style={{ color: colors.text }} />
          </button>

          <h2
            className="font-semibold text-lg"
            style={{ color: colors.text }}
          >
            写日记
          </h2>

          <div className="w-9" /> {/* Spacer for centering */}
        </div>

        <div className="p-6 md:p-10 space-y-8 pb-32">
          {/* 标题输入 */}
          <div>
            <input
              type="text"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="给今天起个标题..."
              className="w-full text-2xl font-bold bg-transparent border-none outline-none placeholder:opacity-40"
              style={{ color: colors.text }}
            />
          </div>

          {/* 心情选择 */}
          <div>
            <MoodPicker selected={selectedMood} onSelect={setSelectedMood} />
          </div>

          {/* 内容输入 */}
          <div>
            <textarea
              value={content}
              onChange={(e) => setContent(e.target.value)}
              placeholder="写下你的想法..."
              className="w-full h-40 bg-transparent border-none outline-none resize-none text-base leading-relaxed"
              style={{ color: colors.text }}
            />
          </div>

          {/* Action Buttons */}
          <div className="flex flex-col gap-4 mt-8">
            {/* AI Generate Button - Prominent */}
            <motion.button
              onClick={handleAISave}
              disabled={!canSubmit || isGenerating}
              className="w-full py-4 rounded-xl flex items-center justify-center gap-3 font-bold text-white relative overflow-hidden"
              style={{
                backgroundColor: colors.primary,
                boxShadow: `0 8px 20px ${colors.primary}40`
              }}
              whileTap={{ scale: 0.98 }}
            >
              <div className="absolute inset-0 bg-white/10 opacity-0 hover:opacity-100 transition-opacity" />
              {isGenerating ? (
                <>
                  <Loader2 size={24} className="animate-spin" />
                  <span>AI 正在创作回忆...</span>
                </>
              ) : (
                <>
                  <Sparkles size={24} fill="currentColor" />
                  <span>AI 生成回忆卡片</span>
                </>
              )}
            </motion.button>

            {/* Secondary Actions */}
            <div className="flex gap-4">
              <button
                className="flex-1 flex items-center justify-center gap-2 py-3 rounded-xl font-medium transition-colors"
                style={{ backgroundColor: `${colors.text}08`, color: colors.text }}
              >
                <ImagePlus size={20} />
                <span>添加图片</span>
              </button>

              <button
                onClick={handleSimpleSave}
                disabled={!canSubmit}
                className="flex-1 flex items-center justify-center gap-2 py-3 rounded-xl font-medium transition-colors"
                style={{ backgroundColor: `${colors.text}08`, color: colors.text }}
              >
                <Save size={20} />
                <span>仅保存文字</span>
              </button>
            </div>
          </div>
        </div>
      </motion.div>


    </motion.div>
  );
};
