#import "PVParkMapViewController.h"
// #import "PVMapOptionsViewController.h"
#import "PVPark.h"
#import "PVParkMapOverlayView.h"
#import "PVParkMapOverlay.h"
#import "BildView.h"
#import <QuartzCore/QuartzCore.h>
#import "M3MiniMapViewController.h"



static inline double radians (double degrees) { return degrees * M_PI/180; }


@interface PVParkMapViewController ()

@property (nonatomic, strong) PVPark *park;
@property (nonatomic, strong) NSMutableArray *selectedOptions;

@property (weak, nonatomic) IBOutlet UIImageView *bildView;


@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D *location2D;

@property (weak, nonatomic) IBOutlet UITextField *infoLabel;

@property (weak, nonatomic) IBOutlet UITextField *currentLat;
@property (weak, nonatomic) IBOutlet UITextField *currentLong;

@property (nonatomic, strong  ) CALayer *customDrawn;

@property (nonatomic)   CGPoint tappedPoint;

@property (weak, nonatomic) IBOutlet UITextView *textLog;


@property (nonatomic) BOOL alphaWillBeMarked;
@property (nonatomic) BOOL betaWillBeMarked;
@property (nonatomic) CLLocation *currentLocation;
@property (nonatomic) CLLocation *alphaCoord;
@property (nonatomic) CLLocation *betaCoord;
@property (nonatomic) CGPoint alphaPoint;
@property (nonatomic) CGPoint betaPoint;

@property (nonatomic) float bildHeight;
@property (nonatomic) float bildWidth;

@property (nonatomic) float aYLaInFunk;
@property (nonatomic) float bYLaInFunk;
@property (nonatomic) float aXLoInFunk;
@property (nonatomic) float bXLoInFunk;



// new popover map
@property (nonatomic, strong) MKMapView *miniMap;
@property (nonatomic, strong) UIPopoverController *miniMapPopover;
@property (nonatomic, strong) M3MiniMapViewController *miniMapVC;

@end

@implementation PVParkMapViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setTitle:@"Reference points"];
	
	
    
    self.selectedOptions = [NSMutableArray array];
    self.park = [[PVPark alloc] initWithFilename:@"MagicMountain"];
	
	
    CLLocationDegrees latDelta = self.park.overlayTopLeftCoordinate.latitude - self.park.overlayBottomRightCoordinate.latitude;
	
    // think of a span as a tv size, measure from one corner to another
    MKCoordinateSpan span = MKCoordinateSpanMake(fabsf(latDelta), 0.0);
	
    MKCoordinateRegion region = MKCoordinateRegionMake(self.park.midCoordinate, span);

	// Tagit bort för att inte visa kartan över parken utan den faktiska
    //self.mapView.region = region;
	[self.mapView setShowsUserLocation:true];
	
	
	// Test stuff for Phase One
	// iPad screen size in points = 1024*768, retina twice in pixels
	//CGRect frameForBild = CGRectMake(100, 100, 824, 568);
	
//	UIView *bildView = [[UIView alloc] initWithFrame:frameForBild];
//	[bildView setBackgroundColor:[UIColor blueColor]];
//	[[self view] addSubview:bildView];
	
	
	
	UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]
									 initWithTarget:self
									 action:@selector(tap4:)];
	
	[self.bildView addGestureRecognizer:tapGr];
	
	
	[self.bildView setUserInteractionEnabled:YES];
	CGRect b = [self.bildView bounds];
	NSLog(@"bild info: Height:%f Width:%f",b.size.height,b.size.width);
	
	self.bildWidth = b.size.width;
	self.bildHeight = b.size.height;
	
	[self.infoLabel setText:[NSString stringWithFormat:@"bild info: X:%f Y:%f H:%f W:%f",b.origin.x, b.origin.y, b.size.height,b.size.width]];
	
//	[self.bildView setBackgroundColor:[UIColor redColor]];
		
	CALayer *myLayer = self.bildView.layer;
    
    
    PFObject *foundObject = self.objectToUse;
    
 //   self.bildView.image = [UIImage imageNamed:@"wait_while_loading.png"]; // placeholder image
//    self.bildView.file = (PFFile *)[foundObject objectForKey:@"image"]; // remote image
    //    self.imageView.backgroundColor = [UIColor redColor];
//    [self.bildView loadInBackground];
    
    
    

    myLayer.contents = (id) self.imageToUse.CGImage;
    myLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    myLayer.borderColor = [UIColor whiteColor].CGColor;
    myLayer.borderWidth = 5.0;
	myLayer.shadowOffset = CGSizeMake(0, 3);
    myLayer.shadowRadius = 5.0;
    myLayer.shadowColor = [UIColor blackColor].CGColor;
    myLayer.shadowOpacity = 0.8;
	

    // Lägger till ett nytt layer för att rita i
    self.customDrawn = [CALayer layer];
    self.customDrawn.delegate = self;
    
    self.customDrawn.backgroundColor = [UIColor greenColor].CGColor;
    self.customDrawn.opacity = 0.2;
  //  self.customDrawn.frame = self.bildView.frame;
    
    CGFloat subWidth = self.bildView.bounds.size.width;
    
    CGFloat subHeight = self.bildView.bounds.size.height;
    
//    self.customDrawn.frame = CGRectMake(0,0,subWidth, subHeight);
    
    self.customDrawn.frame = CGRectMake(0,0, myLayer.bounds.size.width,100);
 //   [self.bildView sizeToFit];
    
    [self.bildView.layer addSublayer:self.customDrawn];
    [self.customDrawn setNeedsDisplay];
 


	// starta location manager
	if (!self.locationManager) {
		self.locationManager = [[CLLocationManager alloc] init];
		[self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
		[self.locationManager startUpdatingLocation];
		[self.locationManager setDelegate:self];
	}
	
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.customDrawn setNeedsDisplay];
    self.customDrawn.delegate = nil;
    [self.locationManager stopUpdatingLocation];
    self.customDrawn = nil;
    
}

- (IBAction)showRealMapPressed:(id)sender {
	
//	UIPopoverCo
/*
	self.miniMapVC = [[M2MiniMapViewController alloc] init];
	
	self.miniMapPopover = [[UIPopoverController alloc] initWithContentViewController:self.miniMapVC];

	//	[self.miniMapPopover setContentViewController:miniVC animated:YES];
	
	[self.miniMapPopover presentPopoverFromBarButtonItem:self.showRealMapButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
*/	
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	
	[self.showRealMapButton setEnabled:YES];

}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)addInfoText:(NSString*)newText {

    NSString *oldText = self.textLog.text;
    NSString *textToInsert = [@"\n" stringByAppendingString:newText];
    
	textToInsert = [oldText stringByAppendingString:textToInsert];
    
    [self.textLog setText:textToInsert];
    
//    UITextPosition *endPos = [self.textLog endOfDocument];
    
    NSRange range = NSMakeRange(self.textLog.text.length - 1, 1);
    [self.textLog scrollRangeToVisible:range];
 
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
  
    float x = self.tappedPoint.x;
    float y = self.tappedPoint.y;
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context,
                                     [UIColor blueColor].CGColor);
    CGContextMoveToPoint(context, x, y);
    CGContextAddLineToPoint(context, x + 5, y + 5);
    CGContextAddLineToPoint(context, x, y + 10);
    CGContextAddLineToPoint(context, x - 5, y + 5);
    CGContextAddLineToPoint(context, x, y);
    CGContextStrokePath(context);
    
    [self addInfoText:@"draw a marker"];
    
  
}

- (IBAction)sendMail:(id)sender {
    
	// Email Subject
    NSString *emailTitle = @"Mappy info";
    // Email Content
    NSString *messageBody = self.textLog.text;
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"per@haugsoen.se"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
	
	// attach the image
	NSData *imageAsData;
	//	UIImage *image = [UIImage imageNamed:@"surbrunnsgatan.png"];
	imageAsData = [NSData dataWithContentsOfFile:@"Images/surbrunnsgatan.png"];
	
	[mc addAttachmentData:imageAsData mimeType:@"image/png" fileName:@"image.png"];
	
	
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
	
    
}


/* Given the params:
    - alpha x			: self.alphaPoint.x
    -       y			: self.alphaPoint.y
    -       lat			: self.alphaCoord.latitude
    -       long		: self.aphaCoord.longitude
    - beta x			: self.betaPoint.x
    -      y			: self.betaPoint.y
    -      lat			: self.betaCoord.latitude
    -      long			: self.betaCoord.longitude
    - height of image   : self.bildHeight
    - width of image    : self.bildWidth
 
 
	- UpperLeft x		: 0.0
	- UpperLeft y		: 0.0
	- UpperRight x		: self.bildWidth
	- UpperRight y		: 0.0
	- LowerLeft x		: 0.0
	- LowerLeft y		: self.bildHeigth
	- LowerRight x		: self.bildWidth
	- LowerRight y		: self.bildHeight
 
 
 Return the lat and long of the corners
 
 */

// Använder den beräknade funktionen för att utifrån vad GPS
// ger för coord (GPS), rita en markering i kartan
// Är främst till för verifiering av att konceptet fungerar och
// för att utvärdera nogrannheten. Hur bra punkter behöver jag ha
// för att få bra utritning. Är det bättre med flera ref-punkter?

- (IBAction)showMe:(id)sender {
	
	// beräknade med fuskvärden för hemma och bica, x=0/y=0
	// Lat= 59.349384 Long=18.046423
	
	// Denna punkt visas på korrekt plats!!!!
	
	CGFloat myYPoint = self.aYLaInFunk + self.bYLaInFunk * self.currentLocation.coordinate.latitude;
	
	CGFloat myXPoint = self.aXLoInFunk + self.bXLoInFunk * self.currentLocation.coordinate.longitude;

	NSString *tmpStr = [NSString stringWithFormat:@"According to calcs you are at X:%f Y:%f", myXPoint, myYPoint];
	[self addInfoText:tmpStr];
	
}


- (IBAction)calcCorners:(id)sender {
    
    
    // Prova att stoppa in mina andra 150 120 exempelvärden för att se att det räknas rätt.
    // Sen skall ju samma göras för X....
	[self addInfoText: @"Starting to calculate the corner coords!"];
	
	// test värden för alpha = hemma på gatan, beta = bica
    float alphaY  = 164.5; //self.alphaPoint.y; // 150
    float alphaLa = 59.347107; //self.alphaCoord.coordinate.latitude; // 54
    float betaY   = 335.0; //self.betaPoint.y;  // 120
    float betaLa  = 59.344742; //self.betaCoord.coordinate.latitude; // 57
    
    float a;
    float b;
	
    float gammaY = 0.0; // satt för att hitta Lat för övre hörnet
    float gammaLa = 0.0;
	
	// Ta fram coord för övre vänstra hörnet
	float LatwhenZeroY = 0.0;
	float LongWhenZeroX = 0.0;
	
	// Ta fram coord för nedre vänstra hörnet
	float LatWhenPicHeightY = 0.0;
	// samma som LongWhenZeroX;
	
	// Ta fram coord för övre högra hörnet
	float LatWhenPicWidthX = 0.0;
	// samma som LongWhenZeroY
	
	// Ta fram coord för nedre högra hörnet
//	float LatWhenPicWidthX = 0.0;
	float LongWhenPicHeightY = 0.0;
	
    
    b = (alphaY - betaY) / (alphaLa - betaLa);
    
    a = betaY - (betaLa * (alphaY - betaY) / (alphaLa - betaLa));
	
	// spara för senare beräkning
	self.aYLaInFunk = a;
	self.bYLaInFunk = b;
    
//    gammaY = a + b * gammaLa;
	gammaLa = (gammaY - a) / b;

    
//    NSString *tmpStr = [NSString stringWithFormat:@"Found out that with gammaLa:%f I will get gammaY:%f", gammaLa, gammaY];
	
	NSString *tmpStr = [NSString stringWithFormat:@"Lat for Y=0.0 is:%f", gammaLa];
	NSLog(@"%@", tmpStr);
    [self addInfoText:tmpStr];
	
	
	float epsilonY = self.bildHeight;
	float epsilonLa = (epsilonY - a) / b;
	
	NSString *tmpStrE = [NSString stringWithFormat:@"Lat for Y=%f is:%f", self.bildHeight,  epsilonLa];
	NSLog(@"%@", tmpStrE);
    [self addInfoText:tmpStrE];
	
	
    
	// samma sak för X och Lon
	
	// test värden för alpha = hemma på gatan, beta = bica
	
	// ger X/Y= 0/0 coords	Lat= 59.349384 Long=18.046423
	
	float alphaX  = 647.0; //self.alphaPoint.x; // 200
    float alphaLo = 18.064217; // self.alphaCoord.coordinate.longitude; // 18
    float betaX   = 315.0; //self.betaPoint.x; // 250
    float betaLo  = 18.055086; //self.betaCoord.coordinate.longitude; // 20
    float gammaX = 0.0;
	float gammaLo = 0.0; // 22 example for test only
	
	a = 0.0;
	b = 0.0;
	b = (alphaX - betaX) / (alphaLo - betaLo);
	a = betaX - (betaLo * (alphaX - betaX) / (alphaLo - betaLo));
	
	// spara för senare beräkning in funk
	self.aXLoInFunk = a;
	self.bXLoInFunk = b;
	
//	gammaX = a + b * gammaLo;

	gammaLo = (gammaX - a ) /b;
//	NSString *tmpStr2 = [NSString stringWithFormat:@"Found out that with gammaLo:%f I will get gammaX:%f",
//						 gammaLo, gammaX];
	
	NSString *tmpStr2 = [NSString stringWithFormat:@"Long for X=0 is:%f", gammaLo];
	
    NSLog(@"%@", tmpStr2);
    [self addInfoText:tmpStr2];
	
	float epsilonX = self.bildWidth;
	float epsilonLo = (epsilonX - a) / b;

	NSString *tmpStr3 = [NSString stringWithFormat:@"Long for X=%f is:%f", epsilonX, epsilonLo];
	
    NSLog(@"%@", tmpStr3);
    [self addInfoText:tmpStr3];

	
}

- (void)tap4:(UITapGestureRecognizer*)recognizer
{
   if (recognizer.state == UIGestureRecognizerStateEnded)     {
       
	  
	   
	   
	   
       [self.customDrawn setNeedsDisplay];

	   CGPoint theTapPoint = [recognizer locationInView:self.bildView];
	   NSLog(@"You tapped x:%f y:%f", theTapPoint.x, theTapPoint.y);

       self.tappedPoint = theTapPoint;
	   
	   if (self.alphaWillBeMarked) {
		   
		   self.alphaCoord = self.currentLocation;
		   float theLat, theLong;
		   theLat = self.alphaCoord.coordinate.latitude;
		   theLong = self.alphaCoord.coordinate.longitude;
		   NSString *tmpStr =
		   [NSString stringWithFormat:@"You marked Alpha at coord N:%f W:%f X:%f Y:%f", theLat, theLong,
			self.tappedPoint.x, self.tappedPoint.y];
		   
		   self.alphaPoint =  self.tappedPoint;
		   
		   [self addInfoText:tmpStr];
	   }
	   if (self.betaWillBeMarked) {
		   
		   self.betaCoord = self.currentLocation;
		   
		   float theLat, theLong;
		   theLat = self.betaCoord.coordinate.latitude;
		   theLong = self.betaCoord.coordinate.longitude;
		   NSString *tmpStr =
		   [NSString stringWithFormat:@"You marked Beta at coord N:%f W:%f X:%f Y:%f", theLat, theLong,
			self.tappedPoint.x, self.tappedPoint.y];
		   
		   self.betaPoint = self.tappedPoint;
		   
		   [self addInfoText:tmpStr];
		   
		   
		   
		   
		   
	   }

	   NSString *tmp = [NSString stringWithFormat:@"You tapped x:%f y:%f", theTapPoint.x, theTapPoint.y];
	   
	   [self.infoLabel setText: tmp];
	   
//	   [self addInfoText:@""]
	   
//	   [self.bildView setClickPoint:CGPointMake(theTapPoint.x, theTapPoint.y)];
	   	  
//	   [self.bildView setNeedsDisplay];
	   
	  
   }
		
	}


- (void) viewDidDisappear:(BOOL)animated {
    NSLog(@"View did disappear");
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	
//	NSLog(@"New location:%@", locations.lastObject);
//	self.location2D = (__bridge CLLocationCoordinate2D *)(locations.lastObject);
//	NSLog(@"New saved loc: %@", self.location2D);
	
	CLLocation *coord = locations.lastObject;
	self.currentLocation = coord;

	NSString *lat = [NSString stringWithFormat:@"%f",coord.coordinate.latitude];
	NSString *lon = [NSString stringWithFormat:@"%f",coord.coordinate.longitude];
	
	[self.currentLat setText:lat];
	[self.currentLong setText:lon];
	 
}

- (IBAction)alphaPressed:(id)sender {

	NSLog(@"Alpha Pressed");
	[self addInfoText:@"If You are at position Alpha, mark it in the picture/map!"];
	self.alphaWillBeMarked = true;
	self.betaWillBeMarked = false;
}




- (IBAction)betaPressed:(id)sender {
	
	NSLog(@"Beta Pressed");
	[self addInfoText:@"If You are at position Beta, mark it in the picture/map!"];
	self.alphaWillBeMarked = false;
	self.betaWillBeMarked = true;
	
}

- (void)addOverlay {
    PVParkMapOverlay *overlay = [[PVParkMapOverlay alloc] initWithPark:self.park];
    [self.mapView addOverlay:overlay];
}




- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:PVParkMapOverlay.class]) {
        UIImage *magicMountainImage = [UIImage imageNamed:@"overlay_park"];
        PVParkMapOverlayView *overlayView = [[PVParkMapOverlayView alloc] initWithOverlay:overlay overlayImage:magicMountainImage];
		
        return overlayView;
    }
	
    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
/*
    
	PVMapOptionsViewController *optionsViewController = segue.destinationViewController;
    optionsViewController.selectedOptions = self.selectedOptions;
 */
	
	if ([segue.identifier isEqualToString:@"miniMapSegue"]) {
	
		NSLog(@"Will try to show mini map in popover");
		
		M3MiniMapViewController *destVc = segue.destinationViewController;
		UIPopoverController *pop = (UIPopoverController*)destVc.presentingViewController;
		
		pop.delegate = self;
		
	// av så länge jag inte löst knappproblemet, lite skumt...
		
	//	[self.showRealMapButton setEnabled:FALSE];
	}
	
}
/*
- (IBAction)closeOptions:(UIStoryboardSegue *)exitSegue {
    PVMapOptionsViewController *optionsViewController = exitSegue.sourceViewController;
    self.selectedOptions = optionsViewController.selectedOptions;
    [self loadSelectedOptions];
}

- (IBAction)mapTypeChanged:(id)sender {

    switch (self.mapTypeSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}
*/
- (BOOL)shouldAutorotate {
	return NO;
}

@end
