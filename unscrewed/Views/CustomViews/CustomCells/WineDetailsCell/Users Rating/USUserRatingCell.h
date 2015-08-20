//
//  USUserRatingCell.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 17/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"

@class USWine;
@interface USUserRatingCell : UITableViewCell {
    __weak IBOutlet UILabel *lblHeader;
    __weak IBOutlet UILabel *lblReviewSummary;
    
}
@property (strong, nonatomic) IBOutlet DYRateView *viewStarRating;

- (void)fillUserRatingInfo:(USWine *)objWine;

@end
