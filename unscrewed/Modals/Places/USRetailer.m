//
//  Retailer.m
//  Unscrewed_iOS_MOCKUP
//
//  Created by Gary Earle on 8/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USRetailer.h"

@implementation USRetailer

- (instancetype)initWithInfo:(id)info {
    self = [super init];
    if (self) {
        [self setRetailerInfo:info];
    }
    return  self;
}

- (void)setRetailerInfo:(id)info {
    _name = [[info valueForKey:nameKey] nonNull];
    _retailerId = [[info valueForKey:idKey] nonNull];
    _latitude = [[[info valueForKey:latitudeKey] nonNull] doubleValue];
    _longitude = [[[info valueForKey:longitudeKey] nonNull] doubleValue];
	long strDistanceInMeters = [[[info valueForKeyPath:@"ranking_info.geoDistance"] nonNull] longValue];
	if (strDistanceInMeters > 0) {
		_distance = [NSString stringWithFormat:@"%.2fmi", strDistanceInMeters * 0.00062137];
	}
	
	_address = [[info valueForKey:addressKey] nonNull];
	_city = [[info valueForKey:cityKey] nonNull];
	_state = [[info valueForKey:stateKey] nonNull];
	_zipCode = [[info valueForKey:zipCodeKey] nonNull];
	_country = [[info valueForKey:countryKey] nonNull];

	if (_address) {
		_completeAddress = _address;
	}
	if (_city || _state) {
		if (_city) {
			_completeAddress = [_completeAddress stringByAppendingFormat:@"\n%@",_city];
			if (_state) {
				_completeAddress = [_completeAddress stringByAppendingFormat:@", %@",_state];
			}
		} else if (_state) {
			_completeAddress =  [_completeAddress stringByAppendingFormat:@"\n%@",_state];
		}
	}
	if (_zipCode) {
		_completeAddress =  [_completeAddress stringByAppendingFormat:@"\n%@",_zipCode];
	}

    NSDictionary *photo = [[info valueForKey:photoKey] nonNull];
    if (photo) {
        _photoUrl = [[photo objectForKey:url_Key] nonNull];
    }
    
    _type = [[info valueForKey:typeKey] nonNull];
    _subtype = [[info valueForKey:subTypeKey] nonNull];
	NSDictionary *priceDict = [[info valueForKey:pricesKey] nonNull];
	if (priceDict) {
		NSInteger price = [[[priceDict objectForKey:wineSizeKey] nonNull] integerValue];
		CGFloat roundedPrice = round(price/100.f);
		_winePrice = [NSString stringWithFormat:@"$%li",(NSInteger)roundedPrice];
        _storeUrl = [[priceDict valueForKey:storeUrlKey] nonNull];
	}
}

@end
