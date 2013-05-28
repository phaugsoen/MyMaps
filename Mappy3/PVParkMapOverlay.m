//
//  PVParkMapOverlay.m
//  Park View
//
//  Created by Per on 2013-03-20.
//  Copyright (c) 2013 Chris Wagner. All rights reserved.
//

#import "PVParkMapOverlay.h"
#import "PVPark.h"

@implementation PVParkMapOverlay

@synthesize coordinate;
@synthesize boundingMapRect;

- (instancetype)initWithPark:(PVPark *)park {
    self = [super init];
    if (self) {
        boundingMapRect = park.overlayBoundingMapRect;
        coordinate = park.midCoordinate;
    }
	
    return self;
}

@end