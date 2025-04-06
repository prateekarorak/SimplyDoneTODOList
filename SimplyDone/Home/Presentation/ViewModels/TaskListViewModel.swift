//
//  TaskListViewModel.swift
//  SimplyDone
//
//  Created by Prateek Arora on 27/03/25.
//

import Foundation
import Combine

final class TaskListViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    
    private let getTasksUseCase: GetTaskUsecase
    private let addTaskUseCase: AddTaskUsecase
    private let toggleTaskUseCase: ToggleTaskCompletionUseCase
    private let deleteTaskUseCase: DeleteTaskUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        getTasksUseCase: GetTaskUsecase = GetTaskUsecase(repository: DIContainer.shared.taskRepository),
        addTaskUseCase: AddTaskUsecase = AddTaskUsecase(repository: DIContainer.shared.taskRepository),
        toggleTaskUseCase: ToggleTaskCompletionUseCase = ToggleTaskCompletionUseCase(repository: DIContainer.shared.taskRepository),
        deleteTaskUseCase: DeleteTaskUseCase = DeleteTaskUseCase(repository: DIContainer.shared.taskRepository)
    ) {
        self.getTasksUseCase = getTasksUseCase
        self.addTaskUseCase = addTaskUseCase
        self.toggleTaskUseCase = toggleTaskUseCase
        self.deleteTaskUseCase = deleteTaskUseCase
        
        loadTasks()
    }
    
    // MARK: - Load Tasks
    func loadTasks() {
        tasks = getTasksUseCase.execute()
    }
    
    // MARK: - Add Task
    func addTask(title: String) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let newTask = Task(id: UUID(), title: title, isCompleted: false)
        addTaskUseCase.execute(newTask)
        loadTasks() // Refresh after adding
        NotificationManager.shared.scheduleTaskReminder(for: newTask)
    }
    
    // MARK: - Toggle Task Completion
    func toggleTaskCompletion(_ task: Task) {
          if let index = tasks.firstIndex(where: { $0.id == task.id }) {
              tasks[index].isCompleted.toggle()
              toggleTaskUseCase.execute(tasks[index])
              
              // ✅ Remove notification if task is completed
              if tasks[index].isCompleted {
                  NotificationManager.shared.removeNotification(for: tasks[index])
              }
          }
      }
    
    // MARK: - Delete Task
    func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let taskToDelete = tasks[index]
            deleteTaskUseCase.execute(taskToDelete)
            NotificationManager.shared.removeNotification(for: taskToDelete)
        }
        loadTasks() // Refresh after deletion
    }
}

extension TaskListViewModel {
    var pendingTasks: [Task] {
        tasks.filter { !$0.isCompleted }
    }

    var completedTasks: [Task] {
        tasks.filter { $0.isCompleted }
    }
}
