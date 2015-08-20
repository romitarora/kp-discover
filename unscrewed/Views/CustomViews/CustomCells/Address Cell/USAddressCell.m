//
//  USAddressCell.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 05/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USAddressCell.h"
#import "USRetailerDetails.h"

@implementation USAddressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Fill Info
- (void)fillAddressInfo:(USRetailerDetails *)retailer forIndex:(NSInteger)index {
    switch (index) {
        case 6:
            lblTitle.text = @"Phone";
            lblValue.text = @"310-293-2010";
            btnGetDirections.hidden = YES;
            break;
        case 7:
            lblTitle.text = @"Website";
            lblValue.text = @"www.traderjoes.com";
            btnGetDirections.hidden = YES;
            break;
        default:
            lblTitle.text = @"Address";
            lblValue.text = retailer.completeAddress;
            btnGetDirections.hidden = NO;
            break;
    }
    [lblValue sizeToFit];
    
    CGRect rect = self.frame;
    if (btnGetDirections.hidden) {
        rect.size.height = 64;
    } else {
        rect.size.height = [USAddressCell heightForCell:retailer];
        CGRect rectButtonGetDirections = btnGetDirections.frame;
        rectButtonGetDirections.origin.y = CGRectGetMinY(lblValue.frame) + CGRectGetHeight(lblValue.frame) + 3;
        btnGetDirections.frame = rectButtonGetDirections;
    }
    [self setFrame:rect];
}


#pragma mark - Get Directions Action
- (IBAction)btnGetDirectionsClicked:(id)sender {
    if ([self delegate] && [self.delegate respondsToSelector:@selector(showDirections)]) {
        [[self delegate] showDirections];
    }
}

#pragma mark - Cell Height
+ (CGFloat)heightForCell:(USRetailerDetails *)objRetailerInfo {
    float heightAboveAddress = 38.f;
    float heightBelowAddress = 47.f;

    CGRect rect = [objRetailerInfo.completeAddress boundingRectWithSize:CGSizeMake(290, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[USFont defaultLinkButtonFont]} context:nil];
    CGFloat bubbleHeight = ceil(CGRectGetHeight(rect)) + ceil(heightAboveAddress) + ceil(heightBelowAddress);
    return bubbleHeight;
}

@end
