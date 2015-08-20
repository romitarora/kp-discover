//
//  UISignupEmailVC.h
//  unscrewed
//
//  Created by Mario Danic on 22/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISignupEmailVC : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)nextButtonClick:(id)sender;

@end
