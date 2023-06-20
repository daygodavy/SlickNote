//
//  DailyNoteTextFieldView.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/19/23.
//

import UIKit

class DailyNoteTextFieldView: UIView {
    
    static let identifier = "DailyNoteTextBar"
    
    private var bottomConstraint: NSLayoutConstraint?
    
    private var keyboardHeight: CGFloat = 0
    
    weak var delegate: DailyNoteTextFieldViewDelegate?
    
    private let textBar: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your note"
//        textField.backgroundColor = .white
        textField.backgroundColor = .red
        textField.layer.cornerRadius = 14
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let addNoteButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let sendImage = UIImage(systemName: "plus.diamond.fill", withConfiguration: imageConfig)
        button.setImage(sendImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(addNoteButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        registerForKeyboardNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        layer.cornerRadius = 14
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        addSubview(textBar)
        addSubview(addNoteButton)
        
        
        NSLayoutConstraint.activate([
            textBar.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            textBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            textBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            textBar.trailingAnchor.constraint(equalTo: addNoteButton.leadingAnchor, constant: -2)
        ])
        
        NSLayoutConstraint.activate([
//            addNoteButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
//            addNoteButton.bottomAnchor.constraint(equalTo: topAnchor, constant: -5),
            addNoteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            addNoteButton.widthAnchor.constraint(equalToConstant: 30),
            addNoteButton.centerYAnchor.constraint(equalTo: textBar.centerYAnchor)
        ])
        
        bottomConstraint = bottomAnchor.constraint(equalTo: superview?.safeAreaLayoutGuide.bottomAnchor ?? bottomAnchor)
        bottomConstraint?.isActive = true
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
           
        keyboardHeight = keyboardFrame.height
           
        UIView.animate(withDuration: duration) {
            self.updateBottomConstraint()
            self.superview?.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
       
        keyboardHeight = 0
       
        UIView.animate(withDuration: duration) {
            self.updateBottomConstraint()
            self.superview?.layoutIfNeeded()
        }
    }
    
    private func updateBottomConstraint() {
        let constant: CGFloat = keyboardHeight > 0 ? -keyboardHeight + 34 : 0
        transform = CGAffineTransform(translationX: 0, y: constant)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func addNoteButtonTapped() {
        guard let note = textBar.text else { return } // create alert to say empty note?
        // omit notes with no characters....
        if note.trimmingCharacters(in: .whitespaces).isEmpty { return }
        delegate?.addNoteButtonTapped(withNote: note)
        // clear textfield
        textBar.text = ""
        // hide keyboard
        textBar.resignFirstResponder()
    }
    
}

protocol DailyNoteTextFieldViewDelegate: AnyObject {
    func addNoteButtonTapped(withNote note: String)
}
