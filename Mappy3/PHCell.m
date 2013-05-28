//
//  PHCell.m
//  Mappy2
//
//  Created by Per on 2013-04-11.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import "PHCell.h"

@implementation PHCell

@synthesize name, size, height, width, date, upperLeft, lowerRight, starButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
		self.starButton = [BButton awesomeButtonWithOnlyIcon:FAIconStar type:BButtonTypeGray];
//		self.starButton.frame = CGRectMake(860.0, 40.0, 40.0f, 40.0f);
//		[self.contentView addSubview:self.starButton];

//		[btn addTarget:self action:@selector(bbPressed:)
//	  forControlEvents:UIControlEventTouchUpInside];
		

		
    }
    return self;
}
- (IBAction)editPressed:(id)sender {
	NSLog(@"Edit pressed");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
