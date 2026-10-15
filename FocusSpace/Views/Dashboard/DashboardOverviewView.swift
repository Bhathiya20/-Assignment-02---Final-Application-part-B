//
//  DashboardOverviewView.swift
//  FocusSpace
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

struct DashboardOverviewView: View {
    @Bindable var store: FocusSpaceStore
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                // Top Header Bar
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("YOUR SPATIAL WORKSPACE")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(FocusSpaceTheme.goldPrimary)
                            .tracking(1.5)
                        
                        Text("FocusSpace")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Make every minute count.")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 7) {
                            Circle()
                                .fill(FocusSpaceTheme.emeraldSuccess)
                                .frame(width: 7, height: 7)
                            
                            Text("visionOS Connected")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.06))
                                .overlay(Capsule().stroke(Color.white.opacity(0.12), lineWidth: 1))
                        )
                        
                        Button {
                            store.isSettingsSheetPresented = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.85))
                                .frame(width: 38, height: 38)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.08))
                                        .overlay(Circle().stroke(Color.white.opacity(0.12), lineWidth: 1))
                                )
                        }
                        .buttonStyle(.plain)
                        .hoverEffect()
                    }
                }
                .padding(.bottom, 8)
                .overlay(alignment: .bottom) {
                    Divider().background(Color.white.opacity(0.1))
                }
                
                // Welcome Section
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ready to focus, Alex?")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Your workspace is ready. Pick up where you left off.")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                // 3 Hero Statistic Cards
                HStack(spacing: 16) {
                    overviewStatCard(
                        title: "FOCUS TIME",
                        icon: "clock.fill",
                        iconColor: FocusSpaceTheme.goldPrimary,
                        mainValue: "1h 45m",
                        subtext: "On track for today's goal",
                        subColor: FocusSpaceTheme.emeraldSuccess
                    )
                    
                    overviewStatCard(
                        title: "SESSIONS",
                        icon: "bolt.fill",
                        iconColor: FocusSpaceTheme.goldPrimary,
                        mainValue: String(format: "%02d", store.todaySessionsCount),
                        subtext: "Avg 25 min per session",
                        subColor: .white.opacity(0.5)
                    )
                    
                    overviewStatCard(
                        title: "TASKS DONE",
                        icon: "checkmark.circle.fill",
                        iconColor: FocusSpaceTheme.emeraldSuccess,
                        mainValue: "\(String(format: "%02d", store.completedTasksCount)) / \(String(format: "%02d", store.totalTasksCount))",
                        subtext: "\(Int(store.taskProgressRatio * 100))% completion rate",
                        subColor: FocusSpaceTheme.emeraldSuccess
                    )
                }
                
                // Primary Focus Action Hero Banner
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("RECOMMENDED NEXT STEP")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(FocusSpaceTheme.goldPrimary)
                            .tracking(1)
                        
                        Text("Start a Focus Session")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Clear your mind and focus on what matters. Next scheduled block: \(store.focusedTask?.title ?? "Deep Work").")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.white.opacity(0.65))
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 18) {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("25 MIN")
                                .font(.system(size: 22, weight: .bold, design: .monospaced))
                                .foregroundColor(FocusSpaceTheme.goldPrimary)
                            
                            Text("Pomodoro Duration")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                store.activeViewMode = .timerWindow
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Text("Open Focus Timer")
                                    .font(.system(size: 13, weight: .bold))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 13, weight: .bold))
                            }
                            .foregroundColor(FocusSpaceTheme.charcoal900)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(FocusSpaceTheme.goldGradient)
                                    .shadow(color: FocusSpaceTheme.goldPrimary.opacity(0.35), radius: 8, x: 0, y: 3)
                            )
                        }
                        .buttonStyle(.plain)
                        .hoverEffect()
                    }
                }
                .padding(24)
                .background {
                    RoundedRectangle(cornerRadius: FocusSpaceTheme.cardRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.05), FocusSpaceTheme.goldPrimary.opacity(0.08)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: FocusSpaceTheme.cardRadius, style: .continuous)
                                .stroke(FocusSpaceTheme.goldPrimary.opacity(0.3), lineWidth: 1)
                        )
                }
                
                // Spatial Workspace Launcher: 3 Distinct Window Tiles
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("Your Workspace")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Tap any window to spawn into visionOS")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.white.opacity(0.45))
                    }
                    
                    HStack(spacing: 16) {
                        workspaceLauncherTile(
                            icon: "timer",
                            iconColor: FocusSpaceTheme.goldPrimary,
                            title: "Focus Timer",
                            subtitle: "Stay focused with a dedicated countdown.",
                            targetMode: .timerWindow
                        )
                        
                        workspaceLauncherTile(
                            icon: "checklist",
                            iconColor: FocusSpaceTheme.emeraldSuccess,
                            title: "My Tasks",
                            subtitle: "Keep your priorities in view.",
                            targetMode: .tasksWindow
                        )
                        
                        workspaceLauncherTile(
                            icon: "chart.bar.xaxis",
                            iconColor: FocusSpaceTheme.purpleAccent,
                            title: "Progress Analytics",
                            subtitle: "Track your focus achievements.",
                            targetMode: .analytics
                        )
                    }
                }
                
                // Bottom Grab Bar & Subtitle
                WindowGrabBar(subtitle: "Arrange your windows naturally around your workspace.")
            }
            .padding(36)
            .frame(maxWidth: 1040)
            .visionWindowStyle()
            .padding(24)
        }
    }
    
    // MARK: - Component Helpers
    @ViewBuilder
    private func overviewStatCard(title: String, icon: String, iconColor: Color, mainValue: String, subtext: String, subColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.5))
                    .tracking(1)
                
                Spacer()
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            
            Text(mainValue)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(subtext)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(subColor)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .visionCardStyle()
    }
    
    @ViewBuilder
    private func workspaceLauncherTile(icon: String, iconColor: Color, title: String, subtitle: String, targetMode: WorkspaceViewMode) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                store.activeViewMode = targetMode
            }
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(2)
                    .frame(height: 30, alignment: .topLeading)
                
                HStack(spacing: 4) {
                    Text("Open Window")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(FocusSpaceTheme.goldPrimary)
                    
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(FocusSpaceTheme.goldPrimary)
                }
                .padding(.top, 4)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .visionCardStyle()
        }
        .buttonStyle(.plain)
        .hoverEffect()
    }
}
