import { useState, useEffect } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { ThemeProvider } from './context/ThemeContext';
import { Navigation } from './components/Navigation';
import { Background } from './components/Background';
import { JournalPage } from './pages/JournalPage';
import { EditorPage } from './pages/EditorPage';
import { ChatPage } from './pages/ChatPage';
import { CommunityPage } from './pages/CommunityPage';
import { mockDiaries, type DiaryEntry } from './data/mockData';

function AppContent() {
  const [currentPage, setCurrentPage] = useState('home');
  const [showEditor, setShowEditor] = useState(false);
  const [diaries, setDiaries] = useState<DiaryEntry[]>(mockDiaries);

  // Reset scroll on page change
  useEffect(() => {
    window.scrollTo(0, 0);
  }, [currentPage]);

  const handleSaveDiary = (newDiary: DiaryEntry) => {
    setDiaries(prev => [newDiary, ...prev]);
    setShowEditor(false);
    setCurrentPage('home'); // Go to home to see the new card
  };

  const renderPage = () => {
    switch (currentPage) {
      case 'home':
        return <ChatPage />;
      case 'journal':
        return <JournalPage diaries={diaries} />;
      case 'community':
        return <CommunityPage />;
      default:
        return <ChatPage />;
    }
  };

  return (
    <div className="min-h-screen w-full relative overflow-x-hidden">
      <Background />
      <Navigation
        currentPage={currentPage}
        onNavigate={setCurrentPage}
        onAddClick={() => setShowEditor(true)}
      />

      {/* Page Content */}
      <motion.main
        key={currentPage}
        className="w-full min-h-screen relative z-0"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 0.3 }}
      >
        {renderPage()}
      </motion.main>

      {/* Editor Modal */}
      <AnimatePresence>
        {showEditor && (
          <EditorPage
            onClose={() => setShowEditor(false)}
            onSave={handleSaveDiary}
          />
        )}
      </AnimatePresence>
    </div>
  );
}

function App() {
  return (
    <ThemeProvider>
      <AppContent />
    </ThemeProvider>
  );
}

export default App;
