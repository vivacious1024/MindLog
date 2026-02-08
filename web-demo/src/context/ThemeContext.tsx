import React, { createContext, useContext, useState } from 'react';

export type ThemeType = 'matcha' | 'taro' | 'peach' | 'ocean';

interface ThemeColors {
  background: string;
  primary: string;
  secondary: string;
  accent: string;
  text: string;
  textSecondary: string;
  surface: string;
}

interface ThemeContextType {
  theme: ThemeType;
  setTheme: (theme: ThemeType) => void;
  colors: ThemeColors;
  themeName: string;
  themeDescription: string;
}

const themeConfigs: Record<ThemeType, { colors: ThemeColors; name: string; description: string }> = {
  matcha: {
    name: '抹茶拿铁',
    description: '自然的呼吸感，治愈的抹茶与燕麦色调',
    colors: {
      background: '#FDFCF8',
      primary: '#A8C2A4',
      secondary: '#F2E6D8',
      accent: '#E8A09A',
      text: '#5C5C5C',
      textSecondary: 'rgba(92, 92, 92, 0.6)',
      surface: 'rgba(255, 255, 255, 0.9)',
    },
  },
  taro: {
    name: '芋泥波波',
    description: '梦幻与静谧，柔软的香芋与云朵色调',
    colors: {
      background: '#F6F7FB',
      primary: '#B8B8E0',
      secondary: '#D6E4FF',
      accent: '#FFD180',
      text: '#4A4A68',
      textSecondary: 'rgba(74, 74, 104, 0.6)',
      surface: 'rgba(255, 255, 255, 0.75)',
    },
  },
  peach: {
    name: '蜜桃乌龙',
    description: '温暖与活力，午后阳光般的蜜桃与乌龙色调',
    colors: {
      background: '#FFFAF5',
      primary: '#FFCCBC',
      secondary: '#FFE0B2',
      accent: '#81C784',
      text: '#6D4C41',
      textSecondary: 'rgba(109, 76, 65, 0.6)',
      surface: 'rgba(255, 255, 255, 0.85)',
    },
  },
  ocean: {
    name: '海盐微风',
    description: '清新与专注，如海风吹拂般的透明与清澈',
    colors: {
      background: '#F0FBFD',
      primary: '#8CD1CA',
      secondary: '#D3EEEC',
      accent: '#FFAB91',
      text: '#455A64',
      textSecondary: 'rgba(69, 90, 100, 0.6)',
      surface: 'rgba(255, 255, 255, 0.9)',
    },
  },
};

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export const ThemeProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [theme, setTheme] = useState<ThemeType>('matcha');

  const config = themeConfigs[theme];

  const value: ThemeContextType = {
    theme,
    setTheme,
    colors: config.colors,
    themeName: config.name,
    themeDescription: config.description,
  };

  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>;
};

export const useTheme = () => {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return context;
};
