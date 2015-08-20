//
//  USWines.h
//  unscrewed
//
//  Created by Robin Garg on 09/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USSnappedWine.h"
#import "USWine.h"

@interface USWines : NSObject

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isReachedEnd;
@property (nonatomic, strong) NSMutableArray *arrWines;

- (void)parseAutofillWinesWithResult:(NSDictionary *)result;

- (void)getWinesWithParams:(NSMutableDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure;

- (void)getFriendLikeWinesWithParams:(NSMutableDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure;

- (void)getMyWinesWithParams:(NSMutableDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure;

- (void)likeWineWithId:(NSString *)wineId target:(id)target completion:(SEL)completion failure:(SEL)failure;
- (void)unlikeWineWithId:(NSString *)wineId target:(id)target completion:(SEL)completion failure:(SEL)failure;

- (void)wantWineWithId:(NSString *)wineId target:(id)target completion:(SEL)completion failure:(SEL)failure;
- (void)removeWantWineWithId:(NSString *)wineId target:(id)target completion:(SEL)completion failure:(SEL)failure;

- (void)rateWineWithId:(NSString *)wineId param:(NSDictionary *)param target:(id)target completion:(SEL)completion failure:(SEL)failure;

- (void)deleteWineWithId:(NSString *)wineId target:(id)target completion:(SEL)completion failure:(SEL)failure;

- (BOOL)findWinesForQueryString:(NSDictionary *)params;

// Snapped Wines
- (void)uploadSnappedWineImageWithParams:(NSDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure;

@end
