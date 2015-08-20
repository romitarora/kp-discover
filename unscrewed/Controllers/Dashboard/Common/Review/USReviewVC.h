//
//  USReviewVC.h
//  unscrewed
//
//  Created by Robin Garg on 18/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ReviewType) {
	ReviewTypeWine = 0,
	ReviewTypeStore
};

@class USReview;
@protocol USReviewVCDelegate;

@interface USReviewVC : UIViewController

@property (nonatomic, strong) NSString *objectId;
//@property (nonatomic, strong) NSString *reviewText;
@property (nonatomic, strong) USReview *objReview;
@property (nonatomic, assign) ReviewType reviewType;

@property (nonatomic, weak) id<USReviewVCDelegate> delegate;

@end

@protocol USReviewVCDelegate <NSObject>

@required
- (void)reviewPostedSuccessfullyWithUpdatedReview:(USReview *)objReview;

@end
