//
//  HelperFunctions.m
//  Priva
//
//  Created by Adrian Coroian on 10/2/13.
//  Copyright (c) 2014 Addval Solutions. All rights reserved.
//

#import "HelperFunctions.h"
#import <MessageUI/MessageUI.h>

@interface HelperFunctions ()<MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@end

@implementation HelperFunctions

#pragma mark - Shared Instance
static HelperFunctions *sharedObject = nil;
+ (id)sharedInstance {
    //used for executing the code once ; only once through the lifetime of the object
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

#pragma mark - AlertView
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                  delegate:(id)delegate
         cancelButtonTitle:(NSString *)cancelButtonTitle
         otherButtonTitle :(NSString *)otherButtonTitle {
    
    UIAlertView *alertWithMessage=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle,nil];
    [alertWithMessage show];
}

+ (void)showInternetNotAvilableAlertWithTarget:(id)delegate
                             cancelButtonTitle:(NSString *)cancelButtonTitle
                             otherButtonTitle :(NSString *)otherButtonTitle {
    [self showAlertWithTitle:kAlert message:kInternetNotAvilableErrorMsg delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle];
}

+ (void)showInternetNotAvilableAlert {
    [self showInternetNotAvilableAlertWithTarget:nil cancelButtonTitle:nil otherButtonTitle:kOk];
}

#pragma mark - Date Formatting
+ (BOOL)isLoggingInFirstTime:(NSDate *)date {
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:(NSCalendarUnitYear |
                                                         NSCalendarUnitMonth |
                                                         NSCalendarUnitDay |
                                                         NSCalendarUnitHour |
                                                         NSCalendarUnitMinute |
                                                         NSCalendarUnitSecond) fromDate:date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSString *currnetDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDateComponents *currentDateComponents = [calender components:(NSCalendarUnitYear |
                                                                    NSCalendarUnitMonth |
                                                                    NSCalendarUnitDay |
                                                                    NSCalendarUnitHour |
                                                                    NSCalendarUnitMinute |
                                                                    NSCalendarUnitSecond) fromDate:[dateFormatter dateFromString:currnetDate]];
    if (components.year == currentDateComponents.year && components.month == currentDateComponents.month && components.day == currentDateComponents.day && components.hour == currentDateComponents.hour && (currentDateComponents.minute - components.minute <= 0)) {
        return YES;
    } else {
        return NO;
    }
}


+ (NSString *)dateValueFromDate:(NSDate *)date {
	
	NSCalendar *calender = [NSCalendar currentCalendar];
	NSDateComponents *compenents = [calender components:(NSCalendarUnitYear |
														 NSCalendarUnitMonth |
														 NSCalendarUnitDay |
														 NSCalendarUnitHour |
														 NSCalendarUnitMinute |
														 NSCalendarUnitSecond) fromDate:date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSString *currnetDate = [dateFormatter stringFromDate:[NSDate date]];

	NSDateComponents *currentDateComponents = [calender components:(NSCalendarUnitYear |
																	NSCalendarUnitMonth |
																	NSCalendarUnitDay |
																	NSCalendarUnitHour |
																	NSCalendarUnitMinute |
																	NSCalendarUnitSecond) fromDate:[dateFormatter dateFromString:currnetDate]];
	if (compenents.year < currentDateComponents.year) {
		return [NSString stringWithFormat:@"%liy ago",(currentDateComponents.year - compenents.year)];
	} else if (compenents.month < currentDateComponents.month) {
		return [NSString stringWithFormat:@"%lim ago",(currentDateComponents.month - compenents.month)];
	} else if (compenents.day < currentDateComponents.day) {
		return [NSString stringWithFormat:@"%lid ago",(currentDateComponents.day - compenents.day)];
	} else if (compenents.hour < currentDateComponents.hour) {
		return [NSString stringWithFormat:@"%lih ago",(currentDateComponents.hour - compenents.hour)];
	} else {
		return [NSString stringWithFormat:@"%lim ago",(currentDateComponents.minute - compenents.minute)];
	}
	return kEmptyString;
}

+ (NSString *)formattedDateString:(NSString *)dateStr {
	//2014-11-26T19:31:26.379Z
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	NSDate *date = [dateFormatter dateFromString:dateStr];
	if (date) {
		return [self dateValueFromDate:date];
	}
	return nil;
}

+ (NSString *)blogFormattedDateString:(NSString *)dateStr {
	//2014-11-26T19:31:26
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	NSDate *date = [dateFormatter dateFromString:dateStr];
	if (date) {
		return [self dateValueFromDate:date];
	}
	return nil;
}

#pragma mark - Kerning
+ (UIView *)kerningTitleViewWithTitle:(NSString *)title {
	UIView *titleView = [UIView new];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
	[attributedString addAttribute:NSKernAttributeName value:@(-2.f) range:NSMakeRange(0, attributedString.length)];
	
	CGRect rect = [title boundingRectWithSize:CGSizeMake(250, 36)
									  options:NSStringDrawingUsesLineFragmentOrigin
								   attributes:@{NSFontAttributeName:[USFont kerningTitleViewFont]}
									  context:nil];
	UILabel *lblTitleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ceilf(rect.size.width), ceilf(rect.size.height))];
	[titleView setFrame:CGRectMake(0, 0, CGRectGetWidth(lblTitleView.frame), CGRectGetHeight(lblTitleView.frame) + 4)];
	[titleView addSubview:lblTitleView];
	[lblTitleView setTextAlignment:NSTextAlignmentCenter];
    //[lblTitleView setTextColor:[UIColor blackColor]];
    [lblTitleView setTextColor:[UIColor whiteColor]];
	[lblTitleView setFont:[USFont kerningTitleViewFont]];
	[lblTitleView setAttributedText:attributedString];
	
	return titleView;
}

#pragma mark - Back Arrow Bar Button Item
+ (UIBarButtonItem*)customBackBarButton {
	return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_button"]
											style:UIBarButtonItemStylePlain
										   target:self
										   action:@selector(popViewController)];
}

+ (UIBarButtonItem*)customBackBarButton2 {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_button2"]
                                            style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(popViewController)];
}

+ (void)popViewController {
	UINavigationController *navController;
	UIViewController *controller = kAppDelegate.window.rootViewController;
	if ([controller isKindOfClass:[UINavigationController class]]) {
		navController = (UINavigationController *)controller;
	} else {
		UITabBarController *tabBarController = (UITabBarController *)controller;
		navController = (UINavigationController *)[tabBarController selectedViewController];
	}
	[navController popViewControllerAnimated:YES];
}

#pragma mark - Validations
+ (BOOL)isValidPhone:(NSString *)phone {
    if([phone rangeOfString:@"@"].location == NSNotFound) {
        return YES;
    }
    return NO;
}

+ (BOOL)validateEmail:(NSString *)emailString {
    // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

// Validate Text Field for Length
+ (BOOL)validateTextField:(UITextField *)textField string:(NSString *)string lenght:(int)lenght range:(NSRange)range
{
    int newLength = (int)(textField.text.length + string.length - range.length);
    return newLength <= lenght;
}

// Validate For Numeric Number
+ (BOOL)validateTextFieldForNumber:(UITextField *)textField string:(NSString *)string lenght:(int)length range:(NSRange)range
{
    if ([string rangeOfCharacterFromSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]].location != NSNotFound) {
        // This field accepts only float entries.
        return NO;
    } else {
        return [self validateTextField:textField string:string lenght:length range:range];
    }
}

+ (BOOL)validateTextFieldForType:(REQUIRED_KEYBOARD_TYPE)keyboardType previousText:(NSString *)previousText newString:(NSString *)string {
    if ([string isEqualToString:@"."] && [previousText rangeOfString:@"."].length > 0) { // check if second dot (.) is being entered
        return NO;
    }
    NSCharacterSet *unacceptedInput;
    switch (keyboardType) {
        case NUMBER_PAD:
            unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:NUMERIC_PAD] invertedSet];
            break;
        case NUMBER_PUNCTUATION:
            unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:NUMERIC_AND_PUNCTUATION] invertedSet];
            break;
        case EMAIL_ADDRESS:
        default:
            return YES;
            break;
    }
    return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
}

#pragma mark - Current Version
/**
 *  Get App Version
 *
 *  @return current version of the app
 */
+ (NSString *)appCurrentVersion {
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    
    DLog(@"Current version :- %@ (%@)",version, build);
    return [NSString stringWithFormat:@"%@ (%@)", version, build];
}

#pragma mark - Application's Documents directory URL
// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Document Directory Path
+ (NSString *)documentDirectoryPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}

#pragma mark - Show/Hide Loading Indicators
- (void)showProgressIndicator {
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    if (!_loadingView) {
        if(IS_IPHONE_5_OR_GREATER)
            _loadingView = [[UIView alloc] initWithFrame:CGRectMake(110,230,100,100)];
        else
            _loadingView = [[UIView alloc] initWithFrame:CGRectMake(110,180,100,100)];
        [_loadingView setBackgroundColor:[UIColor blackColor]];
        [_loadingView setAlpha:0.4];
        _loadingView.layer.cornerRadius = 3.0f;
        [kAppDelegate.window addSubview:_loadingView];
    }
    
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityIndicatorView setFrame:CGRectMake(33, 33, 34, 34)];
        [_loadingView addSubview:_activityIndicatorView];
    }
    
    [_loadingView setHidden:NO];
    [_activityIndicatorView setHidden:NO];
    [_activityIndicatorView startAnimating];
    [kAppDelegate.window bringSubviewToFront:_loadingView];
}

#pragma mark - Option not to disable interation
- (void)showProgressIndicatorWithUserInteractionDiabled:(BOOL)interactionDisabled {
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    
    if (interactionDisabled) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
    
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,100)];
        _loadingView.center = kAppDelegate.window.center;
        [_loadingView setBackgroundColor:[UIColor blackColor]];
        [_loadingView setAlpha:0.4];
        _loadingView.layer.cornerRadius = 5.0f;
        [kAppDelegate.window addSubview:_loadingView];
    }
    
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityIndicatorView setFrame:CGRectMake(33, 33, 34, 34)];
        [_loadingView addSubview:_activityIndicatorView];
    }
    
    [_loadingView setHidden:NO];
    [_activityIndicatorView setHidden:NO];
    [_activityIndicatorView startAnimating];
    [kAppDelegate.window bringSubviewToFront:_loadingView];
}

- (void)hideProgressIndicator {
    [_loadingView setHidden:YES];
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    [_activityIndicatorView stopAnimating];
    [_activityIndicatorView hidesWhenStopped];
}

#pragma mark - Expert Values
+ (NSString *)expertValue:(NSInteger)expertRating {
	switch (expertRating) {
		case 100:
			return @"Best Ever";
		case 99:
			return @"Nearly Perfect";
		case 98:
			return @"Truly Magnificent";
		case 97:
			return @"Phenomenal";
		case 96:
			return @"Fantastic";
		case 95:
			return @"Exceptional";
		case 94:
			return @"Superb";
		case 93:
			return @"Outstanding";
		case 92:
			return @"Excellent";
		case 91:
			return @"Great";
		case 90:
			return @"Very Good";
		case 89:
			return @"Quite Good";
		case 88:
			return @"Good";
		case 87:
			return @"Not Bad";
		case 86:
			return @"Okay";
		case 85:
		case 84:
			return @"Decent";
		case 83:
		case 82:
			return @"Poor";
		case 81:
			return @"Very Poor";
		case 80:
		case 79:
		case 78:
		case 77:
		case 76:
			return @"Bad";
		default:
			return @"Undrinkable";
	}
}

#pragma mark - Options Array
+ (NSMutableArray *)arrWineTypesForRetailer:(BOOL)retailer
{    NSDictionary *dictRedWine = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"red", kTitleKey, @"Red-Wine-Selector", kImageNameKey,@"no",@"selected", nil];
    
    NSDictionary *dictWhiteWine = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"white", kTitleKey, @"White-Wine-Selector", kImageNameKey,@"no",@"selected", nil];
    NSDictionary *dictSparklingWine = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"sparkling", kTitleKey, @"Sparkling-Selector", kImageNameKey,@"no",@"selected", nil];
    NSDictionary *dictRoseWine = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"rose", kTitleKey, @"Rose-Selector", kImageNameKey,@"no",@"selected", nil];
    
    
    NSMutableArray *arrWineTypes;
    if (retailer) {
        NSDictionary *dictDesertWine = [NSDictionary dictionaryWithObjectsAndKeys:@"dessert", kTitleKey, @"Desert-Wine-Selector", kImageNameKey, nil];
        arrWineTypes = [[NSMutableArray alloc] initWithObjects:dictRedWine, dictWhiteWine, dictSparklingWine, dictRoseWine, dictDesertWine, nil];
    } else {
        arrWineTypes = [[NSMutableArray alloc] initWithObjects:dictRedWine, dictWhiteWine, dictSparklingWine, dictRoseWine, nil];
    }
    return arrWineTypes;
}
+ (NSArray *)arrFindWineOptions2
{
    NSDictionary *dictOption1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Reds", kTitleKey, @"wine-red", kImageNameKey, nil];
    NSDictionary *dictOption2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Whites", kTitleKey, @"wine-white", kImageNameKey, nil];
    NSDictionary *dictOption3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Sparkling, Rose & Other", kTitleKey, @"wine-sparkling", kImageNameKey, nil];
    //NSDictionary *dictOption4 = [NSDictionary dictionaryWithObjectsAndKeys:@"Under $10", kTitleKey, @"dollar", kImageNameKey, nil];
    NSDictionary *dictOption5 = [NSDictionary dictionaryWithObjectsAndKeys:@"90+ Rated Under $20", kTitleKey, @"medal", kImageNameKey, nil];
    NSDictionary *dictOption6 = [NSDictionary dictionaryWithObjectsAndKeys:@"New this Week", kTitleKey, @"newThisWeek", kImageNameKey, nil];
    NSDictionary *dictOption7 = [NSDictionary dictionaryWithObjectsAndKeys:@"By Pairing", kTitleKey, @"fork_spoon", kImageNameKey, nil];
    
    NSArray *arrOptions = [[NSArray alloc] initWithObjects:dictOption1, dictOption2, dictOption3, dictOption5, dictOption6, dictOption7, nil];
    return arrOptions;
}

+ (NSArray *)arrFindWineOptions {
	NSDictionary *dictOption1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Under $10", kTitleKey, @"dollar", kImageNameKey, nil];
	NSDictionary *dictOption2 = [NSDictionary dictionaryWithObjectsAndKeys:@"90+ Rated Under $20", kTitleKey, @"medal", kImageNameKey, nil];
	NSDictionary *dictOption3 = [NSDictionary dictionaryWithObjectsAndKeys:@"New this Week", kTitleKey, @"newThisWeek", kImageNameKey, nil];
    NSDictionary *dictOption4 = [NSDictionary dictionaryWithObjectsAndKeys:@"By Pairing", kTitleKey, @"fork_spoon", kImageNameKey, nil];
	
	NSArray *arrOptions = [[NSArray alloc] initWithObjects:dictOption1, dictOption2, dictOption3, dictOption4, nil];
	return arrOptions;
}

+ (NSMutableArray *)arrFindWineOptionsWithSnap
{
    NSMutableDictionary *dictOption0 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"All Wines", kTitleKey, @"wine-glass_new", kImageNameKey, nil];
    
    NSMutableDictionary *dictOption1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Under $10", kTitleKey, @"dollar", kImageNameKey, nil];
    NSMutableDictionary *dictOption2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"90+ Rated Under $20", kTitleKey, @"medal", kImageNameKey, nil];
    NSMutableDictionary *dictOption3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"New this Week", kTitleKey, @"newThisWeek", kImageNameKey, nil];
    NSMutableDictionary *dictOption4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"By Pairing", kTitleKey, @"fork_spoon", kImageNameKey, nil];
    NSMutableDictionary *dictOption5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Snap a Wine Pic", kTitleKey, @"snap_pic", kImageNameKey, nil];
    
    NSMutableArray *arrOptions = [[NSMutableArray alloc] initWithObjects:dictOption0,dictOption1, dictOption2, dictOption3, dictOption4, dictOption5, nil];
    return arrOptions;
}

+ (NSDictionary *)wineSortOptions {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"0", @"Best Value",
			@"0", @"Expert Reviews",
			@"0", @"User Reviews",
			@"0", @"Distance",
			@"0", @"Name", nil];
}

+ (NSDictionary *)distanceFilterOptions {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"0", @"5",
			@"0", @"10",
			@"0", @"15",
			@"0", @"20",
			@"0", @"25", nil];
}

#pragma mark - My Wines Sort Options Array
+ (NSArray *)arrMyWinesSortOptions {
	return [NSArray arrayWithObjects:@"Most Recent", @"Name (A-Z)", @"Varietal (A-Z)", @"Type", @"Price (High to Low)", nil];
}

#pragma mark - Get Wine Filters
#pragma mark For Key
+ (USWineFilter *)wineFilterForKey:(NSString *)key wineFilters:(USWineFilters *)wineFilters {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wineFilterKey ==[c] %@",key];
    NSArray *result = [wineFilters.arrFilters filteredArrayUsingPredicate:predicate];
    if (result.count) {
        return result[0];
    }
    return nil;
}

#pragma mark For Selected Value
+ (USFilterValue *)filterValueForSelectedValue:(NSString *)value values:(USFilterValues *)values {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"filterValue ==[c] %@",value];
    NSArray *result = [values.arrValues filteredArrayUsingPredicate:predicate];
    if (result.count) {
        return result[0];
    }
    return nil;
}

#pragma mark - Number Formatting
+ (NSString*)formatNumber:(NSString*)mobileNumber {
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:kEmptyString];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:kEmptyString];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:kEmptyString];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"." withString:kEmptyString];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:kEmptyString];
    
    return mobileNumber;
}

+ (NSString*)stripNumber:(NSString*) mobileNumber {
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:kEmptyString];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:kEmptyString];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:kEmptyString];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:kEmptyString];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:kEmptyString];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"." withString:kEmptyString];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:kEmptyString];
    
    return mobileNumber;
}


#pragma mark - Send Email
- (void)sendEmailTo:(NSString *)emailId withSubject:(NSString*)subject withMessage:(NSString*)message forNavController:(UINavigationController *)nav {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc]init];
        [emailComposer setMailComposeDelegate:self];
        if (emailId) {
            [emailComposer setToRecipients:@[emailId]];
        }
        [emailComposer setSubject:subject];
        [emailComposer setMessageBody:message isHTML:NO];
        
        [nav presentViewController:emailComposer animated:YES completion:nil];
    } else {
        LogInfo(@"Device does not have email functionality");
    }
}

- (void)sendEmailWithImgTo:(NSString *)emailId withSubject:(NSString*)subject withMessage:(NSString*)message withImage:(UIImage*)image forNavController:(UINavigationController *)nav {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc]init];
        [emailComposer setMailComposeDelegate:self];
        if (emailId) {
            [emailComposer setToRecipients:@[emailId]];
        }
        //[emailComposer addAttachmentData:UIImageJPEGRepresentation(image, 1) mimeType:@"image/jpeg" fileName:@"wine.jpeg"];
        NSData *data = UIImagePNGRepresentation(image);
        [emailComposer addAttachmentData:data
                           mimeType:@"image/png"
                           fileName:@"wine.png"];
        [emailComposer setSubject:subject];
        [emailComposer setMessageBody:message isHTML:NO];
        
        [nav presentViewController:emailComposer animated:YES completion:nil];
    } else {
        LogInfo(@"Device does not have email functionality");
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            DLog(@"mail cencelled");
            break;
        case MFMailComposeResultSaved:
            DLog(@"mail cencelled");
            break;
        case MFMailComposeResultSent:
            DLog(@"mail sent");
            break;
        case MFMailComposeResultFailed:
            DLog(@"mail failed");
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Send Text Message
- (void)sendTextMessageTo:(NSString *)number textMessage:(NSString *)message forNavController:(UINavigationController *)nav {
    if([MFMessageComposeViewController canSendText]) {
        // present message controller now
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
//        [messageController.navigationBar setTitleTextAttributes:@{
//                                                                  NSForegroundColorAttributeName: UIColorFromRGBA(235, 167, 22, 1),
//                                                                  NSFontAttributeName: [UIFont systemFontOfSize:20.f],
//                                                                  }];
        messageController.messageComposeDelegate = self;
        if([number length] > 0) {
            [messageController setRecipients:[NSArray arrayWithObject:number]];
        }
        messageController.body = message;
        [nav presentViewController:messageController animated:YES completion:nil];
    } else {
        LogInfo(@"Device does not have message functionality");
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            DLog(@"message cencelled");
            break;
        case MessageComposeResultSent:
            DLog(@"message sent");
            break;
        case MessageComposeResultFailed:
            DLog(@"message failed");
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
