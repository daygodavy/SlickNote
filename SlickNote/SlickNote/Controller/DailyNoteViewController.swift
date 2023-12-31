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
    private let dailyNCManager = DailyNoteCollectionManager()
    private var noteIndex: Int!
    
    var rootView: DailyNoteView { view as! DailyNoteView }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = DailyNoteView()
        setupNavBar()
        KeyboardHandler.registerHideKeyboard(for: view)
        
        rootView.dailyNoteTableView.dataSource = self
        rootView.dailyNoteTableView.delegate = self
        rootView.dailyNoteTextBar.delegate = self
        dailyNCManager.delegate = self
        
        dailyNCManager.fetchDailyNoteCollection()
        dailyNCManager.fetchAllCollectionDates()
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

    internal func editNoteButtonTapped(withNote note: String) {
        dailyNCManager.updateNote(newNote: note, noteIndex: noteIndex)
    }
    
    internal func editModeCancelled() {
        rootView.hideShadeView()
    }
    
    func refreshUI() {
        DispatchQueue.main.async {
            self.rootView.dailyNoteTableView.reloadData()
        }
    }
}


// MARK: DataSelectorDelegate
extension DailyNoteViewController: DateSelectorDelegate {
    @objc func calendarButtonTapped() {
        let dateSelectorVC = DateSelectorViewController()
        dateSelectorVC.delegate = self
        dateSelectorVC.collectionDates = dailyNCManager.collectionDates
        navigationController?.pushViewController(dateSelectorVC, animated: true)
    }
    
    internal func fetchSelectedDailyNoteCollection(_ selectedDate: Date) {
        dailyNCManager.fetchSelectedDailyNoteCollection(selectedDate)
    }
}


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
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.configure(with: currentNote.note!, pinned: currentNote.pinned, checked: currentNote.checked)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
}

