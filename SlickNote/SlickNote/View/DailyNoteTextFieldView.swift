//
//  DailyNoteTextFieldView.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/19/23.
//

import UIKit

class DailyNoteTextFieldView: UIView {
    static let identifier = "DailyNoteTextBar"
    private let textBar = UITextView()
    private lazy var addNoteButton = UIButton()
    private lazy var cancelEditButton = UIButton()
    private let textViewMaxHeight: CGFloat = 120
    private var textViewBottomConstraint: NSLayoutConstraint?
    private var textBarHeightConstraint: NSLayoutConstraint?
    private var keyboardHeight: CGFloat = 0
    private var editMode: Bool = false
    weak var delegate: DailyNoteTextFieldViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        registerForKeyboardNotifications()
        textBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // deallocate: clean up resources, remove observers
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: Setup UI + Layout
extension DailyNoteTextFieldView {
    private func setupUI() {
        styleView()
        styleTextBar()
        styleAddNoteButton()
        styleCancelEditButton()
        layoutUI()
    }
    
    private func styleView() {
        layer.cornerRadius = 14
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func styleTextBar() {
        textBar.backgroundColor = .white
        let font = UIFont(name: "Helvetica Neue", size: 18)
        textBar.font = font
        // mimicking placeholder
        textBar.textColor = UIColor.lightGray
        textBar.text = "Enter your note"
        textBar.layer.cornerRadius = 14
        textBar.isScrollEnabled = false
        textBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func styleAddNoteButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let sendImage = UIImage(systemName: "plus.diamond.fill", withConfiguration: imageConfig)
        addNoteButton.setImage(sendImage, for: .normal)
        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        
        addNoteButton.addTarget(self, action: #selector(addNoteButtonTapped), for: .touchUpInside)
    }
    
    private func styleCancelEditButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let cancelImage = UIImage(systemName: "xmark.circle.fill", withConfiguration: imageConfig)
        cancelEditButton.setImage(cancelImage, for: .normal)
        cancelEditButton.tintColor = .lightGray
        cancelEditButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelEditButton.addTarget(self, action: #selector(cancelEditButtonTapped), for: .touchUpInside)
    }
    
    private func layoutUI() {
        addSubview(textBar)
        addSubview(addNoteButton)
        addSubview(cancelEditButton)
        
        layoutView()
        layoutTextBar()
        layoutAddNoteButton()
        layoutCancelEditButton()
    }
    
    private func layoutView() {
        textViewBottomConstraint = bottomAnchor.constraint(equalTo: superview?.safeAreaLayoutGuide.bottomAnchor ?? bottomAnchor)
        textViewBottomConstraint?.isActive = true
    }
    
    private func layoutTextBar() {
        NSLayoutConstraint.activate([
            textBar.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            textBar.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -5),
            textBar.leadingAnchor.constraint(equalTo: cancelEditButton.trailingAnchor, constant: 5),
            textBar.trailingAnchor.constraint(equalTo: addNoteButton.leadingAnchor, constant: -2),
        ])
        textBarHeightConstraint = textBar.heightAnchor.constraint(equalToConstant: 32)
        textBarHeightConstraint?.isActive = true
    }
    
    private func layoutAddNoteButton() {
        NSLayoutConstraint.activate([
            addNoteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            addNoteButton.widthAnchor.constraint(equalToConstant: 30),
            addNoteButton.centerYAnchor.constraint(equalTo: textBar.centerYAnchor)
        ])
    }
    
    private func layoutCancelEditButton() {
        NSLayoutConstraint.activate([
            cancelEditButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            cancelEditButton.widthAnchor.constraint(equalToConstant: 30),
            cancelEditButton.centerYAnchor.constraint(equalTo: textBar.centerYAnchor)
        ])
    }
}


// MARK: Methods
extension DailyNoteTextFieldView {
    @objc private func addNoteButtonTapped() {
        // prevent "fake" placeholder from being added as a note
        if textBar.textColor == UIColor.lightGray { return }
        guard let note = textBar.text else { return }
        
        // prevent sending empty notes
        if note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return }
        
        if editMode {
            editModeCancelled()
            delegate?.editNoteButtonTapped(withNote: note)
        } else {
            resetTextBar()
            delegate?.addNoteButtonTapped(withNote: note)
        }
    }
    
    @objc private func cancelEditButtonTapped() {
        editModeCancelled()
    }
    
    private func editModeCancelled() {
        editMode = false
        resetTextBar()
        delegate?.editModeCancelled()
    }
    
    private func resetTextBar() {
        textBar.textColor = UIColor.lightGray
        textBar.text = "Enter your note"
        textBarHeightConstraint?.constant = 32
        layoutIfNeeded()
        
        if keyboardHeight > 0 {
            textBar.resignFirstResponder()
        }
    }
    
    private func updateTextBarSize(_ textView: UITextView) {
        // calculate desired height of textView based on its content
        let contentSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: textViewMaxHeight))
        let newHeight = min(contentSize.height, textViewMaxHeight)

        // update height constraint
        if textView.bounds.height != newHeight {
            textBarHeightConstraint?.constant = newHeight
            layoutIfNeeded()
        }
        
        // enable scrolling when textViewMaxHeight exceeded
        textView.isScrollEnabled = contentSize.height > textViewMaxHeight
    }
    
    public func editNote(note: String) {
        editMode = true
        
        textBar.textColor = UIColor.black
        textBar.text = note
        updateTextBarSize(textBar)
        // Note: handle wait time for text to appear for showing keyboard
        textBar.becomeFirstResponder()
    }
}


// MARK: Keyboard Methods
extension DailyNoteTextFieldView {
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        keyboardHeight = keyboardFrame.height
        self.updateBottomConstraint(notification: notification)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardHeight = 0
        self.updateBottomConstraint(notification: notification)
        
        // handles event where user taps outside of textView to cancel edit
        if editMode {
            editModeCancelled()
        }
    }
    
    private func updateBottomConstraint(notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25

        UIView.animate(withDuration: duration) { [self] in
            let constant: CGFloat = self.keyboardHeight > 0 ? -self.keyboardHeight + 34 : 0
            transform = CGAffineTransform(translationX: 0, y: constant)
            self.superview?.layoutIfNeeded()
        }
    }
}


// MARK: UITextViewDelegate
extension DailyNoteTextFieldView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateTextBarSize(textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  {
            resetTextBar()
        }
    }
}

// MARK: Protocols
protocol DailyNoteTextFieldViewDelegate: AnyObject {
    func addNoteButtonTapped(withNote note: String)
    func editNoteButtonTapped(withNote note: String)
    func editModeCancelled()
}
