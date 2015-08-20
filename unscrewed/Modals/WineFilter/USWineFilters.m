//
//  USWineFilters.m
//  unscrewed
//
//  Created by Robin Garg on 12/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USWineFilters.h"
#import "HTTPRequestManager.h"

@implementation USWineFilters

+ (USWineFilter *)wineStyleFilterForValue:(USFilterValue *)value {
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"wine_style" ofType:@"plist"];
	NSDictionary *styleDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSDictionary *valueDict = [styleDict objectForKey:value.filterValue.lowercaseString];
	if (valueDict) {
		return [[USWineFilter alloc] initWineFilterWithKey:filterStylesKey values:valueDict];
	}
	return nil;
}

#pragma mark - Archiving object to disk
- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.arrFilters forKey:@"arrFilters"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super init];
	if(self) {
		[self fillSortFilterWithSelectedValue:nil];
		[self fillDistanceFilterWithSelectedValue:nil];
		self.arrFilters = [decoder decodeObjectForKey:@"arrFilters"];
	}
	return self;
}

- (NSArray *)orderedFilter {
	return [NSArray arrayWithObjects:
			filterTypesKey,
			filterPriceRangesKey,
			filterPairingsKey,
			filterSubtypesKey,
			filterRegionsKey,
			filterSubRegionsKey,
			filterExpertRatingRangesKey,
			filterExpertSourcesKey,
			yearKey, nil];
}

- (void)fillSortFilterWithSelectedValue:(NSString *)sort {
	self.sortFilter = [[USWineFilter alloc] init];
	self.sortFilter.wineFilterTitle = @"Sort By";
	self.sortFilter.wineFilterKey = @"sort_by";
	self.sortFilter.objValues = [[USFilterValues alloc] initFilterValuesWithInfo:[HelperFunctions wineSortOptions]];
	self.sortFilter.defaultValue = @"Best Value";
	NSString *selectedSortType = [[NSUserDefaults standardUserDefaults] objectForKey:kWinesSortTypeKey];
	if (selectedSortType) {
		self.sortFilter.selectedValue = [HelperFunctions filterValueForSelectedValue:selectedSortType
																			  values:self.sortFilter.objValues];
	} else {
		self.sortFilter.selectedValue = [HelperFunctions filterValueForSelectedValue:self.sortFilter.defaultValue
																			  values:self.sortFilter.objValues];
	}
}

- (void)fillDistanceFilterWithSelectedValue:(NSString *)radius {
	self.distanceFilter = [[USWineFilter alloc] init];
	self.distanceFilter.wineFilterTitle = @"Distance";
	self.distanceFilter.wineFilterKey = @"radius";
	self.distanceFilter.objValues = [[USFilterValues alloc] initFilterValuesWithInfo:[HelperFunctions distanceFilterOptions]];
	self.distanceFilter.defaultValue = @"5";
	NSString *selectedWineDistance = [[NSUserDefaults standardUserDefaults] objectForKey:kWinesDistanceKey];
	if (selectedWineDistance) {
		self.distanceFilter.selectedValue =
		[HelperFunctions filterValueForSelectedValue:selectedWineDistance values:self.distanceFilter.objValues];
	} else {
		self.distanceFilter.selectedValue =
		[HelperFunctions filterValueForSelectedValue:self.distanceFilter.defaultValue
											  values:self.distanceFilter.objValues];
	}
}

- (void)parseFilters:(NSDictionary *)wineFilters {
	if (!wineFilters || wineFilters.allKeys.count == 0) return;
	// Parse filters
	self.arrFilters = nil;
	self.arrFilters = [NSMutableArray new];
	NSMutableDictionary *mutableWineFilters = wineFilters.mutableCopy;
	NSArray *orderedFilter = [self orderedFilter];
	for (NSString *filter in orderedFilter) {
		NSDictionary *filterDict = [[wineFilters objectForKey:filter] nonNull];
		if (filterDict) {
			USWineFilter *objFilter = [[USWineFilter alloc] initWineFilterWithKey:filter values:filterDict];
			[self.arrFilters addObject:objFilter];
			// Remove parsed filter
			[mutableWineFilters removeObjectForKey:filter];
		}
	}
	NSArray *arrFilterKeys = [mutableWineFilters allKeys];
	for (NSString *filter in arrFilterKeys) {
		NSDictionary *filterDict = [[mutableWineFilters objectForKey:filter] nonNull];
		USWineFilter *objFilter = [[USWineFilter alloc] initWineFilterWithKey:filter values:filterDict];
		[self.arrFilters addObject:objFilter];
	}
}

- (void)getWineFiltersWithTarget:(id)target completion:(SEL)completion failure:(SEL)failure {
	HTTPRequestManager *manager = [HTTPRequestManager jsonManager];
	[manager GET:urlWineFilters parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:wineFiltersKey] nonNull]) {
				NSDictionary *wineFilters = [responseObject valueForKey:wineFiltersKey];
				[self parseFilters:wineFilters];
				[target performSelectorOnMainThread:completion withObject:self waitUntilDone:NO];
			} else {
				[target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
			}
		} else {
			// Unknown data received.
			[target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
	}];

}

@end
