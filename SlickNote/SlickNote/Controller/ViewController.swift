//
//  ViewController.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/15/23.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - UI Components
    private let dailyNoteTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .systemGray
        tableView.allowsSelection = true
        
        tableView.separatorStyle = .none
        
        tableView.register(DailyNoteTableViewCell.self, forCellReuseIdentifier: "DailyNoteCell")

        return tableView
    }()
    
    // MARK: - VARIABLES
    let test = ["San Diego San Diego San Diego San Diego San Diego San Diego San Diego San Diego San Diego", "Los Angeles", "Orange County", "San Francisco", "Sacramento", "Sacramento", "Sacramento", "Sacramento", "Sacramento", "Sacramento", "Sacramento"]

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTableView()
        
        dailyNoteTableView.dataSource = self
        dailyNoteTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.view.backgroundColor = UIColor(red: 246/255, green: 214/255, blue: 211/255, alpha: 1.0)
        
        title = "Slick Note"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func setupTableView() {
        view.addSubview(dailyNoteTableView)
        
        dailyNoteTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dailyNoteTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            dailyNoteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dailyNoteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dailyNoteTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])

    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return test.count
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

        cell.configure(with: test[indexPath.section])

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

