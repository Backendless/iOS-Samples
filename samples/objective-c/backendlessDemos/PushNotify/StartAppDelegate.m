//
//  StartAppDelegate.m
//  PushNotify
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2012 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

#import "StartAppDelegate.h"
#import "Backendless.h"
#import "StartViewController.h"

#define _PRODUCTION_ 0
#define _TEST_SERVER_ 1

// *** YOU SHOULD SET THE FOLLOWING VALUES FROM YOUR BACKENDLESS APPLICATION ***
// *** COPY/PASTE APP ID and SECRET KET FROM BACKENDLESS CONSOLE (use the Manage > App Settings screen) ***
#if _PRODUCTION_
static NSString *APP_ID = @"CF47722D-EB7B-A0D0-FFE3-1FADE3346100";
static NSString *SECRET_KEY = @"43B43EF7-247A-ED56-FF2F-ECD43C6E9000";
#endif
#if _TEST_SERVER_
static NSString *APP_ID = @"D8614D1F-D542-7F85-FFE0-0B04270E2100";
static NSString *SECRET_KEY = @"A9E97576-6BF6-0E88-FFA0-C7B6FD3CB100";
#endif
static NSString *VERSION_NUM = @"v1";


@implementation StartAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DebLog setIsActive:YES];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
#if _TEST_SERVER_
    backendless.hostURL = @"http://10.0.1.115:9000";
#endif
    
    [backendless.messaging didFinishLaunchingWithOptions:launchOptions];
    [backendless.messaging registerForRemoteNotifications];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [backendless.messaging unregisterForRemoteNotifications];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [(StartViewController *)[[(UINavigationController *)[self.window rootViewController] viewControllers] objectAtIndex:0] startNetIndicator];
    [backendless.messaging didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    [(StartViewController *)[[(UINavigationController *)[self.window rootViewController] viewControllers] objectAtIndex:0] stopNetIndicator];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    [backendless.messaging didFailToRegisterForRemoteNotificationsWithError:err];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *notification = [backendless.messaging didReceiveRemoteNotification:userInfo];
    [(StartViewController *)[[(UINavigationController *)[self.window rootViewController] viewControllers] objectAtIndex:0] showNotification:notification];
}

@end
