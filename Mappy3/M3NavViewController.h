//
//  M3NavViewController.h
//  Mappy3
//
//  Created by Per Haugsöen on 4/15/13.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Parse/PF_MBProgressHUD.h>


@interface M3NavViewController : UINavigationController <PF_MBProgressHUDDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>


- (void)logoutParse;

@end
