//
//  USInputVC.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 25/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USInputVC.h"
#import "USUsers.h"

@interface USInputVC ()

@end

@implementation USInputVC

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneBarButtonClicked:)];
    [doneBarButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = doneBarButton;
    
    [self setupKeyboardType];
    txtInputView.placeholder = self.placeHolderText;
    
    if (self.selectedText.length > 0) {
        txtInputView.text = self.selectedText;
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textViewTextChanged:)
												 name:UITextViewTextDidChangeNotification
											   object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [txtInputView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UITextViewTextDidChangeNotification
												  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark Set Keyboard Type
- (void)setupKeyboardType {
    switch (self.keyboardType) {
        case NUMBER_PAD:
            txtInputView.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case NUMBER_PUNCTUATION:
            txtInputView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        case EMAIL_ADDRESS:
            txtInputView.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        default:
            txtInputView.keyboardType = UIKeyboardTypeDefault;
            break;
    }
}

- (NSString *)keyForUpdateUser {
	switch (self.inputType) {
		case InputTypeUsername:
			return userNameKey;
		case InputTypeBio:
			return bioKey;
		case InputTypeEmail:
			return emailKey;
		default:
			return nil;
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
}
- (void)updateUserInfoSuccessHandlerWithInfo:(id)info {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	if (self.delegate && [self.delegate respondsToSelector:@selector(inputBoxValueEntered:)]) {
		[self.delegate inputBoxValueEntered:txtInputView.text];
	}
}
- (void)updateUserInfoWithUpdatedValue:(NSString *)updatedValue {
	NSMutableDictionary *userInfo = [NSMutableDictionary new];
	NSString *key = [self keyForUpdateUser];
	[userInfo setObject:updatedValue forKey:key];
	
	[[HelperFunctions sharedInstance] showProgressIndicator];
	[[USUsers sharedUser] updateUserInfoWithParams:userInfo
											target:self
										completion:@selector(updateUserInfoSuccessHandlerWithInfo:)
										   failure:@selector(updateUserInfoFailureHandlerWithError:)];
}

#pragma mark - $$ EVENT HANDLER $$
#pragma mark - Done Bar Button Action
- (void)doneBarButtonClicked:(UIBarButtonItem *)sender {
	if (self.inputType == InputTypePrice) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(inputBoxValueEntered:)]) {
			[self.delegate inputBoxValueEntered:txtInputView.text];
		}
	} else {
		if ([txtInputView.text isEqualToString:self.selectedText]) {
			[self.navigationController popViewControllerAnimated:YES];
		} else {
			[self updateUserInfoWithUpdatedValue:txtInputView.text];
		}
	}
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark Text View Delegates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return [HelperFunctions validateTextFieldForType:self.keyboardType previousText:textView.text newString:text];
}

#pragma mark Text View Observer
- (void)textViewTextChanged:(NSNotification *)notification {
    if (txtInputView.text.length > 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

#pragma mark Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self setUpUIBasedOnKeyboardHeight:CGRectGetHeight(keyboardFrame)];
}

- (void)setUpUIBasedOnKeyboardHeight:(CGFloat)keyboardHeight {
    CGFloat viewContainerHeight = CGRectGetHeight(viewContainer.frame);
    CGFloat textViewCalulatedHeight = viewContainerHeight - 44.f - (keyboardHeight - 49.f);
    CGRect rect = txtInputView.frame;
    rect.size.height = textViewCalulatedHeight;
    txtInputView.frame = rect;
}

@end
