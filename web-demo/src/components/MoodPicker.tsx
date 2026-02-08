import React from 'react';
import { motion } from 'framer-motion';
import { moodOptions } from '../data/mockData';
import { useTheme } from '../context/ThemeContext';

interface MoodPickerProps {
  selected: string;
  onSelect: (moodId: string) => void;
}

export const MoodPicker: React.FC<MoodPickerProps> = ({ selected, onSelect }) => {
  const { colors } = useTheme();

  return (
    <div className="grid grid-cols-4 gap-4">
      {moodOptions.map((mood, index) => {
        const isSelected = selected === mood.id;
        
        return (
          <motion.button
            key={mood.id}
            onClick={() => onSelect(mood.id)}
            className="flex flex-col items-center justify-center p-3 rounded-2xl transition-all"
            style={{
              backgroundColor: isSelected ? `${mood.color}15` : colors.surface,
              border: isSelected ? `2px solid ${mood.color}` : '2px solid transparent',
              boxShadow: isSelected 
                ? `0 4px 16px ${mood.color}30` 
                : '0 2px 8px rgba(0,0,0,0.05)',
            }}
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ delay: index * 0.05 }}
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
          >
            <span 
              className="text-4xl mb-2"
              style={{
                transform: isSelected ? 'scale(1.2)' : 'scale(1)',
                transition: 'transform 0.2s ease',
              }}
            >
              {mood.emoji}
            </span>
            <span 
              className="text-xs"
              style={{
                color: isSelected ? mood.color : colors.textSecondary,
                fontWeight: isSelected ? 600 : 400,
              }}
            >
              {mood.label}
            </span>
          </motion.button>
        );
      })}
    </div>
  );
};
