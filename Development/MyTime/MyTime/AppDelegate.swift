//
//  AppDelegate.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Configuration for split view controller
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController =
            splitViewController.viewControllers[splitViewController.viewControllers.count - 1]
                as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem =
            splitViewController.displayModeButtonItem
        splitViewController.delegate = self
                
//        // Show the primary and secondary view controllers side by side
//        splitViewController.preferredDisplayMode = .allVisible
        
        // Read and set up the data model
        DataModel.default = DataModel.readFromFile() ?? DataModel()
        
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

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
//        print(#function)
        
        // Apply default behaviour, try to incorporate the navigation controller into the interface
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else {
            return false
        }
        
        // Do not do anything, discard table view controller
        if let _ = (secondaryAsNavController.topViewController as? UITableViewController) {
//            print("Successfully handled collapse")
            return true
        }
        
        // Apply default behaviour, try to incorporate the view controller into the interface
        return false
    }

}



