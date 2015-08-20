//
//  USLoginVC.m
//  unscrewed
//
//  Created by Mario Danic on 22/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USLoginVC.h"
#import "AFNetworking.h"
#import "USWineTabBarRootVC.h"
#import "USLocation.h"
#import "USLocationManager.h"
#import "USSignupVC.h"
#import "USHelloVC.h"
#import "USUsers.h"
#import "FBSDKCoreKit.h"

static const CGFloat SECTION_HEIGHT= 160.f;
static const CGFloat ROW_HEIGHT = 44.f;
static const NSInteger NUMBER_OF_ROWS = 2;

@interface USLoginVC () <UIAlertViewDelegate, UITextFieldDelegate>
{
    NSDictionary *_config;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation USLoginVC

+ (BOOL)isUserLoggedIn
{
    return ([[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"] !=
            nil);
}

+ (NSString *)authToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
}

+ (NSString *)userId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
}

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
- (void)navigateToSignUpViewController {
    USSignupVC *objUSSignupVC = [[USSignupVC alloc] init];
    NSMutableArray *viewControllers = [[self.navigationController viewControllers] mutableCopy];
    [viewControllers replaceObjectAtIndex:viewControllers.count-1 withObject:objUSSignupVC];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

#pragma mark Validate Input Values
- (NSString *)keyForIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return emailKey;
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
- (void)signInUserFailureHandlerWithError:(id)error {
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


- (void)signInUserSuccessHandlerWithInfo:(id)info {
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    [self redirectUser];
}

- (void)signInUserWithParams:(NSMutableDictionary *)params {
    [[HelperFunctions sharedInstance] showProgressIndicator];
    [[USUsers sharedUser] signInUserWithParam:params
                                       target:self
                                   completion:@selector(signInUserSuccessHandlerWithInfo:)
                                      failure:@selector(signInUserFailureHandlerWithError:)];
}

#pragma mark - $$ EVENT HANDLER $$
#pragma mark Gesture Event Handler
- (void)dismissKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

#pragma mark - UIButton Events
#pragma mark Forgot Password
- (void)btnForgotPasswordEventHandler:(UIButton *)sender {
    // Implement Forgot Password Functionality
}

#pragma mark Sign Up
- (void)btnSignUpEventHandler:(UIButton *)sender {
    [self navigateToSignUpViewController];
}

#pragma mark Sign In with Facebook
- (void)btnSignInWithFacebookEventHandler:(UIButton *)sender {
    if (![[FBSDKAccessToken currentAccessToken] hasGranted:@"email"] || ![[FBSDKAccessToken currentAccessToken] hasGranted:@"user_friends"]) {
        [kGlobalPref loginUserWithFacebook:^(NSString *token) {
            [self loginWithToken:token];
        }];
    } else {
        NSString *token = [[FBSDKAccessToken currentAccessToken] tokenString];
        [self loginWithToken:token];
    }
}

- (void)loginWithToken:(NSString *)token {
    [[HelperFunctions sharedInstance] showProgressIndicator];
    NSDictionary *dictToken = [NSDictionary dictionaryWithObject:token forKey:@"access_token"];
    [[USUsers sharedUser] facebookLoginWithToken:dictToken target:self completion:@selector(facebookLoginSuccessHandlerWithInfo:) failure:@selector(facebookLoginFailureHandlerWithError:)];
}

- (void)facebookLoginSuccessHandlerWithInfo:(USUser*)objUser {
    [kGlobalPref setLoggedInUserFlag];
    
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    [[USUsers sharedUser] setObjUser:objUser];
    
    [self redirectUser];
}

- (void)facebookLoginFailureHandlerWithError:(id)error {
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    LogError(@"%@",error);
}

#pragma mark - Redirect User
- (void)redirectUser {
    if ([[[USUsers sharedUser] objUser] isLogInFirstTime]) {
        [self navigateToHelloViewController];
    } else {
        [self navigateToDashboard];
    }
}

- (void)navigateToDashboard {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:kAppDelegate.window cache:NO];
    [kAppDelegate.window setRootViewController:[kGlobalPref dashboard]];
    [UIView commitAnimations];
}


- (void)navigateToHelloViewController {
    USHelloVC *objUSHelloVC = [[USHelloVC alloc] init];
    objUSHelloVC.name = [[USUsers sharedUser] objUser].username;
    [self.navigationController pushViewController:objUSHelloVC animated:YES];
}



#pragma mark Sign In With Email
- (void)signInUserEventHandler {
    if ([self validateInputValues]) {
        if ([self isValidEmailInputed]) {
            NSMutableDictionary *params = [NSMutableDictionary new];
            NSArray *cells = [self.tableView visibleCells];
            for (UITableViewCell *cell in cells) {
                UITextField *textField = (UITextField *)[cell.contentView viewWithTag:99];
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                NSString *key = [self keyForIndexPath:indexPath];
                NSString *value = [textField.text trim];
                [params setObject:value forKey:key];
            }
            [self signInUserWithParams:params];
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
            placeHolder = @"Email or Username";
            break;
        default:
            imageName = @"Lock";
            placeHolder = @"Password";
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
    CGFloat viewHeight = CGRectGetHeight(self.view.frame)-20.f;
    CGFloat footerHeight = (viewHeight - SECTION_HEIGHT - NUMBER_OF_ROWS * ROW_HEIGHT);
    return footerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self sectionFooterHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SECTION_HEIGHT)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lblMsg = [[UILabel alloc] initWithFrame:CGRectMake(40, 105, 240, 26)];
    [lblMsg setFont:[USFont signInHeaderFont]];
    [lblMsg setTextColor:[USColor signInSectionNormalTextColor]];
    [lblMsg setTextAlignment:NSTextAlignmentCenter];
    [lblMsg setText:@"Sign In"];
    [headerView addSubview:lblMsg];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat footerHeight = [self sectionFooterHeight];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, footerHeight)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    // Forgot Password
    UIButton *btnForgotPassword = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnForgotPassword setFrame:CGRectMake(20, 20 , 160, 30)];
    [btnForgotPassword.titleLabel setFont:[USFont defaultLinkButtonFont]];
    [btnForgotPassword setTitleColor:[USColor signInSectionNormalTextColor] forState:UIControlStateNormal];
    [btnForgotPassword setTitle:@"Forgot Password" forState:UIControlStateNormal];
    [btnForgotPassword setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnForgotPassword addTarget:self action:@selector(btnForgotPasswordEventHandler:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btnForgotPassword];
    // Sign Up
    UIButton *btnSignUp = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnSignUp setFrame:CGRectMake(20, 50, 120, 30)];
    [btnSignUp.titleLabel setFont:[USFont defaultLinkButtonFont]];
    [btnSignUp setTitleColor:[USColor signInSectionNormalTextColor] forState:UIControlStateNormal];
    [btnSignUp setTitle:@"Sign Up" forState:UIControlStateNormal];
    [btnSignUp setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnSignUp addTarget:self action:@selector(btnSignUpEventHandler:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btnSignUp];
    // Sign In with Facebook
	CGFloat btnSignInFacebookY = footerHeight - 46.f - (IS_IPHONE_4 ? 72: 92);
    UIButton *btnSignInFacebook = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnSignInFacebook setFrame:CGRectMake(0, btnSignInFacebookY , 320, 46)];
    [btnSignInFacebook.titleLabel setFont:[USFont defaultButtonFont]];
    [btnSignInFacebook setTitleColor:[USColor signInSectionNormalTextColor] forState:UIControlStateNormal];
    [btnSignInFacebook setTitle:@"Sign In with Facebook" forState:UIControlStateNormal];
    [btnSignInFacebook setBackgroundColor:[USColor fbButtonBGColor]];
    [btnSignInFacebook addTarget:self action:@selector(btnSignInWithFacebookEventHandler:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btnSignInFacebook];
    
    return footerView;
}

#pragma mark Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([textField.placeholder isEqualToString:@"Email or Username"]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [(UITextField *)[cell.contentView viewWithTag:99] becomeFirstResponder];
    } else {
        [self signInUserEventHandler];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField.placeholder isEqualToString:@"Password"]) {
        [textField setReturnKeyType:UIReturnKeyJoin];
    } else {
        [textField setReturnKeyType:UIReturnKeyNext];
    }
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


/*
- (void)doNetworkRequest:(NSDictionary *)arguments
{
  NSURL *baseURL =
    [NSURL URLWithString:
     @"https://unscrewed-api-staging-2.herokuapp.com/api/auth"
    ];

  AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];

  manager.responseSerializer = [AFJSONResponseSerializer serializer];


  [manager POST:[baseURL absoluteString]
     parameters:arguments
        success:^(NSURLSessionDataTask *task, id responseObject) {
    NSDictionary *response = (NSDictionary *)responseObject;


    NSLog(@"LOGIN RESPONSE: %@", response);


    BOOL success = [[response objectForKey:@"success"] boolValue];
    NSString *errorMsg = [response objectForKey:@"message"];

    if (success == YES)
    {

      NSDictionary *user = [response objectForKey:@"user"];
      NSString *userId = [user objectForKey:@"id"];
      NSString *authToken = [user objectForKey:@"auth_token"];

      NSLog(@"AUTH_TOKEN: %@ USER_ID: %@", authToken, userId);

      NSString *authTokenExpires = [user objectForKey:@"auth_token_expires_at"];

      [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"user_id"];
      [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:
       @"auth_token"];
      [[NSUserDefaults standardUserDefaults] setObject:authTokenExpires forKey:
       @"auth_token_expires"];
      [[NSUserDefaults standardUserDefaults] synchronize];

      [[UIApplication sharedApplication] endIgnoringInteractionEvents];
      [self doNetworkRequest];

    } else {
      UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:
         @"Can't log you in!"
                                   message:errorMsg
                                  delegate:nil
                         cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil];
      [[UIApplication sharedApplication] endIgnoringInteractionEvents];

      [alertView show];

    }

  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    UIAlertView *alertView =
      [[UIAlertView alloc] initWithTitle:
       @"Can't log you in"
                                 message:[error
                                          localizedDescription
       ]
                                delegate:nil
                       cancelButtonTitle:@"Ok"
                       otherButtonTitles:nil];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [alertView show];

  }];
}

- (IBAction)buttonClick:(id)sender
{

  UIButton *resultButton = (UIButton *)sender;

  if ([resultButton.currentTitle isEqualToString:@"Login"])
  {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];

    [arguments setObject:self.emailTextField.text forKey:@"email"];
    [arguments setObject:self.passwordTextField.text forKey:@"password"];

    [self doNetworkRequest:arguments];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)
  buttonIndex
{
  if (buttonIndex == 0)
  {
    _isUserAtPlace = NO;
  } else {
    _isUserAtPlace = YES;
  }
  [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

  if ([[segue identifier] isEqualToString:@"loginSegue"])
  {
    USWineTabBarRootVC *usWineTabBarRootVC = [segue destinationViewController];
    usWineTabBarRootVC.goDirectlyToPlaceFromLogin = _isUserAtPlace;
    usWineTabBarRootVC.goDirectlyToPlaceId = self.goDirectlyToPlaceId;
    if (_isUserAtPlace)
    {
      [usWineTabBarRootVC setSelectedIndex:2];
    } else {
      [usWineTabBarRootVC setSelectedIndex:0];
    }
  }
}

- (void)doNetworkRequest
{

  // used for asking user if he's in place
  NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];

  USLocation *usLocation = [[USLocationManager sharedInstance] currentLocation];
  NSString *endpoint =
    [NSString stringWithFormat:
     @"https://unscrewed-api-staging-2.herokuapp.com/api/places?lat=%@&lng=%@",
     usLocation.latitudeAsString, usLocation.longitudeAsString];

  NSURL *baseURL = [NSURL URLWithString:endpoint];

  AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];

  manager.responseSerializer = [AFJSONResponseSerializer serializer];

  [manager GET:[baseURL absoluteString]
    parameters:arguments
       success:^(NSURLSessionDataTask *task, id responseObject) {
    NSDictionary *response = (NSDictionary *)responseObject;

    if ([[response objectForKey:@"places"] count] == 0)
    {
      _isUserAtPlace = NO;
      [self performSegueWithIdentifier:@"loginSegue" sender:self];
    } else {
      NSDictionary *place = [[response objectForKey:@"places"] objectAtIndex:0];
      self.goDirectlyToPlaceId = [place objectForKey:@"id"];
      NSString *placeName = [place objectForKey:@"name"];

      UIAlertView *alertView = [[UIAlertView alloc]
                                initWithTitle:@"Places"
                                          message:[NSString stringWithFormat:
                                                   @"Are you at %@?", placeName]
                                         delegate:self
                                cancelButtonTitle:@"No"
                                otherButtonTitles:@"Yes", nil];
      [alertView show];
    }

  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    UIAlertView *alertView =
      [[UIAlertView alloc] initWithTitle:
       @"Error Retrieving places"
                                 message:[error
                                          localizedDescription
       ]
                                delegate:nil
                       cancelButtonTitle:@"Ok"
                       otherButtonTitles:nil];
    [alertView show];
  }];
}
*/
@end
