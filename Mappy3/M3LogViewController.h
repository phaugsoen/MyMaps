//
//  M3LogViewController.h
//  Mappy3
//
//  Created by Per Haugsöen on 4/19/13.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M3LogViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *logText;
@property (nonatomic, strong) NSString *textToShow;

-(id)initWithText:(NSString*)text;
@end
