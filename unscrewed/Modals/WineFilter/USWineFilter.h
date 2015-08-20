//
//  USWineFilter.h
//  unscrewed
//
//  Created by Robin Garg on 12/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USFilterValues.h"

@interface USWineFilter : NSObject<NSCoding>

@property (nonatomic, strong) NSString *wineFilterTitle;
@property (nonatomic, strong) NSString *wineFilterKey;
@property (nonatomic, assign) BOOL isPillFilter;
@property (nonatomic, strong) USFilterValues *objValues;
@property (nonatomic, strong) USFilterValue *selectedValue;

@property (nonatomic, strong) NSString *defaultValue;

- (id)initWineFilterWithKey:(NSString *)key values:(id)values;
- (void)fillWineFilterWithKey:(NSString *)key values:(id)values;

@end
