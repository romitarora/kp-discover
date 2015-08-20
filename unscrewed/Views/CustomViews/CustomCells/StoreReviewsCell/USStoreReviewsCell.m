//
//  USStoreReviewsCell.m
//  unscrewed
//
//  Created by Robin Garg on 26/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USStoreReviewsCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "USRetailerDetails.h"
#import "UILabel+LineHeight.h"

@implementation USStoreReviewsCell

- (void)awakeFromNib {
    // Initialization code
	[lblHeader setFont:[USFont sectionTitleFont]];
	[lblStoreReviewTitle setFont:[USFont storeReviewTitleFont]];
    [lblStoreReveiw setLineHeight:18.f];
	[lblStoreReveiw setFont:[USFont storeReviewFont]];
	[lblUserInfo setFont:[USFont storeReivewPostedAtFont]];
	
	[lblUserInfo setTextColor:[USColor storeReviewUserInfoColor]];
	
	[imgViewUserProfile.layer setCornerRadius:CGRectGetHeight(imgViewUserProfile.frame)*0.5f];
	[imgViewUserProfile setClipsToBounds:YES];
}

+ (CGFloat)getHeightOfDescription:(NSString *)reviewDescription {
	if (reviewDescription && reviewDescription.length > 0) {
		CGRect rect = [reviewDescription rectWithSize:CGSizeMake(220, CGFLOAT_MAX) font:[USFont storeReviewFont]];

        /**
         *  because store review description can only be max 6 line long
         */
		CGFloat textHeight = ceilf(CGRectGetHeight(rect));
        float numberOfLines = ceilf(textHeight / ceilf([USFont storeReviewFont].lineHeight));
        CGFloat maxHeight = 18 * 6;
		return MIN(numberOfLines * 18, maxHeight);
	}
	return 0.f;
}

+ (CGFloat)cellHeightForRetailer:(USRetailerDetails *)retailerDetails forIndex:(NSInteger)rowIndex {
	if (retailerDetails.storeReviewsCount > 0) {
		USReview *storeReview = [retailerDetails.storeReviews.arrReviews objectAtIndex:rowIndex];
        storeReview.reviewDescription = storeReview.reviewDescription;
        return [self getHeightOfDescription:storeReview.reviewDescription] + (rowIndex == 0 ? 101.f : 60)-5;
	}
	return 44.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)positionControlsBasedOnDescription {
	CGFloat descriptionHeight = [USStoreReviewsCell getHeightOfDescription:lblStoreReveiw.text];
	CGRect rectReviewDesc = lblStoreReveiw.frame;
	rectReviewDesc.size.height = descriptionHeight;
    rectReviewDesc.origin.y = lblStoreReviewTitle.frame.origin.y+18;
    
    CGRect rect = lblHeader.frame;
    rect.origin.y = 16.f;
    lblHeader.frame = rect;
    
    if(lblHeader.text.length == 0) {
        CGRect rectTitle = lblStoreReviewTitle.frame;
        rectTitle.origin.y = CGRectGetMinY(lblHeader.frame);
        lblStoreReviewTitle.frame = rectTitle;
        
        CGRect rectImage = imgViewUserProfile.frame;
        rectImage.origin.y = CGRectGetMinY(lblHeader.frame) + 3;
        imgViewUserProfile.frame = rectImage;
        
        rectReviewDesc.origin.y = CGRectGetMaxY(lblStoreReviewTitle.frame)-8;
    }
    lblStoreReveiw.frame = rectReviewDesc;
    
    CGRect rectUserInfo = lblUserInfo.frame;
    rectUserInfo.origin.y = CGRectGetMaxY(lblStoreReveiw.frame)+2;//-4;

    lblUserInfo.frame = rectUserInfo;
}


- (void)fillStoreReviewCellWithInfo:(USRetailerDetails *)retailerDetails forIndex:(NSInteger)rowIndex {
	[self.textLabel setText:kEmptyString];
	if (retailerDetails.storeReviewsCount > 0) {
        if (rowIndex == 0) {
            if (retailerDetails.storeReviewsCount == 1) {
                [lblHeader setText:[NSString stringWithFormat:@"%d TIP & COMMENT",(int)retailerDetails.storeReviewsCount]];
            } else {
                [lblHeader setText:[NSString stringWithFormat:@"%d TIPS & COMMENTS",(int)retailerDetails.storeReviewsCount]];
            }
        } else {
            [lblHeader setText:kEmptyString];
        }
        
		USReview *storeReview = [retailerDetails.storeReviews.arrReviews objectAtIndex:rowIndex];
		NSURL *profileUrl = [NSURL URLWithString:storeReview.userImageUrl];
		if (profileUrl) {
			[imgViewUserProfile setImageWithURL:profileUrl placeholderImage:[UIImage imageNamed:@"dummy_gray"]];
		}
		[lblStoreReviewTitle setText:storeReview.reviewTitle];
		// FIXME: remove this dummy later once title is returning from api
		if (!storeReview.reviewTitle || !storeReview.reviewTitle.length) {
			[lblStoreReviewTitle setText:@"Title doesn't set"];
		}
		[lblStoreReveiw setText:storeReview.reviewDescription];
		[self positionControlsBasedOnDescription];
        
		NSString *strUserName = storeReview.userName;
        NSString *strDate = storeReview.reviewTime;
		NSString *strUserInfo = [NSString stringWithFormat:@"%@ on %@",strUserName, strDate];
		
		NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strUserInfo];
		NSRange userNameRange = [strUserInfo rangeOfString:strUserName];
		if (userNameRange.length) {
			[attrString addAttribute:NSFontAttributeName value:[USFont storeReviewUserInfo] range:userNameRange];
		}
		[lblUserInfo setAttributedText:attrString];
	} else {
		[self.textLabel setText:@"No Reviews Found"];
	}
}

@end
