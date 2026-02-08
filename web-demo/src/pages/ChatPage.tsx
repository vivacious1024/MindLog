import React, { useState, useEffect, useRef } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Send, Mic } from 'lucide-react';
import { aiService } from '../services/ai';
import { GrowthEntity } from '../components/GrowthEntity';

interface Message {
  id: string;
  text: string;
  isAI: boolean;
  actions?: { label: string; handlerId: string; style?: 'primary' | 'secondary' }[];
}

export const ChatPage: React.FC = () => {
  const [input, setInput] = useState('');
  const [isListening, setIsListening] = useState(false);
  const [growthLevel, setGrowthLevel] = useState(10); // Start at Seed
  const [messages, setMessages] = useState<Message[]>([
    {
      id: '0',
      text: '你好，我是你的 AI 心灵伴侣。今天感觉怎么样？有什么想要分享的吗？',
      isAI: true,
    },
  ]);
  const [isThinking, setIsThinking] = useState(false);

  // Ref for auto-scrolling
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const handleSendAction = (actionLabel: string) => {
    const userText = actionLabel;
    setMessages((prev) => [...prev, { id: Date.now().toString(), text: userText, isAI: false }]);
    setIsThinking(true);
    setGrowthLevel(prev => Math.min(prev + 5, 100));

    (async () => {
      try {
        const history = messages.map(m => ({ role: m.isAI ? 'assistant' : 'user', content: m.text }));
        history.push({ role: 'user', content: userText });

        const aiResponse = await aiService.chat(userText, history.slice(-10), 'warm');

        setMessages((prev) => [...prev, {
          id: (Date.now() + 1).toString(),
          text: aiResponse.text,
          isAI: true,
          actions: aiResponse.actions
        }]);
      } catch (error) {
        console.error(error);
      } finally {
        setIsThinking(false);
      }
    })();
  };

  const handleSend = async () => {
    if (!input.trim() || isThinking) return;

    const userText = input;
    setMessages((prev) => [...prev, { id: Date.now().toString(), text: userText, isAI: false }]);
    setInput('');
    setIsThinking(true);
    setGrowthLevel(prev => Math.min(prev + 5, 100));

    try {
      const history = messages.slice(-10).map(m => ({ role: m.isAI ? 'assistant' : 'user', content: m.text }));
      const aiResponse = await aiService.chat(userText, history, 'warm');

      setMessages((prev) => [...prev, {
        id: (Date.now() + 1).toString(),
        text: aiResponse.text,
        isAI: true,
        actions: aiResponse.actions
      }]);
    } catch (error) {
      console.error(error);
      setMessages((prev) => [...prev, {
        id: (Date.now() + 1).toString(),
        text: "抱歉，我现在有点累，请稍后再试。",
        isAI: true,
      }]);
    } finally {
      setIsThinking(false);
    }
  };

  const toggleListening = () => {
    setIsListening(!isListening);
    if (!isListening) setGrowthLevel(prev => Math.min(prev + 2, 100));
  };

  return (
    <motion.div
      className="w-full h-full flex flex-col relative max-w-5xl mx-auto"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
    >
      {/* 1. Growth Entity Area (Top) */}
      <div className="flex-shrink-0 h-[30%] min-h-[200px] flex items-center justify-center w-full relative z-10">
        <GrowthEntity level={growthLevel} isInteracting={isThinking || isListening} />
      </div>

      {/* 2. Messages Area (Middle Scroll) */}
      <div className="flex-1 w-full overflow-y-auto px-4 pb-48 pt-2 scroll-smooth no-scrollbar">
        <div className="space-y-6">
          <AnimatePresence mode='popLayout'>
            {messages.map((message) => (
              <motion.div
                key={message.id}
                initial={{ opacity: 0, y: 20, scale: 0.95 }}
                animate={{ opacity: 1, y: 0, scale: 1 }}
                layout
                className={`flex ${message.isAI ? 'justify-start' : 'justify-end'}`}
              >
                <div
                  className={`max-w-[85%] px-5 py-3.5 rounded-2xl text-[15px] leading-relaxed shadow-sm ${message.isAI
                    ? 'bg-white text-gray-800 rounded-tl-none border border-gray-100'
                    : 'bg-[#A8C2A4] text-white rounded-tr-none'
                    }`}
                >
                  {message.text}
                </div>

                {/* Action Buttons */}
                {message.actions && message.actions.length > 0 && (
                  <div className="w-full flex flex-wrap gap-2 mt-3 ml-1">
                    {message.actions.map((action, idx) => (
                      <motion.button
                        key={idx}
                        className={`px-4 py-2 rounded-xl text-xs font-medium transition-all ${action.style === 'primary'
                          ? 'bg-[#E8A09A] text-white shadow-sm'
                          : 'bg-white text-gray-600 border border-gray-100 hover:bg-gray-50'
                          }`}
                        onClick={() => handleSendAction(action.label)}
                        whileTap={{ scale: 0.95 }}
                      >
                        {action.label}
                      </motion.button>
                    ))}
                  </div>
                )}
              </motion.div>
            ))}
          </AnimatePresence>

          {/* Thinking Indicator */}
          {isThinking && (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              className="flex justify-start pl-2"
            >
              <div className="bg-white px-4 py-2 rounded-full text-xs text-gray-400 flex items-center gap-1.5 border border-gray-50">
                <div className="w-1.5 h-1.5 bg-gray-300 rounded-full animate-bounce" />
                <div className="w-1.5 h-1.5 bg-gray-300 rounded-full animate-bounce delay-75" />
                <div className="w-1.5 h-1.5 bg-gray-300 rounded-full animate-bounce delay-150" />
              </div>
            </motion.div>
          )}
          <div ref={messagesEndRef} className="h-4" />
        </div>
      </div>

      {/* 3. Input Area (Absolute above Nav) */}
      <div className="absolute bottom-[100px] left-0 w-full px-5 z-30">
        <div
          className="flex items-center gap-2 p-1.5 rounded-[28px]"
          style={{
            backgroundColor: 'rgba(255,255,255,0.9)',
            backdropFilter: 'blur(10px)',
            boxShadow: '0 4px 20px rgba(0,0,0,0.05), 0 0 0 1px rgba(0,0,0,0.03)'
          }}
        >
          <motion.button
            onClick={toggleListening}
            className="w-10 h-10 rounded-full flex items-center justify-center shrink-0 hover:bg-black/5 transition-colors"
            whileTap={{ scale: 0.9 }}
          >
            {isListening ? (
              <div className="relative">
                <div className="absolute inset-0 bg-red-400 rounded-full animate-ping opacity-20" />
                <Mic size={20} className="text-red-500" />
              </div>
            ) : (
              <Mic size={20} className="text-gray-400" />
            )}
          </motion.button>

          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && handleSend()}
            placeholder="此刻的想法..."
            className="flex-1 bg-transparent border-none outline-none text-[15px] text-gray-700 placeholder:text-gray-400/70 text-center font-medium"
            disabled={isThinking}
          />

          <motion.button
            onClick={handleSend}
            disabled={!input.trim() || isThinking}
            className="w-10 h-10 rounded-full flex items-center justify-center shrink-0 transition-all"
            style={{
              backgroundColor: input.trim() ? '#A8C2A4' : 'transparent',
            }}
            whileTap={{ scale: 0.9 }}
          >
            <Send size={18} className={input.trim() ? "text-white" : "text-gray-300"} />
          </motion.button>
        </div>
      </div>
    </motion.div>
  );
};
