//
//  USPlacesVC.m
//  unscrewed
//
//  Created by Robin Garg on 19/01/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USPlacesVC.h"
#import "USRetailerCell.h"
#import "USFindFriendVC.h"
#import "USRetailers.h"
#import "USLocationManager.h"
#import "USGotItVC.h"

static NSString *const cellIdentifire = @"USRetailerCell";
static const CGFloat ROW_HEIGHT = 68.f;
static const CGFloat CELL_SEPARATOR_INSET = 65.f;

@interface USPlacesVC ()<RetailerStaredDelegate>

@property (nonatomic, strong) USRetailers *objRetailers;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation USPlacesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Nearby";
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    UIBarButtonItem *barButtonSkip = [[UIBarButtonItem alloc] initWithTitle:@"Skip" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonSkipActionEvent)];
    [barButtonSkip setTintColor:[USColor themeSelectedColor]];
    self.navigationItem.rightBarButtonItem = barButtonSkip;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USRetailerCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifire];
    [self.tableView setRowHeight:ROW_HEIGHT];
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, CELL_SEPARATOR_INSET, 0, 0)];
    } else {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, CELL_SEPARATOR_INSET, 0, 0)];
    }
	[self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
    [self getPlaces];
}

#pragma mark - $$ HELPER CLASSES $$
- (UIView *)headerView {
    if (!self.objRetailers.arrPlaces.count) {
        return [UIView new];
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 280, 21)];
    [lblHeader setFont:[USFont tableHeaderTitleFont]];
    [lblHeader setTextColor:[USColor themeSelectedTextColor]];
    [lblHeader setTextAlignment:NSTextAlignmentCenter];
    [lblHeader setText:@"Shop any of these places?"];
    [headerView addSubview:lblHeader];
    
    UILabel *lblMsg = [[UILabel alloc] initWithFrame:CGRectMake(40, 28, 240, 20)];
    [lblMsg setFont:[USFont tableHeaderMessageFont]];
    [lblMsg setTextColor:[USColor themeSelectedTextColor]];
    [lblMsg setTextAlignment:NSTextAlignmentCenter];
    [lblMsg setText:@"You can always add more later"];
    [headerView addSubview:lblMsg];
    
    UIView *seperator = [[UIView alloc] init];
    [seperator setFrame:CGRectMake(0.f, 55.5f, 320.f, 0.5f)];
    [seperator setBackgroundColor:[UIColor colorWithWhite:(236.f/255.f) alpha:1.f]];
    [headerView addSubview:seperator];
    
    return headerView;
}

#pragma mark Navigation
- (void)navigateToFindFriendsViewController {
    USFindFriendVC *objFindFriendVC = [[USFindFriendVC alloc] init];
    objFindFriendVC.isSigningUp = YES;
    objFindFriendVC.title = @"Friends";
    [self.navigationController pushViewController:objFindFriendVC animated:YES];
}



#pragma mark - $$ WEB SERVICES $$
#pragma mark Star/UnStar Place
- (void)setStarStatusFailureHandlerWithError:(id)error {
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

- (void)setStarStatusSuccessHandlerForPlace:(USRetailer *)retailer {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	if (retailer) {
		NSUInteger index = [self.objRetailers.arrPlaces indexOfObject:retailer];
		USRetailerCell *cell = (USRetailerCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
		if (cell) {
			[cell updateStarPlaceStatus:retailer.favorited];
		}
	}
}

- (void)setStatusAsStaredForPlace:(USRetailer *)retailer {
	USRetailers *objRetailers = [USRetailers new];
	[[HelperFunctions sharedInstance] showProgressIndicator];
	[objRetailers setStatusAsStaredForPlace:retailer
									 target:self
								 completion:@selector(setStarStatusSuccessHandlerForPlace:)
									failure:@selector(setStarStatusFailureHandlerWithError:)];
}

- (void)setStatusAsUnstartedForPlace:(USRetailer *)retailer {
	USRetailers *objRetailers = [USRetailers new];
	[[HelperFunctions sharedInstance] showProgressIndicator];
	[objRetailers setStatusAsUnstaredForPlace:retailer
									 target:self
								 completion:@selector(setStarStatusSuccessHandlerForPlace:)
									failure:@selector(setStarStatusFailureHandlerWithError:)];
}

#pragma mark Get Places
- (void)getPlacesFailureHandlerWithError:(id)error {
    DLog(@"places error = %@",error);
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
    DLog(@"places info = %@",info);
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    [self.tableView setTableHeaderView:[self headerView]];
    [self.tableView reloadData];
}

- (void)getPlaces {
    if (!self.objRetailers) {
        self.objRetailers = [USRetailers new];
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    USLocation *selectedLocation = [[USLocationManager sharedInstance] selectedLocationCordinate];
	if (selectedLocation) {
		[params setObject:selectedLocation.latitudeAsString forKey:latitudeKey];
		[params setObject:selectedLocation.longitudeAsString forKey:longitudeKey];
	}
	[params setObject:@YES forKey:showOfflineKey];
    [[HelperFunctions sharedInstance] showProgressIndicator];
    [self.objRetailers getPlacesWithParams:params
                                 target:self
                             completion:@selector(getPlacesSuccessHandlerWithInfo:)
                                failure:@selector(getPlacesFailureHandlerWithError:)];
}

#pragma mark - $$ EVENT HANDLER $$

- (IBAction)btnNextEventHandler:(UIButton *)sender {
    [self navigateToFindFriendsViewController];
}

#pragma mark Bar Button Event
- (void)barButtonSkipActionEvent {
    //[self navigateToFindFriendsViewController];
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark TableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.objRetailers.arrPlaces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    USRetailerCell *cell = (USRetailerCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifire];
    // Configure the cell...
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, CELL_SEPARATOR_INSET, 0, 0)];
    }
    USRetailer *retailer = [self.objRetailers.arrPlaces objectAtIndex:indexPath.row];
	cell.delegate = self;
    [cell fillRetailerInfo:retailer isForPlaces:NO];
    return cell;
}

#pragma mark Retailer Started Delegate Methods
- (void)retailer:(USRetailer *)retailer stared:(BOOL)stared {
	UIBarButtonItem *skipOrNextBarButton = self.navigationItem.rightBarButtonItem;
	if ([skipOrNextBarButton.title isEqualToString:@"Skip"]) {
		[skipOrNextBarButton setTitle:@"Next"];
		self.navigationItem.rightBarButtonItem = skipOrNextBarButton;
	}
	if (stared) {
		[self setStatusAsStaredForPlace:retailer];
	} else {
		[self setStatusAsUnstartedForPlace:retailer];
	}
}

@end
