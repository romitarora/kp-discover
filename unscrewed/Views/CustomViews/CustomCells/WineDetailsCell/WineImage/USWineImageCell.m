//
//  WineImageCell.m
//  unscrewed
//
//  Created by Robin Garg on 16/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USWineImageCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NSString+Utilities.h"
#import "DYRateView.h"
#import "USWineDetail.h"
#import "AsyncImageView.h"

@interface USWineImageCell ()<DYRateViewDelegate>

@property (nonatomic, strong) USWineDetail *objWineDetails;

@property (nonatomic, strong) IBOutlet UIButton *btnLike;
@property (nonatomic, strong) IBOutlet UIButton *btnWant;

@property (nonatomic, strong) IBOutlet AsyncImageView *imgViewWine;

@property (nonatomic, strong) IBOutlet UILabel *lblWineName;

// Price Values
@property (nonatomic, strong) IBOutlet UILabel *lblAvgPrice;
@property (nonatomic, strong) IBOutlet UILabel *lblAvgTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblOnlinePrice;
@property (nonatomic, strong) IBOutlet UILabel *lblOnlineTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblNearbyPrice;
@property (nonatomic, strong) IBOutlet UILabel *lblNearbyTitle;
@property (nonatomic, strong) IBOutlet UIButton *btnOnline;
@property (nonatomic, strong) IBOutlet UIButton *btnNearby;
@property (nonatomic, strong) IBOutlet UIButton *btnFindIt;

- (IBAction)imageAndPriceCellEventHandler:(UIButton *)sender;

@end

@implementation USWineImageCell

- (void)awakeFromNib {
    // Initialization code
	[self.lblWineName setBackgroundColor:[UIColor clearColor]];
	[self.lblWineName setFont:[USFont tableHeaderTitleFont]];
	[self.imgViewWine setClipsToBounds:YES];
       
	[self.btnWant.layer setCornerRadius:CGRectGetHeight(self.btnWant.frame)*0.5];
    [self.btnWant.layer setBorderWidth:1];//[UIScreen mainScreen].scale*0.5f];
	[self.btnWant setTitle:@"Save" forState:UIControlStateNormal];
	[self.btnWant setTitle:@"Save" forState:UIControlStateSelected];
	[self.btnWant setTitleColor:[USColor colorFromHexString:@"#A7A7A7"] forState:UIControlStateNormal];
    [self.btnWant setBackgroundColor:[UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1] /*#f8f8f8*/];
    [self.btnWant.layer setBorderColor:[USColor colorFromHexString:@"#A7A7A7"].CGColor];
	[self.btnWant setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    UIEdgeInsets edgeInsets = self.btnWant.contentEdgeInsets;
    edgeInsets.bottom = 2;
    [self.btnWant setContentEdgeInsets:edgeInsets];
    [self.btnWant setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal] ;
    
	
	if (![self.contentView viewWithTag:1001]) {
		DYRateView *rateView =
		[[DYRateView alloc] initWithFrame:CGRectMake(143, 15, 162, 30)
								 fullStar:[UIImage imageNamed:@"wineDetailsSelectedStar"]
								emptyStar:[UIImage imageNamed:@"wineDetailsGrayStrokeStar"]];
		[rateView setTag:1001];
		[rateView setPadding:3.f];
		[rateView setEditable:YES];
		[rateView setDelegate:self];
		[self.contentView addSubview:rateView];
	}
	
	[self.lblAvgPrice setFont:[USFont wineDetailsPriceFont]];
	[self.lblOnlinePrice setFont:[USFont wineDetailsPriceFont]];
	[self.lblNearbyPrice setFont:[USFont wineDetailsPriceFont]];
	
	[self.lblAvgTitle setFont:[USFont wineDetailsTitleFont]];
	[self.lblOnlineTitle setFont:[USFont wineDetailsTitleFont]];
	[self.lblNearbyTitle setFont:[USFont wineDetailsTitleFont]];
	
	[self.btnFindIt.titleLabel setFont:[USFont defaultLinkButtonFont]];
	
	[self.lblAvgPrice setTextColor:[UIColor blackColor]];
	[self.lblOnlinePrice setTextColor:[USColor themeSelectedColor]];
	[self.lblNearbyPrice setTextColor:[USColor themeSelectedColor]];
	
	[self.lblAvgTitle setTextColor:[USColor wineDetailsPriceTitleColor]];
	[self.lblOnlineTitle setTextColor:[USColor wineDetailsPriceTitleColor]];
	[self.lblNearbyTitle setTextColor:[USColor wineDetailsPriceTitleColor]];
	[self.btnFindIt setTitleColor:[USColor themeSelectedColor] forState:UIControlStateNormal];
	
	[self.lblAvgTitle setText:@"Average"];
	[self.lblOnlineTitle setText:@"Online"];
	[self.lblNearbyTitle setText:@"Nearby"];
	[self.btnFindIt setImage:[UIImage imageNamed:@"findItIcon"] forState:UIControlStateNormal];
	[self.btnFindIt setTitle:@"Find It" forState:UIControlStateNormal];
    
    [self setGradient];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapOnImage)];
    [self.gradientView addGestureRecognizer:singleTap];
}

- (void)setGradient {
    //NSArray *colors = [NSArray arrayWithObjects:[UIColor colorWithWhite:0.0/255.0 alpha:.7f], [UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor colorWithWhite:0.0/255.0 alpha:.7f], nil];
    NSArray *colors = [NSArray arrayWithObjects:[UIColor colorWithWhite:0.0/255.0 alpha:.7f], [UIColor colorWithWhite:0.0/255.0 alpha:.3f], [UIColor colorWithWhite:0.0/255.0 alpha:.0f],[UIColor colorWithWhite:0.0/255.0 alpha:.0f], [UIColor colorWithWhite:0.0/255.0 alpha:.0f],[UIColor colorWithWhite:0.0/255.0 alpha:.3f],[UIColor colorWithWhite:0.0/255.0 alpha:.7f], nil];
    self.gradientView.colors = colors;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWineLikeStatusTo:(BOOL)liked {
	[self.btnLike setSelected:liked];
}

- (void)updateWineWantStatusTo:(BOOL)wants {
	[self.btnWant setSelected:wants];
	if (wants) {
		[self.btnWant.layer setBorderColor:[USColor themeSelectedColor].CGColor];
		[self.btnWant setBackgroundColor:[USColor themeSelectedColor]];
		
	} else {
        [self.btnWant.layer setBorderColor:[UIColor colorWithRed:0.714 green:0.714 blue:0.714 alpha:1] /*#b6b6b6*/.CGColor];//[UIColor colorWithWhite:(182.f/255.f) alpha:1.f].CGColor];
		[self.btnWant setBackgroundColor:[UIColor clearColor]];
	}
}

- (void)updateFormattingOfAvgPriceLabel:(UILabel *)label {
    if ([label.text isEqualToString:kDashString]) {
        [label setFont:[USFont wineDetailsPriceNotFoundFont]];
        [label setTextColor:[USColor wineDetailsPriceNotFoundColor]];
    } else {
        [label setFont:[USFont wineDetailsPriceFont]];
        [label setTextColor:[UIColor blackColor]];
    }
}
- (void)updateFormattingOfPriceLabel:(UILabel *)label {
	if ([label.text isEqualToString:kDashString]) {
		[label setFont:[USFont wineDetailsPriceNotFoundFont]];
		[label setTextColor:[USColor wineDetailsPriceNotFoundColor]];
	} else {
		[label setFont:[USFont wineDetailsPriceFont]];
		[label setTextColor:[USColor themeSelectedColor]];
	}
}

- (void)fillWineImageInfo:(USWineDetail *)info indexPath:(NSIndexPath *)indexPath {
	self.objWineDetails = info;
	[self.imgViewWine setImage:nil];
    
	if (info.wineImageUrl) {
		[self.imgViewWine getImageFromURL:info.wineImageUrl placeholderImage:nil scaling:3];
	}
    
	[self.lblWineName setText:info.name];
	CGRect rect = self.lblWineName.frame;
	CGRect textRect = [info.name rectWithSize:CGSizeMake(CGRectGetWidth(self.lblWineName.frame), CGFLOAT_MAX)
								  font:self.lblWineName.font];
	CGFloat labelHeight = ceilf(CGRectGetHeight(textRect));
	CGFloat maxLineHeight = ceilf(self.lblWineName.font.lineHeight) * 2;
	rect.size.height = MIN(labelHeight, maxLineHeight);
	rect.origin.y = CGRectGetHeight(self.imgViewWine.frame) - CGRectGetHeight(rect) - 13.f/*Padding*/;
	self.lblWineName.frame = rect;
	
	DYRateView *rateView = (DYRateView *)[self.contentView viewWithTag:1001];
	if (rateView) {
        self.isSettingInitialRating = YES;
		rateView.rate = floorf(info.myReview.reviewRatingCount);
        self.isSettingInitialRating = NO;
	}
    
	
	[self updateWineLikeStatusTo:info.liked];
	[self updateWineWantStatusTo:info.wants];
	
    [self.lblAvgPrice setText:(info.averagePrice.integerValue>0 ? [NSString stringWithFormat:@"$%@",info.averagePrice] : kDashString)];
	[self updateFormattingOfAvgPriceLabel:self.lblAvgPrice];
    [self.lblOnlinePrice setText:(info.onlineAveragePrice.integerValue>0 ? [NSString stringWithFormat:@"$%@",info.onlineAveragePrice] : kDashString)];
	[self updateFormattingOfPriceLabel:self.lblOnlinePrice];
    [self.lblNearbyPrice setText:(info.minPrice.integerValue>0 ? [NSString stringWithFormat:@"$%@",info.minPrice] : kDashString)];
	[self updateFormattingOfPriceLabel:self.lblNearbyPrice];
}

- (IBAction)imageAndPriceCellEventHandler:(UIButton *)sender {
	if ([sender isEqual:self.btnLike]) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(likeWineSelectedOnImageCell)]) {
			[self.delegate likeWineSelectedOnImageCell];
		}
	} else if ([sender isEqual:self.btnWant]) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(wantWineSelectedOnImageCell)]) {
			[self.delegate wantWineSelectedOnImageCell];
		}
	} else if ([sender isEqual:self.btnFindIt]) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(findItOptionSelectedOnImageCell)]) {
			[self.delegate findItOptionSelectedOnImageCell];
		}
    } else if ([sender isEqual:self.btnOnline]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onlineOptionSelectedOnImageCell)]) {
            [self.delegate onlineOptionSelectedOnImageCell];
        }
    } else if ([sender isEqual:self.btnNearby]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(nearbyOptionSelectedOnImageCell)]) {
            [self.delegate nearbyOptionSelectedOnImageCell];
        }
    }
}

- (void)handleSingleTapOnImage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(wineImageSelected:)]) {
        [self.delegate wineImageSelected:self.imgViewWine.image];
    }
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark DYRate View Delegate
- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate {
	if (self.isSettingInitialRating == NO) {
		NSString *shown = [[NSUserDefaults standardUserDefaults] objectForKey:@"ratings_ins_shown"];
		if([shown isEqual:@"YES"]){
			if (self.delegate && [self.delegate respondsToSelector:@selector(rateWineChangedOnImageCellToNewRate:)]) {
				[self.delegate rateWineChangedOnImageCellToNewRate:(floorf(rate.floatValue) == floorf(self.objWineDetails.myReview.reviewRatingCount) ? @0 : rate)];
			}
		} else {
			self.objWineDetails.myReview.reviewRatingCount = [rate integerValue];
			[self showRatingsInstructions];
			[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"ratings_ins_shown"];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}
}

#pragma mark - Show Ratings Instructions
-(void)showRatingsInstructions{
    UITableView *tv = (UITableView *) self.superview.superview;
    UITableViewController *vc = (UITableViewController *) tv.dataSource;
    
    UIView *insView = [[UIView alloc] init];
    insView.frame = CGRectMake(0, vc.tableView.contentOffset.y, kScreenWidth, kScreenHeight);
    
    
    //GRAY TRANSPARENT BUTTON
    UIButton *closeBtn1 = [[UIButton alloc]init];
    closeBtn1.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    closeBtn1.alpha = 0.8;
    [closeBtn1 setBackgroundColor:[UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1] /*#383838*/];
    [insView addSubview:closeBtn1];
    
    //WHITE ROUNDED CORNER VIEW
    UIView *whiteView = [[UIView alloc] init];
    whiteView.frame = CGRectMake(kScreenWidth*.05, kScreenHeight*.1, kScreenWidth*.9, kScreenHeight*.35);
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [whiteView.layer setCornerRadius:5];
    [insView addSubview:whiteView];
    
    float wWidth = whiteView.frame.size.width;
    float wHeight = whiteView.frame.size.height;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, wHeight*.08, wWidth, wHeight/8)];
    title.text = @"How to Rate";
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont boldSystemFontOfSize:16.0]];
    [whiteView addSubview:title];
    
    //LABELS
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(wWidth/2, (wHeight/8)*2, wWidth/2, wHeight/8)];
    lbl1.text = @"\"Absolutely love it\"";
    [lbl1 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]];
    [whiteView addSubview:lbl1];
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(wWidth/2, (wHeight/8)*3.05, wWidth/2, wHeight/8)];
    lbl2.text = @"\"Very good\"";
    [lbl2 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]];
    [whiteView addSubview:lbl2];
    UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(wWidth/2, (wHeight/8)*4.1, wWidth/2, wHeight/8)];
    lbl3.text = @"\"Decent\"";
    [lbl3 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]];
    [whiteView addSubview:lbl3];
    UILabel *lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(wWidth/2, (wHeight/8)*5.15, wWidth/2, wHeight/8)];
    lbl4.text = @"\"No, thanks\"";
    [lbl4 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]];
    [whiteView addSubview:lbl4];
    UILabel *lbl5 = [[UILabel alloc] initWithFrame:CGRectMake(wWidth/2, (wHeight/8)*6.2, wWidth/2, wHeight/8)];
    lbl5.text = @"\"Undrinkable\"";
    [lbl5 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]];
    [whiteView addSubview:lbl5];
    
    //STARS
    float lHeight = wHeight/8;
    float sbox = lHeight*.8;
    float sgap = lHeight*.9;
    UIImageView *s1_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-selected"]];
    s1_1.frame = CGRectMake(wWidth/2-(lHeight*5), lbl1.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s1_1];
    UIImageView *s1_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-selected"]];
    s1_2.frame = CGRectMake(s1_1.frame.origin.x+(sgap), lbl1.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s1_2];
    UIImageView *s1_3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-selected"]];
    s1_3.frame = CGRectMake(s1_1.frame.origin.x+(sgap*2), lbl1.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s1_3];
    UIImageView *s1_4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-selected"]];
    s1_4.frame = CGRectMake(s1_1.frame.origin.x+(sgap*3), lbl1.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s1_4];
    UIImageView *s1_5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-selected"]];
    s1_5.frame = CGRectMake(s1_1.frame.origin.x+(sgap*4), lbl1.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s1_5];
    
    UIImageView *s2_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-selected"]];
    s2_1.frame = CGRectMake(s1_1.frame.origin.x, lbl2.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s2_1];
    UIImageView *s2_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-selected"]];
    s2_2.frame = CGRectMake(s1_1.frame.origin.x+(sgap), lbl2.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s2_2];
    UIImageView *s2_3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-selected"]];
    s2_3.frame = CGRectMake(s1_1.frame.origin.x+(sgap*2), lbl2.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s2_3];
    UIImageView *s2_4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-selected"]];
    s2_4.frame = CGRectMake(s1_1.frame.origin.x+(sgap*3), lbl2.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s2_4];
    UIImageView *s2_5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-gray"]];
    s2_5.frame = CGRectMake(s1_1.frame.origin.x+(sgap*4), lbl2.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s2_5];
    
    
    UIImageView *s3_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-selected"]];
    s3_1.frame = CGRectMake(s1_1.frame.origin.x, lbl3.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s3_1];
    UIImageView *s3_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-selected"]];
    s3_2.frame = CGRectMake(s1_1.frame.origin.x+(sgap), lbl3.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s3_2];
    UIImageView *s3_3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-selected"]];
    s3_3.frame = CGRectMake(s1_1.frame.origin.x+(sgap*2), lbl3.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s3_3];
    UIImageView *s3_4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-gray"]];
    s3_4.frame = CGRectMake(s1_1.frame.origin.x+(sgap*3), lbl3.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s3_4];
    UIImageView *s3_5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-gray"]];
    s3_5.frame = CGRectMake(s1_1.frame.origin.x+(sgap*4), lbl3.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s3_5];
    
    UIImageView *s4_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-selected"]];
    s4_1.frame = CGRectMake(s1_1.frame.origin.x, lbl4.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s4_1];
    UIImageView *s4_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-selected"]];
    s4_2.frame = CGRectMake(s1_1.frame.origin.x+(sgap), lbl4.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s4_2];
    UIImageView *s4_3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-gray"]];
    s4_3.frame = CGRectMake(s1_1.frame.origin.x+(sgap*2), lbl4.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s4_3];
    UIImageView *s4_4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-gray"]];
    s4_4.frame = CGRectMake(s1_1.frame.origin.x+(sgap*3), lbl4.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s4_4];
    UIImageView *s4_5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-gray"]];
    s4_5.frame = CGRectMake(s1_1.frame.origin.x+(sgap*4), lbl4.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s4_5];
    
    
    UIImageView *s5_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-selected"]];
    s5_1.frame = CGRectMake(s1_1.frame.origin.x, lbl5.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s5_1];
    UIImageView *s5_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-gray"]];
    s5_2.frame = CGRectMake(s1_1.frame.origin.x+(sgap), lbl5.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s5_2];
    UIImageView *s5_3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-gray"]];
    s5_3.frame = CGRectMake(s1_1.frame.origin.x+(sgap*2), lbl5.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s5_3];
    UIImageView *s5_4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-gray"]];
    s5_4.frame = CGRectMake(s1_1.frame.origin.x+(sgap*3), lbl5.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s5_4];
    UIImageView *s5_5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"insStar-gray"]];
    s5_5.frame = CGRectMake(s1_1.frame.origin.x+(sgap*4), lbl5.frame.origin.y, sbox, sbox);
    [whiteView addSubview:s5_5];
    
    UIButton *closeBtn2 = [[UIButton alloc]init];
    closeBtn2.frame = CGRectMake((wWidth)-lHeight, 0, lHeight, lHeight);
    [closeBtn2 setBackgroundImage:[UIImage imageNamed:@"insClose"] forState:UIControlStateNormal];
    [whiteView addSubview:closeBtn2];
    
    [closeBtn1 addTarget:self action:@selector(closeInstructions:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn2 addTarget:self action:@selector(closeInstructions:) forControlEvents:UIControlEventTouchUpInside];
    
    insView.tag = 99;
    [vc.view addSubview:insView];
    //[self.view addSubview:insView];
    
}
-(void)closeInstructions:(id) sender{
    
    UITableView *tv = (UITableView *) self.superview.superview;
    UITableViewController *vc = (UITableViewController *) tv.dataSource;
    
    UIView *theView;
    NSArray* contentSubViews = [vc.view subviews];
    for (UIView* viewToRemove in contentSubViews)
    {
        if(viewToRemove.tag == 99){
            theView =viewToRemove;
        }
    }
    
    NSArray *viewsToRemove = [theView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    [theView removeFromSuperview];
    theView = nil;
}

@end
