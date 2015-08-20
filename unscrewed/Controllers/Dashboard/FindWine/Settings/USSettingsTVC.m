//
//  USSettingsTVC.m
//  unscrewed
//
//  Created by Robin Garg on 05/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USSettingsTVC.h"
#import "USLocationManager.h"
#import "USMessageVC.h"

@interface USSettingsTVC ()<UIAlertViewDelegate>

@end

@implementation USSettingsTVC
@synthesize isFromNearBy;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Options";
    [self.view setBackgroundColor:[USColor optionsViewBGColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.tableView setSeparatorColor:[USColor settingsViewTableSeparatorColor]];
    
    
    
    if (isFromNearBy)
    {
        self.navigationItem.title = @"Choose Your Location";
        
        UIBarButtonItem * barCancel =[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(CancelButtonClick)];
        
        [barCancel setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = barCancel;
        
        
        self.navigationItem.titleView.tintColor=[UIColor whiteColor];
    }
    else
    {
        UIBarButtonItem *barButtonSettings = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_button_gray"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
        [barButtonSettings setImageInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
        barButtonSettings.tintColor=[UIColor whiteColor];
        
        self.navigationItem.leftBarButtonItem = barButtonSettings;
    }
}

-(void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)CancelButtonClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - $$ HELPER FUNCTIONS $$
#pragma mark Get Cell Text
- (NSString *)cellTextLabelTextForIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section)
    {
        case 0:
            return @"Use Current Location";
        case 1:
            return ((indexPath.row) ? @"Los Angeles" : @"Seattle");
        case 2:
            switch (indexPath.row) {
                case 0:
                    return @"Suggest a Retailer";
                case 1:
                    return @"Give Feedback";
                case 2:
                    return @"About Us";
                default:
                    return @"Terms & Privacy";
            }
        default:
            return @"Log Out";
    }
}

#pragma mark Navigation
- (void)navigateToMessageViewControllerForPrivacy:(BOOL)privacy {
    USMessageVC *objMessageVC = [[USMessageVC alloc] init];
    objMessageVC.showInfoAbout = privacy;
    [self.navigationController pushViewController:objMessageVC animated:YES];
}
#pragma mark - $$ EVENT HANDLER $$
#pragma mark Table View Information Section Selected
- (void)provideActionForInformationSectionForRow:(NSInteger)row {
    switch (row) {
        case 0:
            // @"Suggest a Retailer";
            [[HelperFunctions sharedInstance] sendEmailTo:@"tom@unscrewed.com"
                                              withSubject:@"Retailer Suggestion"
                                              withMessage:kEmptyString
                                         forNavController:self.navigationController];
            break;
        case 1:
            // @"Give Feedback";
            [[HelperFunctions sharedInstance] sendEmailTo:@"tom@unscrewed.com"
                                              withSubject:@"Feedback"
                                              withMessage:kEmptyString
                                         forNavController:self.navigationController];
            break;
        case 2:
            // @"About Us";
            [self navigateToMessageViewControllerForPrivacy:NO];
            break;
        default:
            // @"Terms & Privacy";
            [self navigateToMessageViewControllerForPrivacy:YES];
            break;
    }
}

- (void)logOutUser {
    // Remove Keys
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:authTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:authTokenExpiresKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kIsUserLoggedInKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMyWinesFilterTitleKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMyWinesFilterValueKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMyWinesFilterSortTypeKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kWinesSortTypeKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kWinesDistanceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Go Back to Intro Screen
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:kAppDelegate.window cache:NO];
    [kAppDelegate.window setRootViewController:[kGlobalPref windowRootViewController]];
    [UIView commitAnimations];
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (isFromNearBy)
    {
        return 2;
        
    }
    else
    {
        return 4;
        
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
            return 4;
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifire = @"SettingsCellReuseIdentifire";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifire];
    
    // Configure the cell...
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifire];
        [cell.textLabel setFont:[USFont defaultTableCellTextFont]];
        [cell setTintColor:[USColor themeSelectedColor]];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryNone;
            if ([[USLocationManager sharedInstance] selectedLocation] == SelectedLocationCurrentLocation) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                if ([[USLocationManager sharedInstance] selectedLocation] == SelectedLocationSeattle) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                if ([[USLocationManager sharedInstance] selectedLocation] == SelectedLocationLosAngeles) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
            break;
        case 2:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
        default:
            [cell.textLabel setTextColor:[USColor themeSelectedColor]];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            break;
    }
    [cell.textLabel setText:[self cellTextLabelTextForIndexPath:indexPath]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 22.f;
        case 1:
            return 30.f;
        case 2:
            return 12.f;
        default:
            return 12.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 1) ? @"OUR CITIES" : kEmptyString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case 0:
        {
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized ||
                [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
            {
                [[USLocationManager sharedInstance] setSelectedLocation:SelectedLocationCurrentLocation];
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, 2)];
                [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAddress" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNavigationTitle" object:nil];
                
                
                
            } // Location Services is not enabled
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                [[USLocationManager sharedInstance] setSelectedLocation:SelectedLocationSeattle];
            } else {
                [[USLocationManager sharedInstance] setSelectedLocation:SelectedLocationLosAngeles];
            }
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, 2)];
            [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAddress" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNavigationTitle" object:nil];
            
            
            
            
        }
            break;
        case 2:
            [self provideActionForInformationSectionForRow:indexPath.row];
            break;
            
        default:
            [HelperFunctions showAlertWithTitle:kAlert
                                        message:@"Are you sure you want to logout?"
                                       delegate:self
                              cancelButtonTitle:kCancel
                               otherButtonTitle:kOk];
            break;
    }
}


#pragma mark Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self logOutUser];
    }
}

@end
