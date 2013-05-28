//
//  M2ImageDetailViewController.m
//  Mappy2
//
//  Created by Per Haugsöen on 4/4/13.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import "M3ImageDetailViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "PVParkMapViewController.h"

@interface M3ImageDetailViewController ()
@property (nonatomic, strong) PFImageView *imageView2;



@end

@implementation M3ImageDetailViewController
/*
- (id)initWithObject:(PFObject*)object
{
    self = [super init];
    _objectToDisplay = object;
}
*/
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
    NSLog(@"View Did Load in Detail");
/*
	
    [self setTitle:@"Image"];
    
    PFObject *foundObject = self.objectToDisplay;
 	CALayer *myLayer = self.imageView.layer;
    myLayer.borderColor = [UIColor whiteColor].CGColor;
    myLayer.borderWidth = 5.0;
    
    myLayer.shadowOffset = CGSizeMake(0, 3);
    myLayer.shadowRadius = 5.0;
    myLayer.shadowColor = [UIColor blackColor].CGColor;
    myLayer.shadowOpacity = 0.8;
	
    
 //   self.imageView.image = [UIImage imageNamed:@"wait_while_loading.png"]; // placeholder image
 //   self.imageView.file = (PFFile *)[foundObject objectForKey:@"image"]; // remote image
 //   [self.imageView loadInBackground];

*/
  
}
- (IBAction)dismissDetail:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated {
	
    /*
	PFObject *foundObject = self.objectToDisplay;
 	CALayer *myLayer = self.imageView.layer;
    myLayer.borderColor = [UIColor whiteColor].CGColor;
    myLayer.borderWidth = 5.0;
    
    myLayer.shadowOffset = CGSizeMake(0, 3);
    myLayer.shadowRadius = 5.0;
    myLayer.shadowColor = [UIColor blackColor].CGColor;
    myLayer.shadowOpacity = 0.8;
	
    
    self.imageView.image = [UIImage imageNamed:@"wait_while_loading.png"]; // placeholder image
    self.imageView.file = (PFFile *)[foundObject objectForKey:@"image"]; // remote image
    [self.imageView loadInBackground];
 */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
	
	if ([segue.identifier isEqualToString:@"showRefVC"]) {
		NSLog(@"Will show RefVC");
        
        PVParkMapViewController *newVC = segue.destinationViewController;
        [newVC setImageToUse:self.imageView.image];
        [newVC setObjectToUse:self.objectToDisplay];
        
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
