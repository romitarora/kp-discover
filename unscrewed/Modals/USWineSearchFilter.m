//
//  USWineSearchFilter.m
//  unscrewed
//
//  Created by Gary Earle on 10/13/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USWineSearchFilter.h"

@interface USWineSearchFilter ()

@end

@implementation USWineSearchFilter

- (instancetype)initWithApiFilterName:(NSString *)apiFilterName
              andFilterAttributeValue:(NSString *)filterAttributeValue
{
  self = [super init];
  if (self)
  {
    _apiFilterName = apiFilterName;
    _filterAttributeValue = filterAttributeValue;
  }

  return self;
}

@end
