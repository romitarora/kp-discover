//
//  USFilterValues.h
//  unscrewed
//
//  Created by Robin Garg on 12/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USFilterValue.h"

@interface USFilterValues : NSObject<NSCoding>

@property (nonatomic, strong) NSMutableArray *arrValues;

- (id)initFilterValuesWithInfo:(id)info;
- (void)fillFilterValuesWithInfo:(id)info;

- (id)initFilterValuesWithArray:(NSArray *)arrValues;
- (void)fillFiltervaluesWithArray:(NSArray *)arrValues;

@end
