//
//  RootView.swift
//  SimplyDone
//
//  Created by Prateek Arora on 09/04/25.
//

import Foundation
import SwiftUI

struct RootView: View {
    @State private var isSplashActive = false
    @State private var isAuthenticated = false

    var body: some View {
        Group {
            if !isSplashActive {
                SplashScreenView(isActive: $isSplashActive)
            } else if isAuthenticated {
                TaskListView()
            } else {
                LoginView(isAuthenticated: $isAuthenticated)
            }
        }
        .animation(.easeInOut, value: isSplashActive)
    }
}
