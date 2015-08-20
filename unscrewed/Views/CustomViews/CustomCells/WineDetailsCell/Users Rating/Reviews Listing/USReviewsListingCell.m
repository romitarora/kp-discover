//
//  USReviewsListingCell.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 20/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USReviewsListingCell.h"
#import "USReview.h"
#import "UIImageView+AFNetworking.h"

@interface USReviewsListingCell ()
{
    CGRect rectImageLiked, rectReviewTitle;
}
@property(nonatomic,strong) USReview *objReview;

@end

@implementation USReviewsListingCell

- (void)awakeFromNib {
    imgUser.layer.cornerRadius = CGRectGetWidth(imgUser.frame) / 2;
    imgUser.layer.masksToBounds = YES;
    
    self.viewStarRating.fullStarImage = [UIImage imageNamed:@"wineDetailsSelectedStar_40x40"];
    self.viewStarRating.emptyStarImage = [UIImage imageNamed:@"wineDetailsGrayFilledStar_40x40"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  Will setup the review listing cell
 *
 *  @param objWine will be an object of USWine model
 */
- (void)fillReviewInfo:(USReview *)review forUsers:(BOOL)isUserReviews {
    self.objReview = review;
    
    lblReviewTitle.text = self.objReview.reviewTitle;
    lblReviewDesc.text = self.objReview.reviewDescription;
    lblReviewTime.text = self.objReview.reviewTime;
    
    lblName.text = self.objReview.userName;
    lblAddress.text = self.objReview.userBio;
	[imgUser setImage:[UIImage imageNamed:@"dummy_gray"]];
	if (self.objReview.userImageUrl) {
		[imgUser setImageWithURL:[NSURL URLWithString:self.objReview.userImageUrl] placeholderImage:nil];
	}
    /**
     *  arrange the views based on the rating values i.e.
     *  - show imgLiked only if user has liked this wine
     *  - show rateView only if user has rated the wine
     *  - resize the cell based on the review description length
     *  - adjust lblReviewTime frame accordingly based on lblReviewDesc height.
     */
    [self arrangeViews];
}


- (void)arrangeViews {
    rectImageLiked = imgLiked.frame;
    rectReviewTitle = lblReviewTitle.frame;
    if (self.objReview.reviewRatingCount == 0) {
        self.viewStarRating.hidden = YES;
    } else {
        self.viewStarRating.rate = self.objReview.reviewRatingCount;
    }
    [self resizeViewsWithLikedStatus:self.objReview.liked rateStatus:(self.objReview.reviewRatingCount != 0)];
    
    [lblReviewDesc sizeToFit];
	if (CGRectGetHeight(lblReviewDesc.frame) > 0) {
		CGRect rect = lblReviewTime.frame;
		rect.origin.y = CGRectGetMaxY(lblReviewDesc.frame) + 3.f;
		lblReviewTime.frame = rect;
	}
}

- (void)resizeViewsWithLikedStatus:(BOOL)liked rateStatus:(BOOL)rated {
    if (liked) {
        rectImageLiked.origin.x = (rated ? CGRectGetMinX(self.viewStarRating.frame) + CGRectGetWidth(self.viewStarRating.frame) + 8 : CGRectGetMinX(self.viewStarRating.frame));
        rectReviewTitle.origin.x = rectImageLiked.origin.x + CGRectGetWidth(imgLiked.frame) + 8;
    } else {
        imgLiked.hidden = YES;
        rectReviewTitle.origin.x = (rated ? CGRectGetMinX(self.viewStarRating.frame) + CGRectGetWidth(self.viewStarRating.frame) + 8 : CGRectGetMinX(self.viewStarRating.frame));
    }
    rectReviewTitle.size.width = kScreenWidth - rectReviewTitle.origin.x - 20;
    
    imgLiked.frame = rectImageLiked;
    lblReviewTitle.frame = rectReviewTitle;
}

+ (CGFloat)heightForCell:(USReview *)review {
	/*
    review = [USReview new];
    review.reviewDescription = @"This is a fantasic wine. I love to pair it with roasted chicken and other bistro classsic like fried seafood and potatoes.";
	*/
    float heightAboveDesc = 90.f;
    float heightBelowDesc = 15.f + 3.f; // 15.f Height of review posted time + 3.f padding between description and time
    float padding = 20.f;
    CGSize textSize = [review.reviewDescription boundingRectWithSize:CGSizeMake(kScreenWidth - 30, CGFLOAT_MAX)
                                                    options:NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:@{NSFontAttributeName: [USFont meSecionValueCountFont]}
                                                    context:nil].size;
    CGFloat bubbleHeight = ceil(textSize.height) + ceil(heightAboveDesc) + ceil(heightBelowDesc) + ceil(padding);
    return bubbleHeight;
}

@end
