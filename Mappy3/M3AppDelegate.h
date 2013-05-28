//
//  M3AppDelegate.h
//  Mappy3
//
//  Created by Per Haugsöen on 4/11/13.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M3ParseViewController.h"

@interface M3AppDelegate : UIResponder <UIApplicationDelegate>
{
	M3ParseViewController *myParseVC;
}

@property (strong, nonatomic) UIWindow *window;

@end
