//
//  USIntermediateTVC.h
//  unscrewed
//
//  Created by Ray Venenoso on 6/29/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USIntermediateCell.h"

@interface USIntermediateTVC : UITableViewController

@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) NSMutableArray *arrItems;
@property (nonatomic, strong) NSMutableDictionary *filterDictionary;
@property (nonatomic, assign) NSInteger rowIndex;

@end
