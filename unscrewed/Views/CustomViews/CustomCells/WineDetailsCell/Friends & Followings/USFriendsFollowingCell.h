//
//  USFriendsFollowingCell.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 17/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USWine;
@class USRetailerDetails;

@interface USFriendsFollowingCell : UITableViewCell {
    __weak IBOutlet UILabel *lblHeader;
    __weak IBOutlet UILabel *lblReviewCount;
    __weak IBOutlet UIView *viewUsers;
}

- (void)fillFriendsInfo:(USWine *)objWine;
- (void)fillFriendsInfoForRetailer:(USRetailerDetails *)objRetailer;

@end
