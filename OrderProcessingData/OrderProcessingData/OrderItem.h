#import <Foundation/Foundation.h>

@interface OrderItem :  NSObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *unitPrice;
@property (nonatomic, strong) NSNumber *quantity;
@end