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

#define IS_PRODUCTION 1

// *** YOU SHOULD SET THE FOLLOWING VALUES FROM YOUR BACKENDLESS APPLICATION ***
// *** COPY/PASTE APP ID and SECRET KET FROM BACKENDLESS CONSOLE (use the Manage > App Settings screen) ***
#if IS_PRODUCTION
static NSString *APP_ID = @"88977ABC-84C1-7892-FF31-FE65E43DBB00";
static NSString *SECRET_KEY = @"33C75331-6DAE-EAFB-FFEF-3D6D1F52D600";
#else
static NSString *APP_ID = @"F86D8AA8-06A2-B17F-FF8D-D41B3633E900";
static NSString *SECRET_KEY = @"CBDD92FA-4386-0F35-FF7D-49E0863A2200";
#endif
static NSString *VERSION_NUM = @"v1";


@implementation StartAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[DebLog setIsActive:YES];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
#if IS_PRODUCTION
    backendless.hostURL = @"http://api.backendless.com";
#else
    backendless.hostURL = @"http://10.0.1.53:9000";
#endif

    NSDictionary *remoteDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteDict)
        [self application:application didReceiveRemoteNotification:remoteDict];
    
    // check if iOS8
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
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
    NSLog(@"APN Unregistration");
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [(StartViewController *)[[(UINavigationController *)[self.window rootViewController] viewControllers] objectAtIndex:0] startNetIndicator];
    
    NSString *deviceTokenStr = [backendless.messagingService deviceTokenAsString:deviceToken];
    NSLog(@"application:didRegisterForRemoteNotificationsWithDeviceToken: ->  deviceToken = %@", deviceTokenStr);
   
    @try {
        NSString *deviceRegistrationId = [backendless.messagingService registerDeviceToken:deviceTokenStr];
        NSLog(@"application:didRegisterForRemoteNotificationsWithDeviceToken: -> registerDeviceToken: deviceRegistrationId = %@", deviceRegistrationId);
    }
    @catch (Fault *fault) {
        NSLog(@"application:didRegisterForRemoteNotificationsWithDeviceToken: -> registerDeviceToken: FAULT = %@", fault);
    }
    
    [(StartViewController *)[[(UINavigationController *)[self.window rootViewController] viewControllers] objectAtIndex:0] stopNetIndicator];
 }

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"application:didReceiveRemoteNotification: %@", userInfo);
    NSString *notification = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    [(StartViewController *)[[(UINavigationController *)[self.window rootViewController] viewControllers] objectAtIndex:0] showNotification:notification];
}
#if 0
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler
{
    NSLog(@"application:didReceiveRemoteNotification:fetchCompletionHandler: %@", userInfo);
}
#endif
@end
