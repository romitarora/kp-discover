//
//  USProfileSettingsTVC.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 10/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USProfileSettingsTVC.h"
#import "USMeSceneCell.h"
#import "AsyncImageView.h"
#import "USUsers.h"
#import "USInputVC.h"
#import <FPPicker/FPPicker.h>

@interface USProfileSettingsTVC ()<USInputVCDelegate, USMeSceneCellDelegate, FPPickerDelegate>
{
    NSIndexPath *_selectedIndexPath;
}
@end

@implementation USProfileSettingsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // register cell with tableview
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USMeSceneCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([USMeSceneCell class])];
    
    [self.view setBackgroundColor:[USColor optionsViewBGColor]];
    [self.tableView setSeparatorColor:[USColor settingsViewTableSeparatorColor]];
    
    [self setTableHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Header
- (void)setTableHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 87)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    AsyncImageView *imgProfile = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
	[imgProfile setTag:1001];
    [imgProfile setCenter:CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetHeight(headerView.frame)/2.f)];
	imgProfile.contentMode = UIViewContentModeScaleAspectFill;
    [imgProfile.layer setCornerRadius:CGRectGetHeight(imgProfile.frame)/2.f];
	imgProfile.clipsToBounds = YES;
	imgProfile.backgroundColor = [USColor themeSelectedColor];
	if ([[USUsers sharedUser] objUser].avatar) {
		NSURL *profileUrl = [NSURL URLWithString:[[USUsers sharedUser] objUser].avatar];
		[imgProfile getImageFromURL:profileUrl placeholderImage:nil];
	}
    [headerView addSubview:imgProfile];
	
    UIButton *btnProfileImage = [[UIButton alloc] initWithFrame:headerView.frame];
    [btnProfileImage addTarget:self action:@selector(btnProfileImageClicked) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btnProfileImage];
    
    [self.tableView setTableHeaderView:headerView];
    self.tableView.sectionFooterHeight = 0.f;
}

- (void)updateTableHeader {
	UIView *tableHeader = self.tableView.tableHeaderView;
	AsyncImageView *imageView = (AsyncImageView *)[tableHeader viewWithTag:1001];
	if ([[USUsers sharedUser] objUser].avatar) {
		NSURL *profileUrl = [NSURL URLWithString:[[USUsers sharedUser] objUser].avatar];
		[imageView getImageFromURL:profileUrl placeholderImage:nil];
	}
}

#pragma mark - $$ WEB SERVICES $$
#pragma mark Update User Info
- (void)updateUserInfoFailureHandlerWithError:(id)error {
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
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]]
						  withRowAnimation:UITableViewRowAnimationNone];
}
- (void)updateUserInfoSuccessHandlerWithInfo:(id)info {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	
	if ([[info allKeys] containsObject:avatarKey]) {
		[self updateTableHeader];
	}
	
}
- (void)updateUserInfoWithParam:(NSDictionary *)params {
	[[HelperFunctions sharedInstance] showProgressIndicator];
	[[USUsers sharedUser] updateUserInfoWithParams:params
											target:self
										completion:@selector(updateUserInfoSuccessHandlerWithInfo:)
										   failure:@selector(updateUserInfoFailureHandlerWithError:)];
}

#pragma mark - $$ EVENT HANDLER $$
#pragma mark Button Action
- (void)btnProfileImageClicked {
    LogInfo(@"Edit profile pic here");
	FPPickerController *filePicker = [[FPPickerController alloc] init];
	filePicker.title = @"Select Profile Image";
	filePicker.fpdelegate = self;
	filePicker.dataTypes = @[@"image/*"];
	filePicker.sourceNames = @[FPSourceCamera, FPSourceCameraRoll];
	[self presentViewController:filePicker animated:YES completion:nil];
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    USMeSceneCell *cell = (USMeSceneCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USMeSceneCell class])];
	cell.delegate = self;
    [cell setupProfileSettingsForIndexPath:indexPath];
    return cell;
}

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        _selectedIndexPath = indexPath;
        USMeSceneCell *cell = (USMeSceneCell *)[self.tableView cellForRowAtIndexPath:_selectedIndexPath];
        
        USInputVC *inputVC = [USInputVC new];
        inputVC.delegate = self;
        inputVC.keyboardType = ALPHA_NUMERIC;
        
        switch (indexPath.row) {
            case 0:
                inputVC.title = @"Username";
                inputVC.placeHolderText = @"Enter Username";
				inputVC.inputType = InputTypeUsername;
                break;
            case 1:
                inputVC.title = @"Bio";
                inputVC.placeHolderText = @"Enter Bio";
				inputVC.inputType = InputTypeBio;
                break;
            default:
                inputVC.title = @"Email";
                inputVC.placeHolderText = @"Enter Email";
                inputVC.keyboardType = EMAIL_ADDRESS;
				inputVC.inputType = InputTypeEmail;
                break;
        }
        if (cell.meCellCountLabel.text.length > 0) {
            inputVC.selectedText = cell.meCellCountLabel.text;
        }
        [self.navigationController pushViewController:inputVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.f;
    }
    return 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 280, 20)];
    lblHeader.font = [USFont profileSettingFont];
    lblHeader.textColor = [USColor storeReviewUserInfoColor];
    if (section == 1) {
        [lblHeader setText:@"WHO CAN SEE MY PROFILE"];
    } else if (section == 2) {
        [lblHeader setText:@"FACEBOOK"];
    }
    [headerView addSubview:lblHeader];
    
    return headerView;
}

#pragma mark InputVC Delegate
- (void)inputBoxValueEntered:(NSString*)value {
    LogInfo(@"selected value - %@",value);
	[self.tableView reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark File Picker Delegate Methods
- (void)FPPickerController:(FPPickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[self dismissViewControllerAnimated:YES completion:nil];
	
	NSURL* profileImageFPUrl = [info objectForKey:@"FPPickerControllerRemoteURL"];
	// Update user profile pic
	if (profileImageFPUrl) {
		NSMutableDictionary *param = [NSMutableDictionary new];
		[param setObject:profileImageFPUrl.absoluteString forKey:avatarKey];
		[self updateUserInfoWithParam:param];
	}
}

- (void)FPPickerControllerDidCancel:(FPPickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Auto Follow Event Handler
- (void)autoFollowValueChanged {
	NSMutableDictionary *param = [NSMutableDictionary new];
	[param setObject:@(![[USUsers sharedUser] objUser].autoFollow) forKey:autoFollowKey];
	[self updateUserInfoWithParam:param];
}

@end
