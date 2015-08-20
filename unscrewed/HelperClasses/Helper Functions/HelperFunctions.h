//
//  HelperFunctions.h
//  Priva
//
//  Created by Adrian Coroian on 10/2/13.
//  Copyright (c) 2014 Addval Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USWineFilters.h"

typedef enum {
    NUMBER_PAD = 0,
    NUMBER_PUNCTUATION,
    ALPHA_NUMERIC,
    EMAIL_ADDRESS
} REQUIRED_KEYBOARD_TYPE;

@interface HelperFunctions : NSObject
{
    UIView *_loadingView;
    UIActivityIndicatorView *_activityIndicatorView;
}

#pragma mark - Shared
+ (id)sharedInstance;

#pragma mark - AlertView
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                  delegate:(id)delegate
         cancelButtonTitle:(NSString *)cancelButtonTitle
         otherButtonTitle :(NSString *)otherButtonTitle;

+ (void)showInternetNotAvilableAlertWithTarget:(id)delegate
                             cancelButtonTitle:(NSString *)cancelButtonTitle
                             otherButtonTitle :(NSString *)otherButtonTitle;

+ (void)showInternetNotAvilableAlert;

#pragma mark - Date Formatting
+ (BOOL)isLoggingInFirstTime:(NSDate *)date;
+ (NSString *)formattedDateString:(NSString *)dateStr;
+ (NSString *)blogFormattedDateString:(NSString *)dateStr;

#pragma mark - Kerning
+ (UIView *)kerningTitleViewWithTitle:(NSString *)title;

#pragma mark - Back Arrow Bar Button Item
+ (UIBarButtonItem*)customBackBarButton;
+ (UIBarButtonItem*)customBackBarButton2;

#pragma mark - Validations -
+ (BOOL)isValidPhone:(NSString *)phone;
+ (BOOL)validateEmail:(NSString *)emailString;
+ (BOOL)validateTextField:(UITextField *)textField string:(NSString *)string lenght:(int)length range:(NSRange)range;
+ (BOOL)validateTextFieldForNumber:(UITextField *)textField string:(NSString *)string lenght:(int)length range:(NSRange)range;
+ (BOOL)validateTextFieldForType:(REQUIRED_KEYBOARD_TYPE)keyboardType previousText:(NSString *)previousText newString:(NSString *)string;

#pragma mark - Current Version -
+ (NSString *)appCurrentVersion;

#pragma mark - Document Directory Path
+ (NSString *)documentDirectoryPath;
+ (NSURL *)applicationDocumentsDirectory;

#pragma mark - Show/Hide Loading Indicators
- (void)showProgressIndicator;
// Option not to disable interation
- (void)showProgressIndicatorWithUserInteractionDiabled:(BOOL)interactionDisabled;
- (void)hideProgressIndicator;

#pragma mark - Expert Values
+ (NSString *)expertValue:(NSInteger)expertRating;

#pragma mark - Options Array
+ (NSArray *)arrWineTypesForRetailer:(BOOL)retailer;

+ (NSArray *)arrFindWineOptions2;
+ (NSArray *)arrFindWineOptions;
+ (NSArray *)arrFindWineOptionsWithSnap;

#pragma mark - Wines Sort Options Array
+ (NSDictionary *)wineSortOptions;

// Distance Filter Options
+ (NSDictionary *)distanceFilterOptions;

#pragma mark - My Wines Sort Options Array
+ (NSArray *)arrMyWinesSortOptions;

#pragma mark - Get Wine Filters
#pragma mark For Key
+ (USWineFilter *)wineFilterForKey:(NSString *)key wineFilters:(USWineFilters *)wineFilters;

#pragma mark For Selected Value
+ (USFilterValue *)filterValueForSelectedValue:(NSString *)value values:(USFilterValues *)values;

#pragma mark - Number Formatting
+ (NSString*)formatNumber:(NSString*)mobileNumber;
+ (NSString*)stripNumber:(NSString*) mobileNumber;


#pragma mark - Send
#pragma mark Email
- (void)sendEmailTo:(NSString *)emailId withSubject:(NSString*)subject withMessage:(NSString*)message forNavController:(UINavigationController *)nav;

- (void)sendEmailWithImgTo:(NSString *)emailId withSubject:(NSString*)subject withMessage:(NSString*)message withImage:(UIImage*)image forNavController:(UINavigationController *)nav;

#pragma mark Text Message
- (void)sendTextMessageTo:(NSString *)number textMessage:(NSString *)message forNavController:(UINavigationController *)nav;

@end
