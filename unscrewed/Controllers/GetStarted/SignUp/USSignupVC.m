//
//  USSignupVC.m
//  unscrewed
//
//  Created by Robin Garg on 14/01/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USSignupVC.h"
#import "USLoginVC.h"
#import "USHelloVC.h"
#import "USUsers.h"
#import <FPPicker/FPPicker.h>

static const CGFloat SECTION_HEIGHT= 179.f;
static const CGFloat ROW_HEIGHT = 44.f;
static const NSInteger NUMBER_OF_ROWS = 3;

@interface USSignupVC ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FPPickerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, strong) NSString *profileImageFPUrl;

@end

@implementation USSignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
    UIImageView *tableBGImgView = [[UIImageView alloc] init];
    [tableBGImgView setBackgroundColor:[UIColor blackColor]];
    [tableBGImgView setImage:[UIImage imageNamed:@"Splash2"]];
    [self.tableView setBackgroundView:tableBGImgView];
    [self.tableView setRowHeight:ROW_HEIGHT];
    
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification
												  object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillHideNotification
												  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark Navigate
- (void)navigateToSignInViewController {
    USLoginVC *objUSLoginVC = [[USLoginVC alloc] init];
    NSMutableArray *viewControllers = [[self.navigationController viewControllers] mutableCopy];
    [viewControllers replaceObjectAtIndex:viewControllers.count-1 withObject:objUSLoginVC];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

- (void)navigateToHelloViewController {
    USHelloVC *objUSHelloVC = [[USHelloVC alloc] init];
    objUSHelloVC.name = [[USUsers sharedUser] objUser].username;
    [self.navigationController pushViewController:objUSHelloVC animated:YES];
}

- (void)openImagePickerForCamera:(BOOL)isCamera {
    UIImagePickerController *imagePickercontroller = [[UIImagePickerController alloc] init];
    imagePickercontroller.delegate = self;
    if (isCamera) { // Take Photos from Camera
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickercontroller.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            [HelperFunctions showAlertWithTitle:kAlert
                                        message:@"Camera Functionality not available in this device."
                                       delegate:nil
                              cancelButtonTitle:kOk
                               otherButtonTitle:nil];
            return;
        }
    } else { // Take Photos from Photos Gallery
        imagePickercontroller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickercontroller animated:YES completion:nil];
}

#pragma mark Validate Input Values
- (NSString *)keyForIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return emailKey;
        case 1:
            return userNameKey;
        default:
            return passwordKey;
    }
}

- (BOOL)validateInputValues {
    NSArray *cells = [self.tableView visibleCells];
    for (UITableViewCell *cell in cells) {
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:99];
        if ([textField.text trim].length == 0) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isValidEmailInputed {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:99];
    return [textField.text isValidEmail];
}

#pragma mark - $$ WEB SERVICES $$
#pragma mark Sign Up User
- (void)signUpUserFailureHandlerWithError:(id)error {
    DLog(@"error = %@",error);
    [[HelperFunctions sharedInstance] hideProgressIndicator];
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

- (void)signUpUserSuccessHandlerWithInfo:(id)info {
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    [self navigateToHelloViewController];
}

- (void)signUpUser {
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSArray *cells = [self.tableView visibleCells];
    for (UITableViewCell *cell in cells) {
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:99];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSString *key = [self keyForIndexPath:indexPath];
        NSString *value = [textField.text trim];
        [params setObject:value forKey:key];
    }
	if (self.profileImageFPUrl) {
		[params setObject:self.profileImageFPUrl forKey:photoUrlKey];
	}
    [[HelperFunctions sharedInstance] showProgressIndicator];
    [[USUsers sharedUser] signUpUserWithParam:params
                                       target:self
                                   completion:@selector(signUpUserSuccessHandlerWithInfo:)
                                      failure:@selector(signUpUserFailureHandlerWithError:)];
}

#pragma mark - $$ EVENT HANDLER $$
#pragma mark Gesture Event Handler
- (void)dismissKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)btnAddPhotoEventHandler:(UIButton *)sender {
	FPPickerController *filePicker = [[FPPickerController alloc] init];
	filePicker.title = @"Select Profile Image";
	filePicker.fpdelegate = self;
	filePicker.dataTypes = @[@"image/*"];
	filePicker.sourceNames = @[FPSourceCamera, FPSourceCameraRoll];
	[self presentViewController:filePicker animated:YES completion:nil];
	/*
    UIActionSheet *photoSelectionAS = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
    [photoSelectionAS showInView:self.navigationController.view];
	*/
}

- (void)signUpUserEventHandler {
    if ([self validateInputValues]) {
        if ([self isValidEmailInputed]) {
            [self signUpUser];
        } else {
            // Wrong email format entered
            [HelperFunctions showAlertWithTitle:kAlert
                                        message:@"Please enter valid email address."
                                       delegate:nil
                              cancelButtonTitle:kOk
                               otherButtonTitle:nil];
        }
    } else {
        // Show Alert that all fields are required
        [HelperFunctions showAlertWithTitle:kAlert
                                    message:@"All fields are required."
                                   delegate:nil
                          cancelButtonTitle:kOk
                           otherButtonTitle:nil];
    }
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark TableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return NUMBER_OF_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifire = @"signUpCellIdentifire";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifire];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.imageView setTintColor:[USColor signInGraphicTintColor]];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(60, 7, 250, 30)];
        textField.delegate = self;
		[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [textField setFont:[USFont defaultTextFont]];
        [textField setBorderStyle:UITextBorderStyleNone];
        textField.tag = 99;
        [cell.contentView addSubview:textField];
    }
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:99];
    NSString *imageName;
    NSString *placeHolder;
    switch (indexPath.row) {
        case 0:
            imageName = @"Mail";
            placeHolder = @"Enter Email";
            break;
        case 1:
            imageName = @"UserFilled";
            placeHolder = @"Create a Username (First, Last)";
            break;
        default:
            imageName = @"Lock";
            placeHolder = @"Create a Password";
            [textField setSecureTextEntry:YES];
            break;
    }
	UIImage *renderedImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [cell.imageView setImage:renderedImage];
    [textField setPlaceholder:placeHolder];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SECTION_HEIGHT;
}

- (CGFloat)sectionFooterHeight {
    CGFloat viewHeight = CGRectGetHeight(self.view.frame) - 20.f;
    CGFloat footerHeight = (viewHeight - SECTION_HEIGHT - NUMBER_OF_ROWS * ROW_HEIGHT);
    return footerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self sectionFooterHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SECTION_HEIGHT)];
    [sectionHeaderView setBackgroundColor:[UIColor clearColor]];
    
    UIButton *btnProfilePic = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnProfilePic setFrame:CGRectMake(0, 0, 62, 62)];
    [btnProfilePic setCenter:CGPointMake(CGRectGetMidX(sectionHeaderView.frame), 115.f)];
    [btnProfilePic.layer setCornerRadius:31.f];
    [btnProfilePic.layer setBorderColor:[UIColor whiteColor].CGColor];
    [btnProfilePic.layer setBorderWidth:1.5f];
    [btnProfilePic.titleLabel setNumberOfLines:0];
	btnProfilePic.clipsToBounds = YES;
	if (self.profileImage) {
		[btnProfilePic setTitle:kEmptyString forState:UIControlStateNormal];
		[btnProfilePic setImage:self.profileImage forState:UIControlStateNormal];
	} else {
		[btnProfilePic setImage:nil forState:UIControlStateNormal];
		[btnProfilePic setTitle:@"+\nPHOTO" forState:UIControlStateNormal];
	}
    [btnProfilePic.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [btnProfilePic.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnProfilePic addTarget:self action:@selector(btnAddPhotoEventHandler:) forControlEvents:UIControlEventTouchUpInside];
    [sectionHeaderView addSubview:btnProfilePic];
    
    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat footerHeight = [self sectionFooterHeight];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, footerHeight)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lblMsg = [[UILabel alloc] initWithFrame:CGRectMake(40, 17, 240, 54)];
    [lblMsg setNumberOfLines:0];
    [lblMsg setTextColor:[USColor signInSectionNormalTextColor]];
    // Apply Line Spacing style
    NSString *string = @"By tapping to enter, you are indicating that you have read the Privacy Policy and agree to the Terms of Service";
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    [style setLineSpacing:3.f];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    [attString addAttribute:NSParagraphStyleAttributeName
                      value:style
                      range:NSMakeRange(0, string.length)];
	[attString addAttribute:NSFontAttributeName
					  value:[USFont termsAndCondFont]
					  range:NSMakeRange(0, string.length)];
    [lblMsg setAttributedText:attString];
    [footerView addSubview:lblMsg];
    
    /*
    
    
    CGSize stringsize = [attSign size];
    [self.btnSignIn setFrame:CGRectMake((kScreenWidth/2)-(stringsize.width/2), self.btnSignIn.frame.origin.y+(stringsize.height*.7),stringsize.width, stringsize.height)];
    
    
    */
    
    
    NSString *already = @"Already have an account?";
    NSString *signString = [NSString stringWithFormat:@"%@ Sign In",already];
    NSMutableAttributedString *attSign = [[NSMutableAttributedString alloc] initWithString:signString];
    [attSign addAttribute:NSFontAttributeName value: [UIFont systemFontOfSize:12] range:NSMakeRange(0, attSign.string.length)];
    [attSign addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0] range:NSMakeRange(0, attSign.string.length)];
    [attSign addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] range:NSMakeRange(0, already.length)];
    
    UIButton *btnSignIn = [UIButton buttonWithType:UIButtonTypeSystem];
    //[btnSignIn setFrame:CGRectMake(85, footerHeight - 30.f - 30.f , kScreenWidth, 30)];
    //[btnSignIn.titleLabel setFont:[USFont defaultLinkButtonFont]];
    //[btnSignIn setTitleColor:[USColor signInSectionSelectedTextColor] forState:UIControlStateNormal];
    
    
    CGSize stringsize = [attSign size];
    [btnSignIn setFrame:CGRectMake((kScreenWidth/2)-(stringsize.width/2), footerHeight - 30.f - 30.f,stringsize.width, stringsize.height)];
    [btnSignIn setAttributedTitle:attSign forState:UIControlStateNormal];
    
    //[btnSignIn setTitle:@"Already a Member" forState:UIControlStateNormal];
    [btnSignIn addTarget:self action:@selector(navigateToSignInViewController) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btnSignIn];
    
    return footerView;
}

#pragma mark Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([textField.placeholder isEqualToString:@"Enter Email"]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [(UITextField *)[cell.contentView viewWithTag:99] becomeFirstResponder];
    } else if ([textField.placeholder isEqualToString:@"Create a Username (First, Last)"]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        [(UITextField *)[cell.contentView viewWithTag:99] becomeFirstResponder];
    } else {
        [self signUpUserEventHandler];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField.placeholder isEqualToString:@"Create a Password"]) {
        [textField setReturnKeyType:UIReturnKeyJoin];
    } else {
        [textField setReturnKeyType:UIReturnKeyNext];
    }
}

#pragma mark Action Sheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) return;
    [self openImagePickerForCamera:(buttonIndex == 0)];
}

#pragma mark UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.profileImage = originalImage;
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark File Picker Delegate Methods
- (void)FPPickerController:(FPPickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[self dismissViewControllerAnimated:YES completion:nil];
	
	UIImage *thumbnail = [info objectForKey:@"FPPickerControllerThumbnailImage"];
	if (thumbnail) {
		self.profileImage = thumbnail;
	} else {
		UIImage *originalImage = [info objectForKey:@"FPPickerControllerOriginalImage"];
		self.profileImage = originalImage;
	}
	NSURL *url = [info objectForKey:@"FPPickerControllerRemoteURL"];
	self.profileImageFPUrl = [url absoluteString];
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)FPPickerControllerDidCancel:(FPPickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	[self.tableView setContentInset:UIEdgeInsetsMake(0, 0, CGRectGetHeight(keyboardFrame), 0)];
}

- (void)keyboardWillHide:(NSNotification *)note {
	[self.tableView setContentInset:UIEdgeInsetsZero];
}

@end
