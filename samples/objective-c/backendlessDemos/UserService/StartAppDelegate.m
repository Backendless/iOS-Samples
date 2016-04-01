//
//  StartAppDelegate.m
//  UserService
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


// *** YOU SHOULD SET THE FOLLOWING VALUES FROM YOUR BACKENDLESS APPLICATION ***
// *** COPY/PASTE APP ID and SECRET KET FROM BACKENDLESS CONSOLE (use the Manage > App Settings screen) ***
#define _PRODUCTION_ 1
#define _ANATOLY_ 0

#if _PRODUCTION_
static NSString *HOST_URL = @"http://api.backendless.com";
#if 1 // BasicTest
static NSString *APP_ID = @"25C2E37D-8EB6-8CDA-FF37-D6F05AE7EE00";
static NSString *SECRET_KEY = @"675002F9-A2F8-567F-FFB2-3E348B887900";
#endif
#if 0 // BEVideoChat
static NSString *APP_ID = @"7B92560B-91F0-E94D-FFEB-77451B0F9700";
static NSString *SECRET_KEY = @"B9D27BA8-3964-F3AE-FF26-E71FFF487300";
#endif
#if 0 // BKNDLSS11252a
static NSString *APP_ID = @"CB95ACB9-E041-40DE-FFA0-B205F5897000";
static NSString *SECRET_KEY = @"C82BA900-8090-8D1B-FF99-395DD6FF6B00";
#endif
#if 0 // BKNDLSS11252b
static NSString *APP_ID = @"7A899B44-C380-CA43-FF20-18F535E56300";
static NSString *SECRET_KEY = @"8632A223-EAA5-07F4-FF5B-C7A75C59A000";
#endif
#if 0 // BKNDLSS11252d
static NSString *APP_ID = @"1C5B19B3-953D-9548-FF59-95999A2FE800";
static NSString *SECRET_KEY = @"CE0A96CD-0421-B988-FF80-E16A6A8F7200";
#endif
#endif

#if _ANATOLY_
static NSString *HOST_URL = @"http://tc.themidnightcoders.com:7782";
static NSString *APP_ID = @"2E0535D6-FDA3-6665-FF85-95914A416000";
static NSString *SECRET_KEY = @"A8F10638-9D6C-F32C-FF3A-DA2878F83000";
#endif
static NSString *VERSION_NUM = @"v1";


@implementation StartAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //[DebLog setIsActive:YES];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    backendless.hostURL = HOST_URL;
    
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
