//
//  HTTPRequestManager.m
//  MyDoc-Patient
//
//  Created by Robin on 7/30/14.
//
//

#import "HTTPRequestManager.h"

static NSString *const AUTH_HEADER_KEY = @"X-AUTH-TOKEN";

@implementation HTTPRequestManager

+ (id)jsonManager {
    return [[self alloc] init];
}

- (id)init {
    self = [self initWithBaseURL:nil];
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];

    return self;
}

+ (id)jsonManagerWithHeaders {
    return [[self alloc] initWithHeaders];
}
 
- (id)initWithHeaders {
    self = [self initWithBaseURL:nil];
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey];
	if (authToken) {
		[self.requestSerializer setValue:authToken forHTTPHeaderField:AUTH_HEADER_KEY];
	}
    return self;
}

@end
