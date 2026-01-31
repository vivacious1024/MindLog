//
//  FlowLayout.swift
//  MindLog_
//
//  Created by AI Assistant on 2026/1/31.
//

import SwiftUI

/// 流式布局 - 自动换行的标签布局
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    var alignment: HorizontalAlignment = .leading

    init(spacing: CGFloat = 8, alignment: HorizontalAlignment = .leading) {
        self.spacing = spacing
        self.alignment = alignment
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )

        for (index, subview) in subviews.enumerated() {
            let position = result.positions[index]
            let xOffset: CGFloat
            switch alignment {
            case .leading:
                xOffset = 0
            case .center:
                xOffset = (bounds.width - result.rowWidths[result.rowIndices[index]]) / 2
            case .trailing:
                xOffset = bounds.width - result.rowWidths[result.rowIndices[index]]
            default:
                xOffset = 0
            }
            subview.place(at: CGPoint(x: bounds.minX + position.x + xOffset, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }
}

/// 流式布局计算结果
private struct FlowResult {
    let size: CGSize
    let positions: [CGPoint]
    let rowWidths: [CGFloat]
    let rowIndices: [Int]

    init(in maxWidth: CGFloat, subviews: FlowLayout.Subviews, spacing: CGFloat) {
        var positions: [CGPoint] = []
        var rowWidths: [CGFloat] = []
        var rowIndices: [Int] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var currentRowWidth: CGFloat = 0
        var currentRowIndex = 0
        var maxHeightInRow: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > maxWidth && currentX > 0 {
                // 移到下一行
                rowWidths.append(currentRowWidth)
                currentX = 0
                currentY += maxHeightInRow + spacing
                currentRowWidth = 0
                maxHeightInRow = 0
                currentRowIndex += 1
            }

            positions.append(CGPoint(x: currentX, y: currentY))
            rowIndices.append(currentRowIndex)
            currentX += size.width + spacing
            currentRowWidth += size.width + (currentRowWidth > 0 ? spacing : 0)
            maxHeightInRow = max(maxHeightInRow, size.height)
        }

        // 添加最后一行宽度
        if currentRowWidth > 0 {
            rowWidths.append(currentRowWidth)
        }

        self.size = CGSize(width: maxWidth, height: currentY + maxHeightInRow)
        self.positions = positions
        self.rowWidths = rowWidths
        self.rowIndices = rowIndices
    }
}

#Preview {
    FlowLayout(spacing: 12) {
        ForEach(["生活", "美食", "旅行", "工作", "运动", "阅读", "音乐", "电影", "摄影"], id: \.self) { tag in
            Text(tag)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(16)
        }
    }
    .padding()
}
