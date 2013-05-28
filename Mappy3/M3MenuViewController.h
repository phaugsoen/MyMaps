//
//  M3MenuViewController.h
//  Mappy3
//
//  Created by Per Haugsöen on 4/11/13.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

// Just a simple change to make git do something 


#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Parse/PF_MBProgressHUD.h>




@interface M3MenuViewController : UIViewController
{
    PF_MBProgressHUD *HUD;
    PF_MBProgressHUD *refreshHUD;
}

@property (nonatomic, strong) UIPopoverController *popover;

@property (weak, nonatomic) IBOutlet UITextField *nameOfImage;
@property (weak, nonatomic) IBOutlet UITextField *widthOfImage;
@property (weak, nonatomic) IBOutlet UITextField *heightOfImage;
@property (weak, nonatomic) IBOutlet UIView *viewWithLabels;
@property (nonatomic, strong) UIImage *thumbNailImage;


@end
