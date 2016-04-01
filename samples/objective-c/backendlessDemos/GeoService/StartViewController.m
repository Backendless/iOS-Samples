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
#define FIND_BY_RECTANGLE 1

@interface StartViewController () {
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _currentLocation;
    NSArray *_list;
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
        
        [self performSelector:@selector(invokeGeo) withObject:nil afterDelay:.2f];
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
#if 0
-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#endif

#pragma mark -
#pragma mark Private Methods

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(void)getLocation {
    
    _currentLocation = _locationManager.location.coordinate;
    self.coordinatesLabel.text = [NSString stringWithFormat:COORDINATE_STR, _currentLocation.latitude, _currentLocation.longitude];
    NSLog(@"CURRENT LOCATION: %@", self.coordinatesLabel.text);

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

#if FIND_BY_RECTANGLE // by rectangle
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithRect:rect.nordWest southEast:rect.southEast categories:@[@"geoservice_sample"]];
#else // by radius
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithPoint:center radius:self.radiusSlider.value units:KILOMETERS categories:@[@"geoservice_sample"]];
#endif
        
        query.includeMeta = @YES;
        
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

@end
