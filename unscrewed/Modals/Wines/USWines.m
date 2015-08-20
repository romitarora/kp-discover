//
//  USWines.m
//  unscrewed
//
//  Created by Robin Garg on 09/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USWines.h"
#import "HTTPRequestManager.h"
#import "USReview.h"

@implementation USWines

- (void)parseWines:(NSArray *)wines {
	if (!wines || wines.count == 0) return;
	if (!self.arrWines) {
		self.arrWines = [NSMutableArray new];
	}
	for (id wine in wines) {
		USWine *objWine = [[USWine alloc] initWithInfo:wine];
		[self.arrWines addObject:objWine];
	}
}

- (void)parseMySavedLikedWines:(NSArray *)liked want:(NSArray *)wants rated:(NSArray *)rated {
	NSMutableArray *ratedWinesIds = [[rated valueForKey:idKey] mutableCopy];
	NSMutableArray *likedWinesIds = [[liked valueForKey:idKey] mutableCopy];
	NSMutableArray *wantWinesIds = [[wants valueForKey:idKey] mutableCopy];
	
	// Compare Rated and Liked
	NSMutableSet *ratedWinesSet = [[NSMutableSet alloc] initWithArray:ratedWinesIds];
	NSSet *likedWinesSet = [NSSet setWithArray:likedWinesIds];
	[ratedWinesSet intersectSet:likedWinesSet];
	NSArray *arrCommonLikedIds = [ratedWinesSet allObjects];
	[likedWinesIds removeObjectsInArray:arrCommonLikedIds];
	
	// Compare Rated&Liked With Want
	[ratedWinesIds addObjectsFromArray:likedWinesIds];
	NSMutableSet *ratedAndLikedWinesSet = [[NSMutableSet alloc] initWithArray:ratedWinesIds];
	NSSet *wantsWinesSet = [[NSSet alloc] initWithArray:wantWinesIds];
	[ratedAndLikedWinesSet intersectSet:wantsWinesSet];
	NSArray *commonWantsIds = [ratedAndLikedWinesSet allObjects];
	[wantWinesIds removeObjectsInArray:commonWantsIds];
	
	if (!self.arrWines) {
		self.arrWines = [NSMutableArray new];
	}
	// Parse Rated
	for (id ratedWine in rated) {
		USWine *objWine = [[USWine alloc] initWithInfo:ratedWine];
		[self.arrWines addObject:objWine];
	}
	// Parse Liked
	NSPredicate *predicateLikedWines = [NSPredicate predicateWithFormat:@"id IN %@",likedWinesIds];
	NSArray *filteredLikedWines = [liked filteredArrayUsingPredicate:predicateLikedWines];
	for (id likedWine in filteredLikedWines) {
		USWine *objWine = [[USWine alloc] initWithInfo:likedWine];
		[self.arrWines addObject:objWine];
	}
	// Parse Wants
	NSPredicate *predicateWantsWines = [NSPredicate predicateWithFormat:@"id IN %@",wantWinesIds];
	NSArray *filteredWantWines = [wants filteredArrayUsingPredicate:predicateWantsWines];
	for (id wantWine in filteredWantWines) {
		USWine *objWine = [[USWine alloc] initWithInfo:wantWine];
		[self.arrWines addObject:objWine];
	}
}

- (void)parseAutofillWinesWithResult:(NSDictionary *)result {
	self.currentPage = [[[result valueForKey:pageKey] nonNull] integerValue];
	NSInteger lastPageIndex = [[[result valueForKey:@"nbPages"] nonNull] integerValue]-1;
	self.isReachedEnd = (lastPageIndex <= self.currentPage);
	if (self.currentPage == 0) {
		[self.arrWines removeAllObjects];
	}
	[self parseWines:[result valueForKey:@"hits"]];
}

- (void)getWinesWithParams:(NSMutableDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure {
	[params setObject:@(self.currentPage+1) forKey:pageKey];
	[params setObject:@(DATA_PAGE_SIZE) forKey:perPageKey];
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager GET:urlWines parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				self.currentPage = [[[responseObject valueForKey:currentPageKey] nonNull] integerValue];
				NSInteger total = [[[responseObject valueForKey:winesCountKey] nonNull] integerValue];
				NSInteger totalPages = (NSInteger)ceilf((float)total/(float)DATA_PAGE_SIZE);
				self.isReachedEnd = (totalPages == self.currentPage);
				[self parseWines:[[responseObject valueForKey:winesKey] nonNull]];
				[target performSelectorOnMainThread:completion withObject:responseObject waitUntilDone:NO];
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

- (void)getFriendLikeWinesWithParams:(NSMutableDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure {
    //FIXME: need to check this from backend:
    [params setObject:@(1) forKey:pageKey];
    [params setObject:@(1000) forKey:perPageKey];
    HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
    [manager GET:urlWines parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Parse Result
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject valueForKey:successKey] boolValue]) {
                self.currentPage = [[[responseObject valueForKey:currentPageKey] nonNull] integerValue];
                NSInteger total = [[[responseObject valueForKey:winesCountKey] nonNull] integerValue];
                NSInteger totalPages = (NSInteger)ceilf((float)total/(float)DATA_PAGE_SIZE);
                self.isReachedEnd = (totalPages == self.currentPage);
                [self parseWines:[[responseObject valueForKey:winesKey] nonNull]];
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

- (void)getMyWinesWithParams:(NSMutableDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure {
	[params setObject:@(self.currentPage+1) forKey:pageKey];
	[params setObject:@(DATA_PAGE_SIZE) forKey:perPageKey];
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager GET:urlUserWines parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				self.currentPage = [[[responseObject valueForKey:currentPageKey] nonNull] integerValue];
				NSInteger total = [[[responseObject valueForKey:winesCountKey] nonNull] integerValue];
				NSInteger totalPages = (NSInteger)ceilf((float)total/(float)DATA_PAGE_SIZE);
				self.isReachedEnd = (totalPages == self.currentPage);
				
				NSArray *arrLikedWines = [[responseObject valueForKey:kMyWinesFilterLikeValue] nonNull];
				NSArray *arrWantWines = [[responseObject valueForKey:kMyWinesFilterWantValue] nonNull];
				NSArray *arrRatedWines = [[responseObject valueForKey:kMyWinesFilterRateValue] nonNull];
				[self parseMySavedLikedWines:arrLikedWines want:arrWantWines rated:arrRatedWines];
				
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

- (void)likeWineWithId:(NSString *)wineId target:(id)target completion:(SEL)completion failure:(SEL)failure {
	NSString *urlLikeWine = [NSString stringWithFormat:urlLikeUnlikeWinesWithWineId,wineId];
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager POST:urlLikeWine parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				[target performSelectorOnMainThread:completion withObject:@(YES) waitUntilDone:NO];
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

- (void)unlikeWineWithId:(NSString *)wineId target:(id)target completion:(SEL)completion failure:(SEL)failure {
	NSString *urlUnlikeWine = [NSString stringWithFormat:urlLikeUnlikeWinesWithWineId,wineId];
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager DELETE:urlUnlikeWine parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				[target performSelectorOnMainThread:completion withObject:@(NO) waitUntilDone:NO];
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

- (void)wantWineWithId:(NSString *)wineId target:(id)target completion:(SEL)completion failure:(SEL)failure {
	NSString *urlWantWine = [NSString stringWithFormat:urlWantWineWithWineId,wineId];
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager POST:urlWantWine parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				[target performSelectorOnMainThread:completion withObject:@(YES) waitUntilDone:NO];
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

- (void)removeWantWineWithId:(NSString *)wineId target:(id)target completion:(SEL)completion failure:(SEL)failure {
	NSString *urlRemoveWantWine = [NSString stringWithFormat:urlWantWineWithWineId,wineId];
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager DELETE:urlRemoveWantWine parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				[target performSelectorOnMainThread:completion withObject:@(NO) waitUntilDone:NO];
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

- (void)rateWineWithId:(NSString *)wineId param:(NSDictionary *)param target:(id)target completion:(SEL)completion failure:(SEL)failure {
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	NSString *strUrl = [NSString stringWithFormat:urlPostReviewForWineId,wineId];
	[manager POST:strUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				NSDictionary *comment = [[responseObject valueForKey:commentKey] nonNull];
				USReview *myReview = [[USReview alloc] initWithInfo:comment];
				[target performSelectorOnMainThread:completion withObject:myReview waitUntilDone:NO];
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

- (void)deleteWineWithId:(NSString *)wineId target:(id)target completion:(SEL)completion failure:(SEL)failure {
	NSString *strUrl = [NSString stringWithFormat:urlExcludeWines,wineId];

	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager POST:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				[target performSelectorOnMainThread:completion withObject:@(YES) waitUntilDone:NO];
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

- (BOOL)findWinesForQueryString:(NSDictionary *)params {
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlWines parameters:params error:nil];
	
	NSURLResponse* response;
	NSError* error = nil;
	//Capturing server response
	NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
	if (!error) {
		id responseObject = [manager.responseSerializer responseObjectForResponse:response data:result error:&error];
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				self.currentPage = [[[responseObject valueForKey:currentPageKey] nonNull] integerValue];
				NSInteger total = [[[responseObject valueForKey:placesTotalCountKey] nonNull] integerValue];
				NSInteger totalPages = (NSInteger)ceilf((float)total/(float)DATA_PAGE_SIZE);
				self.isReachedEnd = (totalPages == self.currentPage);
				[self parseWines:[[responseObject valueForKey:winesKey] nonNull]];
				return YES;
			}
		}
	}
	return NO;
}

#pragma mark - Snapped Wines
- (void)uploadSnappedWineImageWithParams:(NSDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure {
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager POST:urlSnappedWines parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				NSDictionary *photoDict = [[responseObject valueForKey:photoKey] nonNull];
				if (photoDict) {
					NSMutableDictionary *snappedWineDict = [NSMutableDictionary new];
					[snappedWineDict setObject:photoDict[url_Key] forKey:url_Key];
					NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
					[formatter setDateFormat:@"MMMM d"];
					[snappedWineDict setObject:[formatter stringFromDate:[NSDate date]] forKey:createdAtKey];
					[snappedWineDict setObject:@"Pending" forKey:nameKey];
					[target performSelectorOnMainThread:completion withObject:snappedWineDict waitUntilDone:NO];
				} else {
					[target performSelectorOnMainThread:failure withObject:@"Error in saving snapped wine" waitUntilDone:NO];
				}
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
