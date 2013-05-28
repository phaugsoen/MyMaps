//
//  PVParkMapOverlay.h
//  Park View
//
//  Created by Per on 2013-03-20.
//  Copyright (c) 2013 Chris Wagner. All rights reserved.
// MKMapRect

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class PVPark;

@interface PVParkMapOverlay : NSObject <MKOverlay>

- (instancetype)initWithPark:(PVPark *)park;

@end
