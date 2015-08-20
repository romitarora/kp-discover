//
//  USSnappedWine.h
//  unscrewed
//
//  Created by Robin Garg on 19/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USWine.h"

@interface USSnappedWine : USWine

@property (nonatomic, strong) NSString *postedOn;
@property (nonatomic, assign) BOOL assignedOnServer;
// FIXME: TEMP ADDED PROPERTY
@property (nonatomic, strong) UIImage *snappedImage;

@end
