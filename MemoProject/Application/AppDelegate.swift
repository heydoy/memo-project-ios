//
//  AppDelegate.swift
//  MemoProject
//
//  Created by Doy Kim on 2022/09/01.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        // realm migration
        aboutMigration()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// Realm Migration
extension AppDelegate {
    func aboutMigration() {
        let config = Realm.Configuration(
            schemaVersion: 1) { migration, oldSchemaVersion in

                if oldSchemaVersion < 1 {
                    migration.renameProperty(onType: Memo.className(), from: "isPinned", to: "pinnedMemo")
                }
            }
        
        Realm.Configuration.defaultConfiguration = config
    }
}
