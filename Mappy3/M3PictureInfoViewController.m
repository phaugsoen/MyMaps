//
//  M3PictureInfoViewController.m
//  Mappy3
//
//  Created by Per on 2013-04-24.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import "M3PictureInfoViewController.h"
#import <Parse/Parse.h>
#import <TSMessageView.h>
#import <QuartzCore/QuartzCore.h>

@interface M3PictureInfoViewController ()

@property (nonatomic, strong) UIImage *imageToShow;
@end

@implementation M3PictureInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPicture:(UIImage*)image {

	self = [super init];
	
	if(self) {
		_imageToShow = image;
		
		
			
		UIImage *thumbNailImage = [image copy];
			
		CGRect imageRect = CGRectMake(0.0, 0.0, 72, 72);
			
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(72, 72), YES, [UIScreen mainScreen].scale);
			
		[thumbNailImage drawInRect:imageRect];
			
			
		//   self.appRecord.appIcon = UIGraphicsGetImageFromCurrentImageContext();  // UIImage returned.
		UIGraphicsEndImageContext();
			
		self.thumbNailImage = thumbNailImage;
		
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
			initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self
										 action:@selector(cancelPressed:)];
		
		[[self navigationItem] setLeftBarButtonItem:cancelButton];
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
										initWithTitle:@"upload" style:UIBarButtonItemStyleDone
										target:self
										action:@selector(donePressed:)];
		
		[[self navigationItem] setRightBarButtonItem:doneButton];
	}
	
	return self;
	
	
}

- (void)cancelPressed:(id)sender
{
	NSLog(@"CancelPressed");

	
	
	[[self navigationController] popViewControllerAnimated:YES];
}

// Should init the upload to back-end of the image
- (void)donePressed:(id)sender
{
	NSLog(@"done pressed");

	[self uploadPicture];
//	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.pictureView.image = self.imageToShow;
	
	self.widthOfImage.text = [NSString stringWithFormat:@"%f",self.imageToShow.size.width];

	self.heightOfImage.text = [NSString stringWithFormat:@"%f",self.imageToShow.size.height];
	
	int sizeOfImage = [UIImagePNGRepresentation(self.imageToShow) length];
	
	
	NSString *sizeNice =
		[NSByteCountFormatter stringFromByteCount:sizeOfImage
									   countStyle:NSByteCountFormatterCountStyleFile];
	
	
	self.sizeOfImage.text = sizeNice;
	
	CALayer *myLayer = self.pictureView.layer;
	
	myLayer.shadowOffset = CGSizeMake(0, 3);
	myLayer.shadowRadius = 5.0;
	myLayer.shadowColor = [UIColor blackColor].CGColor;
	myLayer.shadowOpacity = 0.8;
}


// uploads the picture as a new object to Parse back-end
- (IBAction)uploadPicture
{
    
    HUD = [[PF_MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = PF_MBProgressHUDModeDeterminate;
    HUD.mode = PF_MBProgressHUDAnimationFade;
    HUD.delegate = self;
    HUD.labelText = [@"Uploading: " stringByAppendingString:self.nameOfImage.text];
    
    
    NSData *pictureData = UIImagePNGRepresentation(self.imageToShow);
    
    //    NSLog(@"Size of image file (in bytes) :%d", [pictureData length]);
    
    //  NSString *sizeOfPic = [NSString stringWithFormat:@"Picture to large:%d", [pictureData length]];
    
	if ([pictureData length] > 10485750) {
        [TSMessage showNotificationInViewController:self
										  withTitle:@"Image to large"
										withMessage:@"The image you are trying to upload exceeds the maxiumum size (10 Mb)"
										   withType:TSMessageNotificationTypeError
									   withDuration:5.0];
		
	    [HUD hide:YES];
        
        return;
    }
    
	if ( [self.nameOfImage.text length] < 1) {
		
		[TSMessage showNotificationInViewController:self
										  withTitle:@"No name supplied"
										withMessage:@"You have to supply a name"
										   withType:TSMessageNotificationTypeError
									   withDuration:5.0];
		
	    [HUD hide:YES];
        return;	
	}
	[HUD show:YES];
    // ändra senare till PNG
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
            
    /*
            [imageObject setObject:[NSNumber numberWithFloat:59.1234f] forKey:@"ULLat"];
            [imageObject setObject:[NSNumber numberWithFloat:18.5678f] forKey:@"ULLon"];
            
            [imageObject setObject:[NSNumber numberWithFloat:58.1234f] forKey:@"LLLat"];
            [imageObject setObject:[NSNumber numberWithFloat:18.5678f] forKey:@"LLLon"];
            
            [imageObject setObject:[NSNumber numberWithFloat:59.1234f] forKey:@"URLat"];
            [imageObject setObject:[NSNumber numberWithFloat:19.5678f] forKey:@"URLon"];
            
            [imageObject setObject:[NSNumber numberWithFloat:58.1234f] forKey:@"LRLat"];
            [imageObject setObject:[NSNumber numberWithFloat:19.5678f] forKey:@"LRLon"];
            
      */      
			[imageObject setObject:[NSNumber numberWithBool:FALSE] forKey:@"fav"];
            
            NSData *theData = UIImagePNGRepresentation(self.thumbNailImage);
            PFFile *fileThumb = [PFFile fileWithName:@"thumbnail.jpg" data:theData];
            [imageObject setObject:fileThumb forKey:@"thumbnail"];
            
            [imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded){
                    
                    //Go back to the wall
                    [self.navigationController popViewControllerAnimated:YES];
              //      self.pictureView.image = nil;
              //      self.viewWithLabels.hidden = TRUE;
                }
                else {
                    [HUD hide:YES];
					NSString *errorString = [[error userInfo] objectForKey:@"error"];
					
					[TSMessage showNotificationInViewController:self
													  withTitle:@"Error uploading"
													withMessage:errorString
													   withType:TSMessageNotificationTypeError
												   withDuration:8.0];
					
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
