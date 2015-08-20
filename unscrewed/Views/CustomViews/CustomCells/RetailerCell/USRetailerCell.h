//
//  RetailerCell.h
//  Unscrewed_iOS_MOCKUP
//
//  Created by Gary Earle on 8/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMStarListView.h"
#import "AsyncImageView.h"

@class USRetailer;
@protocol RetailerStaredDelegate;

@interface USRetailerCell : UITableViewCell

@property (nonatomic, strong) NSString *retailerId;

@property (nonatomic, weak) IBOutlet AsyncImageView *retailerImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;

@property (nonatomic, weak) IBOutlet UIButton *btnStarRetailer;

@property (nonatomic, weak) id<RetailerStaredDelegate> delegate;

- (IBAction)btnStarRetailerEventHandler:(UIButton *)sender;

- (void)fillRetailerInfo:(USRetailer *)retailer isForPlaces:(BOOL)isPlaces;
- (void)updateStarPlaceStatus:(BOOL)favourite;

@end

@protocol RetailerStaredDelegate <NSObject>

@optional
- (void)retailer:(USRetailer *)retailer stared:(BOOL)stared;

@end

