//
//  DailyNoteTableViewCell.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/16/23.
//

import UIKit

class DailyNoteTableViewCell: UITableViewCell {
    static let identifier = "DailyNoteCell"
    private let dailyCell = UIView()
    private let dailyLabel = UILabel()
    private let dailyCheckbox = UIButton()
    private let dailyOptions = UIButton()
    weak var delegate: DailyNoteTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


// MARK: Setup UI + Layout
extension DailyNoteTableViewCell {
    private func setupUI() {
        styleDailyCell()
        styleDailyLabel()
        styleDailyCheckbox()
        styleDailyOptions()
        layoutUI()
    }
    
    private func styleDailyCell() {
        dailyCell.backgroundColor = .white
        dailyCell.layer.borderWidth = 2.0
        dailyCell.layer.borderColor = UIColor.white.cgColor
        dailyCell.layer.cornerRadius = 10
        dailyCell.layer.masksToBounds = true
        dailyCell.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func styleDailyLabel() {
        dailyLabel.textColor = .label
        dailyLabel.textAlignment = .left
        dailyLabel.font = .systemFont(ofSize: 16, weight: .medium)
        dailyLabel.text = "Error"
        dailyLabel.numberOfLines = 0
        dailyLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func styleDailyCheckbox() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let uncheckedImage = UIImage(systemName: "circle", withConfiguration: imageConfig)
        let checkedImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfig)
        dailyCheckbox.setImage(uncheckedImage, for: .normal)
        dailyCheckbox.setImage(checkedImage, for: .selected)
        dailyCheckbox.isSelected = false
        dailyCheckbox.tintColor = .systemPink
        dailyCheckbox.translatesAutoresizingMaskIntoConstraints = false
        
        dailyCheckbox.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
    }
    
    private func styleDailyOptions() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14)
        let optionsImage = UIImage(systemName: "ellipsis", withConfiguration: imageConfig)
        dailyOptions.setImage(optionsImage, for: .normal)
        dailyOptions.tintColor = .lightGray
        dailyOptions.translatesAutoresizingMaskIntoConstraints = false
        
        dailyOptions.addTarget(self, action: #selector(optionsTapped), for: .touchUpInside)
    }
    
    private func layoutUI() {
        self.contentView.addSubview(dailyCell)
        self.contentView.addSubview(dailyLabel)
        self.contentView.addSubview(dailyCheckbox)
        self.contentView.addSubview(dailyOptions)
        
        layoutDailyCell()
        layoutDailyLabel()
        layoutDailyCheckbox()
        layoutDailyOptions()
    }
    
    private func layoutDailyCell() {
        NSLayoutConstraint.activate([
            dailyCell.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            dailyCell.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            dailyCell.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            dailyCell.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)
        ])
    }
    
    private func layoutDailyLabel() {
        NSLayoutConstraint.activate([
            dailyLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            dailyLabel.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            dailyLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor, constant: 25),
            dailyLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor, constant: -12)
        ])
    }
    
    private func layoutDailyCheckbox() {
        NSLayoutConstraint.activate([
            dailyCheckbox.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            dailyCheckbox.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            dailyCheckbox.trailingAnchor.constraint(equalTo: dailyLabel.leadingAnchor, constant: -2)
        ])
    }
    
    private func layoutDailyOptions() {
        NSLayoutConstraint.activate([
            dailyOptions.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            dailyOptions.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
}


// MARK: Methods
extension DailyNoteTableViewCell {
//    public func configure(with label: String) {
//        self.dailyLabel.text = label
//
//        // FIXME: temp bug fix for when deleting pinned cell; new cell pinned -> REFACTOR USING CORE DATA ATTRIBUTE PINNED
//        dailyCell.layer.borderColor = UIColor.white.cgColor
//    }
    
    public func configure(with label: String, pinned: Bool) {
        self.dailyLabel.text = label
        
        if pinned {
            dailyCell.layer.borderColor = UIColor.systemYellow.cgColor
        } else {
            dailyCell.layer.borderColor = UIColor.white.cgColor
        }
    }
    
//    public func togglePin() {
//        if dailyCell.layer.borderColor == UIColor.white.cgColor {
//            dailyCell.layer.borderColor = UIColor.systemYellow.cgColor
//        } else {
//            dailyCell.layer.borderColor = UIColor.white.cgColor
//        }
//    }
    
    @objc private func checkboxTapped(_ sender: UIButton) {
        if dailyCheckbox.isSelected == false {
            dailyCheckbox.isSelected = true
            // TODO: add strikethrough to dailyLabel
        } else {
            dailyCheckbox.isSelected = false
            // TODO: remove strikethrough from dailyLabel
        }
    }
    
    @objc private func optionsTapped(_ sender: UIButton) {
        let optionsMenuInteraction = UIEditMenuInteraction(delegate: self)
        self.contentView.addInteraction(optionsMenuInteraction)
        
        let location = CGPoint(x: sender.frame.midX, y: sender.frame.midY)
        let config = UIEditMenuConfiguration(identifier: nil, sourcePoint: location)
        
        optionsMenuInteraction.presentEditMenu(with: config)
    }
    
    private func handleOption(option: String) {
        guard let note = dailyLabel.text else { return }
        delegate?.handleOption(option: option, cell: self, note: note)
    }
}


// MARK: UIEditMenuInteractionDelegate
extension DailyNoteTableViewCell: UIEditMenuInteractionDelegate {
    internal func editMenuInteraction(_ interaction: UIEditMenuInteraction, menuFor configuration: UIEditMenuConfiguration, suggestedActions: [UIMenuElement]) -> UIMenu? {
        let edit = UIAction(title: "Edit", handler: { (action) in
            self.handleOption(option: action.title)
        })
        
        let delete = UIAction(title: "Delete", handler: { (action) in
            self.handleOption(option: action.title)
        })
        
        let pin = UIAction(title: "Pin", handler: { (action) in
            self.handleOption(option: action.title)
        })
        
        let menu = UIMenu(title: "", children: [edit, pin, delete])
        return menu
    }
}


// MARK: Protocols
protocol DailyNoteTableViewCellDelegate: AnyObject {
    func handleOption(option: String, cell: DailyNoteTableViewCell, note: String)
}
