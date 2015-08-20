//
//  Retailer.h
//  Unscrewed_iOS_MOCKUP
//
//  Created by Gary Earle on 8/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USRetailer : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *retailerId;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString *distance;

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *completeAddress;

@property (nonatomic, assign) bool favorited;
@property (nonatomic, assign) NSString *numOfDeals;
@property (nonatomic, strong) NSString *redWines;
@property (nonatomic, strong) NSString *whiteWines;
@property (nonatomic, strong) NSString *sparklingAndOthers;

// to be used in wine detail page :- find it
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *subtype;
@property (nonatomic, strong) NSString *winePrice;
@property (nonatomic, strong) NSString *storeUrl;

- (instancetype)initWithInfo:(id)info;
- (void)setRetailerInfo:(id)info;

@end
