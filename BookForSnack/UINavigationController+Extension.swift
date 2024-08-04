//
//  UINavigationController+Extension.swift
//  BookForSnack
//
//  Created by WORK on 19/01/2018.
//  Copyright © 2018 WORK. All rights reserved.
//

import UIKit

extension UINavigationController {
    /*
     We have two posibilities to change the status bar theme, either we use the global way (AppDelegate) or we use separately view controller, when using separatelly we need this extension and then in the view controller we need to add:
     
         override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
         }
     
        And when using the separatelly method we need to change the plist > "View controller-based status bar appearance" > YES
    */
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return topViewController
    }
}

