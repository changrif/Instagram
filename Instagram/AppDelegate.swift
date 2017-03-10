//
//  AppDelegate.swift
//  Instagram
//
//  Created by Chandler Griffin on 2/20/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Initialize Parse
        // Set applicationId and server based on the values in the Heroku settings.
        // clientKey is not used on Parse open source unless explicitly configured
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "Instagram"
                configuration.clientKey = "lkajfadl;sjfakls;djfakl;sdjfa;ljf"
                configuration.server = "https://evening-harbor-87342.herokuapp.com/parse"
            })
        )
        
        // check if user is logged in.
        if PFUser.current() != nil {
            // if there is a logged in user then load the home view controller
            let homeNavigationController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! UINavigationController
            let homeViewController = homeNavigationController.topViewController as! HomeViewController
            homeViewController.endpoint = "home"
            homeNavigationController.tabBarItem.title = "Home"
            homeNavigationController.tabBarItem.image = UIImage(named: "home")?.stretchableImage(withLeftCapWidth: 30, topCapHeight: 30)
            
            let captureNavigationController = storyboard.instantiateViewController(withIdentifier: "CaptureViewController") as! UINavigationController
            let captureViewController = captureNavigationController.topViewController as! CaptureViewController
            captureViewController.endpoint = "capture"
            captureNavigationController.tabBarItem.title = "Capture"
            captureNavigationController.tabBarItem.image = UIImage(named: "capture")?.stretchableImage(withLeftCapWidth: 30, topCapHeight: 30)
            
            let profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! UINavigationController
            let profileViewController = profileNavigationController.topViewController as! ProfileViewController
            profileViewController.endpoint = "profile"
            profileNavigationController.tabBarItem.title = "Profile"
            profileNavigationController.tabBarItem.image = UIImage(named: "profile")?.stretchableImage(withLeftCapWidth: 30, topCapHeight: 30)
            
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [homeNavigationController, captureNavigationController, profileNavigationController]
            
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
        }   else    {
            let vc = storyboard.instantiateInitialViewController()
            
            self.window?.rootViewController = vc
        }
        
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


}

