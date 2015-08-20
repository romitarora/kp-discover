//
//  USFindFriendVC.m
//  unscrewed
//
//  Created by Sourabh B. on 19/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USFindFriendVC.h"
//#import <FacebookSDK/FacebookSDK.h>
#import "USFollowingUser.h"
#import "USContactsVC.h"
#import "USUsersTVC.h"
#import "USSearchOperation.h"
#import "USUsers.h"
#import "USUserCell.h"
#import "USGotItVC.h"
#import "USIntroStoresVC.h"

@interface USFindFriendVC () <UISearchControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, USSearchOperationCompletionDelegate, USUserCellDelegate> {
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    
    NSMutableArray *arrFriends;
    NSMutableArray *searchData;
}

@property (nonatomic, assign) BOOL searching;
@property (nonatomic, assign) BOOL findingFriends;
@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) NSOperationQueue *searchQueue;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) USUsers *objSearchedUsers;

@end

@implementation USFindFriendVC

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.searchQueue = [NSOperationQueue new];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([USUserCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([USUserCell class])];

    self.btnNext.hidden = YES;
    if (self.isSigningUp) {
        UIBarButtonItem *barButtonSkip = [[UIBarButtonItem alloc] initWithTitle:@"Skip" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonSkipActionEvent)];
        [barButtonSkip setTintColor:[USColor themeSelectedColor]];
        self.navigationItem.rightBarButtonItem = barButtonSkip;
        
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self.navigationController setNavigationBarHidden:YES];
        
        self.btnNext.hidden = NO;
        
	}
	/**
	 *  Applies table separator color, row heights, header / footer heights
	 */
    NSLog(@"FIND FRIENDS");
    
    [self formatTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - $$ SEARCH DISPLAY CONTROLLER $$
#pragma mark Data Source & Delegates
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
    self.searchDisplayController.searchBar.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
    self.tableView.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    self.searching = YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    self.searchString = nil;
    self.objSearchedUsers = nil;
    [self.searchDisplayController.searchResultsTableView reloadData]; // to clear previous search result data on the table
    self.searching = NO;
    self.searchDisplayController.searchBar.transform = CGAffineTransformIdentity;
    self.tableView.transform = CGAffineTransformIdentity;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    self.searchString = searchString;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:searchString forKey:nameKey];
    USSearchOperation *operation = [[USSearchOperation alloc] initWithParams:params
                                                                   searchFor:SearchForFriends
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

- (void)keyboardWillHide:(NSNotification*)notification {
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
    self.objSearchedUsers = (USUsers *)object;
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)searchOperationFailed {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - $$ TABLEVIEW $$
#pragma mark Data Source & Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searching) {
        return self.objSearchedUsers.arrUsers.count;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searching) {
        return 53.f;
    }
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searching) {
        USUserCell *cell = (USUserCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USUserCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        USFollowingUser *user = [self.objSearchedUsers.arrUsers objectAtIndex:indexPath.row];
        [cell fillUserCellWithInfo:user forUserType:SearchedUser];
        return cell;
    } else {
        static NSString *cellIdentifire = @"cellIdentifire";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire];
        // Configure the cell...
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifire];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.imageView setTintColor:[USColor themeSelectedColor]];
            [cell.textLabel setFont:[USFont defaultTextFont]];
        }
        NSString *imageName;
        NSString *text;
        switch (indexPath.row) {
            case 0:
                imageName = @"facebook";
                text = @"Facebook friends";
                break;
            case 1:
                imageName = @"MultipleUsers";
                text = @"Contacts";
                break;
            default:
                imageName = @"Mail";
                text = @"Invite";
                break;
        }
        UIImage *renderedImage;
        if (indexPath.row == 0) {
            renderedImage = [UIImage imageNamed:imageName];
        } else {
            renderedImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.imageView setTintColor:[USColor colorFromHexString:@"#292929"]];
        }
        [cell.textLabel setText:text];
        [cell.imageView setImage:renderedImage];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searching == NO) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        switch (indexPath.row) {
            case 0:
                [self navigateToFindFacebookFriends];
                break;
            case 1:
            default:
                [self navigateToContactListing:indexPath];
                break;
        }
    }
}

#pragma mark - $$ SCROLL VIEW $$
#pragma mark Delegates
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.searching) {
        if ([scrollView isEqual:self.tableView] || decelerate) return;
        
        [self loadMoreFriends];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.searching) {
        if ([scrollView isEqual:self.tableView]) return;
    
        [self loadMoreFriends];
    }
}

#pragma mark - UserCell Delegate
- (void)userCellFollowUnfollowUser:(USFollowingUser *)user {
    LogInfo(@"Follow user");
	[self followUnfollowUser:user];
}

#pragma mark - $$ WEB SERVICES $$
#pragma mark Get More Friends
- (void)getFriendsWithParam:(NSMutableDictionary *)params {
    self.findingFriends = YES;
    [[HelperFunctions sharedInstance] showProgressIndicator];
    LogInfo(@"getting more friends");
    [self.objSearchedUsers getFriendsWithParams:params
                                       target:self
                                   completion:@selector(getFriendsSuccessHandlerWithInfo:)
                                      failure:@selector(getFriendsFailureHandlerWithError:)];
}

- (void)getFriendsSuccessHandlerWithInfo:(id)info {
    self.findingFriends = NO;
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)getFriendsFailureHandlerWithError:(id)error {
    LogError(@"error = %@",error);
    self.findingFriends = NO;
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

#pragma mark Follow/Unfollow User
- (void)followUnfollowUserFailureHandlerWithError:(id)error {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	LogInfo(@"error = %@",error);
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

- (void)followUnfollowUserSuccessHandlerWithInfo:(USFollowingUser *)user {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	NSInteger index = [self.objSearchedUsers.arrUsers indexOfObject:user];
	[self.searchDisplayController.searchResultsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
						  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)followUnfollowUser:(USFollowingUser *)user {
	[[HelperFunctions sharedInstance] showProgressIndicator];
	if (user.unfollowedUser) { // Unfollowed User, Follow User
		[self.objSearchedUsers followUser:user
									target:self
								completion:@selector(followUnfollowUserSuccessHandlerWithInfo:)
						  failure:@selector(followUnfollowUserFailureHandlerWithError:)];
	} else { // Followed User, Unfollow User
		[self.objSearchedUsers unfollowUser:user
							 target:self
						 completion:@selector(followUnfollowUserSuccessHandlerWithInfo:)
							failure:@selector(followUnfollowUserFailureHandlerWithError:)];
	}
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark Table Header
- (void )setTableHeaderView {
    if (self.isSigningUp) {
        /**
         *  hide search bar
         */
        self.searchDisplayController.searchBar.hidden = YES;
        CGRect tableRect = self.tableView.frame;
        tableRect.origin.y = CGRectGetMinY(self.searchDisplayController.searchBar.frame);
        tableRect.size.height = CGRectGetHeight(self.tableView.frame) + CGRectGetHeight(self.searchDisplayController.searchBar.frame);
        self.tableView.frame = tableRect;
        
        /**
         *  create header view
         */
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 38, 280, 21)];
        [lblHeader setFont:[USFont tableHeaderTitleFont]];
        [lblHeader setTextColor:[USColor themeSelectedTextColor]];
        [lblHeader setTextAlignment:NSTextAlignmentCenter];
        [lblHeader setText:@"Add friends to see what they like"];
        [headerView addSubview:lblHeader];
        
        UILabel *lblMsg = [[UILabel alloc] initWithFrame:CGRectMake(40, 58, 240, 20)];
        [lblMsg setFont:[USFont tableHeaderMessageFont]];
        [lblMsg setTextColor:[USColor themeSelectedTextColor]];
        [lblMsg setTextAlignment:NSTextAlignmentCenter];
        [lblMsg setText:@"You can always add more later"];
        [headerView addSubview:lblMsg];
        self.tableView.tableHeaderView = headerView;
	} else {
		[self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNeglegibleHeight)]];
		self.searchDisplayController.searchResultsTableView.tableFooterView = [UIView new]; // to hide empty cell lines
		[self.searchDisplayController.searchResultsTableView setSeparatorColor:[USColor cellSeparatorColor]];
	}
}

- (void)formatTableView {
    [self.tableView setRowHeight:53.5f];
    self.tableView.sectionFooterHeight = 0.f;
    self.tableView.sectionHeaderHeight = 0.f;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
	[self setTableHeaderView];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNeglegibleHeight)]];
}

#pragma mark Navigate To ContactVC
- (void)navigateToContactListing:(NSIndexPath *)indexPath {
    USContactsVC *objContactVC = [[USContactsVC alloc] init];
    if (indexPath.row == 1) { // contacts
        objContactVC.title = @"Find Contacts";
    } else { // invite
        objContactVC.title = @"Invite";
        objContactVC.isInviteContacts = YES;
    }
    [self.navigationController pushViewController:objContactVC animated:YES];
}

- (void)navigateToFindFacebookFriends {
    USUsersTVC *objFollowingUser = [[USUsersTVC alloc] initWithStyle:UITableViewStyleGrouped];
    objFollowingUser.title = @"Facebook Friends";
    objFollowingUser.userType = FacebookUser;
    [self.navigationController pushViewController:objFollowingUser animated:YES];
}


- (void)navigateToGotIt {
    USGotItVC *objGotItVC = [[USGotItVC alloc] init];
    [self.navigationController pushViewController:objGotItVC animated:YES];
}

- (void)navigateToStores{
    USIntroStoresVC *nextVC = [[USIntroStoresVC alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark Pagination
//Load more wines if table view scroll to the end
- (void)loadMoreFriends {
    NSArray *arrVisibleRows = [self.tableView indexPathsForVisibleRows];
    NSIndexPath *lastVisibleIndexPath = [arrVisibleRows lastObject];
    if (lastVisibleIndexPath.row == self.objSearchedUsers.arrUsers.count-1 && self.objSearchedUsers.isReachedEnd == NO) {
        if (self.findingFriends == NO) {
            // Get More Wines
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:self.searchString forKey:queryKey];
            [self getFriendsWithParam:params];
        }
    }
}

#pragma mark - $$ EVENT HANDLER $$


- (IBAction)btnNextEventHandler:(UIButton *)sender {
    [self navigateToStores];
}

#pragma mark Bar Button Event
- (void)barButtonSkipActionEvent {
    
    //[self navigateToStores];
    
    /*
    // Open Dashboard
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:kAppDelegate.window cache:NO];
    [kAppDelegate.window setRootViewController:[kGlobalPref dashboard]];
    [UIView commitAnimations];
     */
}

@end
