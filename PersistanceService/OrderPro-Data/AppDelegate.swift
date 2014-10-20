//
//  AppDelegate.swift
//  OrderPro-Data
//
//  Created by Vyacheslav Vdovichenko on 10/17/14.
//  Copyright (c) 2014 BACKENDLESS.COM. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let APP_ID = "88977ABC-84C1-7892-FF31-FE65E43DBB00"
    let SECRET_KEY = "33C75331-6DAE-EAFB-FFEF-3D6D1F52D600"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        NSLog("!!! APP IS LAUNCHED !!!")
        
        DebLog.setIsActive(true)
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        backendless.hostURL = "http://api.backendless.com"
        backendless.setThrowException(false)
        
        var fault : Fault?
        
        /*
        // - sync method with fault as reference
        var item : OrderItem = backendless.persistenceService.save(OrderItem(), error: &fault) as OrderItem
        if (fault == nil) {
            println("OrderItem: \(item.itemName ) <\(item.objectId)>")
            //var obj : AnyObject = backendless.persistenceService.findById("OrderItem", sid: item.objectId)
        }
        else {
            println("FAULT: \(fault!.faultCode) <\(fault!.detail)>")
        }
        
        */

        // - sorting for the selected columns (ascending and descending)
        
        NSLog(" ------------------ TEST: sorting for the selected columns ---------------------------------")
        
        var query1 : QueryOptions = QueryOptions()
        query1.sortBy = ["name", "objectId"]
        var dataQuery1 : BackendlessDataQuery = BackendlessDataQuery()
        dataQuery1.queryOptions = query1
        
        var c : AnyClass = Types.classByName(Types.objectClassName(Order()))
        //var result : AnyObject = backendless.persistenceService.find(NSClassFromString("OrderPro_Data.Order"), dataQuery:dataQuery1)
        var result : AnyObject = backendless.persistenceService.find(c, dataQuery:dataQuery1)
        if (result is BackendlessCollection) {
            var bc1 : BackendlessCollection = result as BackendlessCollection
            for order : Order in bc1.data as [Order] {
                println("OrderItem: \(order.name) <\(order.objectId)>")
            }
        }
        if (result is Fault) {
            println("FAULT: \(result.faultCode) <\(result.detail)>")
        }

        //
        
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

