//
//  USExpertReviewCell.m
//  unscrewed
//
//  Created by Robin Garg on 23/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USExpertReviewCell.h"
#import "USExpertReview.h"

@interface USExpertReviewCell ()

@property (nonatomic, weak) IBOutlet UILabel *lblExpertPts;
@property (nonatomic, weak) IBOutlet UIButton *btnExpert;
@property (nonatomic, weak) IBOutlet UILabel *lblWineReview;
@property (nonatomic, weak) IBOutlet UILabel *lblPostedAgo;

@property (nonatomic, strong) USExpertReview *objExpertReview;

//- (void)btnWineExpertTappedActionEvent: (UIButton*)sender;

@end

@implementation USExpertReviewCell

- (void)awakeFromNib {
    // Initialization code
	[self.lblExpertPts setFont:[USFont wineExpertReviewPtsFont]];
	[self.btnExpert.titleLabel setFont:[USFont wineExpertReviewExpertNameFont]];
	[self.lblWineReview setFont:[USFont wineExpertReviewFont]];
	[self.lblPostedAgo setFont:[USFont wineExpertReviewTimeFont]];
	
	[self.btnExpert setTitleColor:[USColor themeSelectedColor] forState:UIControlStateNormal];
	[self.lblPostedAgo setTextColor:[USColor themeTextSubTitleColor]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)reviewHeightForExpertReview:(USExpertReview *)objReview {
	CGRect rect = [objReview.expertReview boundingRectWithSize:CGSizeMake(290, CGFLOAT_MAX)
											 options:NSStringDrawingUsesLineFragmentOrigin
										  attributes:@{NSFontAttributeName:[USFont wineExpertReviewFont]}
											 context:nil];
	return ceilf(CGRectGetHeight(rect));
}

+ (CGFloat)cellHeightForExpertReview:(USExpertReview *)objReview {
	if (objReview.expertReview && objReview.expertReview.length) {
		return 103.f + 5.f + [self reviewHeightForExpertReview:objReview];
	}
	return 103.f;
}

- (void)fillExpertReviewCellWithInfo:(USExpertReview *)expertReview {
	self.objExpertReview = expertReview;
	[self.lblExpertPts setText:[NSString stringWithFormat:@"%li Points",(long)expertReview.expertRatings]];
	[self.btnExpert setTitle:expertReview.expertName forState:UIControlStateNormal];
    //self.btnExpert.tag = 99;
    
    
	
	[self.lblPostedAgo setFrame:CGRectMake(15.f, 69.f, 290.f, 14.f)];
	
	[self.lblWineReview setText:expertReview.expertReview];
	if (expertReview.expertReview && expertReview.expertReview.length) {
		CGFloat reviewHeight = [USExpertReviewCell reviewHeightForExpertReview:expertReview];
		CGRect rect = self.lblWineReview.frame;
		rect.size.height = reviewHeight;
		self.lblWineReview.frame = rect;
		
		rect = self.lblPostedAgo.frame;
		rect.origin.y = CGRectGetMaxY(self.lblWineReview.frame) + 5.f;
		self.lblPostedAgo.frame = rect;
	}
	[self.lblPostedAgo setText:expertReview.postedAt];
}

- (IBAction)btnWineExpertTappedActionEvent:(id*)sender {
    NSString *expert = self.objExpertReview.expertName;
    
    if([expert isEqual:@"Wine Spectator"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.winespectator.com"]];
    }else if([expert isEqual:@"Wine Advocate"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.erobertparker.com"]];
    }else if([expert isEqual:@"James Suckling"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.jamessuckling.com"]];
    }else if([expert isEqual:@"Stephen Tanzer"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.vinousmedia.com"]];
    }else if([expert isEqual:@"Wine & Spirits"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.wineandspiritsmagazine.com"]];
    }else if([expert isEqual:@"Wine Enthusiast"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.wineenthusiast.com"]];
    }
    /*
	if (self.delegate && [self.delegate respondsToSelector:@selector(expertReviewCellSelectedWithExpertReviewInfo:)]) {
		[self.delegate expertReviewCellSelectedWithExpertReviewInfo:self.objExpertReview];
	}
     */
}

@end
