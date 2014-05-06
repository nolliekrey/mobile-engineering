//
//  ECUser.h
//  ExistingCommunal
//
//  Created by Jon Whitmore on 5/5/14.
//  Copyright (c) 2014 Jon Whitmore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECAvatar.h"

// Models an Existing Communal user in the system
@interface ECUser : NSObject

// The user's Existing Communal picture
@property (strong, nonatomic) ECAvatar *avatar;

// The user's proper name
@property (strong, nonatomic) NSString *name;

// The user's Existing Communcal system name
@property (strong, nonatomic) NSString *username;

@end
