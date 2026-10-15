//
//  FloatingNavigationOrnament.swift
//  FocusSpace
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

struct FloatingNavigationOrnament: View {
    @Bindable var store: FocusSpaceStore
    
    var body: some View {
        VStack(spacing: 12) {
            // Main Top Bar
            HStack(spacing: 20) {
                // Brand Identifier
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(FocusSpaceTheme.goldGradient)
                            .frame(width: 38, height: 38)
                            .shadow(color: FocusSpaceTheme.goldPrimary.opacity(0.3), radius: 8, x: 0, y: 3)
                        
                        Image(systemName: "clock.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(FocusSpaceTheme.charcoal900)
                    }
                    
                    VStack(alignment: .leading, spacing: 1) {
                        HStack(spacing: 6) {
                            Text("APPLE VISIONOS SPATIAL SUITE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(FocusSpaceTheme.goldPrimary)
                                .tracking(1)
                            
                            Text("SwiftUI Native 2D")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 1.5)
                                .background(Capsule().fill(Color.white.opacity(0.12)))
                        }
                        
                        HStack(spacing: 6) {
                            Text("FocusSpace")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("[Your Focus. Your Space.]")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                }
                
                Spacer()
                
                // Navigation Pill Selector
                HStack(spacing: 4) {
                    ForEach(WorkspaceViewMode.allCases) { mode in
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                store.activeViewMode = mode
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: mode.iconName)
                                    .font(.system(size: 11, weight: .semibold))
                                Text(mode.rawValue)
                                    .font(.system(size: 12, weight: store.activeViewMode == mode ? .bold : .medium))
                            }
                            .foregroundColor(store.activeViewMode == mode ? FocusSpaceTheme.charcoal900 : .white.opacity(0.75))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background {
                                if store.activeViewMode == mode {
                                    Capsule(style: .continuous)
                                        .fill(FocusSpaceTheme.goldPrimary)
                                        .shadow(color: FocusSpaceTheme.goldPrimary.opacity(0.35), radius: 8, x: 0, y: 2)
                                } else {
                                    Color.clear
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Divider()
                        .frame(height: 16)
                        .background(Color.white.opacity(0.2))
                        .padding(.horizontal, 4)
                    
                    // Settings Button
                    Button {
                        store.isSettingsSheetPresented = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.75))
                            .frame(width: 28, height: 28)
                            .background(Circle().fill(Color.white.opacity(0.08)))
                    }
                    .buttonStyle(.plain)
                    .hoverEffect()
                    
                    ToggleImmersiveSpaceButton()
                }
                .padding(5)
                .background {
                    Capsule(style: .continuous)
                        .fill(FocusSpaceTheme.charcoal850.opacity(0.85))
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(FocusSpaceTheme.glassBorder, lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.4), radius: 16, x: 0, y: 8)
                }
            }
            
            // Sub-bar indicator
            HStack {
                HStack(spacing: 6) {
                    Circle()
                        .fill(FocusSpaceTheme.emeraldSuccess)
                        .frame(width: 7, height: 7)
                    
                    Text("LIVE SPATIAL WORKSPACE • SIMULTANEOUS MULTI-WINDOW ARRANGEMENT")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.55))
                        .tracking(0.8)
                }
                
                Spacer()
                
                Text("Gaze & Pinch Targetable • Drag Grab Bars to Reposition")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(FocusSpaceTheme.goldPrimary.opacity(0.85))
            }
            .padding(.horizontal, 4)
        }
    }
}
