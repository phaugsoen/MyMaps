//
//  PVPark.m
//  Park View
//
//  Created by Per on 2013-03-20.
//  Copyright (c) 2013 Chris Wagner. All rights reserved.
//

#import "PVPark.h"
#import <Parse/Parse.h>
#import <TSMessage.h>

@implementation PVPark

- (instancetype)initWithFilename:(NSString *)filename {
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
        NSDictionary *properties = [NSDictionary dictionaryWithContentsOfFile:filePath];
		
        CGPoint midPoint = CGPointFromString(properties[@"midCoord"]);
        _midCoordinate = CLLocationCoordinate2DMake(midPoint.x, midPoint.y);
		
        CGPoint overlayTopLeftPoint = CGPointFromString(properties[@"overlayTopLeftCoord"]);
        _overlayTopLeftCoordinate = CLLocationCoordinate2DMake(overlayTopLeftPoint.x, overlayTopLeftPoint.y);
		
        CGPoint overlayTopRightPoint = CGPointFromString(properties[@"overlayTopRightCoord"]);
        _overlayTopRightCoordinate = CLLocationCoordinate2DMake(overlayTopRightPoint.x, overlayTopRightPoint.y);
		
        CGPoint overlayBottomLeftPoint = CGPointFromString(properties[@"overlayBottomLeftCoord"]);
        _overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(overlayBottomLeftPoint.x, overlayBottomLeftPoint.y);
		
        NSArray *boundaryPoints = properties[@"boundary"];
		
        _boundaryPointsCount = boundaryPoints.count;
		
        _boundary = malloc(sizeof(CLLocationCoordinate2D)*_boundaryPointsCount);
		
        for(int i = 0; i < _boundaryPointsCount; i++) {
            CGPoint p = CGPointFromString(boundaryPoints[i]);
            _boundary[i] = CLLocationCoordinate2DMake(p.x,p.y);
        }
    }
	
    return self;
}

- (instancetype)initWithObject:(PFObject*)object
{
    self = [super init];
    
    if (self) {

        
        // RÄknas nedre högra ut
        
        // Måste boundry finnas, vad gäller för protokollet?
		
		
		
		
		
        NSString *overlayMidString = [NSString stringWithFormat:@"{%f,%f}", [[object valueForKey:@"midCoordLat"] doubleValue],[[object valueForKey:@"midCoordLon"] doubleValue]];
		
		
		NSLog(@"Läser mid från DB:%f", [[object valueForKey:@"midCoordLat"] doubleValue]);
		
		
		
        CGPoint overlayMidPoint = CGPointFromString(overlayMidString);
        _midCoordinate = CLLocationCoordinate2DMake(overlayMidPoint.x, overlayMidPoint.y);
        
        NSString *overlayTopLeftString = [NSString stringWithFormat:@"{%f,%f}", [[object valueForKey:@"ULLat"] doubleValue],[[object valueForKey:@"ULLon"] doubleValue]];
        CGPoint overlayTopLeftPoint = CGPointFromString(overlayTopLeftString);
        _overlayTopLeftCoordinate = CLLocationCoordinate2DMake(overlayTopLeftPoint.x, overlayTopLeftPoint.y);
        
        NSString *overlayTopRightString = [NSString stringWithFormat:@"{%f,%f}", [[object valueForKey:@"URLat"] doubleValue],[[object valueForKey:@"URLon"] doubleValue]];
        CGPoint overlayTopRightPoint = CGPointFromString(overlayTopRightString);
        _overlayTopRightCoordinate = CLLocationCoordinate2DMake(overlayTopRightPoint.x, overlayTopRightPoint.y);
        
        NSString *overlayBottomLeftString = [NSString stringWithFormat:@"{%f,%f}", [[object valueForKey:@"LLLat"] doubleValue],[[object valueForKey:@"LLLon"] doubleValue]];
        CGPoint overlayBottomLeftPoint = CGPointFromString(overlayBottomLeftString);
        _overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(overlayBottomLeftPoint.x, overlayBottomLeftPoint.y);
    
    }
    
    return self;
}

- (CLLocationCoordinate2D)overlayBottomRightCoordinate {
    return CLLocationCoordinate2DMake(self.overlayBottomLeftCoordinate.latitude, self.overlayTopRightCoordinate.longitude);
}

- (MKMapRect)overlayBoundingMapRect {
	
    MKMapPoint topLeft = MKMapPointForCoordinate(self.overlayTopLeftCoordinate);
    MKMapPoint topRight = MKMapPointForCoordinate(self.overlayTopRightCoordinate);
    MKMapPoint bottomLeft = MKMapPointForCoordinate(self.overlayBottomLeftCoordinate);
	
    return MKMapRectMake(topLeft.x,
						 topLeft.y,
						 fabs(topLeft.x - topRight.x),
						 fabs(topLeft.y - bottomLeft.y));
}

@end
