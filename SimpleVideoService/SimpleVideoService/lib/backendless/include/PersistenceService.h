//
//  PersistenceService.h
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

#define PERSIST_OBJECT_ID @"objectId"
#define PERSIST_CLASS(CLASS) [backendless.persistenceService of:[CLASS class]]
static NSString *LOAD_ALL_RELATIONS = @"*";
@class BackendlessCollection, BackendlessQuery, BackendlessDataQuery;
@protocol IResponder, IDataStore;


@interface PersistenceService : NSObject

// sync methods
-(NSDictionary *)save:(NSString *)entityName entity:(NSDictionary *)entity;
-(NSDictionary *)update:(NSString *)entityName entity:(NSDictionary *)entity sid:(NSString *)sid;
-(id)save:(id)entity;
-(id)create:(id)entity;
-(id)update:(id)entity; 
-(NSNumber *)remove:(Class)entity sid:(NSString *)sid; 
-(id)findById:(NSString *)entityName sid:(NSString *)sid; 
-(id)findByClassId:(Class)entity sid:(NSString *)sid; 
-(BackendlessCollection *)find:(Class)entity dataQuery:(BackendlessDataQuery *)dataQuery;
-(id)first:(Class)entity;
-(id)last:(Class)entity;
-(NSArray *)describe:(NSString *)classCanonicalName;
-(id)findById:(NSString *)entityName sid:(NSString *)sid relations:(NSArray *)relations;//
-(void)load:(id)object relations:(NSArray *)relations;
// async methods
-(void)save:(NSString *)entityName entity:(NSDictionary *)entity responder:(id <IResponder>)responder;
-(void)update:(NSString *)entityName entity:(NSDictionary *)entity sid:(NSString *)sid responder:(id <IResponder>)responder;
-(void)save:(id)entity responder:(id <IResponder>)responder;
-(void)create:(id)entity responder:(id <IResponder>)responder;
-(void)update:(id)entity responder:(id <IResponder>)responder; 
-(void)remove:(Class)entity sid:(NSString *)sid responder:(id <IResponder>)responder; 
-(void)findById:(NSString *)entityName sid:(NSString *)sid responder:(id <IResponder>)responder; 
-(void)findByClassId:(Class)entity sid:(NSString *)sid responder:(id <IResponder>)responder; 
-(void)find:(Class)entity dataQuery:(BackendlessDataQuery *)dataQuery responder:(id <IResponder>)responder;
-(void)first:(Class)entity responder:(id <IResponder>)responder;
-(void)last:(Class)entity responder:(id <IResponder>)responder;
-(void)describe:(NSString *)classCanonicalName responder:(id <IResponder>)responder;
-(void)findById:(NSString *)entityName sid:(NSString *)sid relations:(NSArray *)relations responder:(id <IResponder>)responder;
-(void)load:(id)object relations:(NSArray *)relations responder:(id <IResponder>)responder;
//
-(id <IDataStore>)of:(Class)entityClass;

@end
