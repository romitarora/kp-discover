//
//  USFindItCell.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 18/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USWineDetail;
@interface USFindItCell : UITableViewCell
{
	__weak IBOutlet UILabel *lblHeader;
	__weak IBOutlet UIView *viewContainer;
    __weak IBOutlet UIButton *btnIcon;
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet UILabel *lblPrice;
}

- (void)fillFindItInfo:(USWineDetail *)objWine forIndex:(NSInteger)rowIndex;

@end
