//
//  M3ListViewController.m
//  Mappy3
//
//  Created by Per Haugsöen on 4/11/13.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import "M3ListViewController.h"
#import "M3ImageDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PHCell.h"
#import "M3ImageViewController.h"
#import "M3RefViewController.h"
#import "M3PictureInfoViewController.h"
#import <TSMessageView.h>
#import "M3GuideViewController.h"

#define LL_NOT_SET @"(lat/lon): NOT SET"

@interface M3ListViewController ()

@property (nonatomic, strong) UIImage *sittaDar;
@property (nonatomic,strong)   UIPopoverController *popover;
@property (nonatomic, strong) PFObject *clickedObjectInTable;

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIPopoverController *pictureInfoPopover;

@property (nonatomic, strong) UIImage *thumbNailImage;

@end


@implementation M3ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
																				   action:@selector(addNewMapPressed:)];
		[[self navigationItem] setRightBarButtonItem:addButton animated:YES];
		
		[[self navigationItem] setTitle:@"Mappy"];
		
		
		NSString *cog = [NSString stringFromAwesomeIcon:FAIconCog];
	
		UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:cog style:UIBarButtonItemStylePlain target:self action:@selector(foo:)];
		
		[[self navigationItem] setLeftBarButtonItem:bar animated:YES];
		
		
    }
    return self;
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        
        self.parseClassName = @"MappyPics";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"picname";
		
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
         self.objectsPerPage = 10;
        
        
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.tableView.backgroundColor = [UIColor lightGrayColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
	self.tableView.separatorColor = [UIColor blackColor];
	self.tableView.rowHeight = 75; // 75 ok
	
//	self.nav
}

- (void)showSettingsPressed:(id)sender
{
	NSLog(@"show settings pressed");
	
}

- (void)addNewMapPressed:(id)sender
{
	NSLog(@"add new map pressed");
	[self selectPicture:sender];
}

// Presents a popover with pictures from photo library
- (IBAction)selectPicture:(id)sender {
	
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
	imgPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    imgPicker.delegate = (id)self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
	self.popover = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
    
	[self.popover presentPopoverFromBarButtonItem:[self.navigationItem rightBarButtonItem] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
	
	
}

// Called when user selects photo from library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo
{
    self.selectedImage = img;
    
    [[self popover] dismissPopoverAnimated:YES];
    
//    self.pictuewV.image = img;
	
	// skapa och visa ny popover med bild och dess info
	M3PictureInfoViewController *picInfoVC = [[M3PictureInfoViewController alloc] initWithPicture:img];
	
	[[self navigationController] setModalPresentationStyle:UIModalPresentationFormSheet];
//	[[self navigationController] presentViewController:picInfoVC animated:YES completion:nil];
//	[self presentViewController:picInfoVC animated:YES completion:nil];
	[[self navigationController] pushViewController:picInfoVC animated:YES];



    
//    self.widthOfImage.text = [NSString stringWithFormat:@"%f",self.selectedImage.size.width];
//    self.heightOfImage.text = [NSString stringWithFormat:@"%f",self.selectedImage.size.height];
//    self.viewWithLabels.hidden = FALSE;
    
	
    [self createTN];
    
    
    
}


- (void)createTN
{
    
    UIImage *thumbNailImage = [self.selectedImage copy];
    
    CGRect imageRect = CGRectMake(0.0, 0.0, 72, 72);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(72, 72), YES, [UIScreen mainScreen].scale);
    
    [thumbNailImage drawInRect:imageRect];
	
    
    //   self.appRecord.appIcon = UIGraphicsGetImageFromCurrentImageContext();  // UIImage returned.
    UIGraphicsEndImageContext();

    self.thumbNailImage = thumbNailImage;
    
}


- (void)showPictureInfoPopover
{
}

- (IBAction)editPressed:(id)sender {
	NSLog(@"Edit pressed in ListVC");
	
    
    // Måste ta reda på vilket objekt det är som jag klickar på.....
    
    UIButton *tappedButton = (UIButton*)sender;
	

	UIView *cellContentView = (UIView *)tappedButton.superview;
	PHCell *tableViewCell = (PHCell *)cellContentView.superview;
    UITableView* tableView = (UITableView *)tableViewCell.superview;
  
	NSIndexPath* pathOfTheCell = [tableView indexPathForCell:tableViewCell];
    NSInteger rowOfTheCell = pathOfTheCell.row;
    NSLog(@"rowofthecell %d", rowOfTheCell);
	
	PFObject *editSelectedObject = [self objectAtIndexPath:pathOfTheCell];
	self.clickedObjectInTable = editSelectedObject;
	
    
	M3RefViewController *refVC = [[M3RefViewController alloc] initWithObject:self.clickedObjectInTable];
	
	[[self navigationController] pushViewController:refVC animated:NO];
}


#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    //    [query orderByAscending:@"oa"];
	[query orderByDescending:@"updatedAt"];
    
    return query;
}


- (NSString*)createNiceDateTime:(NSDate*)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *result = [formatter stringForObjectValue:date];

	return result;

}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object

{
    
	PHCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PHCell"];
	
	if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PHCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
    }
	
	NSString *tmpName = [object objectForKey:@"picname"];
	if (tmpName) {
		cell.name.text = tmpName;
		NSLog(@"Name of cell:%@", tmpName);
	}
	else
		NSLog(@"Name is NIL from DB");
    
 //   [cell.name setFont:[UIFont fontWithName:@"FontAwesome" size:10.0]];

	
	NSNumber *sizeNumber = [object objectForKey:@"size"];
	
	NSString *sizeNice = [NSByteCountFormatter stringFromByteCount:[sizeNumber longValue]
								   countStyle:NSByteCountFormatterCountStyleFile];
	 
	cell.size.text = [@"" stringByAppendingString:sizeNice];
	
	
	cell.height.text = [@"h: " stringByAppendingString:[[object objectForKey:@"height"] stringValue]];
	
	 
	cell.width.text = [@"w: " stringByAppendingString:[[object objectForKey:@"width"] stringValue]];
	
	cell.user.text = [@"user: " stringByAppendingString:[object objectForKey:@"user"]];
	
	cell.upperLeft.text = [self createULwithLat:[object objectForKey:@"ULLat"]
										andLong:[object objectForKey:@"ULLon"]];
	
	
	cell.lowerRight.text = [self createLRwithLat:[object objectForKey:@"LRLat"]
										 andLong:[object objectForKey:@"LRLon"]];
	
	/*
	PFFile *thumbnail = [object objectForKey:@"thumbnail"];
	cell.imageView.image = [UIImage imageNamed:@"dummy.png"];
	cell.imageView.file = thumbnail;
	cell.thumbnailImageView.image = [UIImage imageWithData:[thumbnail getData]];
	*/
    
    PFFile *thumbnail = [object objectForKey:@"thumbnail"];
//	cell.imageView.image = [UIImage imageNamed:@"dummy.png"];
//	cell.imageView.file = thumbnail;
	cell.thumbnailImageView.image = [UIImage imageWithData:[thumbnail getData]];

	// layer stuff for corner and effect
	cell.thumbnailImageView.layer.shadowOffset = CGSizeMake(0, 3);
	cell.thumbnailImageView.layer.shadowRadius = 5.0;
	cell.thumbnailImageView.layer.shadowColor = [UIColor blackColor].CGColor;
	cell.thumbnailImageView.layer.shadowOpacity = 0.8;
    // end layer stuff
	
	
	NSDate *tmpDate = object.updatedAt;
	
	
	NSString *date1 = [NSDateFormatter localizedStringFromDate:tmpDate
													 dateStyle:NSDateFormatterShortStyle
													 timeStyle:NSDateFormatterShortStyle];
					
					   // tmpDate descriptionWithLocale:[NSLocale currentLocale]];
	

	cell.date.text = date1; //[self createNiceDateTime:tmpDate];
	
	cell.textLabel.text = @"";
	cell.detailTextLabel.text = @"";
	
	// star
	cell.starButton = [BButton awesomeButtonWithOnlyIcon:FAIconStar type:BButtonTypeGray];
	
	cell.starButton = [[BButton alloc] initWithFrame:CGRectMake(830,21,40,40)
											   color:[UIColor grayColor] icon:FAIconStar fontSize:14.0];
	[cell.starButton addTarget:self action:@selector(starButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	
	
//	[cell.starButton setType:BButtonTypeGray];
	
	if( [object objectForKey:@"fav"] ) {
		[cell.starButton.titleLabel setTextColor:[UIColor yellowColor]];
	} else
		[cell.starButton.titleLabel setTextColor:[UIColor whiteColor]];
	
	[cell.contentView addSubview:cell.starButton];
	// end star
	
    // edit button
    
    cell.editButton = [[BButton alloc] initWithFrame:CGRectMake(890,21,40,40)
											   color:[UIColor grayColor] icon:FAIconMapMarker fontSize:30.0];
    [cell.contentView addSubview:cell.editButton];
    [cell.editButton addTarget:self action:@selector(editPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // end edit
	
	// guide
	cell.guideButton = [[BButton alloc] initWithFrame:CGRectMake(950,21,40,40)
											   color:[UIColor grayColor] icon:FAIconRoad fontSize:30.0];
    [cell.contentView addSubview:cell.guideButton];
    [cell.guideButton addTarget:self action:@selector(guidePressed:) forControlEvents:UIControlEventTouchUpInside];
	
	
	// If we got the refed LL, set name in green
//	if (![cell.upperLeft.text isEqualToString:LL_NOT_SET])
//		cell.name.textColor = [UIColor greenColor];
    
    return cell;
}


-(void)guidePressed:(id)sender
{
/*
	NSLog(@"guide pressed");
	
	[TSMessage showNotificationInViewController:self
									  withTitle:@"Not Yet Implemented"
									withMessage:@"This function is not yet implemented. Soon it will have the ability to guide You to Your destination!"
									   withType:TSMessageNotificationTypeMessage
								   withDuration:10.0];
   */
    
    // Måste ta reda på vilket objekt det är som jag klickar på.....
    UIButton *tappedButton = (UIButton*)sender;
	
	
	UIView *cellContentView = (UIView *)tappedButton.superview;
	PHCell *tableViewCell = (PHCell *)cellContentView.superview;
    UITableView* tableView = (UITableView *)tableViewCell.superview;
	
	NSIndexPath* pathOfTheCell = [tableView indexPathForCell:tableViewCell];
    NSInteger rowOfTheCell = pathOfTheCell.row;
    NSLog(@"rowofthecell %d", rowOfTheCell);
	
	PFObject *editSelectedObject = [self objectAtIndexPath:pathOfTheCell];

    
    M3GuideViewController *guideVC = [[M3GuideViewController alloc] initWithObject:editSelectedObject];
    
    [TSMessage showNotificationInViewController:guideVC
									  withTitle:@"Not Yet Implemented"
									withMessage:@"This function is not yet implemented correctly. Soon it will have the ability to guide You to Your destination!"
									   withType:TSMessageNotificationTypeMessage
								   withDuration:10.0];
	
	[[self navigationController] pushViewController: guideVC animated:NO];
	
}

-(void)starButtonPressed:(id)sender
{
	NSLog(@"Star Button");
	
	BButton *btn = (BButton*)sender;
    
    // change color of the star
    if( [btn.titleLabel textColor] == [UIColor yellowColor])
        [btn.titleLabel setTextColor:[UIColor grayColor]];
    else
        [btn.titleLabel setTextColor:[UIColor yellowColor]];
	
	
    // Måste ta reda på vilket objekt det är som jag klickar på.....
    UIButton *tappedButton = (UIButton*)sender;
	
	
	UIView *cellContentView = (UIView *)tappedButton.superview;
	PHCell *tableViewCell = (PHCell *)cellContentView.superview;
    UITableView* tableView = (UITableView *)tableViewCell.superview;
	
	NSIndexPath* pathOfTheCell = [tableView indexPathForCell:tableViewCell];
    NSInteger rowOfTheCell = pathOfTheCell.row;
    NSLog(@"rowofthecell %d", rowOfTheCell);
	
	PFObject *editSelectedObject = [self objectAtIndexPath:pathOfTheCell];
	
	BOOL starred = [[editSelectedObject valueForKey:@"fav"] boolValue];
    
    if(starred)
        [editSelectedObject setObject:[NSNumber numberWithBool:FALSE] forKey:@"fav"];
    else
        [editSelectedObject setObject:[NSNumber numberWithBool:TRUE] forKey:@"fav"];

	[editSelectedObject save];
}



-(NSString*) createULwithLat:(NSNumber*)lat andLong:(NSNumber*) lon
{
	NSString *result;
	
	if( ( abs([lat floatValue])  < 0.001) || (abs([lon floatValue]) < 0.001))
		return LL_NOT_SET;
	
	
	result = [NSString stringWithFormat:@"UL (lat/lon):%f / %f", [lat doubleValue], [lon doubleValue]];
	
	return result;
}

-(NSString*) createLRwithLat:(NSNumber*)lat andLong:(NSNumber*) lon
{
	NSString *result;
	
	if( (abs([lat floatValue]) < 0.001) || (abs([lon floatValue]) < 0.001))
		return LL_NOT_SET;
	
	result = [NSString stringWithFormat:@"LR (lat/lon):%f / %f", [lat doubleValue], [lon doubleValue]];
	
	return result;
}



 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 
	 return [self.objects objectAtIndex:indexPath.row];
 }


/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - Table view data source


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        // [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        self.clickedObjectInTable = [self objectAtIndexPath:indexPath];
        
        [self.clickedObjectInTable deleteInBackground];
        [self loadObjects];
        
        
        
    }
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
	}
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}


 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
     return YES;
 }

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    
    
      PFObject *foo = [self objectAtIndexPath:indexPath];
    
   	
	M3ImageViewController *imageVC = [[M3ImageViewController alloc] initWithObject:foo];
    

    
//    [imageVC setObjectToDisplay:[self objectAtIndexPath:indexPath]];
    [self.navigationController pushViewController:imageVC animated:YES];
    
}


- (BOOL) shouldAutorotate {return FALSE; }

- (NSUInteger)supportedInterfaceOrien { return UIInterfaceOrientationMaskLandscape; }















// Prova om detta gör någon skillnad
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
   
 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}









- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
