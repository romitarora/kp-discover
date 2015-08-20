//
//  USInviteCell.h
//  unscrewed
//
//  Created by Sourabh B. on 18/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USContact;
@protocol USInviteCellDelegate <NSObject>
- (void)btnInviteClickedForUser:(USContact *)user;
@end

@interface USInviteCell : UITableViewCell

- (void)fillCellForUser:(USContact *)contact;

@property(nonatomic, weak)id <USInviteCellDelegate> delegate;

@end

