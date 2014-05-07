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

// TODO: replace this Proof of concept label
@property (strong, nonatomic) IBOutlet UILabel *label;

// Gradient view
@property (strong, nonatomic) IBOutlet UIView *gradientView;

@property (strong, nonatomic) IBOutlet UIImageView *mainImage;

@end
