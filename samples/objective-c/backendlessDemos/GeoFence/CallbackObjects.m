//
//  CallbackObjects.m
//  SamplesForDoc
//
//  Created by Slava Vdovichenko on 5/18/15.
//  Copyright (c) 2015 backendless.com. All rights reserved.
//

#import "CallbackObjects.h"
#import "Backendless.h"
#import "ViewController.h"

@implementation GeoFenceClientCallback

-(id)init {
    
    if ( (self=[super init]) ) {
        CLLocation *_location = [[LocationTracker sharedInstance] getLocation];
        self.me = [GeoPoint geoPoint:(GEO_POINT){.latitude=_location.coordinate.latitude, .longitude=_location.coordinate.longitude} categories:@[@"GeoFenceiOS"]];
        [self savePoint];
    }
    return self;
}

#define _USE_ASYNC_ 1

-(void)savePoint {

#if _USE_ASYNC_
    [backendless.geo
     savePoint:_me
     response:^(GeoPoint *response) {
         if (!_me.objectId) {
             _me.objectId = response.objectId;
             NSLog(@"GeoFenceClientCallback -> savePoint: (ASYNC) Geopoint position has been saved: %@", _me);
         }
         else {
             NSLog(@"GeoFenceClientCallback -> savePoint: (ASYNC) Geopoint position has been updated: %@", _me);
         }
     }
     error:^(Fault *fault) {
         NSLog(@"GeoFenceClientCallback -> savePoint: (ASYNC) Server reported an error: (FAULT) %@", fault);
     }];
#else
    @try {
        self.me = [backendless.geo savePoint:_me];
        NSLog(@"GeoFenceClientCallback -> savePoint: (SYNC) Geopoint position has been saved: %@", _me);
    }
    @catch (Fault *fault) {
        NSLog(@"GeoFenceClientCallback -> savePoint: (SYNC) Server reported an error: (FAULT) %@", fault);
    }
#endif
}

#pragma mark -
#pragma mark IGeofenceCallback Methods

-(void)geoPointEntered:(NSString *)geofenceName geofenceId:(NSString *)geofenceId latitude:(double)latitude longitude:(double)longitude {
    NSLog(@"GeoFenceClientCallback -> geoPointEntered: %@ <%@>", geofenceName, geofenceId);
    [_me latitude:latitude];
    [_me longitude:longitude];
    [_me addMetadata:[NSString stringWithFormat:@"Entered_%@", geofenceName] value:[NSDate date]];
    [self savePoint];
    
    [_vc addText:[NSString stringWithFormat:@"Entered: %@", geofenceName]];
}

-(void)geoPointStayed:(NSString *)geofenceName geofenceId:(NSString *)geofenceId latitude:(double)latitude longitude:(double)longitude {
    NSLog(@"GeoFenceClientCallback -> geoPointStayed: %@ <%@>", geofenceName, geofenceId);
    [_me latitude:latitude];
    [_me longitude:longitude];
    [_me addMetadata:[NSString stringWithFormat:@"Stayed_%@", geofenceName] value:[NSDate date]];
    [self savePoint];
    
    [_vc addText:[NSString stringWithFormat:@"Stayed: %@", geofenceName]];
}

-(void)geoPointExited:(NSString *)geofenceName geofenceId:(NSString *)geofenceId latitude:(double)latitude longitude:(double)longitude {
    NSLog(@"GeoFenceClientCallback -> geoPointExited: %@ <%@>", geofenceName, geofenceId);
    [_me latitude:latitude];
    [_me longitude:longitude];
    [_me addMetadata:[NSString stringWithFormat:@"Exited_%@", geofenceName] value:[NSDate date]];
    [self savePoint];
    
    [_vc addText:[NSString stringWithFormat:@"Exited: %@", geofenceName]];
}

@end
