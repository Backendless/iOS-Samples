#import <Foundation/Foundation.h>

@class Customer, OrderItem;

@interface Order :  NSObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSMutableArray *orderItems;
@property (nonatomic, strong) Customer *customer;

-(void)addOrderItem:(OrderItem *)item;
-(void)removeOrderItem:(OrderItem *)item;
-(NSMutableArray *)loadOrderItems;
-(void)freeOrderItems;
@end