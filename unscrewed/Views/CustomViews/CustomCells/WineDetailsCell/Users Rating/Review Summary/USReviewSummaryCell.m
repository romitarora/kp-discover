//
//  USReviewSummaryCell.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 23/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USReviewSummaryCell.h"
#import "USProgressView.h"
#import "USReview.h"

@implementation USReviewSummaryCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        CGRect rect = CGRectMake(0, 68, kScreenWidth, 12);
        for (int i = 5; i >= 1; i--) {
            USProgressView *progressView = [[USProgressView alloc] initWithFrame:rect];
            [progressView setupProgressWith:[USReview new] atIndex:i];
            [self.contentView addSubview:progressView];
            
            rect.origin.y += rect.size.height + 10;
        }
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    self.viewStarRating.fullStarImage = [UIImage imageNamed:@"wineDetailsSelectedStar_40x40"];
    self.viewStarRating.emptyStarImage = [UIImage imageNamed:@"wineDetailsGrayFilledStar_40x40"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillReviewSummary:(USReview *)review {
    // FIXME: remove this dummy value
    review = [USReview new];
    review.reviewRatingCount = 3;
    review.summaryTitle = @"Very good";
    self.viewStarRating.rate = review.reviewRatingCount;
    lblStarSummary.text = [NSString stringWithFormat:@"%ld out of 5 stars",(long)review.reviewRatingCount];
    lblOverallRating.text = review.summaryTitle;
}

@end
