//
//  USPlaces.h
//  unscrewed
//
//  Created by Robin Garg on 19/01/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USRetailerDetails.h"

@interface USRetailers : NSObject

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isReachedEnd;
@property (nonatomic, strong) NSMutableArray *arrPlaces;

#pragma mark - All Places
- (void)getPlacesWithParams:(NSMutableDictionary *)params target:(id)target completion:(SEL)completion failure:(SEL)failure;

#pragma mark - My Places
- (void)getMyPlaces:(id)target completion:(SEL)completion failure:(SEL)failure;

#pragma mark - Place Detail
- (void)getDetailsForPlaceId:(NSString *)placeId target:(id)target completion:(SEL)completion failure:(SEL)failure;

#pragma mark - Star / Un-star Place
- (void)setStatusAsStaredForPlace:(USRetailer *)retailer target:(id)target completion:(SEL)completion failure:(SEL)failure;
- (void)setStatusAsUnstaredForPlace:(USRetailer *)retailer target:(id)target completion:(SEL)completion failure:(SEL)failure;

#pragma mark - Live Search Places
- (BOOL)findPlacesForQueryString:(NSDictionary *)params;

- (void)parsePlaces:(NSArray *)places;
- (void)parseAutofillOffinePlacesWithResult:(NSDictionary *)result;

@end
