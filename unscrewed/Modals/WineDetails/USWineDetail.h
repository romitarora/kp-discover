//
//  WineDetail.h
//  unscrewed
//
//  Created by Robin Garg on 16/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USWine.h"
#import "USReviews.h"
#import "USExpertReviews.h"
#import "USUsers.h"

@interface USWineDetail : USWine

@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) BOOL wants;
@property (nonatomic, strong) USReview *myReview;

@property (nonatomic, strong) NSString *wineSubtypeWithVoice;
@property (nonatomic, strong) NSString *wineAboutDescription;
@property (nonatomic, strong) NSString *wineRegionWithSubRegion;

@property (nonatomic, strong) USExpertReviews *objExpertReviews;
@property (nonatomic, strong) USReviews *objUsersReviews;
@property (nonatomic, strong) USReviews *objFriendReviews;

@property (nonatomic, assign) NSInteger friendLikesCount;
@property (nonatomic, strong) NSMutableArray *arrFriendsLikes;

- (id)initWithInfo:(id)info;
- (void)setWineInfo:(id)info;

@end
