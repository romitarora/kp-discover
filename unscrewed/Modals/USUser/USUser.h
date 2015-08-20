//
//  USUserLike.h
//  unscrewed
//
//  Created by Rav Chandra on 12/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USUser : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *bioInfo;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, assign) BOOL isLogInFirstTime;

@property (nonatomic, assign) NSInteger likedPlacesCount;
@property (nonatomic, assign) NSInteger likedWinesCount;
@property (nonatomic, assign) NSInteger followerCount;
@property (nonatomic, assign) NSInteger followingCount;

@property (nonatomic, assign) NSInteger bookmarkedPlacesCount;
@property (nonatomic, assign) NSInteger bookmarkedWinesCount;

@property (nonatomic, assign) BOOL hasEmailPassword;
@property (nonatomic, assign) BOOL autoFollow;
@property (nonatomic, assign) BOOL facebookConnected;
@property (nonatomic, assign) BOOL twitterConnected;

@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) NSString *authTokenExpiresAt;

- (id)initWithUserInfo:(id)info;

// basic info
- (void)setUserInfo:(id)info;

// facebook info
- (void)setUserFacebookInfo:(NSDictionary *)info;

@end
