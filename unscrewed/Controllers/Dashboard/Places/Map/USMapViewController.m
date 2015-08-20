//
//  MapViewController.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 09/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USMapViewController.h"
#import "USAnnotation.h"
#import "USLocationManager.h"
#import "MapView.h"

#define METERS_PER_MILE 1600

@interface USMapViewController ()
{
    MapView *_mapView;
}
@end

@implementation USMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonActionEvent)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.objRetailer) {
        [self getDirectionsForRetailer];
    } else {
        [self setupAnnotations];
        LogInfo(@"Number of annotations = %ld",(unsigned long)placesMapView.annotations.count);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Annotations
- (void)setupAnnotations {
    int counter = 0;
    for (USRetailer *objRetailer in self.retailers.arrPlaces) {
        counter++;
        USAnnotation *annotation = [[USAnnotation alloc] initWithRetailer:objRetailer];
        [placesMapView addAnnotation:annotation];
        if (counter == 15) {
            break;
        }
    }
    
    // setup zoom level
    [self zoomToFitMapAnnotations:placesMapView];
}

- (void)zoomToFitMapAnnotations:(MKMapView*)mapView {
    if([mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(USAnnotation* annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}


- (void)getDirectionsForRetailer {
    LogInfo(@"show directions tapped. Open maps app");
    _mapView = [[MapView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_mapView];
    
    LogInfo(@"User Location ( LAT ) - %@",[[USLocationManager sharedInstance] selectedLocationCordinate].latitudeAsString);
    LogInfo(@"User Location ( LNG ) - %@",[[USLocationManager sharedInstance] selectedLocationCordinate].longitudeAsString);
    Place* userLocation = [[Place alloc] init];
    userLocation.name = @"You";
    userLocation.description = @"Current Location";
    userLocation.latitude = [[USLocationManager sharedInstance] selectedLocationCordinate].latitudeAsDouble;
    userLocation.longitude = [[USLocationManager sharedInstance] selectedLocationCordinate].longitudeAsDouble;
    
    LogInfo(@"Destination ( LAT ) - %f",self.objRetailer.latitude);
    LogInfo(@"Destination ( LNG ) - %f",self.objRetailer.longitude);
    
    Place* retailerLocation = [[Place alloc] init];
    retailerLocation.name = self.objRetailer.name;
    retailerLocation.description = self.objRetailer.address;
    retailerLocation.latitude = self.objRetailer.latitude;
    retailerLocation.longitude = self.objRetailer.longitude;
    
    [_mapView showRouteFrom:userLocation to:retailerLocation];
}


#pragma mark - Map Delegates
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"places_annoatation_view";
    if ([annotation isKindOfClass:[USAnnotation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            // here we can use a nice image instead of the default pins
//            annotationView.image = [UIImage imageNamed:@"pin.png"];
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];;
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

// Add the following method
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    DLog(@"Open maps app if requried");
//    USAnnotation *anotation = (USAnnotation*)view.annotation;
//    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
//    [anotation.mapItem openInMapsWithLaunchOptions:launchOptions];
}

#pragma mark - Cancel Bar Button Action
- (void)cancelBarButtonActionEvent {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
