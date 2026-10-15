//
//  FocusSpaceModels.swift
//  FocusSpace
//
//  Created by Bhathiya on 2026-10-16.
//

import Foundation
import SwiftUI

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

// MARK: - Completed Focus Session Record
struct FocusSessionRecord: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var durationMinutes: Int
    var timestamp: Date
    var timeFormatted: String
    var isCompleted: Bool = true
    var taskTitle: String?
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
