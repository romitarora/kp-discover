//
//  GlobalPreferences.m
//  Vapor
//
//  Created by Sourabh B. on 29/01/14.
//  Copyright (c) 2014 Addval Solutions. All rights reserved.
//

#import "GlobalPreferences.h"
#import <MessageUI/MessageUI.h>
#import "USWineTabBarRootVC.h"
#import "USNewActivityTVC.h"
#import "USWineSearchFirstFilterTVC.h"
#import "USPlacesTVC.h"
#import "USMyWinesTVC.h"
#import "USIntroVC.h"
#import "FBSDKLoginKit.h"
#import "FBSDKCoreKit.h"

@interface GlobalPreferences ()

@property(nonatomic,strong)FBSDKLoginManager *loginManager;

@end


@implementation GlobalPreferences

#pragma mark - Singleton Instance
static GlobalPreferences *sharedObject = nil;
+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject=[[self alloc] init];
    });
    return sharedObject;
}

- (id) init {
    self = [super init];
    if (self) {
        //custmization
    }
    return self;
}

- (UITabBarController *)dashboard {
    NSLog(@"SHOW");
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    USNewActivityTVC *objActivityVC = [[USNewActivityTVC alloc] init];
    //UIImage *latestTabBarImage = [UIImage imageNamed:@"latest-tab-icon"];
    //UITabBarItem *activityItem = [[UITabBarItem alloc] initWithTitle:@"Latest" image:latestTabBarImage selectedImage:nil];
    UITabBarItem *activityItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tabicon_glass"] selectedImage:nil];
    UINavigationController *navActivity = [[UINavigationController alloc] initWithRootViewController:objActivityVC];
    [navActivity.navigationBar setTranslucent:NO];
    navActivity.tabBarItem = activityItem;
    navActivity.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    USWineSearchFirstFilterTVC *objFindWineVC = [[USWineSearchFirstFilterTVC alloc] init];
    UIImage *findWinesTabBarImage = [UIImage imageNamed:@"find-wines-tab-icon"];
    UITabBarItem *findWineItem = [[UITabBarItem alloc] initWithTitle:@"Find Wine" image:findWinesTabBarImage selectedImage:nil];
    UINavigationController *navFindWine = [[UINavigationController alloc] initWithRootViewController:objFindWineVC];
    [navFindWine.navigationBar setTranslucent:NO];
    navFindWine.tabBarItem = findWineItem;
    navFindWine.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    USPlacesTVC *objPlacesVC = [[USPlacesTVC alloc] init];
    //UIImage *placesTabBarImage = [UIImage imageNamed:@"places-tab-icon"];
    //UITabBarItem *placesItem = [[UITabBarItem alloc] initWithTitle:@"Nearby" image:placesTabBarImage selectedImage:nil];
    UITabBarItem *placesItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tabicon_map"] selectedImage:nil];
    UINavigationController *navPlaces = [[UINavigationController alloc] initWithRootViewController:objPlacesVC];
    [navPlaces.navigationBar setTranslucent:NO];
    navPlaces.tabBarItem = placesItem;
    navPlaces.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    USMyWinesTVC *objMyWines = [[USMyWinesTVC alloc] initWithStyle:UITableViewStyleGrouped];
    //UIImage *meTabBarImage = [UIImage imageNamed:@"me-tab-icon"];
    //UITabBarItem *meItem = [[UITabBarItem alloc] initWithTitle:@"My Wines" image:meTabBarImage selectedImage:nil];
    UITabBarItem *meItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tabicon_heart"] selectedImage:nil];
    UINavigationController *navMyWines = [[UINavigationController alloc] initWithRootViewController:objMyWines];
    [navMyWines.navigationBar setTranslucent:NO];
    navMyWines.tabBarItem = meItem;
    navMyWines.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    USWineTabBarRootVC *tabBarController = [[USWineTabBarRootVC alloc] init];
    [tabBarController.tabBar setTranslucent:NO];
    [tabBarController setViewControllers:@[navActivity, navPlaces, navMyWines]];
    //--Turned off for new Tab ICONS--[tabBarController setViewControllers:@[navActivity, navFindWine, navPlaces, navMyWines]];
    [tabBarController setSelectedIndex:1];
    return tabBarController;
}

- (UINavigationController *)introVC {
    USIntroVC *objWelcomeVC = [[USIntroVC alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:objWelcomeVC];
	[navController.navigationBar setTranslucent:NO];
    
    return navController;
}

- (UIViewController *)windowRootViewController {
    [self customizeAppearance];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsUserLoggedInKey]) {
        return [self dashboard];
    } else {
        return [self introVC];
    }
}

- (void)customizeAppearance {
    // Set bar button tint color to app theme color
    //--GRAY[[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:68.0/255.0 green:68.0/225.0 blue:76.0/255.0 alpha:1.0]];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    // Set Tab Bar Items Selected Tint color to App Theme Color
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:68.0/255.0 green:68.0/225.0 blue:76.0/255.0 alpha:1.0]];
    //UIImage *nav_bg_img = [[UIImage imageNamed:@"nav_bg"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    //[[UINavigationBar appearance] setBackgroundImage:nav_bg_img forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"navBarShadow"]];
    [[UINavigationBar appearance] setBarTintColor:[USColor colorFromHexString:@"#202020"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
}

#pragma mark - Facebook Login
- (void)loginUserWithFacebook:(void(^)(id data))callback {
    self.loginManager = [[FBSDKLoginManager alloc] init];
    [self.loginManager logInWithReadPermissions:@[@"email", @"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            [self.loginManager logOut];
            LogError(@"Error in signing in via facebook - %@",error);
            [HelperFunctions showAlertWithTitle:@"Unable to login at the moment. Please try again." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitle:nil];
            callback(nil);
        } else if (result.isCancelled == NO ){ // if (status == FBSessionStateOpen) {
            LogInfo(@"user is logged in via facebook");
            FBSDKAccessToken *dataToken = [FBSDKAccessToken currentAccessToken];
            LogInfo(@"%@",[dataToken tokenString]);
            if (dataToken) {
                callback([dataToken tokenString]);
            } else {
                callback(nil);
            }
        }
    }];
}

- (void)setLoggedInUserFlag {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsUserLoggedInKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
