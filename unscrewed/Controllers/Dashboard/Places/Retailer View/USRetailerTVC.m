//
//  USRetailerTVC.m
//  unscrewed
//
//  Created by Robin Garg on 25/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USRetailerTVC.h"
#import "USRetailers.h"
#import "USWineTypeCollectionCell.h"
#import "USWineSearchResultsTVC.h"
#import "USReviewVC.h"
#import "USFriendsFollowingCell.h"
#import "USStoreReviewsCell.h"
#import "USReviewStoreCell.h"
#import "USAddWineCell.h"
#import "USReview.h"
#import "USAddWineVC.h"
#import "USAddressCell.h"
#import "USSearchOperation.h"
#import "USWines.h"
#import "USWineDetailTVC.h"
#import "USMapViewController.h"
#import "USReviewsListTVC.h"
#import "USFriendsLikeWinesVC.h"
#import "USFindFriendVC.h"
#import "USIntermediateTVC.h"
#import "UIImageView+AFNetworking.h"

typedef NS_ENUM(NSInteger, RetailerTableViewSection) {
	RetailerTableViewSectionWineType = 0,
	RetailerTableViewSectionFilter = 1,
	RetailerTableViewSectionFriendsLike = 2,
	RetailerTableViewSectionStoreReview = 3,
	RetailerTableViewSectionReviewStore = 4,
	RetailerTableViewSectionAddWine = 5,
    RetailerTableViewSectionPhone = 6,
	RetailerTableViewSectionWebsite = 7,
	RetailerTableViewSectionAddress = 8
};

static NSString *const collectionViewCellIdentifire = @"WineTypeCollectionCell";
static const NSInteger TOTAL_NUMBER_OF_SECTIONS = 9;

@interface USRetailerTVC ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, USReviewStoreCellDelegate, USReviewVCDelegate, USAddWineCellDelegate, USAddressCellDelegate, USSearchOperationCompletionDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *arrWineTypes;
@property (nonatomic, strong) NSArray *arrWineFilterOptions;

@property (nonatomic, strong) USRetailerDetails *objRetailerDetails;

@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, assign, getter=isSearching) BOOL searching;
@property (nonatomic, strong) USWines *objSearchedWines;
@property (nonatomic, assign) BOOL gettingWines;
@property (nonatomic, strong) NSOperationQueue *searchQueue;


@end

@implementation USRetailerTVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.searchQueue = [NSOperationQueue new];
    
    
    //New Header
    /*
    UIView *headerView = [[UIView alloc] init];
    
    UIImageView *retailerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*.41, 5, kScreenWidth*.18, kScreenWidth*.18)];
    [retailerImage setImageWithURL:[NSURL URLWithString:self.objRetailer.photoUrl]];
    [retailerImage setContentMode:UIViewContentModeScaleToFill];
    [retailerImage.layer setCornerRadius:retailerImage.frame.size.height/2];
    [retailerImage.layer setMasksToBounds:YES];
    [headerView addSubview:retailerImage];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*.1, retailerImage.frame.origin.y+retailerImage.frame.size.height+10, kScreenWidth*.8, 20)];
    [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:[USFont placeNameFont].pointSize+3]];
    [nameLabel setTextColor:[USColor colorFromHexString:@"#1F1F1F"] ];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    nameLabel.text = self.objRetailer.name;
    [headerView addSubview:nameLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*.1, nameLabel.frame.origin.y+nameLabel.frame.size.height+1, kScreenWidth*.8, 20)];
    [addressLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[USFont placeAddressFont].pointSize-1]];
    [addressLabel setTextColor:[USColor colorFromHexString:@"#7F7F7F"] ];
    [addressLabel setTextAlignment:NSTextAlignmentCenter];
    addressLabel.text = self.objRetailer.address;
    [headerView addSubview:addressLabel];
    
    headerView.frame = CGRectMake(0, 0, kScreenWidth, addressLabel.frame.origin.y+addressLabel.frame.size.height+self.searchDisplayController.searchBar.frame.size.height);
    
    CGRect sBarFrame = self.searchDisplayController.searchBar.frame;
    sBarFrame.origin.y = addressLabel.frame.origin.y+addressLabel.frame.size.height+5;
    sBarFrame.size.width = headerView.frame.size.width;
    self.searchDisplayController.searchBar.frame = sBarFrame;
    self.sBarFrame = sBarFrame;
    [self.searchDisplayController.searchBar setBackgroundColor:[UIColor whiteColor]];
    
    [self.searchDisplayController.searchBar setPlaceholder:@"Search store"];
    [self.searchDisplayController.searchResultsTableView setSeparatorColor:[USColor cellSeparatorColor]];
    [headerView addSubview:self.searchDisplayController.searchBar];
    
    self.tableView.tableHeaderView = headerView;
     
    */
    
    
    [self.navigationItem setTitleView:[HelperFunctions kerningTitleViewWithTitle:[self.objRetailer.name lowercaseString]]];
    self.navigationItem.leftBarButtonItem = [HelperFunctions customBackBarButton];
    
    self.arrWineTypes = [HelperFunctions arrWineTypesForRetailer:YES];
    self.arrWineFilterOptions = [HelperFunctions arrFindWineOptions2];
    [self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
    [self registerCellsWithTableview];
    
    [self.searchDisplayController.searchBar setPlaceholder:@"Search store"];
    [self.searchDisplayController.searchResultsTableView setSeparatorColor:[USColor cellSeparatorColor]];
    
    
    
    
    /*
    
	[self.navigationItem setTitleView:[HelperFunctions kerningTitleViewWithTitle:[self.objRetailer.name lowercaseString]]];
	self.navigationItem.leftBarButtonItem = [HelperFunctions customBackBarButton2];
    [self.navigationItem.leftBarButtonItem setTintColor:[USColor colorFromHexString:@"#bbbbbe"]];
	
	self.arrWineTypes = [HelperFunctions arrWineTypesForRetailer:YES];
	self.arrWineFilterOptions = [HelperFunctions arrFindWineOptions];
	[self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
	[self registerCellsWithTableview];*/

    
}
/*
-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    [self.searchDisplayController.searchBar removeFromSuperview];
    self.searchDisplayController.searchBar.frame = self.sBarFrame;
    self.searchDisplayController.searchBar.alpha = 0;
    [self.tableView.tableHeaderView addSubview:self.searchDisplayController.searchBar];
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.searchDisplayController.searchBar.alpha = 1;
        self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
    }completion:^(BOOL finished) {
        
    }];
}

-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    //[self.searchDisplayController.searchBar setBackgroundColor:[UIColor whiteColor]];
    UIView *cover = [[UIView alloc] initWithFrame:self.searchDisplayController.searchBar.frame];
    [cover setBackgroundColor:[UIColor whiteColor]];
    cover.alpha = 0;
    cover.tag = 88;
    //[self.tableView.tableHeaderView addSubview:cover];
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect tFrame = self.tableView.frame;
        tFrame.origin.y = 65;
        //self.tableView.frame = tFrame;
        cover.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];
}
 */

- (void)viewWillAppear:(BOOL)animated
{
    [self getPlaceDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark Register Cells
- (void)registerCellsWithTableview {
	// friends and following cell
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USFriendsFollowingCell class]) bundle:nil]
		 forCellReuseIdentifier:NSStringFromClass([USFriendsFollowingCell class])];

    // Store Reviews cell
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USStoreReviewsCell class]) bundle:nil]
		 forCellReuseIdentifier:NSStringFromClass([USStoreReviewsCell class])];

    // Review Store cell
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USReviewStoreCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([USReviewStoreCell class])];

    // Add Wine cell
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USAddWineCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([USAddWineCell class])];

    // Address cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USAddressCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([USAddressCell class])];
}

- (void)updateNavigationBarLikedPlaceBarButtonBasedOnStatus:(BOOL)liked {
	//NSString *imageName = liked ? @"filled_star_27x27" : @"stroked_star_27x27";
    
    NSString *imageName = liked ? @"filled_star_27x27" : @"stroked_star_27x27";
	UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIBarButtonItem *barButtonStared = self.navigationItem.rightBarButtonItem;
	if (!barButtonStared) {
		barButtonStared = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(barButtonStaredPlaceActionEventHandler)];
	} else {
		[barButtonStared setImage:image];
	}
    [barButtonStared setImageInsets:UIEdgeInsetsMake(0, -16, 0, 8)];
	[self.navigationItem setRightBarButtonItem:barButtonStared];
}

#pragma mark Pagination
//Load more wines if table view scroll to the end
- (void)loadMorePostsIfTableScrolledToLastRecord {
	NSArray *arrVisibleRows = [self.searchDisplayController.searchResultsTableView indexPathsForVisibleRows];
	NSIndexPath *lastVisibleIndexPath = [arrVisibleRows lastObject];
	if (lastVisibleIndexPath.row == self.objSearchedWines.arrWines.count-1 && self.objSearchedWines.isReachedEnd == NO) {
		if (self.gettingWines == NO) {
			// Get More Wines
			NSMutableDictionary *params = [NSMutableDictionary new];
			[params setObject:self.searchString forKey:queryKey];
			[params setObject:self.objRetailer.retailerId forKey:placeIdKey];
			[self getWinesWithParam:params];
		}
	}
}

#pragma mark Navigation
- (void)navigateToWineResultViewControllerForWineType:(NSString *)wineType {
	USWineSearchResultsTVC *objWineResultVC = [[USWineSearchResultsTVC alloc] initWithStyle:UITableViewStylePlain];
	objWineResultVC.wineColorSelected = wineType;
	objWineResultVC.wineHeaderTitle = [wineType capitalizedString];
	objWineResultVC.objRetailer = self.objRetailer;
    [self.navigationController pushViewController:objWineResultVC animated:YES];
}

- (void)navigateToStoreReviewViewWithReviewText:(NSString *)reviewText {
	USReviewVC *objReviewVC = [[USReviewVC alloc] init];
	objReviewVC.objectId = self.objRetailer.retailerId;
	objReviewVC.objReview = self.objRetailerDetails.myReview;
	objReviewVC.delegate = self;
	objReviewVC.reviewType = ReviewTypeStore;
	[self.navigationController pushViewController:objReviewVC animated:YES];
}

- (void)navigateToAddWineViewControllerWithRetailerId:(NSString *)retailerId {
	USAddWineVC *addWineVC = [[USAddWineVC alloc] init];
	addWineVC.objRetailer = self.objRetailer;
	[self.navigationController pushViewController:addWineVC animated:YES];
}

- (void)navigateToWineDetailsViewControllerForWine:(USWine *)wine {
	USWineDetailTVC *objWineDetailsTVC = [[USWineDetailTVC alloc] initWithStyle:UITableViewStylePlain];
	objWineDetailsTVC.wineId = wine.wineId;
	objWineDetailsTVC.wineName = wine.name;
	[self.navigationController pushViewController:objWineDetailsTVC animated:YES];
}

#pragma mark Build Cells
- (UITableViewCell *)buildWineTypeCell {
	static NSString *wineTypeCellIdentifire = @"wineTypeCellIdentifire";
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:wineTypeCellIdentifire];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wineTypeCellIdentifire];
		UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
		[flowLayout setSectionInset:UIEdgeInsetsMake(9.5f, 10.f, 17.5f, 10.f)];
		[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, 116) collectionViewLayout:flowLayout];
		[_collectionView setShowsHorizontalScrollIndicator:NO];
		[_collectionView setBackgroundColor:[UIColor clearColor]];
		_collectionView.dataSource = self;
		_collectionView.delegate = self;
		[_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([USWineTypeCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:collectionViewCellIdentifire];
		[cell.contentView addSubview:_collectionView];
        
	}
	return cell;
}

- (UITableViewCell *)buildQuickSearchCell{
    static NSString *wineFilterCellIdentifire = @"wineFilterCellIdentifire";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:wineFilterCellIdentifire];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wineFilterCellIdentifire];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //[cell.imageView setTintColor:[UIColor blackColor]];//[USColor themeSelectedColor]];
        //[cell.imageView setTintColor:[USColor themeSelectedColor]];
        //[cell.textLabel setFont:[USFont defaultTableCellTextFont]];
    }
    /*
    float frameH = cell.textLabel.frame.size.height;
    float frameW = cell.textLabel.frame.size.width;
    float frameY = cell.textLabel.frame.origin.y;
    */
    UILabel *quickLabel = [[UILabel alloc] init];
    [quickLabel setTextColor:[USColor colorFromHexString:@"#898D8F"]];
    [quickLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [quickLabel setFrame:CGRectMake(10, 0, kScreenHeight, 22)];
    [quickLabel setText:@"QUICK SEARCH"];
    [cell.contentView addSubview:quickLabel];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //UIImage *renderedImage = [[UIImage imageNamed:[dictOption valueForKey:@"imageName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //[cell.imageView setImage:renderedImage];
    
    //NSLog(@" INDEX ROW = %f", cell.textLabel.frame.size.height);
    
    
    //[[cell.contentView viewWithTag:88] removeFromSuperview];
    
    return cell;
}
- (UITableViewCell *)buildFilterCellForIndexPath:(NSIndexPath *)indexPath {
	static NSString *wineFilterCellIdentifire = @"wineFilterCellIdentifire";
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:wineFilterCellIdentifire];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wineFilterCellIdentifire];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //[cell.imageView setTintColor:[UIColor blackColor]];//[USColor themeSelectedColor]];
        [cell.imageView setTintColor:[USColor themeSelectedColor]];
		[cell.textLabel setFont:[USFont defaultTableCellTextFont]];
	}
	NSDictionary *dictOption = [self.arrWineFilterOptions objectAtIndex:indexPath.row];
    
    //FOR NEW COUNTER
    NSString *numberCount = [NSString stringWithFormat:@"%d", rand() % (300 - 1) + 1];
    if(indexPath.row == 0){ //Change Counter text for REDS
        numberCount = @"298";
    }else if(indexPath.row == 1){ //Change Counter text for WHITES
        numberCount = @"108";
    }else if(indexPath.row == 2){ //Change Counter text for SPARKLING , etc
        numberCount = @"41";
    }else if(indexPath.row == 3){ //Change Counter text for 90+ rated under $20
        numberCount = @"16";
    }else if(indexPath.row == 4){ //Change Counter text for New this week
        numberCount = @"4";
    }else if(indexPath.row == 5){ //Change Counter text for by pairing
        numberCount = @"n/a";
    }
    
    NSString *strCount = [NSString stringWithFormat:@"(%@)",numberCount];
    NSString *strTitle = [NSString stringWithFormat:@"%@ %@",[dictOption valueForKey:@"title"], strCount];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strTitle];
    
    NSRange countRange = [strTitle rangeOfString:strCount];
    if (countRange.length) {
        [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] range:countRange];
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setAttributedText:attrString];
	//[cell.textLabel setText:[dictOption valueForKey:@"title"]];
	UIImage *renderedImage = [[UIImage imageNamed:[dictOption valueForKey:@"imageName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[cell.imageView setImage:renderedImage];
    
    //NSLog(@" INDEX ROW = %f", cell.textLabel.frame.size.height);
    
    
    [[cell.contentView viewWithTag:88] removeFromSuperview];
    
    
    
    //For Counter
    
    /*
    float cellHeight = 43.5; //Assumed from NSLog
    [[cell.contentView viewWithTag:88] removeFromSuperview]; //Remove if already renderred
    
    UILabel *counter = [[UILabel alloc] init];
    counter.frame = CGRectMake(kScreenWidth*.75-(cellHeight*.75), 0, kScreenWidth*.25, cellHeight);
    [counter setTextAlignment:NSTextAlignmentRight];
    [counter setTextColor:[USColor colorFromHexString:@"#5B5B5B"]];
    [counter setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:cell.textLabel.font.pointSize]];
    counter.text = @"0";
    counter.tag = 88;
    //NSString *num = [NSString stringWithFormat:@"%d", rand() % (100 - 1) + 1];
    if(indexPath.row == 0){ //Change Counter text for Under $10
        counter.text = @"21";
    }else if(indexPath.row == 1){ //Change Counter text for 90+ rated under $20
        counter.text = @"32";
    }else if(indexPath.row == 2){ //Change Counter text for New this week
        counter.text = @"2";
    }else if(indexPath.row == 3){ //Change Counter text for by pairing
        //counter.text = @"1";
    }
    if([counter.text isEqual:@"0"]){ //Hide counter text if zero
        counter.hidden = YES;
    }
    [cell.contentView addSubview:counter];
     */
    
	return cell;
}

- (USFriendsFollowingCell *)buildFriendsLikeCellForIndexPath:(NSIndexPath *)indexPath {
	USFriendsFollowingCell *friendsAndFollowingCell = (USFriendsFollowingCell *)[self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USFriendsFollowingCell class]) forIndexPath:indexPath];
	friendsAndFollowingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	[friendsAndFollowingCell fillFriendsInfoForRetailer:self.objRetailerDetails];
	return friendsAndFollowingCell;
}

- (USStoreReviewsCell *)buildStoreReviewsCellForIndexPath:(NSIndexPath *)indexPath {
	USStoreReviewsCell *storeReviewCell = (USStoreReviewsCell *)[self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USStoreReviewsCell class]) forIndexPath:indexPath];
	storeReviewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	[storeReviewCell fillStoreReviewCellWithInfo:self.objRetailerDetails forIndex:indexPath.row];
	return storeReviewCell;
}

- (USReviewStoreCell *)buildReviewStoreCellForIndexPath:(NSIndexPath *)indexPath {
	USReviewStoreCell *reviewStoreCell = (USReviewStoreCell *)[self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USReviewStoreCell class]) forIndexPath:indexPath];
	reviewStoreCell.delegate = self;
	[reviewStoreCell fillReviewStoreCellWithInfo:self.objRetailerDetails];
	return reviewStoreCell;
}

- (USAddWineCell *)buildAddWineCellForIndexPath:(NSIndexPath *)indexPath {
	USAddWineCell *cell = (USAddWineCell *)[self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USAddWineCell class]) forIndexPath:indexPath];
	cell.delegate = self;
	return cell;
}

- (USAddressCell *)buildAddressCellForIndexPath:(NSIndexPath *)indexPath {
    USAddressCell *cell = (USAddressCell *)[self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USAddressCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    [cell fillAddressInfo:self.objRetailerDetails forIndex:indexPath.section];
    return cell;
}

#pragma mark - $$ WEB SERVICES $$
#pragma mark Get Place Details
- (void)getPlaceDetailsFailureHandlerWithError:(id)error {
	DLog(@"error = %@",error);
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	if ([error isKindOfClass:[NSError class]]) {
		[HelperFunctions showAlertWithTitle:kServerError
									message:[error localizedDescription]
								   delegate:nil
						  cancelButtonTitle:kOk
						   otherButtonTitle:nil];
	} else {
		[HelperFunctions showAlertWithTitle:kError
									message:(NSString *)error
								   delegate:nil
						  cancelButtonTitle:kOk
						   otherButtonTitle:nil];
	}
}
- (void)getPlaceDetailsSuccessHandlerWithInfo:(USRetailerDetails *)objRetailerDetails {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	self.objRetailerDetails = objRetailerDetails;
	[self updateNavigationBarLikedPlaceBarButtonBasedOnStatus:self.objRetailerDetails.favorited];
	[self.tableView reloadData];
}

- (void)getPlaceDetails {
	[[HelperFunctions sharedInstance] showProgressIndicator];
	USRetailers *objRetailers = [USRetailers new];
	[objRetailers getDetailsForPlaceId:self.objRetailer.retailerId
								target:self
							completion:@selector(getPlaceDetailsSuccessHandlerWithInfo:)
							   failure:@selector(getPlaceDetailsFailureHandlerWithError:)];
}

#pragma mark Like Unlike Place
- (void)likeUnlikePlaceFailureHandlerWithError:(id)error {
	DLog(@"error = %@",error);
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	if ([error isKindOfClass:[NSError class]]) {
		[HelperFunctions showAlertWithTitle:kServerError
									message:[error localizedDescription]
								   delegate:nil
						  cancelButtonTitle:kOk
						   otherButtonTitle:nil];
	} else {
		[HelperFunctions showAlertWithTitle:kError
									message:(NSString *)error
								   delegate:nil
						  cancelButtonTitle:kOk
						   otherButtonTitle:nil];
	}

}
- (void)likeUnlikePlaceSuccessHandlerWithInfo:(id)info {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	[self updateNavigationBarLikedPlaceBarButtonBasedOnStatus:self.objRetailerDetails.favorited];
}
- (void)likeUnlikePlace {
	[[HelperFunctions sharedInstance] showProgressIndicator];

	USRetailers *objRetailers = [USRetailers new];
	if (self.objRetailerDetails.favorited) {
		[objRetailers setStatusAsUnstaredForPlace:self.objRetailerDetails
										   target:self
									   completion:@selector(likeUnlikePlaceSuccessHandlerWithInfo:)
										  failure:@selector(likeUnlikePlaceFailureHandlerWithError:)];
	} else {
		[objRetailers setStatusAsStaredForPlace:self.objRetailerDetails
										 target:self
									 completion:@selector(likeUnlikePlaceSuccessHandlerWithInfo:)
										failure:@selector(likeUnlikePlaceFailureHandlerWithError:)];
	}
}

#pragma mark Get Wines
- (void)getWinesFailureHandlerWithError:(id)error {
	DLog(@"error = %@",error);
	self.gettingWines = NO;
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	if ([error isKindOfClass:[NSError class]]) {
		[HelperFunctions showAlertWithTitle:kServerError
									message:[error localizedDescription]
								   delegate:nil
						  cancelButtonTitle:kOk
						   otherButtonTitle:nil];
	} else {
		[HelperFunctions showAlertWithTitle:kError
									message:(NSString *)error
								   delegate:nil
						  cancelButtonTitle:kOk
						   otherButtonTitle:nil];
	}
	
}

- (void)getWinesSuccessHandlerWithInfo:(id)info {
	self.gettingWines = NO;
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	[self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)getWinesWithParam:(NSMutableDictionary *)params {
	self.gettingWines = YES;
	[[HelperFunctions sharedInstance] showProgressIndicator];
	[self.objSearchedWines getWinesWithParams:params
							   target:self
						   completion:@selector(getWinesSuccessHandlerWithInfo:)
							  failure:@selector(getWinesFailureHandlerWithError:)];
}

#pragma mark - $$ EVENTH HANDLER $$
- (void)barButtonStaredPlaceActionEventHandler {
	DLog(@"STARED PLACE BAR BUTTON TAPPED");
	[self likeUnlikePlace];
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark Review Store Cell Delegate
- (void)reviewStoreTextViewSelectedWithText:(NSString *)text {
	if ([[self.navigationController topViewController] isKindOfClass:[USReviewVC class]] == NO) {
		[self navigateToStoreReviewViewWithReviewText:text];
	}
}

#pragma mark Review VC Delegate
- (void)reviewPostedSuccessfullyWithUpdatedReview:(USReview *)objReview {
	self.objRetailerDetails.myReview = objReview;
	USReviewStoreCell *cell = (USReviewStoreCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:RetailerTableViewSectionReviewStore]];
	[cell updateReviewStoreTextTo:objReview.reviewTitle];
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Add Wine Cell Delegate
- (void)addWineActionEvent {
	LogInfo(@"Add Wine Button Selected");
	[self navigateToAddWineViewControllerWithRetailerId:self.objRetailerDetails.retailerId];
}

#pragma mark AddressCell Delegate
- (void)showDirections {
    USMapViewController *objMapVC = [USMapViewController new];
    objMapVC.objRetailer = self.objRetailer;
    objMapVC.title = @"Directions";
    UINavigationController *navMaps = [[UINavigationController alloc] initWithRootViewController:objMapVC];
    navMaps.navigationBar.translucent = NO;
    [self presentViewController:navMaps animated:YES completion:nil];
}

#pragma mark Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
		return 1;
	}
    return TOTAL_NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
		return self.objSearchedWines.arrWines.count;
	}
    // Return the number of rows in the section.
	switch (section) {
		case RetailerTableViewSectionWineType:
		case RetailerTableViewSectionFriendsLike:
		case RetailerTableViewSectionReviewStore:
		case RetailerTableViewSectionAddWine:
		case RetailerTableViewSectionPhone:
		case RetailerTableViewSectionWebsite:
		case RetailerTableViewSectionAddress:
			return 1;
        case RetailerTableViewSectionStoreReview:
            return (self.objRetailerDetails.storeReviewsCount <= 3 ? self.objRetailerDetails.storeReviewsCount : 3);
		case RetailerTableViewSectionFilter:
			return self.arrWineFilterOptions.count;
		default:
			return 0;
	}
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) return;
	
	// Set seperator inset
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		switch (indexPath.section) {
			case RetailerTableViewSectionWineType:
			case RetailerTableViewSectionFriendsLike:
			case RetailerTableViewSectionReviewStore:
			case RetailerTableViewSectionAddWine:
                [cell setSeparatorInset:UIEdgeInsetsZero];
                break;
			case RetailerTableViewSectionPhone:
			case RetailerTableViewSectionWebsite:
			case RetailerTableViewSectionAddress:
				[cell setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 0)];
				break;
			case RetailerTableViewSectionFilter:
				if (indexPath.row +1 == self.arrWineFilterOptions.count) {
					[cell setSeparatorInset:UIEdgeInsetsZero];
				}
			default:
				break;
		}
	}
	
	// Prevent the cell from inheriting the Table View's margin settings
	if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
		[cell setPreservesSuperviewLayoutMargins:NO];
	}
	
	// Explictly set your cell's layout margins
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		switch (indexPath.section) {
			case RetailerTableViewSectionWineType:
			case RetailerTableViewSectionFriendsLike:
			case RetailerTableViewSectionReviewStore:
			case RetailerTableViewSectionAddWine:
                [cell setLayoutMargins:UIEdgeInsetsZero];
                break;
            case RetailerTableViewSectionPhone:
            case RetailerTableViewSectionWebsite:
            case RetailerTableViewSectionAddress:
                [cell setLayoutMargins:UIEdgeInsetsMake(0, 12, 0, 0)];
                break;
			case RetailerTableViewSectionFilter:
				if (indexPath.row +1 == self.arrWineFilterOptions.count) {
					[cell setLayoutMargins:UIEdgeInsetsZero];
				}
			default:
				break;
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCellReuseIdentifire"];
		if (!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SearchCellReuseIdentifire"];
			[cell.textLabel setFont:[USFont defaultTableCellTextFont]];
			[cell.detailTextLabel setFont:[USFont tableHeaderMessageFont]];
			[cell.detailTextLabel setTextColor:[USColor lightDarkMenuOptionColor]];
		}
		USWine *objWine = [self.objSearchedWines.arrWines objectAtIndex:indexPath.row];
		[cell.textLabel setText:objWine.name];
		NSString *strDetailText = kEmptyString;
		if (objWine.wineType) {
			strDetailText = [NSString stringWithFormat:@"%@ Wine",objWine.wineType];
		}
		if (objWine.wineSubType) {
			strDetailText = [strDetailText stringByAppendingFormat:@" %@",objWine.wineSubType];
		}
		[cell.detailTextLabel setText:strDetailText.trim];
		return cell;
	}
	
	switch (indexPath.section) {
		case RetailerTableViewSectionWineType:

            return [self buildQuickSearchCell];
            //return [self buildWineTypeCell];
		case RetailerTableViewSectionFilter:
			return [self buildFilterCellForIndexPath:indexPath];
		case RetailerTableViewSectionFriendsLike:
			return [self buildFriendsLikeCellForIndexPath:indexPath];
		case RetailerTableViewSectionStoreReview:
			return [self buildStoreReviewsCellForIndexPath:indexPath];
		case RetailerTableViewSectionReviewStore:
			return [self buildReviewStoreCellForIndexPath:indexPath];
		case RetailerTableViewSectionAddWine:
			return [self buildAddWineCellForIndexPath:indexPath];
		case RetailerTableViewSectionPhone:
		case RetailerTableViewSectionWebsite:
		case RetailerTableViewSectionAddress:
			return [self buildAddressCellForIndexPath:indexPath];
		default:
			return nil;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
		return 44.f;
	}
	
	switch (indexPath.section) {
		case RetailerTableViewSectionWineType:
			//return 116.f; //Collection View
            return 22; //New design July 2015 QUICK SEARCH
		case RetailerTableViewSectionFilter:
			return 44.f;
		case RetailerTableViewSectionFriendsLike:
			return 98.f;
		case RetailerTableViewSectionStoreReview:
			return [USStoreReviewsCell cellHeightForRetailer:self.objRetailerDetails forIndex:indexPath.row];
		case RetailerTableViewSectionReviewStore:
			return 106.f;
		case RetailerTableViewSectionAddWine:
			return 108.f;
		case RetailerTableViewSectionPhone:
		case RetailerTableViewSectionWebsite:
			return 64.f;
		case RetailerTableViewSectionAddress:
			return [USAddressCell heightForCell:self.objRetailerDetails];
		default:
			return 0;
	}
}

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        // Search Display Controller Record Selected
		USWine *wine = [self.objSearchedWines.arrWines objectAtIndex:indexPath.row];
		[self navigateToWineDetailsViewControllerForWine:wine];

	} else {
//        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        USWineSearchResultsTVC *objWineResultVC;
		switch (indexPath.section) {
            case RetailerTableViewSectionFilter:
                //Changed due to PT story #97272104
                /*
                objWineResultVC = [[USWineSearchResultsTVC alloc] initWithStyle:UITableViewStylePlain];
                objWineResultVC.wineColorSelected = cell.textLabel.text;
                objWineResultVC.wineHeaderTitle = [cell.textLabel.text capitalizedString];
                [self.navigationController pushViewController:objWineResultVC animated:YES];
                 */
                [self navigateToIntermediate:indexPath];
                break;
			case RetailerTableViewSectionAddress:
				[self showDirections];
				break;
            case RetailerTableViewSectionStoreReview:
                [self navigateToStoreReviewsListing];
                break;
            case RetailerTableViewSectionFriendsLike:
                [self navigateToFriendsLikesWinesListing];
                break;
			default:
				break;
		}
	}
}

- (void)navigateToIntermediate:(NSIndexPath*)indexPath {
    NSMutableArray *arrItems;
    
    USIntermediateTVC *intTVC = [[USIntermediateTVC alloc] initWithStyle:UITableViewStylePlain];
    intTVC.headerTitle = @"Type";
    
    if(indexPath.row == 0){
        arrItems = [NSMutableArray arrayWithObjects:@"Reds", @"Whites", @"Sparkling & Other", nil];
    }else if(indexPath.row == 1){
        arrItems = [NSMutableArray arrayWithObjects:@"Reds", @"Whites", @"Sparkling & Other", nil];
    }else if(indexPath.row == 2){
        intTVC.headerTitle = @"";
        //arrItems = [NSMutableArray arrayWithObjects:@"Reds", @"Whites", @"Sparkling & Other", nil];
    }else if(indexPath.row == 3){
        intTVC.headerTitle = @"Pairing";
        arrItems = [NSMutableArray arrayWithObjects:@"BBQ", @"Beef", @"Cheeses", @"Chocolate", @"Fish", @"Fruit", @"Lamb", @"Pasta", @"Pizza", @"Pork", @"Poultry", @"Salad", @"Shellfish", @"Spicy", @"Sushi", @"Vanilla", nil];
    }
    
    intTVC.arrItems = arrItems;
    [self.navigationController pushViewController:intTVC animated:YES];
}


- (void)navigateToStoreReviewsListing {
    USReviewsListTVC *reviewsListingVC = [[USReviewsListTVC alloc] initWithStyle:UITableViewStylePlain];
    reviewsListingVC.title = @"Store Reviews";
    reviewsListingVC.isViewingUserReviews = NO;
    reviewsListingVC.objReviews = self.objRetailerDetails.storeReviews;
    [self.navigationController pushViewController:reviewsListingVC animated:YES];
}

- (void)navigateToFriendsLikesWinesListing {
    
    if(self.objRetailerDetails.friendLikesCount == 0){
        [self navigateToAddFriendsViewController];
    }else{
        USFriendsLikeWinesVC *objFriendsLikeWinesVC = [[USFriendsLikeWinesVC alloc] init];
        objFriendsLikeWinesVC.placeId = self.objRetailer.retailerId;
        objFriendsLikeWinesVC.filterType = @"liked_wines";
        objFriendsLikeWinesVC.title = @"Friends Like Wines";
        [self.navigationController pushViewController:objFriendsLikeWinesVC animated:YES];
    }
}

#pragma mark - Collection View Data Source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.arrWineTypes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	USWineTypeCollectionCell *cell = (USWineTypeCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentifire forIndexPath:indexPath];
    
    cell.showCounter = YES;
	[cell fillWineTypeCellInfo:[self.arrWineTypes objectAtIndex:indexPath.item]];
	return cell;
}

#pragma mark Collection View Flow Layout Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(89, 89);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *wineType = [self.arrWineTypes objectAtIndex:indexPath.item];
	[self navigateToWineResultViewControllerForWineType:wineType[kTitleKey]];
	DLog(@"Wine Type Selected %@",wineType);
}


#pragma mark - Search Controller Delegates
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    self.searching = YES;
    CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
    self.searchDisplayController.searchBar.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
    self.tableView.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    self.searchString = nil;
    self.objSearchedWines = nil;
    self.searching = NO;
    self.searchDisplayController.searchBar.transform = CGAffineTransformIdentity;
    self.tableView.transform = CGAffineTransformIdentity;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    self.searchString = searchString;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:searchString forKey:queryKey];
    [params setObject:self.objRetailer.retailerId forKey:placeIdKey];
    USSearchOperation *operation = [[USSearchOperation alloc] initWithParams:params
                                                                   searchFor:SearchForWines
                                                                    delegate:self];
    [self.searchQueue cancelAllOperations];
    [self.searchQueue addOperation:operation];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    //this is to handle strange tableview scroll offsets when scrolling the search results
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillHide:(NSNotification*)notification {
    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    UIEdgeInsets inset;
    [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? (inset = UIEdgeInsetsMake(0, 0, height - kTabbarHeight, 0)) : (inset = UIEdgeInsetsZero);
    [tableView setContentInset:inset];
    [tableView setScrollIndicatorInsets:inset];
}

#pragma mark - Search Operation Delegate
- (void)searchOperationCompletedWithObject:(id)object {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.objSearchedWines = (USWines *)object;
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)searchOperationFailed {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if ([scrollView isEqual:self.tableView] || decelerate) return;
	
	[self loadMorePostsIfTableScrolledToLastRecord];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if ([scrollView isEqual:self.tableView]) return;
	
	[self loadMorePostsIfTableScrolledToLastRecord];
}


#pragma mark Navigation
- (void)navigateToAddFriendsViewController {
    USFindFriendVC *findFriends = [[USFindFriendVC alloc] init];
    findFriends.title = @"Find and Invite";
    [self.navigationController pushViewController:findFriends animated:YES];
}

@end
