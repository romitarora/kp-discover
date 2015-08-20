//
//  WineImageCell.h
//  unscrewed
//
//  Created by Robin Garg on 16/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"

@class OBGradientView;
@class USWineDetail;
@protocol USWineImageCellDelegate;

@interface USWineImageCell : UITableViewCell

@property (nonatomic, weak) id<USWineImageCellDelegate> delegate;
@property (nonatomic, retain) IBOutlet OBGradientView *gradientView;

@property(nonatomic,assign)BOOL isSettingInitialRating;

- (void)fillWineImageInfo:(USWineDetail *)info indexPath:(NSIndexPath *)indexPath;

- (void)updateWineLikeStatusTo:(BOOL)like;
- (void)updateWineWantStatusTo:(BOOL)wants;

@end


@protocol USWineImageCellDelegate <NSObject>

@optional
- (void)likeWineSelectedOnImageCell;
- (void)wantWineSelectedOnImageCell;
- (void)rateWineChangedOnImageCellToNewRate:(NSNumber*)rate;
- (void)onlineOptionSelectedOnImageCell;
- (void)nearbyOptionSelectedOnImageCell;
- (void)findItOptionSelectedOnImageCell;
- (void)wineImageSelected:(UIImage *)image;
@end
