//
//  ShoppingItem.swift
//  MindLog_
//
//  Created by AI Assistant on 2026/1/31.
//

import Foundation
import SwiftData

/// 购物清单项
@Model
final class ShoppingItem {
    var id: UUID
    var name: String
    var quantity: String?
    var category: String?
    var isPurchased: Bool
    var createdAt: Date
    var purchasedAt: Date?

    init(
        id: UUID = UUID(),
        name: String,
        quantity: String? = nil,
        category: String? = nil,
        isPurchased: Bool = false,
        createdAt: Date = Date(),
        purchasedAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.category = category
        self.isPurchased = isPurchased
        self.createdAt = createdAt
        self.purchasedAt = purchasedAt
    }

    /// 标记为已购买
    func markAsPurchased() {
        isPurchased = true
        purchasedAt = Date()
    }

    /// 标记为未购买
    func markAsUnpurchased() {
        isPurchased = false
        purchasedAt = nil
    }
}

/// 购物清单分类
enum ShoppingCategory: String, CaseIterable, Codable {
    case food = "食品"
    case daily = "日用品"
    case clothing = "服饰"
    case electronics = "电子产品"
    case home = "家居"
    case books = "图书"
    case sports = "运动"
    case beauty = "美妆"
    case other = "其他"

    var icon: String {
        switch self {
        case .food: return "cart.fill"
        case .daily: return "house.fill"
        case .clothing: return "tshirt.fill"
        case .electronics: return "iphone"
        case .home: return "couch.fill"
        case .books: return "book.fill"
        case .sports: return "sportscourt.fill"
        case .beauty: return "sparkles"
        case .other: return "square.grid.2x2.fill"
        }
    }

    var color: String {
        switch self {
        case .food: return "green"
        case .daily: return "blue"
        case .clothing: return "pink"
        case .electronics: return "purple"
        case .home: return "orange"
        case .books: return "brown"
        case .sports: return "red"
        case .beauty: return "yellow"
        case .other: return "gray"
        }
    }
}
