//
//  StartViewController.m
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

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "StartViewController.h"
#import "StartAppDelegate.h"
#import "Backendless.h"

#define COORDINATE_STR @"lat: %g  long: %g"

@interface StartViewController () {
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _currentLocation;
    NSArray *_list;
    GeoPoint *_geoPoint;
}

-(void)showAlert:(NSString *)message;
-(void)getLocation;
-(NSArray *)loadGeoPoints;
-(void)invokeGeo;
-(void)saveCurrentPosition;
-(void)updateGeoPoint;
@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @try {
        
        [backendless initAppFault];
        
        _locationManager = ((StartAppDelegate *)[[UIApplication sharedApplication] delegate]).locationManager;
#if 0
        [self saveCurrentPosition];
        [self updateGeoPoint];
#else
        [self performSelector:@selector(invokeGeo) withObject:nil afterDelay:.2f];
#endif
    }
    @catch (Fault *fault) {
        [self showAlert:fault.message];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark -
#pragma mark Private Methods

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(void)getLocation {
    
    _currentLocation = _locationManager.location.coordinate;
    self.coordinatesLabel.text = [NSString stringWithFormat:COORDINATE_STR, _currentLocation.latitude, _currentLocation.longitude];

}

-(NSArray *)loadGeoPoints {
    
    if (!_locationManager)
        return nil;
    
    @try {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [self getLocation];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_currentLocation, self.radiusSlider.value*1000, self.radiusSlider.value*1000);
        
        GEO_POINT center;
        center.latitude = region.center.latitude;
        center.longitude = region.center.longitude;
        GEO_RECT rect = [backendless.geoService geoRectangle:center length:2*region.span.longitudeDelta widht:2*region.span.latitudeDelta];
        
        NSLog(@"StartViewController -> loadGeoPoints: center = {%g, %g}, NW = {%g, %g}, SE = {%g, %g}", center.latitude, center.longitude, rect.nordWest.latitude, rect.nordWest.longitude, rect.southEast.latitude, rect.southEast.longitude);
#if 1 // by rectangle
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithRect:rect.nordWest southEast:rect.southEast categories:@[@"geoservice_sample"]];
#else // by radius
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithPoint:center radius:self.radiusSlider.value units:KILOMETERS categories:@[@"geoservice_sample"]];
#endif
        [query includeMeta:YES];
//        query.whereClause = [NSString stringWithFormat:@"\'city\' = \'TBILISI\'"];
//        query.metadata = [NSMutableDictionary dictionary];
//        query.metadata = [NSMutableDictionary dictionaryWithDictionary:@{@"city":@"TBILISI"}];
        
        NSLog(@"StartViewController -> loadGeoPoints: query = %@", query);
        
        BackendlessCollection *bc = [backendless.geoService getPoints:query];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"StartViewController -> loadGeoPoints: bc = %@", bc);

        if (!bc || !bc.data) {
            return nil;
        }
        
        return bc.data;
    }
    
    @catch (Fault *fault) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"StartViewController -> loadGeoPoints: FAULT = %@ <%@>", fault.message, fault.detail);
        
        [self showAlert:fault.message];
        
        return nil;
    }
}

-(void)invokeGeo {
    
    NSLog(@"StartViewController -> invokeGeo");
    
    _list = [self loadGeoPoints];
    [self.citiesTableView reloadData];
}

-(void)saveCurrentPosition {
    
    if (!_locationManager)
        return;
    
    @try {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [self getLocation];
        
        GEO_POINT center;
        center.latitude = _currentLocation.latitude;
        center.longitude = _currentLocation.longitude;
        
#if 1
        GeoPoint *currentPoint = [GeoPoint geoPoint:(GEO_POINT){.latitude=12.9, .longitude=26.3}
                                         categories:@[@"Test5"]
                                           metadata:@{@"enterpriceName":@"House0", @"enterpriseType":@"0"}
                                  ];
#else // FAULT 7007 for Unicode in metadata
        GeoPoint *currentPoint = [GeoPoint geoPoint:center
                                         categories:@[@"fixedcurrent1"]
                                           metadata:@{@"enterpriceName":[NSString stringWithUTF8String:"Twins house \xf0\x9f\x91\xad"], @"enterpriseType":@"0", @"foursquareCategoryID":@"4bf58dd8d48988d103941735", @"foursquareCategoryName":@"Проём подъезда этажа"}];
#endif
        NSLog(@"StartViewController -> saveCurrentPosition (NEW): %@\n%@\n", currentPoint, [Types propertyDictionary:currentPoint]);
        
        GeoPoint *saved = [backendless.geoService savePoint:currentPoint];
        
        NSLog(@"StartViewController -> saveCurrentPosition (SAVED): %@\n%@\n", saved, [Types propertyDictionary:saved]);
        
        _geoPoint = saved;
#if 0
        currentPoint.objectId = saved.objectId;
        [currentPoint metadata:@{@"username":@"375297777777", @"objectId":saved.objectId}];
        [currentPoint setValue:currentPoint.metadata forKey:@"objectMetadata"]; // !!!!! ??????
        
        NSLog(@"\nupdateGeoPoint UPDATING: %@\n%@\n", currentPoint, [Types propertyDictionary:currentPoint]);
        
        GeoPoint *updated = [backendless.geoService savePoint:currentPoint];
        
        NSLog(@"\nupdateGeoPoint UPDATED: %@\n%@\n", updated, [Types propertyDictionary:updated]);
#endif

        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    @catch (Fault *fault) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"StartViewController -> saveCurrentPosition: FAULT = %@ ", fault);
        
        [self showAlert:fault.message];
        
        return;
    }
    
}

-(void)updateGeoPoint {
    
    @try {
        
#if 0
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithCategories:@[@"Test5"]];
        BackendlessCollection *bc = [backendless.geoService getPoints:query];
        
        NSLog(@"\nupdateGeoPoint GETPOINTS: %@", bc);
        
        if (!bc.data.count)
            return;
        
        GeoPoint *updating = bc.data[0];
        [updating latitude:50.1];
        [updating longitude:30.4];
#else
        GEO_POINT point;
        point.latitude = 53.77;
        point.longitude = 28.77;
        GeoPoint *updating = [[GeoPoint alloc] initWithPoint:point categories:@[@"Test5"]];
        updating.objectId = _geoPoint.objectId;
        [updating metadata:@{@"username":@"375297777777", @"objectId":updating.objectId}];
        //[updating setValue:updating.metadata forKey:@"objectMetadata"]; // !!!!! ??????
        
        NSLog(@"\nupdateGeoPoint UPDATING: %@\n%@\n", updating, [Types propertyDictionary:updating]);

#endif
        
        GeoPoint *updated = [backendless.geoService savePoint:updating];
        
        NSLog(@"\nupdateGeoPoint UPDATED: %@\n%@\n", updated, [Types propertyDictionary:updated]);
    }
    
    @catch (Fault *fault) {
        NSLog(@"\nupdateGeoPoint FAULT: %@\n%@\n", fault, [Types propertyDictionary:fault]);
    }
}

#pragma mark - IBAction

-(IBAction)changeRadius:(id)sender {
    
    UISlider *slider = sender;
    
    NSLog(@"StartViewController -> changeRadius: %g", slider.value);
    
    self.radiusLabel.text = [NSString stringWithFormat:@"%g", slider.value];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(invokeGeo) withObject:nil afterDelay:1.0f];
}

#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list?_list.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CitiesTableCell" forIndexPath:indexPath];
    
    if (_list) {
        
        id item = [_list objectAtIndex:indexPath.row];
        if ([item isMemberOfClass:[GeoPoint class]]) {
            
            GeoPoint *gp = item;
            cell.textLabel.text = [gp.metadata valueForKey:@"city"];
            cell.detailTextLabel.text = [NSString stringWithFormat:COORDINATE_STR, [gp.latitude doubleValue], [gp.longitude doubleValue]];
        }
    }
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"StartViewController -> tableView:didSelectRowAtIndexPath: %d", indexPath.row);
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"StartViewController -> tableView:diDeselectRowAtIndexPath: %d", indexPath.row);
}

@end
