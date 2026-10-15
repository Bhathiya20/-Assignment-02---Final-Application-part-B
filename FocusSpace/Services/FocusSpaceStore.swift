//
//  FocusSpaceStore.swift
//  FocusSpace
//
//  Created by Bhathiya on 2026-10-16.
//

import SwiftUI
import Combine

@MainActor
@Observable
final class FocusSpaceStore {
    // MARK: - Navigation View State
    var activeViewMode: WorkspaceViewMode = .dashboard
    var isAddTaskSheetPresented: Bool = false
    var isSessionCompleteSheetPresented: Bool = false
    var isSettingsSheetPresented: Bool = false
    
    // MARK: - Task State
    var tasks: [TaskItem] = [
        TaskItem(
            title: "Complete MADD Assignment",
            category: "University",
            isCompleted: false,
            isFocusing: true,
            statusText: "In Progress",
            notes: "Finalize Spatial UI and test gesture interactions"
        ),
        TaskItem(
            title: "Review Lecture Notes",
            category: "Study",
            isCompleted: false,
            isFocusing: false,
            statusText: "Pending",
            notes: "Human-Computer Interaction week 7 slides"
        ),
        TaskItem(
            title: "Prepare Presentation Slides",
            category: "University",
            isCompleted: true,
            isFocusing: false,
            statusText: "Completed 11:20 AM",
            notes: "Executive deck for spatial demo"
        ),
        TaskItem(
            title: "Practice SwiftUI glassBackgroundEffect",
            category: "Development",
            isCompleted: true,
            isFocusing: false,
            statusText: "Completed 09:45 AM",
            notes: "visionOS 2.0 native material testing"
        ),
        TaskItem(
            title: "Organize Spatial Workspace Assets",
            category: "Development",
            isCompleted: true,
            isFocusing: false,
            statusText: "Completed Yesterday",
            notes: "RealityKit USDZ exports and icons"
        ),
        TaskItem(
            title: "Configure Pomodoro Interval Soundscapes",
            category: "Development",
            isCompleted: true,
            isFocusing: false,
            statusText: "Completed Yesterday",
            notes: "Subtle spatial audio chimes"
        ),
        TaskItem(
            title: "Study Apple HIG for visionOS",
            category: "Study",
            isCompleted: true,
            isFocusing: false,
            statusText: "Completed Oct 14",
            notes: "Ergonomics, focal distance, gaze targets"
        ),
        TaskItem(
            title: "Draft Sprint Retrospective",
            category: "Professional",
            isCompleted: true,
            isFocusing: false,
            statusText: "Completed Oct 13",
            notes: "Key takeaways and next sprint milestones"
        )
    ]
    
    var taskFilter: String = "all" // "all", "active", "completed"
    
    var filteredTasks: [TaskItem] {
        switch taskFilter {
        case "active":
            return tasks.filter { !$0.isCompleted }
        case "completed":
            return tasks.filter { $0.isCompleted }
        default:
            return tasks
        }
    }
    
    var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var totalTasksCount: Int {
        tasks.count
    }
    
    var taskProgressRatio: Double {
        guard totalTasksCount > 0 else { return 0 }
        return Double(completedTasksCount) / Double(totalTasksCount)
    }
    
    var focusedTask: TaskItem? {
        tasks.first(where: { $0.isFocusing }) ?? tasks.first(where: { !$0.isCompleted })
    }
    
    // MARK: - Focus Timer State
    var timerDurationSeconds: Int = 25 * 60
    var timeRemainingSeconds: Int = 23 * 60 + 45 // 23:45 default from design
    var timerState: FocusTimerState = .running
    var timerPresetMinutes: Int = 25
    var currentSessionIndex: Int = 2
    var totalSessionsTarget: Int = 4
    
    var timerProgress: Double {
        guard timerDurationSeconds > 0 else { return 0 }
        return Double(timerDurationSeconds - timeRemainingSeconds) / Double(timerDurationSeconds)
    }
    
    var timeRemainingFormatted: String {
        let mins = timeRemainingSeconds / 60
        let secs = timeRemainingSeconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    // MARK: - Analytics State
    var todayFocusHours: Double = 1.75
    var cumulativeFocusHoursFormatted: String = "5h 30m"
    var todaySessionsCount: Int = 4
    var cumulativeSessionsCount: Int = 12
    var taskSuccessRateFormatted: String = "80% rate"
    
    var weeklyMetrics: [DailyFocusMetric] = [
        DailyFocusMetric(dayLetter: "M", hours: 2.25, isToday: false),
        DailyFocusMetric(dayLetter: "T", hours: 3.25, isToday: false),
        DailyFocusMetric(dayLetter: "W", hours: 1.5, isToday: false),
        DailyFocusMetric(dayLetter: "T", hours: 4.25, isToday: true),
        DailyFocusMetric(dayLetter: "F", hours: 2.5, isToday: false),
        DailyFocusMetric(dayLetter: "S", hours: 1.0, isToday: false),
        DailyFocusMetric(dayLetter: "S", hours: 0.75, isToday: false)
    ]
    
    var recentSessions: [FocusSessionRecord] = [
        FocusSessionRecord(
            title: "Pomodoro Focus",
            durationMinutes: 25,
            timestamp: Date(),
            timeFormatted: "Today, 10:15 AM",
            isCompleted: true,
            taskTitle: "Complete MADD Assignment"
        ),
        FocusSessionRecord(
            title: "Deep Work Session",
            durationMinutes: 45,
            timestamp: Date().addingTimeInterval(-7200),
            timeFormatted: "Today, 08:30 AM",
            isCompleted: true,
            taskTitle: "Review Lecture Notes"
        )
    ]
    
    // MARK: - Settings State
    var defaultFocusDuration: Int = 25
    var defaultBreakDuration: Int = 5
    var enableCompletionSound: Bool = true
    var showProgressOrnaments: Bool = true
    var confirmBeforeReset: Bool = true
    var appearanceTheme: String = "Dark Glass"
    
    // MARK: - Timer Internal Task
    private var timerTask: Task<Void, Never>?
    
    init() {
        startTimerLoop()
    }
    
    // MARK: - Timer Controls
    func startTimerLoop() {
        timerTask?.cancel()
        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard let self = self else { break }
                
                if self.timerState == .running {
                    if self.timeRemainingSeconds > 0 {
                        self.timeRemainingSeconds -= 1
                    } else {
                        self.finishSession()
                    }
                }
            }
        }
    }
    
    func toggleTimer() {
        if timerState == .running {
            timerState = .paused
        } else {
            timerState = .running
        }
    }
    
    func resetTimer() {
        timerState = .idle
        timeRemainingSeconds = timerDurationSeconds
    }
    
    func setDuration(minutes: Int) {
        timerPresetMinutes = minutes
        timerDurationSeconds = minutes * 60
        timeRemainingSeconds = timerDurationSeconds
        timerState = .idle
    }
    
    func finishSession() {
        timerState = .completed
        isSessionCompleteSheetPresented = true
        
        let newSession = FocusSessionRecord(
            title: timerPresetMinutes <= 25 ? "Pomodoro Focus" : "Deep Work Session",
            durationMinutes: timerPresetMinutes,
            timestamp: Date(),
            timeFormatted: "Just now",
            isCompleted: true,
            taskTitle: focusedTask?.title
        )
        recentSessions.insert(newSession, at: 0)
        todaySessionsCount += 1
        cumulativeSessionsCount += 1
        todayFocusHours += Double(timerPresetMinutes) / 60.0
    }
    
    func startBreak(minutes: Int = 5) {
        isSessionCompleteSheetPresented = false
        setDuration(minutes: minutes)
        timerState = .running
    }
    
    // MARK: - Task Controls
    func toggleTask(_ task: TaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isCompleted.toggle()
        if tasks[index].isCompleted {
            tasks[index].statusText = "Completed \(Date().formatted(date: .omitted, time: .shortened))"
            tasks[index].completedAt = Date()
            if tasks[index].isFocusing {
                tasks[index].isFocusing = false
                // Select next active task to focus
                if let next = tasks.first(where: { !$0.isCompleted && $0.id != task.id }) {
                    setFocusTask(next)
                }
            }
        } else {
            tasks[index].statusText = "Pending"
            tasks[index].completedAt = nil
        }
    }
    
    func setFocusTask(_ task: TaskItem) {
        for i in 0..<tasks.count {
            tasks[i].isFocusing = (tasks[i].id == task.id)
            if tasks[i].isFocusing {
                tasks[i].statusText = "In Progress"
            }
        }
    }
    
    func addTask(title: String, category: String, notes: String = "") {
        let newTask = TaskItem(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category,
            isCompleted: false,
            isFocusing: false,
            statusText: "Pending",
            notes: notes
        )
        tasks.insert(newTask, at: 0)
    }
    
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    // MARK: - Extended Productivity Calculations & Presets
    var autoStartBreak: Bool = true
    var ambientSoundIndex: Int = 0
    let ambientSoundOptions: [String] = ["Rainfall", "White Noise", "Forest Echoes", "Coffee Shop", "Mute"]
    
    var focusPresets: [FocusPreset] = [
        FocusPreset(name: "Sprint", minutes: 15, breakMinutes: 3, iconName: "bolt.fill"),
        FocusPreset(name: "Standard", minutes: 25, breakMinutes: 5, iconName: "timer"),
        FocusPreset(name: "Deep Work", minutes: 45, breakMinutes: 10, iconName: "brain.head.profile"),
        FocusPreset(name: "Ultra Focus", minutes: 60, breakMinutes: 15, iconName: "flame.fill")
    ]
    
    func tasksByPriority(_ priority: TaskPriority) -> [TaskItem] {
        tasks.filter { $0.priority == priority }
    }
    
    func tasksByCategory(_ category: String) -> [TaskItem] {
        tasks.filter { $0.category.lowercased() == category.lowercased() }
    }
    
    var totalFocusMinutesThisWeek: Int {
        Int(dailyMetrics.reduce(0.0) { $0 + $1.hours } * 60)
    }
    
    var weeklyGoalCompletionRate: Double {
        let weeklyTargetHours = 20.0
        let totalHours = dailyMetrics.reduce(0.0) { $0 + $1.hours }
        return min(max(totalHours / weeklyTargetHours, 0.0), 1.0)
    }

    func clearHistory() {
        recentSessions.removeAll()
        todaySessionsCount = 0
        todayFocusHours = 0.0
    }
}
