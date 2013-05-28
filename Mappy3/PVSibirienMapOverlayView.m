//
//  PVSibirienMapOverlayView.m
//  Park View
//
//  Created by Per on 2013-03-27.
//  Copyright (c) 2013 Chris Wagner. All rights reserved.
//

#import "PVSibirienMapOverlayView.h"

@interface PVSibirienMapOverlayView ()

@property (nonatomic, strong) UIImage *overlayImage;

@end

@implementation PVSibirienMapOverlayView

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage
{
    self = [super initWithOverlay:overlay];

    if (self) {
        _overlayImage = overlayImage;
    }
	
    return self;
}

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)context
{
    CGImageRef imageReference = self.overlayImage.CGImage;
	
    MKMapRect theMapRect = self.overlay.boundingMapRect;
    CGRect theRect = [self rectForMapRect:theMapRect];
	
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -theRect.size.height);
    CGContextDrawImage(context, theRect, imageReference);
//	CGContextSetAlpha(context, 1.0);
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


@end
