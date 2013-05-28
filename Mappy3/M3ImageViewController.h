//
//  M3ImageViewController.h
//  Mappy3
//
//  Created by Per on 2013-04-12.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface M3ImageViewController: UIViewController <UIScrollViewDelegate>

@property (nonatomic,strong) PFObject *objectToDisplay;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet PFImageView *myImageView;

@property (weak, nonatomic) IBOutlet UIImageView *anotherImageView;
@property (strong, nonatomic) IBOutlet UIImageView *realImageView;

- (id)initWithObject:(PFObject*)object;

@end
