//
//  USBlogWebViewVC.h
//  unscrewed
//
//  Created by Robin Garg on 03/07/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USPost;

@interface USBlogWebViewVC : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) USPost *objPost;

@end
