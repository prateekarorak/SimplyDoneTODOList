//
//  SplashScreenViewController.swift
//  SimplyDone
//
//  Created by Prateek Arora on 09/04/25.
//

import Foundation
import SwiftUI
import Combine
import SwiftUI

struct SplashScreenView: View {
    @State private var animate = false
    @Binding var isActive: Bool

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.purple)
                    .scaleEffect(animate ? 1.1 : 0.8)
                    .opacity(animate ? 1 : 0.5)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animate)

                Text("Simply Done")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.purple)

                Text("Plan it. Do it. Done.")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            animate = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}
