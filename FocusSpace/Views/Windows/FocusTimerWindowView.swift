//
//  FocusTimerWindowView.swift
//  FocusSpace
//
//  Created by Bhathiya on 2026-10-16.
//

import SwiftUI

struct FocusTimerWindowView: View {
    @Bindable var store: FocusSpaceStore
    
    var body: some View {
        VStack(alignment: .center, spacing: 18) {
            // Window Header
            WindowControlsHeader(windowId: "WINDOW 02 • MAIN") {
                HStack(spacing: 6) {
                    Circle()
                        .fill(FocusSpaceTheme.goldPrimary)
                        .frame(width: 7, height: 7)
                        .shadow(color: FocusSpaceTheme.goldPrimary, radius: 4)
                    
                    Text(timerStatusBadgeText)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(FocusSpaceTheme.goldPrimary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4.5)
                .background(
                    Capsule()
                        .fill(FocusSpaceTheme.goldPrimary.opacity(0.12))
                        .overlay(Capsule().stroke(FocusSpaceTheme.goldPrimary.opacity(0.25), lineWidth: 1))
                )
            }
            
            // Title Header
            VStack(spacing: 3) {
                HStack(spacing: 8) {
                    Text("Focus Timer")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Pomodoro")
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .foregroundColor(FocusSpaceTheme.goldPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2.5)
                        .background(Capsule().fill(Color.white.opacity(0.1)))
                }
                
                Text("One task. One moment.")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            // Circular Pomodoro Progress Dial
            ZStack {
                // Background Track
                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 10)
                    .frame(width: 220, height: 220)
                
                // Animated Progress Ring
                Circle()
                    .trim(from: 0, to: max(CGFloat(store.timerProgress), 0.001))
                    .stroke(
                        FocusSpaceTheme.goldGradient,
                        style: StrokeStyle(lineWidth: 11, lineCap: .round)
                    )
                    .frame(width: 220, height: 220)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1.0), value: store.timeRemainingSeconds)
                    .shadow(color: FocusSpaceTheme.goldPrimary.opacity(0.25), radius: 10, x: 0, y: 0)
                
                // Center Telemetry
                VStack(spacing: 5) {
                    Text("FOCUS SESSION")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(FocusSpaceTheme.goldPrimary.opacity(0.85))
                        .tracking(2)
                    
                    Text(store.timeRemainingFormatted)
                        .font(.system(size: 44, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
                    
                    // Session Progression Dots
                    HStack(spacing: 6) {
                        ForEach(1...store.totalSessionsTarget, id: \.self) { idx in
                            Circle()
                                .fill(idx <= store.currentSessionIndex ? FocusSpaceTheme.goldPrimary : Color.white.opacity(0.2))
                                .frame(width: 6, height: 6)
                        }
                        
                        Text("Session \(store.currentSessionIndex) of \(store.totalSessionsTarget)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.leading, 4)
                    }
                }
            }
            .padding(.vertical, 4)
            
            // Duration Presets & Steppers
            HStack(spacing: 8) {
                Button {
                    adjustTimer(by: -5)
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(Color.white.opacity(0.08)))
                }
                .buttonStyle(.plain)
                
                HStack(spacing: 6) {
                    durationButton(mins: 15)
                    durationButton(mins: 25)
                    durationButton(mins: 45)
                    durationButton(mins: 60)
                }
                .padding(4)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.black.opacity(0.35)))
                
                Button {
                    adjustTimer(by: 5)
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(Color.white.opacity(0.08)))
                }
                .buttonStyle(.plain)
            }
            
            // Focused Task Card
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(FocusSpaceTheme.goldPrimary.opacity(0.15))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "scope")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(FocusSpaceTheme.goldPrimary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("FOCUSING ON")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white.opacity(0.45))
                        .tracking(1)
                    
                    Text(store.focusedTask?.title ?? "No Active Task")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        store.activeViewMode = .tasksWindow
                    }
                } label: {
                    Text("Change")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(FocusSpaceTheme.goldPrimary)
                }
                .buttonStyle(.plain)
                .hoverEffect()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .visionCardStyle()
            
            // Primary Action Buttons
            HStack(spacing: 12) {
                // Main Start / Pause Button
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        store.toggleTimer()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: store.timerState == .running ? "pause.fill" : "play.fill")
                            .font(.system(size: 14, weight: .bold))
                        
                        Text(timerActionButtonText)
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(FocusSpaceTheme.charcoal900)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background {
                        RoundedRectangle(cornerRadius: FocusSpaceTheme.buttonRadius, style: .continuous)
                            .fill(FocusSpaceTheme.goldGradient)
                            .shadow(color: FocusSpaceTheme.goldPrimary.opacity(0.4), radius: 12, x: 0, y: 4)
                    }
                }
                .buttonStyle(.plain)
                .hoverEffect()
                
                // Reset Button
                Button {
                    withAnimation(.spring()) {
                        store.resetTimer()
                    }
                } label: {
                    Text("Reset")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background {
                            RoundedRectangle(cornerRadius: FocusSpaceTheme.buttonRadius, style: .continuous)
                                .fill(Color.white.opacity(0.08))
                                .overlay(
                                    RoundedRectangle(cornerRadius: FocusSpaceTheme.buttonRadius, style: .continuous)
                                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                )
                        }
                }
                .buttonStyle(.plain)
                .hoverEffect()
            }
            
            Spacer(minLength: 0)
            
            // Spatial Floating Ornament Attached to Center Window
            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    Text("FLOATING ORNAMENT")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white.opacity(0.45))
                        .tracking(1)
                    
                    Button {
                        store.finishSession()
                    } label: {
                        Text("Test Complete")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(FocusSpaceTheme.goldPrimary)
                    }
                    .buttonStyle(.plain)
                    .hoverEffect()
                    
                    Text("|")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.2))
                    
                    Button {
                        withAnimation {
                            store.activeViewMode = .dashboard
                        }
                    } label: {
                        Text("Dashboard")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.75))
                    }
                    .buttonStyle(.plain)
                    .hoverEffect()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .visionOrnamentStyle()
                
                WindowGrabBar()
            }
        }
        .padding(24)
        .frame(minWidth: 380, maxWidth: 460, minHeight: 620)
        .visionWindowStyle(isMainFocus: true)
    }
    
    // MARK: - Helper Views & Computed Props
    private var timerStatusBadgeText: String {
        switch store.timerState {
        case .running: return "Active Session"
        case .paused: return "Timer Paused"
        case .idle: return "Ready to Focus"
        case .completed: return "Completed"
        }
    }
    
    private var timerActionButtonText: String {
        switch store.timerState {
        case .running: return "Pause Focus"
        case .paused: return "Resume Focus"
        case .idle, .completed: return "Start Focus"
        }
    }
    
    @ViewBuilder
    private func durationButton(mins: Int) -> some View {
        let isSelected = store.timerPresetMinutes == mins
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                store.setDuration(minutes: mins)
            }
        } label: {
            Text("\(mins)m")
                .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? FocusSpaceTheme.charcoal900 : .white.opacity(0.65))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(FocusSpaceTheme.goldPrimary)
                            .shadow(color: FocusSpaceTheme.goldPrimary.opacity(0.35), radius: 6, x: 0, y: 2)
                    }
                }
        }
        .buttonStyle(.plain)
    }
    
    private func adjustTimer(by deltaMinutes: Int) {
        let current = store.timerPresetMinutes
        let newDuration = max(5, min(120, current + deltaMinutes))
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            store.setDuration(minutes: newDuration)
        }
    }
}
