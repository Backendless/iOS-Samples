//
//  ViewController.h
//  UIElementsSample
//
//  Created by Yury Yaschenko on 11/4/13.
//  Copyright (c) 2013 BACKENDLESS.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BETableView.h"
#import "BECollectionView.h"

@interface ViewController : UIViewController
//@property (nonatomic, weak) IBOutlet BEMapView *mapView;
@property (nonatomic, weak) IBOutlet BETableView *tableview;
@property (nonatomic, weak) IBOutlet BECollectionView *collectionView;
@end
