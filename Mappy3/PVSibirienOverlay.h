//
//  PVSibirienOverlay.h
//  Park View
//
//  Created by Per on 2013-03-27.
//  Copyright (c) 2013 Chris Wagner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class PVPark;

@interface PVSibirienOverlay : NSObject <MKOverlay>

- (instancetype)initWithPark:(PVPark *)park;

@end


