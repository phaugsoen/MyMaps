//
//  PVParkMapOverlayView.h
//  Park View
//
//  Created by Per on 2013-03-20.
//  Copyright (c) 2013 Chris Wagner. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PVParkMapOverlayView : MKOverlayView

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage;

@end