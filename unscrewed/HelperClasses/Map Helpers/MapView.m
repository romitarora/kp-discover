//
//  MapViewController.m
//
//  Created by kadir pekel on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapView.h"

@interface MapView()

- (NSMutableArray *)decodePolyLine:(NSMutableString *)encoded;

@end

@implementation MapView

@synthesize lineColor;

- (id) initWithFrame:(CGRect) frame
{
	self = [super initWithFrame:frame];
	if (self != nil) {
		mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		mapView.showsUserLocation = YES;
		[mapView setDelegate:self];
		[self addSubview:mapView];

		self.lineColor = [USColor themeSelectedColor];
	}
	return self;
}

#pragma mark - Remove Views
- (void)closeRouteView:(id)sender {
    [UIView animateWithDuration:0.30 animations:^{
        self.alpha = 0.0;
    }];
    [self performSelector:@selector(removeMe) withObject:nil afterDelay:0.30];
}

- (void)removeMe {
    [self removeFromSuperview];
    self.alpha = 1.0;
}

#pragma mark - Decode
- (NSMutableArray *)decodePolyLine:(NSMutableString *)encoded {
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0,     [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        LogInfo("[%f,", [latitude doubleValue]);
        LogInfo("%f]", [longitude doubleValue]);
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:loc];
    }
    
    return array;
}

- (NSMutableArray *)getDirectionRoutesFrom:(NSString *)saddr1 to:(NSString *)daddr {
    NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr1, daddr];
    NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
    NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSUTF8StringEncoding   error:nil];
    NSString* encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
    return [self decodePolyLine:[encodedPoints mutableCopy]];
}

#pragma mark - Make Route
- (void)showRouteFrom:(Place*)fromPlace to:(Place*)toPlace {
	if(routes) {
		[mapView removeAnnotations:[mapView annotations]];
	}
	
	PlaceMark* from = [[PlaceMark alloc] initWithPlace:fromPlace];
	PlaceMark* to = [[PlaceMark alloc] initWithPlace:toPlace];
	
	[mapView addAnnotation:from];
	[mapView addAnnotation:to];
	
    NSString * saddr = [NSString stringWithFormat:@"%f,%f",from.coordinate.latitude, from.coordinate.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f",to.coordinate.latitude, to.coordinate.longitude];
    LogInfo(@"source - %@ and destination - %@",saddr,daddr);
    routes = [[self getDirectionRoutesFrom:[saddr copy] to:[daddr mutableCopy]] mutableCopy];
    
    if(routes.count) {
        [self drawRoute:routes];
        [self zoomMapViewToFitAnnotationsWithExtraZoomToAdjust:0.f];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlert message:@"Unable to find route at the moment" delegate:self cancelButtonTitle:kOk otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)drawRoute:(NSArray *)path {
    NSInteger numberOfSteps = path.count;
    
    CLLocationCoordinate2D coordinates[numberOfSteps];
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        CLLocation *location = [path objectAtIndex:index];
        CLLocationCoordinate2D coordinate = location.coordinate;
        
        coordinates[index] = coordinate;
    }
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
    [mapView addOverlay:polyLine];
}

#pragma mark - MKOverlayView
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor redColor];
    polylineView.fillColor = [UIColor blueColor];
    polylineView.lineWidth = 10.0;
    return polylineView;
}

#pragma mark - Zoom
- (void)zoomMapViewToFitAnnotationsWithExtraZoomToAdjust:(double)extraZoom {
    if ([mapView.annotations count] == 0) return;
    
    int i = 0;
    MKMapPoint points[[mapView.annotations count]];
    
    for (id<MKAnnotation> annotation in mapView.annotations) {
        points[i++] = MKMapPointForCoordinate(annotation.coordinate);
    }
    
    MKPolygon *poly = [MKPolygon polygonWithPoints:points count:i];
    
    MKMapRect rectToZoom = [poly boundingMapRect];
    rectToZoom.origin.x -= rectToZoom.origin.x * .05;
    rectToZoom.size.width += rectToZoom.size.width * .25;
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(rectToZoom);
    region.span.latitudeDelta += extraZoom;
    region.span.longitudeDelta += extraZoom;
    
    [mapView setRegion:region animated:NO];
}


@end
