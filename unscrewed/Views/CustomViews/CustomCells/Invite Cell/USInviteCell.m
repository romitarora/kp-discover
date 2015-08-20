//
//  USInviteCell.m
//  unscrewed
//
//  Created by Sourabh B. on 18/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USInviteCell.h"
#import "USContact.h"

@interface USInviteCell ()

@property(nonatomic,weak)IBOutlet UILabel *lblName;
@property(nonatomic,strong)USContact *objContact;

@end

@implementation USInviteCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)fillCellForUser:(USContact *)contact {
    self.objContact = contact;
    self.lblName.text = contact.fullName;
}

- (IBAction)btnInviteClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnInviteClickedForUser:)]) {
        [self.delegate btnInviteClickedForUser:self.objContact];
    }
}

@end
