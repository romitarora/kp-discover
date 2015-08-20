//
//  USLocation.h
//  unscrewed
//
//  Created by Gary Earle on 11/2/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USLocation : NSObject

- (id)initWithLatitude:(double)latitude andLongitude:(double)longitude;

- (double)latitudeAsDouble;
- (double)longitudeAsDouble;

- (NSString *)latitudeAsString;
- (NSString *)longitudeAsString;

@end
