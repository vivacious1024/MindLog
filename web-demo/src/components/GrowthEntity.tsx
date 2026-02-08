import React, { useMemo } from 'react';
import { motion } from 'framer-motion';
import { useTheme } from '../context/ThemeContext';

interface GrowthEntityProps {
    level: number; // 0-100
    isInteracting: boolean;
}

export const GrowthEntity: React.FC<GrowthEntityProps> = ({ level, isInteracting }) => {
    const { colors } = useTheme();

    // Determine Stage based on level
    const stage = useMemo(() => {
        if (level < 30) return 'seed';
        if (level < 70) return 'sprout';
        return 'bloom';
    }, [level]);

    // Randomize shapes slightly for uniqueness
    const randomSeed = useMemo(() => Math.random(), []);

    return (
        <div className="relative w-full h-full flex items-center justify-center">
            {/* Glow Effect */}
            <motion.div
                className="absolute rounded-full blur-xl opacity-30"
                style={{
                    width: stage === 'seed' ? 80 : stage === 'sprout' ? 120 : 160,
                    height: stage === 'seed' ? 80 : stage === 'sprout' ? 120 : 160,
                    backgroundColor: colors.primary,
                }}
                animate={{
                    scale: isInteracting ? 1.2 : [1, 1.1, 1],
                    opacity: isInteracting ? 0.5 : [0.3, 0.4, 0.3],
                }}
                transition={{ duration: 2, repeat: Infinity, ease: "easeInOut" }}
            />

            {/* Core Entity */}
            <div className="relative">
                {stage === 'seed' && (
                    <SeedStage colors={colors} isInteracting={isInteracting} seed={randomSeed} />
                )}
                {stage === 'sprout' && (
                    <SproutStage colors={colors} isInteracting={isInteracting} seed={randomSeed} />
                )}
                {stage === 'bloom' && (
                    <BloomStage colors={colors} isInteracting={isInteracting} seed={randomSeed} />
                )}
            </div>
        </div>
    );
};

const SeedStage = ({ colors, isInteracting, seed }: any) => (
    <motion.div
        className="w-8 h-8 rounded-full"
        style={{ backgroundColor: colors.text }}
        animate={{
            scale: isInteracting ? [1, 1.2, 1] : 1,
            y: [0, -5, 0],
        }}
        transition={{
            y: { duration: 2 + seed, repeat: Infinity, ease: "easeInOut" },
            scale: { duration: 0.5, repeat: isInteracting ? Infinity : 0 }
        }}
    />
);

const SproutStage = ({ colors, isInteracting, seed }: any) => (
    <div className="relative w-16 h-16 flex items-center justify-center">
        {/* Core */}
        <motion.div
            className="w-10 h-10 rounded-full z-10"
            style={{ backgroundColor: colors.text }}
            animate={{ scale: isInteracting ? 1.1 : 1 }}
        />

        {/* Orbiting Particles */}
        {[0, 1, 2].map((i) => (
            <motion.div
                key={i}
                className="absolute w-3 h-3 rounded-full"
                style={{ backgroundColor: colors.primary, opacity: 0.7 }}
                animate={{
                    rotate: 360,
                    scale: [1, 1.2, 1],
                }}
                transition={{
                    rotate: { duration: 3 + i + seed, repeat: Infinity, ease: "linear" },
                    scale: { duration: 1.5, repeat: Infinity }
                }}
                initial={{ rotate: i * 120 }}  // Distribute start positions
            >
                <div className="relative -top-6" /> {/* Offset from center */}
            </motion.div>
        ))}
    </div>
);

const BloomStage = ({ colors, isInteracting, seed }: any) => (
    <div className="relative w-24 h-24 flex items-center justify-center">
        {/* Complex Geometric Core */}
        <motion.div
            className="w-12 h-12 rounded-lg rotate-45 z-10"
            style={{ backgroundColor: colors.text }}
            animate={{
                rotate: [45, 90, 45],
                borderRadius: ["20%", "50%", "20%"]
            }}
            transition={{ duration: 4, repeat: Infinity }}
        />

        {/* Outer Rings */}
        {[0, 1].map(i => (
            <motion.div
                key={i}
                className="absolute border-2 rounded-full"
                style={{
                    borderColor: colors.primary,
                    width: 60 + i * 20,
                    height: 60 + i * 20,
                    opacity: 0.6 - i * 0.2
                }}
                animate={{
                    rotate: i % 2 === 0 ? 360 : -360,
                    scale: isInteracting ? 1.1 : 1
                }}
                transition={{ duration: 8 + i * 2, repeat: Infinity, ease: "linear" }}
            />
        ))}
    </div>
);
