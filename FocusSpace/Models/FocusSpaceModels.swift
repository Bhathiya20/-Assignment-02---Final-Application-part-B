//
//  FocusSpaceModels.swift
//  FocusSpace
//
//  Created by Bhathiya on 2026-10-16.
//

import Foundation
import SwiftUI

// MARK: - Task Priority
enum TaskPriority: String, Codable, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .low: return "arrow.down"
        case .medium: return "minus"
        case .high: return "arrow.up"
        case .urgent: return "exclamationmark.3"
        }
    }
    
    var color: Color {
        switch self {
        case .low: return FocusSpaceTheme.emeraldSuccess
        case .medium: return FocusSpaceTheme.amberPending
        case .high: return FocusSpaceTheme.coralWarning
        case .urgent: return Color(red: 255/255, green: 100/255, blue: 100/255)
        }
    }
}

// MARK: - Focus Category
enum FocusCategory: String, Codable, CaseIterable, Identifiable {
    case university = "University"
    case study = "Study"
    case development = "Development"
    case research = "Research"
    case personal = "Personal"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .university: return "graduationcap.fill"
        case .study: return "book.closed.fill"
        case .development: return "hammer.fill"
        case .research: return "atom"
        case .personal: return "person.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .university: return FocusSpaceTheme.amberPending
        case .study: return FocusSpaceTheme.purpleAccent
        case .development: return FocusSpaceTheme.emeraldSuccess
        case .research: return FocusSpaceTheme.goldPrimary
        case .personal: return Color(red: 140/255, green: 200/255, blue: 255/255)
        }
    }
}

// MARK: - Task Item Model
struct TaskItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var category: String
    var isCompleted: Bool
    var isFocusing: Bool = false
    var statusText: String
    var notes: String = ""
    var createdAt: Date = Date()
    var completedAt: Date?
    var priority: TaskPriority = .medium
    var estimatedMinutes: Int = 25
    var tags: [String] = []
    
    var categoryColor: Color {
        switch category.lowercased() {
        case "university":
            return FocusSpaceTheme.amberPending
        case "study":
            return FocusSpaceTheme.purpleAccent
        case "development":
            return FocusSpaceTheme.emeraldSuccess
        default:
            return FocusSpaceTheme.goldPrimary
        }
    }
}

// MARK: - Focus Preset Durations
struct FocusPreset: Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var minutes: Int
    var breakMinutes: Int
    var iconName: String
}

// MARK: - Completed Focus Session Record
struct FocusSessionRecord: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var durationMinutes: Int
    var timestamp: Date
    var timeFormatted: String
    var isCompleted: Bool = true
    var taskTitle: String?
    var category: String = "General"
    var efficiencyRating: Int = 5
    var sessionNotes: String = ""
}

// MARK: - Daily Focus Metric for Swift Charts
struct DailyFocusMetric: Identifiable, Hashable {
    var id: UUID = UUID()
    var dayLetter: String
    var hours: Double
    var isToday: Bool = false
    
    var heightPercentage: CGFloat {
        let maxHours: Double = 5.0
        return CGFloat(min(max(hours / maxHours, 0.1), 1.0))
    }
}

// MARK: - Workspace Navigation Mode
enum WorkspaceViewMode: String, CaseIterable, Identifiable {
    case spatialCanvas = "Spatial Canvas View"
    case dashboard = "Dashboard"
    case timerWindow = "Timer Window"
    case tasksWindow = "Tasks Window"
    case analytics = "Analytics"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .spatialCanvas: return "square.3.layers.3d"
        case .dashboard: return "square.grid.2x2"
        case .timerWindow: return "timer"
        case .tasksWindow: return "checklist"
        case .analytics: return "chart.bar.xaxis"
        }
    }
}

// MARK: - Focus Timer State
enum FocusTimerState {
    case idle
    case running
    case paused
    case completed
}
