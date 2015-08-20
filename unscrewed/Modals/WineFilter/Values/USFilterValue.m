//
//  USFilterValue.m
//  unscrewed
//
//  Created by Robin Garg on 12/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USFilterValue.h"

@implementation USFilterValue

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.filterValue forKey:@"filterValue"];
	[aCoder encodeInteger:self.filterValueCount forKey:@"filterValueCount"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		self.filterValue = [aDecoder decodeObjectForKey:@"filterValue"];
		self.filterValueCount = [aDecoder decodeIntegerForKey:@"filterValueCount"];
	}
	return self;
}

- (id)initWithValue:(NSString *)value count:(NSInteger)count {
	self = [super init];
	if (self) {
		_filterValue = [NSString stringWithString:value];
		_filterValueCount = count;
	}
	return self;
}

@end
