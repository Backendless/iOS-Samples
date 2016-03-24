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

// *** YOU SHOULD SET THE FOLLOWING VALUES FROM YOUR BACKENDLESS APPLICATION ***
// *** COPY/PASTE APP ID and SECRET KET FROM BACKENDLESS CONSOLE (use the Manage > App Settings screen) ***
#define _PRODUCTION_TEAM_DEV_ 1
#define _PRODUCTION_AD_HOC_ 0
#define _TEST_ 0
#define _GMO_MBAAS_TEAM_DEV_ 0
#define _GMO_MBAAS_AD_HOC_ 0

#if _PRODUCTION_TEAM_DEV_
// BEVideoChat app
static NSString *HOST_URL = @"https://api.backendless.com";
static NSString *APP_ID = @"7B92560B-91F0-E94D-FFEB-77451B0F9700";
static NSString *SECRET_KEY = @"B9D27BA8-3964-F3AE-FF26-E71FFF487300";
#endif
#if _PRODUCTION_AD_HOC_
static NSString *HOST_URL = @"https://api.backendless.com";
static NSString *APP_ID = @"FBE67BDF-42BF-2A1D-FF32-209047171800";
static NSString *SECRET_KEY = @"1A2DABE4-902B-01D5-FF54-2BB7984C8200";
#endif
#if _TEST_
static NSString *HOST_URL = @"http://10.0.1.14:9000";
static NSString *APP_ID = @"A970D2F5-6B71-BE57-FFFF-0031FDAF7800";
static NSString *SECRET_KEY = @"AC6E2E75-64B0-AC65-FF8A-2FCC9EBB6F00";
#endif
#if _GMO_MBAAS_TEAM_DEV_
static NSString *HOST_URL = @"http://api.gmo-mbaas.com";
static NSString *APP_ID = @"EFA41CCD-E1C7-DDD9-FF4A-002F9AB2B800";
static NSString *SECRET_KEY = @"BF919610-EA3F-0245-FFD5-9D8F56C0F500";
#endif
#if _GMO_MBAAS_AD_HOC_
static NSString *HOST_URL = @"http://api.gmo-mbaas.com";
static NSString *APP_ID = @"EFA41CCD-E1C7-DDD9-FF4A-002F9AB2B800";
static NSString *SECRET_KEY = @"BF919610-EA3F-0245-FFD5-9D8F56C0F500";
#endif

static NSString *VERSION_NUM = @"v1";

#define __OLD__ 0

@implementation StartAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //[DebLog setIsActive:YES];
    
    backendless.hostURL = HOST_URL;
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
#if __OLD__
    [backendless.messaging registerForRemoteNotifications];
#endif
    
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
