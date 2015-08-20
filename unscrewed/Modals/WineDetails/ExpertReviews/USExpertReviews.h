//
//  ExpertReviews.h
//  unscrewed
//
//  Created by Robin Garg on 23/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USExpertReview.h"

@interface USExpertReviews : NSObject

@property (nonatomic, strong) NSMutableArray *arrExpertReviews;

- (id)initWithExpertReviews:(NSArray *)expertReviwes;

@end
