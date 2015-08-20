//
//  USReview.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 23/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USReview : NSObject

// review summary
@property(nonatomic, assign)NSInteger star_1_Rating;
@property(nonatomic, assign)NSInteger star_2_Rating;
@property(nonatomic, assign)NSInteger star_3_Rating;
@property(nonatomic, assign)NSInteger star_4_Rating;
@property(nonatomic, assign)NSInteger star_5_Rating;
@property(nonatomic, assign)NSInteger overallRating;
@property(nonatomic, strong)NSString  *summaryTitle;

// indivisual review
@property(nonatomic, assign)NSString *reviewId;
@property(nonatomic, assign)NSInteger reviewRatingCount;
@property(nonatomic, strong)NSString *reviewTitle;
@property(nonatomic, strong)NSString *reviewDescription;
@property(nonatomic, strong)NSString *reviewTime;

@property (nonatomic, assign) BOOL liked;

// user info
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *userName;
@property (nonatomic, strong) NSString *userBio;
@property(nonatomic, strong)NSString *userAddress;
@property(nonatomic, strong)NSString *userImageUrl;
@property(nonatomic, assign)BOOL userLiked;
@property(nonatomic, assign)BOOL userRated;

- (id)initWithUserInfo:(id)userInfo;
- (id)initWithUserInfo:(id)userInfo liked:(BOOL)liked;

- (id)initWithInfo:(id)info;
- (id)initWithInfo:(id)info liked:(BOOL)liked;

- (void)fillReviewInfo:(NSDictionary *)info;
- (void)fillUserInfo:(id)userInfo;

@end
