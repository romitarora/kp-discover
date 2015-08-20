//
//  USArticleCell.h
//  unscrewed
//
//  Created by Mario Danic on 28/11/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"

@class OBGradientView;
@class USPost;

@interface USArticleCell : UITableViewCell

@property (nonatomic, retain) IBOutlet OBGradientView *gradientView;
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (strong, nonatomic) IBOutlet UIButton *btnReadit;
@property (strong, nonatomic) IBOutlet UIButton *btnFindthewine;
@property (strong, nonatomic) IBOutlet UIButton *btnFindthewineIcon;

- (void)fillPostInfo:(USPost *)objPost;

+ (CGFloat)cellHeightForPost:(USPost *)objPost;

@end
