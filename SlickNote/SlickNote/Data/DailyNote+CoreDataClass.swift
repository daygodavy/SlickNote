//
//  DailyNote+CoreDataClass.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/23/23.
//
//

import Foundation
import CoreData

@objc(DailyNote)
public class DailyNote: NSManagedObject {
    convenience init(context: NSManagedObjectContext, date: Date, note: String, pinned: Bool, checked: Bool) {
        let entity = NSEntityDescription.entity(forEntityName: "DailyNote", in: context)!
        self.init(entity: entity, insertInto: context)
        self.date = date
        self.note = note
        self.pinned = pinned
        self.checked = checked
    }
}
