//
//  USFriendsFollowingCell.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 17/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USFriendsFollowingCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "USWineDetail.h"
#import "USRetailerDetails.h"

@implementation USFriendsFollowingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillFriendsInfo:(USWineDetail *)objWine {
    lblHeader.text = @"FRIENDS & FOLLOWING";
	
	// thumbnails
	NSArray *viewUsersSubViews = viewUsers.subviews;
	for (UIView *view in viewUsersSubViews) {
		[view removeFromSuperview];
	}
    CGRect rect = CGRectMake(0, 0, 33, 33);
    int thumbCount = 0;
    
    for (USReview *friend in objWine.objFriendReviews.arrReviews) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
        [imgView setImageWithURL:[NSURL URLWithString:friend.userImageUrl] placeholderImage:[UIImage imageNamed:@"dummy_gray"]];
        imgView.layer.cornerRadius = imgView.frame.size.width / 2;
        imgView.layer.masksToBounds = YES;
        [viewUsers addSubview:imgView];
        
        rect.origin.x += rect.size.width + 5;
        thumbCount++;
        if (thumbCount >= 5) {
            break;
        }
    }
	
    // count
    lblReviewCount.frame = CGRectMake(CGRectGetMinX(rect) + 20, lblReviewCount.frame.origin.y, lblReviewCount.frame.size.width, lblReviewCount.frame.size.height);
	for (UIView *subview in [self subviews])
	{
		if (subview.tag == 99)
		{
			[subview removeFromSuperview];
		}
	}
    if (objWine.friendLikesCount > 5) {
        lblReviewCount.text = [NSString stringWithFormat:@"+%i",(int)objWine.friendLikesCount - 5];
    } else if (objWine.friendLikesCount == 0){
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addFriend"]];
        icon.frame = CGRectMake(lblHeader.frame.origin.x, lblHeader.frame.origin.y+lblHeader.frame.size.height*1.6, self.frame.size.height*.3, self.frame.size.height*.3);
        icon.tag = 99;
        [self addSubview:icon];
        
        UILabel *lblAddMorePpl = [[UILabel alloc] init];
        lblAddMorePpl.text = @"Add more people";
        lblAddMorePpl.frame = CGRectMake(icon.frame.origin.x*1.5+icon.frame.size.width, icon.frame.origin.y, self.frame.size.width-(icon.frame.size.width*2), icon.frame.size.height);
        [lblAddMorePpl setTextColor:[USColor themeSelectedColor]];
        [lblAddMorePpl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]];
        lblAddMorePpl.tag = 99;
        [self addSubview:lblAddMorePpl];
    }
}

- (void)fillFriendsInfoForRetailer:(USRetailerDetails *)objRetailer {
	CGRect rect = lblHeader.frame;
	rect.origin.y = 16.f;
	lblHeader.frame = rect;
	
    for (UIView *subview in [self subviews])
    {
        if (subview.tag == 99)
        {
			DLog(@"subview remvoed = %@",subview);
            [subview removeFromSuperview];
        }
    }
    
	if (objRetailer.friendLikesCount == 1) {
		lblHeader.text =  [NSString stringWithFormat: @"%ld FRIEND LIKE WINES HERE",(long)objRetailer.friendLikesCount];
    }else if(objRetailer.friendLikesCount == 0){
        lblHeader.text =  [NSString stringWithFormat: @"%ld FRIENDS LIKE WINES HERE",(long)objRetailer.friendLikesCount];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addFriend"]];
        icon.frame = CGRectMake(lblHeader.frame.origin.x, lblHeader.frame.origin.y+lblHeader.frame.size.height*1.6, self.frame.size.height*.3, self.frame.size.height*.3);
        icon.tag = 99;
        [self addSubview:icon];
        
        UILabel *lblAddMorePpl = [[UILabel alloc] init];
        lblAddMorePpl.text = @"Add more people";
        lblAddMorePpl.frame = CGRectMake(icon.frame.origin.x*1.5+icon.frame.size.width, icon.frame.origin.y, self.frame.size.width-(icon.frame.size.width*2), icon.frame.size.height);
        [lblAddMorePpl setTextColor:[USColor themeSelectedColor]];
        [lblAddMorePpl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]];
        lblAddMorePpl.tag = 99;
        [self addSubview:lblAddMorePpl];
    }else {
		lblHeader.text =  [NSString stringWithFormat: @"%ld FRIENDS LIKE WINES HERE",(long)objRetailer.friendLikesCount];
	}
	// thumbnails
	NSArray *viewUsersSubViews = viewUsers.subviews;
	for (UIView *view in viewUsersSubViews) {
		[view removeFromSuperview];
	}
	CGRect rectProfileImage = CGRectMake(0, 0, 39, 39);
	int thumbCount = 0;
	for (USUser *objUser in objRetailer.objFriendLikes.arrUsers) {
		UIImageView *imgView = [[UIImageView alloc] initWithFrame:rectProfileImage];
        [imgView setImageWithURL:[NSURL URLWithString:objUser.avatar] placeholderImage:[UIImage imageNamed:@"dummy_gray"]];
        [imgView setBackgroundColor:[UIColor orangeColor]];
		imgView.layer.cornerRadius = CGRectGetHeight(imgView.frame)/2.f;
		imgView.layer.masksToBounds = YES;
		[viewUsers addSubview:imgView];
		
		rectProfileImage.origin.x += rectProfileImage.size.width + 5;
		thumbCount++;
		if (thumbCount >= 5) {
			break;
		}
	}
	rect = viewUsers.frame;
	rect.origin.y = CGRectGetMaxY(lblHeader.frame) + 9.f;
	rect.size.height = 39.f;
	rect.size.width = CGRectGetMinX(rectProfileImage) - 5.f;
	viewUsers.frame = rect;
	
	// count
	rect = lblReviewCount.frame;
	rect.origin.x = CGRectGetMaxX(viewUsers.frame) + 15.f;
	rect.origin.y = CGRectGetMidY(viewUsers.frame) -
					CGRectGetHeight(lblReviewCount.frame) * 0.5f;
	rect.size.width = CGRectGetWidth(self.contentView.frame) - 15.f - rect.origin.x;
	lblReviewCount.frame = rect;
	lblReviewCount.text = kEmptyString;
	if (objRetailer.friendLikesCount > 5) {
		lblReviewCount.text = [NSString stringWithFormat:@"+%i",(int)objRetailer.friendLikesCount - 5];
	}
}


@end
