//
//  USFollowingUser.m
//  unscrewed
//
//  Created by Robin Garg on 17/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USFollowingUser.h"

@implementation USFollowingUser

// facebook info
- (void)setUserFacebookInfo:(NSDictionary *)info {
	[super setUserFacebookInfo:info];
	
	_unfollowedUser = ![[[info valueForKey:followingKey] nonNull] boolValue];
}

@end
