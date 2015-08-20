//
//  AppDelegate.h
//  unscrewed-ios
//
//  Created by Gary Earle on 8/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASAPIClient;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ASAPIClient *apiClient;


@end
