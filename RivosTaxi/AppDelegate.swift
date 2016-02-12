//
//  AppDelegate.swift
//  RivosTaxi
//
//  Created by Ramón Quiñonez on 02/10/15.
//  Copyright © 2015 Yozzi Been's. All rights reserved.
//

import UIKit
import GoogleMaps
import FBSDKLoginKit
//import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var centerContainer: MMDrawerController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        DropDown.startListeningToKeyboard()
        // Override point for customization after application launch.
        
        

       
        
        
       
        //Code part 4 Fb
        FBSDKLoginButton.classForCoder()
        
        GMSServices.provideAPIKey("AIzaSyCxbjlxaNmriy_PSp1aWFi3HGXQHDLz3js")
        
        
        var rootViewController = self.window!.rootViewController

        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let centerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ProtectedPageViewController") as! ProtectedPageViewController
        
        
        
        let leftViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SideBarViewController") as! SideBarViewController
        
        // var rightViewController = mainStoryboard.instantiateViewControllerWithIdentifier(“RightSideViewController”) as RightSideViewController
        
        let leftSideNav = UINavigationController(rootViewController: leftViewController)
        let centerNav = UINavigationController(rootViewController: centerViewController)
        
        
        
        centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: leftSideNav)
        

        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView;
        
        window!.rootViewController = centerContainer
        window!.makeKeyAndVisible()
        
        //code part 2
        return FBSDKApplicationDelegate.sharedInstance().application(application,
            didFinishLaunchingWithOptions:launchOptions)
    }
    //code part 3
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) ->Bool{
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation:annotation)
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

