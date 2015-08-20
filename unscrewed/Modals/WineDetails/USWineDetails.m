//
//  USWineDetails.m
//  unscrewed
//
//  Created by Robin Garg on 16/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USWineDetails.h"
#import "HTTPRequestManager.h"
#import "USLocationManager.h"

@implementation USWineDetails

- (void)getWineDetailsForWineId:(NSString *)wineId target:(id)target completion:(SEL)completion failure:(SEL)failure {
	HTTPRequestManager *manager = [HTTPRequestManager jsonManagerWithHeaders];
	NSString *strUrl = [NSString stringWithFormat:urlWineDetailsOfWineId,wineId];
	NSMutableDictionary *params = nil;
	USLocation *selectedLocation = [[USLocationManager sharedInstance] selectedLocationCordinate];
	if (selectedLocation) {
		params = [NSMutableDictionary new];
		[params setObject:selectedLocation.latitudeAsString forKey:latitudeKey];
		[params setObject:selectedLocation.longitudeAsString forKey:longitudeKey];
	}
	[manager GET:strUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		// Parse Result
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([[responseObject valueForKey:messageKey] nonNull]) {
				NSString *errorMsg = [responseObject objectForKey:messageKey];
				[target performSelectorOnMainThread:failure withObject:errorMsg waitUntilDone:NO];
			} else {
				self.objWineDetail = [[USWineDetail alloc] initWithInfo:responseObject];
				[target performSelectorOnMainThread:completion withObject:self.objWineDetail waitUntilDone:NO];
			}
		} else {
			// Unknown data received.
			[target performSelectorOnMainThread:failure withObject:nil waitUntilDone:NO];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[target performSelectorOnMainThread:failure withObject:error waitUntilDone:NO];
	}];
}

@end
