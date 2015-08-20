//
//  USExpertWineDetailCell.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 17/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USExpertReview;
@interface USExpertWineDetailCell : UITableViewCell {
    __weak IBOutlet UILabel *lblHeader;
    __weak IBOutlet UILabel *lblReview;
    __weak IBOutlet UILabel *lblExpertName;
}

- (void)fillExpertInfo:(USExpertReview *)objWine indexPath:(NSIndexPath *)indexPath;

@end
