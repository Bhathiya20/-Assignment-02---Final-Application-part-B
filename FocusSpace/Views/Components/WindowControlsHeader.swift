//
//  WindowControlsHeader.swift
//  FocusSpace
//
//  Created by Bhathiya on 2026-10-16.
//

import SwiftUI

struct WindowControlsHeader<TrailingContent: View>: View {
    let windowId: String
    @ViewBuilder let trailingContent: () -> TrailingContent
    
    init(windowId: String, @ViewBuilder trailingContent: @escaping () -> TrailingContent = { EmptyView() }) {
        self.windowId = windowId
        self.trailingContent = trailingContent
    }
    
    var body: some View {
        HStack(spacing: 8) {
            // Three visionOS / macOS window dots
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 10, height: 10)
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 10, height: 10)
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 10, height: 10)
                
                Text(windowId)
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.4))
                    .padding(.leading, 6)
            }
            
            Spacer()
            
            trailingContent()
        }
    }
}
