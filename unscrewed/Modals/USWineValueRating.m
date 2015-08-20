//
//  USWineValueRating.m
//  unscrewed
//
//  Created by Gary Kipp Earle on 11/9/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USWineValueRating.h"

@interface USWineValueRating ()

@property (nonatomic, strong) NSDictionary *wineValueDictionary;

@end

@implementation USWineValueRating

- (instancetype)initWithWineValueDictionary:(NSDictionary *)wineValueDictionary
{
  self = [self init];
  if (self) {
    _wineValueDictionary = wineValueDictionary;
  }

  return self;
}

- (NSString *)withRetailerType:(NSString *)retailerType size:(NSString *)size price:(NSInteger)price {
  NSArray *good = [[[_wineValueDictionary objectForKey:retailerType] objectForKey:size] objectForKey:@"good"];
  NSArray *excellent = [[[_wineValueDictionary objectForKey:retailerType] objectForKey:size] objectForKey:@"excellent"];
  NSArray *incredible = [[[_wineValueDictionary objectForKey:retailerType] objectForKey:size] objectForKey:@"incredible"];
	
	NSInteger goodLow = [[good objectAtIndex:0] integerValue]/100;
	NSInteger goodHigh = [[good objectAtIndex:1] integerValue]/100;

	NSInteger excellentLow = [[excellent objectAtIndex:0] integerValue]/100;
	NSInteger excellentHigh = [[excellent objectAtIndex:1] integerValue]/100;

	NSInteger incredibleLow = [[incredible objectAtIndex:0] integerValue]/100;
	NSInteger incredibleHigh = [[incredible objectAtIndex:1] integerValue]/100;


  if ((long)price >= goodLow && (long)price < goodHigh) {
    return @"good";
  } else if ((long)price >= excellentLow &&
             (long)price <= excellentHigh) {
    return @"excellent";
  } else if ((long)price >= incredibleLow &&
             (long)price <= incredibleHigh) {
    return @"incredible";
  } else {
    return kEmptyString;
  }
}

@end

// "wine_value": {
//    "Store": {
//        "750ml": {
//            "good": [
//                     2401,
//                     3000
//                     ],
//            "excellent": [
//                          1921,
//                          2400
//                          ],
//            "incredible": [
//                           0,
//                           1920
//                           ]
//        },
//        "glass": {
//            "good": [
//                     1801,
//                     2250
//                     ],
//            "excellent": [
//                          1441,
//                          1800
//                          ],
//            "incredible": [
//                           0,
//                           1440
//                           ]
//        }
//    },
//    "Restaurant": {
//        "750ml": {
//            "good": [
//                     6001,
//                     7500
//                     ],
//            "excellent": [
//                          4801,
//                          6000
//                          ],
//            "incredible": [
//                           0,
//                           4800
//                           ]
//        },
//        "glass": {
//            "good": [
//                     1801,
//                     2250
//                     ],
//            "excellent": [
//                          1441,
//                          1800
//                          ],
//            "incredible": [
//                           0,
//                           1440
//                           ]
//        }
//    },
//    "Online": {
//        "750ml": {
//            "good": [
//                     2401,
//                     3000
//                     ],
//            "excellent": [
//                          1921,
//                          2400
//                          ],
//            "incredible": [
//                           0,
//                           1920
//                           ]
//        },
//        "glass": {
//            "good": [
//                     1801,
//                     2250
//                     ],
//            "excellent": [
//                          1441,
//                          1800
//                          ],
//            "incredible": [
//                           0,
//                           1440
//                           ]
//        }
//    }
// }