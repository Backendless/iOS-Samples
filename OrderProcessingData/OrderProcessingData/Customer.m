#import "Customer.h"
                    
@implementation Customer                    

-(void)addFriend:(Customer *)user {
    if (!self.friends)
        self.friends = [NSMutableArray new];
    [self.friends addObject:user];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"<Customer {%@}> '%@':{%@} -> %@ [%@]", self.objectId, self.name, self.ownerId, self.user, self.friends];
}

@end