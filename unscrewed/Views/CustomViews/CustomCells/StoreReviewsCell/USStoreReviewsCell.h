//
//  USStoreReviewsCell.h
//  unscrewed
//
//  Created by Robin Garg on 26/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USRetailerDetails;
@interface USStoreReviewsCell : UITableViewCell {
	__weak IBOutlet UILabel *lblHeader;
	__weak IBOutlet UILabel *lblStoreReviewTitle;
	__weak IBOutlet UILabel *lblStoreReveiw;
	__weak IBOutlet UILabel *lblUserInfo;
	__weak IBOutlet UIImageView *imgViewUserProfile;
	__weak IBOutlet UIView *viewComponents;
}

+ (CGFloat)cellHeightForRetailer:(USRetailerDetails *)retailerDetails forIndex:(NSInteger)rowIndex;
- (void)fillStoreReviewCellWithInfo:(USRetailerDetails *)retailerDetails forIndex:(NSInteger)rowIndex;

@end
