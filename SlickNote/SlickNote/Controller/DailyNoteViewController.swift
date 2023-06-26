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
    private let dailyNoteTableView = UITableView()
    private lazy var shadeView = UIView(frame: view.bounds)
    private var dailyNoteTextBar: DailyNoteTextFieldView!
    
    // MARK: - Variables
//    private var dailyNotes = [String]()
    private var noteIndex: Int!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: Core Data Temp Variables
//    private var dailyNoteCollection = [DailyNoteCollection]()
    private var dailyNoteCollection: DailyNoteCollection?
    private var dailyNotes = [DailyNote]()
    private var startOfToday: Date!
    private var startOfYesterday: Date!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerHideKeyboard()
        dailyNoteTableView.dataSource = self
        dailyNoteTableView.delegate = self
        dailyNoteTextBar.delegate = self
        
        // Core Data: fetch notes
        startOfToday = Calendar.current.startOfDay(for: Date())
        startOfYesterday = Calendar.current.date(byAdding: .day, value: -1, to: startOfToday)!
        fetchDailyNoteCollection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: UI Setup + Layout
extension DailyNoteViewController {
    private func setupUI() {
        styleView()
        styleDailyNoteTableView()
        styleShadeView()
        styleDailyNoteTextBar()
        layoutUI()
    }
    
    private func styleView() {
        self.view.backgroundColor = UIColor(red: 246/255, green: 214/255, blue: 211/255, alpha: 1.0)
        title = "Slick Note"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func styleDailyNoteTableView() {
        dailyNoteTableView.backgroundColor = .clear
        dailyNoteTableView.allowsSelection = true
        dailyNoteTableView.separatorStyle = .none
        dailyNoteTableView.translatesAutoresizingMaskIntoConstraints = false
        
        dailyNoteTableView.register(DailyNoteTableViewCell.self, forCellReuseIdentifier: "DailyNoteCell")
    }
    
    private func styleShadeView() {
        shadeView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    }
    
    private func styleDailyNoteTextBar() {
        dailyNoteTextBar = DailyNoteTextFieldView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        dailyNoteTextBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layoutUI() {
        view.addSubview(dailyNoteTableView)
        view.addSubview(dailyNoteTextBar)
        layoutDailyNoteTableView()
        layoutDailyNoteTextBar()
    }
    
    private func layoutDailyNoteTableView() {
        NSLayoutConstraint.activate([
            dailyNoteTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            dailyNoteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dailyNoteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dailyNoteTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
    
    private func layoutDailyNoteTextBar() {
        NSLayoutConstraint.activate([
            dailyNoteTextBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            dailyNoteTextBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            dailyNoteTextBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


// MARK: Methods
extension DailyNoteViewController {
    private func createNewNote(_ note: String) {
        let dailyNote = DailyNote(context: context)
        dailyNote.note = note
        dailyNote.date = Date()
        dailyNote.pinned = false
        dailyNote.checked = false
//        dailyNote.index =
        dailyNoteCollection?.addToNotes(dailyNote)
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
        saveAndRefetch()
    }
    
    internal func editModeCancelled() {
        shadeView.removeFromSuperview()
    }
    
    // DailyNoteTableViewCellDelegate method to handle edit/delete note
    internal func handleOption(option: String, cell: DailyNoteTableViewCell, note: String) {
        guard let indexPath = self.dailyNoteTableView.indexPath(for: cell) else { return }
        let section = indexPath.section
        noteIndex = section
        
        if option == "Delete" {
            // remove note
            let noteToDelete = dailyNotes[noteIndex]
            dailyNoteCollection?.removeFromNotes(noteToDelete)
            self.context.delete(noteToDelete)
            dailyNotes.remove(at: noteIndex)
            
            saveAndRefetch()
        } else if option == "Edit" {
            view.insertSubview(shadeView, belowSubview: dailyNoteTextBar)
            dailyNoteTextBar.editNote(note: note)
        } else if option == "Pin" {
            // TODO: update model
            // handle when adding persistence of data (pin daily)
            // toggle pin -> change appearance to represent pin or not
            cell.togglePin()
        }
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
    func fetchDailyNoteCollection() {
        do {
            let request = DailyNoteCollection.fetchRequest() as NSFetchRequest<DailyNoteCollection>
            
            // fetch today's DailyNoteCollection if it exists
            let pred = NSPredicate(format: "date >= %@", startOfToday as CVarArg)
            request.predicate = pred
            
            if let fetchedCollections = try context.fetch(request).first {
                // DailyNoteCollection exists
                self.dailyNoteCollection = fetchedCollections
                fetchDailyNotes(self.dailyNoteCollection?.notes)
            } else {
                // if today's DailyNoteCollection doesn't exist/empty -> create new DailyNoteCollection
                let newCollection = createDailyNoteCollection()
                self.dailyNoteCollection = newCollection
                
                do { try self.context.save() }
                catch { print(error) }
            }
            
            DispatchQueue.main.async {
                self.dailyNoteTableView.reloadData()
            }
        } catch {
            print("Failed to fetch: \(error)")
        }
    }
    
    func fetchDailyNotes(_ collection: NSSet?) {
        guard let notes = collection as? Set<DailyNote> else { return }
        if !notes.isEmpty {
            let sortedNotes = notes.sorted { $0.date! > $1.date! }
            self.dailyNotes = sortedNotes
        }
    }
    
    func createDailyNoteCollection() -> DailyNoteCollection {
        // TODO: if yesterday's pinnedNotes exists -> store in today's pinnedNotes and notes -> ?delete yesterday's?
        guard let pinnedNotes = checkPinnedNotes() else { return DailyNoteCollection(context: context, date: Date()) }
        
        let yesterdayCollection = DailyNoteCollection(context: context, date: Date())
        yesterdayCollection.pinnedNotes = pinnedNotes
        yesterdayCollection.notes = pinnedNotes
        fetchDailyNotes(yesterdayCollection.notes)
        
        return yesterdayCollection
    }
    
    func checkPinnedNotes() -> NSSet? {
        do {
            // fetch yesterday's DailyNoteCollection if it exists
            let request = DailyNoteCollection.fetchRequest() as NSFetchRequest<DailyNoteCollection>
            let pred = NSPredicate(format: "date >= %@ && date <= %@", startOfYesterday as CVarArg, startOfToday as CVarArg)
            request.predicate = pred

            // yesterday's DailyNoteCollection exists -> check if there are pinned notes
            if let fetchedCollections = try context.fetch(request).first {
                guard let pinnedNotes = fetchedCollections.pinnedNotes else { return nil }
                if pinnedNotes.count < 1 { return nil }
                
                return pinnedNotes
            }
        } catch {
            print("Failed to fetch: \(error)")
        }
        
        return nil
    }
    
    private func saveAndRefetch() {
        // save the data
        do { try self.context.save() }
        catch { print(error) }
        
        // re-fetch data
        fetchDailyNoteCollection()
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
//        cell.contentView.backgroundColor = .systemBrown
        cell.backgroundColor = .clear
//        cell.selectionStyle = .none

        cell.configure(with: dailyNotes[indexPath.section].note!)
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

