//
//  USAnnotation.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 09/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "USRetailer.h"

@interface USAnnotation : NSObject<MKAnnotation>
{
    NSString *_title;
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithRetailer:(USRetailer *)retailer;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
- (MKMapItem*)mapItem;

@end
