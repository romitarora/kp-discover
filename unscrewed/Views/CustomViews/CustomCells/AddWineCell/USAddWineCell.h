//
//  USAddWineCell.h
//  unscrewed
//
//  Created by Robin Garg on 02/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol USAddWineCellDelegate;
@interface USAddWineCell : UITableViewCell

@property (nonatomic, weak) id<USAddWineCellDelegate> delegate;

@end

@protocol USAddWineCellDelegate <NSObject>

@required
- (void)addWineActionEvent;

@end