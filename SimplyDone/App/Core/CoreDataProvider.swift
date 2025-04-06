//
//  CoreDataProvider.swift
//  SimplyDone
//
//  Created by Prateek Arora on 27/03/25.
//

import Foundation
import CoreData

class CoreDataProvider {
    
    static let shared = CoreDataProvider()
    
    private init() {}
    
    lazy var persistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "SimplyDoneModel")
        
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                fatalError("Unresolved error\(error),\(error.userInfo)")
            }
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistantContainer.viewContext
    }
    
    func saveContext() {
        let context = persistantContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch  {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
