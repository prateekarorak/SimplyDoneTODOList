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
    @StateObject private var viewModel: TaskListViewModel = TaskListViewModel()
    @State private var newTaskTitle: String = ""
    @State private var showAddTaskAlert: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                // Task List
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
            }
            .navigationTitle("My Tasks")
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

    private func addTask() {
        guard !newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        viewModel.addTask(title: newTaskTitle)
        newTaskTitle = ""
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


