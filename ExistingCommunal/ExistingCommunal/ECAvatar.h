//
//  ECAvatar.h
//  ExistingCommunal
//
//  Created by Jon Whitmore on 5/5/14.
//  Copyright (c) 2014 Jon Whitmore. All rights reserved.
//

#import <Foundation/Foundation.h>

// Models an Existing Communal's user visual representation
@interface ECAvatar : NSObject {
    CGSize _size;
}

// The height and width of the image
@property CGSize size;

// The URL of the image
@property (strong, nonatomic) NSString *src;

@end
