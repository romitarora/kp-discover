//
//  HTTPRequestManager.h
//  MyDoc-Patient
//
//  Created by Robin on 7/30/14.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface HTTPRequestManager : AFHTTPRequestOperationManager

+ (id)jsonManager;
+ (id)jsonManagerWithHeaders;

@end
