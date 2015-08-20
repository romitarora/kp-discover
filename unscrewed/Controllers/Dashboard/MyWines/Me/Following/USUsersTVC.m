//
//  USFollowingUsersTVC.m
//  unscrewed
//
//  Created by Robin Garg on 16/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USUsersTVC.h"
#import "USFindFriendVC.h"
#import "USUsers.h"

static const CGFloat CELL_SEPARATOR_INSET = 52.f;

@interface USUsersTVC ()<USUserCellDelegate>

@property (nonatomic, strong) USUsers *objUsers;

@end

@implementation USUsersTVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = [self titleForUserType:self.userType];
	
	// Setup Navigation Item
    if (self.userType == FollowingUser) {
        UIBarButtonItem *addFriends = [[UIBarButtonItem alloc] initWithTitle:@"Add Friends" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonAddFriendsActionEvent)];
        [self.navigationItem setRightBarButtonItem:addFriends];
    }
    
	// Setup Table View
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USUserCell class]) bundle:nil]
		 forCellReuseIdentifier:NSStringFromClass([USUserCell class])];
	[self.tableView setRowHeight:53.5f];
	[self.tableView setTableFooterView:[UIView new]];
	[self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	/**
	 *  Loads the page with the data based on the userType enum value provided
	 */
	[self loadPageData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Page Data
- (void)loadPageData {
	switch (self.userType) {
		case FollowingUser:
			[self getFollowingUsers];
			break;
		case FacebookUser:
            [self getFacebookFriends];
			break;
		case FollowersUser:
			[self getFollowers];
			break;
		default:
			break;
	}
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark Title For User Type
- (NSString *)titleForUserType:(UserType)userType {
	switch (userType) {
		case FacebookUser:
			return @"Facebook Friends";
		case FollowingUser:
			return @"Following";
		case FollowersUser:
			return @"Following Me";
		default:
			return @"Find Contacts";
	}
}

#pragma mark Navigation
- (void)navigateToAddFriendsViewController {
    USFindFriendVC *findFriends = [[USFindFriendVC alloc] init];
    findFriends.title = @"Find and Invite";
    [self.navigationController pushViewController:findFriends animated:YES];
}

#pragma mark - $$ WEB SERVICES $$
#pragma mark Facebook Friends
- (void)getFacebookFriends {
    [[HelperFunctions sharedInstance] showProgressIndicator];
    USUsers *objUsers = [USUsers new];
    self.objUsers = [USUsers new];
    self.objUsers.arrUsers = self.arrUsers;
    [objUsers getFacebookFriends:self completionHandler:@selector(facebookFriendsSuccessHandler:) failureHandler:@selector(facebookFriendsFailureHandler:)];
}

- (void)facebookFriendsFailureHandler:(id)error {
    LogInfo(@"arrFacebookFriends = %@",error);
    [[HelperFunctions sharedInstance] hideProgressIndicator];
}

- (void)facebookFriendsSuccessHandler:(id)result {
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    self.objUsers.arrUsers = [(USUsers *)result arrUsers];
    [self.tableView reloadData];
}

#pragma mark Get Followers
- (void)getFollowersFailureHandlerWithError:(id)error {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	LogInfo(@"error = %@",error);
	if ([error isKindOfClass:[NSError class]]) {
		[HelperFunctions showAlertWithTitle:kServerError
									message:[error localizedDescription]
								   delegate:nil
						  cancelButtonTitle:kOk
						   otherButtonTitle:nil];
	} else {
		[HelperFunctions showAlertWithTitle:kError
									message:(NSString *)error
								   delegate:nil
						  cancelButtonTitle:kOk
						   otherButtonTitle:nil];
	}
}
- (void)getFollowersSuccessHandlerWithInfo:(id)info {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	[self.tableView reloadData];
}
- (void)getFollowers {
	if (!self.objUsers) {
		self.objUsers = [USUsers new];
	}
	[[HelperFunctions sharedInstance] showProgressIndicator];
	[self.objUsers getFollowersWithTarget:self
							   completion:@selector(getFollowersSuccessHandlerWithInfo:)
								  failure:@selector(getFollowersFailureHandlerWithError:)];
}

#pragma mark Get Following Users
- (void)getFollowingUsersFailureHandlerWithError:(id)error {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	LogInfo(@"error = %@",error);
	if ([error isKindOfClass:[NSError class]]) {
		[HelperFunctions showAlertWithTitle:kServerError
									message:[error localizedDescription]
								   delegate:nil
						  cancelButtonTitle:kOk
						   otherButtonTitle:nil];
	} else {
		[HelperFunctions showAlertWithTitle:kError
									message:(NSString *)error
								   delegate:nil
						  cancelButtonTitle:kOk
						   otherButtonTitle:nil];
	}
}
- (void)getFollowingUsersSuccessHandlerWithInfo:(id)info {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	[self.tableView reloadData];
}
- (void)getFollowingUsers {
	if (!self.objUsers) {
		self.objUsers = [USUsers new];
	}
	[[HelperFunctions sharedInstance] showProgressIndicator];
	[self.objUsers getFollowingUsersWithTarget:self
									completion:@selector(getFollowingUsersSuccessHandlerWithInfo:)
									   failure:@selector(getFollowingUsersFailureHandlerWithError:)];
}

#pragma mark Follow/Unfollow User
- (void)followUnfollowUserFailureHandlerWithError:(id)error {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	LogInfo(@"error = %@",error);
	if ([error isKindOfClass:[NSError class]]) {
		[HelperFunctions showAlertWithTitle:kServerError
									message:[error localizedDescription]
								   delegate:nil
						  cancelButtonTitle:kOk
						   otherButtonTitle:nil];
	} else {
		[HelperFunctions showAlertWithTitle:kError
									message:(NSString *)error
								   delegate:nil
						  cancelButtonTitle:kOk
						   otherButtonTitle:nil];
	}
}
- (void)followUnfollowUserSuccessHandlerWithInfo:(USFollowingUser *)user {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	NSInteger index = [self.objUsers.arrUsers indexOfObject:user];
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
						  withRowAnimation:UITableViewRowAnimationNone];
}
- (void)followUnfollowUser:(USFollowingUser *)user {
	[[HelperFunctions sharedInstance] showProgressIndicator];
	if (user.unfollowedUser) { // Unfollowed User, Follow User
		[self.objUsers followUser:user
									target:self
								completion:@selector(followUnfollowUserSuccessHandlerWithInfo:)
								   failure:@selector(followUnfollowUserFailureHandlerWithError:)];
	} else { // Followed User, Unfollow User
		[self.objUsers unfollowUser:user
									  target:self
								  completion:@selector(followUnfollowUserSuccessHandlerWithInfo:)
									 failure:@selector(followUnfollowUserFailureHandlerWithError:)];
	}
}

#pragma mark - $$ EVENT HANDLERS $$
#pragma mark Bar Button Event Handlers
- (void)barButtonAddFriendsActionEvent {
	[self navigateToAddFriendsViewController];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.objUsers.arrUsers.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) return;
	
	// Remove seperator inset
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		if (indexPath.row+1 == self.objUsers.arrUsers.count) {
			[cell setSeparatorInset:UIEdgeInsetsZero];
		} else {
			[cell setSeparatorInset:UIEdgeInsetsMake(0, CELL_SEPARATOR_INSET, 0, 0)];
		}
	}
	
	// Prevent the cell from inheriting the Table View's margin settings
	if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
		[cell setPreservesSuperviewLayoutMargins:NO];
	}
	
	// Explictlyx set your cell's layout margins
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		if (indexPath.row+1 == self.objUsers.arrUsers.count) {
			[cell setLayoutMargins:UIEdgeInsetsZero];
		} else {
			[cell setLayoutMargins:UIEdgeInsetsMake(0, CELL_SEPARATOR_INSET, 0, 0)];
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.userType == FacebookUser) {
        return 41.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.userType == FacebookUser) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 41)];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(11, CGRectGetMinX(headerView.frame) + 4, 280, CGRectGetHeight(headerView.frame))];
        [lblHeader setFont:[USFont wineExpertValueFont]];
        [lblHeader setTextColor:[USColor userCellBioColor]];
        [lblHeader setTextAlignment:NSTextAlignmentLeft];
        [lblHeader setText:@"FRIENDS ON UNSCREWED"];
        [headerView addSubview:lblHeader];
        
        return headerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    USUserCell *cell = (USUserCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USUserCell class]) forIndexPath:indexPath];
    // Configure the cell...
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.delegate = self;
	USFollowingUser *user = self.objUsers.arrUsers[indexPath.row];
    [cell fillUserCellWithInfo:user forUserType:self.userType];
    return cell;
}

#pragma mark User Cell Delegate
- (void)userCellFollowUnfollowUser:(USFollowingUser *)user {
	[self followUnfollowUser:user];
}

@end
