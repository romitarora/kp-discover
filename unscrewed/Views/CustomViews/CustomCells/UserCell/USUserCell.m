//
//  USUserCell.m
//  unscrewed
//
//  Created by Robin Garg on 17/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USUserCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "USFollowingUser.h"
#import "USContact.h"

@interface USUserCell ()

@property (nonatomic, strong) IBOutlet UIImageView *imgViewProfile;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblBio;
@property (nonatomic, strong) IBOutlet UIButton *btnFollowUser;

@property (nonatomic, strong) USFollowingUser *objUser;
@property(nonatomic,assign)UserType userType;

- (IBAction)cellAccessoryViewTappedActionEvent;

@end

@implementation USUserCell

- (void)awakeFromNib {
    // Initialization code
	[self.imgViewProfile.layer setCornerRadius:CGRectGetHeight(self.imgViewProfile.frame)*0.5];
	[self.imgViewProfile setClipsToBounds:YES];
	
	[self.lblName setFont:[USFont userCellNameFont]];
	[self.lblBio setFont:[USFont userCellBioFont]];
	
	[self.lblBio setTextColor:[USColor userCellBioColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImage *)renderedImageWithName:(NSString *)imageName {
	return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)fillUserCellWithInfo:(USFollowingUser *)user forUserType:(UserType)type {
	self.objUser = user;
    self.userType = type;
	
	[self.imgViewProfile setImage:[UIImage imageNamed:@"dummy_gray"]];
	if (user.avatar) {
		[self.imgViewProfile setImageWithURL:[NSURL URLWithString:user.avatar]];
	}
	[self.lblName setText:user.username];
	[self.lblBio setText:user.bioInfo];
	
	[self.btnFollowUser setHidden:(type == FollowersUser)];
	if (self.btnFollowUser.hidden) return;
    if (user.unfollowedUser) {
        [self.btnFollowUser.layer setBorderColor:[USColor themeSelectedColor].CGColor];
        [self.btnFollowUser.layer setCornerRadius:5];
        [self.btnFollowUser.layer setBorderWidth:1];
		[self.btnFollowUser setTitle:@"ADD" forState:UIControlStateNormal];
    } else {
        [self.btnFollowUser.imageView setTintColor:[USColor userCellBioColor]];
        [self.btnFollowUser setImage:[self renderedImageWithName:@"UserCheck"] forState:UIControlStateNormal];
		[self.btnFollowUser setTitle:nil forState:UIControlStateNormal];
		[self.btnFollowUser.layer setBorderColor:[USColor clearColor].CGColor];
    }
}

#pragma mark Setup Phonebook Cell
- (void)fillUserCellWithPhonebookUser:(USContact *)user {
    self.userType = PhonebookUser;
    
    if (user.thumbnail) {
        [self.imgViewProfile setImage:user.thumbnail];
    } else {
        [self.imgViewProfile setImage:[UIImage imageNamed:@"dummy_gray"]];
    }
    
    [self.lblName setText:user.fullName];
    [self.lblBio setText:user.company];
    
    [self.btnFollowUser.layer setBorderColor:[USColor themeSelectedColor].CGColor];
    [self.btnFollowUser.layer setCornerRadius:5];
    [self.btnFollowUser.layer setBorderWidth:1];
    //[self.btnFollowUser.imageView setTintColor:[USColor themeSelectedColor]];
    //[self.btnFollowUser setImage:[self renderedImageWithName:@"following"] forState:UIControlStateNormal];
}

#pragma mark - $$ EVENT HANDLER $$
#pragma mark Accessory View Event Handler
- (IBAction)cellAccessoryViewTappedActionEvent {
//    if (self.userType == FollowingUser || self.userType == PhonebookUser || self.userType == SearchedUser) {
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(userCellFollowUnfollowUser:)]) {
        [self.delegate userCellFollowUnfollowUser:self.objUser];
    }
}

@end
