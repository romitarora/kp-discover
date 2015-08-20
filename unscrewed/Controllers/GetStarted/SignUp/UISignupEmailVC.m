//
//  UISignupEmailVC.m
//  unscrewed
//
//  Created by Mario Danic on 22/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "UISignupEmailVC.h"
#import "AFNetworking.h"
#import "USHelloVC.h"

@implementation UISignupEmailVC

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == _emailTextField) {
        [_usernameTextField becomeFirstResponder];
    } else if (textField == _usernameTextField) {
        [_passwordTextField becomeFirstResponder];
    } else {
        [self performSelector:@selector(nextButtonClick:) withObject:self];
    }
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _passwordTextField)
    {
        [textField setReturnKeyType:UIReturnKeyJoin];
    } else {
        [textField setReturnKeyType:UIReturnKeyNext];
    }
}

- (void)doNetworkRequest:(NSDictionary *)arguments
{
    NSURL *baseURL =
    [NSURL URLWithString:
     @"https://unscrewed-api-staging-2.herokuapp.com/api/signup"
     ];
    
    AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[baseURL absoluteString]
       parameters:arguments
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSDictionary *response = (NSDictionary *)responseObject;
              
              BOOL success = [[response objectForKey:@"success"] boolValue];
              NSDictionary *errors = [response objectForKey:@"errors"];
              
              NSArray *password_errors = [errors objectForKey:@"password"];
              NSArray *email_errors = [errors objectForKey:@"email"];
              NSArray *base_errors = [errors objectForKey:@"base"];
              
              NSString *errorMsg = @"";
              
              for (NSString * error in password_errors)
              {
                  errorMsg =
                  [NSString stringWithFormat:@"%@\nPassword %@", errorMsg, error];
              }
              
              for (NSString * error in email_errors)
              {
                  errorMsg = [NSString stringWithFormat:@"%@\nEmail %@", errorMsg, error];
              }
              
              for (NSString * error in base_errors)
              {
                  errorMsg = [NSString stringWithFormat:@"%@\n %@", errorMsg, error];
              }
              
              
              if (success == YES)
              {
                  
                  NSDictionary *user = [response objectForKey:@"user"];
                  NSString *authToken = [user objectForKey:@"auth_token"];
                  NSString *authTokenExpires = [user objectForKey:@"auth_token_expires_at"];
                  
                  [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:
                   @"auth_token"];
                  [[NSUserDefaults standardUserDefaults] setObject:authTokenExpires forKey:
                   @"auth_token_expires"];
                  [[NSUserDefaults standardUserDefaults] synchronize];
                  
                  [self performSegueWithIdentifier:@"signupSegue" sender:self];
                  
              } else {
                  UIAlertView *alertView =
                  [[UIAlertView alloc] initWithTitle:
                   @"Error registering user"
                                             message:errorMsg
                                            delegate:nil
                                   cancelButtonTitle:@"Ok"
                                   otherButtonTitles:nil];
                  [alertView show];
                  
              }
              
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              UIAlertView *alertView =
              [[UIAlertView alloc] initWithTitle:
               @"Error registering user"
                                         message:[error
                                                  localizedDescription
                                                  ]
                                        delegate:nil
                               cancelButtonTitle:@"Ok"
                               otherButtonTitles:nil];
              [alertView show];
              
          }];
}

- (IBAction)nextButtonClick:(id)sender
{
    NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
    
    [arguments setObject:self.emailTextField.text forKey:@"email"];
    [arguments setObject:self.passwordTextField.text forKey:@"password"];
    [arguments setObject:self.usernameTextField.text forKey:@"name"];
    [self doNetworkRequest:arguments];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    USHelloVC *usHelloVC = [segue destinationViewController];
    
    usHelloVC.name = self.usernameTextField.text;
}

@end
