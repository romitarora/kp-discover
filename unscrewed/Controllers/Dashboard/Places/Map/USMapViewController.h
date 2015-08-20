//
//  MapViewController.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 09/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "USRetailers.h"

@interface USMapViewController : UIViewController
{
    __weak IBOutlet MKMapView *placesMapView;
}

@property(nonatomic,strong)USRetailers *retailers;
@property(nonatomic,strong)USRetailer *objRetailer;

@end
