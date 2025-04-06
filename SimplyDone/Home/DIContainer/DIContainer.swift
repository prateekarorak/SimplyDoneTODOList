//
//  DIContainer.swift
//  SimplyDone
//
//  Created by Prateek Arora on 27/03/25.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()

    // MARK: - Repositories
    let taskRepository: TaskRepository

    private init() {
        // Data Source Initialization
        let localDataSource = CoreDataTaskDataSource(context: CoreDataProvider.shared.context)
        
        // Repository Initialization
        self.taskRepository = TaskRepository(localDataSource: localDataSource)
    }
}
