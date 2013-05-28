//
//  M3GuideViewController.h
//  Mappy3
//
//  Created by Per on 2013-04-17.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface M3GuideViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (id)initWithObject:(PFObject*)object;

@end
