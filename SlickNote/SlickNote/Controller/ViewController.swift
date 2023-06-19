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
//        tableView.backgroundColor = .clear
        tableView.backgroundColor = .systemGray
        tableView.allowsSelection = true
        
        tableView.separatorStyle = .none
//        tableView.tableFooterView = UIView()
        
        tableView.register(DailyNoteTableViewCell.self, forCellReuseIdentifier: "DailyNoteCell")
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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

//extension ViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return test.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // Return the number of rows in the section
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//
//        cell.selectionStyle = .none
//        cell.backgroundColor = .white
//
//        cell.textLabel?.text = test[indexPath.section]
////        cell.textLabel?.layer.borderWidth = 2.0
////        cell.textLabel?.layer.borderColor = UIColor.green.cgColor
////        cell.textLabel?.layer.cornerRadius = 10
//        cell.textLabel?.numberOfLines = 0
//
//        cell.layer.borderWidth = 4.0
//        cell.layer.borderColor = UIColor.white.cgColor
//        cell.layer.cornerRadius = 10
//
//
//        return cell
//    }
//
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footer = UIView()
////        let footer = UILabel()
////        footer.text = "\(section)"
//        return footer
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10.0
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // Handle row selection
//    }
//}

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
//        let footer = UILabel()
//        footer.text = "\(section)"
        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

