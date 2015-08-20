//
//  SearchOperation.h
//  unscrewed
//
//  Created by Robin Garg on 10/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SearchFor) {
	SearchForWines,
	SearchForPlaces,
	SearchForFriends
};

@protocol USSearchOperationCompletionDelegate;

@interface USSearchOperation : NSOperation

@property (nonatomic, weak) id<USSearchOperationCompletionDelegate> delegate;

- (id)initWithParams:(NSDictionary *)param
		   searchFor:(SearchFor)searchFor
			delegate:(id<USSearchOperationCompletionDelegate>)delegate;

@end

@protocol USSearchOperationCompletionDelegate <NSObject>

@required
- (void)searchOperationCompletedWithObject:(id)object;
@optional
- (void)searchOperationFailed;

@end
