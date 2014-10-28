//
//  AppDelegate.m
//  OrderProcessingData
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

#import "AppDelegate.h"
#import "Backendless.h"
#import "Customer.h"
#import "Address.h"
#import "OrderItem.h"
#import "Order.h"

static NSString *APP_ID = @"F7E12D2B-9C73-B667-FF6E-D45453462E00";
static NSString *SECRET_KEY = @"8AE02A1D-DB9E-A21A-FF80-F41374983700";
static NSString *VERSION_NUM = @"v1";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //[DebLog setIsActive:YES];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    //backendless.hostURL = @"http://api.backendless.com";
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //
    // create customers datastore
    id <IDataStore> customers = [backendless.persistenceService of:[Customer class]];
    Customer *customer = nil;
    
#if 0 // TEST: save Customer instance with User instance as relation
    
    @try {

        BackendlessUser *user = [backendless.userService login:@"bob@foo.com" password:@"bob"];
        NSLog(@"User LOGIN: %@ ", user);
        
        customer = [Customer new];
        customer.name = @"Bob";
        customer.user = user;
        [customer addFriend:[Customer new]];
        
        customer = [customers save:customer];
        NSLog(@"Customer SAVE: %@", customer);

        customer = [customers findID:customer.objectId relationsDepth:1];
        NSLog(@"Customer FIND: %@ ", customer);
    }
    @catch (Fault *fault) {
        NSLog(@"ERROR SAVE: fault = %@", fault);
    }
#else
    
    @try {
        customer = [customers findLast:1];
        NSLog(@"Customer FINDLAST: %@ ", customer);
    }
    @catch (Fault *fault) {
        NSLog(@"ERROR FINDLAST: fault = %@", fault);
    }
#endif


#if 1 // TEST: save Address instance with dictionary property
    
    // create addresses datastore
    id <IDataStore> adresses = [backendless.persistenceService of:[Address class]];
    
    Address *address = [Address new];
    address.text = @"Hello,word!";
    address.family[@"boss"] = customer? customer: @"nobody";
    
    @try {
        address = [adresses save:address];
        NSLog(@"ADDRESS SAVE: %@", address);
        
    }
    @catch (Fault *fault) {
        NSLog(@"ERROR SAVE: fault = %@", fault);
    }
    
#endif
    
    // create orders datastore
    id <IDataStore> orders = [backendless.persistenceService of:[Order class]];
    
#if 1 // TEST: save - update - remove
    
    NSLog(@"TEST (0) BEGIN: save -> update -> findID -> remove");
    
    @try {
        
        OrderItem *item1 = [OrderItem new];
        item1.itemName = @"item1";
        item1.unitPrice = @"$";
        item1.quantity = @(10);
        
        Order *order = [Order new];
        order.name = @"Testing...";
        order.className = @"OrderItem";
        order.customer = customer;
        [order addOrderItem:item1];
        
        order = [orders save:order];
        NSLog(@"ORDER SAVE: %@", order);
        
        OrderItem *item2 = [OrderItem new];
        item2.itemName = @"item2";
        item2.unitPrice = @"%";
        item2.quantity = @(100);
        [order addOrderItem:item2];
        
        order = [orders save:order];
        NSLog(@"ORDER UDPATE: %@", order);
        
        order = [orders findID:order.objectId];
        [order loadOrderItems];
        NSLog(@"ORDER findID: %@", order);
        
        [orders remove:order];
        
        NSLog(@"ORDER REMOVED");
        
    }
    @catch (Fault *fault) {
        NSLog(@"ERROR SAVE: fault = %@", fault);
    }
    
#endif
    
    
#if 1 // TEST: finding with different options
    
    @try {
        
        // - sorting for the selected columns (ascending and descending)
        
        NSLog(@" ------------------ TEST (1): sorting for the selected columns ------------------- ");
        
        BackendlessDataQuery *dataQuery1 = [BackendlessDataQuery query];
        dataQuery1.queryOptions.sortBy = @[@"name", @"objectId"];
        
        BackendlessCollection *bc1 = [orders find:dataQuery1];
        for (Order *order in bc1.data) {
            NSLog(@"ORDER find: %@", order);
        }
        
        // - loading selected relations
        
        NSLog(@" ------------------ TEST (2): loading selected relations --------------------------");
        
        BackendlessDataQuery *dataQuery2 = [BackendlessDataQuery query];
        [dataQuery2.queryOptions related:@[@"customer", @"orderItems"]];
        
        BackendlessCollection *bc2 = [orders find:dataQuery2];
        for (Order *order in bc2.data) {
            NSLog(@"ORDER find: %@", order);
        }
        
        // - page size & orrset
        
        NSLog(@" ------------------ TEST (3): page size & orrset -----------------------------------");
        
        BackendlessDataQuery *dataQuery3 = [BackendlessDataQuery query];
        dataQuery3.queryOptions = [QueryOptions query:10 offset:7];
        
        BackendlessCollection *bc3 = [orders find:dataQuery3];
        for (Order *order in bc3.data) {
            NSLog(@"ORDER find: %@", order);
        }
        
        // - where clause
        
        NSLog(@" ------------------ TEST (4): where clause -----------------------------------------");

        BackendlessDataQuery *dataQuery4 = [BackendlessDataQuery query];
        dataQuery4.whereClause = @"name = \'Testing...\'";
        
        BackendlessCollection *bc4 = [orders find:dataQuery4];
        for (Order *order in bc4.data) {
            NSLog(@"ORDER find: %@", order);
        }
        
        // - relations depth
        
        NSLog(@" ------------------ TEST (5): relations depth --------------------------------------");
        
        BackendlessDataQuery *dataQuery5 = [BackendlessDataQuery query];
        dataQuery5.queryOptions.relationsDepth = @(1);
        
        BackendlessCollection *bc5 = [orders find:dataQuery5];
        for (Order *order in bc5.data) {
            NSLog(@"ORDER find: %@", order);
        }
        //
    }
    
    @catch (Fault *fault) {
        NSLog(@"ERROR SAVE: fault = %@", fault);
    }
    
#endif

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
