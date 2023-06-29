//
//  ViewController.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/15/23.
//

import CoreData
import UIKit

class DailyNoteViewController: UIViewController, DailyNoteTextFieldViewDelegate, DailyNoteTableViewCellDelegate {
    
    // MARK: - UI Components
//    let dailyNoteTableView = UITableView()
//    lazy var shadeView = UIView(frame: view.bounds)
//    var dailyNoteTextBar: DailyNoteTextFieldView!
    
    // MARK: - Variables
    private var noteIndex: Int!
    private let context = PersistanceContainer.shared.container.viewContext

    // MARK: Core Data Temp Variables
    private var dailyNoteCollection: DailyNoteCollection?
    private var dailyNotes = [DailyNote]()
    private var startOfToday: Date!
    private var startOfYesterday: Date!
    
    private var collectionDates: [Date] = []
    
    // MARK: DAILYNOTEVIEW SEPARATION
    var rootView: DailyNoteView {
        view as! DailyNoteView
    }
    
    // MARK: CORE DATA SEPARATION
    let cdManager = CoreDataManager()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupUI()
        view = DailyNoteView()
        setupNavBar()
        registerHideKeyboard()
        rootView.dailyNoteTableView.dataSource = self
        rootView.dailyNoteTableView.delegate = self
        rootView.dailyNoteTextBar.delegate = self
        
        // Core Data: fetch notes
        startOfToday = Calendar.current.startOfDay(for: Date())
        startOfYesterday = Calendar.current.date(byAdding: .day, value: -1, to: startOfToday)!
        fetchDailyNoteCollection()
        fetchAllCollectionDates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}


// MARK: Navigation Bar Setup
extension DailyNoteViewController {
    private func setupNavBar() {
                title = "Slick Note"
                navigationController?.navigationBar.prefersLargeTitles = true
                navigationItem.largeTitleDisplayMode = .never
                navigationController?.navigationBar.backgroundColor = .clear
        
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(calendarButtonTapped))
    }
}



// MARK: Methods
extension DailyNoteViewController {
    // DailyNoteTableViewCellDelegate method to handle edit/delete note
    internal func handleOption(option: String, cell: DailyNoteTableViewCell, note: String) {
        guard let indexPath = rootView.dailyNoteTableView.indexPath(for: cell) else { return }
        noteIndex = indexPath.section
        
        if option == "Delete" {
            handleDelete(noteToDelete: dailyNotes[noteIndex])
        } else if option == "Edit" {
            handleEdit(note: note)
        } else if option == "Pin" {
            handlePin(noteToPin: dailyNotes[noteIndex])
        } else if option == "Checked" {
            handleCheckBox(noteToCheckBox: dailyNotes[noteIndex])
        }
    }
    
    // DailyNoteTextFieldViewDelegate method to handle adding note
    internal func addNoteButtonTapped(withNote note: String) {
        createNewNote(note)
        saveAndRefetch()
    }
    
    // DailyNoteTextFieldViewDelegate method to handle editing note
    internal func editNoteButtonTapped(withNote note: String) {
        guard dailyNotes[noteIndex].note != note else { return }
        dailyNotes[noteIndex].note = note
        
        // TODO: If note is pinned; do I need to update for dailyNoteCollection.pinnedNote also?
        
        saveAndRefetch()
    }
    
    internal func editModeCancelled() {
        rootView.shadeView.removeFromSuperview()
    }
    
    private func createNewNote(_ note: String) {
        let dailyNote = DailyNote(context: context, date: Date(), note: note, pinned: false, checked: false)
        dailyNoteCollection?.addToNotes(dailyNote)
    }
    
    private func handleDelete(noteToDelete: DailyNote) {
        if noteToDelete.pinned { dailyNoteCollection?.removeFromPinnedNotes(noteToDelete) }
        dailyNoteCollection?.removeFromNotes(noteToDelete)
        self.context.delete(noteToDelete)
        dailyNotes.remove(at: noteIndex)
        saveAndRefetch()
    }
    
    private func handleEdit(note: String) {
        view.insertSubview(rootView.shadeView, belowSubview: rootView.dailyNoteTextBar)
        rootView.dailyNoteTextBar.editNote(note: note)
    }
    
    private func handlePin(noteToPin: DailyNote) {
        if noteToPin.pinned {
            noteToPin.pinned = false
            dailyNoteCollection?.removeFromPinnedNotes(noteToPin)
        } else {
            noteToPin.pinned = true
            dailyNoteCollection?.addToPinnedNotes(noteToPin)
        }
        saveAndRefetch()
    }
    
    private func handleCheckBox(noteToCheckBox: DailyNote) {
        if noteToCheckBox.checked {
            noteToCheckBox.checked = false
        } else {
            noteToCheckBox.checked = true
        }
        // TODO: If note is pinned; do I need to update for dailyNoteCollection.pinnedNote also?
        
        saveAndRefetch()
    }
    
    // Handles hiding keyboard if user taps on superview
    private func registerHideKeyboard() {
        let handleKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(handleKeyboard)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
}


// MARK: Core Data Methods
extension DailyNoteViewController {
    private func fetchDailyNoteCollection() {
        let pred = NSPredicate(format: "date >= %@", startOfToday as CVarArg)
        
        if let fetchedCollections = cdManager.fetch(DailyNoteCollection.self, predicate: pred)?.first {
            // DailyNoteCollection exists
            self.dailyNoteCollection = fetchedCollections
            fetchDailyNotes(self.dailyNoteCollection?.notes)
        } else {
            // if today's DailyNoteCollection doesn't exist/empty -> create new DailyNoteCollection
            let newCollection = createDailyNoteCollection()
            self.dailyNoteCollection = newCollection
            
            PersistanceContainer.shared.saveContext()
        }
        
        DispatchQueue.main.async {
            self.rootView.dailyNoteTableView.reloadData()
        }
    }

    
    private func fetchDailyNotes(_ collection: NSSet?) {
        guard let notes = collection as? Set<DailyNote> else { return }
        if !notes.isEmpty && notes.count > 1 {
            let sortedNotes = notes.sorted { $0.date! > $1.date! }
            self.dailyNotes = sortedNotes
        }
    }
    
    private func createDailyNoteCollection() -> DailyNoteCollection {
        // TODO: if yesterday's pinnedNotes exists -> store in today's pinnedNotes and notes -> ?delete yesterday's?
        guard let pinnedNotes = checkPinnedNotes() else { return DailyNoteCollection(context: context, date: Date()) }
        
        let yesterdayCollection = DailyNoteCollection(context: context, date: Date(), pinnedNotes: pinnedNotes, notes: pinnedNotes)
        fetchDailyNotes(yesterdayCollection.notes)
        
        return yesterdayCollection
    }
    
    private func checkPinnedNotes() -> NSSet? {
        let pred = NSPredicate(format: "date >= %@ && date <= %@", startOfYesterday as CVarArg, startOfToday as CVarArg)
        
        // fetch yesterday's DailyNoteCollection if it exists
        if let fetchedCollection = cdManager.fetch(DailyNoteCollection.self, predicate: pred)?.first {
            // yesterday's DailyNoteCollection exists -> check if there are pinned notes
            guard let pinnedNotes = fetchedCollection.pinnedNotes else { return nil }
            if pinnedNotes.count < 1 { return nil }
            return pinnedNotes
        }
        
        return nil
    }
    
    private func saveAndRefetch() {
        PersistanceContainer.shared.saveContext()
        
        // re-fetch data
        fetchDailyNoteCollection()
    }
}


























// MARK: DataSelectorDelegate
extension DailyNoteViewController: DateSelectorDelegate {
    @objc func calendarButtonTapped() {
        let dateSelectorVC = DateSelectorViewController()
        dateSelectorVC.delegate = self
        dateSelectorVC.collectionDates = collectionDates
        navigationController?.pushViewController(dateSelectorVC, animated: true)
    }
    
    private func fetchAllCollectionDates() {
        do {
            let request = DailyNoteCollection.fetchRequest() as NSFetchRequest<DailyNoteCollection>
            let fetchedCollections = try context.fetch(request)

            collectionDates = fetchedCollections.compactMap { $0.date }
        } catch {
            print(error)
        }
    }
    
    internal func fetchSelectedDailyNoteCollection(_ selectedDate: Date) {
        let start = Calendar.current.startOfDay(for: selectedDate)
        guard let end = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: start) else { return }

        do {
            let request = DailyNoteCollection.fetchRequest() as NSFetchRequest<DailyNoteCollection>

            // fetch today's DailyNoteCollection if it exists
            let pred = NSPredicate(format: "date >= %@ && date <= %@", start as CVarArg, end as CVarArg)
            request.predicate = pred

            if let fetchedCollections = try context.fetch(request).first {
                // DailyNoteCollection exists
                self.dailyNoteCollection = fetchedCollections
                fetchDailyNotes(self.dailyNoteCollection?.notes)
            }

            DispatchQueue.main.async {
                self.rootView.dailyNoteTableView.reloadData()
            }
        } catch {
            print("Failed to fetch: \(error)")
        }
    }
}


// MARK: UITableViewDelegate + UITableViewDataSource
extension DailyNoteViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dailyNotes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyNoteTableViewCell.identifier, for: indexPath) as? DailyNoteTableViewCell else {
            fatalError("The TableView could not dequeue a DailyNoteTableViewCell in ViewController.")
        }
        let currentNote = dailyNotes[indexPath.section]
        
//        cell.contentView.backgroundColor = .systemBrown
        cell.backgroundColor = .clear
//        cell.selectionStyle = .none

        cell.configure(with: currentNote.note!, pinned: currentNote.pinned, checked: currentNote.checked)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
}

