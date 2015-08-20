//
//  USPublicProfileTVC.h
//  unscrewed
//
//  Created by Rav Chandra on 8/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USUser.h"

@interface USPublicProfileTVC : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (strong, nonatomic) USUser *exchUserObj;

@end
