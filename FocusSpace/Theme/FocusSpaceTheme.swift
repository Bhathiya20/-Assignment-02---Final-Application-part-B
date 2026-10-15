//
//  FocusSpaceTheme.swift
//  FocusSpace
//
//  Created by Bhathiya on 2026-10-16.
//

import SwiftUI

enum FocusSpaceTheme {
    // MARK: - Core Palette
    static let goldPrimary = Color(red: 242/255, green: 204/255, blue: 123/255) // #F2CC7B
    static let goldSecondary = Color(red: 217/255, green: 175/255, blue: 96/255) // #D9AF60
    static let goldGlow = Color(red: 242/255, green: 204/255, blue: 123/255, opacity: 0.18)
    
    static let charcoal900 = Color(red: 18/255, green: 18/255, blue: 19/255) // #121213
    static let charcoal850 = Color(red: 25/255, green: 25/255, blue: 26/255) // #19191A
    static let charcoal800 = Color(red: 32/255, green: 32/255, blue: 34/255) // #202022
    static let charcoal700 = Color(red: 40/255, green: 40/255, blue: 44/255) // #28282C
    static let charcoal600 = Color(red: 54/255, green: 54/255, blue: 59/255) // #36363B
    
    static let emeraldSuccess = Color(red: 123/255, green: 201/255, blue: 164/255) // #7BC9A4
    static let coralWarning = Color(red: 232/255, green: 135/255, blue: 135/255) // #E88787
    static let amberPending = Color(red: 245/255, green: 195/255, blue: 90/255)
    static let purpleAccent = Color(red: 186/255, green: 147/255, blue: 252/255)
    
    static let glassBorder = Color.white.opacity(0.14)
    static let subtleBorder = Color.white.opacity(0.08)
    static let innerHighlight = Color.white.opacity(0.18)
    
    // MARK: - Gradients
    static let goldGradient = LinearGradient(
        colors: [goldPrimary, goldSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let darkCanvasGradient = RadialGradient(
        gradient: Gradient(colors: [
            Color(red: 30/255, green: 30/255, blue: 36/255),
            Color(red: 17/255, green: 17/255, blue: 19/255),
            Color(red: 10/255, green: 10/255, blue: 11/255)
        ]),
        center: .top,
        startRadius: 80,
        endRadius: 900
    )
    
    // MARK: - Corner Radii
    static let windowRadius: CGFloat = 36
    static let cardRadius: CGFloat = 24
    static let buttonRadius: CGFloat = 16
    static let chipRadius: CGFloat = 9999
}

// MARK: - View Modifiers for visionOS Glass Aesthetics
struct VisionWindowModifier: ViewModifier {
    var isMainFocus: Bool = false
    
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: FocusSpaceTheme.windowRadius, style: .continuous)
                    .fill(FocusSpaceTheme.charcoal850.opacity(0.72))
                    .overlay(
                        RoundedRectangle(cornerRadius: FocusSpaceTheme.windowRadius, style: .continuous)
                            .stroke(
                                isMainFocus ? FocusSpaceTheme.goldPrimary.opacity(0.35) : FocusSpaceTheme.glassBorder,
                                lineWidth: isMainFocus ? 1.5 : 1
                            )
                    )
                    .shadow(color: Color.black.opacity(0.55), radius: 32, x: 0, y: 16)
                    .shadow(color: isMainFocus ? FocusSpaceTheme.goldPrimary.opacity(0.15) : Color.clear, radius: 24, x: 0, y: 0)
            }
    }
}

struct VisionCardModifier: ViewModifier {
    var borderColor: Color = FocusSpaceTheme.subtleBorder
    var borderWidth: CGFloat = 1
    
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: FocusSpaceTheme.cardRadius, style: .continuous)
                    .fill(FocusSpaceTheme.charcoal700.opacity(0.55))
                    .overlay(
                        RoundedRectangle(cornerRadius: FocusSpaceTheme.cardRadius, style: .continuous)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
            }
    }
}

struct VisionOrnamentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                Capsule(style: .continuous)
                    .fill(FocusSpaceTheme.charcoal850.opacity(0.85))
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(FocusSpaceTheme.glassBorder, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.45), radius: 20, x: 0, y: 10)
            }
    }
}

struct VisionPillModifier: ViewModifier {
    var isSelected: Bool = false
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(isSelected ? FocusSpaceTheme.goldPrimary.opacity(0.18) : Color.white.opacity(0.06))
                    .overlay(
                        Capsule()
                            .stroke(isSelected ? FocusSpaceTheme.goldPrimary.opacity(0.4) : Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
    }
}

extension View {
    func visionWindowStyle(isMainFocus: Bool = false) -> some View {
        modifier(VisionWindowModifier(isMainFocus: isMainFocus))
    }
    
    func visionCardStyle(borderColor: Color = FocusSpaceTheme.subtleBorder, borderWidth: CGFloat = 1) -> some View {
        modifier(VisionCardModifier(borderColor: borderColor, borderWidth: borderWidth))
    }
    
    func visionOrnamentStyle() -> some View {
        modifier(VisionOrnamentModifier())
    }
    
    func visionPillStyle(isSelected: Bool = false) -> some View {
        modifier(VisionPillModifier(isSelected: isSelected))
    }
}
