//
//  USLocationManager.h
//  unscrewed
//
//  Created by Gary Earle on 11/2/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USLocationManager.h"

@interface USLocationManager ()

@property double latitude;
@property double longitude;

@end

@implementation USLocationManager

- (id)init
{
	self = [super init];
	if (self)
	{
		if ([[NSUserDefaults standardUserDefaults] integerForKey:@"SelectedLocation"]) {
			self.selectedLocation = [[NSUserDefaults standardUserDefaults] integerForKey:@"SelectedLocation"];
		} else {
			self.selectedLocation = SelectedLocationCurrentLocation;
//			[self setDefaultLocation];
		}
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		_locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
		_locationManager.distanceFilter = 10;     // meters
		
		// Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
		if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
			[self.locationManager requestWhenInUseAuthorization];
		}
		[_locationManager startUpdatingLocation];
	}
	return self;
}

+ (USLocationManager *)sharedInstance
{
	static USLocationManager *sharedInstance = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [[USLocationManager alloc] init];
	});
	sharedInstance.locationManager.delegate = sharedInstance;
	
	return sharedInstance;
}

+ (BOOL)locationLoaded {
	USLocation *currentLocation = [[self sharedInstance] currentLocation];
	return (currentLocation.latitudeAsDouble != 0 && currentLocation.longitudeAsDouble != 0);
}

- (void)setSelectedLocation:(SelectedLocation)selectedLocation {
	if (_selectedLocation != selectedLocation) {
		_selectedLocation = selectedLocation;
		[[NSUserDefaults standardUserDefaults] setInteger:selectedLocation forKey:@"SelectedLocation"];
		[[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reset_page_for_new_location" object:nil];
	}
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	LogInfo(@"LOCATION locationManager:didChangeAuthorizationStatus:status %d", status);
	if (status == kCLAuthorizationStatusNotDetermined) return;
	
	if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
		status == kCLAuthorizationStatusAuthorized) {
		[_locationManager startUpdatingLocation];
	} else {
		if (self.selectedLocation == SelectedLocationCurrentLocation) {
			self.selectedLocation = SelectedLocationLosAngeles;
		}
		[_locationManager stopUpdatingLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *) locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation *location = [locations lastObject];
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (abs((int)howRecent) < 15.0) {
        // If the event is recent, do something with it.
        self.latitude = location.coordinate.latitude;
        self.longitude = location.coordinate.longitude;
        
        [[NSUserDefaults standardUserDefaults] setDouble:self.latitude forKey:@"current_lat"];
        [[NSUserDefaults standardUserDefaults] setDouble:self.longitude forKey:@"current_lon"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        LogInfo(@"LOCATION locationManager:didUpdateLocations:locations NEW latitude: %f NEW longitude: %f", self.latitude,self.longitude);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *) error {
	NSLog(@"LOCATION locationManager:didFailWithError %@", error);
}

- (USLocation *)currentLocation {
	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
	if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
		status == kCLAuthorizationStatusAuthorized) {
		return [[USLocation alloc] initWithLatitude:self.latitude andLongitude:self.longitude];
	}
	return nil;
}

- (USLocation *)seattle {
	return [[USLocation alloc] initWithLatitude:47.6097f andLongitude:-122.3331f];
}

- (USLocation *)losAngeles {
	return [[USLocation alloc] initWithLatitude:34.052234f andLongitude:-118.243685f];
}

- (USLocation *)selectedLocationCordinate {
	switch (self.selectedLocation) {
		case SelectedLocationCurrentLocation:
			return [self currentLocation];
		case SelectedLocationSeattle:
			return [self seattle];
		default:
			return [self losAngeles];
	}
}

- (void)setDefaultLocation {
    // FIXME: Below lat lngs are for Santa monica. Change this to LA. See above values
	// default the lat/long to Los Angeles
	self.latitude = 34.001492;
	self.longitude = -118.485951;
}

@end
