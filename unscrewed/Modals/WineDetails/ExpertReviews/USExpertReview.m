//
//  ExpertReview.m
//  unscrewed
//
//  Created by Robin Garg on 23/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USExpertReview.h"

@implementation USExpertReview

- (id)initWithExpertReview:(id)expertReview {
	self = [super init];
	if (self) {
		[self setExpertReviewWithInfo:expertReview];
	}
	return self;
}

- (void)setExpertReviewWithInfo:(id)dictExpertReview {
	_expertReviewId = [[dictExpertReview valueForKey:idKey] nonNull];
	_expertRatings = [[[dictExpertReview valueForKey:ratingKey] nonNull] integerValue];
	_expertValue = [HelperFunctions expertValue:_expertRatings];
	_expertReview = [[dictExpertReview valueForKey:reviewTextKey] nonNull];
	NSDictionary *expertInfo = [[dictExpertReview valueForKey:expertInfoKey] nonNull];
	if (expertInfo) {
		_expertId = [[expertInfo valueForKey:idKey] nonNull];
		_expertName = [[expertInfo valueForKey:nameKey] nonNull];
	}
	NSString *postedAtDate = [[dictExpertReview valueForKey:postedAtKey] nonNull];
	if (postedAtDate) {
		_postedAt = [HelperFunctions formattedDateString:postedAtDate];
	}
}

@end
