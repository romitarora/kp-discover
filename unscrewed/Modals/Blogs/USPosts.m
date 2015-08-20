//
//  USPosts.m
//  unscrewed
//
//  Created by Robin Garg on 27/01/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USPosts.h"
#import "HTTPRequestManager.h"

@implementation USPosts

- (void)parsePosts:(NSArray *)posts {
	if (!posts || posts.count == 0) return;
	if (!self.arrPosts) {
		self.arrPosts = [NSMutableArray new];
	}
	for (id post in posts) {
		USPost *objPost = [[USPost alloc] initWithInfo:post];
		[self.arrPosts addObject:objPost];
	}
}

/*- (void)getPostsWithParams:(NSMutableDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure {
	[params setObject:@(self.currentPage+1) forKey:pageKey];
	[params setObject:@(DATA_PAGE_SIZE) forKey:perPageKey];
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager GET:urlPosts parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				self.currentPage = [[[responseObject valueForKey:currentPageKey] nonNull] integerValue];
				NSInteger total = [[[responseObject valueForKey:postsCountKey] nonNull] integerValue];
				NSInteger totalPages = (NSInteger)ceilf((float)total/(float)DATA_PAGE_SIZE);
				self.isReachedEnd = (totalPages == self.currentPage);
				[self parsePosts:[[responseObject valueForKey:postsKey] nonNull]];
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
}*/

// http:// www.unscrewed.com/wp/wp-json/posts?post_status=publish&page=2&posts_per_page=1&filter[posts_per_page]=1

- (void)getPostsWithParams:(NSMutableDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure {
	if (!params) {
		params = [NSMutableDictionary new];
	}
	[params setObject:@(self.currentPage+1) forKey:pageKey];
	[params setObject:@(DATA_PAGE_SIZE) forKey:@"posts_per_page"];
	[params setObject:@(DATA_PAGE_SIZE) forKey:@"filter[posts_per_page]"];
	[params setObject:@"publish" forKey:@"post_status"];
	
	HTTPRequestManager *manager = [HTTPRequestManager jsonManager];
	[manager GET:urlPosts parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSArray class]]) {
			NSArray *arrBlogPosts = (NSArray *)responseObject;
			if (arrBlogPosts.count < DATA_PAGE_SIZE) {
				self.isReachedEnd = YES;
			}
			if (arrBlogPosts.count > 0) {
				self.currentPage +=1;
			}
			[self parsePosts:responseObject];
			[target performSelectorOnMainThread:completion withObject:nil waitUntilDone:NO];
		} else {
			// Unknown data received.
			[target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
	}];
}

@end
