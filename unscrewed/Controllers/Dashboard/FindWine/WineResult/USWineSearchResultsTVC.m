//
//  USWineSearchResultsTVC.m
//  unscrewed
//
//  Created by Rav Chandra on 22/08/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USWineSearchResultsTVC.h"
#import "USWineSearchResultsCell.h"
#import "USWines.h"
#import "USWineDetailTVC.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "USLoginVC.h"
#import <CoreLocation/CoreLocation.h>
#import "USLocationManager.h"
#import "USLocation.h"
#import "RadioButton.h"
#import "USWineValueRating.h"
#import "UIBarButtonItem+Badge.h"
#import "USNewPriceTVC.h"
#import "USWineFiltersVC.h"
#import "USWineFilters.h"
#import "MyNavigationController.h"
#import "USRetailer.h"
#import "IBActionSheet.h"

static const CGFloat CELL_HEIGHT = 155.f;

@interface USWineSearchResultsTVC ()<SWTableViewCellDelegate, USWineFiltersDelegate, IBActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSInteger _index;
    UIView *mainView;
	UIView *innerView;
	MyNavigationController *navFilter;
}

@property (nonatomic, strong) USWines *objWines;
@property (nonatomic, assign) BOOL gettingWines;

@property (nonatomic, strong) NSMutableArray *wineResults;
@property (nonatomic, strong) NSMutableArray *wineSearchFilters;

@property (nonatomic, strong) USWineFiltersVC *objWineFiltersVC;

@end

@implementation USWineSearchResultsTVC {
	long _selectedIndex;
}

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self)
	{
		// Custom initialization
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.title = self.wineHeaderTitle;

	[self.tableView registerNib:[UINib nibWithNibName:@"USWineSearchResultsCell" bundle:nil] forCellReuseIdentifier:@"USWineSearchResultsCell"];
	[self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
	
	UIButton *buttonFilter = [UIButton buttonWithType:UIButtonTypeCustom];
	[buttonFilter setFrame:CGRectMake(0, 0, 40, 20)];
	[buttonFilter setTitleColor:[USColor themeSelectedColor] forState:UIControlStateNormal];
	[buttonFilter setTitle:@"Filter" forState:UIControlStateNormal];
	[buttonFilter addTarget:self action:@selector(barButtonFilterTappedActionEvent) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButtonFilter = [[UIBarButtonItem alloc] initWithCustomView:buttonFilter];
	barButtonFilter.badgePadding = 0.f;
	[barButtonFilter setBadgeBGColor:[USColor themeSelectedColor]];
	
	[self.navigationItem setRightBarButtonItem:barButtonFilter];
	[self updateFilterBarButtonCount];
	
	if (!self.wineSearchArguments) {
		self.wineSearchArguments = [[NSMutableDictionary alloc] init];
		
		NSString *sparklingQuery;
		if (![self.wineColorSelected isEqualToString:@"Any"])
		{
			if ([self.wineColorSelected isEqualToString:@"sparkling"])
			{
				sparklingQuery =
				[NSString stringWithFormat:@"%@,%@", @"Sparkling",
				 @"Sparkling & Champagne"];
			} else {
				sparklingQuery =
				[NSString stringWithFormat:@"%@", self.wineColorSelected];
			}
			[self.wineSearchArguments setObject:sparklingQuery forKey:filterTypesKey];
		}
	}
	if (self.objRetailer) {
		[self.wineSearchArguments setObject:self.objRetailer.retailerId forKey:
		 @"place_id"];
	}
	[self fetchAPIrequests:self.wineSearchArguments];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark Pagination
//Load more wines if table view scroll to the end
- (void)loadMorePostsIfTableScrolledToLastRecord {
	NSArray *arrVisibleRows = [self.tableView indexPathsForVisibleRows];
	NSIndexPath *lastVisibleIndexPath = [arrVisibleRows lastObject];
	if (lastVisibleIndexPath.row == self.objWines.arrWines.count-1 && self.objWines.isReachedEnd == NO) {
		if (self.gettingWines == NO) {
			// Get More Wines
			[self getWinesWithParam:self.wineSearchArguments];
		}
	}
}

#pragma mark Update Filter Bar Button Count
- (void)updateFilterBarButtonCount {
	NSArray *filterArray = nil;
	if (self.wineHeaderTitle.length) {
		filterArray = [self.wineHeaderTitle componentsSeparatedByString:@", "];
	}
	UIBarButtonItem *barButtonFilter = self.navigationItem.rightBarButtonItem;
	[barButtonFilter setBadgeValue:[NSString stringWithFormat:@"%lu",(unsigned long)filterArray.count]];
	barButtonFilter.badgeOriginX =
	CGRectGetWidth(barButtonFilter.customView.frame) - CGRectGetWidth(barButtonFilter.badge.frame)*0.5 + 4.f;
	DLog(@"%@",NSStringFromCGRect(barButtonFilter.badge.frame));
	barButtonFilter.badgeOriginY = -1 * CGRectGetHeight(barButtonFilter.badge.frame)*0.5 + 1.f;
}

#pragma mark Navigation
- (void)navigateToWineDetailsViewControllerForWine:(USWine *)wine {
	USWineDetailTVC *objWineDetailsTVC = [[USWineDetailTVC alloc] initWithStyle:UITableViewStylePlain];
	objWineDetailsTVC.wineId = wine.wineId;
    objWineDetailsTVC.wineName = wine.name;
	[self.navigationController pushViewController:objWineDetailsTVC animated:YES];
}

#pragma mark Update Filter Params
// Update Filter params with newly selected filters
- (void)updateSearchArgumentsDictBasedOnFilters:(USWineFilters *)wineFilters {
	[self.wineSearchArguments removeAllObjects];
	NSMutableArray *selectedFilters = [NSMutableArray new];
	for (USWineFilter *filter in wineFilters.arrFilters) {
		if (filter.selectedValue) {
			if ([filter.wineFilterKey isEqualToString:filterStylesKey]) {
				USWineFilter *typeFilter = [HelperFunctions wineFilterForKey:filterTypesKey wineFilters:wineFilters];
				NSString *styleType = [NSString stringWithFormat:@"%@ - %@",typeFilter.selectedValue.filterValue, filter.selectedValue.filterValue];
				[self.wineSearchArguments setObject:styleType forKey:filter.wineFilterKey];
			} else {
				[self.wineSearchArguments setObject:filter.selectedValue.filterValue forKey:filter.wineFilterKey];
			}
			[selectedFilters addObject:filter.selectedValue.filterValue];
		}
	}
	//FIXME: Add sort filter after supported by backend.
	// Add Distance filter
	if (wineFilters.distanceFilter.selectedValue) {
		[self.wineSearchArguments setObject:wineFilters.distanceFilter.selectedValue.filterValue forKey:radiusKey];
	}
	if (self.objRetailer) {
		[self.wineSearchArguments setObject:self.objRetailer.retailerId forKey:placeIdKey];
	}
	// Update View Title
	self.wineHeaderTitle = [selectedFilters componentsJoinedByString:@", "];
	self.navigationItem.title = self.wineHeaderTitle;
	// Update Bar Button filter count
	[self updateFilterBarButtonCount];
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
	
	[self.tableView reloadData];
}

- (void)getWinesWithParam:(NSMutableDictionary *)params {
	if (!self.objWines) {
		self.objWines = [USWines new];
	}
	self.gettingWines = YES;
	USLocation *selectedLocation = [[USLocationManager sharedInstance] selectedLocationCordinate];
	if (selectedLocation) {
		[params setObject:selectedLocation.latitudeAsString forKey:latitudeKey];
		[params setObject:selectedLocation.longitudeAsString forKey:longitudeKey];
	}
	[[HelperFunctions sharedInstance] showProgressIndicator];
	[self.objWines getWinesWithParams:params
							   target:self
						   completion:@selector(getWinesSuccessHandlerWithInfo:)
							  failure:@selector(getWinesFailureHandlerWithError:)];
}

#pragma mark Get Wine Filters
- (void)getWineFiltersFailureHandlerWithError:(id)error {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
}

- (void)getWineFiltersSuccessHandlerWithInfo:(USWineFilters *)wineFilters {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	self.objWineFilters = wineFilters;
	[wineFilters fillSortFilterWithSelectedValue:nil];
	[wineFilters fillDistanceFilterWithSelectedValue:nil];
	NSArray *prefilledFilterKeys = [self.wineSearchArguments allKeys];
	for (NSString *key in prefilledFilterKeys) {
		USWineFilter *filter = [HelperFunctions wineFilterForKey:key wineFilters:wineFilters];
		if (filter) {
			if ([filter.wineFilterKey isEqualToString:filterStylesKey]) {
				NSString *selectedValue = self.wineSearchArguments[key];
				NSArray *arrFilterValue = [selectedValue componentsSeparatedByString:@"- "];
				NSString *filterValue = [arrFilterValue lastObject];
				filter.selectedValue = [HelperFunctions filterValueForSelectedValue:filterValue
																			 values:filter.objValues];
			} else {
				filter.selectedValue = [HelperFunctions filterValueForSelectedValue:self.wineSearchArguments[key]
																			 values:filter.objValues];
			}
			if ([key isEqualToString:filterTypesKey]) {
				USWineFilter *styleFilter = [USWineFilters wineStyleFilterForValue:filter.selectedValue];
				if (styleFilter) {
					if ([prefilledFilterKeys containsObject:filterStylesKey]) {
						styleFilter.selectedValue = [HelperFunctions filterValueForSelectedValue:self.wineSearchArguments[filterStylesKey] values:styleFilter.objValues];
					}
					NSUInteger index = [wineFilters.arrFilters indexOfObject:filter];
					[wineFilters.arrFilters insertObject:styleFilter atIndex:index+1];
				}
			}
		}
	}
	self.objWineFilters = wineFilters;
	[self showWineFiltersView];
}
- (void)getWineFilters {
	USWineFilters *objWineFilters = [USWineFilters new];
	[[HelperFunctions sharedInstance] showProgressIndicator];
	[objWineFilters getWineFiltersWithTarget:self
								  completion:@selector(getWineFiltersSuccessHandlerWithInfo:)
									 failure:@selector(getWineFiltersFailureHandlerWithError:)];
}

#pragma mark - $$ EVENT HANDLER $$
#pragma mark Bar Button Action Event
- (void)barButtonFilterTappedActionEvent {
	if (!self.objWineFilters) {
		[self getWineFilters];
	} else {
		[self showWineFiltersView];
	}
}

- (void)showWineFiltersView {
	NSData *filterData = [NSKeyedArchiver archivedDataWithRootObject:self.objWineFilters];
	USWineFilters *filterCopy = [NSKeyedUnarchiver unarchiveObjectWithData:filterData];
	
	self.objWineFiltersVC = [[USWineFiltersVC alloc] initWithNibName:@"USWineFiltersVC" bundle:nil];
	self.objWineFiltersVC.objWineFilters = filterCopy;
	self.objWineFiltersVC.delegate = self;
	self.objWineFiltersVC.isNearByFilters = (self.objRetailer == nil);
	navFilter = [[MyNavigationController alloc] initWithRootViewController:self.objWineFiltersVC];
	
	CGFloat windowHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
	CGFloat windowWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
	
	mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, windowHeight)];
	[mainView setBackgroundColor:[UIColor clearColor]];
	
	innerView = [[UIView alloc] initWithFrame:CGRectMake(windowWidth, 0, windowWidth - kTransparentAreaWidth, windowHeight)];
	[innerView addSubview:navFilter.view];
	[mainView addSubview:innerView];

	UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 20)];
	[statusBarView setBackgroundColor:[UIColor whiteColor]];
	[mainView addSubview:statusBarView];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:CGRectMake(0, 20, kTransparentAreaWidth, windowHeight-20)];
	[button addTarget:self action:@selector(hideWineFiltersView) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor clearColor]];
	[button setEnabled:NO];
	[mainView addSubview:button];
	
    [kAppDelegate.window addSubview:mainView];
	[UIView animateWithDuration:0.3f animations:^{
		[mainView setBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.2f]];
        [innerView setFrame:CGRectMake(kTransparentAreaWidth, 0, windowWidth - kTransparentAreaWidth, windowHeight)];
	} completion:^(BOOL finished) {
		[button setEnabled:YES];
	}];
}

- (void)hideWineFiltersView {
	CGFloat windowHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
	CGFloat windowWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
	[UIView animateWithDuration:0.25f animations:^{
		[mainView setBackgroundColor:[UIColor clearColor]];
        [innerView setFrame:CGRectMake(windowWidth, 0, windowWidth-kTransparentAreaWidth, windowHeight)];
	} completion:^(BOOL finished) {
		self.objWineFiltersVC = nil;
        [mainView removeFromSuperview];
		mainView = nil;
	}];
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark Wine Filter Selection Delegate
- (void)wineFilterSelectionDoneWithObject:(USWineFilters *)filters {
    // Hide Filters View
    [self hideWineFiltersView];

	// Update wine search arguments dict based on new selected filters
	self.objWineFilters = filters;
    
	[self updateSearchArgumentsDictBasedOnFilters:filters];
	
	// Get Wines based on updated Filters
	self.objWines = nil;
	[self getWinesWithParam:self.wineSearchArguments];
}

- (void)wineFilterselectionCanceled {
	[self hideWineFiltersView];
}

- (void)winePreferenceSelectionViewController:(USWinePreferenceSelectionTVC *)controller didFinishSelectingWineSearchFilters:(NSMutableArray *)wineSearchFilters {
	self.wineSearchFilters = wineSearchFilters;
	
	if (self.wineSearchArguments == nil)
	{
		self.wineSearchArguments = [[NSMutableDictionary alloc] init];
	}
	for (USWineSearchFilter *wineSearchFilter in wineSearchFilters)
	{
		if ([wineSearchFilter.filterAttributeValue isEqualToString:@"Any"])
		{
			[self.wineSearchArguments removeObjectForKey:wineSearchFilter.
			 apiFilterName];
		} else {
			[self.wineSearchArguments setObject:wineSearchFilter.filterAttributeValue
										 forKey:wineSearchFilter.apiFilterName];
		}
		
	}
	[self fetchAPIrequests:self.wineSearchArguments];
}

#pragma mark Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.objWines.arrWines.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return CELL_HEIGHT;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	USWineSearchResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USWineSearchResultsCell" forIndexPath:indexPath];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
	USWine *wine = [self.objWines.arrWines objectAtIndex:indexPath.row];
	if (self.objRetailer) {
		cell.wineCellType = WineCellTypeFromRetailer;
		wine.closestPlaceType = self.objRetailer.type;
	} else {
		cell.wineCellType = WineCellTypeNearby;
	}
	[cell fillWineCellWithWineInfo:wine indexPath:indexPath];
	
	return cell;
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[USColor darkMenuOptionColor] title:@"Out"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[USColor mediumDarkMenuOptionColor] title:@"New\nPrice"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[USColor lightDarkMenuOptionColor] title:@"Hide"];
    return rightUtilityButtons;
}

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	USWine *wine = [self.objWines.arrWines objectAtIndex:indexPath.row];
	[self navigateToWineDetailsViewControllerForWine:wine];
}

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexpath;
    switch (index) {
        case 0:
            LogInfo(@"Out clicked");
            indexpath = [self.tableView indexPathForCell:(SWTableViewCell *)cell];
            _index = indexpath.row;
//            [self deleteCell];
            break;
        case 1:
            LogInfo(@"New Price clicked");
            indexpath = [self.tableView indexPathForCell:(SWTableViewCell *)cell];
            _index = indexpath.row;
            [self navigateToNewPricePage];
            break;
        default:
            LogInfo(@"Hide clicked");
            indexpath = [self.tableView indexPathForCell:(SWTableViewCell *)cell];
            
            USWine *wine = [self.objWines.arrWines objectAtIndex:indexpath.row];
            [[NSUserDefaults standardUserDefaults] setObject:wine.name forKey:@"email_wine"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            _index = indexpath.row;
            [self openActionSheetToAddPhoto];
            break;
    }
    [cell hideUtilityButtonsAnimated:YES];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0: {
            NSLog(@"utility buttons closed");
            break; }
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    return YES;
}

#pragma mark IBActionSheet Delegate Method
-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 1) return;
    [self openImagePickerForIndex:buttonIndex];
}
#pragma mark - Open Camera

- (void)openActionSheetToAddPhoto {
    IBActionSheet *objActionSheet = [[IBActionSheet alloc] initWithTitle:@"Upload Wine Photo" delegate:self cancelButtonTitle:kCancel destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
    
    [objActionSheet setButtonTextColor:[USColor actionSheetDescriptionColor]];
    [objActionSheet setTitleTextColor:[USColor actionSheetTitleColor]];
    [objActionSheet setCancelButtonTextColor:[USColor themeSelectedColor]];
    
    [objActionSheet setCancelButtonFont:[USFont actionSheetCancelFont]];
    [objActionSheet showInView:[[[kAppDelegate window] rootViewController] view]];
}
- (void)openImagePickerForIndex:(NSInteger)index{
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

#pragma mark Image Picker View Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        //[self uploadImage:originalImage];
        
        NSString *emailAddress = @"tom@unscrewed.com";
        NSString *subject = @"New Wine";
        NSString *message = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"email_wine"]];
        [[HelperFunctions sharedInstance] sendEmailWithImgTo:emailAddress
                                          withSubject:subject
                                          withMessage:message
                                        withImage:originalImage
                                     forNavController:self.navigationController];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (decelerate) return;
	[self loadMorePostsIfTableScrolledToLastRecord];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self loadMorePostsIfTableScrolledToLastRecord];
}


#pragma mark - Navigation
- (void)navigateToNewPricePage {
    USNewPriceTVC *objNewPriceVC = [[USNewPriceTVC alloc] initWithStyle:UITableViewStyleGrouped];
    objNewPriceVC.title = @"Price Change";
	objNewPriceVC.openFor = OpenForPriceChange;
	if (self.objRetailer) {
		objNewPriceVC.objRetailer = self.objRetailer;
		objNewPriceVC.openFor = OpenForPriceChagneForRetailer;
	}
    [self.navigationController pushViewController:objNewPriceVC animated:YES];
}

#pragma mark - Private methods
- (void)fetchAPIrequests:(NSMutableDictionary *)arguments {
	[self getWinesWithParam:arguments];
}
/*- (void)fetchAPIrequests:(NSMutableDictionary *)arguments {
	
	if (!self.myWines && !self.friends)
	{/ *
	  if ([CLLocationManager locationServicesEnabled])
	  {
	  USLocation *location =
	  [[USLocationManager sharedInstance] currentLocation];
	  [arguments setObject:location.latitudeAsString forKey:@"lat"];
	  [arguments setObject:location.longitudeAsString forKey:@"lng"];
	  }* /
		
 
		
		
		NSURL *baseURL =
		[NSURL URLWithString:
		 @"http://unscrewed-api-staging-2.herokuapp.com/api/wines"
		 ];
		NSMutableArray *wineResultsArray = [[NSMutableArray alloc] init];
		
		AFHTTPSessionManager *manager =
		[[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
		manager.responseSerializer = [AFJSONResponseSerializer serializer];
		
		
		[manager GET:[baseURL absoluteString] parameters:arguments success:^(
																			 NSURLSessionDataTask *task, id responseObject) {
			
			NSDictionary *response = (NSDictionary *)responseObject;
			
			NSArray *wines = [response objectForKey:@"wines"];
			
			for (NSDictionary * wine in wines)
			{
				
				USWine *usWine = [[USWine alloc] init];
				usWine.wineId = [wine objectForKey:@"id"];
				usWine.name =
				[[[wine objectForKey:@"name"] stringByAppendingString:@" "]
				 stringByAppendingString:[wine objectForKey:@"year"]];
				
				NSString *varietal =
				[[wine objectForKey:@"filter_subtypes"] firstObject];
				NSString *varietalFromRegion =
				[[varietal stringByAppendingString:@" from "] stringByAppendingString:
				 [[
				   wine
				   objectForKey:@"filter_regions"] firstObject]];
				usWine.wineDescription = varietalFromRegion;
				
				usWine.averagePrice = [wine objectForKey:@"avg_price"];
				
				if ([wine objectForKey:@"closest_place"] != nil)
				{
					usWine.closestPlaceName =
					[[[wine objectForKey:@"closest_place"] objectForKey:@"place"]
					 objectForKey:@"name"];
					usWine.closestPlace750mlPrice =
					[[[wine objectForKey:@"closest_place"] objectForKey:@"prices"]
					 objectForKey:@"750ml"];
					usWine.closestPlaceDistanceMiles =
					[[wine objectForKey:@"closest_place"] objectForKey:@"distance_in_mi"
					 ];
				}
				
				NSString *imageUrlString =
				[[wine objectForKey:@"photo"] objectForKey:@"url"];
				usWine.wineImageUrl = [NSURL URLWithString:imageUrlString];
				
				usWine.ratingsCount =
				[[wine objectForKey:@"ratings_count"] integerValue];
				if (usWine.ratingsCount > 0)
				{
					usWine.averageRating = [[wine objectForKey:@"avg_rating"] floatValue];
				}
				
				if ([wine objectForKey:@"wine_value"] != nil)
				{
					usWine.wineValueRating =
					[[USWineValueRating alloc] initWithWineValueDictionary:[wine
																			objectForKey
																			:
																			@"wine_value"
																			]];
				}
				
				[wineResultsArray addObject:usWine];
			}
			
			self.wineResults = wineResultsArray;
			[self.tableView reloadData];
			
		}    failure:^(NSURLSessionDataTask *task, NSError *error) {
			
			UIAlertView *alertView =
			[[UIAlertView alloc] initWithTitle:
			 @"Error retrieving wine list"
									   message:[error
												localizedDescription
												]
									  delegate:nil
							 cancelButtonTitle:@"Ok"
							 otherButtonTitles:nil];
			[alertView show];
			
		}];
	} else if (self.myWines) {
		NSURL *baseURL =
		[NSURL URLWithString:
		 @"http://unscrewed-api-staging-2.herokuapp.com/api/user/wines"
		 ];
		NSMutableArray *wineResultsArray = [[NSMutableArray alloc] init];
		
		NSString *xAuthToken;
		
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"] !=
			nil)
		{
			xAuthToken =
			[[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
		}
		
		NSLog(@"%@", xAuthToken);
		
		
		
		AFHTTPSessionManager *manager =
		[[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
		manager.responseSerializer = [AFJSONResponseSerializer serializer];
		manager.requestSerializer = [AFJSONRequestSerializer serializer];
		
		[manager.requestSerializer setValue:xAuthToken forHTTPHeaderField:
		 @"X-AUTH-TOKEN"];
		
		
		[manager GET:[baseURL absoluteString] parameters:arguments success:^(
																			 NSURLSessionDataTask *task, id responseObject) {
			
			NSDictionary *response = (NSDictionary *)responseObject;
			
			NSString *filterType = [self.wineSearchArguments objectForKey:@"filter"];
			
			NSArray *wines = [response objectForKey:filterType];
			
			for (NSDictionary * wine in wines)
			{
				
				USWine *usWine = [[USWine alloc] init];
				usWine.wineId = [wine objectForKey:@"id"];
				usWine.name =
				[[[wine objectForKey:@"name"] stringByAppendingString:@" "]
				 stringByAppendingString:[wine objectForKey:@"year"]];
				
				NSString *varietal =
				[[wine objectForKey:@"filter_subtypes"] firstObject];
				NSString *varietalFromRegion =
				[[varietal stringByAppendingString:@" from "] stringByAppendingString:
				 [[
				   wine
				   objectForKey:@"filter_regions"] firstObject]];
				usWine.wineDescription = varietalFromRegion;
				
				usWine.averagePrice = [wine objectForKey:@"avg_price"];
				
				if ([wine objectForKey:@"closest_place"] != nil)
				{
					usWine.closestPlaceName =
					[[[wine objectForKey:@"closest_place"] objectForKey:@"place"]
					 objectForKey:@"name"];
					usWine.closestPlace750mlPrice =
					[[[wine objectForKey:@"closest_place"] objectForKey:@"prices"]
					 objectForKey:@"750ml"];
					usWine.closestPlaceDistanceMiles =
					[[wine objectForKey:@"closest_place"] objectForKey:@"distance_in_mi"
					 ];
				}
				
				NSString *imageUrlString =
				[[wine objectForKey:@"photo"] objectForKey:@"url"];
				usWine.wineImageUrl = [NSURL URLWithString:imageUrlString];
				
				usWine.ratingsCount =
				[[wine objectForKey:@"ratings_count"] integerValue];
				if (usWine.ratingsCount > 0)
				{
					usWine.averageRating = [[wine objectForKey:@"avg_rating"] floatValue];
				}
				
				if ([wine objectForKey:@"wine_value"] != nil)
				{
					usWine.wineValueRating =
					[[USWineValueRating alloc] initWithWineValueDictionary:[wine
																			objectForKey
																			:
																			@"wine_value"
																			]];
				}
				
				[wineResultsArray addObject:usWine];
			}
			
			self.wineResults = wineResultsArray;
			[self.tableView reloadData];
			
		}    failure:^(NSURLSessionDataTask *task, NSError *error) {
			
			UIAlertView *alertView =
			[[UIAlertView alloc] initWithTitle:
			 @"Error retrieving wine list"
									   message:[error
												localizedDescription
												]
									  delegate:nil
							 cancelButtonTitle:@"Ok"
							 otherButtonTitles:nil];
			[alertView show];
			
		}];
		
		
	}
}*/

- (IBAction)menuButtonClick:(RadioButton *)sender
{
	self.wineSearchArguments = [[NSMutableDictionary alloc] init];
	
	if ([sender.titleLabel.text isEqualToString:@"Like"])
	{
		_selectedIndex = 0;
		[self.wineSearchArguments setObject:@"likes" forKey:@"filter"];
	} else if ([sender.titleLabel.text isEqualToString:@"Save"]) {
		_selectedIndex = 1;
		[self.wineSearchArguments setObject:@"wants" forKey:@"filter"];
	} else {
		_selectedIndex = 2;
		[self.wineSearchArguments setObject:@"rated" forKey:@"filter"];
	}
	
	[self fetchAPIrequests:self.wineSearchArguments];
	
}

@end
