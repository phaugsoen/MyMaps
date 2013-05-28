//
//  M3ImageViewController.m
//  Mappy3
//
//  Created by Per on 2013-04-12.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import "M3ImageViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "M3RefViewController.h"
#import "M3GuideViewController.h"

@interface M3ImageViewController ()

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

@end

@implementation M3ImageViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		_myImageView = [[PFImageView alloc] init];
    }
    return self;
}

- (id) initWithObject:(id)object {

	self = [super init];
	if (self) {
		NSLog(@"Saving object in imageVC");
		
		if(!object)
			NSLog(@"ERROR!!!!!!!!!!!!");
		
		_objectToDisplay = object;
	}
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	NSString *imageNameForTitle = [self.objectToDisplay valueForKey:@"picname"];
	
	[self setTitle:imageNameForTitle];

	PFObject *foundObject = self.objectToDisplay;

	CALayer *myLayer = self.realImageView.layer;
	 
	myLayer.shadowOffset = CGSizeMake(0, 3);
	myLayer.shadowRadius = 5.0;
	myLayer.shadowColor = [UIColor blackColor].CGColor;
	myLayer.shadowOpacity = 0.8;

	self.realImageView.image = [UIImage imageNamed:@"wait_while_loading.png"]; // placeholder image
	PFFile *theFile = (PFFile *)[foundObject objectForKey:@"image"];
	self.realImageView.image = [UIImage imageWithData:[theFile getData]];
    
    
    
	
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
    // 4
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
	
    // 5
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
	
    // 6
    [self centerScrollViewContents];
}


- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.realImageView.frame;
	
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
	
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
	
    self.realImageView.frame = contentsFrame;
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    return self.realImageView;
}
/*
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}
*/
/*
// Show a VC that uses the map and layer and LL
- (IBAction)useMapPressed:(id)sender {
 
	
	M3GuideViewController *guideVC = [[M3GuideViewController alloc] initWithObject:self.objectToDisplay];
	
	[[self navigationController] pushViewController: guideVC animated:NO];
    
}
*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
