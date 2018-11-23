//
//  AppDelegate.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        let rootNavigationController = UINavigationController()
        rootNavigationController.viewControllers = [ StartScreenViewController.loadFromSB() ]
        
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
        return true
    }
}
