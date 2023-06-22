//
//  ViewController.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/15/23.
//

import UIKit

class DailyNoteViewController: UIViewController, DailyNoteTextFieldViewDelegate, DailyNoteTableViewCellDelegate {
    // MARK: - UI Components
    private let dailyNoteTableView = UITableView()
    private lazy var shadeView = UIView(frame: view.bounds)
    private var dailyNoteTextBar: DailyNoteTextFieldView!
    
    // MARK: - VARIABLES
    private var dailyNotes = [String]()
    private var noteIndex: Int!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerHideKeyboard()
        dailyNoteTableView.dataSource = self
        dailyNoteTableView.delegate = self
        dailyNoteTextBar.delegate = self
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
    // DailyNoteTextFieldViewDelegate method to handle adding note
    internal func addNoteButtonTapped(withNote note: String) {
        dailyNotes.insert(note, at: 0)
        dailyNoteTableView.insertSections(IndexSet(integer: 0), with: .none)
    }
    
    // DailyNoteTextFieldViewDelegate method to handle editing note
    internal func editNoteButtonTapped(withNote note: String) {
        guard dailyNotes[noteIndex] != note else { return }
        // replace existing note with new note
        dailyNotes[noteIndex] = note
        // update section in table
        dailyNoteTableView.reloadSections(IndexSet(integer: noteIndex), with: .none)
    }
    
    internal func editModeCancelled() {
        shadeView.removeFromSuperview()
    }
    
    // DailyNoteTableViewCellDelegate method to handle edit/delete note
    internal func handleOption(option: String, cell: DailyNoteTableViewCell, note: String) {
        let indexPath = self.dailyNoteTableView.indexPath(for: cell)
        guard let section = indexPath?.section else { return }
        noteIndex = section
        
        if option == "Delete" {
            // NOTE: !UIAlert to confirm deletion first!
            dailyNotes.remove(at: noteIndex)
            dailyNoteTableView.deleteSections(IndexSet(integer: noteIndex), with: .none)
        } else if option == "Edit" {
            view.insertSubview(shadeView, belowSubview: dailyNoteTextBar)
            dailyNoteTextBar.editNote(note: note)
        } else if option == "Pin" {
            // handle when adding persistence of data (pin daily)
        }
    }
    
    private func registerHideKeyboard() {
        // Handles hiding keyboard if user taps on superview
        let handleKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(handleKeyboard)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
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
        cell.configure(with: dailyNotes[indexPath.section])
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

