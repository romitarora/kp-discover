//
//  USFeedbackVC.m
//  unscrewed
//
//  Created by Mario Danic on 13/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USFeedbackVC.h"
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@implementation USFeedbackVC

- (void)viewDidLoad
{

  [self.feedbackTextField.layer setBackgroundColor:[[UIColor whiteColor]CGColor]
  ];
  [self.feedbackTextField.layer setBorderColor:[[UIColor grayColor] CGColor]];
  [self.feedbackTextField.layer setBorderWidth:0.6f];
  [self.feedbackTextField.layer setCornerRadius:5.0f];
  [self.feedbackTextField.layer setMasksToBounds:YES];
  self.feedbackTextField.textColor = [UIColor lightGrayColor];

  [self.feedbackTextField setDelegate:self];
  [self.feedbackTextField setReturnKeyType:UIReturnKeySend];

  UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
  tap.cancelsTouchesInView = NO;
  [self.view addGestureRecognizer:tap];

}

- (void)dismissKeyboard:(UITapGestureRecognizer *)sender
{
  [self.view endEditing:YES];
}


#pragma mark - Textview
- (void)textViewDidBeginEditing:(UITextView *)textView
{
  [textView becomeFirstResponder];
  [textView setText:@""];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
  replacementText:(NSString *)text
{
  if ([text isEqualToString:@"\n"])
  {
    [textView resignFirstResponder];
    NSMutableDictionary *arguments = [[NSMutableDictionary alloc]init];
    [arguments setObject:textView.text forKey:@"body"];
    [self doNetworkRequest:arguments];
    [textView setText:@""];
  }

  return YES;
}

- (void)doNetworkRequest:(NSDictionary *)arguments
{


  NSURL *baseURL;
  NSString *xAuthToken;

  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"] != nil)
  {
    xAuthToken =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
  }

  baseURL =
    [NSURL URLWithString:[NSString stringWithFormat:
                          @"http://unscrewed-api-staging-2.herokuapp.com/api/feedback"
     ]];

  AFHTTPSessionManager *manager =
    [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
  manager.responseSerializer = [AFJSONResponseSerializer serializer];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];

  [manager.requestSerializer setValue:xAuthToken forHTTPHeaderField:
   @"X-AUTH-TOKEN"];

  [manager POST:[baseURL absoluteString]
     parameters:arguments
        success:^(NSURLSessionDataTask *task, id responseObject){

    NSDictionary *response = (NSDictionary *)responseObject;

    NSLog(@"%@", response);

  }  failure:^(NSURLSessionDataTask *task, NSError *error) {
    UIAlertView *alertView =
      [[UIAlertView alloc] initWithTitle:
       @"Error submitting feedback!"
                                 message:[error
                                          localizedDescription
       ]
                                delegate:nil
                       cancelButtonTitle:@"Ok"
                       otherButtonTitles:nil];
    [alertView show];

  }];
}



@end
