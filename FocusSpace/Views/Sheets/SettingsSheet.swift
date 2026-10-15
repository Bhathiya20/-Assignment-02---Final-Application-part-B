//
//  SettingsSheet.swift
//  FocusSpace
//
//  Created by Bhathiya on 2026-10-16.
//

import SwiftUI

struct SettingsSheet: View {
    @Bindable var store: FocusSpaceStore
    @Environment(\.dismiss) private var dismiss
    
    let focusDurations = [15, 25, 45, 60]
    let breakDurations = [5, 10, 15]
    let appearances = ["System", "Dark Glass", "Light Glass"]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Settings")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Make FocusSpace yours.")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white.opacity(0.4))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 4)
                .overlay(alignment: .bottom) {
                    Divider().background(Color.white.opacity(0.1))
                }
                
                // Focus Preferences
                VStack(alignment: .leading, spacing: 8) {
                    Text("DEFAULT FOCUS DURATION")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(FocusSpaceTheme.goldPrimary)
                        .tracking(1)
                    
                    HStack(spacing: 8) {
                        ForEach(focusDurations, id: \.self) { mins in
                            Button {
                                store.defaultFocusDuration = mins
                                store.setDuration(minutes: mins)
                            } label: {
                                Text("\(mins) min")
                                    .font(.system(size: 12, weight: store.defaultFocusDuration == mins ? .bold : .medium))
                                    .foregroundColor(store.defaultFocusDuration == mins ? FocusSpaceTheme.charcoal900 : .white.opacity(0.7))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background {
                                        if store.defaultFocusDuration == mins {
                                            RoundedRectangle(cornerRadius: 10).fill(FocusSpaceTheme.goldPrimary)
                                        } else {
                                            RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.06))
                                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                // Break Preferences
                VStack(alignment: .leading, spacing: 8) {
                    Text("DEFAULT BREAK DURATION")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(FocusSpaceTheme.goldPrimary)
                        .tracking(1)
                    
                    HStack(spacing: 8) {
                        ForEach(breakDurations, id: \.self) { mins in
                            Button {
                                store.defaultBreakDuration = mins
                            } label: {
                                Text("\(mins) min")
                                    .font(.system(size: 12, weight: store.defaultBreakDuration == mins ? .bold : .medium))
                                    .foregroundColor(store.defaultBreakDuration == mins ? FocusSpaceTheme.charcoal900 : .white.opacity(0.7))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background {
                                        if store.defaultBreakDuration == mins {
                                            RoundedRectangle(cornerRadius: 10).fill(FocusSpaceTheme.goldPrimary)
                                        } else {
                                            RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.06))
                                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                // Audio & Visual Toggles
                VStack(spacing: 12) {
                    Toggle(isOn: $store.enableCompletionSound) {
                        Text("Enable Completion Sound")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.85))
                    }
                    .tint(FocusSpaceTheme.goldPrimary)
                    
                    Divider().background(Color.white.opacity(0.06))
                    
                    Toggle(isOn: $store.showProgressOrnaments) {
                        Text("Show Session Progress Ornaments")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.85))
                    }
                    .tint(FocusSpaceTheme.goldPrimary)
                    
                    Divider().background(Color.white.opacity(0.06))
                    
                    Toggle(isOn: $store.confirmBeforeReset) {
                        Text("Confirm Before Timer Reset")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.85))
                    }
                    .tint(FocusSpaceTheme.goldPrimary)
                }
                .padding(14)
                .visionCardStyle()
                
                // Appearance
                VStack(alignment: .leading, spacing: 8) {
                    Text("APPEARANCE")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(FocusSpaceTheme.goldPrimary)
                        .tracking(1)
                    
                    HStack(spacing: 8) {
                        ForEach(appearances, id: \.self) { app in
                            Button {
                                store.appearanceTheme = app
                            } label: {
                                Text(app)
                                    .font(.system(size: 12, weight: store.appearanceTheme == app ? .bold : .medium))
                                    .foregroundColor(store.appearanceTheme == app ? FocusSpaceTheme.charcoal900 : .white.opacity(0.7))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background {
                                        if store.appearanceTheme == app {
                                            RoundedRectangle(cornerRadius: 10).fill(FocusSpaceTheme.goldPrimary)
                                        } else {
                                            RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.06))
                                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.1), lineWidth: 1))
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                // Spatial Layout Arrangement
                VStack(alignment: .leading, spacing: 8) {
                    Text("SPATIAL WINDOW ARRANGEMENT")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(FocusSpaceTheme.goldPrimary)
                        .tracking(1)
                    
                    HStack(spacing: 8) {
                        layoutCard(name: "Triple Space", icon: "square.split.3x1.fill", isSelected: true)
                        layoutCard(name: "Center Focus", icon: "square.fill", isSelected: false)
                        layoutCard(name: "Compact", icon: "rectangle.compress.vertical", isSelected: false)
                    }
                }
                
                // Local SwiftData Storage Card
                VStack(alignment: .leading, spacing: 10) {
                    Text("LOCAL SWIFTDATA STORAGE")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white.opacity(0.45))
                        .tracking(1)
                    
                    HStack {
                        Text("Total Completed Sessions")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.white.opacity(0.75))
                        Spacer()
                        Text("\(store.cumulativeSessionsCount) Sessions")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(FocusSpaceTheme.goldPrimary)
                    }
                    
                    HStack {
                        Text("Total Focus Time")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.white.opacity(0.75))
                        Spacer()
                        Text(store.cumulativeFocusHoursFormatted)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        store.clearHistory()
                    } label: {
                        Text("Clear Session History")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(FocusSpaceTheme.coralWarning)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(FocusSpaceTheme.coralWarning.opacity(0.1))
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(FocusSpaceTheme.coralWarning.opacity(0.3), lineWidth: 1))
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 4)
                }
                .padding(14)
                .visionCardStyle()
                
                // About
                Text("FocusSpace • Version 1.0 • visionOS SwiftUI Native")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.35))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                WindowGrabBar()
            }
            .padding(26)
        }
        .frame(width: 480, height: 620)
        .visionWindowStyle()
    }
    
    @ViewBuilder
    private func layoutCard(name: String, icon: String, isSelected: Bool) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? FocusSpaceTheme.goldPrimary : .white.opacity(0.6))
            
            Text(name)
                .font(.system(size: 11, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? .white : .white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(isSelected ? FocusSpaceTheme.goldPrimary.opacity(0.15) : Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(isSelected ? FocusSpaceTheme.goldPrimary.opacity(0.4) : Color.white.opacity(0.1), lineWidth: 1)
                )
        }
    }
}
