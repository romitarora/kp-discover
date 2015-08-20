//
//  USPillCell.h
//  unscrewed
//
//  Created by Sourabh B. on 13/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USFilterValue;

@protocol USPillCellDelegate <NSObject>

@required

- (void)filterValueSelected:(id)senderCell;

@end


@interface USPillCell : UICollectionViewCell
{
    __weak IBOutlet UIView *viewBorder;
}

@property(nonatomic,weak)id <USPillCellDelegate> delegate;
@property(nonatomic,strong)IBOutlet UIButton *btnTitle;
@property(nonatomic, strong) USFilterValue *filter;

#pragma mark - Fill Title
- (void)fillWithFilter:(USFilterValue *)objFilter selected:(BOOL)selected;

#pragma mark - Show Selection
- (void)showSetSelected:(BOOL)selected;

#pragma mark - Width
+ (CGFloat )widthForTitle:(USFilterValue *)filterValue;

@end
