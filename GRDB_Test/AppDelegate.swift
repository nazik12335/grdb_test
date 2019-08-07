//
//  AppDelegate.swift
//  GRDB_Test
//
//  Created by Nazar on 7/31/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import UIKit
import GRDB

var dbQueue: DatabaseQueue!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        try! setupDatabase(application)
        setupRootViewController()
        return true
    }
    
    private func setupRootViewController() {
        let rootVC = UINavigationController(rootViewController: WarehouseViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }

    private func setupDatabase(_ application: UIApplication) throws {
        let fileManager = FileManager.default
        let dbPath = try fileManager
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("products.db")
            .path
        if !fileManager.fileExists(atPath: dbPath) {
            let dbResourcePath = Bundle.main.path(forResource: "products", ofType: "db")!
            try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
        }
        dbQueue = try DBClient.openDatabase(path: dbPath)
        dbQueue.setupMemoryManagement(in: application)
    }
}

