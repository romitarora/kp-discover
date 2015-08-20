//
//  USMyWineFiltersTVC.h
//  unscrewed
//
//  Created by Robin Garg on 11/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol USMyWineFiltersDelegate <NSObject>

@optional
- (void)myWinesFilterSelectionCompletedForSorting:(BOOL)sorting;

@end

@interface USMyWineFiltersTVC : UITableViewController

@property (nonatomic, weak) id<USMyWineFiltersDelegate> delegate;

@end
