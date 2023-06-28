//
//  CoreDataManager.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/28/23.
//

import CoreData
import UIKit

class CoreDataManager {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private func fetch<M: NSManagedObject> (_ type: M.Type, predicate: NSPredicate?=nil, sort: NSSortDescriptor?=nil) -> [M]? {
        var fetched: [M]?
        let entity = String(describing: type)
        let request = NSFetchRequest<M>(entityName: entity)
        
        request.predicate = predicate
        request.sortDescriptors = [sort] as? [NSSortDescriptor]
        
        do {
            fetched = try context.fetch(request)
        }
        catch {
            print("Error during fetch: \(error)")
        }
        
        return fetched
    }
    
    private func add<M: NSManagedObject>(_ type: M.Type) -> M? {
        
        return nil
    }
    
    
    private func save() {
        
    }
}
