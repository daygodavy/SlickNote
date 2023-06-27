//
//  DailyNoteView.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/27/23.
//

import UIKit

extension DailyNoteViewController {
    func setupUI() {
        styleView()
        styleDailyNoteTableView()
        styleShadeView()
        styleDailyNoteTextBar()
        layoutUI()
    }
    
    private func styleView() {
        self.view.backgroundColor = UIColor(red: 246/255, green: 214/255, blue: 211/255, alpha: 1.0)
        title = "Slick Note"
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.backgroundColor = .clear
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(calendarButtonTapped))
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
