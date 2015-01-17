//
//  Document.m
//  GeoServiceMac
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2013 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

#import "Document.h"
#import "Backendless.h"
#import <CoreLocation/CoreLocation.h>

// *** YOU SHOULD SET THE FOLLOWING VALUES FROM YOUR BACKENDLESS APPLICATION ***
// *** COPY/PASTE APP ID and SECRET KET FROM BACKENDLESS CONSOLE (use the Manage > App Settings screen) ***

static NSString *APP_ID = @"";
static NSString *SECRET_KEY = @"";
static NSString *VERSION_NUM = @"v1";

@interface Document()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    NSArray *_data;
    float r;
}
@end

@implementation Document

- (id)init
{
    self = [super init];
    if (self) {
        r = 1.0;
        // Add your subclass-specific initialization here.
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    @try {
        [backendless initAppFault];
    }
    @catch (Fault *fault) {
        [[NSAlert alertWithMessageText:fault.message defaultButton:@"Done" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", fault.detail] runModal];
    }
    [_locationManager startUpdatingLocation];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

#pragma mark - private methosd

-(void)loadGeoPointsForLocation:(CLLocationCoordinate2D)location radius:(float)radius {
        
    GEO_POINT center;
    center.latitude = location.latitude;
    center.longitude = location.longitude;
    GEO_RECT rect = [backendless.geoService geoRectangle:center length:radius widht:radius];
    BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithRect:rect.nordWest southEast:rect.southEast categories:@[@"geoservice_sample"]];
    query.metadata = [NSMutableDictionary dictionary];
    [backendless.geoService getPoints:query response:^(BackendlessCollection *collection) {
        _data = collection.data;
        [_tableView reloadData];
    } error:^(Fault *error) {
        NSLog(@"%@", error.detail);
    }];
        
}

#pragma mark - Table View

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    GeoPoint *point = [_data objectAtIndex:rowIndex];
    if ([aTableColumn.identifier isEqualToString:@"latitude"]) {
        return point.latitude;
    }
    else if ([aTableColumn.identifier isEqualToString:@"longitude"])
    {
        return point.longitude;
    }
    else 
        return [point.categories componentsJoinedByString:@", "];
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return _data.count;
}

#pragma mark - location manager delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    [self loadGeoPointsForLocation:newLocation.coordinate radius:r];
}

-(void)changeRadius:(NSSlider *)sender
{
    r = sender.floatValue;
    [self loadGeoPointsForLocation:_locationManager.location.coordinate radius:r];
}
@end
