//
//  USExpertWineDetailCell.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 17/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USExpertWineDetailCell.h"
#import "USExpertReview.h"

@implementation USExpertWineDetailCell

- (void)awakeFromNib {
    // Initialization code
	lblHeader.text = @"EXPERTS";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillExpertInfo:(USExpertReview *)objWine indexPath:(NSIndexPath *)indexPath {
    if (objWine) {
        lblReview.text = [NSString stringWithFormat:@"%li points - %@",(long)objWine.expertRatings, objWine.expertValue];
        lblExpertName.text = objWine.expertName;
    }
	[lblHeader setHidden:indexPath.row];
	if (indexPath.row) {
		CGRect rect = lblReview.frame;
		rect.origin.y = CGRectGetMinY(lblHeader.frame);
		lblReview.frame = rect;
		
		rect = lblExpertName.frame;
		rect.origin.y = CGRectGetMaxY(lblReview.frame) + 3;
		lblExpertName.frame = rect;
	}
}

@end
