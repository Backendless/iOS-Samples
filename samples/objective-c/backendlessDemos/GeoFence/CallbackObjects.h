//
//  CallbackObjects.h
//  SamplesForDoc
//
//  Created by Slava Vdovichenko on 5/18/15.
//  Copyright (c) 2015 backendless.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Backendless.h"

@class ViewController;

@interface GeoFenceClientCallback : NSObject <IGeofenceCallback>
@property (strong, nonatomic) GeoPoint *me;
@property (assign, nonatomic) ViewController *vc;
@end
