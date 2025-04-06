//
//  CoreDataTaskDataSource.swift
//  SimplyDone
//
//  Created by Prateek Arora on 27/03/25.
//

import Foundation
import CoreData

class CoreDataTaskDataSource {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataProvider.shared.context) {
        self.context = context
    }
    
    // Fetch Tasks
    
    func fetchTask() -> [Task] {
        let fetchRequest: NSFetchRequest<SimplyDoneEntity> = SimplyDoneEntity.fetchRequest()
        
        do {
            let taskEntities = try context.fetch(fetchRequest)
            return taskEntities.map { $0.toDomain() }
            
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }
    
    // Save Tasks
    func saveTask(_ task: Task) {
        let entity = SimplyDoneEntity(context: context)
        entity.id = task.id
        entity.title = task.title
        entity.isCompleted = task.isCompleted
        
        saveContext()
    }
    
    // Delete Tasks
    
    func deleteTask(_ task: Task) {
         let fetchRequest: NSFetchRequest<SimplyDoneEntity> = SimplyDoneEntity.fetchRequest()
         fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
         
         do {
             let tasks = try context.fetch(fetchRequest)
             if let taskEntity = tasks.first {
                 context.delete(taskEntity)
                 saveContext()
             }
         } catch {
             print("Error deleting task: \(error)")
         }
     }
    
    // Save Cntext
    private func saveContext() {
        CoreDataProvider.shared.saveContext()
    }
    
    func updateTask(_ task: Task) {
         let request: NSFetchRequest<SimplyDoneEntity> = SimplyDoneEntity.fetchRequest()
         request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)

         if let entity = (try? context.fetch(request))?.first {
             entity.isCompleted = task.isCompleted
             saveContext()
         }
     }
    
}

extension SimplyDoneEntity {
    
    func toDomain() -> Task {
        return Task(id: id ?? UUID(),
                    title: title ?? "",
                    isCompleted: isCompleted)
    }
}
