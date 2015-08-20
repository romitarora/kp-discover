//
//  USReviewsListTVC.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 20/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USReviews;

@interface USReviewsListTVC : UITableViewController

@property(nonatomic, weak)NSString *wineId;
@property(nonatomic,assign)BOOL isViewingUserReviews;
@property(nonatomic, strong)USReviews *objReviews;

@property(nonatomic,assign)BOOL showHelp;
@property(nonatomic,assign)BOOL showingHelp;


@end
