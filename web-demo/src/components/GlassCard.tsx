import React from 'react';
import { motion } from 'framer-motion';
// import { useTheme } from '../context/ThemeContext';

interface GlassCardProps {
  children: React.ReactNode;
  className?: string;
  onClick?: () => void;
  hover?: boolean;
  style?: 'regular' | 'subtle' | 'prominent';
  padding?: 'none' | 'small' | 'medium' | 'large';
}

export const GlassCard: React.FC<GlassCardProps> = ({
  children,
  className = '',
  onClick,
  hover = true,
  style = 'regular',
  padding = 'medium',
}) => {
  // const { colors } = useTheme(); // Unused

  const paddingValue = {
    none: '0px',
    small: '16px',
    medium: '24px',
    large: '48px',
  }[padding];

  const styleClass = {
    regular: 'glass-card',
    subtle: 'glass-card-subtle',
    prominent: 'glass-card',
  }[style];

  return (
    <motion.div
      className={`${styleClass} ${className}`}
      onClick={onClick}
      style={{
        cursor: onClick ? 'pointer' : 'default',
        padding: paddingValue,
      }}
      whileHover={hover && onClick ? { scale: 1.01, y: -2 } : undefined}
      whileTap={onClick ? { scale: 0.98 } : undefined}
      initial={{ opacity: 0, y: 16 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3, ease: 'easeOut' }}
    >
      {children}
    </motion.div>
  );
};
