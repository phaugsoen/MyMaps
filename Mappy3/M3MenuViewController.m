//
//  M3MenuViewController.m
//  Mappy3
//
//  Created by Per Haugsöen on 4/11/13.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import "M3MenuViewController.h"
#import <Parse/Parse.h>
#import <Parse/PF_MBProgressHUD.h>
#import <QuartzCore/QuartzCore.h>
#import "M3ListViewController.h"
#import "M3NavViewController.h"
#import <TSMessage.h>
#import <BButton.h>


@interface M3MenuViewController ()

@property (nonatomic, strong) UIImage *selectedImage;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@end

@implementation M3MenuViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.viewWithLabels.hidden = TRUE;
	
	// test BButton
//	CGRect frame = CGRectMake(512.0, 520.0, 162.0f, 40.0f);
	
	//BButton *btn = [[BButton alloc] initWithFrame:frame type:BButtonTypePrimary];
	
//	btn = [BButton awesomeButtonWithOnlyIcon:FAIconStar color:[UIColor yellowColor]];
	
//	btn = [BButton awesomeButtonWithOnlyIcon:FAIconStar type:BButtonTypeGray];
//	btn.frame = CGRectMake(512.0, 520.0, 162.0f, 40.0f);
		   
	//[btn setTitle:@"Select" forState:UIControlStateNormal];
//	[btn addTarget:self action:@selector(bbPressed:)
//			forControlEvents:UIControlEventTouchUpInside];
	
//	[self.view addSubview:btn];
	
	//NSString *foo = @"Kalle";
//	foo = [NSString stringFromAwesomeIcon:FAIconStar];
	//NSLog(@"FA:%@", foo);
}

-(void)bbPressed:(id) sender
{
	NSLog(@"bbpressed");
}

//  Should create, push and show the ListVC
//
- (IBAction)prepareMapButtonPressed:(id)sender {
    
    NSLog(@"(M3MenuVC:prepapreMapButtonPressed");
    
    M3ListViewController *listVC = [[M3ListViewController alloc] init];
    
    [self.navigationController pushViewController:listVC animated:NO];
    
}


- (IBAction)selectPicture:(id)sender {

    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
	imgPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    imgPicker.delegate = (id)self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
   
	self.popover = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
    
	[self.popover presentPopoverFromRect:CGRectMake(0.0, 0.0, 0.0, 0.0)
                                  inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionAny
                                animated:YES];
    
	
	
	
	
}
/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSString *fileURLName = [info valueForKey:@"UIImagePickerControllerMediaURL"];
    
    [[self popover] dismissPopoverAnimated:YES];
    
    self.selectedImageView.image = [[UIImage alloc] init];
	self.selectedImageView.image = [img copy];
    
    self.widthOfImage.text = [NSString stringWithFormat:@"%f",self.selectedImage.size.width];
    self.heightOfImage.text = [NSString stringWithFormat:@"%f",self.selectedImage.size.height];
    self.viewWithLabels.hidden = FALSE;
    
	
    [self createTN];

}
*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo
{
    self.selectedImage = img;
    

	
    [[self popover] dismissPopoverAnimated:YES];
    
    self.selectedImageView.image = img;
    
    self.widthOfImage.text = [NSString stringWithFormat:@"%f",self.selectedImage.size.width];
    self.heightOfImage.text = [NSString stringWithFormat:@"%f",self.selectedImage.size.height];
    self.viewWithLabels.hidden = FALSE;
    
	
    [self createTN];
    
    
    
}


- (void)createTN
{
    
    UIImage *thumbNailImage = [self.selectedImage copy];
    
    CGRect imageRect = CGRectMake(0.0, 0.0, 72, 72);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(72, 72), YES, [UIScreen mainScreen].scale);
    
    [thumbNailImage drawInRect:imageRect];

    
    //   self.appRecord.appIcon = UIGraphicsGetImageFromCurrentImageContext();  // UIImage returned.
    UIGraphicsEndImageContext();
    
    self.thumbNailImage = thumbNailImage;
    
}



- (void)viewWillAppear:(BOOL)animated
{
    
    CALayer *myLayer = self.selectedImageView.layer;
    // myLayer.contents = (id) [UIImage imageNamed:@"surbrunnsgatan.png"].CGImage;
    myLayer.borderColor = [UIColor whiteColor].CGColor;
    myLayer.borderWidth = 5.0;
    
    myLayer.shadowOffset = CGSizeMake(0, 3);
    myLayer.shadowRadius = 5.0;
    myLayer.shadowColor = [UIColor blackColor].CGColor;
    myLayer.shadowOpacity = 0.8;
    
    
}




- (IBAction)logoutParse:(id)sender {
    
//    [self presentingViewController]
    
}



- (IBAction)uploadPicture:(id)sender {
    
    
    if (self.selectedImageView.image == nil) {
		/*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"No picture selected"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
	 */
		[TSMessage showNotificationInViewController:self
										  withTitle:@"No picture selected!"
										withMessage:@"You have to first select a picture"
										   withType:TSMessageNotificationTypeError
									   withDuration:3.0];
		return;
	
    }
    
    HUD = [[PF_MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = PF_MBProgressHUDModeDeterminate;
    HUD.mode = PF_MBProgressHUDAnimationFade;
    HUD.delegate = self;
    HUD.labelText = [@"Uploading: " stringByAppendingString:self.nameOfImage.text];
    [HUD show:YES];
    
    NSData *pictureData = UIImagePNGRepresentation(self.selectedImage);
    
    //    NSLog(@"Size of image file (in bytes) :%d", [pictureData length]);
    
    //  NSString *sizeOfPic = [NSString stringWithFormat:@"Picture to large:%d", [pictureData length]];
    
	
	if ( [self.nameOfImage.text length] < 1) {
		
		[TSMessage showNotificationInViewController:self
										  withTitle:@"No name supplied"
										withMessage:@"You have to supply a name"
										   withType:TSMessageNotificationTypeError
									   withDuration:5.0];

		/*
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"You have to supply a name"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
		 */
        [HUD hide:YES];
        return;
		
	}
	
    
    PFFile *file = [PFFile fileWithName:@"image.jpg" data:pictureData];
	
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            [HUD hide:YES];
            
            // Show checkmark
            HUD = [[PF_MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.delegate = self;
            
            PFObject *imageObject = [PFObject objectWithClassName:@"MappyPics"];
            
            [imageObject setObject:self.nameOfImage.text forKey:@"picname"];
            [imageObject setObject:[PFUser currentUser].username forKey:@"user"];
            [imageObject setObject:file forKey:@"image"];
            [imageObject setObject:[NSNumber numberWithInt:[self.widthOfImage.text intValue]] forKey:@"width"];
            [imageObject setObject:[NSNumber numberWithInt:[self.heightOfImage.text intValue]]  forKey:@"height"];
            [imageObject setObject:[NSNumber numberWithInt:[pictureData length]] forKey:@"size"];
            
            
            // for now, set the corners to some dummies
            
            
            [imageObject setObject:[NSNumber numberWithFloat:59.1234f] forKey:@"ULLat"];
            [imageObject setObject:[NSNumber numberWithFloat:18.5678f] forKey:@"ULLon"];
            
            [imageObject setObject:[NSNumber numberWithFloat:58.1234f] forKey:@"LLLat"];
            [imageObject setObject:[NSNumber numberWithFloat:18.5678f] forKey:@"LLLon"];
            
            [imageObject setObject:[NSNumber numberWithFloat:59.1234f] forKey:@"URLat"];
            [imageObject setObject:[NSNumber numberWithFloat:19.5678f] forKey:@"URLon"];
            
            [imageObject setObject:[NSNumber numberWithFloat:58.1234f] forKey:@"LRLat"];
            [imageObject setObject:[NSNumber numberWithFloat:19.5678f] forKey:@"LRLon"];
            
            
			[imageObject setObject:[NSNumber numberWithBool:FALSE] forKey:@"fav"];
            
            NSData *theData = UIImagePNGRepresentation(self.thumbNailImage);
            PFFile *fileThumb = [PFFile fileWithName:@"thumbnail.jpg" data:theData];
            [imageObject setObject:fileThumb forKey:@"thumbnail"];
            
            [imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded){
                    
                    //Go back to the wall
                    [self.navigationController popViewControllerAnimated:YES];
                    self.selectedImageView.image = nil;
                    self.viewWithLabels.hidden = TRUE;
                }
                else {
                    [HUD hide:YES];
                    
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                }
            }];
        }
        else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
        
    } progressBlock:^(int percentDone) {
        NSLog(@"Uploaded: %d %%", percentDone);
        HUD.progress = (float)percentDone/100;
    }];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
