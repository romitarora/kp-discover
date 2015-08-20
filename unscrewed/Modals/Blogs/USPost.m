//
//  USPost.m
//  unscrewed
//
//  Created by Mario Danic on 28/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USPost.h"

@implementation USPost

- (id)initWithInfo:(id)info {
	self = [super init];
	if (self) {
		[self setPostInfo:info];
	}
	return self;
}

- (void)setPostInfo:(id)info {
	_postId = [[info valueForKey:idKey] nonNull];
	_title = [[info valueForKey:postTitleKey] nonNull];
	_body = [[info valueForKey:postBodyKey] nonNull];
	_createdAt = [[info valueForKey:postCreatedAtKey] nonNull];
	_updatedAt = [[info valueForKey:postUpdatedAtKey] nonNull];
	
	NSDictionary *authorDict = [[info valueForKey:@"author"] nonNull];
	_authorName = [[authorDict valueForKey:nameKey] nonNull];
	if (!_authorName) {
		_authorName = @"unscrewed";
	}
	_authorAvtar = [[authorDict valueForKey:avatarKey] nonNull];
	
	NSDictionary *imageDict = [[info valueForKey:postImageInfoKey] nonNull];
	if (imageDict) {
		_photoUrl = [[imageDict valueForKeyPath:postImageUrlKeyPath] nonNull];
		if (!_photoUrl) {
			_photoUrl = [[imageDict valueForKey:@"source"] nonNull];
		}
	}
	
	NSString *strUrl = [[info valueForKey:blogUrlKey] nonNull];
	if (strUrl) {
		_blogUrl = [NSURL URLWithString:strUrl];
	}
}

@end
