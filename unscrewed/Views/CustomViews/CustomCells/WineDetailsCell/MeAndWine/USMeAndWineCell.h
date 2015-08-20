//
//  MeAndWineCell.h
//  unscrewed
//
//  Created by Robin Garg on 18/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USWineDetail;
@protocol USWineMeAndThisWineDelegate;

@interface USMeAndWineCell : UITableViewCell

@property(nonatomic,assign)BOOL isSettingInitialRating;
@property (nonatomic, weak) id<USWineMeAndThisWineDelegate> delegate;

- (void)fillMeAndWineInfo:(USWineDetail *)info indexPath:(NSIndexPath *)indexPath;
- (void)updateWineLikeStatusTo:(BOOL)like;
- (void)updateWineWantStatusTo:(BOOL)wants;
- (void)updateReviewWineTextTo:(NSString *)review;

@end

@protocol USWineMeAndThisWineDelegate <NSObject>

@optional
- (void)likeWineSelected;
- (void)wantWineSelected;
- (void)rateWineChangedToNewRate:(NSNumber*)rate;
- (void)reviewWineTextViewSelectedWithText:(NSString *)text;

@end
