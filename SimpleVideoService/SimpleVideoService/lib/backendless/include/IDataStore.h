//
//  IDataStore.h
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

@class BackendlessCollection, BackendlessQuery, BackendlessDataQuery;
@protocol IResponder;

@protocol IDataStore <NSObject>

// sync methods

-(id)save:(id)entity;
-(id)findID:(NSString *)objectID;
-(NSNumber *)remove:(id)entity;
-(NSNumber *)removeID:(NSString *)objectID;
-(BackendlessCollection *)find:(BackendlessDataQuery *)dataQuery;
-(id)findFirst;
-(id)findLast;

// async methods

-(void)save:(id)entity responder:(id <IResponder>)responder;
-(void)findID:(NSString *)objectID responder:(id <IResponder>)responder;
-(void)remove:(id)entity responder:(id <IResponder>)responder;
-(void)removeID:(NSString *)objectID responder:(id <IResponder>)responder;
-(void)find:(BackendlessDataQuery *)dataQuery responder:(id <IResponder>)responder;
-(void)findFirst:(id <IResponder>)responder;
-(void)findLast:(id <IResponder>)responder;

@end
