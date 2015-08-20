//
//  USFindItCell.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 18/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USFindItCell.h"
#import "USWineDetail.h"

@implementation USFindItCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateFormattingOfPriceLabel:(UILabel *)label {
    CGRect rectLabel = label.frame;
	if ([label.text isEqualToString:kDashString]) {
        rectLabel.size.height = 60; // this is need to align dashes vertically center with right arrow
		//[label setFont:[USFont wineDetailsPriceNotFoundFont]];
		//[label setTextColor:[USColor wineDetailsPriceNotFoundColor]];
	} else {
        rectLabel.size.height = 62;
		//[label setFont:[USFont wineDetailsFindItPriceFont]];
		//[label setTextColor:[USColor themeSelectedColor]];
	}
    [label setFrame:rectLabel];
}

- (void)fillFindItInfo:(USWineDetail *)objWine forIndex:(NSInteger)rowIndex {
	CGRect rect = viewContainer.frame;
    if (rowIndex == 0) {
		rect.origin.y = 36.f;
		[lblHeader setHidden:NO];
        [btnIcon setImage:[UIImage imageNamed:@"nearby"] forState:UIControlStateNormal];
        lblTitle.text = @"Nearby";
        [lblPrice setText:(objWine.minPrice ? [NSString stringWithFormat:@"$%@",objWine.minPrice] : kDashString)];
        
    } else {
		rect.origin.y = 0.f;
		[lblHeader setHidden:YES];
        [btnIcon setImage:[UIImage imageNamed:@"online"] forState:UIControlStateNormal];
        lblTitle.text = @"Online";
        [lblPrice setText:(objWine.onlineAveragePrice.integerValue > 0 ? [NSString stringWithFormat:@"$%@",objWine.onlineAveragePrice] : kDashString)];
    }
	[self updateFormattingOfPriceLabel:lblPrice];
	viewContainer.frame = rect;
}

@end
