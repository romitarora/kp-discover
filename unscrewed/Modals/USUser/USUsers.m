//
//  USUsers.m
//  unscrewed
//
//  Created by Robin Garg on 15/01/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USUsers.h"
#import "HTTPRequestManager.h"

@implementation USUsers

+ (BOOL)isUserLoggedIn
{
    return ([[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"] !=
            nil);
}

+ (NSString *)authToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
}

+ (NSString *)userId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
}

+ (id)sharedUser {
    static USUsers *objUsers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objUsers = [[self alloc] init];
    });
    return objUsers;
}

- (id)init {
    self = [super init];
    if (self) {
        self.arrContactsToImport = [NSMutableArray array];
	}
    return self;
}

- (id)initWithFriends:(NSArray *)friends {
    self = [super init];
    if (self) {
        [self parseFriends:friends];
    }
    return self;
}

- (void)signUpUserWithParam:(NSDictionary *)param target:(id)target completion:(SEL)completion failure:(SEL)failure {
    HTTPRequestManager *manager = [HTTPRequestManager jsonManager];
    [manager POST:urlSignUp parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Parse Result
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject valueForKey:successKey] boolValue]) {
                NSDictionary *user = [responseObject objectForKey:userKey];
				if (!self.objUser) {
					self.objUser = [USUser new];
				}
                [self.objUser setUserInfo:user];
				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsUserLoggedInKey];
				[[NSUserDefaults standardUserDefaults] setObject:self.objUser.authToken forKey:authTokenKey];
				[[NSUserDefaults standardUserDefaults] setObject:self.objUser.authTokenExpiresAt forKey:authTokenExpiresKey];
				[[NSUserDefaults standardUserDefaults] synchronize];
                [target performSelectorOnMainThread:completion withObject:nil waitUntilDone:NO];
            } else {
                NSDictionary *errors = [responseObject valueForKey:errorsKey];
                NSArray *password_errors = [errors objectForKey:passwordKey];
                NSArray *email_errors = [errors objectForKey:emailKey];
                NSArray *base_errors = [errors objectForKey:baseErrorsKey];
                NSString *errorMsg = @"";
                for (NSString * error in password_errors) {
                    errorMsg = [NSString stringWithFormat:@"%@\nPassword %@", errorMsg, error];
                }
                for (NSString * error in email_errors) {
                    errorMsg = [NSString stringWithFormat:@"%@\nEmail %@", errorMsg, error];
                }
                for (NSString * error in base_errors) {
                    errorMsg = [NSString stringWithFormat:@"%@\n %@", errorMsg, error];
                }
                [target performSelectorOnMainThread:failure withObject:errorMsg.trim waitUntilDone:NO];
            }
        } else {
            // Unknown data received.
            [target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
    }];
}

#pragma mark - Sign In User
- (void)signInUserWithParam:(NSDictionary *)param target:(id)target completion:(SEL)completion failure:(SEL)failure {
    HTTPRequestManager *manager = [HTTPRequestManager jsonManager];
    [manager POST:urlSignInWithEmail parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Parse Result
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject valueForKey:successKey] boolValue]) {
                NSDictionary *user = [responseObject objectForKey:userKey];
				if (!self.objUser) {
					self.objUser = [USUser new];
				}
                [self.objUser setUserInfo:user];
				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsUserLoggedInKey];
				[[NSUserDefaults standardUserDefaults] setObject:self.objUser.authToken forKey:authTokenKey];
				[[NSUserDefaults standardUserDefaults] setObject:self.objUser.authTokenExpiresAt forKey:authTokenExpiresKey];
				[[NSUserDefaults standardUserDefaults] synchronize];
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

#pragma mark - Facebook SignIn / SignUp
- (void)facebookLoginWithToken:(NSDictionary *)param target:(id)target completion:(SEL)completion failure:(SEL)failure {
    HTTPRequestManager *manager = [HTTPRequestManager jsonManager];
    [manager POST:urlFacebook parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Parse Result
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject valueForKey:successKey] boolValue]) {
                NSDictionary *user = [responseObject objectForKey:userKey];
                if (!self.objUser) {
                    self.objUser = [USUser new];
                }
                [self.objUser setUserFacebookInfo:user];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsUserLoggedInKey];
                [[NSUserDefaults standardUserDefaults] setObject:self.objUser.authToken forKey:authTokenKey];
                [[NSUserDefaults standardUserDefaults] setObject:self.objUser.authTokenExpiresAt forKey:authTokenExpiresKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [target performSelectorOnMainThread:completion withObject:self.objUser waitUntilDone:NO];
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

#pragma mark - Get User Info
- (void)userInfoWithParam:(NSDictionary *)param target:(id)target completion:(SEL)completion failure:(SEL)failure {
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager GET:urlUserInfo parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[[responseObject valueForKey:authenticatedKey] nonNull] boolValue]) {
				NSDictionary *user = [responseObject objectForKey:userKey];
				if (!self.objUser) {
					self.objUser = [USUser new];
				}
				[self.objUser setUserInfo:user];
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

#pragma mark - Update User Info
- (void)updateUserInfoWithParams:(NSDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure {
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager POST:urlUserInfo parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[[responseObject valueForKey:successKey] nonNull] boolValue]) {
				NSDictionary *user = [responseObject objectForKey:userKey];
				if (!self.objUser) {
					self.objUser = [USUser new];
				}
				[self.objUser setUserInfo:user];
			
				[target performSelectorOnMainThread:completion withObject:params waitUntilDone:NO];
			} else {
				NSDictionary *errors = [responseObject valueForKey:errorsKey];
				NSArray *password_errors = [errors objectForKey:passwordKey];
				NSArray *email_errors = [errors objectForKey:emailKey];
				NSArray *username_errors = [errors objectForKey:userNameKey];
				NSArray *bio_errors = [errors objectForKey:bioKey];
				NSArray *base_errors = [errors objectForKey:baseErrorsKey];
				NSString *errorMsg = @"";
				for (NSString * error in password_errors) {
					errorMsg = [NSString stringWithFormat:@"%@\nPassword %@", errorMsg, error];
				}
				for (NSString * error in email_errors) {
					errorMsg = [NSString stringWithFormat:@"%@\nEmail %@", errorMsg, error];
				}
				for (NSString * error in username_errors) {
					errorMsg = [NSString stringWithFormat:@"%@\nUsername %@", errorMsg, error];
				}for (NSString * error in bio_errors) {
					errorMsg = [NSString stringWithFormat:@"%@\nBio %@", errorMsg, error];
				}
				for (NSString * error in base_errors) {
					errorMsg = [NSString stringWithFormat:@"%@\n %@", errorMsg, error];
				}
				[target performSelectorOnMainThread:failure withObject:errorMsg.trim waitUntilDone:NO];
			}
		} else {
			// Unknown data received.
			[target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
	}];
}

#pragma mark - Get Followers
- (void)getFollowersWithTarget:(id)target completion:(SEL)completion failure:(SEL)failure {
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager GET:urlFollowers parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			NSArray *arrFollowingUsers = [[responseObject valueForKey:usersKey] nonNull];
			[self parseFollowingUsers:arrFollowingUsers];
			[target performSelectorOnMainThread:completion withObject:self waitUntilDone:NO];
		} else {
			// Unknown data received.
			[target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
	}];
}

#pragma mark - Get Following Users
- (void)parseFollowingUsers:(NSArray *)users {
	if (!users || users.count == 0)	return;
	self.arrUsers = [NSMutableArray new];
	for (NSDictionary *user in users) {
		USFollowingUser *objUser = [[USFollowingUser alloc] initWithUserInfo:user];
		[self.arrUsers addObject:objUser];
	}
}
- (void)getFollowingUsersWithTarget:(id)target completion:(SEL)completion failure:(SEL)failure {
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager GET:urlFollowingUsers parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			NSArray *arrFollowingUsers = [[responseObject valueForKey:usersKey] nonNull];
			[self parseFollowingUsers:arrFollowingUsers];
			[target performSelectorOnMainThread:completion withObject:self waitUntilDone:NO];
		} else {
			// Unknown data received.
			[target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
	}];
}

#pragma mark - Follow User
- (void)followUser:(USFollowingUser *)user target:(id)target completion:(SEL)completion failure:(SEL)failure {
	NSString *urlFollow = [NSString stringWithFormat:urlFollowUser,user.userId];
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager POST:urlFollow parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				user.unfollowedUser = NO;
				[target performSelectorOnMainThread:completion withObject:user waitUntilDone:NO];
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

#pragma mark - Unfollow User
- (void)unfollowUser:(USFollowingUser *)user target:(id)target completion:(SEL)completion failure:(SEL)failure {
	NSString *urlUnfollow = [NSString stringWithFormat:urlFollowUser,user.userId];
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	[manager DELETE:urlUnfollow parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:successKey] boolValue]) {
				user.unfollowedUser = YES;
				[target performSelectorOnMainThread:completion withObject:user waitUntilDone:NO];
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


#pragma mark - Upload Contacts
- (void)uploadPhoneContacts:(id)target completionHandler:(SEL)completion failureHandler:(SEL)failure {
    
    HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
    
    LogInfo(@"Contacts to import count - %lu",(unsigned long)[[[USUsers sharedUser] arrContactsToImport] count]);
    if([[[USUsers sharedUser] arrContactsToImport] count]) {
        NSDictionary *params = [NSDictionary dictionaryWithObject:[[USUsers sharedUser] arrContactsToImport] forKey:@"contacts"];
        
        [manager POST:urlContacts parameters:[[NSDictionary alloc] initWithObjectsAndKeys:params, @"user",self.objUser.userId,idKey, nil]
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if ([responseObject isKindOfClass:[NSDictionary class]]) {
                      if ([[responseObject objectForKey:successKey] boolValue]) {
                          
                          [self.arrContactsToImport removeAllObjects];
                          
                          [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:self.arrContactsToImport.count] forKeyPath:kNumberOfContactsKey];
                          [[NSUserDefaults standardUserDefaults] synchronize];
                          
                          [target performSelectorOnMainThread:completion withObject:self waitUntilDone:NO];
                          
                      } else {
                          NSString *strMsg = [responseObject objectForKey:messageKey];
                          [target performSelectorOnMainThread:failure withObject:strMsg waitUntilDone:NO];
                      }
                  } else {
                      [target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"Failure :- %@",error);
                  [target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
              }];
    }
}


#pragma mark - Get Users
- (void)getUnscrewedUsers:(id)target completionHandler:(SEL)completion failureHandler:(SEL)failure {
    HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
    [manager GET:urlUsers parameters:@{idKey:self.objUser.userId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *usersArray = [responseObject objectForKey:usersKey];
            if (usersArray.count) {
                self.arrUsers = [NSMutableArray new];
                for (NSDictionary *userDict in usersArray) {
                    USUser *objUser = [USUser new];
                    [objUser setUserInfo:userDict];
                    [self.arrUsers addObject:objUser];
                }
                [target performSelectorOnMainThread:completion withObject:self waitUntilDone:NO];
            } else {
                NSString *strMsg = [responseObject objectForKey:messageKey];
                [target performSelectorOnMainThread:failure withObject:strMsg waitUntilDone:NO];
            }
        } else {
            [target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
    }];
}


#pragma mark - Facebook Friends
- (void)getFacebookFriends:(id)target completionHandler:(SEL)completion failureHandler:(SEL)failure {
    HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
    [manager GET:urlFindFriends parameters:@{idKey:[[[USUsers sharedUser] objUser] userId]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *usersArray = [responseObject objectForKey:usersKey];
            self.arrUsers = [NSMutableArray new];
            for (NSDictionary *fbFriend in usersArray) {
                USFollowingUser *user = [USFollowingUser new];
                [user setUserFacebookInfo:fbFriend];
                [self.arrUsers addObject:user];
            }
            [target performSelectorOnMainThread:completion withObject:self waitUntilDone:NO];
        } else {
            [target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
    }];
}

- (void)getUsersImNotFollowing:(id)target completionHandler:(SEL)completion failureHandler:(SEL)failure {
    HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
    [manager GET:urlUsers parameters:@{idKey:self.objUser.userId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *usersArray = [responseObject objectForKey:usersKey];
            if (usersArray.count) {
                self.arrUsers = [NSMutableArray new];
                for (NSDictionary *userDict in usersArray) {
                    USUser *objUser = [USUser new];
                    [objUser setUserInfo:userDict];
                    [self.arrUsers addObject:objUser];
                }
                [target performSelectorOnMainThread:completion withObject:self waitUntilDone:NO];
            } else {
                NSString *strMsg = [responseObject objectForKey:messageKey];
                [target performSelectorOnMainThread:failure withObject:strMsg waitUntilDone:NO];
            }
        } else {
            [target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
    }];
}

- (void)getNonUnscrewedUsers:(id)target completionHandler:(SEL)completion failureHandler:(SEL)failure {
    HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
    [manager GET:urlUsers parameters:@{idKey:self.objUser.userId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *usersArray = [responseObject objectForKey:usersKey];
            if (usersArray.count) {
                self.arrUsers = [NSMutableArray new];
                for (NSDictionary *userDict in usersArray) {
                    USUser *objUser = [USUser new];
                    [objUser setUserInfo:userDict];
                    [self.arrUsers addObject:objUser];
                }
                [target performSelectorOnMainThread:completion withObject:self waitUntilDone:NO];
            } else {
                NSString *strMsg = [responseObject objectForKey:messageKey];
                [target performSelectorOnMainThread:failure withObject:strMsg waitUntilDone:NO];
            }
        } else {
            [target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
    }];
}

#pragma mark Live Search For Friends
- (void)parseSearchedUsers:(NSArray *)arrUsers {
	if (!arrUsers || arrUsers.count == 0) return;
	if (!self.arrUsers) {
		self.arrUsers = [NSMutableArray new];
	}
	for (id userDict in arrUsers) {
		NSString *strId = (NSString *)[[userDict valueForKey:@"_id"] nonNull];
		if ([strId isEqualToString:[[USUsers sharedUser] objUser].userId]) {
			continue;
		}
		USFollowingUser *unfollowedUser = [[USFollowingUser alloc] init];
		unfollowedUser.unfollowedUser = YES;
		[unfollowedUser setUserInfo:userDict];
		//FIXME: need to be removed after _id key is returning id
		unfollowedUser.userId = [[userDict valueForKey:@"_id"] nonNull];
		NSArray *followerIds = [[userDict valueForKey:@"follower_ids"] nonNull];
		if (followerIds != nil && followerIds.count) {
			BOOL isFollowedUser = [followerIds containsObject:[[USUsers sharedUser] objUser].userId];
			unfollowedUser.unfollowedUser = !isFollowedUser;
		}
		[self.arrUsers addObject:unfollowedUser];
	}
}

- (BOOL)findFriendsForQueryString:(NSDictionary *)params {
    HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlSearchUsers parameters:params error:nil];//urlSearchUsers
    
    NSURLResponse* response;
    NSError* error = nil;

    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    if (!error) {
        id responseObject = [manager.responseSerializer responseObjectForResponse:response data:result error:&error];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
			NSArray *arrUsers = [[responseObject valueForKey:usersKey] nonNull];
			if (arrUsers != nil || arrUsers.count) {
				self.currentPage = [[[responseObject valueForKey:currentPageKey] nonNull] integerValue];
				NSInteger total = [[[responseObject valueForKey:placesTotalCountKey] nonNull] integerValue];//usersTotalCountKey
				NSInteger totalPages = (NSInteger)ceilf((float)total/(float)DATA_PAGE_SIZE);
				self.isReachedEnd = (totalPages == self.currentPage);
				[self parseSearchedUsers:arrUsers];//usersKey
				return YES;
			}
        }
    }
    return NO;
}

// load more friends
- (void)getFriendsWithParams:(NSMutableDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure {
    [params setObject:@(self.currentPage+1) forKey:pageKey];
    [params setObject:@(DATA_PAGE_SIZE) forKey:perPageKey];
    
    HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
    
    [manager GET:urlSearchUsers parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Parse Result
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject valueForKey:successKey] boolValue]) {

                self.currentPage = [[[responseObject valueForKey:currentPageKey] nonNull] integerValue];
                NSInteger total = [[[responseObject valueForKey:usersTotalCountKey] nonNull] integerValue];
                NSInteger totalPages = (NSInteger)ceilf((float)total/(float)DATA_PAGE_SIZE);
                self.isReachedEnd = (totalPages == self.currentPage);
                [self parseFollowingUsers:[[responseObject valueForKey:usersKey] nonNull]];

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

- (void)parseUsersData:(NSArray *)usersArray {
    if (!usersArray || usersArray.count == 0) return;
    
    if (!self.arrUsers) {
        self.arrUsers = [NSMutableArray new];
    }
    
    for (NSDictionary *userDict in usersArray) {
        USFollowingUser *unfollowedUser = [[USFollowingUser alloc] init];
        unfollowedUser.unfollowedUser = NO;
        unfollowedUser.username = [[userDict objectForKey:nameKey] nonNull];
        unfollowedUser.bioInfo = [[userDict objectForKey:addressKey] nonNull];
        // FIXME - user user's info here : uncomment below line
//        [objUser setUserInfo:userDict];
        [self.arrUsers addObject:unfollowedUser];
    }
}

- (void)parseFriends:(NSArray *)usersArray {
    if (!usersArray || usersArray.count == 0) return;
    
    if (!self.arrUsers) {
        self.arrUsers = [NSMutableArray new];
    }
    
    for (NSDictionary *userDict in usersArray) {
        USUser *user = [[USUser alloc] init];
        [user setUserInfo:userDict];
        [self.arrUsers addObject:user];
    }
}

@end
