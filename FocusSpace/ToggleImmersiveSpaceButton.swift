//
//  ToggleImmersiveSpaceButton.swift
//  FocusSpace
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

struct ToggleImmersiveSpaceButton: View {

    @Environment(AppModel.self) private var appModel

    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    var body: some View {
        Button {
            Task { @MainActor in
                switch appModel.immersiveSpaceState {
                    case .open:
                        appModel.immersiveSpaceState = .inTransition
                        await dismissImmersiveSpace()
                    case .closed:
                        appModel.immersiveSpaceState = .inTransition
                        switch await openImmersiveSpace(id: appModel.immersiveSpaceID) {
                            case .opened:
                                break
                            case .userCancelled, .error:
                                fallthrough
                            @unknown default:
                                appModel.immersiveSpaceState = .closed
                        }
                    case .inTransition:
                        break
                }
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: appModel.immersiveSpaceState == .open ? "mountain.2.fill" : "visionpro")
                    .font(.system(size: 12, weight: .semibold))
                Text(appModel.immersiveSpaceState == .open ? "Exit Immersion" : "Immersive Space")
                    .font(.system(size: 11, weight: .semibold))
            }
            .foregroundColor(appModel.immersiveSpaceState == .open ? FocusSpaceTheme.charcoal900 : .white.opacity(0.85))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background {
                if appModel.immersiveSpaceState == .open {
                    Capsule().fill(FocusSpaceTheme.emeraldSuccess)
                } else {
                    Capsule().fill(Color.white.opacity(0.1))
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(appModel.immersiveSpaceState == .inTransition)
        .hoverEffect()
    }
}
