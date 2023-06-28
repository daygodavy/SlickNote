//
//  DailyNoteCollection+CoreDataClass.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/23/23.
//
//

import Foundation
import CoreData

@objc(DailyNoteCollection)
public class DailyNoteCollection: NSManagedObject {
    convenience init(context: NSManagedObjectContext, date: Date) {
        let entity = NSEntityDescription.entity(forEntityName: "DailyNoteCollection", in: context)!
        self.init(entity: entity, insertInto: context)
        self.date = date
    }
}
