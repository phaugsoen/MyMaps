//
//  PVSibirienOverlay.m
//  Park View
//
//  Created by Per on 2013-03-27.
//  Copyright (c) 2013 Chris Wagner. All rights reserved.
//

#import "PVSibirienOverlay.h"
#import "PVPark.h"

@implementation PVSibirienOverlay

@synthesize coordinate;
@synthesize boundingMapRect;

- (instancetype)initWithPark:(PVPark *)park
{
    self = [super init];

    if (self) {
        boundingMapRect = park.overlayBoundingMapRect;
        coordinate = park.midCoordinate;
    }
	
    return self;
}

@end