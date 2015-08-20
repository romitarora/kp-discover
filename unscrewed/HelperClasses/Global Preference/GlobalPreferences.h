//
//  GlobalPreferences.h
//  Vapor
//
//  Created by Sourabh B. on 29/01/14.
//  Copyright (c) 2014 Addval Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalPreferences : NSObject

#pragma mark - Singleton Instance
+ (id)sharedInstance;

- (UITabBarController *)dashboard;
- (UINavigationController *)introVC;
- (UIViewController *)windowRootViewController;


#pragma mark - Facebook Login
- (void)loginUserWithFacebook:(void(^)(id data))callback;
- (void)setLoggedInUserFlag;
@end
