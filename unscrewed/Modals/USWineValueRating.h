//
//  USWineValueRating.h
//  unscrewed
//
//  Created by Gary Kipp Earle on 11/9/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USWineValueRating : NSObject

- (instancetype)initWithWineValueDictionary:(NSDictionary *)wineValueDictionary;

- (NSString *)withRetailerType:(NSString *)retailerType size:(NSString *)size
                         price:(NSInteger)price;

@end
