//
//  AppDelegate.swift
//  SZ_Lottie_DEMO_Swift
//
//  Created by 颜浪 on 2018/4/26.
//  Copyright © 2018年 颜浪. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let mainViewController: MainListViewController = MainListViewController()

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        startAPP()
        
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


// MARK: - private method
extension AppDelegate {
    
    private func startAPP() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.backgroundColor = UIColor.white
        
        window?.makeKeyAndVisible()
        
        window?.rootViewController = UINavigationController.init(rootViewController: mainViewController)
        
//        showLanuchAnimationView()
    }
    
    private func showLanuchAnimationView() {
        
        guard let win = window else { return }
        
        let animView: LanuchAnimationView = LanuchAnimationView(frame: window?.bounds ?? CGRect.zero)
        
        // 全 JSON 动画
        animView.showLanuchOne(target: win, completion: { [weak self] in

            guard let `self` = self else { return }

            self.mainViewController.playHeadAnimation()
        })
        
        // 以 image 为底的 JSON 动画
//        animView.showLanuchTwo(target: win, completion: { [weak self] in
//
//            guard let `self` = self else { return }
//
//            self.mainViewController.playHeadAnimation()
//        })
    }
}
