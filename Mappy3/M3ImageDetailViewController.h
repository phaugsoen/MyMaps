//
//  M2ImageDetailViewController.h
//  Mappy2
//
//  Created by Per Haugsöen on 4/4/13.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface M3ImageDetailViewController : UIViewController

@property (nonatomic,strong) PFObject *objectToDisplay;


@property (weak, nonatomic) IBOutlet PFImageView *imageView;


// - (id) initWithObject:(PFObject*) object;
@end
