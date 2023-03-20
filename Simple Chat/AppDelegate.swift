//
//  AppDelegate.swift
//  Simple Chat
//
//  Created by Nikita Kolomoec on 20.03.2023.
//

import Foundation
import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
                   [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
