//
//  AppDelegate.swift
//  Example
//
//  Created by Anton Belousov on 15/01/2019.
//  Copyright © 2019 kp. All rights reserved.
//

import UIKit
import WatchSyncService

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GenericSyncService.setSyncTipes(types: [Message.self])
        
        return true
    }
}
