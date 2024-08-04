//
//  AppDelegate.swift
//  BookForSnack
//
//  Created by WORK on 5/7/17.
//  Copyright © 2017 WORK. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // Customize nav bar
        Utils.customizeNavTitle()
        
        // Change tab bar colors
        Utils.styleBottomTabBar();
        
        // Changing the back button icon for all screens of the app
        Utils.changeNavBackButtonAll()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
   
    // Shared preference
    static func isGettingStarted() -> Bool {
        //return false // TODO returning false will show every time the getting started you open the app
        return UserDefaults.standard.bool(forKey: "gettingStarted")
    }
    
    static func saveGettingStarted(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "gettingStarted")
    }
    // Shared preference
    
    
    
    // Getting the AppDelegate instance
    static func getDelegate() -> AppDelegate? {
        return (UIApplication.shared.delegate as? AppDelegate)
    }
    
    // Getting the Database context
    static func getDatabaseContext() -> NSManagedObjectContext? {
        
        if #available(iOS 10.0, *) {
            
//            if let appDelegate = getDelegate() {
//                return appDelegate.persistentContainer.viewContext
//            }
            
            return DatabaseController10.persistentContainer.viewContext
        } else {
            return DatabaseController.getDatabaseContext()
        }
    }
    // Saving Database context
    static func saveDatabaseContext() {
        
        if #available(iOS 10.0, *) {
            
//            if let appDelegate = getDelegate() {
//                appDelegate.saveContext()
//            }
            
            DatabaseController10.saveContext()
        } else {
            DatabaseController.saveDatabaseContext()
            return
        }
    }
}

