//
//  M3RefViewController.m
//  Mappy3
//
//  Created by Per Haugsöen on 4/16/13.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import "M3RefViewController.h"
#import "PVPark.h"
#import "PVParkMapOverlayView.h"
#import "PVParkMapOverlay.h"
#import "BildView.h"
#import <QuartzCore/QuartzCore.h>
#import "M3MiniMapViewController.h"
#import "M3LogViewController.h"
#import "M3Annotation.h"
#import "M3AnnotationView.h"
#import "SVPulsingAnnotationView.h"
#import "M3Helpers.h"
#import <TSMessage.h>

static inline double radians (double degrees) { return degrees * M_PI/180; }

NSString * const Mappy3AlphaPointXPrefKey = @"Mappy3AlphaPointXPrefKey";
NSString * const Mappy3AlphaPointYPrefKey = @"Mappy3AlphaPointYPrefKey";
NSString * const Mappy3AlphaPointLatPrefKey = @"Mappy3AlphaPointLatPrefKey";
NSString * const Mappy3AlphaPointLonPrefKey = @"Mappy3AlphaPointLonPrefKey";

NSString * const Mappy3BetaPointXPrefKey = @"Mappy3BetaPointXPrefKey";
NSString * const Mappy3BetaPointYPrefKey = @"Mappy3BetaPointYPrefKey";
NSString * const Mappy3BetaPointLatPrefKey = @"Mappy3BetaPointLatPrefKey";
NSString * const Mappy3BetaPointLonPrefKey = @"Mappy3BetaPointLonPrefKey";

NSString * const Mappy3MapID = @"Mappy3MapID";

@interface M3RefViewController ()

@property (nonatomic, strong) PVPark *park;
@property (nonatomic, strong) NSMutableArray *selectedOptions;

@property (strong, nonatomic) IBOutlet PFImageView *bildView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D *location2D;

//@property (weak, nonatomic) IBOutlet UITextField *infoLabel;

@property (weak, nonatomic) IBOutlet UITextField *currentLat;
@property (weak, nonatomic) IBOutlet UITextField *currentLong;

@property (weak, nonatomic) IBOutlet UITextField *accuracyGPS;

@property (nonatomic, strong  ) CALayer *customDrawn;

@property (nonatomic)   CGPoint tappedPoint;

@property (weak, nonatomic) IBOutlet UITextView *textLog;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *logButton;

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


@property (nonatomic, strong) PFObject *objectToDisplay;

@property (nonatomic, retain) UIPopoverController *logPop;


// nya slutvärden efter integration i Mappy3. Calc corner sätter dessa värden
// Städa upp resten sen när det funkar som det skall

@property (nonatomic) double ULLat;
@property (nonatomic) double ULLon;
@property (nonatomic) double LLLat;
@property (nonatomic) double LLLon;

@property (nonatomic) double URLat;
@property (nonatomic) double URLon;
@property (nonatomic) double LRLat;
@property (nonatomic) double LRLon;

@property (nonatomic) double MidLat;
@property (nonatomic) double MidLon;

// Slut på Mappy3 extra props

// Nya rena coords, parallellt med de andra
@property (nonatomic) double alphaLat;
@property (nonatomic) double alphaLon;
@property (nonatomic) double betaLat;
@property (nonatomic) double betaLon;

@property (nonatomic) BOOL isLogPopVisible;


@property (nonatomic) NSString *mapId;

@end

@implementation M3RefViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _bildView = [[PFImageView alloc] init];
    }
    return self;
}


- (id) initWithObject:(id)object {
    
	self = [super init];
	if (self) {
		NSLog(@"Saving object in imageVC");
		
		if(!object)
			NSLog(@"ERROR!!!!!!!!!!!!");
		
		_objectToDisplay = object;
	}
	return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setTitle:@"Reference points"];
    
  //  [self.view setContentMode:UIViewContentModeScaleAspectFit];
	
	
    // reload info about points from User Defaults
	[self loadUserDefaults];
	
	[self addInfoText:@"Read prev ref data from user defaults:"];
	NSString *pointsRead = [NSString stringWithFormat:@"alpha:%f %f %f %f",
							self.alphaPoint.x, self.alphaPoint.y,
							self.alphaLat, self.alphaLon];
	
	[self addInfoText:pointsRead];
	pointsRead = [NSString stringWithFormat:@"beta:%f %f %f %f",
							self.betaPoint.x, self.betaPoint.y,
							self.betaLat, self.betaLon];
	
	[self addInfoText:pointsRead];

    pointsRead = [NSString stringWithFormat:@"MapID:%@", self.mapId];
    [self addInfoText:pointsRead];
	
	
  	
	
	
	UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]
									 initWithTarget:self
									 action:@selector(tap4:)];
	
	[self.bildView addGestureRecognizer:tapGr];
	
	
	[self.bildView setUserInteractionEnabled:YES];
	CGRect b = [self.bildView bounds];
	NSLog(@"bild info: Height:%f Width:%f",b.size.height,b.size.width);
	
	self.bildWidth = b.size.width;
	self.bildHeight = b.size.height;
 
	CALayer *myLayer = self.bildView.layer;
    
    
        
       self.bildView.image = [UIImage imageNamed:@"wait_while_loading.png"]; // placeholder image
        PFFile *theFile = (PFFile *)[self.objectToDisplay objectForKey:@"image"]; // remote image
    self.bildView.file = theFile;
    //    self.imageView.backgroundColor = [UIColor redColor];
        [self.bildView loadInBackground];
    
    
    
  /*
    myLayer.contents = (id) self.imageToUse.CGImage;
    myLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    myLayer.borderColor = [UIColor greenColor].CGColor;
    myLayer.borderWidth = 5.0;
	myLayer.shadowOffset = CGSizeMake(0, 3);
    myLayer.shadowRadius = 5.0;
    myLayer.shadowColor = [UIColor blackColor].CGColor;
    myLayer.shadowOpacity = 0.8;
*/	
    
    // Lägger till ett nytt layer för att rita i
    self.customDrawn = [CALayer layer];
    self.customDrawn.delegate = self;
    
   self.customDrawn.frame = CGRectMake(0,0, myLayer.bounds.size.width,
									   myLayer.bounds.size.height);
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
	
    
    CALayer *logLayer = self.textLog.layer;
    logLayer.borderColor = [UIColor blackColor].CGColor;
    logLayer.borderWidth = 5.0;
    
    logLayer.shadowOffset = CGSizeMake(0, 3);
    logLayer.shadowRadius = 5.0;
    logLayer.shadowColor = [UIColor blackColor].CGColor;
    logLayer.shadowOpacity = 0.8;
    
    // the parse id of the "map" used, for identity of the saved alpha and beta points
    self.mapId = [self.objectToDisplay valueForKey:@"objectId"];
    
    
    // test av coord labels i kartan
    [self drawCoordLabels];
}


-(void)drawCoordLabels
{
    UILabel *ulLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 15, 100, 30)];
    [ulLabel setText:[NSString stringWithFormat:@"%f %f", self.ULLat,self.ULLon]];
    [ulLabel setTextColor:[UIColor redColor]];
    [ulLabel setBackgroundColor:[UIColor clearColor]];
    [self.bildView addSubview:ulLabel];
    
    UILabel *urLabel = [[UILabel alloc] initWithFrame:CGRectMake(900, 15, 100, 30)];
    [urLabel setText:[NSString stringWithFormat:@"%f %f", self.URLat,self.URLon]];
    [urLabel setTextColor:[UIColor greenColor]];
    [urLabel setBackgroundColor:[UIColor clearColor]];
    [self.bildView addSubview:urLabel];
    
    UILabel *llLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 730, 100, 30)];
    [llLabel setText:[NSString stringWithFormat:@"%f %f", self.LLLat,self.LLLon]];
    [llLabel setTextColor:[UIColor redColor]];
    [llLabel setBackgroundColor:[UIColor clearColor]];
    [self.bildView addSubview:llLabel];
    
    UILabel *lrLabel = [[UILabel alloc] initWithFrame:CGRectMake(900, 730, 100, 30)];
    [lrLabel setText:[NSString stringWithFormat:@"%f %f", self.LRLat,self.LRLon]];
    [lrLabel setTextColor:[UIColor greenColor]];
    [lrLabel setBackgroundColor:[UIColor clearColor]];
    [self.bildView addSubview:lrLabel];
}



- (void)loadUserDefaults
{
	self.alphaPoint =
	CGPointMake( [[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3AlphaPointXPrefKey],
				[[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3AlphaPointYPrefKey]);
	
	self.alphaLat = [[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3AlphaPointLatPrefKey];
	self.alphaLon = [[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3AlphaPointLonPrefKey];
	
	
	self.betaPoint =
		CGPointMake( [[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3BetaPointXPrefKey],
					[[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3BetaPointYPrefKey]);
	
	self.betaLat = [[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3BetaPointLatPrefKey];
	self.betaLon = [[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3BetaPointLonPrefKey];
    
    self.mapId = [[NSUserDefaults standardUserDefaults] stringForKey:Mappy3MapID];
	
}


- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.bildView.frame;
	
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
	
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
	
    self.bildView.frame = contentsFrame;
}

-(void)viewWillAppear:(BOOL)animated
{
	
	// starta location manager
	if (!self.locationManager) {
		self.locationManager = [[CLLocationManager alloc] init];
		[self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
		[self.locationManager startUpdatingLocation];
		[self.locationManager setDelegate:self];
	}
	
	// Scroll view test
	self.bildView.frame = CGRectMake(0, 0, self.bildView.image.size.width, self.bildView.image.size.height);
	self.scrollView.contentSize = self.bildView.image.size;
	

	/*
	CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
	
	self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
	
	*/
	// end Scroll view test
	// [self centerScrollViewContents];
	 
}

#pragma mark Scroll View Delegate

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.bildView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    NSLog(@"Did end the zoom");
    [self.customDrawn setNeedsDisplay];
}

- (IBAction)showLogPopup:(id)sender {
	
	self.textLog.hidden = !self.textLog.hidden;
//	self.infoField.hidden = !self.infoField.hidden;
/*
	if(!self.isLogPopVisible) {
	
    M3LogViewController *logVC = [[M3LogViewController alloc]
								  initWithText:self.textLog.text];
    if(!self.logPop) {
        self.logPop = [[UIPopoverController alloc] initWithContentViewController:logVC];
     [self.logPop setPassthroughViews:[NSArray arrayWithObject:self.bildView]];
    }
    
	
	
		[self.logPop presentPopoverFromBarButtonItem:self.logButton
						permittedArrowDirections:UIPopoverArrowDirectionAny
										animated:YES];
	
		self.isLogPopVisible = true;
	} else {
		self.isLogPopVisible = false;
		[self.logPop dismissPopoverAnimated:YES];
		self.logPop = nil;
	}
 */
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.customDrawn setNeedsDisplay];
    self.customDrawn.delegate = nil;
    [self.locationManager stopUpdatingLocation];
	self.locationManager = nil;
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
/*
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

*/



- (void)addInfoText:(NSString*)newText {
    
    NSString *oldText = self.textLog.text;
    NSString *textToInsert = [@"\n" stringByAppendingString:newText];
    
	textToInsert = [oldText stringByAppendingString:textToInsert];
    
    [self.textLog setText:textToInsert];
    
    //    UITextPosition *endPos = [self.textLog endOfDocument];
    
    NSRange range = NSMakeRange(self.textLog.text.length - 1, 1);
    [self.textLog scrollRangeToVisible:range];
    
 //   if([self.logPop isPopoverVisible])
//        [self.logPop setTextToShow:textToInsert];
    
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
    
    float x = self.tappedPoint.x;
    float y = self.tappedPoint.y;
    
    x = self.alphaPoint.x;
    y = self.alphaPoint.y;
    NSLog(@"drawLayer");
    /*
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextMoveToPoint(context, x, y);
    CGContextAddLineToPoint(context, x + 5, y + 5);
    CGContextAddLineToPoint(context, x, y + 10);
    CGContextAddLineToPoint(context, x - 5, y + 5);
    CGContextAddLineToPoint(context, x, y);
    CGContextStrokePath(context);
    */
    // Draw a cross
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextMoveToPoint(context, x -5 , y - 5);
    CGContextAddLineToPoint(context, x + 5, y + 5);
    CGContextMoveToPoint(context, x -5 , y + 5);
    CGContextAddLineToPoint(context, x + 5, y - 5);
    CGContextStrokePath(context);
    
    
    x = self.betaPoint.x;
    y = self.betaPoint.y;
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextMoveToPoint(context, x -5 , y - 5);
    CGContextAddLineToPoint(context, x + 5, y + 5);
    CGContextMoveToPoint(context, x -5 , y + 5);
    CGContextAddLineToPoint(context, x + 5, y - 5);
    CGContextStrokePath(context);

    
    
   // [self addInfoText:@"has drawn a marker"];
	
/*
	[self addInfoText:@"Will draw the ruler"];
	
	CGContextSetLineWidth(context, 20.0);
	CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
	CGContextMoveToPoint(context, 20.0, 150-50);
	CGContextAddLineToPoint(context, 120.0, 150-50);
	CGContextStrokePath(context);
*/	

	
	
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
    
	[self addInfoText: @"Starting to calculate the corner coords!"];
	

    float alphaY  = self.alphaPoint.y;						// 150
    float alphaLa = self.alphaCoord.coordinate.latitude;	// 54
    float betaY   = self.betaPoint.y;						// 120
    float betaLa  = self.betaCoord.coordinate.latitude;		// 57
	
	
	// ger X/Y= 0/0 coords	Lat= 59.349384 Long=18.046423
	
	float alphaX  = self.alphaPoint.x; // 647.0;
    float alphaLo =  self.alphaCoord.coordinate.longitude; // 18.064217;
    float betaX   =  self.betaPoint.x; // 315.0
    float betaLo  =  self.betaCoord.coordinate.longitude; // 18.055086;
    float gammaX = 0.0;
	float gammaLo = 0.0; // 22 example for test only

// Check if the coords are the same, then stupid error
	if(( alphaLa == betaLa) && (alphaLo == betaLo)) {
		[TSMessage showNotificationInViewController:self
                                          withTitle:@"Coordinate error"
                                        withMessage:@"the two reference points have the same value!"
                                           withType:TSMessageNotificationTypeError
                                       withDuration:5.0];
		return;
	}
	
	// test värden för alpha = hemma på gatan, beta = bica
/*
    float alphaY  = 164.5; //self.alphaPoint.y; // 150
    float alphaLa = 59.347107; //self.alphaCoord.coordinate.latitude; // 54
    float betaY   = 335.0; //self.betaPoint.y;  // 120
    float betaLa  = 59.344742; //self.betaCoord.coordinate.latitude; // 57
*/
    
    float a,b;
	
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
	
	// Ovan har vi fått Latitud för uppe och nere 
	self.ULLat = gammaLa;
	self.LLLat = epsilonLa;
	
	
	self.URLat = gammaLa;
	self.LRLat = epsilonLa;
	
	
	// LLLat = epsilonLa
	
	
	
	
	
    
	// samma sak för X och Lon
	
	// test värden för alpha = hemma på gatan, beta = bica
		
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
    
	
	self.ULLon = gammaLo;
	self.LLLon = epsilonLo;
	
	
	self.URLon = gammaLo;
	self.LRLon = epsilonLo;

	if (![self uploadCoords] ) {
		[TSMessage showNotificationInViewController:self
                                          withTitle:@"Error"
                                        withMessage:@"something went wrong uploading data"
                                           withType:TSMessageNotificationTypeError
                                       withDuration:5.0];
    }
    
    
    // calculate the midPoint of the area defined by UL och LR
    self.MidLat = (self.ULLat - self.LLLat) / 2.0f + self.LLLat;
    self.MidLon = (self.LRLon -self.LLLon) / 2.0f + self.LLLon;
    
	NSString *midInfo = [NSString stringWithFormat:@"Mid: %f %f", self.MidLat, self.MidLon];
	NSLog(midInfo);
	[self addInfoText:midInfo];

	
}
- (IBAction)uploadCoordsPressed:(id)sender {
	[self uploadCoords];
    
    /*
    // update the labels with new values
    NSArray *views = [self.bildView subviews];
    
    for (UIView *v in views) {
        UILabel *lab = v;
        [lab setText:self.]
    }
 */       
}


- (BOOL)uploadCoords
/*
@property (nonatomic) double ULLat;
@property (nonatomic) double ULLon;
@property (nonatomic) double LLLat;
@property (nonatomic) double LLLon;

@property (nonatomic) double URLat;
@property (nonatomic) double URLon;
@property (nonatomic) double LRLat;
@property (nonatomic) double LRLon;
*/
{
	[self addInfoText:@"Will upload coord to back-end"];
	
	NSString *stringWithUploadCoords;
	PFObject *object = self.objectToDisplay;
	
	[object setObject:[NSNumber   numberWithDouble:self.ULLat] forKey:@"ULLat"];
	[object setObject:[NSNumber   numberWithDouble:self.ULLon] forKey:@"ULLon"];
	
	stringWithUploadCoords = [NSString stringWithFormat:@"ULLat:%f", self.ULLat];
	[self addInfoText:stringWithUploadCoords];
	stringWithUploadCoords = [NSString stringWithFormat:@"ULLong:%f", self.ULLon];
	[self addInfoText:stringWithUploadCoords];
	
	
	
	
	[object setObject:[NSNumber   numberWithDouble:self.LLLat] forKey:@"LLLat"];
	[object setObject:[NSNumber   numberWithDouble:self.LLLon] forKey:@"LLLon"];
	
	stringWithUploadCoords = [NSString stringWithFormat:@"LLLat:%f", self.LLLat];
	[self addInfoText:stringWithUploadCoords];
	stringWithUploadCoords = [NSString stringWithFormat:@"LLLong:%f", self.LLLon];
	[self addInfoText:stringWithUploadCoords];
	
	
	
	
	[object setObject:[NSNumber   numberWithDouble:self.URLat] forKey:@"URLat"];
	[object setObject:[NSNumber   numberWithDouble:self.URLon] forKey:@"URLon"];
	
	stringWithUploadCoords = [NSString stringWithFormat:@"URLat:%f", self.URLat];
	[self addInfoText:stringWithUploadCoords];
	stringWithUploadCoords = [NSString stringWithFormat:@"URLong:%f", self.URLon];
	[self addInfoText:stringWithUploadCoords];
	
	
	
	[object setObject:[NSNumber   numberWithDouble:self.LRLat] forKey:@"LRLat"];
	[object setObject:[NSNumber   numberWithDouble:self.LRLon] forKey:@"LRLon"];
	
	stringWithUploadCoords = [NSString stringWithFormat:@"LRLat:%f", self.LRLat];
	[self addInfoText:stringWithUploadCoords];
	stringWithUploadCoords = [NSString stringWithFormat:@"LRLong:%f", self.LRLon];
	[self addInfoText:stringWithUploadCoords];
	
	
    [object setObject:[NSNumber numberWithDouble:self.MidLat] forKey:@"midCoordLat"];
    [object setObject:[NSNumber numberWithDouble:self.MidLon] forKey:@"midCoordLon"];
    
    
    
	[object save];
	
	

	[TSMessage showNotificationInViewController:self
									  withTitle:@"Upload"
									withMessage:@"Coordinates for the map uploaded"
									   withType:TSMessageNotificationTypeSuccess
								   withDuration:5.0];

	return TRUE;
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
            
			self.alphaLat = self.alphaCoord.coordinate.latitude;
			self.alphaLon = self.alphaCoord.coordinate.longitude;
			
            self.alphaPoint =  self.tappedPoint;
            
            [self addInfoText:tmpStr];
			
			// save for later use
            /*
            [[NSUserDefaults standardUserDefaults] setDouble:self.tappedPoint.x forKey:Mappy3AlphaPointXPrefKey];
            [[NSUserDefaults standardUserDefaults] setDouble:self.tappedPoint.y forKey:Mappy3AlphaPointYPrefKey];
			
            [[NSUserDefaults standardUserDefaults] setDouble:theLat	forKey:Mappy3AlphaPointLatPrefKey];
            [[NSUserDefaults standardUserDefaults] setDouble:theLong	forKey:Mappy3AlphaPointLonPrefKey];
            
            [[NSUserDefaults standardUserDefaults] setValue:self.mapId forKey:Mappy3MapID];
			*/
		//	UIImage *theDot = [M3Helpers dotAnnotationImage];
		//	UIImageView *theDotView = [[UIImageView alloc] initWithImage:theDot];
		//	theDotView.frame = CGRectMake(self.tappedPoint.x, self.tappedPoint.y, 50, 50);
			
		//	[self.bildView addSubview:theDotView];

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
            
			self.betaLat = self.betaCoord.coordinate.latitude;
			self.betaLon = self.betaCoord.coordinate.longitude;
			
            [self addInfoText:tmpStr];
	
            [[NSUserDefaults standardUserDefaults] setDouble:self.tappedPoint.x forKey:Mappy3BetaPointXPrefKey];
            [[NSUserDefaults standardUserDefaults] setDouble:self.tappedPoint.y forKey:Mappy3BetaPointYPrefKey];
			
            [[NSUserDefaults standardUserDefaults] setDouble:theLat	forKey:Mappy3BetaPointLatPrefKey];
            [[NSUserDefaults standardUserDefaults] setDouble:theLong forKey:Mappy3BetaPointLonPrefKey];
     
     }
    }
    
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
	
	NSString *accuracy;
	NSNumber *accNum;
	
	accNum = [NSNumber numberWithDouble:coord.horizontalAccuracy];
//	accuracy = [NSString stringWithFormat:@"accu:%f", coord.horizontalAccuracy   ];
    
	accuracy = [NSString stringWithFormat:@"Acc:%d", [accNum intValue]];
//	NSLog(@"Accuracy:%d", [accNum intValue]);
	[self.accuracyGPS setText:accuracy];
	
	if( [accNum intValue] < 11)
		self.accuracyGPS.backgroundColor = [UIColor greenColor];
	else
		self.accuracyGPS.backgroundColor = [UIColor redColor];
}

- (IBAction)refButtonPressed:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    if(seg.selectedSegmentIndex == 0)
        [self alphaPressed:sender];
    if(seg.selectedSegmentIndex == 1)
        [self betaPressed:sender];
    
}

- (IBAction)alphaPressed:(id)sender {
    
	NSLog(@"Alpha Pressed");
	[self addInfoText:@"If You are at position Alpha, mark it in the picture/map!"];
	self.alphaWillBeMarked = true;
	self.betaWillBeMarked = false;
	
	/*
	// Test av annotations för markering
	M3Annotation *annotation = [[M3Annotation alloc] init];
	
	CGPoint point = CGPointFromString(attraction[@"location"]);
	annotation.coordinate = CLLocationCoordinate2DMake(point.x, point.y);
	annotation.title = attraction[@"name"];
	annotation.type = [attraction[@"type"] integerValue];
	annotation.subtitle = attraction[@"subtitle"];
	[self.mapView addAnnotation:annotation];
*/
/*
	UIImage *theDot = [M3Helpers dotAnnotationImage];
	UIImageView *theDotView = [[UIImageView alloc] initWithImage:theDot];
	theDotView.frame = CGRectMake(self.tappedPoint.x, self.tappedPoint.y, 50, 50);
	[self.bildView addSubview:theDotView];
*/	
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
	
	NSLog(@"Ref VC got Memory Warning!!!!");
	
	
}

@end
