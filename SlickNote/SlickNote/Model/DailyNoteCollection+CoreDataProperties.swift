//
//  DailyNoteCollection+CoreDataProperties.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/23/23.
//
//

import Foundation
import CoreData


extension DailyNoteCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyNoteCollection> {
        return NSFetchRequest<DailyNoteCollection>(entityName: "DailyNoteCollection")
    }

    @NSManaged public var date: Date?
    @NSManaged public var notes: NSSet?
    @NSManaged public var pinnedNotes: NSSet?

}

// MARK: Generated accessors for notes
extension DailyNoteCollection {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: DailyNote)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: DailyNote)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

// MARK: Generated accessors for pinnedNotes
extension DailyNoteCollection {

    @objc(addPinnedNotesObject:)
    @NSManaged public func addToPinnedNotes(_ value: DailyNote)

    @objc(removePinnedNotesObject:)
    @NSManaged public func removeFromPinnedNotes(_ value: DailyNote)

    @objc(addPinnedNotes:)
    @NSManaged public func addToPinnedNotes(_ values: NSSet)

    @objc(removePinnedNotes:)
    @NSManaged public func removeFromPinnedNotes(_ values: NSSet)

}

extension DailyNoteCollection : Identifiable {

}
