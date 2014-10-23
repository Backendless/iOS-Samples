#import "Order.h"
#import "OrderItem.h"
#import "Backendless.h"

@implementation Order

-(void)addOrderItem:(OrderItem *)item {
    
    if (!self.orderItems)
        self.orderItems = [NSMutableArray array];
    
    [self.orderItems addObject:item];
}

-(void)removeOrderItem:(OrderItem *)item {
    
    [self.orderItems removeObject:item];
    
    if (!self.orderItems.count) {
        self.orderItems = nil;
    }
}

-(NSMutableArray *)loadOrderItems {
    
    if (!self.orderItems)
        [backendless.persistenceService load:self relations:@[@"orderItems"]];
    
    return self.orderItems;
}

-(void)freeOrderItems {
    
    if (!self.orderItems)
        return;
    
    [self.orderItems removeAllObjects];
    self.orderItems = nil;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"<Order {%@}> '%@':'%@' -> %@ [%@]", self.objectId, self.name, self.className, self.customer, self.orderItems];
}

@end