import React from 'react';
import { useTheme } from '../context/ThemeContext';

export const Background: React.FC = () => {
  const { colors, theme } = useTheme();

  return (
    <>
      {/* Base Background Color */}
      <div
        className="fixed inset-0 -z-50 transition-colors duration-700 ease-in-out"
        style={{ backgroundColor: colors.background }}
      />

      {/* Mesh Gradient Orbs */}
      <div className="fixed inset-0 -z-40 overflow-hidden pointer-events-none">
        {/* Orb 1: Primary Color - Top Left */}
        <div
          className="absolute top-[-10%] left-[-10%] w-[50vw] h-[50vw] rounded-full mix-blend-multiply filter blur-[80px] opacity-40 animate-blob"
          style={{ backgroundColor: colors.primary }}
        />

        {/* Orb 2: Secondary Color - Top Right */}
        <div
          className="absolute top-[-10%] right-[-10%] w-[50vw] h-[50vw] rounded-full mix-blend-multiply filter blur-[80px] opacity-40 animate-blob animation-delay-2000"
          style={{ backgroundColor: colors.secondary }}
        />

        {/* Orb 3: Accent Color - Bottom Center */}
        <div
          className="absolute bottom-[-20%] left-[20%] w-[60vw] h-[60vw] rounded-full mix-blend-multiply filter blur-[80px] opacity-30 animate-blob animation-delay-4000"
          style={{ backgroundColor: colors.accent }}
        />
      </div>

      {/* Noise Texture Overlay */}
      <div
        className="fixed inset-0 -z-30 opacity-[0.03] pointer-events-none"
        style={{
          backgroundImage: `url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)'/%3E%3C/svg%3E")`,
          transform: 'translateZ(0)', // Force GPU acceleration
        }}
      />
    </>
  );
};
