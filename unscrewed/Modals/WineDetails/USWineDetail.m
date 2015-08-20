//
//  WineDetail.m
//  unscrewed
//
//  Created by Robin Garg on 16/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USWineDetail.h"
#import "USReviews.h"

@implementation USWineDetail

- (id)initWithInfo:(id)info {
	self = [super init];
	if (self) {
		[self setWineInfo:info];
	}
	return self;
}

- (void)setWineInfo:(id)info {
	_liked = [[[info valueForKey:likedKey] nonNull] boolValue];
	_wants = [[[info valueForKey:wantsKey] nonNull] boolValue];
	NSDictionary *myComment = [[info valueForKey:myCommentKey] nonNull];
	if (myComment) {
		_myReview = [[USReview alloc] initWithInfo:myComment];
	}
	NSDictionary *wineInfo = [[info valueForKey:wineKey] nonNull];
	[super setWineInfo:wineInfo];
	
	if (self.wineSubType) {
		self.wineSubtypeWithVoice = self.wineSubType;
		NSString *subTypeVoice = [[wineInfo valueForKey:@"s_wine_subtypes_voice"] nonNull];
		if (subTypeVoice) {
			self.wineSubtypeWithVoice = [NSString stringWithFormat:@"%@ (%@)",self.wineSubType, subTypeVoice];
		}
	}
	
	NSString *wineSubtypeDescription = [[wineInfo valueForKey:@"s_wine_subtypes_description"] nonNull];
	NSArray *winePairings = [[wineInfo valueForKey:filterPairingsKey] nonNull];
	NSMutableString *wineDesc = [[NSMutableString alloc] initWithFormat:@"%@ wine. ",self.wineType];
	if (wineSubtypeDescription) {
		[wineDesc appendString:wineSubtypeDescription];
		if (winePairings.count) {
			[wineDesc appendFormat:@"and pairs with %@",[winePairings componentsJoinedByString:@", "]];
		}
	} else if (winePairings.count) {
		[wineDesc appendFormat:@"Pairs with %@",[winePairings componentsJoinedByString:@", "]];
	}
	self.wineAboutDescription = wineDesc;
	
	NSString *region = [[[wineInfo valueForKey:filterRegionsKey] nonNull] firstObject];
	if (region) {
		self.wineRegionWithSubRegion = region;
		NSString *subRegion = [[[wineInfo valueForKey:filterSubRegionsKey] nonNull] firstObject];
		if (subRegion) {
			self.wineRegionWithSubRegion = [NSString stringWithFormat:@"%@ > %@",region, subRegion];
		}
	}
	// Parse Expert Reviews
	NSArray *expertReviews = [[info valueForKey:expertRatingsKey] nonNull];
	if (expertReviews && expertReviews.count) {
		self.objExpertReviews = [[USExpertReviews alloc] initWithExpertReviews:expertReviews];
	}
    // Parse User Reviews
	NSArray *userLikes = [[info valueForKey:userLikesKey] nonNull];
    NSArray *userReviews = [[info valueForKey:userCommentsKey] nonNull];
	self.objUsersReviews = [[USReviews alloc] initWithReviews:userReviews likes:userLikes];

	// Parse Friends & Followings
	NSArray *friendLikes = [[info valueForKey:friendLikesKey] nonNull];
	NSArray *friendReviews = [[info valueForKey:friendCommentsKey] nonNull];
	self.objFriendReviews = [[USReviews alloc] initWithReviews:friendReviews likes:friendLikes];
	self.friendLikesCount = self.objExpertReviews.arrExpertReviews.count;
}

@end
