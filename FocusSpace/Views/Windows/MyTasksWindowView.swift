//
//  MyTasksWindowView.swift
//  FocusSpace
//
//  Created by Bhathiya on 2026-10-16.
//

import SwiftUI

struct MyTasksWindowView: View {
    @Bindable var store: FocusSpaceStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            // Window Header with 3 dots & Add Task button
            WindowControlsHeader(windowId: "WINDOW 01 â€¢ TASKS") {
                Button {
                    store.isAddTaskSheetPresented = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(FocusSpaceTheme.goldPrimary)
                            .frame(width: 32, height: 32)
                            .shadow(color: FocusSpaceTheme.goldPrimary.opacity(0.35), radius: 6, x: 0, y: 2)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(FocusSpaceTheme.charcoal900)
                    }
                }
                .buttonStyle(.plain)
                .hoverEffect()
            }
            
            // Title & Subtitle
            VStack(alignment: .leading, spacing: 2) {
                Text("My Tasks")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Stay organized, stay focused.")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            // Task Progress Summary Card
            VStack(spacing: 8) {
                HStack {
                    Text("Task Progress")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    Text("\(store.completedTasksCount) of \(store.totalTasksCount) tasks completed")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(FocusSpaceTheme.goldPrimary)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 8)
                        
                        Capsule()
                            .fill(FocusSpaceTheme.goldGradient)
                            .frame(width: max(geo.size.width * CGFloat(store.taskProgressRatio), 8), height: 8)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: store.taskProgressRatio)
                    }
                }
                .frame(height: 8)
            }
            .padding(14)
            .visionCardStyle()
            
            // Segmented Filter Control (All, Active, Done)
            HStack(spacing: 4) {
                filterButton(title: "All (\(store.tasks.count))", filterKey: "all")
                filterButton(title: "Active (\(store.tasks.filter { !$0.isCompleted }.count))", filterKey: "active")
                filterButton(title: "Done (\(store.tasks.filter { $0.isCompleted }.count))", filterKey: "completed")
            }
            .padding(4)
            .background(RoundedRectangle(cornerRadius: 14).fill(Color.black.opacity(0.35)))
            
            // Task List
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    ForEach(store.filteredTasks) { task in
                        taskRow(task)
                    }
                }
                .padding(.vertical, 2)
            }
            .frame(maxHeight: 380)
            
            Spacer(minLength: 0)
            
            // Bottom Grab Bar
            WindowGrabBar()
        }
        .padding(24)
        .frame(minWidth: 360, maxWidth: 440, minHeight: 620)
        .visionWindowStyle()
    }
    
    // MARK: - Filter Button
    @ViewBuilder
    private func filterButton(title: String, filterKey: String) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                store.taskFilter = filterKey
            }
        } label: {
            Text(title)
                .font(.system(size: 12, weight: store.taskFilter == filterKey ? .semibold : .medium))
                .foregroundColor(store.taskFilter == filterKey ? .white : .white.opacity(0.6))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 7)
                .background {
                    if store.taskFilter == filterKey {
                        RoundedRectangle(cornerRadius: 11, style: .continuous)
                            .fill(Color.white.opacity(0.18))
                            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
                    }
                }
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Task Row Card
    @ViewBuilder
    private func taskRow(_ task: TaskItem) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // Checkbox
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    store.toggleTask(task)
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(task.isCompleted ? FocusSpaceTheme.emeraldSuccess : Color.white.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(task.isCompleted ? FocusSpaceTheme.emeraldSuccess : Color.white.opacity(0.25), lineWidth: 1)
                        )
                        .frame(width: 18, height: 18)
                    
                    if task.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(FocusSpaceTheme.charcoal900)
                    }
                }
            }
            .buttonStyle(.plain)
            .padding(.top, 2)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(task.title)
                        .font(.system(size: 14, weight: task.isFocusing ? .bold : .semibold))
                        .foregroundColor(task.isCompleted ? .white.opacity(0.45) : .white)
                        .strikethrough(task.isCompleted, color: .white.opacity(0.4))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if task.isFocusing {
                        Text("Focusing")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(FocusSpaceTheme.goldPrimary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2.5)
                            .background(
                                Capsule()
                                    .fill(FocusSpaceTheme.goldPrimary.opacity(0.15))
                                    .overlay(Capsule().stroke(FocusSpaceTheme.goldPrimary.opacity(0.4), lineWidth: 1))
                            )
                    } else if task.isCompleted {
                        Text("Done")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(FocusSpaceTheme.emeraldSuccess)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 2.5)
                            .background(Capsule().fill(FocusSpaceTheme.emeraldSuccess.opacity(0.12)))
                    } else {
                        Text(task.category)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.horizontal, 7)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(Color.white.opacity(0.08)))
                    }
                }
                
                HStack(spacing: 6) {
                    Text(task.category)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.white.opacity(0.45))
                    
                    Text("â€¢")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.25))
                    
                    Text(task.statusText)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(
                            task.isCompleted ? FocusSpaceTheme.emeraldSuccess.opacity(0.9) :
                            (task.isFocusing ? FocusSpaceTheme.amberPending : .white.opacity(0.5))
                        )
                }
            }
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(FocusSpaceTheme.charcoal700.opacity(task.isCompleted ? 0.35 : 0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(
                            task.isFocusing ? FocusSpaceTheme.goldPrimary.opacity(0.4) : Color.white.opacity(0.06),
                            lineWidth: task.isFocusing ? 1.5 : 1
                        )
                )
                // Yellow accent bar on leading edge if focusing
                .overlay(alignment: .leading) {
                    if task.isFocusing {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(FocusSpaceTheme.goldPrimary)
                            .frame(width: 3.5)
                            .padding(.vertical, 6)
                    }
                }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !task.isCompleted {
                withAnimation(.spring()) {
                    store.setFocusTask(task)
                }
            }
        }
        .hoverEffect()
    }
}
