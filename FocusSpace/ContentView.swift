//
//  ContentView.swift
//  FocusSpace
//
//  Created by Bhathiya on 2026-10-16.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    @State private var store = FocusSpaceStore()
    
    var body: some View {
        ZStack {
            // Ambient Dark Canvas Background
            FocusSpaceTheme.darkCanvasGradient
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                // Top Spatial Navigation and Branding Ornament
                FloatingNavigationOrnament(store: store)
                    .padding(.horizontal, 36)
                    .padding(.top, 28)
                
                // Active Workspace Mode View
                Group {
                    switch store.activeViewMode {
                    case .spatialCanvas:
                        SpatialCanvasView(store: store)
                            .transition(.opacity.combined(with: .scale(scale: 0.98)))
                    case .dashboard:
                        DashboardOverviewView(store: store)
                            .transition(.opacity.combined(with: .scale(scale: 0.98)))
                    case .timerWindow:
                        ScrollView {
                            FocusTimerWindowView(store: store)
                                .frame(width: 480)
                                .padding(.vertical, 20)
                        }
                        .transition(.opacity.combined(with: .scale(scale: 0.98)))
                    case .tasksWindow:
                        ScrollView {
                            MyTasksWindowView(store: store)
                                .frame(width: 440)
                                .padding(.vertical, 20)
                        }
                        .transition(.opacity.combined(with: .scale(scale: 0.98)))
                    case .analytics:
                        ScrollView {
                            ProgressAnalyticsWindowView(store: store)
                                .frame(width: 440)
                                .padding(.vertical, 20)
                        }
                        .transition(.opacity.combined(with: .scale(scale: 0.98)))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: store.activeViewMode)
                .padding(.bottom, 12)
            }
        }
        // Modals & Sheets
        .sheet(isPresented: $store.isAddTaskSheetPresented) {
            AddTaskSheet(store: store)
                .presentationBackground(.clear)
        }
        .sheet(isPresented: $store.isSessionCompleteSheetPresented) {
            SessionCompleteSheet(store: store)
                .presentationBackground(.clear)
        }
        .sheet(isPresented: $store.isSettingsSheetPresented) {
            SettingsSheet(store: store)
                .presentationBackground(.clear)
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
