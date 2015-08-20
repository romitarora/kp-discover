//
//  USLocationManager.h
//  unscrewed
//
//  Created by Gary Earle on 11/2/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "USLocation.h"

typedef NS_ENUM(NSInteger, SelectedLocation) {
	SelectedLocationCurrentLocation = 1,
	SelectedLocationSeattle,
	SelectedLocationLosAngeles
};

@interface USLocationManager : NSObject <CLLocationManagerDelegate>

+ (USLocationManager *)sharedInstance;

+ (BOOL)locationLoaded;

@property (readonly) CLLocationManager *locationManager;
@property (nonatomic, assign) SelectedLocation selectedLocation;

- (USLocation *)selectedLocationCordinate;
- (USLocation *)currentLocation;

@end
