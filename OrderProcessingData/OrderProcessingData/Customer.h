#import <Foundation/Foundation.h>

@class BackendlessUser;

@interface Customer : NSObject
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) BackendlessUser *user;
@property (nonatomic, strong) NSMutableArray *friends;

-(void)addFriend:(Customer *)user;
-(void)deleteFriend:(Customer *)user;
@end