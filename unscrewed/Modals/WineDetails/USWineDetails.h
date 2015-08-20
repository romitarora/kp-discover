//
//  USWineDetails.h
//  unscrewed
//
//  Created by Robin Garg on 16/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USWineDetail.h"

@interface USWineDetails : NSObject

@property (nonatomic, strong) USWineDetail *objWineDetail;

- (void)getWineDetailsForWineId:(NSString *)wineId target:(id)target completion:(SEL)completion failure:(SEL)failure;

@end
