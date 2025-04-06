//
//  TaskListView.swift
//  SimplyDone
//
//  Created by Prateek Arora on 27/03/25.
//

import Foundation
import SwiftUI
import LocalAuthentication
import AuthenticationServices

struct TaskListView: View {
    @StateObject private var viewModel: TaskListViewModel
    
    @State private var newTaskTitle: String = ""
    @State private var showAddTaskAlert: Bool = false
    @State private var isAuthenticated = false
    @State private var showError = false
    @State private var showErrorMessage: String = ""
    
    init(viewModel: TaskListViewModel = TaskListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Task List
                
                if isAuthenticated {
                    
                
                    List {
                        if !viewModel.pendingTasks.isEmpty {
                            Section(header: Text("Pending Tasks")) {
                                ForEach(viewModel.pendingTasks) { task in
                                    TaskRow(task: task, toggleCompletion: {
                                        viewModel.toggleTaskCompletion(task)
                                    })
                                }
                                .onDelete(perform: viewModel.deleteTask)
                            }
                        }
                        
                        if !viewModel.completedTasks.isEmpty {
                            Section(header: Text("Completed Tasks")) {
                                ForEach(viewModel.completedTasks) { task in
                                    TaskRow(task: task, toggleCompletion: {
                                        viewModel.toggleTaskCompletion(task)
                                    })
                                }
                                .onDelete(perform: viewModel.deleteTask)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                    // Add Task Section
                    HStack {
                        TextField("Enter task title", text: $newTaskTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.leading, 10)
                        
                        Button(action: addTask) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                        .disabled(newTaskTitle.isEmpty)
                        .padding(.trailing, 10)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                } else {
                    SignInWithAppleButton(.signIn) { request in
                       
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        //Handle Apple Sigin
                    } .signInWithAppleButtonStyle(.black)
                        .frame(height: 50)
                        .padding()
                    
                    Button(action: {
                        if BiometricsAuthManager.shared.canUseBiometricAuthentication() {
                            BiometricsAuthManager.shared.authenticateWithBiometrics { result, error in
                                if result {
                                    // Biometric authentication succeeded
                                    isAuthenticated = true
                                    print("Authentication successful")
                                    // Perform post-auth actions, e.g., navigate to the next screen
                                } else {
                                    // Biometric authentication failed
                                    print("Authentication failed: \(error?.localizedDescription ?? "Unknown error")")
                                    showError = true
                                    // Show an alert or feedback to the user
                                }
                            }
                        } else {
                            print("Biometric authentication not available")
                            // Handle devices without biometric capabilities
                        }
                    }) {
                        Text("Login with Touch/Face ID")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }


                }
            }
            .navigationTitle("To-Do List")
            .onAppear {
                viewModel.loadTasks()
                NotificationManager.shared.requestNotificationPermission()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddTaskAlert.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    private func authenticate() {
        BiometricsAuthManager.shared.authenticateWithBiometrics { success, error in
            isAuthenticated = success
        }
    }
    
    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        
        switch result {
        case .success(let authenticate):
            if let _ = authenticate.credential as? ASAuthorizationAppleIDCredential {
                //Mark user is authenticated if Apple ID is valid
                isAuthenticated = true
            }
        case .failure(let error):
            // Capture and display any error
            showErrorMessage = error.localizedDescription
            showError = true
            
        }
    }
}

// MARK: - Private Functions
extension TaskListView {
    private func addTask() {
        guard !newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        viewModel.addTask(title: newTaskTitle)
        newTaskTitle = "" // Clear text after adding
    }
}

// MARK: - Task Row View
struct TaskRow: View {
    let task: Task
    let toggleCompletion: () -> Void
    
    var body: some View {
        HStack {
            Text(task.title)
                .strikethrough(task.isCompleted, color: .gray)
                .foregroundColor(task.isCompleted ? .gray : .primary)
            
            Spacer()
            
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
                .onTapGesture {
                    toggleCompletion()
                }
        }
        .padding(.vertical, 4)
    }
}


