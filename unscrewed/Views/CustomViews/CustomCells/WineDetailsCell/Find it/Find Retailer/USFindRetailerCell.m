//
//  USFindRetailerCell.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 19/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USFindRetailerCell.h"
#import "USRetailer.h"

@interface USFindRetailerCell ()

@property(nonatomic,strong)NSString *storeUrl;

@end

@implementation USFindRetailerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillRetailerInfo:(USRetailer *)objRetailer {
    
    lblRetailerName.text = objRetailer.name;
    lblAddress.text = objRetailer.address;
    
    /**
     *  Position name label to the center of the cell - VERTICALLY ; if address is not available
     */
    if (lblAddress.text.length == 0) {
        lblRetailerName.frame = CGRectMake(lblRetailerName.frame.origin.x, self.frame.origin.y, lblRetailerName.frame.size.width, self.frame.size.height);
    }
    
    /**
     *  Position Buy button according to the length/width of price label. If its long value
     *  buy button will position itself accordingly.
     */
    CGRect priceRect = lblPrice.frame;
    lblPrice.text = objRetailer.winePrice;
    [lblPrice sizeToFit];
    priceRect.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(lblPrice.frame) - 10;
    priceRect.size.width = CGRectGetWidth(lblPrice.frame);
    [lblPrice setFrame:priceRect];
    
    CGRect buttonRect = btnBuyOrPickUp.frame;
    buttonRect.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(lblPrice.frame) - buttonRect.size.width - 24;
    [btnBuyOrPickUp setFrame:buttonRect];
    
    self.storeUrl = objRetailer.storeUrl;

    if (self.storeUrl) {
        if ([objRetailer.type isEqualToString:@"Online"]) {
            [btnBuyOrPickUp setTitle:@"Buy" forState:UIControlStateNormal];
        } else {
            [btnBuyOrPickUp setTitle:@"Buy/Pickup" forState:UIControlStateNormal];
        }
    } else {
        btnBuyOrPickUp.hidden = YES;
    }
    
    /**
     *  If buy button is hidden, Increase the width of name and address labels to show more content
     */
    if (btnBuyOrPickUp.hidden == YES) {
        lblRetailerName.frame = CGRectMake(CGRectGetMinX(lblRetailerName.frame), CGRectGetMinY(lblRetailerName.frame), CGRectGetWidth(lblRetailerName.frame) + CGRectGetWidth(btnBuyOrPickUp.frame), CGRectGetHeight(lblRetailerName.frame));
        lblAddress.frame = CGRectMake(CGRectGetMinX(lblAddress.frame), CGRectGetMinY(lblAddress.frame), CGRectGetWidth(lblAddress.frame) + CGRectGetWidth(btnBuyOrPickUp.frame), CGRectGetHeight(lblAddress.frame));
    }
}

- (IBAction)btnBuyOrPickUpClicked:(id)sender {
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(btnBuyOrPickUpFromStore:forStore:)]) {
        [[self delegate] btnBuyOrPickUpFromStore:self.storeUrl forStore:lblRetailerName.text];
    }
}

@end
