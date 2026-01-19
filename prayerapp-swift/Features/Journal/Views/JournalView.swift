//
//  JournalView.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 19.01.2026.
//

import SwiftUI

// This is a placeholder view for the Journal feature.
// The journal will allow users to write personal prayer notes
// and track their spiritual journey.

struct JournalView: View {

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color matching the app's dark theme
                Color(white: 0.11)
                    .ignoresSafeArea()

                // Placeholder content
                VStack(spacing: 16) {
                    Image(systemName: "book")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)

                    Text("Journal")
                        .font(.title)
                        .foregroundStyle(.white)

                    Text("Deine Gebetstagebuch-Einträge werden hier angezeigt")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .navigationTitle("Journal")
            .foregroundColor(.white)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview

#Preview {
    JournalView()
}
