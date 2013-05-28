//
//  M3AnnotationView.m
//  Mappy3
//
//  Created by Per on 2013-04-22.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import "M3AnnotationView.h"

#import "M3AnnotationView.h"
#import "M3Annotation.h"

@implementation PVAttractionAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation
		 reuseIdentifier:(NSString *)reuseIdentifier {
	
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
	if (self) {
		
        M3Annotation *attractionAnnotation = self.annotation;
        switch (attractionAnnotation.type) {
            case PVAttractionFirstAid:
                self.image = [UIImage imageNamed:@"firstaid"];
                break;
            case PVAttractionFood:
                self.image = [UIImage imageNamed:@"food"];
                break;
            case PVAttractionRide:
                self.image = [UIImage imageNamed:@"ride"];
                break;
            default:
                self.image = [UIImage imageNamed:@"star"];
                break;
        }
    }
	
    return self;
}

@end