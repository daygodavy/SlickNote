//
//  Keyboard.swift
//  SlickNote
//
//  Created by Davy Chuon on 6/29/23.
//

import Foundation
import UIKit

class KeyboardHandler {
    
    // Handles hiding keyboard if user taps on superview
    static func registerHideKeyboard(for view: UIView) {
        let handleKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(handleKeyboard)
    }
    
    @objc private static func hideKeyboard(_ gestureRecognizer: UITapGestureRecognizer) {
        gestureRecognizer.view?.endEditing(true)
    }
}
