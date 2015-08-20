//
//  AppDelegate.m
//  unscrewed-ios
//
//  Created by Gary Earle on 8/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//OneClick did comment here for testing.plz ignore.

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworkActivityLogger.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "USLocationManager.h"
#import <FPPicker/FPPicker.h>
#import <AlgoliaSearch-Client/ASAPIClient.h>

@implementation AppDelegate { 
    
}

+ (void)initialize {
	//FIXME: this is test key need to be updated
	[FPConfig sharedInstance].APIKey = @"A3klFVA8HQ7WaFI3yd0x2z";
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //test
	
	// start the location service
	[USLocationManager sharedInstance];
	
	self.apiClient = [ASAPIClient apiClientWithApplicationID:ALGOLIA_APPLICATION_ID apiKey:ALGOLIA_API_KEY];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] keyWindow].tintColor = [USColor themeSelectedColor];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [self.window setRootViewController:[kGlobalPref windowRootViewController]];

    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
}
-(void)showSplash
{
    /*
    UIImageView *splashScreen = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"LaunchImage"]];
    [self.window.rootViewController.view addSubview: splashScreen];
    [self.window makeKeyAndVisible];
     */
    NSString *launchImageName;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([UIScreen mainScreen].bounds.size.height == 480) launchImageName = @"LaunchImage-700@2x.png"; // iPhone 4/4s, 3.5 inch screen
        if ([UIScreen mainScreen].bounds.size.height == 568) launchImageName = @"LaunchImage-700-568h@2x.png"; // iPhone 5/5s, 4.0 inch screen
        if ([UIScreen mainScreen].bounds.size.height == 667) launchImageName = @"LaunchImage-800-667h@2x.png"; // iPhone 6, 4.7 inch screen
        if ([UIScreen mainScreen].bounds.size.height == 736) launchImageName = @"LaunchImage-800-Portrait-736h@3x.png"; // iPhone 6+, 5.5 inch screen
    }
    UIImageView *splashScreen = [[UIImageView alloc] initWithImage:[UIImage imageNamed: launchImageName]];
    [self.window addSubview: splashScreen];
    [self.window bringSubviewToFront: splashScreen]; //!
    [self.window makeKeyAndVisible];
    NSLog(@"begin splash");
    [UIView animateWithDuration: 0.5
                          delay: 2.5
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{
                         splashScreen.alpha = 0.0;
                     }
                     completion: ^ (BOOL finished) {
                         [splashScreen removeFromSuperview];
                         NSLog(@"end splash");
                     }
     ];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self showSplash];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self showSplash];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end