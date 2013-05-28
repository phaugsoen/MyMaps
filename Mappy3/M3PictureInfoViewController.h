//
//  M3PictureInfoViewController.h
//  Mappy3
//
//  Created by Per on 2013-04-24.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/PF_MBProgressHUD.h>

@interface M3PictureInfoViewController : UIViewController <PF_MBProgressHUDDelegate>
{
	PF_MBProgressHUD *HUD;
    PF_MBProgressHUD *refreshHUD;

}

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UITextField *nameOfImage;
@property (weak, nonatomic) IBOutlet UITextField *widthOfImage;
@property (weak, nonatomic) IBOutlet UITextField *heightOfImage;
@property (weak, nonatomic) IBOutlet UIView *viewWithLabels;
@property (nonatomic, strong) UIImage *thumbNailImage;

@property (weak, nonatomic) IBOutlet UITextField *sizeOfImage;

- (id)initWithPicture:(UIImage*)image;

@end
