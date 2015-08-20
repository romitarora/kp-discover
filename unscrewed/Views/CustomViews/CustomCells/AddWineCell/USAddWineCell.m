//
//  USAddWineCell.m
//  unscrewed
//
//  Created by Robin Garg on 02/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USAddWineCell.h"

@interface USAddWineCell ()

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UIButton *btnAddWine;

- (IBAction)btnAddWineActionEvent;

@end

@implementation USAddWineCell

- (void)awakeFromNib {
    // Initialization code
	[self.lblTitle setFont:[USFont addWineMsgFont]];
	[self.btnAddWine.titleLabel setFont:[USFont addWineBtnFont]];
	
	[self.lblTitle setText:@"See something new? Help us out!"];
	[self.btnAddWine setTitle:@"Add a Wine" forState:UIControlStateNormal];
    
	[self.lblTitle setTextColor:[USColor themeSelectedColor]];
	[self.btnAddWine.layer setCornerRadius:5.f];
	[self.btnAddWine setBackgroundColor:[USColor themeSelectedColor]];
	[self.btnAddWine setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnAddWine setTitleEdgeInsets:UIEdgeInsetsMake(0, 1.5, 0, 0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnAddWineActionEvent {
	if (self.delegate && [self.delegate respondsToSelector:@selector(addWineActionEvent)]) {
		[self.delegate addWineActionEvent];
	}
}

@end
