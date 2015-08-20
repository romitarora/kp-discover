//
//  USReviewsListingCell.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 20/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"

@class USReview;
@interface USReviewsListingCell : UITableViewCell {
    __weak IBOutlet UILabel *lblReviewTitle;
    __weak IBOutlet UIImageView *imgUser;
    __weak IBOutlet UIImageView *imgLiked;
    __weak IBOutlet UILabel *lblName;
    __weak IBOutlet UILabel *lblAddress;
    __weak IBOutlet UILabel *lblReviewDesc;
    __weak IBOutlet UILabel *lblReviewTime;
}
@property (strong, nonatomic) IBOutlet DYRateView *viewStarRating;

- (void)fillReviewInfo:(USReview *)review forUsers:(BOOL)isUserReviews;
+ (CGFloat)heightForCell:(USReview *)review;

@end
