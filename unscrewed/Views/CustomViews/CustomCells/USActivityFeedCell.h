//
//  USActivityFeedCell.h
//  unscrewed
//
//  Created by Rav Chandra on 19/09/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USActivityFeedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *wineName;
@property (weak, nonatomic) IBOutlet UILabel *wineSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *winePrice;
@property (weak, nonatomic) IBOutlet UIImageView *activityTypeIcon;

@end
