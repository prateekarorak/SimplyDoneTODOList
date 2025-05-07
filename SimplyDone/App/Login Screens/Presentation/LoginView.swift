//
//  LoginView.swift
//  SimplyDone
//
//  Created by Prateek Arora on 09/04/25.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "checkmark.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.purple)
                .padding(.bottom, 10)

            Text("Welcome to Simply Done")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Plan it. Do it. Done.")
                .foregroundColor(.gray)

            Spacer()

            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                handleAppleSignIn(result)
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
            .padding(.horizontal)

            Button(action: {
                if BiometricsAuthManager.shared.canUseBiometricAuthentication() {
                    BiometricsAuthManager.shared.authenticateWithBiometrics { result, error in
                        if result {
                            isAuthenticated = true
                        } else {
                            errorMessage = error?.localizedDescription ?? "Authentication Failed"
                            showError = true
                        }
                    }
                } else {
                    errorMessage = "Biometric authentication not available."
                    showError = true
                }
            }) {
                Text("Login with Touch/Face ID")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .alert("Login Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }

    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            if let _ = auth.credential as? ASAuthorizationAppleIDCredential {
                isAuthenticated = true
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
