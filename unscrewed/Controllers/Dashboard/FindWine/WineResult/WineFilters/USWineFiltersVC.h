//
//  USWineFiltersVC.h
//  unscrewed
//
//  Created by Robin Garg on 12/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USWineFilters.h"

@protocol USWineFiltersDelegate;
@protocol USFilterValueSelectionDelegate;

@interface USWineFiltersVC : UIViewController

@property (nonatomic, assign) BOOL isNearByFilters;
@property (nonatomic, strong) USWineFilters *objWineFilters;
@property (nonatomic, weak) id<USWineFiltersDelegate> delegate;

@property (nonatomic, assign, getter=isDetailView) BOOL detailView;
@property (nonatomic, assign) BOOL sort;
@property (nonatomic, strong) USWineFilter *selectedFilter;
@property (nonatomic, weak) id<USFilterValueSelectionDelegate> valueSelectorDelegate;

@end

@protocol USWineFiltersDelegate <NSObject>

@optional
- (void)wineFilterSelectionDoneWithObject:(id)filters;
- (void)wineFilterselectionCanceled;

@end

@protocol USFilterValueSelectionDelegate <NSObject>

@optional
- (void)filterValueSelectedForFilter:(USWineFilter *)wineFilter selectedValue:(USFilterValue *)filterValue;

@end
