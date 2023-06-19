//
//  DailyNoteTableViewCell.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/16/23.
//

import UIKit

class DailyNoteTableViewCell: UITableViewCell {
    
    static let identifier = "DailyNoteCell"
    
    private let myCheckbox: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let circleImage = UIImage(systemName: "circle", withConfiguration: imageConfig)
        let checkImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfig)
        button.setImage(circleImage, for: .normal)
        button.setImage(checkImage, for: .selected)
        button.isSelected = false
        button.tintColor = .systemPink
        
        button.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)

        return button
    }()
    
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
        self.contentView.addSubview(myCheckbox)
        
        dailyCell.translatesAutoresizingMaskIntoConstraints = false
        dailyLabel.translatesAutoresizingMaskIntoConstraints = false
        myCheckbox.translatesAutoresizingMaskIntoConstraints = false
        
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
            myCheckbox.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            myCheckbox.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            myCheckbox.trailingAnchor.constraint(equalTo: dailyLabel.leadingAnchor, constant: -2)
        ])
    }
    
    @objc func checkboxTapped(_ sender: UIButton) {
        if myCheckbox.isSelected == false {
            myCheckbox.isSelected = true
            // add strikethrough to dailyLabel
        } else {
            myCheckbox.isSelected = false
            // remove strikethrough from dailyLabel
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    

}
