//
//  DateSelectorViewController.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/26/23.
//

import UIKit

class DateSelectorViewController: UIViewController, UICalendarViewDelegate {
    weak var delegate: DateSelectorDelegate?
    let calendarView = UICalendarView()
    var collectionDates: [Date] = []
    var formattedDates: [String] = []
    let dateFormatter = DateFormatter()
    var selectedDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
        setupUI()
        setupValidDates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            checkSelectedDate()
        }
    }

}


// MARK: Setup UI + Layout
extension DateSelectorViewController {
    private func setupUI() {
        styleView()
//        styleHeaderLabel()
        styleCalendarView()
//        styleConfirmButton()
        layoutUI()
    }
    
    private func styleView() {
        view.backgroundColor = UIColor(red: 246/255, green: 214/255, blue: 211/255, alpha: 1.0)
    }
    
    private func styleCalendarView() {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        calendarView.calendar = gregorianCalendar
        calendarView.backgroundColor = .white
        calendarView.layer.cornerCurve = .continuous
        calendarView.layer.cornerRadius = 10.0
        calendarView.tintColor = UIColor.systemTeal
        calendarView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layoutUI() {
        layoutCalendarView()
    }
    
    private func layoutCalendarView() {
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200)
        ])
    }
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        let font = UIFont.systemFont(ofSize: 10)
        let config = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "star.fill", withConfiguration: config)?.withRenderingMode(.alwaysOriginal)
        
        if formattedDates.contains(dateFormatter.string(from: dateComponents.date!)) {
            return .image(image)
        }
        return nil
    }
    
}

// MARK: Class Methods
extension DateSelectorViewController {
    private func setupValidDates() {
        // specifies date range from when calendar starts
        guard let startDate = collectionDates.first else { return }
        calendarView.availableDateRange = DateInterval.init(start: startDate, end: Date())
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        formattedDates = collectionDates.map { dateFormatter.string(from: $0) }
    }
}


// MARK: UICalendarSelectionSingleDateDelegate
extension DateSelectorViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selectedDate = dateComponents?.date
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
}

// MARK: DateSelectorDelegate Methods
extension DateSelectorViewController {
    func checkSelectedDate() {
        guard let date = selectedDate else { return }
//        guard collectionDates.contains(date) else { return }
        delegate?.fetchSelectedDailyNoteCollection(date)
        
    }
}

// MARK: Protocol
protocol DateSelectorDelegate: AnyObject {
    func fetchSelectedDailyNoteCollection(_ selectedDate: Date)
}
