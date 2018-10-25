//
//  AppDelegate.swift
//  Passport
//
//  Created by jackrex on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit
import Mapbox

@UIApplicationMain

class PAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        MGLAccountManager.accessToken = "pk.eyJ1Ijoia2VlcGludGwiLCJhIjoiY2pncTRxY2VhMzF6YzJ5bzhsdGFpM21iNiJ9.HD758SGS8F21IA6YnQvoJg"
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        
        if let userId = AccountManager.getUserId() {
            let tabbarController = ResourceUtil.mainSB().instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
            window?.rootViewController = tabbarController
            window?.makeKeyAndVisible()
        }
        

        UMAnalyticsConfig.sharedInstance()?.appKey = "5bd16411f1f556029200001f"
        UMAnalyticsConfig.sharedInstance()?.channelId = "Beta"
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
        
        
        
        UITabBar.appearance().tintColor = UIColor.init(rgb: 0x584f60)
        
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

