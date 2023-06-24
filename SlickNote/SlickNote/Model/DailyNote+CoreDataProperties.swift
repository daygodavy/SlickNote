//
//  DailyNote+CoreDataProperties.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/23/23.
//
//

import Foundation
import CoreData


extension DailyNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyNote> {
        return NSFetchRequest<DailyNote>(entityName: "DailyNote")
    }

    @NSManaged public var note: String?
    @NSManaged public var pinned: Bool
    @NSManaged public var checked: Bool
    @NSManaged public var index: Int64
    @NSManaged public var date: Date?
    @NSManaged public var collection: DailyNoteCollection?
    @NSManaged public var pinnedCollection: DailyNoteCollection?

}

extension DailyNote : Identifiable {

}
