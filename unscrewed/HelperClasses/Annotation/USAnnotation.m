//
//  USAnnotation.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 09/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USAnnotation.h"
#import <AddressBook/AddressBook.h>

@implementation USAnnotation

- (id)initWithRetailer:(USRetailer *)retailer {
    self = [super init];
    if (self) {
        self.latitude = retailer.latitude;
        self.longitude = retailer.longitude;
        self.title = retailer.name;
        self.subtitle = retailer.address;

        _coordinate.latitude = self.latitude;
        _coordinate.longitude = self.longitude;
    }
    return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D) coordinate {
    self = [super init];
    if(self){
        self.coordinate = coordinate;
    }
    return self;
}


- (id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    if (self = [super init]) {
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    self.latitude = newCoordinate.latitude;
    self.longitude = newCoordinate.longitude;
}

- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : self.subtitle};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
