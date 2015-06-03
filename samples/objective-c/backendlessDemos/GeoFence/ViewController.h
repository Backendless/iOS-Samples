//
//  ViewController.h
//  GeoFence
//
//  Created by Slava Vdovichenko on 5/19/15.
//  Copyright (c) 2015 BACKENDLESS.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labelLat;
@property (weak, nonatomic) IBOutlet UILabel *labelLon;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UITextView *textView;
-(void)addText:(NSString *)text;
@end

