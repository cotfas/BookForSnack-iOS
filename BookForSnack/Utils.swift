//
//  Utils.swift
//  BookForSnack
//
//  Created by WORK on 5/16/17.
//  Copyright © 2017 WORK. All rights reserved.
//

import Foundation
import UIKit


class Utils {
   
    // Change tab bar colors
    static func styleBottomTabBar() {
        //tintColor - this property allows you to change the tint color of the tab bar item.
        UITabBar.appearance().tintColor = UIColor(red: 235.0/255.0, green: 75.0/255.0,
                                                  blue: 27.0/255.0, alpha: 1.0)
        //barTintColor - this property lets you change the tint color of the tab bar background. The code below changes the background color to black:
        UITabBar.appearance().barTintColor = UIColor.black
        
        //backgroundImage - this property lets you define a background image of the tab bar.
        UITabBar.appearance().backgroundImage = UIImage(named: "tabbar-background")
        
        // Change selection indicator image
        UITabBar.appearance().selectionIndicatorImage = UIImage(named: "tabitem-selected") // TODO fix selector for landscape selection
    }
    
    /*
     Customize navigation bar
     */
    static func customizeNavTitle() {
        // Change navigation drawer color
        UINavigationBar.appearance().barTintColor = UIColor.red
        
        // Change font
        if let font = UIFont(name: "Avenir-Light", size: 24) {
            UINavigationBar.appearance().titleTextAttributes =
                [NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font:font]
        }
        
        // Change navigation items color
        UINavigationBar.appearance().tintColor = UIColor.white
        
        /*
         Change status bar color
         In order to use globally need plist update "View controller-based status bar appearance" > NO
         */
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    static func setTableViewForTablet(_ tableView : UITableView!) {
        // Setting the UI tableView for Tablet as centered
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
    
    static func largeTitle(_ navigationController : UINavigationController?) {

        if #available(iOS 11.0, *) {
            // For iOS11 Setting up the large title
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    static func largeTitleInheritedDisabled(_ navigationItem : UINavigationItem!) {
        if #available(iOS 11.0, *) {
            // Disabling inherited large title from the parent main viewControler
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
    }
    
    static func restoreNavBarBackgroundColor(_ navigationController : UINavigationController?) {
        // Restoring the color of the navigation bar back to normal
        // Must be used with viewWillAppear on the parent screen or viewWillDisappear on the current screen
        // Usefull when using the configureNavBarAppearance in detail and the user come back to master and it appears a blank navBar
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .red
    }
    
    static func configureNavBarAppearance(_ navigationController : UINavigationController?) {
        // Configure navigation bar appearance
        
        // Transparent navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
       
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            if #available(iOS 11.0, *) {
                // Customize large title text (iOS11)
                // Will work with largeTitle only
                navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor(red: 235, green: 75, blue: 27), NSAttributedStringKey.font: customFont ]
            } else {
                // Fallback on earlier versions
            }
        }
        
        // Hide bars on swipe
        //navigationController?.hidesBarsOnSwipe = true
    }
    
    static func configureNavBarAppearance(_ navigationController : UINavigationController?, _ tableView : UITableView) {
        // Configure the navigation bar appearance
        
        // Transparent navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white // Change navigation buttons and title colors
        
        if #available(iOS 11.0, *) {
            // Tell the tableView to not adjust his size based on the navigation bar (this will remove the top offset)
            // If this method does not work - do not forget in the storyboard to use the safe area!
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        // Other method for transparent navigation bar
        //navigationController?.navigationBar.isTranslucent = true
        //navigationController?.view.backgroundColor = .clear
        
        // Alpha
        //navigationController?.navigationBar.alpha = 0.0
        
        // Hidding navigation bar
        //navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Hide bars on swipe
        //navigationController?.hidesBarsOnSwipe = false
    }
    
    static func hideBarsOnSwipe(_ navigationController : UINavigationController?, _ enabled : Bool) {
        // Enable/disable hideBarsOnSwipe per view controler
        // Needs to be called on viewWillAppear because this must be executed every time when the view is shown (otherwise will cause issues)
        // Can be modified from storyboard as well "Navigation Controller Scene"
        
        if (enabled) {
            navigationController?.hidesBarsOnSwipe = true
        } else {
            navigationController?.hidesBarsOnSwipe = false
            navigationController?.setNavigationBarHidden(false, animated: true) // Hidding navigation bar
        }
    }
    
    static func enableTableViewAutoRow(_ tableView : UITableView!) {
        // Enable tableView auto row height size
        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    static func changeNavBackButtonAll() {
        // Changing the back button icon for all screens of the app
        // Need to be called from AppDelegate launchingWithOptions
        let backButtonImage = UIImage(named: "back")
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
    }
    
    static func changeNavBackButton(_ navigationController : UINavigationController?) {
        
        // Change navigation back button text
        let btn = UIBarButtonItem(title: NSLocalizedString("Back", comment: "Back"), style: .plain, target: self, action: nil)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem  = btn
    }
    
    static func changeNavTitle(_ navigationController : UINavigationController?, _ title : String?) {
        // Changing navigation bar title
        navigationController?.title = title
        navigationController?.navigationItem.title = title
        
        /*if (title == "") {
            hideNavBarTitle(navigationController)
        }*/
    }
    
    static func hideNavBarTitle(_ navigationController : UINavigationController?) {
        // Hiding the title
        navigationController?.navigationItem.titleView = UIView()
    }
    
    static func hideNavBarBackButtonTitle(_ navigationController : UINavigationController?) {
        // Hiding the navigation bar back button text
        
        // Solution that really works by hiding the back button text (can be called on viewWillAppear)
        let btn = UIBarButtonItem(title: " ", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem  = btn
        
        // WORKS but changes the parent screen title as well when you go back to the master navigation screen...
        //navigationController?.navigationBar.topItem?.title = "New back"
        
        // Other method - does not work
        //navigationController?.navigationBar.backItem?.title = " "
        
        // Other method - does not work
        //navigationController?.navigationItem.backBarButtonItem?.title = " "
        
        // Other method - does not work
        //let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        //navigationController?.navigationItem.backBarButtonItem = item
        
        // Other method - does not work
        //navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        /*
            Other solution that works is to use this code in the master VC for hiding the detail back button text
            override func viewWillDisappear(_ animated: Bool) {
                 super.viewWillDisappear(true)
                 // needed to clear the text in the back navigation:
                 self.navigationItem.title = " "
             }
         
             override func viewWillAppear(_ animated: Bool) {
                 super.viewWillAppear(animated)
                 self.navigationItem.title = "My Title"
             }
        */
    }
    
    static func navigationBarShow(_ navigationController : UINavigationController?, _ show : Bool) {
        
        // Showing and hiding the navigation bar
        
        if (show) {
             navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
             navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    static func tableViewCustomize(_ tableView : UITableView!) {
        // Set table view background color
        tableView.backgroundColor = UIColor.lightText
        
        // Remove separators from non items
        //tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Change separators color
        tableView.separatorColor = UIColor.lightGray
    }
    
    static func tableViewRemoveUnusedSeparators(_ tableView : UITableView!) {
        // Remove unused separators
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    static func tableViewRemoveAllSeparators(_ tableView : UITableView!) {
        // Remove tableView separator
        tableView.separatorStyle = .none
    }
    
    static func tableViewRemoveBottomDivider(_ tableView : UITableView!) {
        // Removing tableView divider
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView?.isHidden = true
    }
    
    static func tableViewDisableClickSelector(_ tableView : UITableView!, _ cell : UITableViewCell!) {
        /*
            Disabling click selector
         */
        // Must be called on tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        
        // Default style
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        // Gray style
        //cell.selectionStyle = UITableViewCellSelectionStyle.gray
        
        tableView.separatorStyle = .none
        
        // To disable the didSelectRowAt use this
        //cell.userInteractionEnabled = false
    }
    
    static func tableViewEmptyView(_ tableView : UITableView!, _ emptyView: UIImageView!, _ shown: Bool!) {
      
        if (shown) {
            tableView.backgroundView = emptyView
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = emptyView
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        }
    }
}
