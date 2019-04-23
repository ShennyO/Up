//
//  CoreDataFetchHelper.swift
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

func fetchGoalFromCoreData(entityName: String, type: goalType) -> [NSManagedObject]? {
    let coreData = CoreDataStack.instance
    
    let fetchRequest = NSFetchRequest<Goal>(entityName: entityName)
    let sort = NSSortDescriptor(key: #keyPath(Goal.date), ascending: true)
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


