//
//  USFilterValues.m
//  unscrewed
//
//  Created by Robin Garg on 12/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USFilterValues.h"

@implementation USFilterValues

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.arrValues forKey:@"arrValues"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (self) {
		self.arrValues = [aDecoder decodeObjectForKey:@"arrValues"];
	}
	return self;
}

- (id)initFilterValuesWithInfo:(id)info {
	self = [super init];
	if (self) {
		[self fillFilterValuesWithInfo:info];
	}
	return self;
}

- (void)fillFilterValuesWithInfo:(NSDictionary *)info {
	NSArray *arrValues = [info allKeys];
	if (!arrValues || arrValues.count == 0) return;
	self.arrValues = [NSMutableArray new];
	for (NSString *value in arrValues) {
		NSInteger count = [[[info objectForKey:value] nonNull] integerValue];
		USFilterValue *objValue = [[USFilterValue alloc] initWithValue:value count:count];
		[self.arrValues addObject:objValue];
	}
}

- (id)initFilterValuesWithArray:(NSArray *)arrValues {
	self = [super init];
	if (self) {
		[self fillFiltervaluesWithArray:arrValues];
	}
	return self;
}

- (void)fillFiltervaluesWithArray:(NSArray *)arrValues {
	if (!arrValues || arrValues.count == 0) return;
	self.arrValues = [NSMutableArray new];
	for (NSString *value in arrValues) {
		USFilterValue *objValue = [[USFilterValue alloc] initWithValue:value count:0];
		[self.arrValues addObject:objValue];
	}
}

@end
