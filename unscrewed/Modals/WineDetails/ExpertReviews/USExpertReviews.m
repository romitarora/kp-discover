//
//  ExpertReviews.m
//  unscrewed
//
//  Created by Robin Garg on 23/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USExpertReviews.h"

@implementation USExpertReviews

- (id)initWithExpertReviews:(NSArray *)expertReviwes {
	self = [super init];
	if (self) {
		[self parseExpertReviews:expertReviwes];
	}
	return self;
}

- (void)parseExpertReviews:(NSArray *)arrExpertReviews {
	if (!arrExpertReviews || arrExpertReviews.count == 0) return;
	if (!self.arrExpertReviews) {
		self.arrExpertReviews = [NSMutableArray new];
	}
	for (id info in arrExpertReviews) {
		USExpertReview *expertReview = [[USExpertReview alloc] initWithExpertReview:info];
		[self.arrExpertReviews addObject:expertReview];
	}
}
@end
