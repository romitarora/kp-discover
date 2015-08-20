//
//  USPlacesTVC.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 06/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USPlacesTVC.h"
#import "USRetailerCell.h"
#import "USRetailers.h"
#import "USLocationManager.h"
#import "USMapViewController.h"
#import "USRetailerTVC.h"
#import <AlgoliaSearch-Client/ASAPIClient.h>
#import <AlgoliaSearch-Client/ASRemoteIndex.h>

static NSString *cellIdentifier;
static const CGFloat ROW_HEIGHT = 67.f;
static const CGFloat CELL_SEPARATOR_INSET = 65.f;

@interface USPlacesTVC () {
	ASRemoteIndex *index;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) USRetailers *objRetailers;
@property (nonatomic, strong) USRetailers *objSearchedRetailers;
@property (nonatomic, strong) NSString *searchString;

@property (nonatomic, assign, getter=isSearching) BOOL searching;
@property (nonatomic, assign) BOOL gettingPlaces;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSOperationQueue *searchQueue;

@end

@implementation USPlacesTVC
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	// Initalise Algolia Search Params
	index = [[kAppDelegate apiClient] getIndex:@"places_production"];
	NSArray *faceting = @[@"type"];
	NSDictionary *settings = @{@"attributesForFaceting": faceting};
	[index setSettings:settings success:nil
			   failure:^(ASRemoteIndex *index, NSDictionary *settings, NSString *errorMessage) {
				   NSLog(@"Error when applying settings: %@", errorMessage);
			   }];
	
    cellIdentifier = @"USRetailerCell";
	self.searchQueue = [NSOperationQueue new];
    
    [self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
    [self.searchDisplayController.searchResultsTableView setSeparatorColor:[USColor cellSeparatorColor]];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USRetailerCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
	self.tableView.tableFooterView = [UIView new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetPageForNewSelectedLocation) name:@"reset_page_for_new_location" object:nil];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

    if (self.isFromMeSection) {
        [self getMyPlaces];
    } else {
        if (!self.objRetailers || self.objRetailers.arrPlaces.count == 0) {
            self.objRetailers = nil;
            [self getPlaces];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetPageForNewSelectedLocation {
    LogInfo(@"resetPageForNewSelectedLocation");
	if (self.isFromMeSection) return;
	
    self.objRetailers = nil;
}

#pragma mark - UI Setup
- (void)setupUI {
    if (self.isFromMeSection) {
        self.searchDisplayController.searchBar.hidden = YES;
        self.title = @"My Places";
        /**
         *  hide search bar and update table frames accordingly
         */
        CGRect tableRect = self.tableView.frame;
        tableRect.origin.y = CGRectGetMinY(self.searchDisplayController.searchBar.frame);
        tableRect.size.height += CGRectGetHeight(self.searchDisplayController.searchBar.frame);
        self.tableView.frame = tableRect;
        
        /**
         *  Add Edit button - Right Bar Button Item
         */
        UIBarButtonItem *barButtonEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonEditActionEvent)];
        [barButtonEdit setTintColor:[USColor themeSelectedColor]];
        self.navigationItem.rightBarButtonItem = barButtonEdit;
        
    } else {
        [self.navigationItem setTitleView:[HelperFunctions kerningTitleViewWithTitle:@"nearby"]];
		
		// Initialize the refresh control.
		self.refreshControl = [[UIRefreshControl alloc] init];
		[self.refreshControl addTarget:self
								action:@selector(refreshPlaces:)
					  forControlEvents:UIControlEventValueChanged];
		[self.tableView addSubview:self.refreshControl];
        /**
         * Add Map Button - Left Bar Button Item
         */
        UIBarButtonItem *barButtonMap = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonMapActionEvent)];
        [barButtonMap setTintColor:[USColor themeSelectedColor]];
        self.navigationItem.leftBarButtonItem = barButtonMap;
    }
}

- (void)refreshPlaces:(UIRefreshControl *)refreshControl {
	self.objRetailers = nil;
	[self getPlaces];
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark Pagination
//Load more places if table view scroll to the end
- (void)loadMorePlacesIfTableScrolledToLastRecord {
	BOOL isReachedEnd;
	NSInteger totalCount;
	NSArray *arrVisibleRows;
	NSIndexPath *lastVisibleIndexPath;
	if (self.searching) {
		arrVisibleRows = [self.searchDisplayController.searchResultsTableView indexPathsForVisibleRows];
		totalCount = self.objSearchedRetailers.arrPlaces.count-1;
		isReachedEnd = self.objSearchedRetailers.isReachedEnd;
		lastVisibleIndexPath = [arrVisibleRows lastObject];
		if (lastVisibleIndexPath.row == totalCount && isReachedEnd == NO) {
			[self getOfflinePlacesWithSearchString:self.searchString];
		}
	} else {
		arrVisibleRows = [self.tableView indexPathsForVisibleRows];
		totalCount = self.objRetailers.arrPlaces.count-1;
		isReachedEnd = self.objRetailers.isReachedEnd;
		lastVisibleIndexPath = [arrVisibleRows lastObject];
		if (lastVisibleIndexPath.row == totalCount && isReachedEnd == NO) {
			if (self.gettingPlaces == NO) {
				if (self.isFromMeSection) {
					[self getMyPlaces];
				} else {
					[self getPlaces];
				}
			}
		}
	}
}

#pragma mark Navigation
- (void)navigateToRetailersViewControllerForRetailer:(USRetailer *)objRetailer {
	USRetailerTVC *objRetailerTVC = [[USRetailerTVC alloc] init];
	objRetailerTVC.objRetailer = objRetailer;
	[self.navigationController pushViewController:objRetailerTVC animated:YES];
}

#pragma mark - $$ WEB SERVICES $$
#pragma mark Get Places
- (void)getPlacesFailureHandlerWithError:(id)error {
    DLog(@"error = %@",error);
	self.gettingPlaces = NO;
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

- (void)getPlacesSuccessHandlerWithInfo:(id)info {
	self.gettingPlaces = NO;
    [[HelperFunctions sharedInstance] hideProgressIndicator];
	
	if ([self.refreshControl isRefreshing]) {
		[self.refreshControl endRefreshing];
	}
	
	if (self.searching) {
		[self.searchDisplayController.searchResultsTableView reloadData];
	} else {
		[self.tableView reloadData];
	}
}

- (void)getPlaces {
	self.gettingPlaces = YES;
    NSMutableDictionary *params = [NSMutableDictionary new];
    USLocation *selectedLocation = [[USLocationManager sharedInstance] selectedLocationCordinate];
	if (selectedLocation) {
		[params setObject:selectedLocation.latitudeAsString forKey:latitudeKey];
		[params setObject:selectedLocation.longitudeAsString forKey:longitudeKey];
	}
//	[params setObject:@YES forKey:showOnlineKey];
	[params setObject:@YES forKey:showOfflineKey];
	USRetailers *objRetailers;
	if (self.searching) {
		objRetailers = self.objSearchedRetailers;
		[params setObject:self.searchString forKey:queryKey];
	} else {
		if (!self.objRetailers) {
			self.objRetailers = [USRetailers new];
		}
		objRetailers = self.objRetailers;
	}
	[[HelperFunctions sharedInstance] showProgressIndicator];
    [objRetailers getPlacesWithParams:params
                                    target:self
                                completion:@selector(getPlacesSuccessHandlerWithInfo:)
                                   failure:@selector(getPlacesFailureHandlerWithError:)];
}

- (void)getMyPlaces {
    self.gettingPlaces = YES;
    
    if (!self.objRetailers) {
        self.objRetailers = [USRetailers new];
    }
    USRetailers *retailers = [USRetailers new];
    [[HelperFunctions sharedInstance] showProgressIndicator];
    [retailers getMyPlaces:self
				completion:@selector(getMyPlacesSuccessHandler:)
				   failure:@selector(getPlacesFailureHandlerWithError:)];
}

- (void)getMyPlacesSuccessHandler:(id)info {
    self.gettingPlaces = NO;
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    
    self.objRetailers = (USRetailers *)info;
    [self.tableView reloadData];
}

#pragma mark Delete Place
- (void)deletePlace:(USRetailer *)retailer {
    self.gettingPlaces = YES;
    [[HelperFunctions sharedInstance] showProgressIndicator];
    [[USRetailers new] setStatusAsUnstaredForPlace:retailer target:self completion:@selector(deletePlaceSuccessHandler:) failure:@selector(deletePlaceFailureHandler:)];
}

- (void)deletePlaceSuccessHandler:(id)response {
    self.gettingPlaces = NO;
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    
    // update data source
    USRetailer *retailer = (USRetailer *)response;
    NSInteger retailerIndex = [self.objRetailers.arrPlaces indexOfObject:retailer];
    [self.objRetailers.arrPlaces removeObject:retailer];
    
    // udpate UI
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:retailerIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deletePlaceFailureHandler:(id)error {
    LogInfo(@"Error in deleting place :- %@",error);
    self.gettingPlaces = NO;
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

#pragma mark - $$ PROTOCOLS $$
#pragma mark Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
		return self.objSearchedRetailers.arrPlaces.count;
	}
    return self.objRetailers.arrPlaces.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) return;
	
	// Remove seperator inset
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsMake(0, CELL_SEPARATOR_INSET, 0, 0)];
	}
	
	// Prevent the cell from inheriting the Table View's margin settings
	if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
		[cell setPreservesSuperviewLayoutMargins:NO];
	}
	
	// Explictlyx set your cell's layout margins
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsMake(0, CELL_SEPARATOR_INSET, 0, 0)];
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
		USRetailer *objRetailer = [self.objSearchedRetailers.arrPlaces objectAtIndex:indexPath.row];
		[cell.textLabel setText:objRetailer.name];
		NSString *detailText = objRetailer.type;
		if (objRetailer.address) {
			detailText = [detailText stringByAppendingFormat:@" - %@",objRetailer.address];
		}
		[cell.detailTextLabel setText:detailText];
        
		return cell;
	}

    USRetailerCell *cell = (USRetailerCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
	// Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    USRetailer *retailer = [self.objRetailers.arrPlaces objectAtIndex:indexPath.row];
    [cell fillRetailerInfo:retailer isForPlaces:YES];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
		return 44.f;
	}
	return ROW_HEIGHT;
}

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	USRetailer *retailer;
	if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
		retailer = [self.objSearchedRetailers.arrPlaces objectAtIndex:indexPath.row];
	} else {
		retailer = [self.objRetailers.arrPlaces objectAtIndex:indexPath.row];
        NSLog(@"RETAILER = %@", retailer);
	}
	[self navigateToRetailersViewControllerForRetailer:retailer];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.isEditing;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    USRetailer *retailer = [self.objRetailers.arrPlaces objectAtIndex:indexPath.row];
    [self deletePlace:retailer];
}

#pragma mark - Search Controller Delegates
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    self.searching = YES;
    CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
    self.searchDisplayController.searchBar.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
    self.tableView.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
	self.searchString = nil;
	self.objSearchedRetailers = nil;
    self.searching = NO;
    self.searchDisplayController.searchBar.transform = CGAffineTransformIdentity;
    self.tableView.transform = CGAffineTransformIdentity;
	if (!self.objRetailers) {
		[self.tableView reloadData];
		[self getPlaces];
	}
}

- (void)getOfflinePlacesWithSearchString:(NSString *)searchString {
	ASQuery *query = [ASQuery queryWithFullTextQuery:searchString];
	query.facets = @[@"*"];
	query.facetFilters = @[@"type:Store"];
	USLocation *selectedLocation = [[USLocationManager sharedInstance] selectedLocationCordinate];
	if (selectedLocation) {
		[query searchAroundLatitude:selectedLocation.latitudeAsDouble longitude:selectedLocation.longitudeAsDouble maxDist:10000];
	}
	query.page = self.objSearchedRetailers.currentPage+1;
	query.hitsPerPage = DATA_PAGE_SIZE;
	[index search:query
		  success:^(ASRemoteIndex *index, ASQuery *query, NSDictionary *result) {
			  [[HelperFunctions sharedInstance] hideProgressIndicator];
			  DLog(@"Result count: %lu",(long)[[result valueForKey:@"hits"] count]);
			  DLog(@"Result: %@",result);
			  [self.objSearchedRetailers parseAutofillOffinePlacesWithResult:result];
			  [self.searchDisplayController.searchResultsTableView reloadData];
		  } failure:^(ASRemoteIndex *index, ASQuery *query, NSString *errorMessage) {
			  DLog(@"error = %@",errorMessage);
			  [[HelperFunctions sharedInstance] hideProgressIndicator];
		  }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	self.searchString = searchString;
	if (searchString.length >= 3) {
		ASQuery *onlineQuery = [ASQuery queryWithFullTextQuery:searchString];
		onlineQuery.facets = @[@"*"];
		onlineQuery.facetFilters = @[@"type:Online"];
		[[HelperFunctions sharedInstance] showProgressIndicator];
		[index search:onlineQuery success:^(ASRemoteIndex *index, ASQuery *query, NSDictionary *result) {
			DLog(@"Result count online places: %lu",(long)[[result valueForKey:@"hits"] count]);
			DLog(@"Result online places: %@",[result valueForKey:@"hits"]);
			self.objSearchedRetailers = nil;
			self.objSearchedRetailers = [USRetailers new];
			[self.objSearchedRetailers parsePlaces:[result valueForKey:@"hits"]];
			self.objSearchedRetailers.currentPage = -1;
			// Get Offline Places once get online places
			[self getOfflinePlacesWithSearchString:searchString];
		} failure:^(ASRemoteIndex *index, ASQuery *query, NSString *errorMessage) {
			DLog(@"error = %@",errorMessage);
			[[HelperFunctions sharedInstance] hideProgressIndicator];
		}];
	}
	return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    //this is to handle strange tableview scroll offsets when scrolling the search results
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
	self.objSearchedRetailers = nil;
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

#pragma mark - Scroll View Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (decelerate) return;
	[self loadMorePlacesIfTableScrolledToLastRecord];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self loadMorePlacesIfTableScrolledToLastRecord];
}

#pragma mark - Bar Button Actions
#pragma mark Map Action
- (void)barButtonMapActionEvent {
    DLog(@"Map clicked");
    USMapViewController *objMapVC = [USMapViewController new];
    objMapVC.retailers = self.objRetailers;
    objMapVC.title = @"Places Map";
    UINavigationController *navMaps = [[UINavigationController alloc] initWithRootViewController:objMapVC];
	navMaps.navigationBar.translucent = NO;
    [self presentViewController:navMaps animated:YES completion:nil];
}

#pragma mark - Edit Action 
- (void)barButtonEditActionEvent {
    if (self.tableView.isEditing) {
        [self enableTableViewEditMode:NO];
    } else {
        [self enableTableViewEditMode:YES];
    }
}

- (void)enableTableViewEditMode:(BOOL)editMode {
    UIBarButtonItem *editButton = self.navigationItem.rightBarButtonItem;
    if (editMode) {
        [editButton setTitle:@"Done"];
    } else {
        [editButton setTitle:@"Edit"];
    }
    [self.tableView setEditing:editMode animated:YES];
}

@end
