//
//  WindowGrabBar.swift
//  FocusSpace
//
//  Created by Rusheni Botheju on 2026-10-16.
//

import SwiftUI

struct WindowGrabBar: View {
    var subtitle: String? = nil
    
    var body: some View {
        VStack(spacing: 8) {
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.4))
            }
            
            Capsule()
                .fill(Color.white.opacity(0.28))
                .frame(width: 140, height: 4.5)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 12)
    }
}
