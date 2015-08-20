//
//  USProgressView.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 23/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USProgressView.h"
#import "USReview.h"

@implementation USProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lblRateTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 36, 12)];
        [self.lblRateTitle setFont:[USFont wineDescriptionFont]];
        [self.lblRateTitle setTextColor:[USColor themeNormalTextColor]];
        [self addSubview:self.lblRateTitle];
        
        self.viewGrayedOut = [[UIImageView alloc] initWithFrame:CGRectMake(61, 0, 130, 12)];
        [self.viewGrayedOut setBackgroundColor:[USColor grayedStarColor]];
        [self addSubview:self.viewGrayedOut];

        self.viewColored = [[UIImageView alloc] initWithFrame:CGRectMake(61, 0, 130, 12)];
        [self.viewColored setBackgroundColor:[USColor highlightedStarColor]];
        [self addSubview:self.viewColored];
        
        self.lblRateValue = [[UILabel alloc] initWithFrame:CGRectMake(203, 0, 65, 12)];
        [self.lblRateValue setFont:[USFont wineDescriptionFont]];
        [self.lblRateValue setTextColor:[USColor wineCellDescriptionColor]];
        [self addSubview:self.lblRateValue];
    }
    return self;
}

- (void)setupProgressWith:(USReview *)review atIndex:(int)index {
    
    // FIXME: remove below dummy values
    review.reviewRatingCount = 310;
    NSInteger width;
    switch (index) {
        case 5:
            review.star_5_Rating = 43;
            [self.lblRateTitle setText:@"5 star"];
            [self.lblRateValue setText:[NSString stringWithFormat:@"%ld",(long)review.star_5_Rating]];
            width = [self calculateWidthPercentage:review forStarRating:review.star_5_Rating];
            break;
        case 4:
            review.star_4_Rating = 112;
            [self.lblRateTitle setText:@"4 star"];
            [self.lblRateValue setText:[NSString stringWithFormat:@"%ld",(long)review.star_4_Rating]];
            width = [self calculateWidthPercentage:review forStarRating:review.star_4_Rating];
            break;
        case 3:
            review.star_3_Rating = 128;
            [self.lblRateTitle setText:@"3 star"];
            [self.lblRateValue setText:[NSString stringWithFormat:@"%ld",(long)review.star_3_Rating]];
            width = [self calculateWidthPercentage:review forStarRating:review.star_3_Rating];
            break;
        case 2:
            review.star_2_Rating = 6;
            [self.lblRateTitle setText:@"2 star"];
            [self.lblRateValue setText:[NSString stringWithFormat:@"%ld",(long)review.star_2_Rating]];
            width = [self calculateWidthPercentage:review forStarRating:review.star_2_Rating];
            break;
        default:
            review.star_1_Rating = 21;
            [self.lblRateTitle setText:@"1 star"];
            [self.lblRateValue setText:[NSString stringWithFormat:@"%ld",(long)review.star_1_Rating]];
            width = [self calculateWidthPercentage:review forStarRating:review.star_1_Rating];
            break;
    }
    [self.viewColored setFrame:CGRectMake(CGRectGetMinX(self.viewColored.frame), CGRectGetMinY(self.viewColored.frame), width, CGRectGetHeight(self.viewColored.frame))];
}

- (NSInteger)calculateWidthPercentage:(USReview *)review forStarRating:(NSInteger)currentStarRating {
    float percentage = ((float)currentStarRating / (float)review.reviewRatingCount) * CGRectGetWidth(self.viewColored.frame);
    return ceil(percentage);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
