//
//  USFont.h
//  unscrewed
//
//  Created by Robin Garg on 14/01/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USFont : NSObject

#pragma mark - App Level Font
+ (UIFont *)defaultTextFont;

+ (UIFont *)defaultButtonFont;
+ (UIFont *)defaultLinkButtonFont;

+ (UIFont *)defaultTableCellTextFont;

+ (UIFont *)kerningTitleViewFont;

#pragma mark - SignUp/Login Section
// Welcome/Intro View
+ (UIFont *)unscrewedFont;
+ (UIFont *)winesFont;
+ (UIFont *)unscrewedMsgFont;
+ (UIFont *)facebookMsgFont;

// Sign Up View
+ (UIFont *)termsAndCondFont;

// Sign In View
+ (UIFont *)signInHeaderFont;

// Hello View
+ (UIFont *)helloNameFont;
+ (UIFont *)helloMsgFont;
+ (UIFont *)gotitMsgFont;

// Table Header Message on Places & Invite Friends
+ (UIFont *)tableHeaderTitleFont;
+ (UIFont *)tableHeaderMessageFont;

// Places Cell Font
+ (UIFont *)placeNameFont;
+ (UIFont *)placeAddressFont;

// Logout button font
+ (UIFont *)logoutButtonFont;

#pragma mark - Dashboard
// Blogs View
+ (UIFont *)blogUserNameFont;
+ (UIFont *)blogPostedTimeFont;
+ (UIFont *)blogTitleFont;
+ (UIFont *)blogSubtitleFont;
+ (UIFont *)blogDescriptionFont;

// Find Wines
// Wine Cell
+ (UIFont *)wineNameFont;
+ (UIFont *)wineDescriptionFont;
+ (UIFont *)winePriceFont;
+ (UIFont *)wineRetailerFont;
+ (UIFont *)wineDistanceFont;
+ (UIFont *)wineUserRatingsFont;
+ (UIFont *)wineExpertLabelFont;
+ (UIFont *)wineExpertValueFont;
+ (UIFont *)wineFriendsReviewsFont;
+ (UIFont *)wineValueFont;

// Me Section
+ (UIFont *)meSecionValueCountFont;
+ (UIFont *)snappedWineInfoFont;

// Wine Details
+ (UIFont *)wineDetailsWineNameFont;

+ (UIFont *)wineDetailsPriceFont;
+ (UIFont *)wineDetailsPriceNotFoundFont;
+ (UIFont *)wineDetailsTitleFont;
+ (UIFont *)wineDetailsFindItTitleFont;
+ (UIFont *)wineDetailsFindItPriceFont;
+ (UIFont *)wineDetailsReportSectionFont;

// Wine Expert Reviews Font
+ (UIFont *)wineExpertReviewPtsFont;
+ (UIFont *)wineExpertReviewExpertNameFont;
+ (UIFont *)wineExpertReviewFont;
+ (UIFont *)wineExpertReviewTimeFont;

// Retailer Details
+ (UIFont *)sectionTitleFont;
+ (UIFont *)friendsLikeCountFont;
+ (UIFont *)storeReviewTitleFont;
+ (UIFont *)storeReviewFont;
+ (UIFont *)storeReviewUserInfo;
+ (UIFont *)storeReivewPostedAtFont;
+ (UIFont *)addWineMsgFont;
+ (UIFont *)addWineBtnFont;

// Review Font
+ (UIFont *)reviewTextFont;

// profile settings
+(UIFont *)profileSettingFont;

// User Cell Font
+ (UIFont *)userCellNameFont;
+ (UIFont *)userCellBioFont;

// Filter View
+ (UIFont *)filterViewStdFilterValueFont;
+ (UIFont *)filterViewPillFilterFont;
+ (UIFont *)filterCountBadgeFont;

#pragma mark - ActionSheet
+ (UIFont *)actionSheetTitleFont;
+ (UIFont *)actionSheetCancelFont;
+ (UIFont *)actionSheetDescriptionFont;

@end
