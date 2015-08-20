//
//  USDetailTVC.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 25/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol USDetailTVCDelegate <NSObject>

- (void)selectedValue:(NSString*)value;

@end

@interface USDetailTVC : UITableViewController

@property (nonatomic, strong) NSArray *arrTableDataSource;
@property (nonatomic, strong) NSString *selectedText;

@property (nonatomic, assign) BOOL removeSearchOption;

@property (nonatomic, assign) BOOL isFromFilters;

@property (nonatomic, strong) id <USDetailTVCDelegate> delegate;


@end
