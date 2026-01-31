//
//  ScheduleItem.swift
//  MindLog_
//
//  Created by AI Assistant on 2026/1/31.
//

import Foundation
import SwiftData

/// 日程安排项
@Model
final class ScheduleItem {
    var id: UUID
    var title: String
    var startDate: Date?
    var endDate: Date?
    var location: String?
    var notes: String?
    var isCompleted: Bool
    var reminderDate: Date?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        startDate: Date? = nil,
        endDate: Date? = nil,
        location: String? = nil,
        notes: String? = nil,
        isCompleted: Bool = false,
        reminderDate: Date? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.notes = notes
        self.isCompleted = isCompleted
        self.reminderDate = reminderDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    /// 标记为已完成
    func markAsCompleted() {
        isCompleted = true
        updatedAt = Date()
    }

    /// 标记为未完成
    func markAsPending() {
        isCompleted = false
        updatedAt = Date()
    }

    /// 是否是全天事件
    var isAllDay: Bool {
        guard let start = startDate,
              let end = endDate else { return false }
        let calendar = Calendar.current
        return calendar.isDate(start, inSameDayAs: end)
    }

    /// 事件持续时长（分钟）
    var durationMinutes: Int? {
        guard let start = startDate,
              let end = endDate else { return nil }
        return Int(end.timeIntervalSince(start) / 60)
    }

    /// 是否已过期
    var isPast: Bool {
        guard let end = endDate else { return false }
        return end < Date()
    }

    /// 是否是今天
    var isToday: Bool {
        guard let start = startDate else { return false }
        return Calendar.current.isDateInToday(start)
    }
}

/// 日程类型
enum ScheduleType: String, CaseIterable, Codable {
    case work = "工作"
    case personal = "个人"
    case meeting = "会议"
    case appointment = "预约"
    case social = "社交"
    case exercise = "运动"
    case study = "学习"
    case travel = "出行"
    case other = "其他"

    var icon: String {
        switch self {
        case .work: return "briefcase.fill"
        case .personal: return "person.fill"
        case .meeting: return "person.2.fill"
        case .appointment: return "calendar.badge.clock"
        case .social: return "person.3.fill"
        case .exercise: return "figure.run"
        case .study: return "book.fill"
        case .travel: return "airplane"
        case .other: return "circle.fill"
        }
    }

    var color: String {
        switch self {
        case .work: return "blue"
        case .personal: return "green"
        case .meeting: return "purple"
        case .appointment: return "orange"
        case .social: return "pink"
        case .exercise: return "red"
        case .study: return "brown"
        case .travel: return "cyan"
        case .other: return "gray"
        }
    }
}
