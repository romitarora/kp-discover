//
//  NSObject+NonNull.m
//  unscrewed
//
//  Created by Robin Garg on 19/01/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "NSObject+NonNull.h"

@implementation NSObject (NonNull)

- (id)nonNull {
    if ([self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return self;
}

@end
