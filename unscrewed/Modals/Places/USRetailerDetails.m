//
//  USRetailerDetails.m
//  unscrewed
//
//  Created by Robin Garg on 25/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USRetailerDetails.h"

@implementation USRetailerDetails

- (instancetype)initWithInfo:(id)info {
	self = [super init];
	if (self) {
		[self setRetailerInfo:info];
	}
	return self;
}

- (void)setRetailerInfo:(id)info {
	NSDictionary *dict = [[info valueForKey:placeKey] nonNull];
	[super setRetailerInfo:dict];
	
	self.favorited = [[[info valueForKey:likedKey] nonNull] boolValue];
	NSDictionary *myComment = [[info valueForKey:myCommentKey] nonNull];
	if (myComment) {
		_myReview = [[USReview alloc] initWithInfo:myComment];
	}
    
    NSArray *friendLikes = [[info valueForKey:friendLikesPlaceKey] nonNull];
    self.friendLikesCount = friendLikes.count;
    if (friendLikes && friendLikes.count) {
        self.objFriendLikes = [[USUsers alloc] initWithFriends:friendLikes];
    }
    
	_storeReviewsCount = [[[info valueForKey:userCommentsTotalKey] nonNull] integerValue];
	if (_storeReviewsCount > 0) {
		NSArray *arrUserComments = [[info valueForKey:userCommentsKey] nonNull];
		_storeReviews = [[USReviews alloc] initWithReviews:arrUserComments];
	}
}

@end
