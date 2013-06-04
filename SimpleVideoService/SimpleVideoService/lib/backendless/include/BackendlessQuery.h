//
//  BackendlessQuery.h
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

@interface BackendlessQuery : NSObject {
    
    NSNumber    *pageSize;
    NSNumber    *offset;
    NSArray     *sortBy;
    NSArray     *related;

}
@property (strong, nonatomic) NSNumber *pageSize;
@property (strong, nonatomic) NSNumber *offset;
@property (strong, nonatomic) NSArray *sortBy;
@property (strong, nonatomic) NSArray *related;

-(id)initWithPageSize:(int)_pageSize offset:(int)_offset;
+(BackendlessQuery *)query;
+(BackendlessQuery *)query:(int)_pageSize offset:(int)_offset;

-(BackendlessQuery *)pageSize:(int)_pageSize;
-(BackendlessQuery *)offset:(int)_offset;
-(BackendlessQuery *)sortBy:(NSArray *)_sortBy;
-(BackendlessQuery *)related:(NSArray *)_related;
-(NSDictionary *)getQuery;

@end
