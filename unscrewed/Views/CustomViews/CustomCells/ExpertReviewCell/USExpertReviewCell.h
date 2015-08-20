//
//  USExpertReviewCell.h
//  unscrewed
//
//  Created by Robin Garg on 23/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol USExpertReviewCellDelegate;
@class USExpertReview;
@interface USExpertReviewCell : UITableViewCell

@property (nonatomic, weak) id<USExpertReviewCellDelegate> delegate;

+ (CGFloat)cellHeightForExpertReview:(USExpertReview *)objReview;

- (void)fillExpertReviewCellWithInfo:(USExpertReview *)expertReview;

@end

@protocol USExpertReviewCellDelegate <NSObject>

@optional
- (void)expertReviewCellSelectedWithExpertReviewInfo:(USExpertReview *)expertReview;

@end
