//
//  AppDelegate.m
//  SilentPushChat
//
//  Created by Slava Vdovichenko on 8/4/15.
//  Copyright (c) 2015 BACKENDLESS.COM. All rights reserved.
//

#import "AppDelegate.h"
#import "Backendless.h"
#import "ViewController.h"

// *** YOU SHOULD SET THE FOLLOWING VALUES FROM YOUR BACKENDLESS APPLICATION ***
// *** COPY/PASTE APP ID and SECRET KET FROM BACKENDLESS CONSOLE (use the Manage > App Settings screen) ***

#define _PRODUCTION_ 0
#define _TEST_ 1

#if _PRODUCTION_
static NSString *HOST_URL = @"https://api.backendless.com";
static NSString *APP_ID = @"7B92560B-91F0-E94D-FFEB-77451B0F9700";
static NSString *SECRET_KEY = @"B9D27BA8-3964-F3AE-FF26-E71FFF487300";
#endif
#if _TEST_
#if 0
static NSString *HOST_URL = @"http://10.0.1.116:9000";
static NSString *APP_ID = @"8C2263E0-8A50-5133-FF6E-7497E19A4C00";
static NSString *SECRET_KEY = @"3748791C-9BFB-67C3-FFA4-EBBFD9859600";
#endif
#if 1
static NSString *HOST_URL = @"http://api.backendless.com";
static NSString *APP_ID = @"7B92560B-91F0-E94D-FFEB-77451B0F9700";
static NSString *SECRET_KEY = @"B9D27BA8-3964-F3AE-FF26-E71FFF487300";
#endif
#endif
static NSString *VERSION_NUM = @"v1";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DebLog setIsActive:YES];
    
    backendless.hostURL = HOST_URL;
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    [backendless.messaging registerForPushPubSub];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [backendless.messaging applicationWillTerminate];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    [backendless.messaging didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    [backendless.messaging didFailToRegisterForRemoteNotificationsWithError:err];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [backendless.messaging didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler {
    
    [backendless.messaging didReceiveRemoteNotification:userInfo];
    handler(UIBackgroundFetchResultNewData);
}

@end
