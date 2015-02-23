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
#import "Infos.h"

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
@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @try {
        
        [backendless initAppFault];
        
        _locationManager = ((StartAppDelegate *)[[UIApplication sharedApplication] delegate]).locationManager;

#if 0 // loading default geopoints
        [self performSelector:@selector(invokeGeo) withObject:nil afterDelay:.2f];
#endif
        
#if 0 // samples: save & update the current position
        [self saveCurrentPosition];
        [self updateGeoPoint];
#endif
        
#if 0 // samples: delete geo point
        [self deleteGeoPoint];
#endif
        
#if 0 // samples: search by date
        [self searchByDateInCategory];
        [self searchByDateInRadius];
        [self searchByDateInRectangularArea];
#endif
       
#if 0 // samples: partial match search
        //[self partialMatchCreateGeoPoints];
        [self partialMatchSearchInCategory];
        [self partialMatchSearchInRadius];
        [self partialMatchSearchInRectangularArea];
        [self partialMatchSearchInWhereClause];
#endif
        
#if 0 // samples: Linking a data object with a geo point and vice versa
        [self linkingDataObjectWithGeoPoints];
        [self linkingGeoPointWithDataObject];
        [self linkingGeoPointWithSeveralDataObjects];
#endif
        
#if 0 // samples: clustering search
        //[self partialMatchCreateGeoPoints];
        [self clusteringSearchInCategory];
        [self clusteringSearchInRadius];
        [self clusteringSearchInRectangularArea];
#endif
        
#if 0 // sample: load geo point metadata
        [self loadingGeoPointMetadata];
        [self loadingGeoClusterMetadata];
#endif

#if 1 // sample: searching for data objects by distance
        [self searchingDataObjectByDistance];
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
        query.includeMeta = @YES;
        //query.whereClause = [NSString stringWithFormat:@"city = \'DAKAR\'"];
        //[query metadata:@{@"city":@"DAKAR"}];
        
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


#pragma mark -
#pragma mark Private Methods (Samples)

// samples: save & update the current position

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

-(void)deleteGeoPoint {
    
    @try {
        
        // create
        GeoPoint *point = [GeoPoint geoPoint:(GEO_POINT){.latitude=21.306944, .longitude=-157.858333}
                                   categories:@[@"City", @"Coffee"]
                                     metadata:@{@"Name":@"Starbucks", @"City":@"Honolulu", @"Parking":@YES}
                            ];
        point = [backendless.geoService savePoint:point];
        NSLog(@"deleteGeoPoint -> point: %@\n[id: %@]", point, point.objectId);

        // delete
        [backendless.geoService removePoint:point];
        NSLog(@"deleteGeoPoint -> point id: %@ has been deleted", point.objectId);
    }
    @catch (Fault *fault) {
        NSLog(@"deleteGeoPoint FAULT = %@ ", fault);
        return;
    }
}

// samples: search by date

-(void)searchByDateInCategory {
    
    @try {
        
        // create
        GeoPoint *point = [GeoPoint geoPoint:(GEO_POINT){.latitude=21.306944, .longitude=-157.858333}
                                  categories:@[@"Coffee"]
                                    metadata:@{@"Name":@"Starbucks", @"Parking":@YES, @"updated":@([[NSDate date] timeIntervalSince1970])}
                           ];
        point = [backendless.geoService savePoint:point];
        NSLog(@"searchByDateInCategory -> point: %@]", point);
        
        // date
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd.MM.yyyy 'at' HH:mm"];
        NSDate *updated = [dateFormatter dateFromString:@"17.01.2015 at 12:00"];
        
        // search
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithCategories:@[@"Coffee"]];
        query.whereClause = [NSString stringWithFormat:@"updated > %f", [updated timeIntervalSince1970]];
        query.includeMeta = @YES;
        BackendlessCollection *bc = [backendless.geoService getPoints:query];
        
        NSLog(@"searchByDateInCategory GETPOINTS: %@", bc);
    }
    
    @catch (Fault *fault) {
        NSLog(@"searchByDateInCategory FAULT = %@ ", fault);
        return;
    }
}

-(void)searchByDateInRadius {
    
    @try {
        
        // create
        GeoPoint *point = [GeoPoint geoPoint:(GEO_POINT){.latitude=21.306944, .longitude=-157.858333}
                                  categories:@[@"City", @"Coffee"]
                                    metadata:@{@"Name":@"Starbucks", @"City":@"Honolulu", @"Parking":@YES, @"updated":@([[NSDate date] timeIntervalSince1970])}
                           ];
        point = [backendless.geoService savePoint:point];
        NSLog(@"searchByDateInRadius -> point: %@]", point);
        
        // date
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd.MM.yyyy 'at' HH:mm"];
        NSDate *updated = [dateFormatter dateFromString:@"17.01.2015 at 12:00"];

        // search
        GEO_POINT center = (GEO_POINT){.latitude=21.30, .longitude=-157.85};
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithPoint:center radius:50 units:KILOMETERS categories:@[@"City"]];
        query.whereClause = [NSString stringWithFormat:@"updated > %f", [updated timeIntervalSince1970]];
        query.includeMeta = @YES;
        BackendlessCollection *bc = [backendless.geoService getPoints:query];
        
        NSLog(@"searchByDateInRadius GETPOINTS: %@", bc);
    }
    
    @catch (Fault *fault) {
        NSLog(@"searchByDateInRadius FAULT = %@ ", fault);
        return;
    }
}

-(void)searchByDateInRectangularArea {
    
    @try {
        
        // date
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd.MM.yyyy 'at' HH:mm"];
        NSDate *opened = [dateFormatter dateFromString:@"17.01.2015 at 07:00"];
        NSDate *closed = [dateFormatter dateFromString:@"17.01.2015 at 23:00"];

        // create
        GeoPoint *point = [GeoPoint geoPoint:(GEO_POINT){.latitude=21.306944, .longitude=-157.858333}
                                  categories:@[@"Coffee"]
                                    metadata:@{@"Name":@"Starbucks", @"opened":@([opened timeIntervalSince1970]), @"closed":@([closed timeIntervalSince1970])}
                           ];
        point = [backendless.geoService savePoint:point];
        NSLog(@"searchByDateInRectangularArea -> point: %@]", point);

        // search
        GEO_POINT center = (GEO_POINT){.latitude=21.306944, .longitude=-157.858333};
        GEO_RECT rect = [backendless.geoService geoRectangle:center length:0.5 widht:0.5];
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithRect:rect.nordWest southEast:rect.southEast categories:@[@"Coffee"]];
        double now = [[dateFormatter dateFromString:@"17.01.2015 at 16:30"] timeIntervalSince1970];
        query.whereClause = [NSString stringWithFormat:@"opened < %@ AND closed > %@", @(now), @(now)];
        query.includeMeta = @YES;
        BackendlessCollection *bc = [backendless.geoService getPoints:query];
        
        NSLog(@"searchByDateInRectangularArea GETPOINTS: %@", bc);
    }
    
    @catch (Fault *fault) {
        NSLog(@"searchByDateInRectangularArea FAULT = %@ ", fault);
        return;
    }
}

// samples: partial match search

-(void)partialMatchCreateGeoPoints {
    
    @try {
        
        GeoPoint *point1 = [GeoPoint geoPoint:(GEO_POINT){.latitude=47.606209, .longitude=-122.332071}
                                   categories:@[@"City", @"Coffee"]
                                     metadata:@{@"Name":@"Starbucks", @"City":@"Seattle", @"Parking":@YES}
                            ];
        point1 = [backendless.geoService savePoint:point1];
        NSLog(@"partialMatchCreateGeoPoints -> point1: %@", point1);
        
        GeoPoint *point2 = [GeoPoint geoPoint:(GEO_POINT){.latitude=34.052234, .longitude=-118.243685}
                                   categories:@[@"City", @"Restaurant"]
                                     metadata:@{@"Name":@"All Stars", @"City":@"LA", @"Parking":@YES}
                            ];
        point2 = [backendless.geoService savePoint:point2];
        NSLog(@"partialMatchCreateGeoPoints -> point2: %@", point2);
        
        GeoPoint *point3 = [GeoPoint geoPoint:(GEO_POINT){.latitude=21.306944, .longitude=-157.858333}
                                   categories:@[@"City", @"Coffee"]
                                     metadata:@{@"Name":@"McCoffee", @"City":@"Honolulu", @"Parking":@NO}
                            ];
        point3 = [backendless.geoService savePoint:point3];
        NSLog(@"partialMatchCreateGeoPoints -> point3: %@", point3);
        
        GeoPoint *point4 = [GeoPoint geoPoint:(GEO_POINT){.latitude=21.306944, .longitude=-157.858333}
                                   categories:@[@"City", @"Restaurant"]
                                     metadata:@{@"Name":@"Kamehaha", @"City":@"Honolulu", @"Parking":@YES}
                            ];
        point4 = [backendless.geoService savePoint:point4];
        NSLog(@"partialMatchCreateGeoPoints -> point4: %@", point4);
    }
    
    @catch (Fault *fault) {
        NSLog(@"partialMatchCreateGeoPoints FAULT = %@ ", fault);
        return;
    }
}

-(void)partialMatchSearchInCategory {
    
    @try {
        
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithCategories:@[@"Restaurant"]];
        query.relativeFindMetadata = @{@"City":@"LA", @"Parking":@YES};
        query.relativeFindPercentThreshold = @30.0;
        query.includeMeta = @YES;
        BackendlessCollection *bc = [backendless.geoService relativeFind:query];
        
        NSLog(@"partialMatchSearchInCategory GETPOINTS: %@", bc);
    }
    
    @catch (Fault *fault) {
        NSLog(@"partialMatchSearchInCategory FAULT = %@ ", fault);
        return;
    }
}

-(void)partialMatchSearchInRadius {
    
    @try {
        
        GEO_POINT center = (GEO_POINT){.latitude=21.306944, .longitude=-157.858333};
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithPoint:center radius:50 units:KILOMETERS categories:@[@"City"]];
        query.relativeFindMetadata = @{@"Name":@"Ra Harbor", @"City":@"Honolulu", @"Parking":@NO};
        query.relativeFindPercentThreshold = @30.0;
        query.includeMeta = @YES;
        BackendlessCollection *bc = [backendless.geoService relativeFind:query];
        
        NSLog(@"partialMatchSearchInRadius GETPOINTS: %@", bc);
    }
    
    @catch (Fault *fault) {
        NSLog(@"partialMatchSearchInRadius FAULT = %@ ", fault);
        return;
    }
}

-(void)partialMatchSearchInRectangularArea {
    
    @try {
        
        GEO_POINT center = (GEO_POINT){.latitude=21.306944, .longitude=-157.858333};
        GEO_RECT rect = [backendless.geoService geoRectangle:center length:0.5 widht:0.5];
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithRect:rect.nordWest southEast:rect.southEast categories:@[@"City"]];
        query.relativeFindMetadata = @{@"Name":@"Ra Harbor", @"City":@"Honolulu", @"Parking":@NO};
        query.relativeFindPercentThreshold = @30.0;
        query.includeMeta = @YES;
        BackendlessCollection *bc = [backendless.geoService relativeFind:query];
        
        NSLog(@"partialMatchSearchInRectangularArea GETPOINTS: %@", bc);
    }
    
    @catch (Fault *fault) {
        NSLog(@"partialMatchSearchInRectangularArea FAULT = %@ ", fault);
        return;
    }
}

-(void)partialMatchSearchInWhereClause {
    
    @try {
        
        GEO_POINT center = (GEO_POINT){.latitude=21.306944, .longitude=-157.858333};
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithPoint:center radius:50 units:KILOMETERS categories:@[@"City"]];
        query.whereClause = @"categories = \'Coffee\'";
        query.relativeFindMetadata = @{@"Name":@"Ra Harbor", @"City":@"Honolulu", @"Parking":@YES};
        query.relativeFindPercentThreshold = @30.0;
        query.includeMeta = @YES;
        BackendlessCollection *bc = [backendless.geoService relativeFind:query];
        
        NSLog(@"partialMatchSearchInWhereClause GETPOINTS: %@", bc);
    }
    
    @catch (Fault *fault) {
        NSLog(@"partialMatchSearchInWhereClause FAULT = %@ ", fault);
        return;
    }
}

// samples: Linking a data object with a geo point and vice versa - http://bugs.backendless.com/browse/BKNDLSS-7826

-(void)linkingDataObjectWithGeoPoints {
    
    @try {
        
        TaxiCab *taxi = [TaxiCab new];
        taxi.carMake = @"Toyota";
        taxi.carModel = @"Prius";
        
        // one-to-one relation between a data object and a geo point
        taxi.location = [GeoPoint geoPoint:(GEO_POINT){.latitude=40.7148, .longitude=-74.0059}
                                  categories:@[@"taxi"]
                                    metadata:@{@"service-area":@"NYC"}
                           ];
        
        // one-to-many relation between a data object and geo points
        GeoPoint *droppOff1 = [GeoPoint geoPoint:(GEO_POINT){.latitude=40.757977, .longitude=-73.98557}
                                     categories:@[@"DropOffs"]
                                       metadata:@{@"name":@"Times Square"}
                              ];
        GeoPoint *droppOff2 = [GeoPoint geoPoint:(GEO_POINT){.latitude=40.748379, .longitude=-73.985565}
                                      categories:@[@"DropOffs"]
                                        metadata:@{@"name":@"Empire State Building"}
                               ];
        taxi.previousDropOffs = [NSMutableArray arrayWithArray:@[droppOff1, droppOff2]];
        
        taxi = [backendless.persistenceService save:taxi];
        NSLog(@"linkingDataObjectWithGeoPoints: %@", taxi);
    }
    
    @catch (Fault *fault) {
        NSLog(@"linkingDataObjectWithGeoPoints FAULT = %@ ", fault);
    }
}

-(void)linkingGeoPointWithDataObject {
    
    @try {
        
        TaxiCab *cab = [TaxiCab new];
        cab.carMake = @"Ford";
        cab.carModel = @"Crown Victoria";
        
        GeoPoint *pickupLocation = [GeoPoint geoPoint:(GEO_POINT){.latitude=40.750549, .longitude=-73.994232}
                                  categories:@[@"Pickups"]
                                    metadata:@{@"TaxiCab":cab}
                           ];
        
        pickupLocation = [backendless.geoService savePoint:pickupLocation];
        NSLog(@"linkingGeoPointWithDataObject: %@", pickupLocation);
    }
    
    @catch (Fault *fault) {
        NSLog(@"linkingGeoPointWithDataObject FAULT = %@ ", fault);
    }
}

-(void)linkingGeoPointWithSeveralDataObjects {
    
    @try {

        TaxiCab *cab1 = [TaxiCab new];
        cab1.carMake = @"Ford";
        cab1.carModel = @"Crown Victoria";
        
        TaxiCab *cab2 = [TaxiCab new];
        cab1.carMake = @"Toyota";
        cab1.carModel = @"Prius";
        
        GeoPoint *pickupLocation = [GeoPoint geoPoint:(GEO_POINT){.latitude=40.750549, .longitude=-73.994232}
                                           categories:@[@"Pickups"]
                                             metadata:@{@"AvailableCabs":@[cab1, cab2]}
                                    ];
        
        pickupLocation = [backendless.geoService savePoint:pickupLocation];
        NSLog(@"linkingGeoPointWithSeveralDataObjectst: %@", pickupLocation);
    }
    
    @catch (Fault *fault) {
        NSLog(@"linkingGeoPointWithSeveralDataObjects FAULT = %@ ", fault);
    }
}

// samples : geo clustering - http://bugs.backendless.com/browse/BKNDLSS-7866

-(void)clusteringSearchInCategory {
    
    @try {
        
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithCategories:@[@"City"]];
        [query setClusteringParams:-157.9 eastLongitude:-157.8 mapWidth:480];
        BackendlessCollection *bc = [backendless.geoService getPoints:query];
        
        NSLog(@"clusteringSearchInCategory GETPOINTS: %@", bc);
    }
    
    @catch (Fault *fault) {
        NSLog(@"clusteringSearchInCategory FAULT = %@ ", fault);
        return;
    }
}

-(void)clusteringSearchInRadius {
    
    @try {
        
        GEO_POINT center = (GEO_POINT){.latitude=21.306944, .longitude=-157.858333};
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithPoint:center radius:50 units:KILOMETERS categories:@[@"City"]];
        [query setClusteringParams:-157.9 eastLongitude:-157.8 mapWidth:480];
        BackendlessCollection *bc = [backendless.geoService getPoints:query];
        
        NSLog(@"clusteringSearchInRadius GETPOINTS: %@", bc);
    }
    
    @catch (Fault *fault) {
        NSLog(@"clusteringSearchInRadius FAULT = %@ ", fault);
        return;
    }
}

-(void)clusteringSearchInRectangularArea {
    
    @try {
        
        GEO_POINT center = (GEO_POINT){.latitude=21.306944, .longitude=-157.858333};
        GEO_RECT rect = [backendless.geoService geoRectangle:center length:0.5 widht:0.5];
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithRect:rect.nordWest southEast:rect.southEast categories:@[@"City"]];
        [query setClusteringParams:-157.9 eastLongitude:-157.8 mapWidth:480];
        BackendlessCollection *bc = [backendless.geoService getPoints:query];
        
        NSLog(@"clusteringSearchInRectangularArea GETPOINTS: %@", bc);
    }
    
    @catch (Fault *fault) {
        NSLog(@"clusteringSearchInRectangularArea FAULT = %@ ", fault);
        return;
    }
}

// sample: load geo point metadata - http://bugs.backendless.com/browse/BKNDLSS-8098

-(void)loadingGeoPointMetadata {
    
    @try {
        
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithCategories:@[@"City"]];
        BackendlessCollection *bc = [backendless.geoService getPoints:query];
        
        for (GeoPoint *point in bc.data) {
            GeoPoint * geoPoint = [backendless.geoService loadMetadata:point];
            NSLog(@"%@", geoPoint);
        }
    }
    
    @catch (Fault *fault) {
        NSLog(@"loadingGeoPointMetadata FAULT = %@ ", fault);
        return;
    }
}


-(void)loadingGeoClusterMetadata {
    
    @try {
        
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithCategories:@[@"City"]];
        [query setClusteringParams:-157.9 eastLongitude:-157.8 mapWidth:480];
        BackendlessCollection *bc = [backendless.geoService getPoints:query];
        
        for (GeoPoint *point in bc.data) {
            GeoPoint * geoPoint = [backendless.geoService loadMetadata:point];
            NSLog(@"%@", geoPoint);
        }
    }
    
    @catch (Fault *fault) {
        NSLog(@"oadingGeoClusterMetadata FAULT = %@ ", fault);
        return;
    }
}

// sample: searching for data objects by distance - http://bugs.backendless.com/browse/BKNDLSS-8020

-(void)searchingDataObjectByDistance {
    
    @try {
        
        Friend *bob = [Friend new];
        bob.name = @"Bob";
        bob.phoneNumber = @"512-555-1212";
        bob.coordinates = [GeoPoint geoPoint:(GEO_POINT){.latitude=30.26715, .longitude=-97.74306}
                                  categories:@[@"Home"]
                                    metadata:@{@"description":@"Bob's home"}
                           ];
        [backendless.persistenceService save:bob];
        
        Friend *jane = [Friend new];
        jane.name = @"Jane";
        jane.phoneNumber = @"281-555-1212";
        jane.coordinates = [GeoPoint geoPoint:(GEO_POINT){.latitude=29.76328, .longitude=-95.36327}
                                   categories:@[@"Home"]
                                     metadata:@{@"description":@"Jane's home"}
                            ];
        [backendless.persistenceService save:jane];
        
        Friend *fred = [Friend new];
        fred.name = @"Fred";
        fred.phoneNumber = @"210-555-1212";
        fred.coordinates = [GeoPoint geoPoint:(GEO_POINT){.latitude=29.42412, .longitude=-98.49363}
                                   categories:@[@"Home"]
                                     metadata:@{@"description":@"Fred's home"}
                            ];
        [backendless.persistenceService save:fred];
        
        QueryOptions *queryOptions = [QueryOptions query];
        queryOptions.relationsDepth = @1;
        
        BackendlessDataQuery *dataQuery = [BackendlessDataQuery query];
        dataQuery.queryOptions = queryOptions;
        dataQuery.whereClause = @"distance( 30.26715, -97.74306, Coordinates.latitude, Coordinates.longitude ) < mi(200)";
        
        BackendlessCollection *friends = [[backendless.persistenceService of:[Friend class]] find:dataQuery];
        for (Friend *friend in friends.data) {
            NSLog(@"%@ lives at %@, %@ tagged as '%@'", friend.name, friend.coordinates.latitude, friend.coordinates.longitude, friend.coordinates.metadata[@"description"]);
            
        }
    }
    
    @catch (Fault *fault) {
        NSLog(@"searchingDataObjectByDistance FAULT = %@ ", fault);
    } 
} 

@end
