//
//  USExpertReviewsTVC.h
//  unscrewed
//
//  Created by Robin Garg on 20/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USExpertReviews;
@class USExpertReview;

@interface USExpertReviewsTVC : UITableViewController

@property (nonatomic, strong) USExpertReviews *objExpertReviews;
@property (nonatomic, strong) USExpertReview *expertReview;

@end
