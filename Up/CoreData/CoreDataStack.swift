//
//  CoreDataStack.swift
//  Up
//
//  Created by Sunny Ouyang on 4/22/19.
//

import Foundation
import CoreData

enum GoalTypeEnum {
    case timed
    case untimed
    case all
}

enum GoalCompletionEnum {
    case completed
    case incomplete
    case all
}

enum GoalClearanceEnum {
    case notCleared
    case all
}

enum GoalSortingEnum {
    case dateAscending
    case completionDateAscending
    case dateDescending
    case completionDateDescending
    case listOrderDescending
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
    
    func fetchGoal(type: GoalTypeEnum, completed: GoalCompletionEnum, sorting: GoalSortingEnum) -> [NSManagedObject]? {
        let coreData = CoreDataStack.instance
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        let typePredicate: NSPredicate?
        let completedPredicate: NSPredicate?
        var sort: NSSortDescriptor?
        switch sorting {
        case .completionDateAscending:
            sort = NSSortDescriptor(key: #keyPath(Goal.completionDate), ascending: true)
        case .dateAscending:
            sort = NSSortDescriptor(key: #keyPath(Goal.date), ascending: true)
        case .completionDateDescending:
            sort = NSSortDescriptor(key: #keyPath(Goal.completionDate), ascending: false)
        case .listOrderDescending:
            sort = NSSortDescriptor(key: #keyPath(Goal.listOrder), ascending: false)
        default:
            sort = NSSortDescriptor(key: #keyPath(Goal.date), ascending: false)
        }
        fetchRequest.sortDescriptors = [sort!]
        
        switch type {
        case .timed:
            typePredicate = NSPredicate(format: "duration > \(0)")
        case .untimed:
            typePredicate = NSPredicate(format: "duration == \(0)")
        default:
            typePredicate = nil
        }
        
        switch completed {
        case .completed:
            completedPredicate = NSPredicate(format: "completionDate != nil")
        case .incomplete:
            completedPredicate = NSPredicate(format: "completionDate == nil")
        case .all:
            completedPredicate = nil
        }
        
       
        
        var predicateArray: [NSPredicate] = []
        
        if typePredicate != nil {
            predicateArray.append(typePredicate!)
        }
        
        if completedPredicate != nil {
            predicateArray.append(completedPredicate!)
        }
        
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicateArray)
        fetchRequest.predicate = andPredicate
        
        do {
            let result = try coreData.viewContext.fetch(fetchRequest)
            return result
        } catch let error {
            print(error)
        }
        return nil
    }

    
}

