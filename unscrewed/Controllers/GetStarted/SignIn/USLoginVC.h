//
//  USLoginVC.h
//  unscrewed
//
//  Created by Mario Danic on 22/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USLoginVC : UIViewController

+ (NSString *)authToken;
+ (NSString *)userId;
+ (BOOL)      isUserLoggedIn;

@end
