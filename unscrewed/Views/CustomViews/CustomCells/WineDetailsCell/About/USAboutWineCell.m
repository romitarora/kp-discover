//
//  USAboutWineCell.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 18/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USAboutWineCell.h"
#import "USWineDetail.h"

@implementation USAboutWineCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightWithWineDetail:(USWineDetail *)objWine {
	CGFloat cellHeight = 45; // 15 Top Padding + 15 About Label Height + 15 Bottom Padding
	if (objWine.wineSubtypeWithVoice) {
		cellHeight += (18.f + 10.f);
	}
	if (objWine.wineAboutDescription) {
		UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
		CGRect textRect = [objWine.wineAboutDescription rectWithSize:CGSizeMake(kScreenWidth - 30, CGFLOAT_MAX) font:font];
		cellHeight += (ceil(CGRectGetHeight(textRect)) + 10.f);
	}
	if (objWine.wineRegionWithSubRegion) {
		cellHeight += (18.f+10);
	}
	return cellHeight;
}

- (void)fillAboutSection:(USWineDetail *)objWine {
    lblHeader.text = @"ABOUT";
	
	lblPronouncedAs.hidden = YES;
	lblBestWith.hidden = YES;
	lblLocation.hidden = YES;
	
	CGFloat currentY = CGRectGetMinY(lblPronouncedAs.frame);
	if (objWine.wineSubtypeWithVoice) {
		lblPronouncedAs.hidden = NO;
		lblPronouncedAs.text = objWine.wineSubtypeWithVoice;
		currentY = CGRectGetMaxY(lblPronouncedAs.frame) + 10.f;
	}
	if (objWine.wineAboutDescription) {
		lblBestWith.hidden = NO;
		lblBestWith.text = objWine.wineAboutDescription;
		CGRect textRect = [lblBestWith.text rectWithSize:CGSizeMake(CGRectGetWidth(lblBestWith.frame), CGFLOAT_MAX)
													font:lblBestWith.font];
		CGRect rect = lblBestWith.frame;
		rect.origin.y = currentY;
		rect.size.height = ceil(CGRectGetHeight(textRect));
		lblBestWith.frame = rect;
		currentY = CGRectGetMaxY(lblBestWith.frame) + 10.f;
	}
	if (objWine.wineRegionWithSubRegion) {
		lblLocation.hidden = NO;
		lblLocation.text = objWine.wineRegionWithSubRegion;
		CGRect rect = lblLocation.frame;
		rect.origin.y = currentY;
		lblLocation.frame = rect;
	}
}

@end
