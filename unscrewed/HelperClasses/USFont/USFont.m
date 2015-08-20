//
//  USFont.m
//  unscrewed
//
//  Created by Robin Garg on 14/01/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USFont.h"

static NSString * const kHelveticaNeue = @"HelveticaNeue";
static NSString * const kHelveticaNeueBold =  @"HelveticaNeue-Bold";
static NSString * const kHelveticaNeueMedium = @"HelveticaNeue-Medium";
static NSString * const kHelveticaNeueLight = @"HelveticaNeue-Light";

@implementation USFont

#pragma mark - App Level Font
+ (UIFont *)defaultButtonFont {
    return [UIFont fontWithName:kHelveticaNeue size:16.f];
}
+ (UIFont *)defaultLinkButtonFont {
    return [UIFont fontWithName:kHelveticaNeue size:15.f];
}

+ (UIFont *)tableHeaderFont {
    return [UIFont fontWithName:kHelveticaNeueMedium size:20.f];
}

+ (UIFont *)defaultTextFont {
    return [UIFont fontWithName:kHelveticaNeue size:17.f];
}

+ (UIFont *)defaultTableCellTextFont {
    return [UIFont fontWithName:kHelveticaNeue size:16.f];
}

+ (UIFont *)kerningTitleViewFont {
	return [UIFont fontWithName:kHelveticaNeueBold	size:30.f];
}

#pragma mark - Welcome/Intro View
+ (UIFont *)unscrewedFont {
    return [UIFont fontWithName:kHelveticaNeueBold size:54.f];
}
+ (UIFont *)winesFont {
    return [UIFont fontWithName:kHelveticaNeueLight size:17.f];
}
+ (UIFont *)unscrewedMsgFont{
    return [UIFont fontWithName:kHelveticaNeueBold size:22.f];
}
+ (UIFont *)facebookMsgFont{
    return [UIFont fontWithName:kHelveticaNeueLight size:13.f];
}

#pragma mark - Sign Up View
+ (UIFont *)termsAndCondFont {
    return [UIFont fontWithName:kHelveticaNeueLight size:12.f];
}

#pragma mark - Sign In View
+ (UIFont *)signInHeaderFont {
    return [UIFont fontWithName:kHelveticaNeueMedium size:20.f];
}

#pragma mark - Hello View
+ (UIFont *)helloNameFont {
    return [UIFont fontWithName:kHelveticaNeue size:19.f];
}
+ (UIFont *)helloMsgFont {
    return [UIFont fontWithName:kHelveticaNeue size:16.f];
}

+ (UIFont *)gotitMsgFont {
    return [UIFont fontWithName:kHelveticaNeue size:15.f];
}

#pragma mark - Table Header Message on Places & Invite Friends
+ (UIFont *)tableHeaderTitleFont {
    return [UIFont fontWithName:kHelveticaNeueMedium size:16.f];
}
+ (UIFont *)tableHeaderMessageFont {
    return [UIFont fontWithName:kHelveticaNeue size:13.f];
}

#pragma mark - Places Cell Font
+ (UIFont *)placeNameFont {
    return [UIFont fontWithName:kHelveticaNeueMedium size:15.f];
}
+ (UIFont *)placeAddressFont {
    return [UIFont fontWithName:kHelveticaNeue size:14.f];
}

#pragma mark - Settings Screen
+ (UIFont *)logoutButtonFont {
	return [UIFont fontWithName:kHelveticaNeueMedium size:16.f];
}

#pragma mark - Blogs View
+ (UIFont *)blogUserNameFont {
	return [UIFont fontWithName:kHelveticaNeueBold size:14.f];
}
+ (UIFont *)blogPostedTimeFont {
	return [UIFont fontWithName:kHelveticaNeue size:14.f];
}
+ (UIFont *)blogTitleFont {
	return [UIFont fontWithName:kHelveticaNeueBold size:15.f];
}
+ (UIFont *)blogSubtitleFont {
	return [UIFont fontWithName:kHelveticaNeue size:14.f];
}
+ (UIFont *)blogDescriptionFont {
	return [UIFont fontWithName:kHelveticaNeue size:14.f];
}

#pragma mark - Wine Cell
+ (UIFont *)wineNameFont {
	return [UIFont fontWithName:kHelveticaNeueBold size:13.f];
}
+ (UIFont *)wineDescriptionFont {
	return [UIFont fontWithName:kHelveticaNeue size:12.f];
}
+ (UIFont *)winePriceFont {
	return [UIFont fontWithName:kHelveticaNeueBold size:13.f];
}
+ (UIFont *)wineRetailerFont {
	return [UIFont fontWithName:kHelveticaNeueBold size:13.f];
}
+ (UIFont *)wineDistanceFont {
	return [UIFont fontWithName:kHelveticaNeueLight size:13.f];
}
+ (UIFont *)wineUserRatingsFont {
	return [UIFont fontWithName:kHelveticaNeue size:11.f];
}
+ (UIFont *)wineExpertLabelFont {
	return [UIFont fontWithName:kHelveticaNeue size:12.f];
}
+ (UIFont *)wineExpertValueFont {
	return [UIFont fontWithName:kHelveticaNeueBold size:12.f];
}
+ (UIFont *)wineFriendsReviewsFont {
	return [UIFont fontWithName:kHelveticaNeue size:11.f];
}
+ (UIFont *)wineValueFont {
	return [UIFont fontWithName:kHelveticaNeueBold size:12.f];
}

#pragma mark - Me Section
+ (UIFont *)meSecionValueCountFont {
	return [UIFont fontWithName:kHelveticaNeueLight	size:14.f];
}
+ (UIFont *)snappedWineInfoFont {
	return [UIFont fontWithName:kHelveticaNeue size:14.f];
}

#pragma mark - Wine Details
+ (UIFont *)wineDetailsWineNameFont {
	return [UIFont fontWithName:kHelveticaNeueMedium size:18.f];
}
+ (UIFont *)wineDetailsPriceFont {
	return [UIFont fontWithName:kHelveticaNeueBold size:15.f];
}
+ (UIFont *)wineDetailsPriceNotFoundFont {
	return [UIFont fontWithName:kHelveticaNeueLight size:15.f];
}
+ (UIFont *)wineDetailsTitleFont {
	return [UIFont fontWithName:kHelveticaNeueLight size:14.f];
}
+ (UIFont *)wineDetailsReportSectionFont {
	return [UIFont fontWithName:kHelveticaNeueMedium size:15.f];
}
+ (UIFont *)wineDetailsFindItTitleFont {
    return [UIFont fontWithName:kHelveticaNeueBold size:11.f];
}
+ (UIFont *)wineDetailsFindItPriceFont {
	return [UIFont fontWithName:kHelveticaNeueMedium size:15.f];
}

#pragma mark - Wine Expert Reviews Font
+ (UIFont *)wineExpertReviewPtsFont {
	return [UIFont fontWithName:kHelveticaNeue size:14.f];
}
+ (UIFont *)wineExpertReviewExpertNameFont {
	return [UIFont fontWithName:kHelveticaNeueLight size:14.f];
}
+ (UIFont *)wineExpertReviewFont {
	return [UIFont fontWithName:kHelveticaNeue size:14.f];
}
+ (UIFont *)wineExpertReviewTimeFont{
	return [UIFont fontWithName:kHelveticaNeueLight size:12.f];
}

#pragma mark - Retailer Details
+ (UIFont *)sectionTitleFont {
	return [UIFont fontWithName:kHelveticaNeueBold size:11.f];
}
+ (UIFont *)friendsLikeCountFont {
	return [UIFont fontWithName:kHelveticaNeue size:14.f];
}
+ (UIFont *)storeReviewTitleFont {
	return [UIFont fontWithName:kHelveticaNeueBold size:14.f];
}
+ (UIFont *)storeReviewFont {
	return [UIFont fontWithName:kHelveticaNeue size:14.f];
}
+ (UIFont *)storeReviewUserInfo {
	return [UIFont fontWithName:kHelveticaNeueBold size:12.f];
}
+ (UIFont *)storeReivewPostedAtFont {
	return [UIFont fontWithName:kHelveticaNeue size:12.f];
}
+ (UIFont *)addWineMsgFont {
	return [UIFont fontWithName:kHelveticaNeue size:14.f];
}
+ (UIFont *)addWineBtnFont {
	return [UIFont fontWithName:kHelveticaNeueMedium size:13.f];
}

+ (UIFont *)reviewTextFont {
	return [UIFont fontWithName:kHelveticaNeue size:18.f];
}

+(UIFont *)profileSettingFont {
    return [UIFont fontWithName:kHelveticaNeue size:13.f];
}

#pragma mark - User Cell Font
+ (UIFont *)userCellNameFont {
	return [UIFont fontWithName:kHelveticaNeueMedium size:14.f];
}
+ (UIFont *)userCellBioFont {
	return [UIFont fontWithName:kHelveticaNeue size:14.f];
}

#pragma mark - Filter View
+ (UIFont *)filterViewStdFilterValueFont {
	return [UIFont fontWithName:kHelveticaNeue size:15.f];
}
+ (UIFont *)filterViewPillFilterFont {
	return [UIFont fontWithName:kHelveticaNeue size:14.f];
}
+ (UIFont *)filterCountBadgeFont {
	return [UIFont fontWithName:kHelveticaNeue size:11.f];
}


#pragma mark - ActionSheet
+ (UIFont *)actionSheetTitleFont {
    return [UIFont fontWithName:kHelveticaNeue size:15.f];
}

+ (UIFont *)actionSheetCancelFont {
    return [UIFont fontWithName:kHelveticaNeue size:22.f];
}

+ (UIFont *)actionSheetDescriptionFont {
    return [UIFont fontWithName:kHelveticaNeue size:45.f];
}

@end
