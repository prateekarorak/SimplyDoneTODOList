//
//  DeleteTaskUseCase.swift
//  SimplyDone
//
//  Created by Prateek Arora on 27/03/25.
//

import Foundation

final class DeleteTaskUseCase {
    private let repository: TaskRepository

    init(repository: TaskRepository) {
        self.repository = repository
    }

    func execute(_ task: Task) {
        repository.deleteTask(task)
    }
}
