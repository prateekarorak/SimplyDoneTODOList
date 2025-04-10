//
//  AddTaskUsecase.swift
//  SimplyDone
//
//  Created by Prateek Arora on 27/03/25.
//

import Foundation

class AddTaskUsecase {
    
    private let repository: TaskRepository
    
    init(repository: TaskRepository = TaskRepository()) {
        self.repository = repository
    }
    
    func execute(_ task: Task) {
        return repository.addTask(task)
    }
}
