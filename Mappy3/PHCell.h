//
//  PHCell.h
//  Mappy2
//
//  Created by Per on 2013-04-11.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

// just a dummt change to make git wake

#import <Parse/Parse.h>
#import <BButton.h>

@interface PHCell : PFTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *size;
@property (nonatomic, weak) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *user;

@property (nonatomic, weak) IBOutlet UILabel *upperLeft;
@property (nonatomic, weak) IBOutlet UILabel *lowerRight;

@property (nonatomic, weak) IBOutlet UILabel *height;
@property (nonatomic, weak) IBOutlet UILabel *width;


@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@property (nonatomic, strong) IBOutlet BButton *starButton;
@property (strong, nonatomic) IBOutlet BButton *editButton;
@property (strong, nonatomic) IBOutlet BButton *guideButton;


@end
