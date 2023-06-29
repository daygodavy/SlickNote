//
//  DailyNoteView.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/27/23.
//

import UIKit

class DailyNoteView: UIView {
    // MARK: - UI Components
    let dailyNoteTableView = UITableView()
    lazy var shadeView = UIView(frame: self.bounds)
    var dailyNoteTextBar: DailyNoteTextFieldView!
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func showShadeView() {
        self.insertSubview(shadeView, belowSubview: dailyNoteTextBar)
        layoutShadeView()
    }
    
    func hideShadeView() {
        shadeView.removeFromSuperview()
    }
}

// MARK: UI Styling + Layout
extension DailyNoteView {
    func setupUI() {
        styleView()
        styleDailyNoteTableView()
        styleShadeView()
        styleDailyNoteTextBar()
        layoutUI()
    }
    
    private func styleView() {
        self.backgroundColor = UIColor(red: 246/255, green: 214/255, blue: 211/255, alpha: 1.0)
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
        shadeView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func styleDailyNoteTextBar() {
        dailyNoteTextBar = DailyNoteTextFieldView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 50))
        dailyNoteTextBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layoutUI() {
        self.addSubview(dailyNoteTableView)
        self.addSubview(dailyNoteTextBar)
        layoutDailyNoteTableView()
        layoutDailyNoteTextBar()
    }
    
    private func layoutDailyNoteTableView() {
        NSLayoutConstraint.activate([
            dailyNoteTableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            dailyNoteTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            dailyNoteTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            dailyNoteTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100)
        ])
    }
    
    private func layoutDailyNoteTextBar() {
        NSLayoutConstraint.activate([
            dailyNoteTextBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            dailyNoteTextBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            dailyNoteTextBar.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func layoutShadeView() {
        NSLayoutConstraint.activate([
            shadeView.topAnchor.constraint(equalTo: self.topAnchor),
            shadeView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            shadeView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            shadeView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

}
