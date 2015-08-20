//
//  USContactsVC.m
//  unscrewed
//
//  Created by Sourabh B. on 18/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USContactsVC.h"
#import "USUserCell.h"
#import "USInviteCell.h"
#import "USUsers.h"
#import "USContacts.h"
#import "IBActionSheet.h"

static const CGFloat CELL_SEPARATOR_INSET = 52.f;

@interface USContactsVC ()<USUserCellDelegate,USInviteCellDelegate,IBActionSheetDelegate> {
    NSMutableArray *searchData;
    UILabel *lblHeader;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *allContactsDictionary;
@property (strong, nonatomic) NSArray *sortedKeysAllContacts;
@property (strong, nonatomic) NSMutableArray *arrContacts;

@property (strong, nonatomic) USUsers *objUsers;
@end

@implementation USContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup Table View
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USUserCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([USUserCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USInviteCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([USInviteCell class])];
    
    /**
     *  Applies table separator color, row heights, header / footer heights
     */
    [self formatTableView];
    
    /**
     *  Load user's phonebook
     */
    [self loadContacts];
    if (self.isInviteContacts == NO) {
        /**
         *  hide search bar
         */
        self.searchDisplayController.searchBar.hidden = YES;
        CGRect tableRect = self.tableView.frame;
        tableRect.origin.y = CGRectGetMinY(self.searchDisplayController.searchBar.frame);
        tableRect.size.height = CGRectGetHeight(self.tableView.frame) + CGRectGetHeight(self.searchDisplayController.searchBar.frame);
        self.tableView.frame = tableRect;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Contacts
- (void)loadContacts {
    [[HelperFunctions sharedInstance] showProgressIndicator];
    
    [[USContacts sharedObject] loadDeviceContacts:^(NSError *error) {
        [[HelperFunctions sharedInstance] hideProgressIndicator];
        if (!error) {
            self.arrContacts = nil;
            self.arrContacts = [[[USContacts sharedObject] arrContacts] mutableCopy];
            
            LogInfo(@"Users contacts count = %ld",(unsigned long)self.arrContacts.count);
            [self.tableView reloadData];
            [self performSelector:@selector(updateLabelHeaderText) withObject:nil afterDelay:0.1];
            if ([[[USUsers sharedUser] arrContactsToImport] count]) {
//                [self updloadContacts];
            } else {
                if (self.isInviteContacts) {
//                    [self getNonUnscrewedUsers];
                } else { // contacts
//                    [self getUsersImNotFollowing];
                }
            }
        } else {
            LogError(@"Permission Denied");
        }
    } isForInvite:self.isInviteContacts];
}

#pragma mark - Header Text
- (void)updateLabelHeaderText {
    [lblHeader setText:[NSString stringWithFormat:@"FOUND %ld CONTACTS YOU AREN'T FOLLOWING",(unsigned long)self.arrContacts.count]];
}

#pragma mark - $$ TABLEVIEW $$
#pragma mark Formating
- (void)formatTableView {
    [self.tableView setRowHeight:53.5f];
    self.tableView.sectionFooterHeight = 0.f;
    self.tableView.sectionHeaderHeight = 0.f;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNeglegibleHeight)]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNeglegibleHeight)]];
    [self.searchDisplayController.searchResultsTableView setRowHeight:53.5f];
    self.searchDisplayController.searchResultsTableView.tableFooterView = [UIView new]; // to hide empty cell lines
    [self.searchDisplayController.searchResultsTableView setSeparatorColor:[USColor cellSeparatorColor]];
}

#pragma mark Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchData.count;
    } else {
        return self.arrContacts.count;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isInviteContacts == NO) {
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            if (indexPath.row+1 == self.arrContacts.count) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            } else {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, CELL_SEPARATOR_INSET, 0, 0)];
            }
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        
        // Explictlyx set your cell's layout margins
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            if (indexPath.row+1 == self.arrContacts.count) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            } else {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, CELL_SEPARATOR_INSET, 0, 0)];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isInviteContacts) {
        return 0.f;
    }
    return 41.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 41)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    if (!lblHeader) {
        lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(11, CGRectGetMinX(headerView.frame) + 4, kScreenWidth - 22, CGRectGetHeight(headerView.frame))];
        [lblHeader setFont:[USFont wineExpertValueFont]];
        [lblHeader setTextColor:[USColor userCellBioColor]];
        [lblHeader setTextAlignment:NSTextAlignmentLeft];
        [lblHeader setText:kEmptyString];
    }
    [headerView addSubview:lblHeader];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isInviteContacts) {
        USInviteCell *cell = (USInviteCell *)[self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USInviteCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        USContact *contact;
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            contact = [searchData objectAtIndex:indexPath.row];
        } else {
            contact = [self.arrContacts objectAtIndex:indexPath.row];
        }
        [cell fillCellForUser:contact];
        return cell;
    } else {
        USUserCell *cell = (USUserCell *)[self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USUserCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        id user = [self.arrContacts objectAtIndex:indexPath.row];
//        [cell fillUserCellWithInfo:user forUserType:PhonebookUser];
        [cell fillUserCellWithPhonebookUser:user]; // FIXME : uncomment above line to show up followingUsers model values
        return cell;
    }
}


#pragma mark - $$ Search Display Controller $$
#pragma mark Data Source & Delegates
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
    self.searchDisplayController.searchBar.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
    self.tableView.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    self.searchDisplayController.searchBar.transform = CGAffineTransformIdentity;
    self.tableView.transform = CGAffineTransformIdentity;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
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


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [searchData removeAllObjects];
    
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fullName contains[c] %@", searchText];
    searchData = [NSMutableArray arrayWithArray:[self.arrContacts filteredArrayUsingPredicate:predicate]];
}


#pragma mark - UserCell Delegate
- (void)userCellFollowUnfollowUser:(USFollowingUser *)user {
    LogInfo(@"Follow user");
//    [self followUser:user];
}

#pragma mark - InviteCell Delegate
- (void)btnInviteClickedForUser:(USContact *)user {
    if ([self.searchDisplayController.searchBar isFirstResponder]) {
        [self.searchDisplayController.searchBar resignFirstResponder];
    }
    
    LogInfo(@"Show Invite actionsheet");
    NSMutableArray *arrayInviteOptions = [NSMutableArray new];
    for (NSString *phone in user.phones) {
        [arrayInviteOptions addObject:phone];
    }
    for (NSString *email in user.emails) {
        if ([HelperFunctions validateEmail:email]) {
            [arrayInviteOptions addObject:email];
        }
    }
    IBActionSheet *objActionSheet = [[IBActionSheet alloc] initWithTitle:@"Invite a friend.." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitlesArray:arrayInviteOptions];
    
    [objActionSheet setButtonTextColor:[USColor actionSheetDescriptionColor]];
    [objActionSheet setTitleTextColor:[USColor actionSheetTitleColor]];
    
    [objActionSheet setCancelButtonTextColor:[USColor themeSelectedColor]];
    [objActionSheet setCancelButtonFont:[USFont actionSheetCancelFont]];
    [objActionSheet showInView:[[[kAppDelegate window] rootViewController] view]];
}


#pragma mark IBActionSheet Delegate
- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != actionSheet.numberOfButtons-1) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        NSString *value = [HelperFunctions formatNumber:title];
        NSString *username = [[[USUsers sharedUser] objUser] username];
        if ([HelperFunctions isValidPhone:value]) {
            NSString *messageCopy = [NSString stringWithFormat:kTextMessageCopy,username,username,kiTunesAppUrl];
            [[HelperFunctions sharedInstance] sendTextMessageTo:title
                                                    textMessage:messageCopy
                                               forNavController:self.navigationController];
        } else {
            NSString *emailCopy = [NSString stringWithFormat:kEmailMessageCopy,username,username,username,kiTunesAppUrl];
            [[HelperFunctions sharedInstance] sendEmailTo:title
                                              withSubject:kEmailSubjectTitle
                                              withMessage:emailCopy
                                         forNavController:self.navigationController];
        }
    }
}


#pragma mark - $$ WEB SERVICES $$
#pragma mark Upload Contacts
- (void)updloadContacts {
    [[HelperFunctions sharedInstance] showProgressIndicator];
    [[USUsers sharedUser] uploadPhoneContacts:self
                            completionHandler:@selector(uploadContactsSuccessHandler:)
                               failureHandler:@selector(uploadContactsFailureHandler:)];
}

- (void)uploadContactsFailureHandler:(id)error {
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    LogError(@"%@",error);
}

- (void)uploadContactsSuccessHandler:(id)response {
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    LogInfo(@"%@",response);
    if (self.isInviteContacts) {
        [self getNonUnscrewedUsers];
    } else {
        [self getUsersImNotFollowing];
    }
}

#pragma mark Users Im Not Following
- (void)getUsersImNotFollowing {
    [[USUsers sharedUser] getUsersImNotFollowing:self
                               completionHandler:@selector(userImNotFollowingSuccessHandler:)
                                  failureHandler:@selector(userImNotFollowingFailureHandler:)];
}


- (void)userImNotFollowingSuccessHandler:(id)result {
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    self.objUsers = (USUsers *)result;
    self.arrContacts = [self.objUsers.arrUsers mutableCopy];
    LogInfo(@"%@",self.arrContacts);
    [self.tableView reloadData];
    [self performSelector:@selector(updateLabelHeaderText) withObject:nil afterDelay:0.1];
}

- (void)userImNotFollowingFailureHandler:(id)error {
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    LogError(@"%@",error);
}


#pragma mark Non Unscrewed Users
- (void)getNonUnscrewedUsers {
    [[USUsers sharedUser] getNonUnscrewedUsers:self
                             completionHandler:@selector(nonUnscrewedUsersSuccessHandler:)
                                failureHandler:@selector(nonUnscrewedUsersFailureHandler:)];
}

- (void)nonUnscrewedUsersSuccessHandler:(id)result {
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    self.objUsers = (USUsers *)result;
    self.arrContacts = [self.objUsers.arrUsers mutableCopy];
    LogInfo(@"%@",self.arrContacts);
    [self.tableView reloadData];
}

- (void)nonUnscrewedUsersFailureHandler:(id)error {
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    LogError(@"%@",error);
}

#pragma mark Follow User
- (void)followUser:(USFollowingUser *)user {
    [[HelperFunctions sharedInstance] showProgressIndicator];
    [self.objUsers followUser:user
                       target:self
                   completion:@selector(followUserSuccessHandlerWithInfo:)
                      failure:@selector(followUserFailureHandlerWithError:)];
}

- (void)followUserSuccessHandlerWithInfo:(USFollowingUser *)user {
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    [self.arrContacts removeObject:user];
    [self.tableView reloadData];
}

- (void)followUserFailureHandlerWithError:(id)error {
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    LogError(@"error = %@",error);
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

@end
