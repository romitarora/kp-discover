//
//  USPost.h
//  unscrewed
//
//  Created by Mario Danic on 28/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USRetailer.h"

@interface USPost : NSObject

@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *updatedAt;

@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, strong) NSString *authorAvtar;

@property (nonatomic, strong) NSURL *blogUrl;

- (id)initWithInfo:(id)info;
- (void)setPostInfo:(id)info;

@end
