//
//  USProgressView.h
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 23/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USProgressView : UIView

@property(nonatomic,strong)UILabel *lblRateTitle;
@property(nonatomic,strong)UILabel *lblRateValue;
@property(nonatomic,strong)UIImageView *viewGrayedOut;
@property(nonatomic,strong)UIImageView *viewColored;

- (void)setupProgressWith:(id)obj atIndex:(int)index;

@end
