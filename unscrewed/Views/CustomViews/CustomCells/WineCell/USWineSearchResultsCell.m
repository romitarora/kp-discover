//
//  USWineSearchResultsCell.m
//  unscrewed
//
//  Created by Rav Chandra on 22/08/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USWineSearchResultsCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NSString+Utilities.h"
#import "USWine.h"

@interface USWineSearchResultsCell ()

@property (nonatomic, assign) BOOL myWines;

@end

@implementation USWineSearchResultsCell

@synthesize imageView;
@synthesize wineId;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)
reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self)
	{
		// Initialization code
	}
	
	return self;
}

- (void)awakeFromNib
{
	// Initialization code
    //self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	self.imageView.clipsToBounds = YES;
	CGRect rect = self.imageView.frame;
	rect.size.height = 154.5f;
	self.imageView.frame = rect;
	[self.imageView setBackgroundColor:[UIColor blackColor]];
	[self.labelName setFont:[USFont wineNameFont]];
	[self.labelDescription setFont:[USFont wineDescriptionFont]];
	[self.labelPrice setFont:[USFont winePriceFont]];
	[self.numberOfUsersLabel setFont:[USFont wineUserRatingsFont]];
	[self.labelExpertPts setFont:[USFont wineExpertValueFont]];
	[self.labelFriendsReview setFont:[USFont wineUserRatingsFont]];
	[self.labelWineValueRating setFont:[USFont wineValueFont]];
	
	[self.labelName setTextColor:[UIColor blackColor]];
	[self.labelDescription setTextColor:[USColor wineCellDescriptionColor]];
	[self.labelPrice setTextColor:[USColor themeSelectedColor]];
	[self.numberOfUsersLabel setTextColor:[USColor wineCellDescriptionColor]];
	[self.labelExpertPts setTextColor:[USColor wineCellDescriptionColor]];
	[self.labelFriendsReview setTextColor:[USColor wineCellDescriptionColor]];
	[self.labelWineValueRating setTextColor:[UIColor whiteColor]];
	
	[self.labelWineValueRating setBackgroundColor:[USColor themeSelectedColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

- (void)resetCell {
	[self.labelName setHidden:YES];
	[self.labelDescription setHidden:YES];
	[self.imageView setImage:nil];
	[self.labelPrice setHidden:YES];
	[self.labelExpertPts setHidden:YES];
	[self.labelFriendsReview setHidden:YES];
	[self.labelWineValueRating setHidden:YES];
}

- (void)fillWineCellWithWineInfo:(USWine *)wine indexPath:(NSIndexPath *)indexPath {
	self.wineId = wine.wineId;
	
	CGRect rect;
	CGRect textRect;
	CGFloat cellY = 5;
	[self resetCell];
		// Name
	if (wine.name != nil && wine.name.length) {
		[self.labelName setHidden:NO];
		self.labelName.text = wine.name;
		rect = self.labelName.frame;
		textRect = [wine.name rectWithSize:CGSizeMake(CGRectGetWidth(self.labelName.frame), CGFLOAT_MAX)
									  font:self.labelName.font];
		rect.origin.y = cellY;
		CGFloat labelHeight = ceilf(CGRectGetHeight(textRect));
		CGFloat maxLineHeight = ceilf(self.labelName.font.lineHeight) * 2;
		rect.size.height = MIN(labelHeight, maxLineHeight);
		self.labelName.frame = rect;
		cellY = CGRectGetMaxY(self.labelName.frame);
	}	// Description
	if (wine.wineDescription != nil && wine.wineDescription.length) {
		cellY+=1.f;
		[self.labelDescription setHidden:NO];
		self.labelDescription.text = wine.wineDescription;
		rect = self.labelDescription.frame;
		rect.origin.y = cellY;
		self.labelDescription.frame = rect;
		cellY = CGRectGetMaxY(self.labelDescription.frame);
	}	// Image
	if (wine.wineImageUrl != nil) {
		[self.imageView getImageFromURL:wine.wineImageUrl placeholderImage:nil scaling:3];
	}
	// Price
	[self.labelPrice setAttributedText:nil];
	[self.labelPrice setText:nil];
	switch (self.wineCellType) {
		case WineCellTypeNearby:
		case WineCellTypeMyWines:
		{
            NSMutableString *strPrice = [[NSMutableString alloc] init];
			
			if (wine.closestPlaceWinePrice != nil && wine.closestPlaceWinePrice.integerValue > 0) {
				[strPrice appendFormat:@"$%li",wine.closestPlaceWinePrice.integerValue];
			}
			if (wine.closestPlaceName != nil && wine.closestPlaceName.length) {
				[strPrice appendFormat:@" at %@",wine.closestPlaceName];
			}
			if (wine.closestPlaceDistanceMiles) {
				[strPrice appendFormat:@" (%.1fmi)",wine.closestPlaceDistanceMiles.floatValue];
			}
			if (strPrice.length) {
				[self.labelPrice setHidden:NO];
				// Create Attributed String and set to price label currently not returning from API
				NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:strPrice];
				NSRange range = [strPrice rangeOfString:[NSString stringWithFormat:@"(%.1fmi)",wine.closestPlaceDistanceMiles.floatValue]];
				if (range.length) {
					[attString addAttribute:NSFontAttributeName value:[USFont wineDistanceFont] range:range];
				}
				[self.labelPrice setAttributedText:attString];
			} else if (wine.minAvgPrice && wine.minAvgPrice.integerValue > 0) {
				[self.labelPrice setHidden:NO];
				[self.labelPrice setText:[NSString stringWithFormat:@"$%li",wine.minAvgPrice.integerValue]];
			}
		}
			break;
		case WineCellTypeFromRetailer:
			if (wine.closestPlaceWinePrice != nil && wine.closestPlaceWinePrice.integerValue>0) {
				[self.labelPrice setHidden:NO];
				[self.labelPrice setText:[NSString stringWithFormat:@"$%li",wine.closestPlaceWinePrice.integerValue]];
			} else if (wine.minAvgPrice && wine.minAvgPrice.integerValue > 0) {
				[self.labelPrice setHidden:NO];
				[self.labelPrice setText:[NSString stringWithFormat:@"$%li",wine.minAvgPrice.integerValue]];
			}
			break;
	}
	if (!self.labelPrice.hidden) {
		cellY+=2.f;
		rect = self.labelPrice.frame;
		rect.origin.y = cellY;
		self.labelPrice.frame = rect;
		cellY = CGRectGetMaxY(self.labelPrice.frame);
	}
	long countOfSelected = 0;
	NSString *numberOfUsersLabelText;
	if (self.wineCellType == WineCellTypeMyWines &&
		wine.myRatingValue > 0) {
		countOfSelected = wine.myRatingValue;
		numberOfUsersLabelText = @"(Me)";
	} else {
		// User Ratings
		if (wine.ratingsCount > 0) {
			countOfSelected = (int)wine.averageRating;
			if (wine.ratingsCount > 1) {
				numberOfUsersLabelText =
				[NSString stringWithFormat:@"(%ld users)", (long)wine.ratingsCount];
			} else {
				numberOfUsersLabelText =
				[NSString stringWithFormat:@"(%ld user)", (long)wine.ratingsCount];
			}
		} else {
			numberOfUsersLabelText = @"(not yet rated)";
		}
	}
	self.viewStarRating.rate = countOfSelected;
	self.numberOfUsersLabel.text = numberOfUsersLabelText;
	
	cellY+=3.f;
	rect = self.viewUserRatings.frame;
	rect.origin.y = cellY;
	self.viewUserRatings.frame = rect;
	cellY = CGRectGetMaxY(self.viewUserRatings.frame);
		// Expert Ratings
	if (wine.expertPts != 0) {
		NSString *expertPtsString = [NSString stringWithFormat:@"Experts: %li pts - %@",(long)wine.expertPts, wine.expertValue];
		NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:expertPtsString];
		NSRange expertLabelRange = [expertPtsString rangeOfString:@"Experts:"];
		if (expertLabelRange.length) {
			[attrString addAttribute:NSFontAttributeName value:[USFont wineExpertLabelFont] range:expertLabelRange];
		}
		[self.labelExpertPts setHidden:NO];
		[self.labelExpertPts setAttributedText:attrString];
		rect = self.labelExpertPts.frame;
		rect.origin.y = cellY;
		self.labelExpertPts.frame = rect;
		cellY = CGRectGetMaxY(self.labelExpertPts.frame);
	}	// Friends Reviews
	NSArray *cellContentViewSubViews = self.contentView.subviews;
	for (UIView *view in cellContentViewSubViews) {
		if ([view isKindOfClass:[UIImageView class]] && view.tag >= 100) {
			[view removeFromSuperview];
		}
	}
	if (wine.socialLikesCount) {
		cellY+=3.f;
		[self.labelFriendsReview setHidden:NO];
		[self.labelFriendsReview setText:[NSString stringWithFormat:@"(%li friend reviews)",(long)wine.socialLikesCount]];
		
        int thumbCount = 0;
        CGRect rectProfileImage = CGRectMake(115, cellY, 14, 14);
		for (USUser *friend in wine.objSocialLikes.arrUsers) {
			UIImageView *imageViewFriend = [[UIImageView alloc] initWithFrame:rectProfileImage];
			[imageViewFriend setTag:100 + thumbCount];
			[imageViewFriend.layer setCornerRadius:CGRectGetWidth(imageViewFriend.frame) * 0.5f];
			[imageViewFriend.layer setMasksToBounds:YES];
            [imageViewFriend setImageWithURL:[NSURL URLWithString:friend.avatar] placeholderImage:[UIImage imageNamed:@"dummy_gray"]];
			[self.contentView addSubview:imageViewFriend];
            rectProfileImage.origin.x += rectProfileImage.size.width + 5;
            thumbCount++;
            if (thumbCount >= 5) {
                break;
            }
		}
		rect = self.labelFriendsReview.frame;
		rect.origin.y = cellY-1;
		rect.origin.x = 115 + thumbCount * 19;
		rect.size.width = CGRectGetWidth([UIScreen mainScreen].bounds) - rect.origin.x - 10.f;
		self.labelFriendsReview.frame = rect;
		cellY = CGRectGetMaxY(self.labelFriendsReview.frame);
	}	// Wine Value Ratings
	if (wine.closestPlaceType && wine.closestPlaceWinePrice.integerValue > 0 && wine.closestPlaceWineSize) {
		NSString *wineValue = [wine.wineValueRating withRetailerType:wine.closestPlaceType
																size:wine.closestPlaceWineSize
															   price:wine.closestPlaceWinePrice.integerValue];
		if (wineValue && wineValue.length) {
			cellY+=3.f;
			[self.labelWineValueRating setHidden:NO];
			//[self.labelWineValueRating setText:[NSString stringWithFormat:@"%@ value",wineValue]];
            NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            style.alignment = NSTextAlignmentCenter;
            style.lineHeightMultiple = 0.85f;
            NSString *title = [NSString stringWithFormat:@"%@ value",wineValue];
            NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:title attributes:@{ NSParagraphStyleAttributeName : style}];
            [self.labelWineValueRating setAttributedText:attrText];
			
			rect = self.labelWineValueRating.frame;
			textRect = [self.labelWineValueRating.text rectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX)
															   font:self.labelName.font];
			rect.origin.y = cellY;
			rect.size.height = ceilf(CGRectGetHeight(textRect));
            rect.size.width = ceilf(CGRectGetWidth(textRect));
            rect.size.height += 1;
            rect.size.width += 5;
            self.labelWineValueRating.frame = rect;
		}
	}
}

@end
