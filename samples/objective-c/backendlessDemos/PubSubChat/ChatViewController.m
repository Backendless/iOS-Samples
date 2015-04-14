//
//  ChatViewController.m
//  backendlessDemos
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

#import "ChatViewController.h"
#import "Backendless.h"

//static NSString *MESSAGING_CHANNEL = @"default";
static NSString *MESSAGING_CHANNEL = @"checking";
static NSString *PUBLISHER_ANONYMOUS = @"Anonymous";
static NSString *PUBLISHER_NAME_HEADER = @"publisher_name";


@interface ChatViewController () <IResponder> {
    
    PublishOptions *publishOptions;
    SubscriptionOptions *subscriptionOptions;
    BESubscription *subscription;
    Responder *responder;
}

-(void)showAlert:(NSString *)message;
-(void)publish;
-(void)subscribe;
-(void)unsubscribe;
@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.isTextAppended = YES;
    
    [self subscribe];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Public Methods

-(void)chatSetup:(NSString *)name {
    
    NSLog(@"ChatViewController -> chatSetup: name = %@", name);
    publishOptions = [PublishOptions new];
    publishOptions.publisherId = name?name:PUBLISHER_ANONYMOUS;
    subscriptionOptions = [SubscriptionOptions new];
}

#pragma mark -
#pragma mark Private Methods

-(void)showAlert:(NSString *)message {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error:" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

-(void)publish {
    
    NSString *message = self.textField.text;
    if (!message || !message.length)
        return;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    @try {
        
        MessageStatus *status = [backendless.messagingService publish:MESSAGING_CHANNEL message:message publishOptions:publishOptions];
        self.textField.text = @"";
        
        NSLog(@"ChatViewController -> publish: PUBLISH STATUS: %@", status);
    }
    
    @catch (Fault *fault) {
        NSLog(@"ChatViewController -> publish: %@", fault);
    }
    
    @finally {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

#if 1
-(void)subscribe {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [backendless.messagingService
      subscribe:MESSAGING_CHANNEL
      subscriptionResponse:^(NSArray *messages) {
          [self responseHandler:messages];
      }
      subscriptionError:^(Fault *error) {
          NSLog(@"ChatViewController -> subscribe (ERROR): %@", error);
          [self showAlert:error.message];
      }
      subscriptionOptions:subscriptionOptions
      response:^(BESubscription *response) {
          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
          subscription = response;
          NSLog(@"ChatViewController -> subscribe: SUBSCRIPTION: %@", subscription);
      }
      error:^(Fault *fault) {
          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
          NSLog(@"ChatViewController -> subscribe (FAULT: %@", fault);
          [self showAlert:fault.message];
      }];
}
 //
#else
-(void)subscribe {
   
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        @try {
            
            responder = [[Responder alloc] initWithResponder:self
                                          selResponseHandler:@selector(responseHandler:) selErrorHandler:@selector(errorHandler:)];
            subscription = [backendless.messagingService
                            subscribe:MESSAGING_CHANNEL subscriptionResponder:responder subscriptionOptions:subscriptionOptions];
            
            NSLog(@"ChatViewController -> subscribe: SUBSCRIPTION: %@", subscription);
        }
        
        @catch (Fault *fault) {
            
            NSLog(@"ChatViewController -> subscribe: %@", fault.message);
            
            [self showAlert:fault.message];
        }
        
        @finally {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    });
}
#endif

-(void)unsubscribe {
    [subscription cancel];
}

#pragma mark -
#pragma mark IResponder Methods

-(id)responseHandler:(id)response {
    
    dispatch_async( dispatch_get_main_queue(), ^{
        
        //NSLog(@"ChatViewController -> responseHandler: RESPONSE = %@ <%@>", response, response?[response class]:@"NULL");
        
        NSArray *messages = response;
        for (id obj in messages) {
            if ([obj isKindOfClass:[Message class]]) {
                Message *message = (Message *)obj;
                NSString *publisher = message.publisherId;
                self.textView.text = self.isTextAppended ?
                [self.textView.text stringByAppendingFormat:@"%@ : '%@'\n", publisher ? publisher : PUBLISHER_ANONYMOUS, message.data] :
                [NSString stringWithFormat:@"%@ : '%@'\n%@", publisher ? publisher : PUBLISHER_ANONYMOUS, message.data, self.textView.text];
            }
        }
    });
    
    return response;
}

-(void)errorHandler:(Fault *)fault {
    NSLog(@"ChatViewController -> errorHandler: %@", fault);
}

#pragma mark -
#pragma mark Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"ChatViewController -> prepareForSegue: %@", [segue identifier]);
    
    if ([[segue identifier] isEqualToString:@"Cancel.ChatViewController"]) {
        [self unsubscribe];
        sleep(1);
        
        NSLog(@"ChatViewController -> prepareForSegue: BYE");
        
        return;
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self publish];
	
    return YES;
}

@end
