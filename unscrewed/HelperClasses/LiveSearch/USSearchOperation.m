//
//  SearchOperation.m
//  unscrewed
//
//  Created by Robin Garg on 10/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USSearchOperation.h"
#import "USRetailers.h"
#import "USWines.h"
#import "USUsers.h"

@interface USSearchOperation ()

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, assign) SearchFor searchFor;

@end

@implementation USSearchOperation

- (id)initWithParams:(NSDictionary *)params
		   searchFor:(SearchFor)searchFor
			delegate:(id<USSearchOperationCompletionDelegate>)delegate {
	self = [super init];
	if (self) {
		self.params = params;
		self.searchFor = searchFor;
		self.delegate = delegate;
	}
	return self;
}

- (void)main {
	@autoreleasepool {
		
		if (self.isCancelled) {
			return;
		}
		
		BOOL success;
		id object;
		switch (self.searchFor) {
			case SearchForPlaces:
			{
				USRetailers *objRetailers = [USRetailers new];
				success = [objRetailers findPlacesForQueryString:self.params];
				object = objRetailers;
			}
            break;
            case SearchForFriends:
            {
                USUsers *objUsers = [USUsers new];
                success = [objUsers findFriendsForQueryString:self.params];
                object = objUsers;
            }
            break;
			default:
			{
				USWines *objWines = [USWines new];
				success = [objWines findWinesForQueryString:self.params];
				object = objWines;
			}
            break;
		}
		
		if (self.isCancelled) {
			object = nil;
			return;
		}
		
		if (success) {
			[(NSObject *)self.delegate performSelectorOnMainThread:@selector(searchOperationCompletedWithObject:) withObject:object waitUntilDone:YES];
		} else {
			// Can call failure handler
		}		
	}
}

@end
