//
//  USWineSearchFilter.h
//  unscrewed
//
//  Created by Gary Earle on 10/13/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USWineSearchFilter : NSObject

- (instancetype)initWithApiFilterName:(NSString *)apiFilterName
              andFilterAttributeValue:(NSString *)filterAttributeValue;

@property (readonly, nonatomic, strong) NSString *apiFilterName;
@property (readonly, nonatomic, strong) NSString *filterAttributeValue;

@end
