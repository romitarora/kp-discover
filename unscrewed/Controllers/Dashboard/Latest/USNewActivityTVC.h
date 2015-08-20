//
//  USNewActivityTVC.h
//  unscrewed
//
//  Created by Rav Chandra on 25/09/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USPost.h"

@interface USNewActivityTVC : UITableViewController

@property (nonatomic, strong) USPost *post;
@property (nonatomic, strong) NSMutableArray *blogPosts;
@property (nonatomic) NSInteger postsCount;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) BOOL loadingNow;


@property NSString *cellValue;

@end
