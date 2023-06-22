//
//  DailyNoteTableViewCell.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/16/23.
//

import UIKit

class DailyNoteTableViewCell: UITableViewCell, UIEditMenuInteractionDelegate {
    
    static let identifier = "DailyNoteCell"
    
    weak var delegate: DailyNoteTableViewCellDelegate?
    
    private let dailyCell: UIView = {
        let cell = UIView()
        cell.backgroundColor = .white
        cell.layer.borderWidth = 4.0
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        return cell
    }()
    
    private let dailyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = "Error"
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var dailyCheckbox: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let uncheckedImage = UIImage(systemName: "circle", withConfiguration: imageConfig)
        let checkedImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfig)
        button.setImage(uncheckedImage, for: .normal)
        button.setImage(checkedImage, for: .selected)
        button.isSelected = false
        button.tintColor = .systemPink
        
        button.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)

        return button
    }()
    
    private lazy var dailyOptions: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14)
        let optionsImage = UIImage(systemName: "ellipsis", withConfiguration: imageConfig)
        button.setImage(optionsImage, for: .normal)
        button.tintColor = .lightGray
        
        button.addTarget(self, action: #selector(optionsTapped), for: .touchUpInside)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with label: String) {
        self.dailyLabel.text = label
    }
    
    private func setupUI() {
        self.contentView.addSubview(dailyCell)
        self.contentView.addSubview(dailyLabel)
        self.contentView.addSubview(dailyCheckbox)
        self.contentView.addSubview(dailyOptions)
        
        dailyCell.translatesAutoresizingMaskIntoConstraints = false
        dailyLabel.translatesAutoresizingMaskIntoConstraints = false
        dailyCheckbox.translatesAutoresizingMaskIntoConstraints = false
        dailyOptions.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dailyCell.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            dailyCell.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            dailyCell.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            dailyCell.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            dailyLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            dailyLabel.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            dailyLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor, constant: 25),
            dailyLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            dailyCheckbox.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            dailyCheckbox.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            dailyCheckbox.trailingAnchor.constraint(equalTo: dailyLabel.leadingAnchor, constant: -2)
        ])
        
        NSLayoutConstraint.activate([
            dailyOptions.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            dailyOptions.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    @objc private func checkboxTapped(_ sender: UIButton) {
        if dailyCheckbox.isSelected == false {
            dailyCheckbox.isSelected = true
            // add strikethrough to dailyLabel
        } else {
            dailyCheckbox.isSelected = false
            // remove strikethrough from dailyLabel
        }
    }
    
    @objc private func optionsTapped(_ sender: UIButton) {
        
        let optionsMenuInteraction = UIEditMenuInteraction(delegate: self)
        self.contentView.addInteraction(optionsMenuInteraction)
        
        let location = CGPoint(x: sender.frame.midX, y: sender.frame.midY)
        let config = UIEditMenuConfiguration(identifier: nil, sourcePoint: location)
        
        optionsMenuInteraction.presentEditMenu(with: config)
    }
    
    func editMenuInteraction(_ interaction: UIEditMenuInteraction, menuFor configuration: UIEditMenuConfiguration, suggestedActions: [UIMenuElement]) -> UIMenu? {
        let edit = UIAction(title: "Edit", handler: { (action) in
            // signal edit
            self.handleOption(option: action.title)
        })
        
        let delete = UIAction(title: "Delete", handler: { (action) in
            // signal delete
            self.handleOption(option: action.title)
        })
        
        let pin = UIAction(title: "Pin", handler: { (action) in
            // signal pin
            self.handleOption(option: action.title)
        })
        
        let menu = UIMenu(title: "", children: [edit, pin, delete])
        return menu
    }
    
    private func handleOption(option: String) {
        guard let note = dailyLabel.text else { return }
        delegate?.handleOption(option: option, cell: self, note: note)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

protocol DailyNoteTableViewCellDelegate: AnyObject {
    func handleOption(option: String, cell: DailyNoteTableViewCell, note: String)
}
