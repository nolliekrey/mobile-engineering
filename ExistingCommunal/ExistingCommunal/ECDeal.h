//
//  ECDeal.h
//  ExistingCommunal
//
//  Created by Jon Whitmore on 5/5/14.
//  Copyright (c) 2014 Jon Whitmore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECUser.h"

// Models a deal (coupon, discount, etc.) for purchase in the Existing Communal system
@interface ECDeal : NSObject

// Short blurp describing the deal
@property (nonatomic, strong) NSString *monetaryInvestment;

// The business promoting the deal
@property (nonatomic, strong) NSString *sponsor;

// A link to the Existing Communal site for more information
@property (nonatomic, strong) NSString *href;

// The source URL for the image that should acompany the blurp
@property (nonatomic, strong) NSString *src;

// The actual image that should acompany the blurp
@property (nonatomic, strong) UIImage *img;

// The user associated with this deal
@property (nonatomic, strong) ECUser *user;
@end
