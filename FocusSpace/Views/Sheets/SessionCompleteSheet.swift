//
//  SessionCompleteSheet.swift
//  FocusSpace
//
//  Created by Bhathiya on 2026-10-16.
//

import SwiftUI

struct SessionCompleteSheet: View {
    @Bindable var store: FocusSpaceStore
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            // Celebratory Icon
            ZStack {
                Circle()
                    .fill(FocusSpaceTheme.goldGradient)
                    .frame(width: 64, height: 64)
                    .shadow(color: FocusSpaceTheme.goldPrimary.opacity(0.4), radius: 16, x: 0, y: 6)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(FocusSpaceTheme.charcoal900)
            }
            .padding(.top, 8)
            
            Text("Focus Session Complete!")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            Text("Great work, Alex. You finished \(store.timerPresetMinutes) minutes of deep concentration.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.65))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            // Session Metrics Recap Card
            HStack(spacing: 16) {
                VStack(spacing: 2) {
                    Text("DURATION")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white.opacity(0.45))
                    Text("\(store.timerPresetMinutes)m")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(FocusSpaceTheme.goldPrimary)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 24)
                    .background(Color.white.opacity(0.12))
                
                VStack(spacing: 2) {
                    Text("TASK")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white.opacity(0.45))
                    Text(store.focusedTask?.title ?? "Deep Focus")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.04))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.08), lineWidth: 1))
            )
            
            // Break Selection Buttons
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    Button {
                        store.startBreak(minutes: 5)
                        dismiss()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.system(size: 12))
                            Text("5m Break")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .foregroundColor(FocusSpaceTheme.charcoal900)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(FocusSpaceTheme.goldGradient)
                        )
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        store.startBreak(minutes: 15)
                        dismiss()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "figure.walk")
                                .font(.system(size: 12))
                            Text("15m Walk")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.white.opacity(0.1))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.15), lineWidth: 1))
                        )
                    }
                    .buttonStyle(.plain)
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("Skip Break & Return")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 6)
        }
        .padding(28)
        .frame(width: 400)
        .visionWindowStyle(isMainFocus: true)
    }
}
