//
//  USWineFilter.m
//  unscrewed
//
//  Created by Robin Garg on 12/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USWineFilter.h"

@implementation USWineFilter

#pragma mark - Archiving object to disk
- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.wineFilterKey forKey:@"wineFilterKey"];
	[encoder encodeObject:self.objValues forKey:@"objValues"];
	[encoder encodeObject:self.selectedValue forKey:@"selectedValue"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super init];
	if(self) {
		self.wineFilterKey = [decoder decodeObjectForKey:@"wineFilterKey"];
		self.wineFilterTitle = [self filterTitle:self.wineFilterKey];
		self.isPillFilter = [self isPillTypeFilter:self.wineFilterKey];
		self.defaultValue = [self defaultValueForFilter:self.wineFilterKey];
		self.objValues = [decoder decodeObjectForKey:@"objValues"];
		self.selectedValue = [decoder decodeObjectForKey:@"selectedValue"];
	}
	return self;
}

- (id)initWineFilterWithKey:(NSString *)key values:(id)values {
	self = [super init];
	if (self) {
		[self fillWineFilterWithKey:key values:values];
	}
	return self;
}

- (void)fillWineFilterWithKey:(NSString *)key values:(id)values {
	_wineFilterKey = key;
	_wineFilterTitle = [self filterTitle:key];
	_isPillFilter = [self isPillTypeFilter:key];
	_defaultValue = [self defaultValueForFilter:key];
	if ([_wineFilterKey isEqualToString:filterPriceRangesKey]) {
		_objValues = [[USFilterValues alloc] initFilterValuesWithArray:[USWineFilter priceFilterValues]];
	} else if ([_wineFilterKey isEqualToString:filterExpertRatingRangesKey]) {
		_objValues = [[USFilterValues alloc] initFilterValuesWithArray:[USWineFilter expertRatingsValues]];
	} else {
		_objValues = [[USFilterValues alloc] initFilterValuesWithInfo:values];
	}
}

- (NSString *)filterTitle:(NSString *)filter {
	if ([filter isEqualToString:filterTypesKey]) {
		return @"Wine Type";
	} else if ([filter isEqualToString:filterStylesKey]) {
		return @"Style";
	} else if ([filter isEqualToString:filterPriceRangesKey]) {
		return @"Price";
	} else if ([filter isEqualToString:filterPairingsKey]) {
		return @"Pairing";
	} else if ([filter isEqualToString:filterSubtypesKey]) {
		return @"Grape Varietal";
	}else if ([filter isEqualToString:filterRegionsKey]) {
		return @"Region";
	} else if ([filter isEqualToString:filterSubRegionsKey]) {
		return @"Sub Region";
	} else if ([filter isEqualToString:filterExpertRatingRangesKey]) {
		return @"Expert Rating";
	} else if ([filter isEqualToString:filterExpertSourcesKey]) {
		return @"Reviewed By";
	} else if ([filter isEqualToString:yearKey]) {
		return @"Vintage";
	} else if ([filter isEqualToString:filterProducerKey]) {
		return @"Producer";
	}
	return filter;
}

- (NSString *)defaultValueForFilter:(NSString *)filter {
	return @"Any";
}

- (BOOL)isPillTypeFilter:(NSString *)filter {
	return ([filter isEqualToString:filterStylesKey] ||
			[filter isEqualToString:filterPriceRangesKey]);
}

+ (NSArray *)priceFilterValues {
	return @[@"Under $10",
			 @"$10 - $25",
			 @"$25 - $50",
			 @"$50 - $100",
			 @"$100 and up"];
}

+ (NSArray *)expertRatingsValues {
	return @[@"Below 80",
			 @"80 - 85",
			 @"85 - 90",
			 @"90 - 95",
			 @"95 - 100"];
}

@end
