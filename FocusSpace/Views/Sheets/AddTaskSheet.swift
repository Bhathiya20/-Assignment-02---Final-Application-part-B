//
//  AddTaskSheet.swift
//  FocusSpace
//
//  Created by Bhathiya on 2026-10-16.
//

import SwiftUI

struct AddTaskSheet: View {
    @Bindable var store: FocusSpaceStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var taskTitle: String = ""
    @State private var selectedCategory: String = "University"
    @State private var notes: String = ""
    
    let categories = ["University", "Study", "Development", "Professional"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Text("Add New Task")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
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
            
            // Task Title Input
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Text("Task Title")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    Text("*")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(FocusSpaceTheme.coralWarning)
                }
                
                TextField("e.g. Write Literature Review", text: $taskTitle)
                    .textFieldStyle(.plain)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.white.opacity(0.06))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.12), lineWidth: 1))
                    )
            }
            
            // Category Selector
            VStack(alignment: .leading, spacing: 6) {
                Text("Category")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                HStack(spacing: 8) {
                    ForEach(categories, id: \.self) { cat in
                        Button {
                            selectedCategory = cat
                        } label: {
                            Text(cat)
                                .font(.system(size: 12, weight: selectedCategory == cat ? .bold : .medium))
                                .foregroundColor(selectedCategory == cat ? FocusSpaceTheme.charcoal900 : .white.opacity(0.7))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background {
                                    if selectedCategory == cat {
                                        Capsule().fill(FocusSpaceTheme.goldPrimary)
                                    } else {
                                        Capsule().fill(Color.white.opacity(0.08))
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
            // Notes TextEditor
            VStack(alignment: .leading, spacing: 6) {
                Text("Notes (Optional)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                TextField("Key goals or references...", text: $notes, axis: .vertical)
                    .lineLimit(3...5)
                    .textFieldStyle(.plain)
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.white.opacity(0.06))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.12), lineWidth: 1))
                    )
            }
            
            // Action Buttons
            HStack(spacing: 12) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.08))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.12), lineWidth: 1))
                        )
                }
                .buttonStyle(.plain)
                
                Button {
                    guard !taskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                    store.addTask(title: taskTitle, category: selectedCategory, notes: notes)
                    dismiss()
                } label: {
                    Text("Add Task")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(FocusSpaceTheme.charcoal900)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(FocusSpaceTheme.goldGradient)
                        )
                }
                .buttonStyle(.plain)
                .disabled(taskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(taskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1.0)
            }
            .padding(.top, 8)
        }
        .padding(28)
        .frame(width: 440)
        .visionWindowStyle()
    }
}
