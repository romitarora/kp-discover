//
//  USFilterValue.h
//  unscrewed
//
//  Created by Robin Garg on 12/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USFilterValue : NSObject

@property (nonatomic, strong) NSString *filterValue;
@property (nonatomic, assign) NSInteger filterValueCount;

- (id)initWithValue:(NSString *)value count:(NSInteger)count;

@end
