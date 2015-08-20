//
//  USWineSearchResultsCell.h
//  unscrewed
//
//  Created by Rav Chandra on 22/08/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"
#import "SWTableViewCell.h"
#import "AsyncImageView.h"

typedef NS_ENUM(NSInteger, WineCellType) {
	WineCellTypeNearby,
	WineCellTypeFromRetailer,
	WineCellTypeMyWines
};

@class USWine;

@interface USWineSearchResultsCell : SWTableViewCell

@property NSString *wineId;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (strong, nonatomic) IBOutlet AsyncImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfUsersLabel;
@property (strong, nonatomic) IBOutlet DYRateView *viewStarRating;
@property (strong, nonatomic) IBOutlet UIView *viewUserRatings;
@property (weak, nonatomic) IBOutlet UILabel *labelExpertPts;
@property (strong, nonatomic) IBOutlet UILabel *labelFriendsReview;
@property (strong, nonatomic) IBOutlet UILabel *labelWineValueRating;

@property (assign, nonatomic) WineCellType wineCellType;

- (void)fillWineCellWithWineInfo:(USWine *)wine indexPath:(NSIndexPath *)indexPath;

@end
