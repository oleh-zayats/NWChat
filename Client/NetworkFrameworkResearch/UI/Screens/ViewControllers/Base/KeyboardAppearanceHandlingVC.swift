//
//  KeyboardAppearanceHandlingVC.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

class KeyboardAppearanceHandlingVC: UIViewController {
    
    var reactingConstraint: NSLayoutConstraint? {
        return nil
    }
    
    // MARK: - Overrides
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let willShowSEL = #selector(KeyboardAppearanceHandlingVC.keyboardWillShow)
        let willHideSEL = #selector(KeyboardAppearanceHandlingVC.keyboardWillHide)
        NotificationCenter.default.addObserver(self, selector: willShowSEL, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: willHideSEL, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if let constraint = reactingConstraint, constraint.constant <= keyboardSize.height {
                constraint.constant += keyboardSize.height
            }
            view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if let constraint = reactingConstraint, constraint.constant > keyboardSize.height {
                constraint.constant -= keyboardSize.height
            }
            view.layoutIfNeeded()
        }
    }
}
