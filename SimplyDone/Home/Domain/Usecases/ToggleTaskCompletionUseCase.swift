//
//  ToggleTaskCompletionUseCase.swift
//  SimplyDone
//
//  Created by Prateek Arora on 27/03/25.
//

import Foundation

final class ToggleTaskCompletionUseCase {
    private let repository: TaskRepository

    init(repository: TaskRepository) {
        self.repository = repository
    }

    func execute(_ task: Task) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        repository.updateTask(updatedTask)
    }
}
