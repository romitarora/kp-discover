
//
//  USWineDetailTVC.m
//  unscrewed
//
//  Created by Rav Chandra on 21/08/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USWineDetailTVC.h"
#import "USWineDetails.h"
#import "USWines.h"
#import "USWineDetails.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "SAMStarListView.h"
#import "USLoginVC.h"
#import "USUserComment.h"
#import "WineDetailShopCell.h"
#import "USReviewVC.h"
#import "USRetailersListTVC.h"
#import "USReviewsListTVC.h"

#import "USWineImageCell.h"
#import "USExpertWineDetailCell.h"
#import "USFriendsFollowingCell.h"
#import "USUserRatingCell.h"
#import "USAboutWineCell.h"
#import "USFindItCell.h"
#import "USMeAndWineCell.h"

#import "USExpertReviewsTVC.h"
#import "USReview.h"

#import "USGalleryViewController.h"

#import "USFindFriendVC.h"

typedef NS_ENUM(NSInteger, WineDetailsViewSection) {
	WineDetailsViewSectionImageAndPrice = 0,
	WineDetailsViewSectionExpertReviews = 1,
	WineDetailsViewSectionFriends = 2,
	WineDetailsViewSectionUserRatings = 3,
	WineDetailsViewSectionWineDetail = 4,
	WineDetailsViewSectionFindIt = 5,
	WineDetailsViewSectionMe = 6,
	WineDetailsViewSectionAddExpertReviewOrError = 7,
};

@interface USWineDetailTVC ()<USWineMeAndThisWineDelegate, USWineImageCellDelegate, USReviewVCDelegate>

@property (nonatomic, strong) USWineDetails *objWineDetails;

@property (nonatomic, strong) NSDictionary *wine;
@property (nonatomic, strong) NSArray *friendsComments;
@property (nonatomic, strong) NSArray *friendsLikes;
@property (nonatomic, strong) NSArray *userComments;
@property (nonatomic, strong) NSMutableArray *friendsAndFollowing;

@property NSInteger wineStarRatingCurrentValue; // 0 if never rated or value persisted on last visit
@property (nonatomic, strong) SAMStarListView *wineStarRatingView;
@property (nonatomic, strong) UITextView *userWineReviewTextView;
@property (nonatomic, strong) NSString *userWineReviewTextCurrentValue;  // empty if never rated or value persisted on last visit

@end

@implementation USWineDetailTVC

- (void)viewDidLoad {
	[super viewDidLoad];

    self.title = self.wineName;
    
	UITapGestureRecognizer *tap =
	    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
	tap.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:tap];
	
    // share icon on top right
	UIBarButtonItem *barButtonShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(barButtonShareTappedEvent)];
    self.navigationItem.rightBarButtonItem = barButtonShare;
    
    [self registerCellsWithTableview];
	[self.tableView setSeparatorColor:[USColor cellSeparatorColor]];

	//[self fetchWineFromApi];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self getWineDetails];
}

- (void)dismissKeyboard:(UITapGestureRecognizer *)sender {
	[self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
#pragma mark - $$ HELPER METHODS $$
#pragma mark Register Cells
- (void)registerCellsWithTableview {
	// Wine Image and Price
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USWineImageCell class]) bundle:nil]
		 forCellReuseIdentifier:@"WineDetailViewImageCell"];
	
    // experts cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USExpertWineDetailCell class]) bundle:nil] forCellReuseIdentifier:@"USExpertWineDetailCell"];
    
    // friends and following cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USFriendsFollowingCell class]) bundle:nil] forCellReuseIdentifier:@"USFriendsFollowingCell"];
    
    // user rating cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USUserRatingCell class]) bundle:nil] forCellReuseIdentifier:@"USUserRatingCell"];
    
    // about wine cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USAboutWineCell class]) bundle:nil] forCellReuseIdentifier:@"USAboutWineCell"];

    // find it
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USFindItCell class]) bundle:nil] forCellReuseIdentifier:@"USFindItCell"];
	
	// Me and This Wine Cell
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USMeAndWineCell class]) bundle:nil] forCellReuseIdentifier:@"WineDetailViewMeAndWineCell"];
	
}

#pragma mark Navigation
- (void)navigateToAddFriendsViewController {
	USFindFriendVC *findFriends = [[USFindFriendVC alloc] init];
	findFriends.title = @"Find and Invite";
	[self.navigationController pushViewController:findFriends animated:YES];
}

- (void)navigateToAddExpertReviewOrReportError:(NSIndexPath *)indexPath {
	NSLog(@"EXPERT");
	
	NSString *emailAddress;
	NSString *subject;
	NSString *message;
	if (indexPath.row == 0) {	// Add an Expert Review
		emailAddress = @"admin@unscrewed.com";
		subject      = @"Expert Review";
		message      = self.objWineDetails.objWineDetail.name;
	} else {					// Report an Error
		emailAddress = @"support@unscrewed.com";
		subject      = @"Report an Error";
		message      = [NSString stringWithFormat:@"Error Regarding %@", self.objWineDetails.objWineDetail.name];
	}// Open email client
	[[HelperFunctions sharedInstance] sendEmailTo:emailAddress
									  withSubject:subject
									  withMessage:message
								 forNavController:self.navigationController];
}

- (void)navigateToExpertReviews:(NSIndexPath *)indexPath {
	if (self.objWineDetails.objWineDetail.objExpertReviews &&
		self.objWineDetails.objWineDetail.objExpertReviews.arrExpertReviews.count) {
		USExpertReview *review = [self.objWineDetails.objWineDetail.objExpertReviews.arrExpertReviews objectAtIndex:indexPath.row];
		USExpertReviewsTVC *objExpertReviewsTVC = [[USExpertReviewsTVC alloc] initWithStyle:UITableViewStylePlain];
		objExpertReviewsTVC.expertReview = review;
		//        objExpertReviewsTVC.objExpertReviews = self.objWineDetails.objWineDetail.objExpertReviews;
		[self.navigationController pushViewController:objExpertReviewsTVC animated:YES];
	} else {
		[HelperFunctions showAlertWithTitle:kAlert
									message:@"There is no expert reviews\n for this wine yet."
								   delegate:nil
						  cancelButtonTitle:kOk
						   otherButtonTitle:nil];
	}
}

- (void)navigateToFindItDetails:(NSIndexPath *)indexPath {
	if ((indexPath.row == 0 && !self.objWineDetails.objWineDetail.minPrice) ||
		(indexPath.row == 1 && !self.objWineDetails.objWineDetail.onlineAveragePrice)) {
		return;
	}
	
	USRetailersListTVC *retailerVC = [[USRetailersListTVC alloc] initWithStyle:UITableViewStylePlain];
	if (indexPath.row == 0) { // near by row
		retailerVC.title = @"Nearby";
		retailerVC.isViewingOnline = NO;
	} else {
		retailerVC.title = @"Online";
		retailerVC.isViewingOnline = YES;
	}
	retailerVC.wineId = self.objWineDetails.objWineDetail.wineId;
	[self.navigationController pushViewController:retailerVC animated:YES];
}

- (void)navigateToUserReviews:(NSIndexPath *)indexPath {
	USReviewsListTVC *reviewsListingVC = [[USReviewsListTVC alloc] initWithStyle:UITableViewStylePlain];
	if (indexPath.section == 2) { // friends & followings
		
		
		reviewsListingVC.title = @"Friends & Following";
		reviewsListingVC.isViewingUserReviews = NO;
		reviewsListingVC.showHelp = NO;
		reviewsListingVC.objReviews = self.objWineDetails.objWineDetail.objFriendReviews;
	} else { // user reviews
		reviewsListingVC.title = @"User Reviews";
		reviewsListingVC.isViewingUserReviews = YES;
		reviewsListingVC.showHelp = YES;
		reviewsListingVC.objReviews = self.objWineDetails.objWineDetail.objUsersReviews;
		
		
	}
	[self.navigationController pushViewController:reviewsListingVC animated:YES];
}

- (void)navigateToWineReviewViewWithReviewText:(NSString *)reviewText {
	USReviewVC *objReviewVC = [[USReviewVC alloc] init];
	objReviewVC.objectId = self.objWineDetails.objWineDetail.wineId;
	objReviewVC.objReview = self.objWineDetails.objWineDetail.myReview;
	objReviewVC.delegate = self;
	objReviewVC.reviewType = ReviewTypeWine;
	[self.navigationController pushViewController:objReviewVC animated:YES];
}

#pragma mark - $$ EVENT HANDLER $$
#pragma mark Share Wine Button Actions Event
- (void)barButtonShareTappedEvent {
    DLog(@"open share action sheet");
        NSArray * activities = @[UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePostToTwitter,UIActivityTypePostToFacebook];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activities applicationActivities:nil];
    activityVC.excludedActivityTypes = [[NSArray alloc] initWithObjects:
                                        UIActivityTypePostToWeibo,
                                        UIActivityTypePrint,
                                        UIActivityTypeAssignToContact,
                                        nil];
    [self presentViewController:activityVC animated:YES completion:^{
        // handle completion here
    }];
}

#pragma mark - $$ WEB SERVICES $$
#pragma mark Get Wine Details
- (void)getWineDetailsFailureHandlerWithError:(id)error {
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

- (void)getWineDetailsSuccessHandlerWithInfo:(USWineDetail *)detail {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
    self.objWineDetails.objWineDetail = detail;
    
	self.friendsComments = [self.wine objectForKey:@"friend_comments"];
//    self.friendsLikes = detail.arrFriendsLikes ;// [self.wine objectForKey:@"friend_likes"];
	self.userComments = [self.wine objectForKey:@"user_comments"];
	
	[self.tableView reloadData];
}

- (void)getWineDetails {
	[[HelperFunctions sharedInstance] showProgressIndicator];
	self.objWineDetails = [USWineDetails new];
	[self.objWineDetails getWineDetailsForWineId:self.wineId
										  target:self
									  completion:@selector(getWineDetailsSuccessHandlerWithInfo:)
										 failure:@selector(getWineDetailsFailureHandlerWithError:)];
}

#pragma mark Like/Unlike Wine
- (void)likeUnlikeWineFailureHandlerWithError:(id)error {
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

- (void)likeUnlikeWineSuccessHandlerWithInfo:(NSNumber *)liked {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	self.objWineDetails.objWineDetail.liked = [liked boolValue];
	
	USWineImageCell *imageCell = (USWineImageCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	if (imageCell) {
		[imageCell updateWineLikeStatusTo:liked.boolValue];

	}
	USMeAndWineCell *meCell = (USMeAndWineCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:6]];
	if (meCell) {
		[meCell updateWineLikeStatusTo:liked.boolValue];
	}
}

- (void)likeUnlikeWine {
	[[HelperFunctions sharedInstance] showProgressIndicator];
	USWines *objWines = [USWines new];
	if (self.objWineDetails.objWineDetail.liked) { // Previously Liked Unlike Wine
		[objWines unlikeWineWithId:self.objWineDetails.objWineDetail.wineId
							target:self
						completion:@selector(likeUnlikeWineSuccessHandlerWithInfo:)
						   failure:@selector(likeUnlikeWineFailureHandlerWithError:)];
	} else { // Like Wine
		[objWines likeWineWithId:self.objWineDetails.objWineDetail.wineId
						  target:self
					  completion:@selector(likeUnlikeWineSuccessHandlerWithInfo:)
						 failure:@selector(likeUnlikeWineFailureHandlerWithError:)];
	}
}

#pragma mark Want Wine
- (void)wantWineFailureHandlerWithError:(id)error {
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

- (void)wantWineSuccessHandlerWithInfo:(NSNumber *)wants {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	self.objWineDetails.objWineDetail.wants = [wants boolValue];
	
	USWineImageCell *imageCell = (USWineImageCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	if (imageCell) {
		[imageCell updateWineWantStatusTo:wants.boolValue];
	}
	USMeAndWineCell *meCell = (USMeAndWineCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:6]];
	if (meCell) {
		[meCell updateWineWantStatusTo:wants.boolValue];
	}
}

- (void)wantWine {
	[[HelperFunctions sharedInstance] showProgressIndicator];
	USWines *objWines = [USWines new];
	if (self.objWineDetails.objWineDetail.wants) { // Previously Wanted remove from wants Wine
		[objWines removeWantWineWithId:self.objWineDetails.objWineDetail.wineId
								target:self
							completion:@selector(wantWineSuccessHandlerWithInfo:)
							   failure:@selector(wantWineFailureHandlerWithError:)];
	} else { // Want Wine
		[objWines wantWineWithId:self.objWineDetails.objWineDetail.wineId
						  target:self
					  completion:@selector(wantWineSuccessHandlerWithInfo:)
						 failure:@selector(wantWineFailureHandlerWithError:)];
	}
}

#pragma mark Rate Wine
- (void)rateWineFailureHandlerWithError:(id)error {
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
- (void)rateWineSuccessHandlerWithInfo:(USReview *)review {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	self.objWineDetails.objWineDetail.myReview = review;
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],
											 [NSIndexPath indexPathForRow:0 inSection:6]]
						  withRowAnimation:UITableViewRowAnimationNone];
}
- (void)rateWineWithInfo:(NSDictionary *)param {
	[[HelperFunctions sharedInstance] showProgressIndicator];
	USWines *objWines = [USWines new];
	[objWines rateWineWithId:self.objWineDetails.objWineDetail.wineId
					   param:param
					  target:self
				  completion:@selector(rateWineSuccessHandlerWithInfo:)
					 failure:@selector(rateWineFailureHandlerWithError:)];
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    switch (section) {
        case WineDetailsViewSectionFindIt:
            return 2;
		case WineDetailsViewSectionExpertReviews:
			return self.objWineDetails.objWineDetail.objExpertReviews.arrExpertReviews.count;
		case WineDetailsViewSectionAddExpertReviewOrError: // +1 -> Add an Expert Review	+1-> Report an Error
			return 2;
        default:
            return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case WineDetailsViewSectionImageAndPrice: // wine image
			return 334.f;
        case WineDetailsViewSectionExpertReviews: // experts
			if (indexPath.row == 0) {
				return 85;
			}
            return 60;
        case WineDetailsViewSectionFriends: // friends & followings
            return 85;
        case WineDetailsViewSectionUserRatings: // users
            return 105;
        case WineDetailsViewSectionWineDetail: // about
            return [USAboutWineCell heightWithWineDetail:self.objWineDetails.objWineDetail];
        case WineDetailsViewSectionFindIt: // find it
			return (indexPath.row ? 63.f: 99.f);
        case WineDetailsViewSectionMe: // me and this wine
            return 208;
        case WineDetailsViewSectionAddExpertReviewOrError: // add an expert & report an error
            return 63;
    }
	return 0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Set seperator inset
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		switch (indexPath.section) {
			case WineDetailsViewSectionImageAndPrice: // Image and Price
			case WineDetailsViewSectionMe: // Me and And This Wine
			case WineDetailsViewSectionAddExpertReviewOrError: // Expert Review and Report Error
				[cell setSeparatorInset:UIEdgeInsetsZero];
				break;
			default:
				[cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
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
			case WineDetailsViewSectionImageAndPrice: // Image and Price
			case WineDetailsViewSectionMe: // Me and And This Wine
			case WineDetailsViewSectionAddExpertReviewOrError: // Expert Review and Report Error
				[cell setLayoutMargins:UIEdgeInsetsZero];
				break;
			default:
				[cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
				break;
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case WineDetailsViewSectionImageAndPrice: // wine image
            return [self buildWineImageCell];
        case WineDetailsViewSectionExpertReviews: // experts
            return [self buildExpertsCell:indexPath];
        case WineDetailsViewSectionFriends: // friends and following
            return [self buildFriendsAndFollowingsCell:indexPath];
        case WineDetailsViewSectionUserRatings: // users rating
            return [self buildUsersRatingCell:indexPath];
        case WineDetailsViewSectionWineDetail: // about wine
            return [self buildAboutWineCell:indexPath];
        case WineDetailsViewSectionFindIt: // find it
            return [self buildFindItCell:indexPath];
        case WineDetailsViewSectionMe: // me and this wine
            return [self buildMeAndThisWineCellForIndexPath:indexPath];
        default:// add expert reivew or report error
            return [self buildAddExpertReviewOrAddErrorCellForIndexPath:indexPath];
    }
}

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case WineDetailsViewSectionExpertReviews:
            [self navigateToExpertReviews:indexPath];
            break;
        case WineDetailsViewSectionFriends:
		{
            
            if(self.objWineDetails.objWineDetail.objFriendReviews.arrReviews.count == 0){
                [self navigateToAddFriendsViewController];
            }
            
			if (self.objWineDetails.objWineDetail.objFriendReviews.arrReviews.count) {
				[self navigateToUserReviews:indexPath];
			}
		}
			break;
		case WineDetailsViewSectionUserRatings:
		{
			if (self.objWineDetails.objWineDetail.objUsersReviews.arrReviews.count) {
				[self navigateToUserReviews:indexPath];
			}
		}
            break;
        case WineDetailsViewSectionFindIt:
            [self navigateToFindItDetails:indexPath];
            break;
        case WineDetailsViewSectionAddExpertReviewOrError:
            [self navigateToAddExpertReviewOrReportError:indexPath];
            break;
        default:
            break;
    }
}

#pragma mark Me and This Wine Delegate
- (void)likeWineSelected {
	[self likeUnlikeWine];
}

- (void)wantWineSelected {
	[self wantWine];
}
- (void)rateWineChangedToNewRate:(NSNumber*)rate {
	NSString *reviewTitle = self.objWineDetails.objWineDetail.myReview.reviewTitle;
	NSString *reviewDesc = self.objWineDetails.objWineDetail.myReview.reviewDescription;
	if (!reviewTitle) {
		reviewTitle = kEmptyString;
	}
	if (!reviewDesc) {
		reviewDesc = kEmptyString;
	}
	NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:reviewTitle, titleKey, reviewDesc, bodyKey, rate, ratingKey, nil];
	[self rateWineWithInfo:dictionary];
}

- (void)reviewWineTextViewSelectedWithText:(NSString *)text {
	if ([[self.navigationController topViewController] isKindOfClass:[USReviewVC class]] == NO) {
		[self navigateToWineReviewViewWithReviewText:text];
	}
}

#pragma mark Image and Price Delegate
- (void)likeWineSelectedOnImageCell {
	[self likeUnlikeWine];
}

- (void)wantWineSelectedOnImageCell {
	[self wantWine];
}

- (void)rateWineChangedOnImageCellToNewRate:(NSNumber*)rate {
	NSString *reviewTitle = self.objWineDetails.objWineDetail.myReview.reviewTitle;
	NSString *reviewDesc = self.objWineDetails.objWineDetail.myReview.reviewDescription;
	if (!reviewTitle) {
		reviewTitle = kEmptyString;
	}
	if (!reviewDesc) {
		reviewDesc = kEmptyString;
	}
	NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:reviewTitle, titleKey, reviewDesc, bodyKey, rate, ratingKey, nil];
	[self rateWineWithInfo:dictionary];
}

- (void)findItOptionSelectedOnImageCell {
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5]
						  atScrollPosition:UITableViewScrollPositionTop
								  animated:YES];
}

- (void)onlineOptionSelectedOnImageCell {
    [self navigateToFindItDetails:[NSIndexPath indexPathForRow:1 inSection:WineDetailsViewSectionFindIt]];
}

- (void)nearbyOptionSelectedOnImageCell {
    [self navigateToFindItDetails:[NSIndexPath indexPathForRow:0 inSection:WineDetailsViewSectionFindIt]];
}

- (void)wineImageSelected:(UIImage *)image {
    if ([self.navigationController presentedViewController] &&
        [[self.navigationController presentedViewController] isKindOfClass:[USGalleryViewController class]]) {
        return;
    }

    if (image) {
        USGalleryViewController *galleryVC = [[USGalleryViewController alloc] initWithNibName:@"USGalleryViewController" bundle:nil];
        galleryVC.image = image;
        galleryVC.hidesBottomBarWhenPushed = YES;
        [UIView transitionWithView:kAppDelegate.window
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.navigationController presentViewController:galleryVC animated:NO completion:nil];
                        }
                        completion:nil];
    }
}


#pragma mark Review Cell Delegate 
- (void)reviewPostedSuccessfullyWithUpdatedReview:(USReview *)objReview {
	[self.navigationController popViewControllerAnimated:YES];
	self.objWineDetails.objWineDetail.myReview = objReview;
	USMeAndWineCell *cell = (USMeAndWineCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:6]];
	[cell updateReviewWineTextTo:objReview.reviewTitle];
}

#pragma mark - CELLS
- (USWineImageCell *)buildWineImageCell {
	USWineImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"WineDetailViewImageCell"];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	cell.delegate = self;
	[cell fillWineImageInfo:self.objWineDetails.objWineDetail indexPath:nil];
	return cell;
}

- (USExpertWineDetailCell *)buildExpertsCell:(NSIndexPath *)indexPath {
    USExpertWineDetailCell *expertsCell = (USExpertWineDetailCell *)[self.tableView dequeueReusableCellWithIdentifier:@"USExpertWineDetailCell" forIndexPath:indexPath];
	USExpertReview *objReview = [self.objWineDetails.objWineDetail.objExpertReviews.arrExpertReviews objectAtIndex:indexPath.row];
    [expertsCell fillExpertInfo:objReview indexPath:indexPath];
    expertsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return expertsCell;
}

- (USFriendsFollowingCell *)buildFriendsAndFollowingsCell:(NSIndexPath *)indexPath {
    USFriendsFollowingCell *friendsAndFollowingCell = (USFriendsFollowingCell *)[self.tableView dequeueReusableCellWithIdentifier:@"USFriendsFollowingCell" forIndexPath:indexPath];
    [friendsAndFollowingCell fillFriendsInfo:self.objWineDetails.objWineDetail];
	friendsAndFollowingCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_disclosure"]];
    return friendsAndFollowingCell;
}

- (USUserRatingCell *)buildUsersRatingCell:(NSIndexPath *)indexPath {
    USUserRatingCell *usersRatingCell = (USUserRatingCell *)[self.tableView dequeueReusableCellWithIdentifier:@"USUserRatingCell" forIndexPath:indexPath];
    [usersRatingCell fillUserRatingInfo:self.objWineDetails.objWineDetail];
	usersRatingCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_disclosure"]];
    return usersRatingCell;
}

- (USAboutWineCell *)buildAboutWineCell:(NSIndexPath *)indexPath {
    USAboutWineCell *aboutWineCell = (USAboutWineCell *)[self.tableView dequeueReusableCellWithIdentifier:@"USAboutWineCell" forIndexPath:indexPath];
    aboutWineCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [aboutWineCell fillAboutSection:self.objWineDetails.objWineDetail];
    return aboutWineCell;
}

- (USFindItCell *)buildFindItCell:(NSIndexPath *)indexPath {
    USFindItCell *findItCell = (USFindItCell *)[self.tableView dequeueReusableCellWithIdentifier:@"USFindItCell" forIndexPath:indexPath];
    [findItCell fillFindItInfo:self.objWineDetails.objWineDetail forIndex:indexPath.row];
    return findItCell;
}
    
- (USMeAndWineCell *)buildMeAndThisWineCellForIndexPath:(NSIndexPath *)indexPath {
	USMeAndWineCell *meAndWineCell = (USMeAndWineCell *)[self.tableView dequeueReusableCellWithIdentifier:@"WineDetailViewMeAndWineCell" forIndexPath:indexPath];
	meAndWineCell.selectionStyle = UITableViewCellSelectionStyleNone;
	meAndWineCell.delegate = self;
	[meAndWineCell fillMeAndWineInfo:self.objWineDetails.objWineDetail indexPath:indexPath];
	
	return meAndWineCell;
}

- (UITableViewCell *)buildAddExpertReviewOrAddErrorCellForIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellReuseIdentifire = @"LastSectionCellReuseIdentifire";
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellReuseIdentifire];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifire];
		[cell.textLabel setTextAlignment:NSTextAlignmentCenter];
		[cell.textLabel setTextColor:[USColor themeSelectedColor]];
		[cell.textLabel setFont:[USFont wineDetailsReportSectionFont]];
	}
	if (indexPath.row == 0) {
		[cell.textLabel setText:@"Add an Expert Review"];
	} else {
		[cell.textLabel setText:@"Report an Error"];
	}
	return cell;
}

#pragma mark - OLD CODE
- (UITableViewCell *)buildWinePricesCell {
	UITableViewCell *cell =
	    [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];

	UILabel *averagePriceLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 5, 70, 21)];

	[averagePriceLabel setFont:[UIFont systemFontOfSize:12]];
	averagePriceLabel.text =
	    [NSString stringWithFormat:@"$%.2f",
	     [[[self.wine objectForKey:@"wine"] objectForKey:@"avg_price"] floatValue] /
	     100];
	[cell addSubview:averagePriceLabel];

	UILabel *averagePriceTitleLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 22, 70, 21)];
	[averagePriceTitleLabel setFont:[UIFont systemFontOfSize:12]];
	averagePriceTitleLabel.text = @"Average";
	[cell addSubview:averagePriceTitleLabel];

	UILabel *onlinePriceLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(90, 5, 70, 21)];
	[onlinePriceLabel setFont:[UIFont systemFontOfSize:12]];
	onlinePriceLabel.textColor = [UIColor redColor];
	onlinePriceLabel.text =
	    [NSString stringWithFormat:@"$%.2f",
	     [[[self.wine objectForKey:@"wine"] objectForKey:@"online_avg_price"]
	  floatValue] / 100];
	[cell addSubview:onlinePriceLabel];

	UILabel *onlinePriceTitleLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(90, 22, 70, 21)];
	[onlinePriceTitleLabel setFont:[UIFont systemFontOfSize:12]];
	onlinePriceTitleLabel.text = @"Online";
	[cell addSubview:onlinePriceTitleLabel];

	UILabel *nearbyPriceLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 70, 21)];
	[nearbyPriceLabel setFont:[UIFont systemFontOfSize:12]];
	nearbyPriceLabel.textColor = [UIColor redColor];
	if ([[self.wine objectForKey:@"in_stock_nearby"] isEqual:[NSNull null]]) {
		nearbyPriceLabel.text = @"Price not available";
	}
	else {
		nearbyPriceLabel.text =
		    [NSString stringWithFormat:@"$%.2f",
		     [[[[self.wine objectForKey:@"in_stock_nearby"] objectForKey:@"750ml"]
		 objectForKey:@"lowest_price"] floatValue] / 100];
	}
	[cell addSubview:nearbyPriceLabel];

	UILabel *nearbyPriceTitleLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(160, 22, 70, 21)];
	[nearbyPriceTitleLabel setFont:[UIFont systemFontOfSize:12]];
	nearbyPriceTitleLabel.text = @"Nearby";
	[cell addSubview:nearbyPriceTitleLabel];
	
	UIButton *findIt = [UIButton buttonWithType:UIButtonTypeCustom];
	[findIt setFrame:CGRectMake(235, 15, 80, 30)];
	[findIt setTitleColor:[USColor themeSelectedColor] forState:UIControlStateNormal];
	[findIt.imageView setTintColor:[USColor themeSelectedColor]];
	[findIt.titleLabel setFont:[USFont defaultButtonFont]];
	UIImage *renderedImage = [[UIImage imageNamed:@"places-tab-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[findIt setImage:renderedImage forState:UIControlStateNormal];
	[findIt setTitle:@"Find It" forState:UIControlStateNormal];
	[cell addSubview:findIt];

  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

	return cell;
}

- (UITableViewCell *)buildWineExpertsCellForRowAtIndexPath:(NSIndexPath *)
    indexPath {
	NSDictionary *expertRating =
	    [[self.wine objectForKey:@"expert_ratings"] objectAtIndex:indexPath.row];

	UITableViewCell *cell =
	    [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];

	UILabel *expertRatingLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 5, 70, 21)];

	[expertRatingLabel setFont:[UIFont systemFontOfSize:12]];
	expertRatingLabel.text =
	    [[[expertRating objectForKey:@"rating"] stringValue] stringByAppendingString
		 :
	     @" pts"];
	[cell addSubview:expertRatingLabel];

	UILabel *expertSourceNameLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 22, 200, 21)];
	[expertSourceNameLabel setFont:[UIFont systemFontOfSize:12]];
	expertSourceNameLabel.textColor = [UIColor lightGrayColor];
	expertSourceNameLabel.text =
	    [[expertRating objectForKey:@"expert_source"] objectForKey:@"name"];
	[cell addSubview:expertSourceNameLabel];
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

	return cell;
}

- (UITableViewCell *)buildFriendsAndFollowingCellForRowAtIndexPath:(NSIndexPath
                                                                    *)indexPath {
	UITableViewCell *cell =
	    [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];

	UILabel *friendNameLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 5, 200, 21)];
  
  NSDictionary *userComment = [self.userComments objectAtIndex:indexPath.row];
  NSDictionary *user = [userComment objectForKey:@"user"];
  
	[friendNameLabel setFont:[UIFont systemFontOfSize:12]];
  friendNameLabel.text = [user objectForKey:@"name"];
	[cell addSubview:friendNameLabel];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return cell;
}

- (UITableViewCell *)buildUsersCell {
	//    NSDictionary * ??????????????? = [[self.wine objectForKey:@"???????????????????"] objectAtIndex:indexPath.row];

	UITableViewCell *cell =
	    [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];

  NSDictionary *rawWine = [self.wine objectForKey:@"wine"];

	SAMStarListView *userRatingStarView =
	    [[SAMStarListView alloc] initWithFrame:CGRectMake(18, 14, 80,
	                                                      20) count:5
	                           countOfSelected:[[rawWine objectForKey:@"avg_rating"] longValue] withStrokeColor:[UIColor
	                                                                          yellowColor]];

	userRatingStarView.emptyColor = [UIColor lightGrayColor];
	userRatingStarView.backgroundColor = [UIColor whiteColor];
  userRatingStarView.userInteractionEnabled = NO;

	[cell addSubview:userRatingStarView];

	UILabel *userRatingAverageLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(110, 11, 70, 21)];
	[userRatingAverageLabel setFont:[UIFont systemFontOfSize:15]];
  
  userRatingAverageLabel.text = [[rawWine objectForKey:@"avg_rating"] stringValue];
	[cell addSubview:userRatingAverageLabel];

	UILabel *userRatingMaxValueLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(133, 11, 70, 21)];
	[userRatingMaxValueLabel setFont:[UIFont systemFontOfSize:15]];
	userRatingMaxValueLabel.textColor = [UIColor lightGrayColor];
	userRatingMaxValueLabel.text = @"/5";
	[cell addSubview:userRatingMaxValueLabel];

	UILabel *numberOfUsersLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(150, 11, 100, 21)];
	[numberOfUsersLabel setFont:[UIFont systemFontOfSize:15]];
	numberOfUsersLabel.textColor = [UIColor lightGrayColor];
	numberOfUsersLabel.text =
	    [[@"(" stringByAppendingString : [[rawWine objectForKey:@"ratings_count"] stringValue]] stringByAppendingString:@" users)"];
	[cell addSubview:numberOfUsersLabel];

	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

	return cell;
}

/*
- (UITableViewCell *)buildVarietalAndRegionCell {
	UITableViewCell *cell =
	    [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];

  NSDictionary *rawWine = [self.wine objectForKey:@"wine"];

  NSLog(@"%@", self.wine);
	UILabel *varietalTitleLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 5, 200, 21)];

	[varietalTitleLabel setFont:[UIFont systemFontOfSize:15]];
	varietalTitleLabel.text = @"Syrah (Sur-ah)";
	[cell addSubview:varietalTitleLabel];

	UILabel *varietalDescriptionLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 24, 280, 42)];
	[varietalDescriptionLabel setFont:[UIFont systemFontOfSize:15]];
	varietalDescriptionLabel.textColor = [UIColor lightGrayColor];
	varietalDescriptionLabel.numberOfLines = 0;
	varietalDescriptionLabel.text =
	    @"Red wine. Usually dry, full bodied and pairs with bbq, steak, and poultry.";
	[cell addSubview:varietalDescriptionLabel];

	UILabel *wineRegionLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 70, 280, 21)];
	[wineRegionLabel setFont:[UIFont systemFontOfSize:15]];
	wineRegionLabel.text = @"California > Napa Valley";
	[cell addSubview:wineRegionLabel];

	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

	return cell;
}*/

- (UITableViewCell *)buildRetailersStoresCell {
	UITableViewCell *cell =
	    [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];

	UILabel *storesTitleLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 5, 200, 21)];

	[storesTitleLabel setFont:[UIFont systemFontOfSize:15]];
	storesTitleLabel.text = @"Stores";
	[cell addSubview:storesTitleLabel];

	UILabel *storeNameLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 24, 145, 21)];
	[storeNameLabel setFont:[UIFont systemFontOfSize:14]];
	storeNameLabel.textColor = [UIColor redColor];
	storeNameLabel.text = @"Trader Joes";
	[cell addSubview:storeNameLabel];

	UILabel *storesCountLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(160, 24, 100, 21)];
	[storesCountLabel setFont:[UIFont systemFontOfSize:14]];
	storesCountLabel.textColor = [UIColor lightGrayColor];
	storesCountLabel.text =
	    [[@"+ " stringByAppendingString : @"10"] stringByAppendingString:@" more"];
	[cell addSubview:storesCountLabel];

	UILabel *storePriceLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(260, 15, 200, 21)];
	[storePriceLabel setFont:[UIFont systemFontOfSize:15]];
	storePriceLabel.textColor = [UIColor blackColor];
	storePriceLabel.text = @"$14.00";
	[cell addSubview:storePriceLabel];

	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

	return cell;
}

- (UITableViewCell *)buildRetailersOnlineCell {
	UITableViewCell *cell =
	    [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];

	UILabel *onlineTitleLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 5, 200, 21)];

	[onlineTitleLabel setFont:[UIFont systemFontOfSize:15]];
	onlineTitleLabel.text = @"Online";
	[cell addSubview:onlineTitleLabel];

	UILabel *onlineNameLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 24, 145, 21)];
	[onlineNameLabel setFont:[UIFont systemFontOfSize:14]];
	onlineNameLabel.textColor = [UIColor redColor];
	onlineNameLabel.text = @"Wine.com";
	[cell addSubview:onlineNameLabel];

	UILabel *onlineCountLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(160, 24, 100, 21)];
	[onlineCountLabel setFont:[UIFont systemFontOfSize:14]];
	onlineCountLabel.textColor = [UIColor lightGrayColor];
	onlineCountLabel.text =
	    [[@"+ " stringByAppendingString : @"398"] stringByAppendingString:@" more"];
	[cell addSubview:onlineCountLabel];

	UILabel *onlinePriceLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(260, 15, 200, 21)];
	[onlinePriceLabel setFont:[UIFont systemFontOfSize:15]];
	onlinePriceLabel.textColor = [UIColor blackColor];
	onlinePriceLabel.text = @"9.00";
	[cell addSubview:onlinePriceLabel];

	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

	return cell;
}

- (UITableViewCell *)buildRetailersRestaurantsCell {
	UITableViewCell *cell =
	    [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];

	UILabel *restaurantsTitleLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 5, 200, 21)];

	[restaurantsTitleLabel setFont:[UIFont systemFontOfSize:15]];
	restaurantsTitleLabel.text = @"Restaurants & Bars";
	[cell addSubview:restaurantsTitleLabel];

	UILabel *restaurantNameLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 24, 145, 21)];
	[restaurantNameLabel setFont:[UIFont systemFontOfSize:14]];
	restaurantNameLabel.textColor = [UIColor redColor];
	restaurantNameLabel.text = @"Boa Steakhouse";
	[cell addSubview:restaurantNameLabel];

	UILabel *restaurantCountLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(160, 24, 100, 21)];
	[restaurantCountLabel setFont:[UIFont systemFontOfSize:14]];
	restaurantCountLabel.textColor = [UIColor lightGrayColor];
	restaurantCountLabel.text =
	    [[@"+ " stringByAppendingString : @"3"] stringByAppendingString:@" more"];
	[cell addSubview:restaurantCountLabel];

	UILabel *restaurantPriceLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(260, 15, 200, 21)];
	[restaurantPriceLabel setFont:[UIFont systemFontOfSize:15]];
	restaurantPriceLabel.textColor = [UIColor redColor];
	restaurantPriceLabel.text = @"$28.00";
	[cell addSubview:restaurantPriceLabel];

	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

	return cell;
}

- (UITableViewCell *)buildRetailersByTheGlassCell {
	UITableViewCell *cell =
	    [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];

	UILabel *byTheGlassTitleLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 5, 200, 21)];

	[byTheGlassTitleLabel setFont:[UIFont systemFontOfSize:15]];
	byTheGlassTitleLabel.text = @"By the Glass";
	[cell addSubview:byTheGlassTitleLabel];

	UILabel *byTheGlassNameLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(18, 24, 145, 21)];
	[byTheGlassNameLabel setFont:[UIFont systemFontOfSize:14]];
	byTheGlassNameLabel.textColor = [UIColor redColor];
	byTheGlassNameLabel.text = @"Boa Steakhouse";
	[cell addSubview:byTheGlassNameLabel];

	UILabel *byTheGlassCountLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(160, 24, 100, 21)];
	[byTheGlassCountLabel setFont:[UIFont systemFontOfSize:14]];
	byTheGlassCountLabel.textColor = [UIColor lightGrayColor];
	byTheGlassCountLabel.text =
	    [[@"+ " stringByAppendingString : @"4"] stringByAppendingString:@" more"];
	[cell addSubview:byTheGlassCountLabel];

	UILabel *byTheGlassPriceLabel =
	    [[UILabel alloc] initWithFrame:CGRectMake(260, 15, 200, 21)];
	[byTheGlassPriceLabel setFont:[UIFont systemFontOfSize:15]];
	byTheGlassPriceLabel.textColor = [UIColor redColor];
	byTheGlassPriceLabel.text = @"$7.50";
	[cell addSubview:byTheGlassPriceLabel];

	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

	return cell;
}

- (UITableViewCell *)buildFavoriteWantStarReviewCellForTableView:(UITableView *)
    tableView                              cellForRowAtIndexPath:(NSIndexPath *)
    indexPath {
	UITableViewCell *cell =
	    [tableView dequeueReusableCellWithIdentifier:@"FavoriteWantStarReviewCell"
	                                    forIndexPath:indexPath];

	self.wineStarRatingCurrentValue = 0;
	self.wineStarRatingView =
	    [[SAMStarListView alloc] initWithFrame:CGRectMake(170, 17, 80,
	                                                      20) count:5
	                           countOfSelected:0 withStrokeColor:[UIColor
	                                                                        yellowColor]];
	self.wineStarRatingView.emptyColor = [UIColor lightGrayColor];
	self.wineStarRatingView.backgroundColor = [UIColor whiteColor];
	[cell addSubview:self.wineStarRatingView];


	self.userWineReviewTextView =
	    [[UITextView alloc] initWithFrame:CGRectMake(20, 50, 280, 124)];
	self.userWineReviewTextView.returnKeyType = UIReturnKeySend;

	self.userWineReviewTextView.backgroundColor = [UIColor whiteColor];
	self.userWineReviewTextView.layer.borderColor = [[UIColor grayColor]CGColor];
	self.userWineReviewTextView.layer.borderWidth = 0.6f;
	self.userWineReviewTextView.layer.cornerRadius = 5.0f;
	self.userWineReviewTextView.layer.masksToBounds = YES;
	self.userWineReviewTextView.textColor = [UIColor lightGrayColor];
	self.userWineReviewTextView.text = @" ";

	self.userWineReviewTextCurrentValue = self.userWineReviewTextView.text;
	self.userWineReviewTextView.delegate = self;
	[cell addSubview:self.userWineReviewTextView];

	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

	return cell;
}

#pragma mark - Private methods

- (void)fetchWineFromApi {
	NSDictionary *arguments = [[NSDictionary alloc] init];

	NSString *urlString =
	    [@"http://unscrewed-api-staging-2.herokuapp.com/api/wines/"
stringByAppendingString: self.wineId];

	NSURL *baseURL = [NSURL URLWithString:urlString];

	AFHTTPSessionManager *manager =
	    [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];

	manager.responseSerializer = [AFJSONResponseSerializer serializer];

	if ([USLoginVC authToken] != nil) {
		manager.requestSerializer = [AFJSONRequestSerializer serializer];
		[manager.requestSerializer setValue:[USLoginVC authToken] forHTTPHeaderField
										   :@"auth_token"];
	}

	[manager   GET:[baseURL absoluteString]
	    parameters:arguments
	       success: ^(NSURLSessionDataTask *task, id responseObject) {
	    NSDictionary *response = (NSDictionary *)responseObject;

	    self.wine = response;
           
           NSLog(@"%@", self.wine);
           
      
           
           self.friendsComments = [self.wine objectForKey:@"friend_comments"];
           self.friendsLikes = [self.wine objectForKey:@"friend_likes"];
           self.userComments = [self.wine objectForKey:@"user_comments"];
           
           [self.tableView reloadData];
	    //[self populateFriendsAndFollowingArray];
	} failure: ^(NSURLSessionDataTask *task, NSError *error) {
	    UIAlertView *alertView =
	        [[UIAlertView alloc] initWithTitle:
	         @"Error retrieving wine detail"
	                                   message:[error
	                                            localizedDescription
	         ]
	                                  delegate:nil
	                         cancelButtonTitle:@"Ok"
	                         otherButtonTitles:nil];
	    [alertView show];
	}];
}


- (IBAction)favoriteButtonTapped:(UIButton *)button {
	NSString *wineId = [[self.wine objectForKey:@"wine"] objectForKey:@"id"];

	NSDictionary *arguments = [[NSDictionary alloc] init];

	[self doNetworkRequest:arguments wineID:wineId button:button];
}

- (void)doNetworkRequest:(NSDictionary *)arguments wineID:(NSString *)wineId
                  button:(UIButton *)button {
	NSURL *baseURL;
	NSString *xAuthToken;
	BOOL want = NO;

	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"] != nil) {
		xAuthToken =
		    [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
	}

	if ([button.titleLabel.text isEqualToString:@"Save"]) {
		baseURL =   [NSURL URLWithString:[NSString stringWithFormat:
		                                  @"https://unscrewed-api-staging-2.herokuapp.com/api/wines/%@/wants",
		                                  wineId]];
		want = YES;
	}
	else {
		baseURL =
		    [NSURL URLWithString:[NSString stringWithFormat:
		                          @"https://unscrewed-api-staging-2.herokuapp.com/api/wines/%@/likes",
		                          wineId]];
		want = NO;
	}
	AFHTTPSessionManager *manager =
	    [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.requestSerializer = [AFJSONRequestSerializer serializer];

	[manager.requestSerializer setValue:xAuthToken forHTTPHeaderField:
	 @"X-AUTH-TOKEN"];

	if (![button isSelected]) {
		[manager  POST:[baseURL absoluteString]
		    parameters:arguments
		       success: ^(NSURLSessionDataTask *task, id responseObject) {
		    [button setSelected:YES];
		    if (want) {
		        button.backgroundColor = [USColor themeSelectedColor];
			}
		}  failure: ^(NSURLSessionDataTask *task, NSError *error) {
		    UIAlertView *alertView =
		        [[UIAlertView alloc] initWithTitle:
		         @"Error in liking a wine!"
		                                   message:[error
		                                            localizedDescription
		         ]
		                                  delegate:nil
		                         cancelButtonTitle:@"Ok"
		                         otherButtonTitles:nil];
		    [alertView show];
		}];
	}
	else {
		[manager DELETE:[baseURL absoluteString]
		     parameters:arguments
		        success: ^(NSURLSessionDataTask *task, id responseObject) {
		    [button setSelected:NO];
		    if (want) {
		        button.backgroundColor = [UIColor whiteColor];
			}
		}  failure: ^(NSURLSessionDataTask *task, NSError *error) {
		    UIAlertView *alertView =
		        [[UIAlertView alloc] initWithTitle:
		         @"Error in remove a like from a wine!"
		                                   message:[error
		                                            localizedDescription
		         ]
		                                  delegate:nil
		                         cancelButtonTitle:@"Ok"
		                         otherButtonTitles:nil];
		    [alertView show];
		}];
	}
}

- (IBAction)wantButtonTapped:(UIButton *)button {
	NSString *wineId = [[self.wine objectForKey:@"wine"] objectForKey:@"id"];

	NSDictionary *arguments = [[NSDictionary alloc] init];

	[self doNetworkRequest:arguments wineID:wineId button:button];
}

- (id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self) {
		// Custom initialization
	}

	return self;
}

- (void)apiPostRequestWithUrl:(NSString *)url andPostData:(NSDictionary *)
    postData {
	NSURL *baseURL = [NSURL URLWithString:url];
	AFHTTPSessionManager *manager =
	    [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];

	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.requestSerializer = [AFJSONRequestSerializer serializer];
	[manager.requestSerializer setValue:[USLoginVC authToken] forHTTPHeaderField:
	 @"X-AUTH-TOKEN"];

	[manager  POST:[baseURL absoluteString]
	    parameters:postData
	       success: ^(NSURLSessionDataTask *task, id responseObject) {
	    NSDictionary *response = (NSDictionary *)responseObject;

	    NSLog(@"apiPostRequestWithUrl RESPONSE: %@", response);
	} failure: ^(NSURLSessionDataTask *task, NSError *error) {
	    UIAlertView *alertView =
	        [[UIAlertView alloc] initWithTitle:
	         @"Error saving favorite"
	                                   message:[error
	                                            localizedDescription
	         ]
	                                  delegate:nil
	                         cancelButtonTitle:@"Ok"
	                         otherButtonTitles:nil];
	    [alertView show];
	}];
}

#pragma mark - Textview
- (void)textViewDidBeginEditing:(UITextView *)textView {
	[textView becomeFirstResponder];
	[textView setText:@""];
}

- (BOOL)   textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
    replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];

		NSString *wineId = [[self.wine objectForKey:@"wine"] objectForKey:@"id"];

		if (self.wineStarRatingView.countOfSelected != self.wineStarRatingCurrentValue
		    || ![self.userWineReviewTextView.text isEqualToString:self.
		         userWineReviewTextCurrentValue]) {
			NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
			if (self.userWineReviewTextView.text != nil &&
			    ![self.userWineReviewTextView.text isEqualToString:@""]) {
				[postData setObject:self.userWineReviewTextView.text forKey:@"body"];
			}

			[postData setObject:[NSString stringWithFormat:@"%lu",
			                     (unsigned long)self.wineStarRatingView.countOfSelected]
			             forKey:@"rating"];
			[self apiPostRequestWithUrl:[NSString stringWithFormat:
			                             @"https://unscrewed-api-staging-2.herokuapp.com/api/wines/%@/comments",
			                             wineId] andPostData:postData];
		}
		[textView setText:@""];
	}

	return YES;
}

@end
