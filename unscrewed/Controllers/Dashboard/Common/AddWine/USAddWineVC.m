//
//  USAddWineVC.m
//  unscrewed
//
//  Created by Robin Garg on 02/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USAddWineVC.h"
#import "USWines.h"
#import "USSearchOperation.h"
#import "USWineDetailTVC.h"
#import "IBActionSheet.h"
#import "USNewPriceTVC.h"
#import <AlgoliaSearch-Client/ASAPIClient.h>
#import <AlgoliaSearch-Client/ASRemoteIndex.h>

@interface USAddWineVC ()<USSearchOperationCompletionDelegate, IBActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
	ASRemoteIndex *index;
}

@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, assign, getter=isSearching) BOOL searching;
@property (nonatomic, strong) USWines *objSearchedWines;
@property (nonatomic, assign) BOOL gettingWines;
@property (nonatomic, strong) NSOperationQueue *searchQueue;

@property (nonatomic, strong) IBOutlet UIButton *btnSnapPhoto;
- (IBAction)btnSnapPhotoActionEvent;

@end

@implementation USAddWineVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationItem.title = @"Add Wine";
	index = [[kAppDelegate apiClient] getIndex:@"wines_production"];
	
	self.searchQueue = [NSOperationQueue new];
	self.btnSnapPhoto.backgroundColor = [USColor themeSelectedColor];
	
	[self.searchDisplayController.searchBar setPlaceholder:@"Search wines"];
	[self.searchDisplayController.searchResultsTableView setSeparatorColor:[USColor cellSeparatorColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark Pagination
//Load more wines if table view scroll to the end
- (void)loadMorePostsIfTableScrolledToLastRecord {
	NSArray *arrVisibleRows = [self.searchDisplayController.searchResultsTableView indexPathsForVisibleRows];
	NSIndexPath *lastVisibleIndexPath = [arrVisibleRows lastObject];
	if (lastVisibleIndexPath.row == self.objSearchedWines.arrWines.count-1 && self.objSearchedWines.isReachedEnd == NO) {
		if (self.gettingWines == NO) {
			// Get More Wines
			[self loadMoreAutofilWines];
			/*
			NSMutableDictionary *params = [NSMutableDictionary new];
			[params setObject:self.searchString forKey:queryKey];
			[self getWinesWithParam:params];*/
		}
	}
}

#pragma mark Navigation
- (void)navigateToWineDetailsViewControllerForWine:(USWine *)wine {
	USWineDetailTVC *objWineDetailsTVC = [[USWineDetailTVC alloc] initWithStyle:UITableViewStylePlain];
	objWineDetailsTVC.wineId = wine.wineId;
	objWineDetailsTVC.wineName = wine.name;
	[self.navigationController pushViewController:objWineDetailsTVC animated:YES];
}

- (void)navigateToPriceChangeViewControllerWithImage:(UIImage *)image {
	USNewPriceTVC *objNewPriceVC = [[USNewPriceTVC alloc] initWithStyle:UITableViewStyleGrouped];
	objNewPriceVC.title = @"Price Change";
	objNewPriceVC.openFor = OpenForAddWineInRetailer;
	objNewPriceVC.wineImage = image;
	objNewPriceVC.objRetailer = self.objRetailer;
	[self.navigationController pushViewController:objNewPriceVC animated:YES];
}

- (void)openImagePickerForIndex:(NSInteger)index {
	UIImagePickerController *imagePickercontroller = [[UIImagePickerController alloc] init];
	imagePickercontroller.delegate = self;
	if (index == 0) { // Take Photos from Camera
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			imagePickercontroller.sourceType = UIImagePickerControllerSourceTypeCamera;
		} else {
			DLog(@"Camera Functionality not available in Simulator");
			[HelperFunctions showAlertWithTitle:kAlert
										message:@"Camera Functionality not available in this device."
									   delegate:nil
							  cancelButtonTitle:kOk
							   otherButtonTitle:nil];
			return;
		}
	} else { // Take Photos from Photos Gallery
		imagePickercontroller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	[self presentViewController:imagePickercontroller animated:YES completion:nil];
}

- (void)openActionSheetToAddPhoto {
	IBActionSheet *objActionSheet = [[IBActionSheet alloc] initWithTitle:@"Upload Wine Photo" delegate:self cancelButtonTitle:kCancel destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
	
	[objActionSheet setButtonTextColor:[USColor actionSheetDescriptionColor]];
	[objActionSheet setTitleTextColor:[USColor actionSheetTitleColor]];
	[objActionSheet setCancelButtonTextColor:[USColor themeSelectedColor]];
	
	[objActionSheet setCancelButtonFont:[USFont actionSheetCancelFont]];
	[objActionSheet showInView:[[[kAppDelegate window] rootViewController] view]];
}

#pragma mark - $$ WEB SERVICES $$
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

#pragma mark - $$ EVENT HANDLER $$
- (IBAction)btnSnapPhotoActionEvent {
	[self openActionSheetToAddPhoto];
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	return self.objSearchedWines.arrWines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44.f;
}

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	DLog(@"Wine Filter selected at Index = %li",(long)indexPath.row);
	
	USWine *wine = [self.objSearchedWines.arrWines objectAtIndex:indexPath.row];
	[self navigateToWineDetailsViewControllerForWine:wine];
}

#pragma mark - Search Controller Delegates
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
	self.searching = YES;
	CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
	self.searchDisplayController.searchBar.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
	self.searchString = nil;
	self.objSearchedWines = nil;
	self.searching = NO;
	self.searchDisplayController.searchBar.transform = CGAffineTransformIdentity;
}



/*-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	self.searchString = searchString;
	NSMutableDictionary *params = [NSMutableDictionary new];
	[params setObject:searchString forKey:queryKey];
	USSearchOperation *operation = [[USSearchOperation alloc] initWithParams:params
																   searchFor:SearchForWines
																	delegate:self];
	[self.searchQueue cancelAllOperations];
	[self.searchQueue addOperation:operation];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	return NO;
}*/

- (void)loadMoreAutofilWines {
	self.gettingWines = YES;
	
	ASQuery *query = [ASQuery queryWithFullTextQuery:self.searchString];
	query.page = self.objSearchedWines.currentPage+1;
	query.hitsPerPage = DATA_PAGE_SIZE;
	[[HelperFunctions sharedInstance] showProgressIndicator];
	[index search:query success:^(ASRemoteIndex *index, ASQuery *query, NSDictionary *result) {
		[[HelperFunctions sharedInstance] hideProgressIndicator];
		[self.objSearchedWines parseAutofillWinesWithResult:result];
		[self.searchDisplayController.searchResultsTableView reloadData];
		self.gettingWines = NO;
	} failure:^(ASRemoteIndex *index, ASQuery *query, NSString *errorMessage) {
		DLog(@"error = %@",errorMessage);
		[[HelperFunctions sharedInstance] hideProgressIndicator];
		self.gettingWines = NO;
	}];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	self.searchString = searchString;
	if (searchString.length >= 3) {
		self.gettingWines = YES;
		
		ASQuery *query = [ASQuery queryWithFullTextQuery:searchString];
		query.hitsPerPage = DATA_PAGE_SIZE;
		[[HelperFunctions sharedInstance] showProgressIndicator];
		[index search:query success:^(ASRemoteIndex *index, ASQuery *query, NSDictionary *result) {
			[[HelperFunctions sharedInstance] hideProgressIndicator];
			self.objSearchedWines = nil;
			self.objSearchedWines = [USWines new];
			[self.objSearchedWines parseAutofillWinesWithResult:result];
			[self.searchDisplayController.searchResultsTableView reloadData];
			self.gettingWines = NO;
		} failure:^(ASRemoteIndex *index, ASQuery *query, NSString *errorMessage) {
			DLog(@"error = %@",errorMessage);
			[[HelperFunctions sharedInstance] hideProgressIndicator];
			self.gettingWines = NO;
		}];
	}
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

#pragma mark - Live Search Operation Delegate
- (void)searchOperationCompletedWithObject:(id)object {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	self.objSearchedWines = (USWines *)object;
	[self.searchDisplayController.searchResultsTableView reloadData];
	if (self.objSearchedWines.arrWines.count) {
		[self.searchDisplayController.searchResultsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}
}

- (void)searchOperationFailed {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[self loadMorePostsIfTableScrolledToLastRecord];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self loadMorePostsIfTableScrolledToLastRecord];
}

#pragma mark Image Picker View Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	[self dismissViewControllerAnimated:YES completion:^{
		[self navigateToPriceChangeViewControllerWithImage:originalImage];
	}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark IBActionSheet Delegate Method
-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex > 1) return;
	[self openImagePickerForIndex:buttonIndex];
}

@end
