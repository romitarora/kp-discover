//
//  USFollowingUsersTVC.h
//  unscrewed
//
//  Created by Robin Garg on 16/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USUserCell.h"

@interface USUsersTVC : UITableViewController

@property (nonatomic, assign) UserType userType;
@property (nonatomic, strong) NSMutableArray *arrUsers;

@end

