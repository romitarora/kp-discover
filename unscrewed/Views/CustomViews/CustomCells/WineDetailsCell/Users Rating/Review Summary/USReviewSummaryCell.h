//
//  USReviewSummaryCell.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 23/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"

@class USReview;
@interface USReviewSummaryCell : UITableViewCell
{
    __weak IBOutlet UILabel *lblOverallRating;
    __weak IBOutlet UILabel *lblStarSummary;
}

@property (strong, nonatomic) IBOutlet DYRateView *viewStarRating;

- (void)fillReviewSummary:(USReview *)review;

@end
