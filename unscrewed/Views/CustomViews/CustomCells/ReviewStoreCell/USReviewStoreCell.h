//
//  USReviewStoreCell.h
//  unscrewed
//
//  Created by Robin Garg on 26/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USRetailerDetails;
@protocol USReviewStoreCellDelegate;

@interface USReviewStoreCell : UITableViewCell

@property (nonatomic, weak) id<USReviewStoreCellDelegate> delegate;

- (void)updateReviewStoreTextTo:(NSString *)review;
- (void)fillReviewStoreCellWithInfo:(USRetailerDetails *)retailerInfo;

@end

@protocol USReviewStoreCellDelegate <NSObject>

@optional
- (void)reviewStoreTextViewSelectedWithText:(NSString *)text;

@end

