//
//  USDefines.h
//  unscrewed
//
//  Created by Robin Garg on 14/01/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#ifndef unscrewed_USDefines_h
#define unscrewed_USDefines_h

#import "Logging.h"
#import "URLs.h"
#import "USColor.h"
#import "USFont.h"
#import "NSString+Utilities.h"
#import "NSObject+NonNull.h"

#define IS_IPHONE_4 ([[UIScreen mainScreen] bounds ].size.height == 480)
#define IS_IPHONE_5_OR_GREATER ([[UIScreen mainScreen] bounds].size.height > 480)
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kTabbarHeight 49
#define kTransparentAreaWidth 30
#define MaxWidthForFilterCell 120

#define kNeglegibleHeight 0.0000001

#define UIControlStateAll UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted

#define kNumberOfContactsKey @"NUMBER_OF_CONTACTS"

#define NUMERIC_PAD @"1234567890"
#define NUMERIC_AND_PUNCTUATION @"1234567890."

#define iTunesAppId @"969064066"
#define kiTunesAppUrl @"http://itunes.apple.com/app/id"iTunesAppId

#define ALGOLIA_APPLICATION_ID @"8X1R8NF9E6"
#define ALGOLIA_API_KEY @"291a578e8c9fc499d28684abad9d5618"

// Email
#define kEmailSubjectTitle @"Join Me on Uncscrewed"
#define kEmailAccountNotSetupMessage @"Email account not setup in device settings application."
#define kEmailMessageCopy @"%@ has invited you to join Unscrewed! Unscrewed is an iPhone app that helps you find the best wines at places like Trader Joes, Whole Foods, Ralphs and Costco. You can also see what %@ and other friends like (or don't like!).\nClick here to download the app and join %@ %@"

// Message
#define kMessageFunctionalityNotAvailable @"Message Functionality not available in this device."
#define kTextMessageCopy @"%@ invited you to join Unscrewed, an iPhone app that helps you find the best wines at places like Trader Joes, Whole Foods, Costco, etc. Click here to join %@ %@"


// String Constants
#define kSuccess @"Success!"
#define kInvalidValue @"Invalid Value"
#define kAlert @"Alert!"
#define kError @"Error!"
#define kFailure @"Failure!"
#define kServerError @"Server Error!"
#define kServerErrorMsg @"Oops! Something went wrong please try again later."
#define kInternetNotAvilableErrorMsg @"You are not connected with WiFi or Mobile Internet."

#define kSpaceString @" "
#define kEmptyString @""
#define kDashString @"--"

#define kOk @"OK"
#define kCancel @"Cancel"

#define kWinesSortTypeKey @"WinesSortType"
#define kWinesDistanceKey @"WineDistanceFilter"

// My Wine Filter
#define kMyWinesFilterLikeTitle @"Like"
#define kMyWinesFilterLikeValue @"likes"
#define kMyWinesFilterWantTitle @"Save"
#define kMyWinesFilterWantValue @"wants"
#define kMyWinesFilterRateTitle @"Rated"
#define kMyWinesFilterRateValue @"rated"

#define kMyWinesFilterSortTitle @"Sort By"


// Key Constants
#define kIsUserLoggedInKey @"isUserLoggedIn"
#define kTitleKey @"title"
#define kImageNameKey @"imageName"

#define kMyWinesFilterTitleKey @"MyWineFilterTitle"
#define kMyWinesFilterValueKey @"MyWineFilterValue"
#define kMyWinesFilterSortTypeKey @"MyWineSortType"

#endif
