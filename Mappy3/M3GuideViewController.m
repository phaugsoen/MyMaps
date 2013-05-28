//
//  M3GuideViewController.m
//  Mappy3
//
//  Created by Per on 2013-04-17.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import "M3GuideViewController.h"
#import <MapKit/MapKit.h>
#import "PVPark.h"
#import "PVSibirienOverlay.h"
#import "PVSibirienMapOverlayView.h"
#import <TSMessage.h>

@interface M3GuideViewController ()



@property (nonatomic, strong) PVPark *park;
@property (strong, nonatomic) PFObject *objectToUse;

@end

@implementation M3GuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithObject:(PFObject*)object
{
	self = [super init];
	if(self) {
        _objectToUse = object;
        
		[self.navigationItem setTitle:@"You R Here!"];
	
		UISegmentedControl *mapSegmentControl =
		[[UISegmentedControl alloc] initWithItems:@[@"none", @"layer", @"dim"]];
		
		
		[mapSegmentControl addTarget:self
							  action:@selector(mapSegChanged:)
				   forControlEvents:UIControlEventValueChanged];
		[[self navigationItem] setTitleView:mapSegmentControl];
        }
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	

    // nu skall jag läsa in params som tidigare kom från plist
    // jag borde ha allt som behövs i object
    
    
    
//    self.park = [[PVPark alloc] initWithFilename:@"sibirien"];
    self.park = [[PVPark alloc] initWithObject:self.objectToUse];
	
	// Check that the park values are ok
	if( self.park.midCoordinate.latitude == 0.0 || self.park.midCoordinate.longitude == 0.0) {
		
		[TSMessage showNotificationInViewController:self
										  withTitle:@"Data Error"
										withMessage:@"There seems to be something strange about one or more of the map parameter values"
										   withType:TSMessageNotificationTypeError
									   withDuration:8.0];
		 
		 }
    
    
	
	
    CLLocationDegrees latDelta = self.park.overlayTopLeftCoordinate.latitude - self.park.overlayBottomRightCoordinate.latitude;
	
    // think of a span as a tv size, measure from one corner to another
    MKCoordinateSpan span = MKCoordinateSpanMake(fabsf(latDelta), 0.0);
	
    MKCoordinateRegion region = MKCoordinateRegionMake(self.park.midCoordinate, span);
	
    self.mapView.region = region;
	self.mapView.showsUserLocation = true;
	//self.theMapView.alpha = 0.2;
}

- (void)addOverlay
{
    
 //   [self.theMapView removeOverlays:self.theMapView.overlays];
    PVSibirienOverlay *overlay = [[PVSibirienOverlay alloc] initWithPark:self.park];
    [self.mapView addOverlay:overlay];
	
}

- (void)addBlackOverlay
{
    // Gör en ny likadan klass, men annan....
    
    // Denna klass kanske skall täcka hela världen, så att man aldrig ser kartan.
    PVSibirienOverlay *overlay = [[PVSibirienOverlay alloc] initWithPark:self.park];
    [self.mapView addOverlay:overlay];
	
}


- (MKOverlayView *)mapView:(MKMapView *)mapView
			viewForOverlay:(id<MKOverlay>)overlay
{
    NSLog(@"delegate called, in area");
    
    
    // Testa om nya klassen, i så fall annat case där en svart fil används
    
    if ([overlay isKindOfClass:PVSibirienOverlay.class])
	{
        UIImage *magicMountainImage = [UIImage imageNamed:@"surbrunnsgatan"];

        PVSibirienMapOverlayView *overlayView = [[PVSibirienMapOverlayView alloc]
                                                 initWithOverlay:overlay
                                                 overlayImage:magicMountainImage];
		
        return overlayView;
    }
	
    return nil;
}

-(IBAction)mapSegChanged:(id)sender
{
	NSLog(@"Change map seg");
    
    UISegmentedControl *tmp = sender;
    
    if (tmp.selectedSegmentIndex == 1) {
        [self addOverlay];
        NSLog(@"Adding layer to map");
    }
    
    if (tmp.selectedSegmentIndex == 0)
        [self.mapView removeOverlays:self.mapView.overlays];
    
    
	
	
	
}

- (IBAction)showUnitPressed:(id)sender {
    NSLog(@"show Unit Pressed");
    
    self.mapView.showsUserLocation = !self.mapView.showsUserLocation;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
