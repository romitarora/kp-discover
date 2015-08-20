//
//  USWine.h
//  unscrewed
//
//  Created by Rav Chandra on 21/08/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USWineValueRating.h"
#import "USUsers.h"

@interface USWine : NSObject

@property (nonatomic, strong) NSString *wineId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *wineDescription;
@property (nonatomic, strong) NSString *wineType;
@property (nonatomic, strong) NSString *wineSubType;
@property (nonatomic, strong) NSURL *wineImageUrl;

@property (nonatomic, assign) BOOL myLikedStatus;
@property (nonatomic, assign) BOOL myWantsStatus;
@property (nonatomic, assign) NSInteger myRatingValue;

@property (nonatomic, strong) NSNumber *averagePrice;
@property (nonatomic, strong) NSNumber *onlineAveragePrice;
@property (nonatomic, strong) NSNumber *restaurantAveragePrice;
@property (nonatomic, strong) NSNumber *minAvgPrice;
@property (nonatomic, strong) NSNumber *minPrice;

@property (nonatomic, strong) NSString *closestPlaceName;
@property (nonatomic, strong) NSString *closestPlaceType;
@property (nonatomic, strong) NSString *closestPlaceWineSize;
@property (nonatomic, strong) NSNumber *closestPlaceWinePrice;
@property (nonatomic, strong) NSNumber *closestPlaceDistanceMiles;
//@property (nonatomic, strong) NSString *wineValue;
@property (nonatomic, strong) USWineValueRating *wineValueRating;

@property (nonatomic, assign) NSInteger ratingsCount;
@property (nonatomic, assign) CGFloat averageRating;

@property (nonatomic, assign) NSInteger expertPts;
@property (nonatomic, strong) NSString *expertValue;

@property (nonatomic, assign) NSInteger socialLikesCount;
@property (nonatomic, strong) USUsers *objSocialLikes;

@property (nonatomic, strong) NSString *sourceLocation;
@property (nonatomic, assign) NSInteger vintage;


- (id)initWithInfo:(id)info;
- (void)setWineInfo:(id)info;

- (NSNumber *)updatedPrice:(NSNumber *)price;

@end
