//
//  AppDelegate.m
//  FacebookLogin
//
//  Created by Slava Vdovichenko on 8/25/15.
//  Copyright (c) 2015 BACKENDLESS.COM. All rights reserved.
//

// com.themidnightcoders.FacebookLogin
// my Facebook "Back­e­n­d­l­e­s­s­U­s­e­r­L­ogin" App ID: 1077032488973601 App Secret: 864152891aa661ef1f2eb991be3fb9a8
// Anatoly's Facebook Application AppId: 276598585828317 App Secret: ddb15e46a7d5e53436617b7a866811d8


#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Backendless.h"

#define _PRODUCTION_ 1
#define _ANATOLY_ 0
#define BKNDLSS_11806 0

#if _PRODUCTION_
#if 0 // BEVideoChat
static NSString *APP_ID = @"7B92560B-91F0-E94D-FFEB-77451B0F9700";
static NSString *SECRET_KEY = @"B9D27BA8-3964-F3AE-FF26-E71FFF487300";
#endif
#if 0 // BKNDLSS11252
static NSString *APP_ID = @"3A5F63C4-6EFC-992D-FF0D-B6CAA3456000";
static NSString *SECRET_KEY = @"EC607A66-4531-8FD5-FFC4-BE02F0690500";
#endif
#if 1 // BKNDLSS11252d
static NSString *APP_ID = @"1C5B19B3-953D-9548-FF59-95999A2FE800";
static NSString *SECRET_KEY = @"CE0A96CD-0421-B988-FF80-E16A6A8F7200";
#endif
#endif

#if _ANATOLY_
#if 1
static NSString *APP_ID = @"DF380E99-E4B7-9AA2-FF34-1180B28A7D00";
static NSString *SECRET_KEY = @"78318653-9B46-F182-FF6B-F9864924CC00";
#endif
#endif

#if BKNDLSS_11806
#if 1
// com.themidnightcoders.FacebookLogin Facebook AppId: 1660519497541840
static NSString *APP_ID = @"29FC1C00-10BB-E1E9-FF4C-1AD425339000";
static NSString *SECRET_KEY = @"2098F6F4-950D-3105-FF0D-3BAC28C95400";
#endif
#endif

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
    if (!token) {
        NSLog(@"!!! Token = null !!!");
        return false;
    }
    
    NSLog(@"openURL: result = %@, url = %@\n userId: %@, token = %@, expirationDate = %@, permissions = %@", @(result), url, [token valueForKey:@"userID"], [token valueForKey:@"tokenString"], [token valueForKey:@"expirationDate"], [token valueForKey:@"permissions"]);
    
    NSDictionary *fieldsMapping = @{
                                    @"id" : @"facebookId",
                                    @"name" : @"name",
                                    @"first_name": @"first_name",
                                    @"last_name" : @"last_name",
                                    @"gender": @"gender",
                                    @"email": @"email"
                                    };

#if 0 // sync
    
    @try {
        BackendlessUser *user = [backendless.userService loginWithFacebookSDK:token fieldsMapping:fieldsMapping];
        NSLog(@"USER (0): %@", user);
#if 0
        [backendless.userService logout];
        NSLog(@"LOGOUT");
#endif
}
    @catch (Fault *fault) {
        NSLog(@"ERROR: %@", fault);
    
    }
    
#else // async
    
    [backendless.userService
     loginWithFacebookSDK:token
     fieldsMapping:fieldsMapping
     response:^(BackendlessUser *user) {
         NSLog(@"USER (0): %@", user);
         
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
             [backendless.userService logout];
             NSLog(@"LOGOUT");
#endif
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
