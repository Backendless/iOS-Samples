//
//  StartAppDelegate.m
//  GeoService
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

#define _LOCALHOST_ 0
#define _PRODUCTION_ 1
#define _TEST_ 0

#if _LOCALHOST_
static NSString *HOST_URL = @"http://10.0.1.62:9000";
static NSString *APP_ID = @"9E2E39D8-0A73-D2CE-FF84-E21661EF2700";
static NSString *SECRET_KEY = @"ADE0B282-A1CF-1229-FF46-DB768BB9BE00";
#endif
#if _PRODUCTION_
static NSString *HOST_URL = @"https://api.backendless.com";
static NSString *APP_ID = @"88977ABC-84C1-7892-FF31-FE65E43DBB00";
static NSString *SECRET_KEY = @"33C75331-6DAE-EAFB-FFEF-3D6D1F52D600";
#endif
#if _TEST_
static NSString *HOST_URL = @"http://apitest.backendless.com";
static NSString *APP_ID = @"88977ABC-84C1-7892-FF31-FE65E43DBB00";
static NSString *SECRET_KEY = @"33C75331-6DAE-EAFB-FFEF-3D6D1F52D600";
#endif
static NSString *VERSION_NUM = @"v1";

@implementation StartAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [DebLog setIsActive:YES];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];

    if ([CLLocationManager locationServicesEnabled]) {
        
        _locationManager = [CLLocationManager new];
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        [_locationManager startUpdatingLocation];
        sleep(1);
        
        NSLog(@"StartAppDelegate: (SUCCESS) Location services is enabled.");
    }
    else {
        
        _locationManager = nil;
        
        NSLog(@"StartAppDelegate: (ERROR) Location services is not enabled.");
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
