//
//  M3MiniMapViewController.m
//  Mappy2
//
//  Created by Per on 2013-04-10.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import "M3MiniMapViewController.h"

@interface M3MiniMapViewController ()

@end

@implementation M3MiniMapViewController

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
	
	[self.miniMap setShowsUserLocation:true];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
