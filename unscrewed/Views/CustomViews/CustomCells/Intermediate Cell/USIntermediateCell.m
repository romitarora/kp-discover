//
//  USIntermediateCell.m
//  unscrewed
//
//  Created by Ray Venenoso on 6/29/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USIntermediateCell.h"

@implementation USIntermediateCell

- (void)awakeFromNib {
    // Initialization code
    self.theLabel.text = @"Success";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillCell:(NSString *)string {
    
}

@end
