//
//  AppDelegate.m
//  FacebookLogin
//
//  Created by Slava Vdovichenko on 8/25/15.
//  Copyright (c) 2015 BACKENDLESS.COM. All rights reserved.
//


// Facebook "Back­e­n­d­l­e­s­s­U­s­e­r­L­ogin" App ID: 1077032488973601

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Backendless.h"

static NSString *APP_ID = @"";
static NSString *SECRET_KEY = @"";
static NSString *VERSION_NUM = @"v1";

#if 1

@interface Task : NSObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *status;
@end

@implementation Task
-(NSString *)description {
    return [NSString stringWithFormat:@"<Task> [%@] %@ (%@)", self.objectId, self.title, self.status];
}
@end

#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //[DebLog setIsActive:YES];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    backendless.hostURL = @"http://api.backendless.com";
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL result = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                 openURL:url
                                                       sourceApplication:sourceApplication
                                                              annotation:annotation];
    
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    
    NSLog(@"openURL: result = %@, url = %@\n userId: %@, token = %@, expirationDate = %@, permissions = %@", @(result), url, [token valueForKey:@"userID"], [token valueForKey:@"tokenString"], [token valueForKey:@"expirationDate"], [token valueForKey:@"permissions"]);
    
#if 0
    NSDictionary *fieldsMapping = @{
                                    @"id" : @"facebookId",
                                    @"name" : @"name",
                                    @"birthday": @"birthday",
                                    @"first_name": @"fb_first_name",
                                    @"last_name" : @"fb_last_name",
                                    @"gender": @"gender",
                                    @"email": @"email"
                                    };
#else
    NSDictionary *fieldsMapping = @{
                                    @"name" : @"name",
                                    @"email": @"email"
                                    };
#endif

#if 1 // sync
    
    @try {
        BackendlessUser *user = [backendless.userService loginWithFacebookSDK:token fieldsMapping:fieldsMapping];
        NSLog(@"USER (0): %@", user);
        [backendless.userService logout];
        NSLog(@"LOGOUT");
}
    @catch (Fault *fault) {
        NSLog(@"ERROR: %@", fault);
    
    }
    
#else // async
    
    [backendless.userService
     loginWithFacebookSDK:token
     fieldsMapping:fieldsMapping
     response:^(BackendlessUser *user) {
         NSLog(@"USER (0): %@\ncurrentAccessToken = %@", user, [FBSDKAccessToken currentAccessToken]);
         
         @try {
#if 0
             Task *task = [Task new];
             task.title = [backendless randomString:12];
             [user setProperty:@"task" object:task];
             user = [backendless.userService update:user];
             NSLog(@"USER (1): %@", user);
#endif
#if 0
             [user setProperty:@"currentUser" object:backendless.userService.currentUser];
             user = [backendless.userService update:user];
             NSLog(@"USER (2): %@", user);
#endif
#if 0
             Task *task = [Task new];
             task.title = [backendless randomString:12];
             Task *saved = [backendless.data save:task];
             id result = [backendless.data.permissions grantForUser:user.objectId entity:saved operation:DATA_UPDATE];
             NSLog(@"GRANT): %@", result);
             
#endif
#if 0
             token = [FBSDKAccessToken currentAccessToken];
             NSLog(@"currentAccessToken: userId: %@, token = %@, expirationDate = %@, permissions = %@", [token valueForKey:@"userID"], [token valueForKey:@"tokenString"], [token valueForKey:@"expirationDate"], [token valueForKey:@"permissions"]);
#endif
             [backendless.userService logout];
             NSLog(@"LOGOUT");
         }
         @catch (Fault *fault) {
             NSLog(@"%@", fault);
         }
     }
     error:^(Fault *fault) {
         NSLog(@"openURL: %@", fault);
     }];
    
#endif
    
    return result;
}

@end
