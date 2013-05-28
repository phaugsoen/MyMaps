//
//  M3ListViewController.h
//  Mappy3
//
//  Created by Per Haugsöen on 4/11/13.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PHCell.h"

@interface M3ListViewController : PFQueryTableViewController

@property (nonatomic, strong) IBOutlet PHCell *myPHCell;

@end
