//
//  SpatialCanvasView.swift
//  FocusSpace
//
//  Created by Bhathiya on 2026-10-16.
//

import SwiftUI

struct SpatialCanvasView: View {
    @Bindable var store: FocusSpaceStore
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 24) {
                // Window 1: Tasks Window
                MyTasksWindowView(store: store)
                    .frame(width: 400)
                
                // Window 2: Focus Timer (Center Anchor)
                FocusTimerWindowView(store: store)
                    .frame(width: 440)
                
                // Window 3: Progress Analytics
                ProgressAnalyticsWindowView(store: store)
                    .frame(width: 400)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 20)
        }
    }
}
