//
//  USUsers.h
//  unscrewed
//
//  Created by Robin Garg on 15/01/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USUser.h"
#import "USFollowingUser.h"

@interface USUsers : NSObject

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isReachedEnd;

@property (nonatomic, strong) USUser *objUser;
@property (nonatomic, strong) NSMutableArray *arrUsers;
@property (nonatomic, strong) NSMutableArray *arrContactsToImport;

+ (id)sharedUser;

+ (NSString *)authToken;
+ (NSString *)userId;
+ (BOOL)      isUserLoggedIn;

- (id)initWithFriends:(NSArray *)friends;

#pragma mark - Sign Up User
- (void)signUpUserWithParam:(NSDictionary *)param target:(id)target completion:(SEL)completion failure:(SEL)failure;

#pragma mark - Sign In User
- (void)signInUserWithParam:(NSDictionary *)param target:(id)target completion:(SEL)completion failure:(SEL)failure;

#pragma mark - Facebook SignIn / SignUp
- (void)facebookLoginWithToken:(NSDictionary *)param target:(id)target completion:(SEL)completion failure:(SEL)failure;

#pragma mark - Get User Info
- (void)userInfoWithParam:(NSDictionary *)param target:(id)target completion:(SEL)completion failure:(SEL)failure;

#pragma mark - Update User Info
- (void)updateUserInfoWithParams:(NSDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure;

#pragma mark - Following / Follow / Unfollow
// get following users
- (void)getFollowingUsersWithTarget:(id)target completion:(SEL)completion failure:(SEL)failure;

// Get Followers
- (void)getFollowersWithTarget:(id)target completion:(SEL)completion failure:(SEL)failure;

// Follow User
- (void)followUser:(USFollowingUser *)user target:(id)target completion:(SEL)completion failure:(SEL)failure;

// Unfollow User
- (void)unfollowUser:(USFollowingUser *)user target:(id)target completion:(SEL)completion failure:(SEL)failure;

#pragma mark - Upload Contacts
- (void)uploadPhoneContacts:(id)target completionHandler:(SEL)completion failureHandler:(SEL)failure;

#pragma mark - Get Users
#pragma mark - Facebook Friends
- (void)getFacebookFriends:(id)target completionHandler:(SEL)completion failureHandler:(SEL)failure;
- (void)getUnscrewedUsers:(id)target completionHandler:(SEL)completion failureHandler:(SEL)failure;
- (void)getUsersImNotFollowing:(id)target completionHandler:(SEL)completion failureHandler:(SEL)failure;
- (void)getNonUnscrewedUsers:(id)target completionHandler:(SEL)completion failureHandler:(SEL)failure;

#pragma mark Live Search For Friends
- (BOOL)findFriendsForQueryString:(NSDictionary *)params;
- (void)getFriendsWithParams:(NSMutableDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure; // load more case

@end
