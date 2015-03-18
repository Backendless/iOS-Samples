//
//  AppDelegate.swift
//  VideoService
/*
* *********************************************************************************************************************
*
*  BACKENDLESS.COM CONFIDENTIAL
*
*  ********************************************************************************************************************
*
*  Copyright 2014 BACKENDLESS.COM. All Rights Reserved.
*
*  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
*  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
*  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
*  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
*  unless prior written permission is obtained from Backendless.com.
*
*  ********************************************************************************************************************
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let APP_ID = "7B92560B-91F0-E94D-FFEB-77451B0F9700"
    let SECRET_KEY = "B9D27BA8-3964-F3AE-FF26-E71FFF487300"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //DebLog.setIsActive(true)
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        backendless.setThrowException(false)
        backendless.mediaService = MediaService()
        
        return true
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

