//
//  USMeSceneCell.m
//  unscrewed
//
//  Created by Mario Danic on 14/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USMeSceneCell.h"
#import "USUsers.h"
#import "USWineFilter.h"

@implementation USMeSceneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)
  reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    // Initialization code
  }

  return self;
}

- (void)awakeFromNib
{
  // Initialization code
	[self.meCellImageView setTintColor:[USColor themeSelectedColor]];
	[self.meCellMainLabel setFont:[USFont defaultTableCellTextFont]];
	[self.meCellCountLabel setFont:[USFont meSecionValueCountFont]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)fillCellInfoWithImageName:(NSString *)imageName text:(NSString *)text count:(NSInteger)count {
	UIImage *renderedImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[self.meCellImageView setImage:renderedImage];
	[self.meCellMainLabel setText:text];
	[self.meCellCountLabel setText:[NSString stringWithFormat:@"%li",(long)count]];
}

- (void)fillMeSceneCellForIndexPath:(NSIndexPath *)indexPath {
    self.switchSetting.hidden = YES;
    self.meCellImageView.hidden = NO;
	
	CGRect rect = self.meCellCountLabel.frame;
	rect.origin.x = CGRectGetMaxX(self.meCellMainLabel.frame);
	rect.size.width = CGRectGetWidth(self.contentView.frame) - rect.origin.x;
	self.meCellCountLabel.frame = rect;
    
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
	[self.meCellImageView setContentMode:UIViewContentModeCenter];
	switch (indexPath.row)
	{
		case 0:
			[self fillCellInfoWithImageName:@"myWines" text:@"Wines" count:[[USUsers sharedUser] objUser].likedWinesCount];
			break;
		case 1:
			[self fillCellInfoWithImageName:@"placesIcon" text:@"Places" count:[[USUsers sharedUser] objUser].likedPlacesCount];
			break;
		case 2:
			[self.meCellImageView setContentMode:UIViewContentModeRight];
			[self fillCellInfoWithImageName:@"following" text:@"Following" count:[[USUsers sharedUser] objUser].followingCount];
			break;
		default:
			[self fillCellInfoWithImageName:@"MultipleUsers" text:@"Following Me" count:[[USUsers sharedUser] objUser].followerCount];
			break;
	}
}

- (void)updateCellForTextOnly {
	[self setTintColor:[USColor themeSelectedColor]];
	[self.switchSetting setHidden:YES];
	
	CGRect rect = self.meCellMainLabel.frame;
	rect.origin.x = 15.f;
	rect.size.width = (CGRectGetWidth(self.contentView.frame) - 15.f)*0.5;
	self.meCellMainLabel.frame = rect;
	
	rect = self.meCellCountLabel.frame;
	rect.origin.x = CGRectGetMaxX(self.meCellMainLabel.frame);
	rect.size.width = CGRectGetWidth(self.contentView.frame) - rect.origin.x;
	self.meCellCountLabel.frame = rect;
}

- (void)fillWinesFilterCellForFilter:(USWineFilter *)filter {
	[self updateCellForTextOnly];
	[self.meCellCountLabel setFont:[USFont filterViewStdFilterValueFont]];
	
	self.selectionStyle = UITableViewCellSelectionStyleDefault;
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	[self.meCellMainLabel setText:filter.wineFilterTitle];
	[self.meCellCountLabel setText:filter.defaultValue];
	
	[self.meCellCountLabel setTextColor:[USColor filterViewGrayColor]];
	if (filter.selectedValue) {
		[self.meCellCountLabel setText:filter.selectedValue.filterValue];
		[self.meCellCountLabel setTextColor:[USColor themeSelectedColor]];
	}	
}

- (void)fillWineFilterValue:(USFilterValue *)objValue selected:(BOOL)selected sort:(BOOL)sort {
	[self setTintColor:[USColor themeSelectedColor]];
	[self.switchSetting setHidden:YES];
	
	CGRect rect = self.meCellMainLabel.frame;
	rect.origin.x = 15.f;
	rect.size.width = CGRectGetWidth(self.contentView.frame) - 15.f;
	self.meCellMainLabel.frame = rect;

	self.accessoryType = UITableViewCellAccessoryNone;
	[self.meCellMainLabel setTextColor:[UIColor blackColor]];
	if (selected) {
		self.accessoryType = UITableViewCellAccessoryCheckmark;
		[self.meCellMainLabel setTextColor:[USColor themeSelectedColor]];
	}
	[self.meCellMainLabel setText:objValue.filterValue];
//	if (sort || objValue.filterValueCount == 0) {
//		[self.meCellMainLabel setText:objValue.filterValue];
//	} else {
//		[self.meCellMainLabel setText:[NSString stringWithFormat:@"%@(%d)", objValue.filterValue,objValue.filterValueCount]];
//	}
	[self.meCellCountLabel setText:kEmptyString];
}

- (void)fillMyWinesFilterCellForIndexPath:(NSIndexPath *)indexPath {
	[self updateCellForTextOnly];
	
	self.selectionStyle = UITableViewCellSelectionStyleDefault;
	if (indexPath.section == 0) {
		[self.meCellMainLabel setText:kMyWinesFilterSortTitle];
		[self.meCellCountLabel setText:[[NSUserDefaults standardUserDefaults] objectForKey:kMyWinesFilterSortTypeKey]];
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else {
		switch (indexPath.row) {
			case 0:
				[self.meCellMainLabel setText:kMyWinesFilterLikeTitle];
				break;
			case 1:
				[self.meCellMainLabel setText:kMyWinesFilterWantTitle];
				break;
			default:
				[self.meCellMainLabel setText:kMyWinesFilterRateTitle];
				break;
		}
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		[self.meCellCountLabel setText:kEmptyString];
		NSString *myWineFilter = [[NSUserDefaults standardUserDefaults] objectForKey:kMyWinesFilterTitleKey];
		self.accessoryType = UITableViewCellAccessoryNone;
		if ([self.meCellMainLabel.text isEqualToString:myWineFilter]) {
			self.accessoryType = UITableViewCellAccessoryCheckmark;
		}
	}
}

#pragma mark - Profile Settings Cell
- (void)setupProfileSettingsForIndexPath:(NSIndexPath *)indexPath {
    self.meCellImageView.hidden = YES;
    [self arrangeViewsForSection:indexPath.section];
    
    switch (indexPath.section) {
        case 0:
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.selectionStyle = UITableViewCellSelectionStyleGray;
            
            if (indexPath.row == 0) {
                [self fillCellInfoWithText:@"Username" value:[[[USUsers sharedUser] objUser] username] showSwitch:NO];
            } else if(indexPath.row == 1) {
                [self fillCellInfoWithText:@"Bio" value:[[[USUsers sharedUser] objUser] bioInfo] showSwitch:NO];
            } else {
                [self fillCellInfoWithText:@"Email" value:[[[USUsers sharedUser] objUser] email] showSwitch:NO];
            }
            break;
        case 1:
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (indexPath.row == 0) {
                self.switchSetting.tag = 1;
                [self fillCellInfoWithText:@"Friends" value:nil showSwitch:YES];
            } else if(indexPath.row == 1) {
                self.switchSetting.tag = 2;
                [self fillCellInfoWithText:@"Everyone" value:nil showSwitch:YES];
            }
            break;
        case 2:
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (indexPath.row == 0) {
                self.switchSetting.tag = 3;
				self.switchSetting.on = [[[USUsers sharedUser] objUser] autoFollow];
                [self fillCellInfoWithText:@"Auto-Follow Facebook Friends" value:nil showSwitch:YES];
            }
            break;
        default:
            break;
    }
    
}

- (void)arrangeViewsForSection:(NSInteger)section {
    int width = 90;
    if (section == 2) {
        width = 230;
    }
    self.meCellMainLabel.frame = CGRectMake(15, CGRectGetMinY(self.meCellMainLabel.frame), width, CGRectGetHeight(self.meCellMainLabel.frame));
    self.meCellCountLabel.frame = CGRectMake(CGRectGetMaxX(self.meCellMainLabel.frame) + 1, CGRectGetMinY(self.meCellCountLabel.frame), kScreenWidth - width - 51, CGRectGetHeight(self.meCellCountLabel.frame));
}

- (void)fillCellInfoWithText:(NSString *)text value:(NSString *)value showSwitch:(BOOL)showSwitch {
    self.meCellCountLabel.font = [USFont profileSettingFont];
    [self.meCellMainLabel setText:text];
    if (showSwitch == YES) {
        self.switchSetting.hidden = NO;
        [self.meCellCountLabel setText:kEmptyString];
    } else {
        self.switchSetting.hidden = YES;
        [self.meCellCountLabel setText:value];
    }
}

#pragma mark - Switch Action
- (IBAction)switchValueChanged:(UISwitch *)sender {
    NSString *selectedKey = kEmptyString;
    switch (sender.tag) {
        case 1: // Friends
            selectedKey = @"friends";
            break;
        case 2: // Everyone
            selectedKey = @"everyone";
            break;
        default: // Auto-Follow Facebook Friends
            selectedKey = autoFollowKey;
			if (self.delegate && [self.delegate respondsToSelector:@selector(autoFollowValueChanged)]) {
				[self.delegate autoFollowValueChanged];
			}
            break;
    }
    if (sender.isOn) {
        LogInfo(@"Switched to On for key = %@",selectedKey);
    } else {
        LogInfo(@"Switched to Off for key = %@",selectedKey);
    }
}

@end
