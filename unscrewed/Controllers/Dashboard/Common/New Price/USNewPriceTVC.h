//
//  USNewPriceTVC.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 25/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OpenFor) {
	OpenForPriceChange,
	OpenForPriceChagneForRetailer,
	OpenForAddWineInRetailer
};

@class USRetailer;

@interface USNewPriceTVC : UITableViewController

@property (nonatomic, assign) OpenFor openFor;

@property(nonatomic, assign) BOOL addingWine;
@property (nonatomic, strong) UIImage *wineImage;

@property (nonatomic, strong) USRetailer *objRetailer;

@property(nonatomic, strong) NSString *wineId;

@end
