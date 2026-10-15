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
            
            VStack(spacing: 10) {
                Button {
                    store.startBreak(minutes: 5)
                    dismiss()
                } label: {
                    Text("Start 5m Break")
                        .font(.system(size: 13, weight: .bold))
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
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.08))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.12), lineWidth: 1))
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 12)
        }
        .padding(28)
        .frame(width: 380)
        .visionWindowStyle(isMainFocus: true)
    }
}
