//
//  AppDelegate.swift
//  PersistanceService
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
    
    let APP_ID = ""
    let SECRET_KEY = ""
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        
        //DebLog.setIsActive(true)
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        
        // --------------- UserService -------------------------------------
        
        // - sync methods with fault as exception (full "try/catch/finally" version)
        Types.try({ () -> Void in
            
            // - user login
            var user = self.backendless.userService.login("bob3@foo.com", password:"bob3")
            NSLog("LOGINED USER: %@", user.description)
            
            // - user update
            var counter: AnyObject! = user.getProperty("counter")
            user.setProperty("counter", object: counter)
            user = self.backendless.userService.update(user)
            NSLog("UPDATED USER: %@", user.description)
        
            },
            
            catch: { (exception) -> Void in
                NSLog("FAULT: %@", exception as Fault)
            },
            
            finally: { () -> Void in
                NSLog("USER OPERATIONS ARE FINISHED")
           })
        
        
        // -------------- PersistenceService -------------------------------
        
        // - sync methods with fault as exception (short "try/catch" version)
        Types.try({ () -> Void in
            
            var obj = PersistentObjectQB()
            var result : AnyObject? = self.backendless.persistenceService.save(obj)
            NSLog("PersistentObjectQB: %@", (result as PersistentObjectQB).description)
            
            },
            
            catch: { (exception) -> Void in
                NSLog("FAULT: %@", exception as Fault)
            })
        
        
        // - shut off the fault as exception
        backendless.setThrowException(false)
        
        var result : AnyObject
        var fault : Fault?
        
        // - sync method with fault as reference (fault as exception should be shutted off !)
        var item : AnyObject? = backendless.persistenceService.save(OrderItem(), error: &fault)
        if (fault == nil) {
            var obj : AnyObject = backendless.persistenceService.findById("OrderItem", sid: (item as OrderItem).objectId)
            if (obj is OrderItem) {
                println("OrderItem: \((obj as OrderItem).itemName) <\((obj as OrderItem).objectId)>")
            }
            else {
                println("\nFAULT (0): \(fault!.description)")
           }
        }
        else {
            println("\nFAULT (0): \(fault!.description)")
        }
        
        /* - sorting for the selected columns (ascending and descending)
        
        NSLog(" ------------------ TEST: sorting for the selected columns ---------------------------------")
        
        var query1 : QueryOptions = QueryOptions()
        query1.sortBy = ["name", "objectId"]
        var dataQuery1 : BackendlessDataQuery = BackendlessDataQuery()
        dataQuery1.queryOptions = query1
        
        result = backendless.persistenceService.find(Order().ofClass(), dataQuery:dataQuery1)
        if (result is BackendlessCollection) {
            var bc1 : BackendlessCollection = result as BackendlessCollection
            for order : Order in bc1.data as [Order] {
                println("OrderItem: \(order.name) <\(order.objectId)>")
            }
        }
        if (result is Fault) {
            println("\nFAULT (0): \(fault!.description)")
        }
        
        */
        
        // - sync method with class instance/fault as return (fault as exception should be shutted off !)
        result = backendless.persistenceService.save(Weather())
        if (result is Weather) {
            var obj : AnyObject = backendless.persistenceService.findById("Weather", sid:(result as Weather).objectId)
            if (obj is Weather) {
                var obj1 = obj as Weather
                println("\nWeather (1): \(obj1.description)")
            }
        }
        if (result is Fault) {
            println("\nFAULT (1): \(fault!.description)")
        }
        
        // - sync method with fault as reference (fault as exception should be shutted off !)
        var weather : AnyObject? = backendless.persistenceService.save(Weather(), error: &fault)
        if (fault == nil) {
            var obj : AnyObject = backendless.persistenceService.findById("Weather", sid: (weather as Weather).objectId)
            if (obj is Weather) {
                println("\nWeather (2): \((obj as Weather).description)")
            }
        }
        else {
            println("\nFAULT (2): \(fault!.description)")
        }
        
        // - async method with block-based callbacks
        backendless.persistenceService.save(
            Weather(),
            response: { (var result : AnyObject!) -> () in
                var obj : AnyObject = self.backendless.persistenceService.findById("Weather", sid: (result as Weather).objectId)
                if (obj is Weather) {
                    println("\nWeather (3): \((obj as Weather).description)")
                }
            },
            error: { (var fault : Fault!) -> () in
                println("\nFAULT (3): \(fault!.description)")
            }
        )
        
        // - object as dictionary of properties
        var os = ["iOS":"Apple", "android":"Google"]
        var mobileOs : AnyObject? = backendless.persistenceService.save("MobileOS", entity:os, error: &fault)
        if (fault != nil) {
            println("\nFAULT (4): \(fault!.description)")
        }

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

