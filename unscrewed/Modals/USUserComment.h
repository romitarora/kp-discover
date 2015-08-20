//
//  NSUserComment.h
//  unscrewed
//
//  Created by Rav Chandra on 12/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USUser.h"

@interface USUserComment : NSObject

@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) USUser *user;

@end
