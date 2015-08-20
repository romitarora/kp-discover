//
//  USUserLike.m
//  unscrewed
//
//  Created by Rav Chandra on 12/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USUser.h"

@implementation USUser

- (id)initWithUserInfo:(id)info {
    self = [super init];
    if (self) {
        [self setUserInfo:info];
    }
    return self;
}

#pragma mark - General Info
- (void)setUserInfo:(id)info {
    _authToken = [[info valueForKey:authTokenKey] nonNull];
    _authTokenExpiresAt = [[info valueForKey:authTokenExpiresKey] nonNull];
    _autoFollow = [[[info valueForKey:autoFollowKey] nonNull] boolValue];
    _avatar = ([[info valueForKey:avatarKey] nonNull] ? [[info valueForKey:avatarKey] nonNull] : kEmptyString);
    _bioInfo = [[info valueForKey:bioKey] nonNull];
    _email = [[info valueForKey:emailKey] nonNull];

    _username = [[info valueForKey:userNameKey] nonNull];
    if (_username == nil) {
        if (_email.length > 0) {
            _username = [[_email componentsSeparatedByString:@"@"] firstObject];
        } else {
            _username = @"Not Available"; // FIXME
        }
    }
    _bookmarkedPlacesCount = [[[info valueForKey:bookmarkedPlacesCountKey] nonNull] integerValue];
    _bookmarkedWinesCount = [[[info valueForKey:bookmarkedWinesCountKey] nonNull] integerValue];
    _facebookConnected = [[[info valueForKey:facebookConnectedKey] nonNull] boolValue];
    _followerCount = [[[info valueForKey:followerCountKey] nonNull] integerValue];
    _followingCount = [[[info valueForKey:followingCountKey] nonNull] integerValue];
    _hasEmailPassword = [[[info valueForKey:hasEmailPasswordKey] nonNull] boolValue];
    _userId = [[info valueForKey:idKey] nonNull];
    _likedPlacesCount = [[[info valueForKey:likedPlacesCountKey] nonNull] integerValue];
    _likedWinesCount = [[[info valueForKey:likedWinesCountKey] nonNull] integerValue];
    _twitterConnected = [[[info valueForKey:twitterConnectedKey] nonNull] boolValue];    
}

#pragma mark - Facebook Info
- (void)setUserFacebookInfo:(NSDictionary *)info {
    LogInfo(@"user fb data = %@",info);
    
    _userId = [[info valueForKey:idKey] nonNull];
    _hasEmailPassword = [[[info valueForKey:hasEmailPasswordKey] nonNull] boolValue];
    
    _email = [[info valueForKey:emailKey] nonNull];
    _avatar = [info valueForKey:avatarKey];
    _username = [[info valueForKey:nameKey] nonNull];

    LogInfo(@"created_at = %@",[HelperFunctions formattedDateString:[[info valueForKey:@"created_at"] nonNull]]);
    _createdAt = [[info valueForKey:@"created_at"] nonNull];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *firstDate = [dateFormatter dateFromString:_createdAt];
	if (firstDate) {
		_isLogInFirstTime = [HelperFunctions isLoggingInFirstTime:firstDate];
	}
    _facebookConnected = [[[info valueForKey:facebookConnectedKey] nonNull] boolValue];
    _twitterConnected = [[[info valueForKey:twitterConnectedKey] nonNull] boolValue];
    
    _authToken = [[info valueForKey:authTokenKey] nonNull];
    _authTokenExpiresAt = [[info valueForKey:authTokenExpiresKey] nonNull];
    _autoFollow = [[[info valueForKey:autoFollowKey] nonNull] boolValue];

    _bookmarkedPlacesCount = [[[info valueForKey:bookmarkedPlacesCountKey] nonNull] integerValue];
    _bookmarkedWinesCount = [[[info valueForKey:bookmarkedWinesCountKey] nonNull] integerValue];

    _followerCount = [[[info valueForKey:followerCountKey] nonNull] integerValue];
    _followingCount = [[[info valueForKey:followingCountKey] nonNull] integerValue];


    _likedPlacesCount = [[[info valueForKey:likedPlacesCountKey] nonNull] integerValue];
    _likedWinesCount = [[[info valueForKey:likedWinesCountKey] nonNull] integerValue];

    
    if (_username == nil) {
        if (_email.length > 0) {
            _username = [[_email componentsSeparatedByString:@"@"] firstObject];
        } else {
            _username = @"Not Available"; // FIXME
        }
    }
}

@end
