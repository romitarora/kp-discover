//
//  USReviewsListTVC.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 20/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USReviewsListTVC.h"
#import "USReviewsListingCell.h"
#import "USReviewSummaryCell.h"
#import "USReviews.h"

@interface USReviewsListTVC ()

@end

@implementation USReviewsListTVC

- (void)viewDidLoad {
    [super viewDidLoad];

	[self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
	
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USReviewSummaryCell class]) bundle:nil] forCellReuseIdentifier:@"USReviewSummaryCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USReviewsListingCell class]) bundle:nil] forCellReuseIdentifier:@"USReviewsListingCell"];
    
    if(self.showHelp==YES){
        self.showingHelp = NO;
        UIBarButtonItem *helpButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Help"
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(helpBtnAction:)];
        self.navigationItem.rightBarButtonItem = helpButton;
    }
}
-(void)helpBtnAction:(id)sender{
    if(self.showingHelp == NO){
        self.showingHelp = YES;
        [self showRatingsInstructions];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
//    [self getReviews];
}

#pragma mark - Get Reviews
- (void)getReviews {
    self.objReviews = [USReviews new];
    [self.objReviews getReviewsForWineId:_wineId
						   isUserReviews:self.isViewingUserReviews
								  target:self
							  completion:@selector(getReviewsSuccessHandler:)
								 failure:@selector(getReviewsFailureHandler:)];
}

- (void)getReviewsSuccessHandler:(id)data {
    LogInfo(@"%@",data);
}

- (void)getReviewsFailureHandler:(id)error {
    LogTrace(@"Error Info - %@",error);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
    //return (self.isViewingUserReviews ? 2 : 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.isViewingUserReviews && section == 0) {
//        return 1;
//    }
    return self.objReviews.arrReviews.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.isViewingUserReviews && indexPath.section == 0) {
//        return 189.f;
//    }
	USReview *objReview = self.objReviews.arrReviews[indexPath.row];
    return [USReviewsListingCell heightForCell:objReview];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Remove seperator inset
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	
	// Prevent the cell from inheriting the Table View's margin settings
	if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
		[cell setPreservesSuperviewLayoutMargins:NO];
	}
	
	// Explictly set your cell's layout margins
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	USReviewsListingCell *cell = (USReviewsListingCell *)[tableView dequeueReusableCellWithIdentifier:@"USReviewsListingCell" forIndexPath:indexPath];
	[cell fillReviewInfo:[self.objReviews.arrReviews objectAtIndex:indexPath.row] forUsers:self.isViewingUserReviews];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
	/*
	if (self.isViewingUserReviews && indexPath.section == 0) {
        USReviewSummaryCell *cell = (USReviewSummaryCell *)[tableView dequeueReusableCellWithIdentifier:@"USReviewSummaryCell" forIndexPath:indexPath];
        [cell fillReviewSummary:[self.objReviews.arrReviews objectAtIndex:indexPath.section]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        USReviewsListingCell *cell = (USReviewsListingCell *)[tableView dequeueReusableCellWithIdentifier:@"USReviewsListingCell" forIndexPath:indexPath];
        [cell fillReviewInfo:[self.objReviews.arrReviews objectAtIndex:indexPath.row] forUsers:self.isViewingUserReviews];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }*/
}


#pragma mark - Show Ratings Instructions
-(void)showRatingsInstructions{
    //UITableView *tv = (UITableView *) self.superview.superview;
    //UITableViewController *vc = (UITableViewController *) tv.dataSource;
    
    UIView *insView = [[UIView alloc] init];
    insView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    
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
    [self.view addSubview:insView];
    //[self.view addSubview:insView];
    
}
-(void)closeInstructions:(id) sender{
    
    //UITableView *tv = (UITableView *) self.superview.superview;
    //UITableViewController *vc = (UITableViewController *) tv.dataSource;
    
    UIView *theView;
    NSArray* contentSubViews = [self.view subviews];
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
    self.showingHelp = NO;
}


@end
