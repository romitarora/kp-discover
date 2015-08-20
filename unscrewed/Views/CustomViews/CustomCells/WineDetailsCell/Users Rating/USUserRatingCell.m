//
//  USUserRatingCell.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 17/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USUserRatingCell.h"
#import "USWine.h"

@implementation USUserRatingCell

- (void)awakeFromNib {
    // Initialization code
    self.viewStarRating.fullStarImage = [UIImage imageNamed:@"wineDetailsSelectedStar"];
    self.viewStarRating.emptyStarImage = [UIImage imageNamed:@"wineDetailsGrayFilledStar"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillUserRatingInfo:(USWine *)objWine {
    lblHeader.text = @"USERS";
    self.viewStarRating.rate = floorf(objWine.averageRating);
    
    // review summary
    NSString *users;
    if (objWine.ratingsCount == 0 || objWine.ratingsCount > 1) {
        users = [NSString stringWithFormat:@"(%ld users)",(long)objWine.ratingsCount];
    } else {
        users = [NSString stringWithFormat:@"(%ld user)",(long)objWine.ratingsCount];
    }
    lblReviewSummary.text = [NSString stringWithFormat:@"%.1f out of 5 stars %@",(float)objWine.averageRating,users];
}

@end
