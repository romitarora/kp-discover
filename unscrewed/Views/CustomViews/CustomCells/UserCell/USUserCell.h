//
//  USUserCell.h
//  unscrewed
//
//  Created by Robin Garg on 17/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USContact;
@class USFollowingUser;
@protocol USUserCellDelegate;

typedef enum : NSUInteger {
    FollowingUser = 0,
    FacebookUser,
    PhonebookUser,
    FollowersUser,
	SearchedUser
} UserType;

@interface USUserCell : UITableViewCell

@property (nonatomic, weak) id<USUserCellDelegate> delegate;

- (void)fillUserCellWithInfo:(USFollowingUser *)user forUserType:(UserType)type;

#pragma mark Setup Phonebook Cell
- (void)fillUserCellWithPhonebookUser:(USContact *)user;

@end

@protocol USUserCellDelegate <NSObject>

@optional
- (void)userCellFollowUnfollowUser:(USFollowingUser *)user;

@end
