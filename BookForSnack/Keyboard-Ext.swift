//
//  Keyboard-Ext.swift
//  BookForSnack
//
//  Created by WORK on 30/01/2018.
//  Copyright © 2018 WORK. All rights reserved.
//

import UIKit

// Put this piece of code anywhere you like
extension UIViewController {
    /*
        Use it with
        override func viewDidLoad() {
         super.viewDidLoad()
         self.hideKeyboardWhenTappedAround()
        }
    */
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
