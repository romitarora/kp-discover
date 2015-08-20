//
//  USContacts.h
//  Unscrewed
//
//  Created by Robin on 9/19/14.
//  Copyright (c) 2014 AddVal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USContact.h"

@interface USContacts : NSObject

@property (nonatomic, strong) NSMutableArray *arrContacts;

+ (id)sharedObject;

- (void)loadDeviceContacts:(void (^)(NSError *error))callbackBlock isForInvite:(BOOL)forInvite;

@end
