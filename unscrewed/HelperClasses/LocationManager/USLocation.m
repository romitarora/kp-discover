//
//  USLocation.m
//  unscrewed
//
//  Created by Gary Earle on 11/2/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USLocation.h"

@interface USLocation ()

@property double latitude;
@property double longitude;

@end

@implementation USLocation

- (id)initWithLatitude:(double)latitude andLongitude:(double)longitude
{
  if (self = [super init])
  {
    _latitude = latitude;
    _longitude = longitude;
  }

  return self;
}

- (double)latitudeAsDouble
{
  return _latitude;
}

- (double)longitudeAsDouble
{
  return _longitude;
}

- (NSString *)latitudeAsString
{
  return [NSString stringWithFormat:@"%.6f", _latitude];
}

- (NSString *)longitudeAsString
{
  return [NSString stringWithFormat:@"%.6f", _longitude];
}

@end
