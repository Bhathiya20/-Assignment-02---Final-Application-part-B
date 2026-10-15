//
//  ProgressAnalyticsWindowView.swift
//  FocusSpace
//
//  Created by Bhathiya on 2026-10-16.
//

import SwiftUI
import Charts

struct ProgressAnalyticsWindowView: View {
    @Bindable var store: FocusSpaceStore
    @State private var selectedTimeRange: String = "Week"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            // Window Header
            WindowControlsHeader(windowId: "WINDOW 03 • PROGRESS") {
                Text("Swift Charts Native")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            // Title & Subtitle
            VStack(alignment: .leading, spacing: 2) {
                Text("Your Progress")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Small steps. Meaningful progress.")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            // 3 Stat Cards Row
            HStack(spacing: 10) {
                statCard(
                    title: "FOCUS TIME",
                    value: store.cumulativeFocusHoursFormatted,
                    subtext: "+1h today",
                    subColor: FocusSpaceTheme.emeraldSuccess,
                    valueColor: FocusSpaceTheme.goldPrimary
                )
                
                statCard(
                    title: "SESSIONS",
                    value: "\(store.cumulativeSessionsCount)",
                    subtext: "\(store.todaySessionsCount) today",
                    subColor: .white.opacity(0.5),
                    valueColor: .white
                )
                
                statCard(
                    title: "TASKS DONE",
                    value: String(format: "%02d", store.completedTasksCount),
                    subtext: store.taskSuccessRateFormatted,
                    subColor: FocusSpaceTheme.emeraldSuccess,
                    valueColor: FocusSpaceTheme.emeraldSuccess
                )
            }
            
            // Weekly Activity Bar Chart Card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Focus Activity")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.85))
                    }
                    
                    Spacer()
                    
                    // Time Range Selector
                    HStack(spacing: 4) {
                        ForEach(["Week", "Month"], id: \.self) { range in
                            Button {
                                selectedTimeRange = range
                            } label: {
                                Text(range)
                                    .font(.system(size: 10, weight: selectedTimeRange == range ? .bold : .medium))
                                    .foregroundColor(selectedTimeRange == range ? FocusSpaceTheme.charcoal900 : .white.opacity(0.6))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background {
                                        if selectedTimeRange == range {
                                            Capsule().fill(FocusSpaceTheme.goldPrimary)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(2)
                    .background(Capsule().fill(Color.white.opacity(0.06)))
                    
                    Text("Today: \(String(format: "%.1f", store.todayFocusHours))h")
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .foregroundColor(FocusSpaceTheme.goldPrimary)
                }
                
                // Swift Charts / Bar Visualization
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(store.weeklyMetrics) { metric in
                        VStack(spacing: 6) {
                            Spacer(minLength: 0)
                            
                            // Bar
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(
                                    metric.isToday ?
                                    AnyShapeStyle(FocusSpaceTheme.goldGradient) :
                                    AnyShapeStyle(Color.white.opacity(0.12))
                                )
                                .frame(height: max(100 * metric.heightPercentage, 12))
                                .shadow(
                                    color: metric.isToday ? FocusSpaceTheme.goldPrimary.opacity(0.35) : Color.clear,
                                    radius: 6, x: 0, y: 2
                                )
                            
                            // Day Letter
                            Text(metric.dayLetter)
                                .font(.system(size: 10, weight: metric.isToday ? .bold : .medium))
                                .foregroundColor(metric.isToday ? FocusSpaceTheme.goldPrimary : .white.opacity(0.45))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 120)
                .padding(.top, 4)
            }
            .padding(14)
            .visionCardStyle()
            
            // Recent Sessions Section
            VStack(alignment: .leading, spacing: 8) {
                Text("RECENT SESSIONS")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.45))
                    .tracking(1)
                
                VStack(spacing: 8) {
                    ForEach(store.recentSessions.prefix(2)) { session in
                        HStack(spacing: 10) {
                            Circle()
                                .fill(FocusSpaceTheme.emeraldSuccess)
                                .frame(width: 7, height: 7)
                            
                            VStack(alignment: .leading, spacing: 1) {
                                Text(session.title)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text(session.timeFormatted)
                                    .font(.system(size: 10, weight: .regular))
                                    .foregroundColor(.white.opacity(0.45))
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 1) {
                                Text("\(session.durationMinutes) min")
                                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                                    .foregroundColor(.white.opacity(0.85))
                                
                                Text("Completed")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(FocusSpaceTheme.emeraldSuccess)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .visionCardStyle()
                    }
                }
            }
            
            // Motivational Insight Banner
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(FocusSpaceTheme.goldPrimary.opacity(0.2))
                        .frame(width: 26, height: 26)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(FocusSpaceTheme.goldPrimary)
                }
                
                Text("\"You're building a strong, calm focus habit.\"")
                    .font(.system(size: 12, weight: .medium))
                    .italic()
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(FocusSpaceTheme.goldPrimary.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(FocusSpaceTheme.goldPrimary.opacity(0.25), lineWidth: 1)
                    )
            }
            
            Spacer(minLength: 0)
            
            // Bottom Grab Bar
            WindowGrabBar()
        }
        .padding(24)
        .frame(minWidth: 360, maxWidth: 440, minHeight: 620)
        .visionWindowStyle()
    }
    
    // MARK: - Stat Card Subcomponent
    @ViewBuilder
    private func statCard(title: String, value: String, subtext: String, subColor: Color, valueColor: Color) -> some View {
        VStack(spacing: 3) {
            Text(title)
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.white.opacity(0.45))
                .tracking(0.6)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(valueColor)
            
            Text(subtext)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(subColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 6)
        .visionCardStyle()
    }
}
