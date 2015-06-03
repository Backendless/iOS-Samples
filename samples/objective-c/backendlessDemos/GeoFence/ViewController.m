//
//  ViewController.m
//  GeoFence
//
//  Created by Slava Vdovichenko on 5/19/15.
//  Copyright (c) 2015 BACKENDLESS.COM. All rights reserved.
//

#import "ViewController.h"
#import "Backendless.h"
#import "CallbackObjects.h"

#define APP_NAME @"GeoFenceApp"

@interface ViewController () <ILocationTrackerListener> {
    LocationTracker *_locationTracker;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    @try {
        [backendless initAppFault];
    }
    @catch (Fault *fault) {
        [self showAlert:fault.message];
    }
    
    _locationTracker = [LocationTracker sharedInstance];
    [_locationTracker addListener:self];

#if 0
    _locationTracker.distanceFilter = 5;
    _locationTracker.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    //_locationTracker.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationTracker.monitoringSignificantLocationChanges = NO;
#endif

#if 0
    [self startMonitoringAllGeofencesWithRemoteCallback];
#endif
    
#if 1
    [self startMonitoringAllGeofencesWithLocalCallback];
#endif
    
#if 0
    [self startMonitoringSpesificGeofenceWithRemoteCallback];
#endif
    
#if 0
    [self startMonitoringSpesificGeofenceWithLocalCallback];
#endif
    
#if 0
    [self retriveGeopointsFromGeofence];
#endif

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = [self.textView.text stringByAppendingFormat:@"%@\n%@\n", [NSDate date], text];
    });
}

#pragma mark -
#pragma mark ILocationTrackerListener Methods

-(void)onLocationChanged:(CLLocation *)location {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [DebLog log:@"ViewController -> onLocationChanged: %@", location];
        
        NSString *lat = [NSString stringWithFormat:@"LAT: %f", location.coordinate.latitude];
        NSString *lon = [NSString stringWithFormat:@"LON: %f", location.coordinate.longitude];
        NSString *time = [NSString stringWithFormat:@"%@", [NSDate date]];
        
        self.labelLat.text = lat;
        self.labelLon.text = lon;
        self.labelTime.text = time;
        self.textView.text = [self.textView.text stringByAppendingFormat:@"%@\n%@ %@\n", time, lat, lon];
    });
}

-(void)onLocationFailed:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [DebLog log:@"ViewController -> onLocationFailed: ERROR: %@", error];
        self.textView.text = [self.textView.text stringByAppendingFormat:@"ERROR: %@\n", error];
    });
}

#pragma mark -
#pragma mark Private Methods

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

// Start location monitoring for a specific geofence with a local callback
-(void)startMonitoringSpesificGeofenceWithLocalCallback {
    
    NSLog(@">>>> startMonitoringSpesificGeofenceWithLocalCallback >>>>>");
    
    GeoFenceClientCallback *geoFenceCallback = [GeoFenceClientCallback new];
    geoFenceCallback.vc = self;
    
    [backendless.geo
     startGeofenceMonitoring:@"WorkRect"
     callback:geoFenceCallback
     response:^(id response) {
         NSLog(@"Geofence monitoring has been started: %@", response);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

//Start location monitoring for all geofences with a local callback
-(void)startMonitoringAllGeofencesWithLocalCallback {
    
    NSLog(@">>>> startMonitoringAllGeofencesWithLocalCallback >>>>>");
    
    GeoFenceClientCallback *geoFenceCallback = [GeoFenceClientCallback new];
    geoFenceCallback.vc = self;
    
    [backendless.geo
     startGeofenceMonitoring:geoFenceCallback
     response:^(id response) {
         NSLog(@"Geofence monitoring has been started: %@", response);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

// assign device's token to geopoint metadata.
// the token is received by registering device
// with Backendless for push notifications.
const NSString *deviceToken = @"iOS GeoFence";

//Start location monitoring for a specific geofence with a remote callback
-(void)startMonitoringSpesificGeofenceWithRemoteCallback {
    
    NSLog(@">>>> startMonitoringSpesificGeofenceWithRemoteCallback >>>>>");
    
    CLLocation *_location = [_locationTracker getLocation];
    GeoPoint *myLocation = [GeoPoint geoPoint:(GEO_POINT){.latitude=_location.coordinate.latitude, .longitude=_location.coordinate.longitude}];
    [myLocation metadata:@{@"deviceId":deviceToken}];
    
    [backendless.geo
     startGeofenceMonitoringGeoPoint:@"WorkRect"
     geoPoint:myLocation
     response:^(id response) {
         NSLog(@"Geofence monitoring has been started: %@", response);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

// Start location monitoring for all geofences with a remote callback
-(void)startMonitoringAllGeofencesWithRemoteCallback {
    
    NSLog(@">>>> startMonitoringAllGeofencesWithRemoteCallback >>>>>");
    
    CLLocation *_location = [_locationTracker getLocation];
    GeoPoint *myLocation = [GeoPoint geoPoint:(GEO_POINT){.latitude=_location.coordinate.latitude, .longitude=_location.coordinate.longitude}];
    [myLocation metadata:@{@"deviceId":deviceToken}];

    [backendless.geo
     startGeofenceMonitoringGeoPoint:myLocation
     response:^(id response) {
         NSLog(@"Geofence monitoring has been started: %@", response);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

// Stop location monitoring for a specific geofence
-(void)stopMonitoringSpesificGeofence {
    [backendless.geo stopGeofenceMonitoring:@"WorkRect"];
}

// Stop location monitoring for all geofences
-(void)stopMonitoringAllGeofences {
    [backendless.geo stopGeofenceMonitoring];
}

// Run the OnEnter Action
-(void)runOnEnterAction {
    [backendless.geo runOnEnterAction:@"WorkRect"];
}

// Run the OnStay Action
-(void)runOnStayAction {
    [backendless.geo runOnStayAction:@"WorkRect"];
}

// Run the OnExit Action
-(void)runOnExitAction {
    [backendless.geo runOnExitAction:@"WorkRect"];
}

// Retrieve Geopoints from a Geofence
-(void)retriveGeopointsFromGeofence {
    
    NSLog(@">>>> retriveGeopointsFromGeofence >>>>>");
    
#if 0
    @try {
        
        BackendlessCollection *points = [backendless.geo getFencePoints:@"WorkShape"];
        NSLog(@"Geofence points: %@", points);
    }
    @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
    }
#else
    
    [backendless.geo
     getFencePoints:@"WorkShape"
     response:^(BackendlessCollection *points) {
         NSLog(@"Geofence points: %@", points);
         BackendlessCollection *bc = [points getPage:0];
         NSLog(@"Geofence bc: %@", bc);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
#endif
}

@end
