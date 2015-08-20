//
//  USReview.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 23/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USReview.h"

@implementation USReview

- (id)initWithUserInfo:(id)userInfo {
    self = [super init];
    if (self) {
		[self fillUserInfo:userInfo];
	}
    return self;
}

- (id)initWithInfo:(id)info {
    self = [super init];
    if (self) {
        [self fillReviewInfo:info];
    }
    return self;
}

- (id)initWithUserInfo:(id)userInfo liked:(BOOL)liked {
	self = [super init];
	if (self) {
		[self fillUserInfo:userInfo];
		self.liked = liked;
	}
	return self;
}

- (id)initWithInfo:(id)info liked:(BOOL)liked {
	self = [super init];
	if (self) {
		[self fillReviewInfo:info];
		self.liked = liked;
	}
	return self;
}

- (void)fillReviewInfo:(NSDictionary *)info {
    self.reviewId = [[info valueForKey:idKey] nonNull];
    self.reviewRatingCount = [[[info valueForKey:ratingKey] nonNull] integerValue];
	self.userRated = self.reviewRatingCount > 0;
    self.reviewTitle = [[info valueForKey:titleKey] nonNull];
    self.reviewDescription = [[info valueForKey:bodyKey] nonNull];
	NSString *dateString = [[info valueForKey:createdAtKey] nonNull];
	if (dateString) {
		self.reviewTime = [HelperFunctions formattedDateString:dateString];
	}
    NSDictionary *userInfo = [[info valueForKey:userKey] nonNull];
	[self fillUserInfo:userInfo];
}

- (void)fillUserInfo:(id)userInfo {
	self.userId = [[userInfo valueForKey:idKey] nonNull];
	self.userName = [[userInfo valueForKey:userNameKey] nonNull];
	_userName = [[userInfo valueForKey:userNameKey] nonNull];
	if (_userName == nil) {
		NSString *_email = [[userInfo valueForKey:emailKey] nonNull];
		if (_email.length > 0) {
			_userName = [[_email componentsSeparatedByString:@"@"] firstObject];
		}
	}
	self.userBio = [[userInfo valueForKey:bioKey] nonNull];
	self.userAddress = [[userInfo valueForKey:locationKey] nonNull];
	self.userImageUrl = [[userInfo valueForKey:avatarKey] nonNull];
	self.userLiked = [[[userInfo valueForKey:likedKey] nonNull] boolValue];
	self.userRated = [[[userInfo valueForKey:likedKey] nonNull] boolValue];// FIXME : update to rated key
}

@end
