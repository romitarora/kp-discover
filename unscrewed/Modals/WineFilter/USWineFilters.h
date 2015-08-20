//
//  USWineFilters.h
//  unscrewed
//
//  Created by Robin Garg on 12/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USWineFilter.h"

@interface USWineFilters : NSObject<NSCoding>

@property (nonatomic, strong) USWineFilter *sortFilter;
@property (nonatomic, strong) USWineFilter *distanceFilter;

@property (nonatomic, strong) NSMutableArray *arrFilters;

+ (USWineFilter *)wineStyleFilterForValue:(USFilterValue *)value;

- (void)fillSortFilterWithSelectedValue:(NSString *)sort;
- (void)fillDistanceFilterWithSelectedValue:(NSString *)radius;

- (void)getWineFiltersWithTarget:(id)target completion:(SEL)completion failure:(SEL)failure;

@end
