//
//  RoundedTextField.swift
//  BookForSnack
//
//  Created by WORK on 29/01/2018.
//  Copyright © 2018 WORK. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
    
    // Indentation
    // - this method returns the drawing rectangle for the text field’s text.
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    // Indentation
    // - this method returns the drawing rectangle for the text field’s placeholder text.
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    // Indentation
    // - this method returns the rectangle in which editable text can be displayed.
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    // Rounded corners
    override func layoutSubviews() {
        super.layoutSubviews() // It is called every time when the text field is laid out.
        
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
}
