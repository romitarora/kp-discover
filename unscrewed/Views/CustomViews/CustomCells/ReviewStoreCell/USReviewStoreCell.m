//
//  USReviewStoreCell.m
//  unscrewed
//
//  Created by Robin Garg on 26/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USReviewStoreCell.h"
#import "USRetailerDetails.h"
#import "USUsers.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface USReviewStoreCell ()<UITextViewDelegate>

@property (nonatomic, weak)   IBOutlet UIImageView *imgViewUserProfile;
@property (nonatomic, strong) IBOutlet UITextView *textViewUserReview;

@end

@implementation USReviewStoreCell

- (void)awakeFromNib {
    // Initialization code
	[self.imgViewUserProfile.layer setCornerRadius:CGRectGetHeight(self.imgViewUserProfile.frame)*0.5f];
	[self.imgViewUserProfile setClipsToBounds:YES];
    
    [self.textViewUserReview setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
    self.textViewUserReview.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
	[self.textViewUserReview.layer setCornerRadius:5.f];
    [self.textViewUserReview.layer setBorderWidth:1];//[UIScreen mainScreen].scale*0.5f];
    [self.textViewUserReview.layer setBorderColor:[USColor colorFromHexString:@"#afafaf"].CGColor];
	//[self.textViewUserReview.layer setBorderColor:[UIColor colorWithWhite:(177.f/255.f) alpha:1.f].CGColor];
    [self.textViewUserReview setTextColor:[USColor colorFromHexString:@"#afafaf"]];
	//[self.textViewUserReview setTextColor:[UIColor colorWithRed:(137.f/255.f) green:(141.f/255.f) blue:(143.f/255.f) alpha:1.f]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateReviewStoreTextTo:(NSString *)review {
	if (review) {
		[self.textViewUserReview setText:review];
	} else {
		[self.textViewUserReview setText:@"Add a tip or comment"];
	}
}

- (void)fillReviewStoreCellWithInfo:(USRetailerDetails *)retailerInfo {
	NSURL *profileUrl = [NSURL URLWithString:[[USUsers sharedUser]objUser].avatar];
	if (profileUrl) {
		[self.imgViewUserProfile setImageWithURL:profileUrl placeholderImage:[UIImage imageNamed:@"dummy_gray"]];
	} else {
		[self.imgViewUserProfile setImage:[UIImage imageNamed:@"dummy_gray"]];
	}
	if (retailerInfo.myReview.reviewTitle) {
		[self updateReviewStoreTextTo:retailerInfo.myReview.reviewTitle];
	} else {
		[self updateReviewStoreTextTo:retailerInfo.myReview.reviewDescription];
	}
}

#pragma mark Text View Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	if (self.delegate && [self.delegate respondsToSelector:@selector(reviewStoreTextViewSelectedWithText:)]) {
		if ([textView.text isEqualToString:@"Add a tip or comment"]) {
			[self.delegate reviewStoreTextViewSelectedWithText:nil];
		} else {
			[self.delegate reviewStoreTextViewSelectedWithText:textView.text];
		}
	}
	return NO;
}

@end
