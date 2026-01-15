//
//  prayerapp_swiftApp.swift
//  prayerapp-swift
//
//  Created by Razvan Macovei on 13.01.2026.
//

import SwiftUI


@main
struct prayerapp_swiftApp: App {
    
    @State private var viewModel: AuthViewModel
    private let authService: AuthService
    
    init() {
        let authService = AuthService(apiClient: .shared, keychainManager: .shared)
        self.authService = authService
        
        APIClient.shared.tokenProvider = authService
        
        _viewModel = State(initialValue: AuthViewModel(authService: authService))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .task {
                    await viewModel.checkExistingAuth()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    Task {
                        await viewModel.checkAndRefreshIfNeeded()
                    }
                }
        }
    }
}
