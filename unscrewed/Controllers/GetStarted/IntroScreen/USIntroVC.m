//
//  USWelcomeVC.m
//  unscrewed
//
//  Created by Rav Chandra on 12/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USIntroVC.h"
#import "AFNetworking.h"
#import "USSignupVC.h"
#import "USLoginVC.h"
#import "USHelloVC.h"
#import "USUsers.h"
#import "FBSDKCoreKit.h"

@interface USIntroVC ()
{
    NSDictionary *_config;
}

@property (nonatomic, weak) IBOutlet UIImageView *imgViewBG;
@property (nonatomic, weak) IBOutlet UILabel *lblUnscrewed;
@property (nonatomic, weak) IBOutlet UILabel *lblWines;
@property (nonatomic, weak) IBOutlet UILabel *lblMsg;
@property (nonatomic, weak) IBOutlet UILabel *lblFBMsg;

@property (nonatomic, weak) IBOutlet UIButton *btnLoginWithFacebook;
@property (nonatomic, weak) IBOutlet UIButton *btnJoinWithEmail;
@property (nonatomic, weak) IBOutlet UIButton *btnSignIn;

- (IBAction)welcomeViewActionHandler:(UIButton *)sender;

@end

@implementation USIntroVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup View
    [self setUI];
    
    [self.imgViewBG setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] /*#333333*/];
    
    
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark View Creation
- (void)setFontAndTextColor {
    // Set Font
    [self.lblUnscrewed setFont:[USFont unscrewedFont]];
    [self.lblWines setFont:[USFont winesFont]];
    //[self.lblMsg setFont:[USFont unscrewedMsgFont]];
    [self.lblMsg setFont:[UIFont systemFontOfSize:23]];
    [self.lblFBMsg setFont:[USFont facebookMsgFont]];
    [self.btnLoginWithFacebook.titleLabel setFont:[USFont defaultButtonFont]];
    [self.btnJoinWithEmail.titleLabel setFont:[USFont defaultButtonFont]];
    //[self.btnSignIn.titleLabel setFont:[USFont defaultLinkButtonFont]];
    
    // Set Text Color
    [self.lblUnscrewed setTextColor:[USColor signInSectionNormalTextColor]];
    [self.lblWines setTextColor:[USColor signInSectionNormalTextColor]];
    [self.lblMsg setTextColor:[USColor signInSectionNormalTextColor]];
    [self.lblFBMsg setTextColor:[USColor signInSectionNormalTextColor]];
    [self.btnLoginWithFacebook setTitleColor:[USColor signInSectionNormalTextColor] forState:UIControlStateNormal];
    [self.btnJoinWithEmail setTitleColor:[USColor themeNormalTextColor] forState:UIControlStateNormal];
    [self.btnSignIn setTitleColor:[USColor themeSelectedTextColor] forState:UIControlStateNormal];
    
    // Background Color
    [self.lblUnscrewed setBackgroundColor:[USColor clearColor]];
    [self.lblWines setBackgroundColor:[USColor clearColor]];
    [self.lblMsg setBackgroundColor:[USColor clearColor]];
    [self.lblFBMsg setBackgroundColor:[USColor clearColor]];
    [self.btnLoginWithFacebook setBackgroundColor:[USColor fbButtonBGColor]];
    [self.btnJoinWithEmail setBackgroundColor:[USColor joinWithEmailBGColor]];
    [self.btnSignIn setBackgroundColor:[USColor clearColor]];
    
    
}

- (void)setUI {
    [self setFontAndTextColor];
    // Set Text
	
	NSMutableAttributedString *attStrUnscrewed = [[NSMutableAttributedString alloc] initWithString:@"unscrewed"];
	[attStrUnscrewed addAttribute:NSKernAttributeName value:@(-2.5) range:NSMakeRange(0, attStrUnscrewed.length)];
	[self.lblUnscrewed setAttributedText:attStrUnscrewed];
    [self.lblWines setText:@"Whole Foods\nTrader Joes\nCostco\nAlbertsons\nBevMo\nMore..."];
	NSMutableAttributedString *attStrMsg = [[NSMutableAttributedString alloc] initWithString:@"Always find the best wines\nat your favorite retailers"];
	[attStrMsg addAttribute:NSKernAttributeName value:@(-0.8) range:NSMakeRange(0, attStrMsg.length)];
	[self.lblMsg setAttributedText:attStrMsg];
    [self.lblFBMsg setText:@"We will never post to facebook"];
    [self.btnLoginWithFacebook setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    [self.btnJoinWithEmail setTitle:@"Join with Email" forState:UIControlStateNormal];
    
    
    
    NSString *already = @"Already have an account?";
    NSString *signString = [NSString stringWithFormat:@"%@ Sign In",already];
    NSMutableAttributedString *attSign = [[NSMutableAttributedString alloc] initWithString:signString];
    [attSign addAttribute:NSFontAttributeName value: [UIFont systemFontOfSize:12] range:NSMakeRange(0, attSign.string.length)];
    [attSign addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0] range:NSMakeRange(0, attSign.string.length)];
    [attSign addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] range:NSMakeRange(0, already.length)];
    
    CGSize stringsize = [attSign size];
    //[self.btnSignIn setFrame:CGRectMake(kScreenWidth-(stringsize.width+10), self.btnSignIn.frame.origin.y,stringsize.width, stringsize.height)];
    [self.btnSignIn setFrame:CGRectMake((kScreenWidth/2)-(stringsize.width/2), self.btnSignIn.frame.origin.y+(stringsize.height*.7),stringsize.width, stringsize.height)];
    
    [self.btnSignIn setAttributedTitle:attSign forState:UIControlStateNormal];
    //[self.btnSignIn setTitle:@"Sign In" forState:UIControlStateNormal];
}

#pragma mark - FB Login
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

#pragma mark - Navigation
- (void)navigateToSignUpViewControllerForFacebook:(BOOL)forFacebook {
    if (forFacebook) {
        if (![[FBSDKAccessToken currentAccessToken] hasGranted:@"email"] ||
			![[FBSDKAccessToken currentAccessToken] hasGranted:@"user_friends"]) {
            [kGlobalPref loginUserWithFacebook:^(NSString *token) {
                [self loginWithToken:token];
            }];
        } else {
            NSString *token = [[FBSDKAccessToken currentAccessToken] tokenString];
            [self loginWithToken:token];
        }
    } else {
        USSignupVC *objSignUpVC = [[USSignupVC alloc] init];
        objSignUpVC.fromFacebook = forFacebook;
        [self.navigationController pushViewController:objSignUpVC animated:YES];
    }
}

- (void)navigateToSignInViewController {
    USLoginVC *objUSLoginVC = [[USLoginVC alloc] init];
    [self.navigationController pushViewController:objUSLoginVC animated:YES];
}

- (void)navigateToHelloViewController {
    USHelloVC *objUSHelloVC = [[USHelloVC alloc] init];
    objUSHelloVC.name = [[USUsers sharedUser] objUser].username;
    [self.navigationController pushViewController:objUSHelloVC animated:YES];
}

- (void)navigateToDashboard {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:kAppDelegate.window cache:NO];
    [kAppDelegate.window setRootViewController:[kGlobalPref dashboard]];
    [UIView commitAnimations];
}

- (void)redirectUser {
    if ([[[USUsers sharedUser] objUser] isLogInFirstTime]) {
        [self navigateToHelloViewController];
    } else {
        [self navigateToDashboard];
    }
}

#pragma mark - $$ EVENT HANDLER $$
#pragma mark Button Handler
- (IBAction)welcomeViewActionHandler:(UIButton *)sender {
    if ([sender isEqual:self.btnLoginWithFacebook]) {
        [self navigateToSignUpViewControllerForFacebook:YES];
	} else if ([sender isEqual:self.btnJoinWithEmail]) {
        [self navigateToSignUpViewControllerForFacebook:NO];
    } else {
        [self navigateToSignInViewController];
    }
}
/* This api is called after facebook login keeping for future reference after we implement facebook
#pragma mark - network stuff
- (void)doNetworkRequest:(NSDictionary *)arguments
{
    NSURL *baseURL =
    [NSURL URLWithString:
     @"https://unscrewed-api-staging-2.herokuapp.com/api/auth/facebook"
     ];
    
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[baseURL absoluteString]
       parameters:arguments
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSDictionary *response = (NSDictionary *)responseObject;
              
              NSLog(@"%@", response);
              
              BOOL success = [[response objectForKey:@"success"] boolValue];
              BOOL authenticated = [[response objectForKey:@"authenticated"] boolValue];
              
              if (success && authenticated)
              {
                  
                  NSDictionary *user = [response objectForKey:@"user"];
                  
                  NSString *userId = [user objectForKey:@"id"];
                  NSString *authToken = [user objectForKey:@"auth_token"];
                  NSString *authTokenExpires = [user objectForKey:@"auth_token_expires_at"];
                  
                  [[NSUserDefaults standardUserDefaults] setObject:@"fbLogin" forKey:
                   @"facebook_login"];
                  [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"user_id"];
                  [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:
                   @"auth_token"];
                  [[NSUserDefaults standardUserDefaults] setObject:authTokenExpires forKey:
                   @"auth_token_expires"];
                  [[NSUserDefaults standardUserDefaults] synchronize];
                  
                  [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                  
                  [self performSegueWithIdentifier:@"facebookSegue" sender:self];
              }
              
              
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              UIAlertView *alertView =
              [[UIAlertView alloc] initWithTitle:
               @"Error connecting to Facebook"
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
*/
@end
