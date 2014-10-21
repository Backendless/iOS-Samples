#import "OrderItem.h"

@implementation OrderItem                    

-(NSString *)description {
    return [NSString stringWithFormat:@"<OrderItem {%@}> '%@':{%@} -> %@:%@", self.objectId, self.itemName, self.ownerId, self.quantity, self.unitPrice];
}

@end