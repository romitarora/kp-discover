//
//  USColor.m
//  unscrewed
//
//  Created by Gary Earle on 11/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USColor.h"

@implementation USColor

+ (UIColor *)clearColor {
    return [UIColor clearColor];
}

+ (UIColor *)themeSelectedColor
{
  return [UIColor colorWithRed:253.f/255.f
                         green:60.f/255.f
                          blue:87.f/255.f
                         alpha:1.f];
}

+ (UIColor *)themeNormalTextColor {
    return [UIColor blackColor];
}
+ (UIColor *)themeSelectedTextColor {
    return [self themeSelectedColor];
}
+ (UIColor *)themeTextSubTitleColor {
	return [UIColor colorWithWhite:(144.f/255.f) alpha:1.f];
}
+ (UIColor *)cellSeparatorColor {
	return [UIColor colorWithWhite:(236.f/255.f) alpha:1.f];
}

+ (UIColor *)settingsViewTableSeparatorColor {
	return [UIColor colorWithWhite:(228.f/255.f) alpha:1.f];
}

+ (UIColor *)signInGraphicTintColor {
	return [UIColor colorWithWhite:(196.f/255.f) alpha:1.f];
}
+ (UIColor *)signInSectionNormalTextColor {
    return [UIColor whiteColor];
}
+ (UIColor *)signInSectionSelectedTextColor {
    return [self themeSelectedTextColor];
}

+ (UIColor *)fbButtonBGColor {
    return [UIColor colorWithRed:75.f/255.f
                           green:109.f/255.f
                            blue:173.f/255.f
                           alpha:1.f];
}
+ (UIColor *)joinWithEmailBGColor {
    return [UIColor whiteColor];
}

+ (UIColor *)wineCellDescriptionColor {
	return [UIColor colorWithWhite:121.f/255.f alpha:1.f];
}

// Options/Settings View
+(UIColor *)optionsViewBGColor {
	return [UIColor colorWithRed:(240.f/255.f)
						   green:(238.f/255.f)
							blue:(236.f/255.f)
						   alpha:1.f];
}

// Wine Details
+ (UIColor *)wineDetailsPriceTitleColor {
	return [UIColor colorWithWhite:(127.f/255.f) alpha:1.f];
}
+ (UIColor *)wineDetailsPriceNotFoundColor {
	return [UIColor colorWithWhite:(151.f/255.f) alpha:1.f];
}
+ (UIColor *)darkMenuOptionColor {
    return [UIColor colorWithWhite:(33.f/255.f) alpha:1.f];
}

+ (UIColor *)mediumDarkMenuOptionColor {
    return [UIColor colorWithWhite:(104.f/255.f) alpha:1.f];
}

+ (UIColor *)lightDarkMenuOptionColor {
    return [UIColor colorWithWhite:(164.f/255.f) alpha:1.f];
}

// Store Details
+ (UIColor *)storeReviewUserInfoColor {
	return [UIColor colorWithWhite:(96.f/255.f) alpha:1.f];
}

+ (UIColor *)grayedStarColor {
    return [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1.f];
}

+ (UIColor *)highlightedStarColor {
    return [UIColor colorWithRed:254.f/255.f green:214.f/255.f blue:42.f/255.f alpha:1.f];
}

#pragma mark - User Cell Color
+ (UIColor *)userCellBioColor {
	return [UIColor colorWithWhite:(119.f/255.f) alpha:1.f];
}

#pragma mark - Filter
+ (UIColor *)filterViewGrayColor {
	return [UIColor colorWithWhite:170.f/255.f alpha:1.f];
}

#pragma mark - ActionSheet
+ (UIColor *)actionSheetTitleColor {
    return [UIColor lightGrayColor];
//    return [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1.f];
}

+ (UIColor *)actionSheetDescriptionColor {
	return [UIColor colorWithWhite:(144.f/255.f) alpha:1.f];
}

#pragma mark - Color from hex
+ (UIColor *)colorFromHexString: (NSString *)hexString{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >>8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
