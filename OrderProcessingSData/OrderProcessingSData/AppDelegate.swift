//
//  AppDelegate.swift
//  OrderProcessingSData
//
//  Created by Vyacheslav Vdovichenko on 10/21/14.
//  Copyright (c) 2014 BACKENDLESS.COM. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let APP_ID = "F7E12D2B-9C73-B667-FF6E-D45453462E00"
    let SECRET_KEY = "8AE02A1D-DB9E-A21A-FF80-F41374983700"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        println("!!! APP IS LAUNCHED !!!")
        
        //DebLog.setIsActive(true)
        
        // backendless initialization
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        //backendless.hostURL = "http://api.backendless.com"
        backendless.setThrowException(false)
        
        
        var result : AnyObject?
        var fault : Fault?
        
        // backendless user login
        fault = nil
        var user : AnyObject! = backendless.userService.login("bob@foo.com", password:"bob", error:&fault)
        if (fault == nil) {
            println("\n(User login): \((user as BackendlessUser).description)")
        }
        else {
            println("\nFAULT (0): \(fault!.description)")
        }
        //
        
        // create data stores
        var customers = backendless.persistenceService.of(Customer().ofClass())
        var addresses = backendless.persistenceService.of(Address().ofClass())
        var items = backendless.persistenceService.of(OrderItem().ofClass())
        var orders = backendless.persistenceService.of(Order().ofClass())
        
        // test save - update - remove
        
        println("\n ---------------- TEST (0): save - update - remove --------------------")
        
        // customer
        var customer = Customer()
        customer.name = "Stiven"
        customer.user = user as? BackendlessUser
        customer.addFriend(Customer())
        
        /* save the customer
        fault = nil
        result = customers.save(customer, fault:&fault)
        if (fault == nil) {
            println("\n(Customer save): \((result as Customer).description)")
        }
        else {
            println("\nFAULT (0): \(fault!.description)")
        }
        */
        
        // address
        var address = Address()
        address.family["boss"] = customer;
        
        // save the address
        fault = nil
        result = addresses.save(address, fault:&fault)
        if (fault == nil) {
            println("\n(Address save): \((result as Address).description)")
        }
        else {
            println("\nFAULT (0): \(fault!.description)")
        }
        //
        
        // item
        var item1 = OrderItem()
        item1.itemName = "item1"
        item1.unitPrice = "$"
        item1.quantity = 10
        
        /* save the item
        fault = nil
        result = items.save(item1, fault:&fault)
        if (fault == nil) {
            println("\n(OrderItem save): \((result as OrderItem).description)")
        }
        else {
            println("\nFAULT (0): \(fault!.description)")
        }
        */
        
        // order
        var order = Order()
        order.name = "Testing..."
        order.customer = customer
        order.orderItems.append(item1)
        
        /* save the order
        fault = nil
        result = orders.save(order, fault:&fault)
        if (fault == nil) {
            println("\n(Order save): \((result as Order).description)")
        }
        else {
            println("\nFAULT (0): \(fault!.description)")
        }
        */
        
        // order: save -> update -> findID -> load relations -> remove
        fault = nil
        result = orders.save(order, fault:&fault)
        if (fault == nil) {
            
            order = result as Order
            println("\n(save): \(order.description)")
            
            order.customer?.ownerId = order.objectId
            
            var item2 = OrderItem()
            item2.itemName = "item2"
            item2.unitPrice = "%"
            item2.quantity = 100
            
            order.orderItems.append(item2)
            
            result = orders.save(order, fault:&fault)
            if (fault == nil) {
                
                order = result as Order
                println("\n(update): \(order.description)")
                
                result = orders.findID(order.objectId, fault:&fault)
                if (fault == nil) {
                    
                    order = result as Order
                    println("\n(findID): \(order.description)")
                    
                    result = orders.load(order, relations:["customer", "orderItems"], fault:&fault)
                    if (fault == nil) {
                        
                        order = result as Order
                        println("\n(load relations): \(order.description)")
                        
                        orders.remove(order, fault:&fault)
                    }
                }
            }
            
        }
        
        if (fault != nil) {
            println("\nFAULT (0): \(fault!.description)")
        }
        
        //
        
        // - sorting for the selected columns (ascending and descending)
        
        println("\n ------------------ TEST (1): sorting for the selected columns ------------")
        
        var dataQuery1 = BackendlessDataQuery()
        dataQuery1.queryOptions.sortBy = ["name", "objectId"]
            
        result = orders.find(dataQuery1)
        if (result is BackendlessCollection) {
            var bc : BackendlessCollection = result as BackendlessCollection
            for order : Order in bc.data as [Order] {
                println("\(order.description)")
            }
        }
        if (result is Fault) {
            println("\nFAULT (1): \(fault!.description)")
        }
        
        // - loading selected relations
        
        println("\n ------------------ TEST (2): loading selected relations -------------------");
        
        var dataQuery2 = BackendlessDataQuery()
        dataQuery2.queryOptions.related(["customer", "orderItems"])
        
        result = orders.find(dataQuery2)
        if (result is BackendlessCollection) {
            var bc : BackendlessCollection = result as BackendlessCollection
            for order : Order in bc.data as [Order] {
                println("\(order.description)")
            }
        }
        if (result is Fault) {
            println("\nFAULT (2): \(fault!.description)")
        }
        
        // - page size & orrset
        
        println("\n ------------------ TEST (3): page size & offset ----------------------------");
        
        var dataQuery3 = BackendlessDataQuery()
        dataQuery3.queryOptions = QueryOptions.query(10, offset:7)
        
        result = orders.find(dataQuery3)
        if (result is BackendlessCollection) {
            var bc : BackendlessCollection = result as BackendlessCollection
            for order : Order in bc.data as [Order] {
                println("\(order.description)")
            }
        }
        if (result is Fault) {
            println("\nFAULT (3): \(fault!.description)")
        }
        
        // - where clause
        
        println("\n ------------------ TEST (4): where clause ------------------------------------");
        
        var dataQuery4 = BackendlessDataQuery()
        dataQuery4.whereClause = "name = \'Testing...\'"
        
        result = orders.find(dataQuery4)
        if (result is BackendlessCollection) {
            var bc : BackendlessCollection = result as BackendlessCollection
            for order : Order in bc.data as [Order] {
                println("\(order.description)")
            }
        }
        if (result is Fault) {
            println("\nFAULT (4): \(fault!.description)")
        }
        
        // - relations depth
        
        println("\n ------------------ TEST (5): relations depth ----------------------------------");
        
        var dataQuery5 = BackendlessDataQuery()
        dataQuery5.queryOptions.relationsDepth = 1
        
        result = orders.find(dataQuery5)
        if (result is BackendlessCollection) {
            var bc : BackendlessCollection = result as BackendlessCollection
            for order : Order in bc.data as [Order] {
                println("\(order.description)")
            }
        }
        if (result is Fault) {
            println("\nFAULT (5): \(fault!.description)")
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

