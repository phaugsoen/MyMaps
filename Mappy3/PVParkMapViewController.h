#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import <Parse/Parse.h>

@interface PVParkMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate,
MFMailComposeViewControllerDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;

- (IBAction)mapTypeChanged:(id)sender;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITextField *infoField;
@property (nonatomic,strong) UIImage *imageToUse;

@property (nonatomic, strong) PFObject *objectToUse;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *showRealMapButton;


@end
