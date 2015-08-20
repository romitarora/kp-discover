//
//  USFollowingUser.h
//  unscrewed
//
//  Created by Robin Garg on 17/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USUser.h"

@interface USFollowingUser : USUser

@property (nonatomic, assign) BOOL unfollowedUser;

// facebook info
- (void)setUserFacebookInfo:(NSDictionary *)info;

@end
