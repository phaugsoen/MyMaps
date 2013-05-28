//
//  BildView.m
//  Park View
//
//  Created by Per on 2013-03-21.
//  Copyright (c) 2013 Chris Wagner. All rights reserved.
//

#import "BildView.h"

@implementation BildView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
			
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
	
/*
	// rita en markering för klick
	float x = self.clickPoint.x;
	float y = self.clickPoint.y;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIBezierPath *path = [[UIBezierPath alloc] init];
	[path moveToPoint:self.clickPoint];
	
	[path addLineToPoint:CGPointMake(x + 5.0, y + 10.0)];
	
	[path addLineToPoint:CGPointMake(self.clickPoint.x - 5.0, self.clickPoint.y)];
	
	[path closePath];
	[[UIColor greenColor] setFill];
	[[UIColor redColor] setStroke];
	[path fill];
	[path stroke];
	*/
}


- (void)tap:(UITapGestureRecognizer*)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateEnded)     {
		// handling code     }
		CGPoint theTapPoint = [recognizer locationInView:self];
		NSLog(@"(View)You tapped: x:%f y:%f", theTapPoint.x, theTapPoint.y);
	}
	
	
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
