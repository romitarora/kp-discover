//
//  USPosts.h
//  unscrewed
//
//  Created by Robin Garg on 27/01/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USPost.h"

@interface USPosts : NSObject

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isReachedEnd;
@property (nonatomic, strong) NSMutableArray *arrPosts;

- (void)getPostsWithParams:(NSMutableDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure;

@end
