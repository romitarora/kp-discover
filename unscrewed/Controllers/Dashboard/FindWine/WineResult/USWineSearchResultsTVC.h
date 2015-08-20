//
//  USWineSearchResultsTVC.h
//  unscrewed
//
//  Created by Rav Chandra on 22/08/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USWinePreferenceSelectionTVC.h"

@class USRetailer;
@interface USWineSearchResultsTVC : UITableViewController <USWinePreferenceSelectionDelegate>

@property (nonatomic, strong) NSString *wineHeaderTitle;
@property (nonatomic, strong) NSMutableDictionary *wineSearchArguments;
@property (nonatomic, strong) NSString *wineColorSelected;
@property (nonatomic, strong) USRetailer *objRetailer;
@property (nonatomic, strong) USWineFilters *objWineFilters;

@property (nonatomic) NSString *initialSearchCategorySelected;
@property (nonatomic) NSString *retailerSelected;
@property (nonatomic) NSString *retailerTypeSelected;
@property (nonatomic) BOOL friends;
@property (nonatomic) BOOL myWines;

- (IBAction)menuButtonClick:(id)sender;

@end
