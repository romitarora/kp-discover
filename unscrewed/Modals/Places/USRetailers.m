//
//  USPlaces.m
//  unscrewed
//
//  Created by Robin Garg on 19/01/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USRetailers.h"
#import "HTTPRequestManager.h"

@implementation USRetailers

- (void)parsePlaces:(NSArray *)places {
    if (!places || places.count == 0) return;
    if (!self.arrPlaces) {
        self.arrPlaces = [NSMutableArray new];
    }
    for (NSDictionary *place in places) {
        USRetailer *objRetailer = [[USRetailer alloc] initWithInfo:place];
        [self.arrPlaces addObject:objRetailer];
    }
}

- (void)parseAutofillOffinePlacesWithResult:(NSDictionary *)result {
	self.currentPage = [[[result valueForKey:pageKey] nonNull] integerValue];
	NSInteger totalPages = [[[result valueForKey:@"nbPages"] nonNull] integerValue]-1;
	self.isReachedEnd = (totalPages <= self.currentPage);
	if (self.currentPage == 0) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.type matches[c] %@",@"Store"];
		NSArray *filteredArray = [self.arrPlaces filteredArrayUsingPredicate:predicate];
		if (filteredArray.count) {
			[self.arrPlaces removeObjectsInArray:filteredArray];
		}
	}
	[self parsePlaces:[result valueForKey:@"hits"]];
}

#pragma mark - All Places
- (void)getPlacesWithParams:(NSMutableDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure {
	[params setObject:@(self.currentPage+1) forKey:pageKey];
	[params setObject:@(DATA_PAGE_SIZE) forKey:perPageKey];
    HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
    [manager GET:urlPlaces parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Parse Result
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject valueForKey:successKey] boolValue]) {
				self.currentPage = [[[responseObject valueForKey:currentPageKey] nonNull] integerValue];
				NSInteger total = [[[responseObject valueForKey:placesTotalCountKey] nonNull] integerValue];
				NSInteger totalPages = (NSInteger)ceilf((float)total/(float)DATA_PAGE_SIZE);
				self.isReachedEnd = (totalPages == self.currentPage);
				[self parsePlaces:[[responseObject valueForKey:placesKey] nonNull]];
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

#pragma mark - My Places
- (void)getMyPlaces:(id)target completion:(SEL)completion failure:(SEL)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.currentPage+1) forKey:pageKey];
    [params setObject:@(DATA_PAGE_SIZE) forKey:perPageKey];
    
    HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
    [manager GET:urlMyPlaces parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Parse Result
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject valueForKey:successKey] boolValue]) {
                self.currentPage = [[[responseObject valueForKey:currentPageKey] nonNull] integerValue];
                NSInteger total = [[[responseObject valueForKey:likesTotalCountKey] nonNull] integerValue];
                NSInteger totalPages = (NSInteger)ceilf((float)total/(float)DATA_PAGE_SIZE);
                self.isReachedEnd = (totalPages == self.currentPage);
                [self parsePlaces:[[responseObject valueForKey:likesKey] nonNull]];
                [target performSelectorOnMainThread:completion withObject:self waitUntilDone:NO];
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

#pragma mark - Place Detail
- (void)getDetailsForPlaceId:(NSString *)placeId target:(id)target completion:(SEL)completion failure:(SEL)failure {
	NSString *strUrl = [NSString stringWithFormat:urlPlaceDetails,placeId];
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:messageKey] nonNull]) {
				NSString *errorMsg = [responseObject objectForKey:messageKey];
				[target performSelectorOnMainThread:failure withObject:errorMsg waitUntilDone:NO];
			} else {
				USRetailerDetails *objRetailerDetails = [[USRetailerDetails alloc] initWithInfo:responseObject];
				[target performSelectorOnMainThread:completion withObject:objRetailerDetails waitUntilDone:NO];
			}
		} else {
			// Unknown data received.
			[target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
	}];
}

#pragma mark - Star / UnStar Place
- (void)setStatusAsStaredForPlace:(USRetailer *)retailer target:(id)target completion:(SEL)completion failure:(SEL)failure {
	NSString *urlStarPlace = [NSString stringWithFormat:urlStarPlacesWithID,retailer.retailerId];
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager POST:urlStarPlace parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				retailer.favorited = YES;
				[target performSelectorOnMainThread:completion withObject:retailer waitUntilDone:NO];
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


- (void)setStatusAsUnstaredForPlace:(USRetailer *)retailer target:(id)target completion:(SEL)completion failure:(SEL)failure {
	NSString *urlUnstarPlace = [NSString stringWithFormat:urlStarPlacesWithID,retailer.retailerId];
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager DELETE:urlUnstarPlace parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				retailer.favorited = NO;
				[target performSelectorOnMainThread:completion withObject:retailer waitUntilDone:NO];
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

#pragma mark - Live Search Places
- (BOOL)findPlacesForQueryString:(NSDictionary *)params {
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlPlaces parameters:params error:nil];
	
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
				[self parsePlaces:[[responseObject valueForKey:placesKey] nonNull]];
				return YES;
			}
		}
	}
	return NO;
}

@end
