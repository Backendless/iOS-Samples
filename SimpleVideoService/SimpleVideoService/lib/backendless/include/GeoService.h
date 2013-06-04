//
//  GeoService.h
//  backendlessAPI
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

#import <Foundation/Foundation.h>
#import "GeoPoint.h"

#define DEFAULT_CATEGORY_NAME @"Default"

typedef struct {
    GEO_POINT nordWest;
    GEO_POINT southEast;
} GEO_RECT;

@class GeoPoint, BackendlessCollection, BackendlessGeoQuery, GeoCategory;
@protocol IResponder;

@interface GeoService : NSObject

// sync methods
-(GeoCategory *)addCategory:(NSString *)categoryName;
-(id)deleteCategory:(NSString *)categoryName;
-(GeoPoint *)savePoint:(GeoPoint *)geoPoint;
-(NSArray *)getCategories;
-(BackendlessCollection *)getPoints:(BackendlessGeoQuery *)query;
-(BackendlessCollection *)getPoints:(BackendlessGeoQuery *)query Metadata:(NSDictionary *)metadata Matches:(NSNumber *)matches;

// async methods
-(void)addCategory:(NSString *)categoryName responder:(id <IResponder>)responder;
-(void)deleteCategory:(NSString *)categoryName responder:(id <IResponder>)responder;
-(void)savePoint:(GeoPoint *)geoPoint responder:(id <IResponder>)responder;
-(void)getCategories:(id <IResponder>)responder;
-(void)getPoints:(BackendlessGeoQuery *)query responder:(id <IResponder>)responder;
-(void)getPoints:(BackendlessGeoQuery *)query Metadata:(NSDictionary *)metadata Matches:(NSNumber *)matches responder:(id <IResponder>)responder;
-(GEO_RECT)geoRectangle:(GEO_POINT)center length:(double)length widht:(double)widht;
@end
