//
//  ViewController.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/15/23.
//

import CoreData
import UIKit

class DailyNoteViewController: UIViewController, DailyNoteTextFieldViewDelegate, DailyNoteTableViewCellDelegate, DailyNCManagerDelegate {

    // MARK: - Variables
    private var noteIndex: Int!
    private let context = PersistanceContainer.shared.container.viewContext

    // MARK: Core Data Temp Variables
    private var collectionDates: [Date] = []
    
    // MARK: DAILYNOTEVIEW SEPARATION
    var rootView: DailyNoteView {
        view as! DailyNoteView
    }
    
    // MARK: DAILYNOTECOLLECTION MANAGER
    let dailyNCManager = DailyNoteCollectionManager()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = DailyNoteView()
        setupNavBar()
        registerHideKeyboard()
        rootView.dailyNoteTableView.dataSource = self
        rootView.dailyNoteTableView.delegate = self
        rootView.dailyNoteTextBar.delegate = self
        dailyNCManager.delegate = self
        
        
        // Core Data: fetch notes
        dailyNCManager.fetchDailyNoteCollection()
        
        // FIXME: UNCOMMENT FOR DATESELECTOR
//        fetchAllCollectionDates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func refreshUI() {
        DispatchQueue.main.async {
            self.rootView.dailyNoteTableView.reloadData()
        }
    }
}


// MARK: Navigation Bar Setup
extension DailyNoteViewController {
    private func setupNavBar() {
                title = "Slick Note"
                navigationController?.navigationBar.prefersLargeTitles = true
                navigationItem.largeTitleDisplayMode = .never
                navigationController?.navigationBar.backgroundColor = .clear
        
        // FIXME: UNCOMMENT FOR DATESELECTOR
//                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(calendarButtonTapped))
    }
}



// MARK: Methods
extension DailyNoteViewController {
    // DailyNoteTableViewCellDelegate method to handle edit/delete note
    internal func handleOption(option: String, cell: DailyNoteTableViewCell, note: String) {
        
        guard let indexPath = rootView.dailyNoteTableView.indexPath(for: cell) else { return }
        noteIndex = indexPath.section
        guard let currentNote = dailyNCManager.dailyNotes?[noteIndex] else { return }
        
        switch option {
        case "Edit":
            rootView.showShadeView()
            rootView.dailyNoteTextBar.editNote(note: note)
        case "Delete":
            dailyNCManager.handleDelete(noteToDelete: currentNote, noteIndex: noteIndex)
        case "Pin":
            dailyNCManager.handlePin(noteToPin: currentNote)
        case "Checked":
            dailyNCManager.handleCheckBox(noteToCheckBox: currentNote)
        default:
            break
        }
    }
    
    internal func addNoteButtonTapped(withNote note: String) {
        dailyNCManager.createNewNote(note)
    }

    // DailyNoteTextFieldViewDelegate method to handle editing note
    internal func editNoteButtonTapped(withNote note: String) {
        dailyNCManager.updateNote(newNote: note, noteIndex: noteIndex)
    }
    
    internal func editModeCancelled() {
        rootView.hideShadeView()
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











// MARK: DataSelectorDelegate
//extension DailyNoteViewController: DateSelectorDelegate {
//    @objc func calendarButtonTapped() {
//        let dateSelectorVC = DateSelectorViewController()
//        dateSelectorVC.delegate = self
//        dateSelectorVC.collectionDates = collectionDates
//        navigationController?.pushViewController(dateSelectorVC, animated: true)
//    }
//
//    private func fetchAllCollectionDates() {
//        do {
//            let request = DailyNoteCollection.fetchRequest() as NSFetchRequest<DailyNoteCollection>
//            let fetchedCollections = try context.fetch(request)
//
//            collectionDates = fetchedCollections.compactMap { $0.date }
//        } catch {
//            print(error)
//        }
//    }
//
//    internal func fetchSelectedDailyNoteCollection(_ selectedDate: Date) {
//        let start = Calendar.current.startOfDay(for: selectedDate)
//        guard let end = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: start) else { return }
//
//        do {
//            let request = DailyNoteCollection.fetchRequest() as NSFetchRequest<DailyNoteCollection>
//
//            // fetch today's DailyNoteCollection if it exists
//            let pred = NSPredicate(format: "date >= %@ && date <= %@", start as CVarArg, end as CVarArg)
//            request.predicate = pred
//
//            if let fetchedCollections = try context.fetch(request).first {
//                // DailyNoteCollection exists
//                self.dailyNoteCollection = fetchedCollections
//                fetchDailyNotes(self.dailyNoteCollection?.notes)
//            }
//
//            DispatchQueue.main.async {
//                self.rootView.dailyNoteTableView.reloadData()
//            }
//        } catch {
//            print("Failed to fetch: \(error)")
//        }
//    }
//}


// MARK: UITableViewDelegate + UITableViewDataSource
extension DailyNoteViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dailyNCManager.dailyNotes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyNoteTableViewCell.identifier, for: indexPath) as? DailyNoteTableViewCell else {
            fatalError("The TableView could not dequeue a DailyNoteTableViewCell in ViewController.")
        }
        
        guard let currentNote = dailyNCManager.dailyNotes?[indexPath.section] else { return UITableViewCell() }

        
        
        
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

