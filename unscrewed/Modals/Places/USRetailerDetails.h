//
//  USRetailerDetails.h
//  unscrewed
//
//  Created by Robin Garg on 25/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USRetailer.h"
#import "USReviews.h"
#import "USUsers.h"

@interface USRetailerDetails : USRetailer

@property (nonatomic, strong) USReview *myReview;
@property (nonatomic, strong) NSString *profileUrl;

@property (nonatomic, assign) NSInteger friendLikesCount;
@property (nonatomic, strong) USUsers *objFriendLikes;

@property (nonatomic, strong) USReviews *storeReviews;
@property (nonatomic, assign) NSInteger storeReviewsCount;


- (instancetype)initWithInfo:(id)info;
- (void)setRetailerInfo:(id)info;

@end
