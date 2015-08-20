//
//  MeAndWineCell.m
//  unscrewed
//
//  Created by Robin Garg on 18/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USMeAndWineCell.h"
#import "DYRateView.h"
#import "USWineDetail.h"
#import "USReview.h"
#import "USUsers.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

static NSString *const PlaceHolder = @"Review it";

@interface USMeAndWineCell ()<DYRateViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) USWineDetail *objWineDetails;

@property (nonatomic, strong) IBOutlet UIButton *btnLike;
@property (nonatomic, strong) IBOutlet UIButton *btnWant;

@property (nonatomic, weak)   IBOutlet UIImageView *imgViewUserProfile;
@property (nonatomic, strong) IBOutlet UITextView *textViewUserReview;

- (IBAction)meAndThisWineEventHandler:(UIButton *)sender;

@end

@implementation USMeAndWineCell

- (void)awakeFromNib {
    // Initialization code
	[self.btnWant.layer setCornerRadius:CGRectGetHeight(self.btnWant.frame)*0.5];
	[self.btnWant.layer setBorderWidth:[UIScreen mainScreen].scale*0.5f];
	[self.btnWant setTitle:@"Save" forState:UIControlStateNormal];
	[self.btnWant setTitle:@"Save" forState:UIControlStateSelected];
	[self.btnWant setTitleColor:[USColor colorFromHexString:@"#A7A7A7"] forState:UIControlStateNormal];
    [self.btnWant setBackgroundColor:[UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1] /*#f8f8f8*/];
    [self.btnWant.layer setBorderColor:[USColor colorFromHexString:@"#A7A7A7"].CGColor];
    
    [self.btnWant setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    UIEdgeInsets edgeInsets = self.btnWant.contentEdgeInsets;
    edgeInsets.bottom = 1;
    [self.btnWant setContentEdgeInsets:edgeInsets];
    [self.btnWant setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal] ;
	
	[self.imgViewUserProfile.layer setCornerRadius:CGRectGetHeight(self.imgViewUserProfile.frame)*0.5f];
	[self.imgViewUserProfile setClipsToBounds:YES];
	
	[self.textViewUserReview.layer setCornerRadius:5.f];
	[self.textViewUserReview.layer setBorderWidth:[UIScreen mainScreen].scale*0.5f];
	//[self.textViewUserReview.layer setBorderColor:[UIColor colorWithWhite:(215.f/255.f) alpha:1.f].CGColor];
    [self.textViewUserReview.layer setBorderColor:[USColor colorFromHexString:@"#d7d7d7"].CGColor];
    [self.textViewUserReview setTextColor:[USColor colorFromHexString:@"#CECECE"]];
	//[self.textViewUserReview setTextColor:[UIColor colorWithRed:(137.f/255.f) green:(141.f/255.f) blue:(143.f/255.f) alpha:1.f]];
	
	if (![self.contentView viewWithTag:1001]) {
		DYRateView *rateView =
		[[DYRateView alloc] initWithFrame:CGRectMake(143, 43, 162, 30)
								 fullStar:[UIImage imageNamed:@"wineDetailsSelectedStar"]
								emptyStar:[UIImage imageNamed:@"wineDetailsGrayFilledStar"]];
		[rateView setTag:1001];
		[rateView setEditable:YES];
		[rateView setDelegate:self];
		[rateView setPadding:3.f];
		[self.contentView addSubview:rateView];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWineLikeStatusTo:(BOOL)like {
	[self.btnLike setSelected:like];
}

- (void)updateWineWantStatusTo:(BOOL)wants {
	[self.btnWant setSelected:wants];
	if (wants) {
		[self.btnWant.layer setBorderColor:[USColor themeSelectedColor].CGColor];
		[self.btnWant setBackgroundColor:[USColor themeSelectedColor]];
	} else {
		[self.btnWant.layer setBorderColor:[UIColor colorWithRed:0.843 green:0.843 blue:0.843 alpha:1] /*#d7d7d7*/.CGColor];
		[self.btnWant setBackgroundColor:[UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1] /*#f8f8f8*/];
	}
}

- (void)updateReviewWineTextTo:(NSString *)review {
	if (review) {
		[self.textViewUserReview setText:review];
	} else {
		[self.textViewUserReview setText:PlaceHolder];
	}
}

- (void)fillMeAndWineInfo:(USWineDetail *)info indexPath:(NSIndexPath *)indexPath {
	self.objWineDetails = info;
	DYRateView *rateView = (DYRateView *)[self.contentView viewWithTag:1001];
	if (rateView) {
        self.isSettingInitialRating = YES;
		rateView.rate = floorf(info.myReview.reviewRatingCount);
        self.isSettingInitialRating = NO;
	}
    
	[self updateWineLikeStatusTo:info.liked];
	[self updateWineWantStatusTo:info.wants];
	NSURL *profileUrl = [NSURL URLWithString:[[USUsers sharedUser]objUser].avatar];
	if (profileUrl) {
		[self.imgViewUserProfile setImageWithURL:profileUrl placeholderImage:[UIImage imageNamed:@"dummy_gray"]];
	} else {
		[self.imgViewUserProfile setImage:[UIImage imageNamed:@"dummy_gray"]];
	}
	[self updateReviewWineTextTo:info.myReview.reviewTitle];
}

#pragma mark - $$ EVENT HANDLER $$
- (IBAction)meAndThisWineEventHandler:(UIButton *)sender {
	if ([sender isEqual:self.btnLike]) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(likeWineSelected)]) {
			[self.delegate likeWineSelected];
		}
	} else if ([sender isEqual:self.btnWant]){
		if (self.delegate && [self.delegate respondsToSelector:@selector(wantWineSelected)]) {
			[self.delegate wantWineSelected];
		}
	}
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark DYRateView Delegate
- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate {
	DLog(@"Rate View Changed To Rating - %@",rate);
	if (self.isSettingInitialRating == NO) {
		NSString *shown = [[NSUserDefaults standardUserDefaults] objectForKey:@"ratings_ins_shown"];
		if([shown isEqual:@"YES"]){
			if (self.delegate && [self.delegate respondsToSelector:@selector(rateWineChangedToNewRate:)]) {
				[self.delegate rateWineChangedToNewRate:(floorf(rate.floatValue) == floorf(self.objWineDetails.myReview.reviewRatingCount) ? @0 : rate)];
			}
		} else {
			self.objWineDetails.myReview.reviewRatingCount = [rate integerValue];
			[self showRatingsInstructions];
			[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"ratings_ins_shown"];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}
}

#pragma mark Text View Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	if (self.delegate && [self.delegate respondsToSelector:@selector(reviewWineTextViewSelectedWithText:)]) {
		if ([textView.text isEqualToString:PlaceHolder]) {
			[self.delegate reviewWineTextViewSelectedWithText:nil];
		} else {
			[self.delegate reviewWineTextViewSelectedWithText:textView.text];
		}
	}
	return NO;
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
