//
//  ECDealTableViewCell.h
//  ExistingCommunal
//
//  Created by Jon Whitmore on 5/6/14.
//  Copyright (c) 2014 Jon Whitmore. All rights reserved.
//

#import <UIKit/UIKit.h>

// A tableview cell for Existing Communal deal display
@interface ECDealTableViewCell : UITableViewCell

// For text describing the deal to be purchased
@property (strong, nonatomic) IBOutlet UILabel *dealLabel;

// For the entity sponsoring a deal
@property (strong, nonatomic) IBOutlet UILabel *sponsorLabel;

// Gradient view to display text over
@property (strong, nonatomic) IBOutlet UIView *gradientView;

// The large image picturing the deal offered
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;

// The background of the avatar and it's label
@property (strong, nonatomic) IBOutlet UIView *avatarView;

// The associated user's avatar
@property (strong, nonatomic) IBOutlet UIImageView *avatar;

// The avatar's associated text
@property (strong, nonatomic) IBOutlet UILabel *avatarLabel;

@end
