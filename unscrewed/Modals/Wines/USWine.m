//
//  USWine.m
//  unscrewed
//
//  Created by Rav Chandra on 21/08/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USWine.h"

@implementation USWine

- (id)initWithInfo:(id)info {
	self = [super init];
	if (self) {
		[self setWineInfo:info];
	}
	return self;
}

- (NSNumber *)updatedPrice:(NSNumber *)price {
	if (price) {
		CGFloat roundPrice = round(price.floatValue/100.f);
		return [NSNumber numberWithInteger:roundPrice];
	}
	return nil;
}

- (void)setWineInfo:(id)info {
	_wineId = [[info valueForKey:idKey] nonNull];
	// 1. Wine Name = Name + Year
	NSString *name = [[info valueForKey:nameKey] nonNull];
	NSString *year = [[info valueForKey:yearKey] nonNull];
	if (name && year) {
		_name = [NSString stringWithFormat:@"%@ %@", name, year];
	} else if (name) {
		_name = name;
	} else if (year) {
		_name = year;
	}
	_myLikedStatus = [[[info valueForKey:likedKey] nonNull] boolValue];
	_myWantsStatus = [[[info valueForKey:wantsKey] nonNull] boolValue];
	_myRatingValue = [[[info valueForKey:ratingKey] nonNull] integerValue];
    
	// 2. Wine Description = Wine Varietal from Region
	NSString *varietal = [[[info valueForKey:filterSubtypesKey] nonNull] firstObject];
    NSString *region = [[[info valueForKey:filterRegionsKey] nonNull] firstObject];
	NSString *varietalFromRegion = kEmptyString;
	if (varietal && region) {
		varietalFromRegion = [NSString stringWithFormat:@"%@ from %@", varietal, region];
	} else if (varietal) {
		varietalFromRegion = varietal;
	} else if (region) {
		varietalFromRegion = region;
	}
	_wineDescription = varietalFromRegion;
    
	// 3. Wine Image
	NSDictionary *photo = [[info valueForKey:photoKey] nonNull];
	if (photo) {
		_wineImageUrl = [NSURL URLWithString:[[photo objectForKey:url_Key] nonNull]];
	}
    
	// 4. Avg Price
	_averagePrice = [self updatedPrice:[[info valueForKey:averagePriceKey] nonNull]];
	_onlineAveragePrice = [self updatedPrice:[[info valueForKey:onlineAveragePriceKey] nonNull]];
	_restaurantAveragePrice = [self updatedPrice:[[info valueForKey:restaurantAveragePriceKey] nonNull]];
	if (_averagePrice) {
		_minAvgPrice = _averagePrice;
		if (_onlineAveragePrice) {
			_minAvgPrice = MIN(_minAvgPrice, _onlineAveragePrice);
		}
		if (_restaurantAveragePrice) {
			_minAvgPrice = MIN(_minAvgPrice, _restaurantAveragePrice);
		}
	} else if (_onlineAveragePrice) {
		_minAvgPrice = _onlineAveragePrice;
		if (_restaurantAveragePrice) {
			_minAvgPrice = MIN(_minAvgPrice, _restaurantAveragePrice);
		}
	} else if (_restaurantAveragePrice) {
		_minAvgPrice = _restaurantAveragePrice;
	}
	// Optional Displayed with Avg Price if Available
	if ([[info objectForKey:closestPlaceKey] nonNull] != nil) {
		NSDictionary *closetPlace = [[info valueForKey:closestPlaceKey] nonNull];
		_closestPlaceDistanceMiles = [[closetPlace objectForKey:distanceKey] nonNull];
		
		NSDictionary *place = [[closetPlace valueForKey:placeKey] nonNull];
		_closestPlaceName = [[place valueForKey:nameKey] nonNull];
		_closestPlaceType = [[place valueForKey:typeKey] nonNull];
		
		NSDictionary *prices = [[closetPlace valueForKey:pricesKey] nonNull];
		if (prices && prices.allKeys.count) {
			_closestPlaceWineSize  = [NSString stringWithFormat:@"%@",wineSizeKey];
			_closestPlaceWinePrice = [self updatedPrice:[[prices objectForKey:wineSizeKey] nonNull]];
		}
	} else {
		NSDictionary *prices = [[info valueForKey:pricesKey] nonNull];
		if (prices && prices.allKeys.count) {
			_closestPlaceWineSize  = [NSString stringWithFormat:@"%@",wineSizeKey];
			_closestPlaceWinePrice = [self updatedPrice:[[prices objectForKey:wineSizeKey] nonNull]];
		}
	}
	// Min Price
	_minPrice = [self updatedPrice:[[info valueForKey:minPriceKey] nonNull]];
	
	// 5. User Ratings
    _ratingsCount = [[[info valueForKey:wineRatingsCountKey] nonNull] integerValue];
	if (_ratingsCount > 0) {
		float value = [[[info valueForKey:wineAvgRatingsCountKey] nonNull] floatValue];
		_averageRating = floorf(value);
	}
	// 6. Expert Pts
	_expertPts = [[[info valueForKey:wineExpertPts] nonNull] integerValue];
	_expertValue = [HelperFunctions expertValue:_expertPts];
	
	// 7. Friends Review
    self.socialLikesCount = [[[info valueForKey:socialCountKey] nonNull] integerValue];
    NSArray *friendLikes = [[info valueForKey:socialKey] nonNull];
    if (friendLikes && friendLikes.count) {
        if (!self.socialLikesCount) {
            self.socialLikesCount = friendLikes.count;
        }
        self.objSocialLikes = [[USUsers alloc] initWithFriends:friendLikes];
    }
	// 8. Wine Type & Subtype
	NSArray *filterTypes = [[info valueForKey:filterTypesKey] nonNull];
	if (filterTypes.count > 0) {
		_wineType = [filterTypes objectAtIndex:0];
	}
	NSArray *filterSubtypes = [[info valueForKey:filterSubtypesKey] nonNull];
	if (filterSubtypes.count > 0) {
		_wineSubType = [filterSubtypes objectAtIndex:0];
	}
	// 9. Wine Value Rating
	_wineValueRating = [[USWineValueRating alloc] initWithWineValueDictionary:[[info valueForKey:wineValueKey] nonNull]];
}

- (NSString *)wineValueWithInfo:(NSDictionary *)_wineValueDictionary RetailerType:(NSString *)retailerType size:(NSString *)size price:(NSInteger)price {
	NSArray *good = [[[_wineValueDictionary objectForKey:retailerType] objectForKey:size] objectForKey:@"good"];
	NSArray *excellent = [[[_wineValueDictionary objectForKey:retailerType] objectForKey:size] objectForKey:@"excellent"];
	NSArray *incredible = [[[_wineValueDictionary objectForKey:retailerType] objectForKey:size] objectForKey:@"incredible"];
	
	if ((long)price >= [[good objectAtIndex:0] integerValue] && (long)price <
		[[good objectAtIndex:1] integerValue]) {
		return @"good";
	} else if ((long)price >= [[excellent objectAtIndex:0] integerValue] &&
			   (long)price <= [[excellent objectAtIndex:1] integerValue]) {
		return @"excellent";
	} else if ((long)price >= [[incredible objectAtIndex:0] integerValue] &&
			   (long)price <= [[incredible objectAtIndex:1] integerValue]) {
		return @"incredible";
	} else {
		return kEmptyString;
	}
}

@end
