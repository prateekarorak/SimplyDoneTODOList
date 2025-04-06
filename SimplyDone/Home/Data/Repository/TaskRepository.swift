//
//  TaskRepository.swift
//  SimplyDone
//
//  Created by Prateek Arora on 27/03/25.
//

import Foundation

protocol TaskRepositoryProtocol {
    func getTask() -> [Task]
    func addTask(_ task: Task)
    func deleteTask(_ task: Task)
    func updateTask(_ task: Task)
}

class TaskRepository: TaskRepositoryProtocol {
    
    
    private let localDataSource: CoreDataTaskDataSource
    
    init(localDataSource: CoreDataTaskDataSource = CoreDataTaskDataSource()) {
        self.localDataSource = localDataSource
    }
    
    func getTask() -> [Task] {
        return localDataSource.fetchTask()
    }
    
    func addTask(_ task: Task) {
        return localDataSource.saveTask(task)
    }
    
    func deleteTask(_ task: Task) {
        localDataSource.deleteTask(task)
    }
    
    func updateTask(_ task: Task) {
        self.localDataSource.updateTask(task)
    }
}
