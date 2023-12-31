//
//  DailyNoteCollectionManager.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/29/23.
//

import CoreData
import Foundation

protocol DailyNCManagerDelegate: AnyObject {
    func refreshUI()
}

class DailyNoteCollectionManager {
    private let context = PersistanceContainer.shared.container.viewContext
    private let cdManager = CoreDataManager()
    
    private var dailyNoteCollection: DailyNoteCollection?
    public var dailyNotes: [DailyNote]?
    public var collectionDates: [Date] = []
    
    weak var delegate: DailyNCManagerDelegate?
    
    init(dailyNoteCollection: DailyNoteCollection? = nil, dailyNotes: [DailyNote]? = nil) {
        self.dailyNoteCollection = dailyNoteCollection
    }
}

// MARK: DailyNoteCollection Management
extension DailyNoteCollectionManager {
    
    func fetchDailyNoteCollection() {
        let pred = NSPredicate(format: "date >= %@", DateUtil.startOfToday as CVarArg)
        
        if let fetchedCollections = cdManager.fetch(DailyNoteCollection.self, predicate: pred)?.first {
            dailyNoteCollection = fetchedCollections
            fetchDailyNotes(dailyNoteCollection?.notes)
        } else {
            let newCollection = createDailyNoteCollection()
            dailyNoteCollection = newCollection
            
            PersistanceContainer.shared.saveContext()
        }
        
        delegate?.refreshUI()
    }
    
    func createDailyNoteCollection() -> DailyNoteCollection {
        guard let pinnedNotes = checkPinnedNotes() else { return DailyNoteCollection(context: context, date: Date()) }
        
        let yesterdayCollection = DailyNoteCollection(context: context, date: Date(), pinnedNotes: pinnedNotes, notes: pinnedNotes)
        
        fetchDailyNotes(yesterdayCollection.notes)
        
        return yesterdayCollection
    }
    
    func checkPinnedNotes() -> NSSet? {
        let pred = NSPredicate(format: "date >= %@ && date <= %@", DateUtil.startOfYesterday as CVarArg, DateUtil.startOfToday as CVarArg)
        
        if let fetchedCollection = cdManager.fetch(DailyNoteCollection.self, predicate: pred)?.first {
            
            guard let pinnedNotes = fetchedCollection.pinnedNotes else { return nil }
            if pinnedNotes.count < 1 { return nil }
            
            return pinnedNotes
        }
        return nil
    }
}


// MARK: DailyNote Management
extension DailyNoteCollectionManager {
    
    private func fetchDailyNotes(_ collection: NSSet?) {
        guard let notes = collection as? Set<DailyNote> else { return }
        if !notes.isEmpty {
            let sortedNotes = notes.sorted { $0.date! > $1.date! }
            self.dailyNotes = sortedNotes
        } else {
            self.dailyNotes = []
        }
    }
    
    func createNewNote(_ note: String) {
        let dailyNote = DailyNote(context: context, date: Date(), note: note, pinned: false, checked: false)
        dailyNoteCollection?.addToNotes(dailyNote)
        
        saveAndRefetch()
    }
    
    func handleDelete(noteToDelete: DailyNote, noteIndex: Int) {
        if noteToDelete.pinned { dailyNoteCollection?.removeFromPinnedNotes(noteToDelete) }
        dailyNoteCollection?.removeFromNotes(noteToDelete)
        self.context.delete(noteToDelete)
        dailyNotes?.remove(at: noteIndex)
        saveAndRefetch()
    }
    
    func handlePin(noteToPin: DailyNote) {
        if noteToPin.pinned {
            noteToPin.pinned = false
            dailyNoteCollection?.removeFromPinnedNotes(noteToPin)
        } else {
            noteToPin.pinned = true
            dailyNoteCollection?.addToPinnedNotes(noteToPin)
        }
        saveAndRefetch()
    }
    
    func handleCheckBox(noteToCheckBox: DailyNote) {
        if noteToCheckBox.checked {
            noteToCheckBox.checked = false
        } else {
            noteToCheckBox.checked = true
        }
        
        saveAndRefetch()
    }
    
    // FIXME: editNoteButtonTapped -> handles edit here
    func updateNote(newNote: String, noteIndex: Int) {
        guard dailyNotes?[noteIndex].note != newNote else { return }
        dailyNotes?[noteIndex].note = newNote
        
        saveAndRefetch()
    }
}

// MARK: DateSelector Management
extension DailyNoteCollectionManager {
    func fetchAllCollectionDates() {
        guard let allCollections = cdManager.fetch(DailyNoteCollection.self) else { return }
        
        collectionDates = allCollections.compactMap { $0.date }
    }
    
    func fetchSelectedDailyNoteCollection(_ selectedDate: Date) {
        let start = DateUtil.startOfDate(selectedDate)
        let end = DateUtil.endOfDate(start)
        let pred = NSPredicate(format: "date >= %@ && date <= %@", start as CVarArg, end as CVarArg)
        
        if let selectedCollection = cdManager.fetch(DailyNoteCollection.self, predicate: pred)?.first {
            self.dailyNoteCollection = selectedCollection
            fetchDailyNotes(self.dailyNoteCollection?.notes)
            
        }
        delegate?.refreshUI()
    }
}


// MARK: Persistance
extension DailyNoteCollectionManager {
    private func saveAndRefetch() {
        PersistanceContainer.shared.saveContext()
        
        // re-fetch data
        fetchDailyNoteCollection()
    }
}
