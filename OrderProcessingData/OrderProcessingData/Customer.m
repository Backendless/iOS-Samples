#import "Customer.h"
                    
@implementation Customer                    

-(void)addFriend:(Customer *)user {
    
    if (!self.friends)
        self.friends = [NSMutableArray new];
    
    [self.friends addObject:user];
}

-(void)deleteFriend:(Customer *)user {
    
    [self.friends removeObject:user];
    
    if (!self.friends.count) {
        self.friends = nil;
    }
}

-(NSString *)description {
    return [NSString stringWithFormat:@"<Customer {%@}> '%@':{%@} -> %@ [%@]", self.objectId, self.name, self.ownerId, self.user, self.friends];
}

@end