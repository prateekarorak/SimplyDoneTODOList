//
//  GetTaskUsecase.swift
//  SimplyDone
//
//  Created by Prateek Arora on 27/03/25.
//

import Foundation

class GetTaskUsecase {
    
    private let repository: TaskRepository
    
    init(repository: TaskRepository = TaskRepository()) {
        self.repository = repository
    }
    
    func execute() -> [Task] {
        repository.getTask()
    }
}
