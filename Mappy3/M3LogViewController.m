//
//  M3LogViewController.m
//  Mappy3
//
//  Created by Per Haugsöen on 4/19/13.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import "M3LogViewController.h"

@interface M3LogViewController ()



@end

@implementation M3LogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)initWithText:(NSString*)text
{
    self = [super init];
    
    if(self) {
        _textToShow = text;
    }
    
    return self;
}

-(CGSize)contentSizeForViewInPopover
{
    CGSize tmp = CGSizeMake(400, 200);
    return tmp;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.logText setText:self.textToShow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
