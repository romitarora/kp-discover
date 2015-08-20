//
//  ExpertReview.h
//  unscrewed
//
//  Created by Robin Garg on 23/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USExpertReview : NSObject

@property (nonatomic, strong) NSString *expertReviewId;
@property (nonatomic, assign) NSInteger expertRatings;
@property (nonatomic, strong) NSString *expertValue;
@property (nonatomic, strong) NSString *expertReview;

@property (nonatomic, strong) NSString *expertId;
@property (nonatomic, strong) NSString *expertName;
@property (nonatomic, strong) NSString *postedAt;

- (id)initWithExpertReview:(id)expertReview;
- (void)setExpertReviewWithInfo:(id)expertReview;

@end
