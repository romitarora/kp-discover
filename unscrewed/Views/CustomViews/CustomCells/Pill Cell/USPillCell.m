//
//  USPillCell.m
//  unscrewed
//
//  Created by Sourabh B. on 13/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USPillCell.h"
#import "USFilterValue.h"

#define LeftRightPadding 17.f

@interface USPillCell ()

- (IBAction)btnTitleSelected:(id)sender;

@end

@implementation USPillCell

- (void)awakeFromNib {
    // Initialization code
    viewBorder.layer.borderColor = [UIColor lightGrayColor].CGColor;
    viewBorder.layer.borderWidth = 1;
	
	[self.btnTitle.titleLabel setFont:[USFont filterViewPillFilterFont]];
}

- (void)fillWithFilter:(USFilterValue *)objFilter selected:(BOOL)selected {
    self.backgroundColor = [UIColor clearColor];
    if (objFilter) {
        self.filter = objFilter;
        [self.btnTitle setTitle:objFilter.filterValue forState:UIControlStateNormal];
		[self showSetSelected:selected];
        
        CGRect titleRect = CGRectZero;
        titleRect.size.width = [USPillCell widthForTitle:objFilter];
        [self arrangeFramesWithRect:titleRect];
    }
}

- (void)arrangeFramesWithRect:(CGRect)newRect {
    CGRect rectBorderView = viewBorder.frame;
    rectBorderView.size.width = newRect.size.width;
    viewBorder.frame = rectBorderView;

    CGRect rectTitleButton = CGRectInset(rectBorderView, 0, 0);
    self.btnTitle.frame = rectTitleButton;
    
    viewBorder.layer.masksToBounds = YES;
    self.btnTitle.layer.masksToBounds = YES;
}

- (IBAction)btnTitleSelected:(id)sender {
    [self showSetSelected:YES];
    
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(filterValueSelected:)]) {
        [[self delegate] filterValueSelected:self];
    }
}

#pragma mark - Show Selection
- (void)showSetSelected:(BOOL)selected {
    if (selected) {
        [self.btnTitle setBackgroundColor:[USColor themeSelectedColor]];
        [self.btnTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        viewBorder.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        [self.btnTitle setBackgroundColor:[UIColor clearColor]];
        [self.btnTitle setTitleColor:[USColor filterViewGrayColor] forState:UIControlStateNormal];
        
        viewBorder.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}

#pragma mark - Width
+ (CGFloat )widthForTitle:(USFilterValue *)objFilter {
    if (objFilter) {
        CGRect rect = [objFilter.filterValue boundingRectWithSize:CGSizeMake(MaxWidthForFilterCell, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[USFont filterViewPillFilterFont]} context:nil];
        CGFloat calculatedWidth = ceil(CGRectGetWidth(rect));
        CGFloat totalWidth = (calculatedWidth > MaxWidthForFilterCell ? MaxWidthForFilterCell : calculatedWidth);
        CGFloat finalWidth = totalWidth + LeftRightPadding;
        LogInfo(@"width for '%@' = %f",objFilter.filterValue, ceil(finalWidth));
        return ceil(finalWidth);
    } else {
        LogInfo(@"Title is nil");
        return 0.f;
    }

}

@end
