//
//  USFindRetailerCell.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 19/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USRetailer;
@protocol USFindRetailerCellDelegate <NSObject>
@optional
- (void)btnBuyOrPickUpFromStore:(NSString *)storeUrl forStore:(NSString *)storeName;
@end

@interface USFindRetailerCell : UITableViewCell {
    
    __weak IBOutlet UILabel *lblRetailerName;
    __weak IBOutlet UILabel *lblAddress;
    __weak IBOutlet UILabel *lblPrice;
    __weak IBOutlet UIButton *btnBuyOrPickUp;
}

@property(nonatomic,weak) id <USFindRetailerCellDelegate> delegate;

- (void)fillRetailerInfo:(USRetailer *)objRetailer;
- (IBAction)btnBuyOrPickUpClicked:(id)sender;

@end
