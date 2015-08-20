//
//  USReviews.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 23/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USReviews.h"
#import "HTTPRequestManager.h"

@implementation USReviews

- (id)initWithReviews:(NSArray *)reviews {
    self = [super init];
    if (self) {
        [self parseReviews:reviews];
    }
    return self;
}

- (id)initWithReviews:(NSArray *)reviews likes:(NSArray *)likes {
	self = [super init];
	if (self) {
		[self parseReviews:reviews likes:likes];
	}
	return self;
}

- (id)initWithFollowing:(NSArray *)followings {
    self = [super init];
    if (self) {
        [self parseFollowings:followings];
    }
    return self;
}

#pragma mark - Get Reviews
- (void)getReviewsForWineId:(NSString *)wineId isUserReviews:(BOOL)userReviews target:(id)target completion:(SEL)completion failure:(SEL)failure {
    HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
    NSString *strUrl = [NSString stringWithFormat:urlReviewsForWineId,wineId];
    [manager GET:strUrl parameters:@{@"is_user_reviews":@(userReviews)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject valueForKey:successKey] boolValue]) {
                // parse
                [self parseReviewsData:[responseObject nonNull]];

                // update UI
                [target performSelectorOnMainThread:completion withObject:nil waitUntilDone:NO];
            } else {
                NSString *errorMsg = [responseObject objectForKey:messageKey];
                [target performSelectorOnMainThread:failure withObject:errorMsg waitUntilDone:NO];
            }
        } else {
            // Unknown data received.
            [target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
    }];
}

- (void)parseReviewsData:(id)dictionaryReviews {
    // page handling
    self.currentPage = [[[dictionaryReviews valueForKey:currentPageKey] nonNull] integerValue];
    NSInteger total = [[[dictionaryReviews valueForKey:winesCountKey] nonNull] integerValue];
    NSInteger totalPages = (NSInteger)ceilf((float)total/(float)DATA_PAGE_SIZE);
    self.isReachedEnd = (totalPages == self.currentPage);
    
    // reviews
    NSArray *reviews = [[dictionaryReviews valueForKey:@"reviews"] nonNull];
    [self parseReviews:reviews];
}

- (void)parseReviews:(NSArray *)arrayReviews {
    if (!arrayReviews || arrayReviews.count == 0) return;
    if (!self.arrReviews) {
        self.arrReviews = [NSMutableArray new];
    }
    //FIXME: remove below line of reversing objects order.
    arrayReviews = [[arrayReviews reverseObjectEnumerator] allObjects];
    for (id review in arrayReviews) {
        USReview *objReview = [[USReview alloc] initWithInfo:review];
        [self.arrReviews addObject:objReview];
    }
}

- (void)parseReviews:(NSArray *)arrayReviews likes:(NSArray *)arrayLikes {
	if ((!arrayReviews || arrayReviews.count == 0) &&
		(!arrayLikes || arrayLikes.count == 0))	return;
	if (!self.arrReviews) {
		self.arrReviews = [NSMutableArray new];
	}
	// Get ids of users
	NSArray *likedFriendIds = [arrayLikes valueForKey:idKey];
	NSArray *ratedFriendIds = [arrayReviews valueForKeyPath:[NSString stringWithFormat:@"%@.%@",userKey,idKey]];
	// Get common friends ids
	NSMutableSet *likedFriendsSet = [[NSMutableSet alloc] initWithArray:likedFriendIds];
	NSSet *ratedFriendsSet = [[NSSet alloc] initWithArray:ratedFriendIds];
	[likedFriendsSet intersectSet:ratedFriendsSet];
	NSArray *commenIds = [likedFriendsSet allObjects];
	// Parse Reviews
	for (id review in arrayReviews) {
		BOOL isLiked = [commenIds containsObject:[review valueForKeyPath:[NSString stringWithFormat:@"%@.%@",userKey,idKey]]];
		USReview *objReview = [[USReview alloc] initWithInfo:review liked:isLiked];
		[self.arrReviews addObject:objReview];
	}
	// Parse Likes
	for (id userInfo in arrayLikes) {
		if ([commenIds containsObject:[userInfo valueForKey:idKey]]) continue;
		USReview *objReview = [[USReview alloc] initWithUserInfo:userInfo liked:YES];
		[self.arrReviews addObject:objReview];
	}
}

- (void)parseFollowings:(NSArray *)arrayFollowings {
    if (!arrayFollowings || arrayFollowings.count == 0) return;
    if (!self.arrReviews) {
        self.arrReviews = [NSMutableArray new];
    }
    for (id user in arrayFollowings) {
        USReview *objReview = [[USReview alloc] initWithUserInfo:user];
        [self.arrReviews addObject:objReview];
    }
}


#pragma mark - Post Loggedin User Review
- (void)postReviewOfLoggedInUserForWineId:(NSString *)wineId withInfo:(NSDictionary *)info target:(id)target completion:(SEL)completion failure:(SEL)failure {
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	NSString *strUrl = [NSString stringWithFormat:urlPostReviewForWineId,wineId];
	[manager POST:strUrl parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				[target performSelectorOnMainThread:completion withObject:responseObject waitUntilDone:NO];
			} else {
				NSString *error = [[responseObject valueForKey:messageKey] nonNull];
				[target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
			}
		} else {
			// Unknown data received.
			[target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
	}];
}

- (void)postLoggedInUserReviewForStoreId:(NSString *)storeId withInfo:(NSDictionary *)info target:(id)target completion:(SEL)completion failure:(SEL)failure {
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	NSString *strUrl = [NSString stringWithFormat:urlPostReviewForStoreId,storeId];
	[manager POST:strUrl parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				[target performSelectorOnMainThread:completion withObject:responseObject waitUntilDone:NO];
			} else {
				NSString *error = [[responseObject valueForKey:messageKey] nonNull];
				[target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
			}
		} else {
			// Unknown data received.
			[target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
	}];
}

@end
