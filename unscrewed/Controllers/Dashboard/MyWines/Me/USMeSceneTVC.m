//
//  USMeScene.m
//  unscrewed
//
//  Created by Mario Danic on 14/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USMeSceneTVC.h"
#import "USMeSceneCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "USUsers.h"
#import "USProfileSettingsTVC.h"
#import "USMyWinesTVC.h"
#import "USPlacesTVC.h"
#import "USUsersTVC.h"
#import "AsyncImageView.h"

static const CGFloat SECTION_HEIGHT = 90.f;

@interface USMeSceneTVC ()

@property (nonatomic, strong) NSURL *profileImageFPUrl;

@end

@implementation USMeSceneTVC

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self.navigationItem setTitleView:[HelperFunctions kerningTitleViewWithTitle:@"me"]];
	[self.view setBackgroundColor:[UIColor whiteColor]];
	[self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USMeSceneCell class]) bundle:nil]
		 forCellReuseIdentifier:NSStringFromClass([USMeSceneCell class])];
	
    UIBarButtonItem *barButtonItemSettings = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(btnSettingsClicked:)];
	[self.navigationItem setRightBarButtonItem:barButtonItemSettings];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self getUserInfo];
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark Navigation
- (void)navigateToMyWinesViewController {
	NSArray *viewControllers = self.navigationController.viewControllers;
	[self.navigationController setViewControllers:@[[viewControllers objectAtIndex:0]] animated:YES];
}

- (void)navigateToMyPlaces {
	USPlacesTVC *objPlacesVC = [USPlacesTVC new];
	objPlacesVC.isFromMeSection = YES;
	[self.navigationController pushViewController:objPlacesVC animated:YES];
	
}

- (void)navigateToUsersViewControllerForUserType:(UserType)userType {
	USUsersTVC *objFollowingUser = [[USUsersTVC alloc] initWithStyle:UITableViewStylePlain];
	objFollowingUser.userType = userType;
	[self.navigationController pushViewController:objFollowingUser animated:YES];
}

#pragma mark - $$ WEB SEVICES $$
#pragma mark Get User Info
- (void)getUserInfoFailureHandlerWithError:(id)error {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	DLog(@"error = %@",error);
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

- (void)getUserInfoWithSuccessHandlerWithInfo:(id)info {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	[self.tableView reloadData];
}

- (void)getUserInfo {
	[[HelperFunctions sharedInstance] showProgressIndicator];
	[[USUsers sharedUser] userInfoWithParam:nil
									 target:self
								 completion:@selector(getUserInfoWithSuccessHandlerWithInfo:)
									failure:@selector(getUserInfoFailureHandlerWithError:)];
}

#pragma mark Bar Button Action
- (void)btnSettingsClicked:(id)sender {
	LogInfo(@"User Profile Settings");
	USProfileSettingsTVC *objProfileSettingsVC = [[USProfileSettingsTVC alloc] initWithStyle:UITableViewStyleGrouped];
	objProfileSettingsVC.title = @"Profile Settings";
	[self.navigationController pushViewController:objProfileSettingsVC animated:YES];
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark Table View DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Remove seperator inset
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsMake(0, 50, 0, 0)];
	}
	
	// Prevent the cell from inheriting the Table View's margin settings
	if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
		[cell setPreservesSuperviewLayoutMargins:NO];
	}
	
	// Explictly set your cell's layout margins
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsMake(0, 50, 0, 0)];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	USMeSceneCell *cell = (USMeSceneCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USMeSceneCell class])];
	[cell fillMeSceneCellForIndexPath:indexPath];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	switch (indexPath.row) {
		case 0:
			[self navigateToMyWinesViewController];
			break;
		case 1:
			[self navigateToMyPlaces];
			break;
		case 2:
			[self navigateToUsersViewControllerForUserType:FollowingUser];
			break;
		case 3:
			[self navigateToUsersViewControllerForUserType:FollowersUser];
			break;
		default:
			break;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return SECTION_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SECTION_HEIGHT)];
	[headerView setBackgroundColor:[UIColor clearColor]];
	
	AsyncImageView *imageViewProfile = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
	[imageViewProfile setCenter:CGPointMake(CGRectGetMidX(self.view.frame), SECTION_HEIGHT/2.f)];
	imageViewProfile.contentMode = UIViewContentModeScaleAspectFill;
	[imageViewProfile.layer setCornerRadius:60.f/2.f];
	imageViewProfile.clipsToBounds = YES;
	[imageViewProfile setBackgroundColor:[USColor themeSelectedColor]];
	if ([[USUsers sharedUser] objUser].avatar) {
		NSURL *profileUrl = [NSURL URLWithString:[[USUsers sharedUser] objUser].avatar];
		[imageViewProfile getImageFromURL:profileUrl placeholderImage:nil];
	}
	[headerView addSubview:imageViewProfile];
	
	return headerView;
}

@end
