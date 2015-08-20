//
//  PlaceMark.m
//
//  Created by kadir pekel on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlaceMark.h"


@implementation PlaceMark

@synthesize coordinate;
@synthesize place;

- (id)initWithPlace:(Place*)objPlace
{
	self = [super init];
	if (self != nil) {
		coordinate.latitude = objPlace.latitude;
		coordinate.longitude = objPlace.longitude;
		self.place = objPlace;
	}
	return self;
}

- (NSString *)subtitle
{
	return self.place.description;
}

- (NSString *)title
{
	return self.place.name;
}


@end
