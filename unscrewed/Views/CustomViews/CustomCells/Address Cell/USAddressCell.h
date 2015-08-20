//
//  USAddressCell.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 05/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol USAddressCellDelegate <NSObject>
@optional
- (void)showDirections;
@end

@class USRetailerDetails;
@interface USAddressCell : UITableViewCell
{
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet UILabel *lblValue;
    __weak IBOutlet UIButton *btnGetDirections;
}

@property(nonatomic,weak)id <USAddressCellDelegate> delegate;

#pragma mark - Fill Info
- (void)fillAddressInfo:(USRetailerDetails *)retailer forIndex:(NSInteger)index;

#pragma mark - Height
+ (CGFloat)heightForCell:(USRetailerDetails *)obj;

-(IBAction)btnGetDirectionsClicked:(id)sender;


@end
