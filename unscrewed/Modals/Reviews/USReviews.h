//
//  USReviews.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 23/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USReview.h"

@interface USReviews : NSObject

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isReachedEnd;
@property(nonatomic, strong)NSMutableArray *arrReviews;

#pragma mark - Get Reviews
- (id)initWithReviews:(NSArray *)reviews;
- (id)initWithReviews:(NSArray *)reviews likes:(NSArray *)likes;
- (id)initWithFollowing:(NSArray *)followings;

#pragma mark - Get
- (void)getReviewsForWineId:(NSString *)wineId isUserReviews:(BOOL)userReviews target:(id)target completion:(SEL)completion failure:(SEL)failure;

#pragma mark - Post Loggedin User Wine Review
- (void)postReviewOfLoggedInUserForWineId:(NSString *)wineId withInfo:(NSDictionary *)info target:(id)target completion:(SEL)completion failure:(SEL)failure;

- (void)postLoggedInUserReviewForStoreId:(NSString *)storeId withInfo:(NSDictionary *)info target:(id)target completion:(SEL)completion failure:(SEL)failure;

@end
