//
//  AlertUtils.swift
//  BookForSnack
//
//  Created by WORK on 29/01/2018.
//  Copyright © 2018 WORK. All rights reserved.
//

import UIKit

/*
 Example of usage:
 
 //class A: AlertListener {
 //    func onOk() {
 //
 //    }
 //    func onCancel() {
 //
 //    }
 //    func onShow() {
 //
 //    }
 //}
 //AlertUtils.alert(self, title: "", message: "Message", okButton: nil, cancelButton: "", asDialog: false, A(), [
 //    AlertUtils.ButtonAlert("", buttonListener: { () in
 //        print("aa")
 //    }),
 //    AlertUtils.ButtonAlert("", buttonListener: { () in
 //        print("bb")
 //    }),
 //    AlertUtils.ButtonAlert("", buttonListener: nil)
 //    ])
 
 */

public protocol AlertListener: class {
    func onOk() -> Void
    func onCancel() -> Void
    func onShow() -> Void
    //func onDismiss() -> Void
}

/* default implementation */
extension AlertListener {
    func onOk() {
        print("onOk")
    }
    func onCancel() {
        print("onCancel")
    }
    func onShow() {
        print("onShow")
    }
}

public class AlertUtils {
    
    public static func alert(_ controller: UIViewController!,
                      title: String? = "",
                      message: String!,
                      okButton: String? = "OK",
                      cancelButton: String? = "Cancel",
                      asDialog: Bool? = true,
                      _ listener: AlertListener? = nil,
                      _ buttons: [ButtonAlert]? = nil) {
        
        var preferredStyle: UIAlertControllerStyle! = .actionSheet
        if (asDialog!) {
            preferredStyle = .alert
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        var hasAnyButtons: Bool = false
        
        if (buttons != nil) {
            for button in buttons! {
                let text = button.getButtonText()
                if (text != "") {
                    let closure = button.getButtonListener()
                    
                    let callBack = { (action:UIAlertAction!) -> Void in
                        if (closure != nil) {
                            closure!()
                        }
                    }
                    
                    let okAction = UIAlertAction(title: text, style: .default, handler: callBack)
                    alertController.addAction(okAction)
                    
                    hasAnyButtons = true
                }
            }
        }
        
        if (okButton != nil && okButton != "") {
            let callBack = { (action:UIAlertAction!) -> Void in
                if (listener != nil) {
                    listener!.onOk()
                }
            }
            let okAction = UIAlertAction(title: okButton, style: .default, handler: callBack)
            alertController.addAction(okAction)
            
            hasAnyButtons = true
        }
        
        if (cancelButton != nil && cancelButton != "") {
            let callBack = { (action:UIAlertAction!) -> Void in
                if (listener != nil) {
                    listener!.onCancel()
                }
            }
            let cancelAction = UIAlertAction(title: cancelButton, style: .cancel, handler: callBack)
            alertController.addAction(cancelAction)
            
            hasAnyButtons = true
        }
        
        if (!hasAnyButtons) {
            self.alert(controller, title: title, message: message, okButton: "OK", cancelButton: cancelButton, asDialog: asDialog, listener, buttons)
            return
        }
        
        let callBack = { () -> Void in
            if (listener != nil) {
                listener!.onShow()
            }
        }
        controller.present(alertController, animated: true, completion: callBack)
    }
    
    public class ButtonAlert {
        private let buttonText: String!
        private let buttonListener: (() -> Void)?
        
        public init(_ buttonText: String!, buttonListener: (() -> Void)?) {
            self.buttonText = buttonText
            self.buttonListener = buttonListener
        }
        
        public func getButtonText() -> String! {
            return buttonText
        }
        
        public func getButtonListener() -> (() -> Void)? {
            return buttonListener
        }
    }
}
