//
//  SpacesView.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 19.01.2026.
//

import SwiftUI

// This is a placeholder view for the Spaces feature.
// NavigationStack is used because this tab will eventually have
// navigation to space details, creating spaces, etc.

struct SpacesView: View {

    // MARK: - Body

    var body: some View {
        // NavigationStack enables push/pop navigation within this tab
        // Each tab gets its own independent navigation stack
        NavigationStack {
            ZStack {
                // Background color matching the app's dark theme
                Color(white: 0.11)
                    .ignoresSafeArea()

                // Placeholder content
                VStack(spacing: 16) {
                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)

                    Text("Spaces")
                        .font(.title)
                        .foregroundStyle(.white)

                    Text("Deine Gebetsräume werden hier angezeigt")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .navigationTitle("Spaces")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview

#Preview {
    SpacesView()
}
