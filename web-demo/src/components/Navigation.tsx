import { motion } from 'framer-motion';
import { Users, PlusCircle, Book, Sparkles } from 'lucide-react';
import { useTheme } from '../context/ThemeContext';

interface NavigationProps {
  currentPage: string;
  onNavigate: (page: string) => void;
  onAddClick: () => void;
}

export const Navigation: React.FC<NavigationProps> = ({ currentPage, onNavigate, onAddClick }) => {
  const { colors } = useTheme();

  return (
    <>
      {/* Desktop Header Navigation */}
      <motion.header
        className="hidden md:flex sticky top-0 z-50 justify-center w-full min-h-[96px]"
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
      >
        <div
          className="absolute inset-0 border-b shadow-sm backdrop-blur-md"
          style={{
            backgroundColor: 'rgba(255,255,255,0.85)',
            borderColor: 'rgba(0,0,0,0.05)'
          }}
        />

        <div className="relative z-10 w-full flex items-center justify-between !px-20">
          {/* Logo Area */}
          <div className="flex items-center gap-5">
            <div className="w-14 h-14 rounded-2xl flex items-center justify-center shadow-sm" style={{ backgroundColor: colors.primary }}>
              <Book size={28} className="text-white bg-transparent" />
            </div>
            <span className="text-3xl font-bold tracking-tight" style={{ color: colors.text }}>MindLog</span>
          </div>

          {/* Slogan */}
          <div className="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2">
            <span
              className="text-xl tracking-[0.2em] font-medium"
              style={{
                color: colors.text,
                fontFamily: '"Noto Serif SC", "Songti SC", serif',
                opacity: 0.8
              }}
            >
              记录当下，治愈自我
            </span>
          </div>

          <div className="flex items-center gap-5">
            <motion.button
              onClick={onAddClick}
              className="group flex items-center gap-4 !px-12 !py-3.5 rounded-full text-white text-lg font-bold transition-all shrink-0 whitespace-nowrap"
              style={{
                backgroundColor: colors.primary,
                boxShadow: `inset 0 1px 1px rgba(255, 255, 255, 0.4), 0 4px 12px ${colors.primary}40`,
                fontFamily: '"Outfit", sans-serif'
              }}
              whileHover={{
                y: -1,
                filter: 'brightness(1.05)',
                boxShadow: `inset 0 1px 1px rgba(255, 255, 255, 0.5), 0 8px 16px ${colors.primary}50`
              }}
              whileTap={{ scale: 0.98 }}
            >
              <PlusCircle size={24} className="transition-transform group-hover:rotate-90" />
              <span>写手帐</span>
            </motion.button>
          </div>
        </div>
      </motion.header>

      {/* 底部浮动胶囊导航栏 (Unified) */}
      <motion.nav
        className="fixed bottom-8 left-1/2 -translate-x-1/2 z-[100] flex items-center justify-between px-6 py-4 rounded-full shadow-2xl glass-card"
        initial={{ opacity: 0, y: 50 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3, type: 'spring', stiffness: 300, damping: 30 }}
        style={{
          width: 'min(90vw, 320px)',
          backgroundColor: 'rgba(255,255,255,0.85)',
          backdropFilter: 'blur(20px)',
        }}
      >
        {/* 1. Community (Left) */}
        <motion.button
          onClick={() => onNavigate('community')}
          className="flex flex-col items-center justify-center gap-1 w-14"
          whileTap={{ scale: 0.85 }}
        >
          <div className="relative">
            <div className={`p-2 rounded-xl transition-colors ${currentPage === 'community' ? 'bg-black/5' : ''}`}>
              <Users
                size={24}
                style={{
                  color: currentPage === 'community' ? colors.primary : '#9CA3AF',
                  transition: 'all 0.3s'
                }}
                fill={currentPage === 'community' ? `${colors.primary}30` : 'none'}
                strokeWidth={currentPage === 'community' ? 2.5 : 2}
              />
            </div>
          </div>
          <span className="text-[10px] font-medium" style={{ color: currentPage === 'community' ? colors.primary : '#9CA3AF' }}>
            社区
          </span>
        </motion.button>

        {/* 3. Central Button (Add / Home) */}
        <motion.button
          onClick={() => {
            if (currentPage === 'home') {
              onAddClick();
            } else {
              onNavigate('home');
            }
          }}
          className="relative -top-6 w-16 h-16 rounded-full flex items-center justify-center shadow-lg"
          style={{
            backgroundColor: colors.primary,
            boxShadow: `inset 0 1px 1px rgba(255, 255, 255, 0.4), 0 6px 16px ${colors.primary}50`
          }}
          whileHover={{
            y: -2,
            scale: 1.05,
            boxShadow: `inset 0 1px 1px rgba(255, 255, 255, 0.5), 0 10px 20px ${colors.primary}60`
          }}
          whileTap={{ scale: 0.95 }}
        >
          {currentPage === 'home' ? (
            <PlusCircle size={32} color="white" strokeWidth={2.5} />
          ) : (
            <Sparkles size={30} color="white" strokeWidth={2.5} />
          )}
        </motion.button>

        {/* 4. Journal (Right Inner) */}
        <motion.button
          onClick={() => onNavigate('journal')}
          className="flex flex-col items-center justify-center gap-1 w-14"
          whileTap={{ scale: 0.85 }}
        >
          <div className="relative">
            <div className={`p-2 rounded-xl transition-colors ${currentPage === 'journal' ? 'bg-black/5' : ''}`}>
              <Book
                size={24}
                style={{
                  color: currentPage === 'journal' ? colors.primary : '#9CA3AF',
                  transition: 'all 0.3s'
                }}
                fill={currentPage === 'journal' ? `${colors.primary}30` : 'none'}
                strokeWidth={currentPage === 'journal' ? 2.5 : 2}
              />
            </div>
          </div>
          <span className="text-[10px] font-medium" style={{ color: currentPage === 'journal' ? colors.primary : '#9CA3AF' }}>
            手帐
          </span>
        </motion.button>

      </motion.nav>
    </>
  );
};
