//
//  CoreDataStack.swift
//  Carry1stEcommerceApp
//
//  Created by GIGL-IT on 25/11/2024.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}

    // Persistent container for Core Data
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CacheModel") // Generic name for your data model
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

    // Context for read/write operations
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // Generic function to fetch data
    func fetchEntities<T: NSManagedObject>(_ entityType: T.Type) -> [T] {
        let fetchRequest = T.fetchRequest()

        do {
            return try context.fetch(fetchRequest) as? [T] ?? []
        } catch {
            print("Failed to fetch entities for \(T.self): \(error)")
            return []
        }
    }

    // Generic function to clear data
    func clearEntities<T: NSManagedObject>(_ entityType: T.Type) {
        let fetchRequest = T.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            print("\(T.self) entities cleared.")
        } catch {
            print("Failed to clear entities for \(T.self): \(error)")
        }
    }

    // Save context changes
    func saveContext() {
        guard context.hasChanges else { return }

        do {
            try context.save()
            print("Context saved successfully.")
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
