//
//  AppDelegate.swift
//  TagsExample
//
//  Created by Tom Clark on 2016-06-25.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
      // Enable or disable features based on authorization
    }
    return true
  }
}
