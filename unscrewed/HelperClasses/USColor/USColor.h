//
//  USColor.h
//  unscrewed
//
//  Created by Gary Earle on 11/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USColor : NSObject

+ (UIColor *)clearColor;

+ (UIColor *)themeSelectedColor;

+ (UIColor *)themeNormalTextColor;
+ (UIColor *)themeSelectedTextColor;

+ (UIColor *)themeTextSubTitleColor;

+ (UIColor *)cellSeparatorColor;

+ (UIColor *)signInGraphicTintColor;
+ (UIColor *)signInSectionNormalTextColor;
+ (UIColor *)signInSectionSelectedTextColor;

+ (UIColor *)fbButtonBGColor;
+ (UIColor *)joinWithEmailBGColor;

// Find Wines
// Wine Cell
+ (UIColor *)wineCellDescriptionColor;

// Options/Settings View
+ (UIColor *)optionsViewBGColor;
+ (UIColor *)settingsViewTableSeparatorColor;

// Wine Details
+ (UIColor *)wineDetailsPriceTitleColor;
+ (UIColor *)wineDetailsPriceNotFoundColor;
+ (UIColor *)darkMenuOptionColor;
+ (UIColor *)mediumDarkMenuOptionColor;
+ (UIColor *)lightDarkMenuOptionColor;

// Store Details
+ (UIColor *)storeReviewUserInfoColor;

+ (UIColor *)grayedStarColor;
+ (UIColor *)highlightedStarColor;

// User Cell Color
+ (UIColor *)userCellBioColor;

#pragma mark - Filter
+ (UIColor *)filterViewGrayColor;

#pragma mark - ActionSheet
+ (UIColor *)actionSheetTitleColor;
+ (UIColor *)actionSheetDescriptionColor;

#pragma mark - Color from hex
+ (UIColor *)colorFromHexString: (NSString *)hexString;

@end
