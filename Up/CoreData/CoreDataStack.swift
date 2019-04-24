//
//  CoreDataStack.swift
//  Up
//
//  Created by Sunny Ouyang on 4/22/19.
//

import Foundation
import CoreData

enum goalType {
    case timed
    case untimed
    case all
}

public final class CoreDataStack {
    static let instance = CoreDataStack()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        //this is a computed property, the closure is run when we access the var persistentContainer, this closure will run and return this container we set
        
        //create our persistent Container, that contains our coordinator
        let container = NSPersistentContainer(name: "Up")
        //Set the persistent store to the container
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    //Making the NSManagedObjectContext - Windows to the persistent Store
    
    lazy var viewContext: NSManagedObjectContext = {
        //receiving the default view Context that is already in the persistentContainer
        //This automatically links the context to the main Queue for us
        let context = persistentContainer.viewContext
        context.name = "View Context"
        return context
    }()
    
    lazy var downloadContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        context.name = "Download Context"
        return context
    }()
    
    
    func saveTo(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchGoalFrom(entityName: String, type: goalType) -> [NSManagedObject]? {
        let coreData = CoreDataStack.instance
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: entityName)
        let sort = NSSortDescriptor(key: #keyPath(Goal.date), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        if type == .timed {
            let predicate = NSPredicate(format: "duration > \(0)")
            fetchRequest.predicate = predicate
        } else if type == .untimed{
            let predicate = NSPredicate(format: "duration == \(0)")
            fetchRequest.predicate = predicate
        }
        do {
            let result = try coreData.viewContext.fetch(fetchRequest)
            return result
        } catch let error {
            print(error)
        }
        return nil
    }

    
}

