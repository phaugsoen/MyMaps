//
//  M3RefViewController.h
//  Mappy3
//
//  Created by Per Haugsöen on 4/16/13.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import <Parse/Parse.h>

@interface M3RefViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate,
MFMailComposeViewControllerDelegate, UIPopoverControllerDelegate, UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *showRealMapButton;
@property (weak, nonatomic) IBOutlet UITextView *infoField;


@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic,strong) UIImage *imageToUse;
@property (nonatomic, strong) PFObject *objectToUse;


- (id) initWithObject:(id)object;

@end
