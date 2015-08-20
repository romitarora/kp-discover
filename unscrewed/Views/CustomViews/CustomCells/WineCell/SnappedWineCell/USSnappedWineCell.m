//
//  USSnappedWineCell.m
//  unscrewed
//
//  Created by Robin Garg on 19/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USSnappedWineCell.h"
#import "USSnappedWine.h"
#import "AsyncImageView.h"

@interface USSnappedWineCell ()

@property (nonatomic, strong) IBOutlet AsyncImageView *imgViewWine;
@property (nonatomic, strong) IBOutlet UILabel *lblWineInfo;

@end

@implementation USSnappedWineCell

- (void)awakeFromNib {
    // Initialization code
	[self.imgViewWine setBackgroundColor:[UIColor blackColor]];
	[self.lblWineInfo setTextColor:[UIColor whiteColor]];
	
	[self.lblWineInfo setFont:[USFont snappedWineInfoFont]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillSnappedWineCellWithInfo:(id)wine {
	NSURL *url = [NSURL URLWithString:wine[url_Key]];
	[self.imgViewWine getImageFromURL:url placeholderImage:nil];
	
	NSString *wineInfo = [NSString stringWithFormat:@"%@ - %@",wine[createdAtKey], wine[nameKey]];
	NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:wineInfo];
	NSRange range = [wineInfo rangeOfString:@"Pending"];
	if (range.length == 0) {
		range = [wineInfo rangeOfString:wine[nameKey]];
		[attrStr addAttribute:NSForegroundColorAttributeName value:[USColor themeSelectedColor] range:range];
	}
	[self.lblWineInfo setAttributedText:attrStr];
}

/*- (void)fillSnappedWineCellWithInfo:(USSnappedWine *)wine {
	[self.imgViewWine setImage:wine.snappedImage];
	
	NSString *wineInfo = [NSString stringWithFormat:@"%@ - %@",wine.postedOn, wine.name];
	NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:wineInfo];
	NSRange range = [wineInfo rangeOfString:@"Pending"];
	if (range.length == 0) {
		range = [wineInfo rangeOfString:wine.name];
		[attrStr addAttribute:NSForegroundColorAttributeName value:[USColor themeSelectedColor] range:range];
	}
	[self.lblWineInfo setAttributedText:attrStr];
}*/

@end
