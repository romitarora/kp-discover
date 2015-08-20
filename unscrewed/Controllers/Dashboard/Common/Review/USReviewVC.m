//
//  USReviewVC.m
//  unscrewed
//
//  Created by Robin Garg on 18/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USReviewVC.h"
#import "SZTextView.h"
#import "USReviews.h"

@interface USReviewVC ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *viewContainer;
@property (nonatomic, strong) IBOutlet UIView *viewSeparator;
@property (nonatomic, strong) IBOutlet UITextField *textFieldTitle;
@property (nonatomic, strong) IBOutlet SZTextView *textViewReview;

- (IBAction)textFieldEditingChanged:(UITextField *)textField;

@end

@implementation USReviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	if (self.reviewType == ReviewTypeStore) {
		[self.navigationItem setTitle:@"Review Place"];

	} else {
		[self.navigationItem setTitle:@"Write Review"];
	}
	CGRect rect = self.viewSeparator.frame;
	rect.origin.y = 43.5f;
	rect.size.height = 0.5f;
	self.viewSeparator.frame = rect;
	[self.textFieldTitle setFont:[USFont reviewTextFont]];
	[self.textFieldTitle setAttributedPlaceholder:[self attributedPlaceholder:@"Title"]];
	[self.textViewReview setFont:[USFont reviewTextFont]];
	[self.textViewReview setAttributedPlaceholder:[self attributedPlaceholder:@"Review (Optional)"]];
	
	[self.textFieldTitle setText:self.objReview.reviewTitle];
	[self.textViewReview setText:self.objReview.reviewDescription];
	
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonDoneTappedActionEvent)];
	[barButtonDone setEnabled:(self.objReview.reviewTitle != nil)];
	[self.navigationItem setRightBarButtonItem:barButtonDone];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification
												  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSAttributedString *)attributedPlaceholder:(NSString *)placeHolder {
	NSDictionary *attributedDict = @{NSForegroundColorAttributeName : [UIColor colorWithWhite:(195.f/255.f) alpha:1.f],
									 NSFontAttributeName : [USFont reviewTextFont]};
	return [[NSAttributedString alloc] initWithString:placeHolder attributes:attributedDict];
}

- (void)setUpUIBasedOnKeyboardHeight:(CGFloat)keyboardHeight {
	CGFloat viewContainerHeight = CGRectGetHeight(self.viewContainer.frame);
	CGFloat textViewCalulatedHeight = viewContainerHeight - 44.f - (keyboardHeight - 49.f);
	CGRect rect = self.textViewReview.frame;
	rect.size.height = textViewCalulatedHeight;
	self.textViewReview.frame = rect;
}

#pragma mark - $$ WEB SERVICES $$
#pragma mark Post Review
- (void)postReviewFailureHandlerWithError:(id)error {
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

- (void)postReviewSuccessHandlerWithInfo:(id)info {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	[self.objReview fillReviewInfo:[[info valueForKey:commentKey] nonNull]];
	if (self.delegate && [self.delegate respondsToSelector:@selector(reviewPostedSuccessfullyWithUpdatedReview:)]) {
		[self.delegate reviewPostedSuccessfullyWithUpdatedReview:self.objReview];
	}
}

- (void)postReviewWithInfo:(NSMutableDictionary *)info {
	[[HelperFunctions sharedInstance] showProgressIndicator];
	USReviews *objReviews = [USReviews new];
	if (self.reviewType == ReviewTypeStore) {
		[objReviews postLoggedInUserReviewForStoreId:self.objectId
											withInfo:info
											  target:self
										  completion:@selector(postReviewSuccessHandlerWithInfo:)
											 failure:@selector(postReviewFailureHandlerWithError:)];
	} else {
		[info setObject:@(self.objReview.reviewRatingCount) forKey:ratingKey];
		[objReviews postReviewOfLoggedInUserForWineId:self.objectId
											 withInfo:info
											   target:self
										   completion:@selector(postReviewSuccessHandlerWithInfo:)
											  failure:@selector(postReviewFailureHandlerWithError:)];
	}
}

#pragma mark - $$ EVENT HANDLER $$
#pragma mark Bar Button Handler
- (void)barButtonDoneTappedActionEvent {
	DLog(@"Done Bar button Tapped");
	NSString *title = [self.textFieldTitle.text trim];
	NSString *review = [self.textViewReview.text trim];
	// Check if user doesn't update titie and review and tapped done then no need to hit server.
	if ([title isEqualToString:self.objReview.reviewTitle] &&
		[review isEqualToString:self.objReview.reviewDescription]) {
		[self.navigationController popViewControllerAnimated:YES];
	} else {// Done button is clickable if user entered title.
		NSMutableDictionary *dictionary = [NSMutableDictionary new];
		[dictionary setObject:title forKey:titleKey];
		if (review && review.length) {
			[dictionary setObject:review forKey:bodyKey];
		}
		[self postReviewWithInfo:dictionary];
	}
}

- (IBAction)textFieldEditingChanged:(UITextField *)textField {
	UIBarButtonItem *doneBarButtonItem = self.navigationItem.rightBarButtonItem;
	doneBarButtonItem.enabled = ([textField.text trim].length > 0);
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	unsigned long newLength = textField.text.length + string.length - range.length;
	return (newLength <= 70.f);
}

#pragma mark Text View Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	unsigned long newLength = textView.text.length + text.length - range.length;
	return (newLength <= 1000.f);
}

#pragma mark Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	[self setUpUIBasedOnKeyboardHeight:CGRectGetHeight(keyboardFrame)];
}

@end
