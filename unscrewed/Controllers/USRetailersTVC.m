//
//  RetailerTableViewController.m
//  Unscrewed_iOS_MOCKUP
//
//  Created by Gary Earle on 8/10/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USRetailersTVC.h"
#import "USRetailer.h"
#import "USRetailerCell.h"
#import "USPlacesTwoTVC.h"

@interface USRetailersTVC ()

@end

@implementation USRetailersTVC


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _fixturesStores = [NSMutableArray arrayWithCapacity:5];
    USRetailer *retailer = [[USRetailer alloc] init];
    
    retailer.name = @"Whole Foods Market";
    retailer.address = @"2210 Westlake Ave";
    retailer.numOfDeals = 668;
    retailer.favorited = true;
    [_fixturesStores addObject:retailer];
    
    retailer = [[USRetailer alloc] init];
    retailer.name = @"QFC";
    retailer.address = @"500 Mercer St";
    retailer.numOfDeals = 973;
    [_fixturesStores addObject:retailer];
    
    retailer = [[USRetailer alloc] init];
    retailer.name = @"QFC";
    retailer.address = @"1400 Broadway";
    retailer.numOfDeals = 973;
    [_fixturesStores addObject:retailer];
    
    retailer = [[USRetailer alloc] init];
    retailer.name = @"Metropolitan Market";
    retailer.address = @"100 Mercer";
    retailer.numOfDeals = 442;
    [_fixturesStores addObject:retailer];

    retailer = [[USRetailer alloc] init];
    retailer.name = @"Metropolitan Market";
    retailer.address = @"100 Mercer";
    retailer.numOfDeals = 442;
    [_fixturesStores addObject:retailer];
    retailer = [[USRetailer alloc] init];
    retailer.name = @"Metropolitan Market";
    retailer.address = @"100 Mercer";
    retailer.numOfDeals = 442;
    [_fixturesStores addObject:retailer];
    retailer = [[USRetailer alloc] init];
    retailer.name = @"Metropolitan Market";
    retailer.address = @"100 Mercer";
    retailer.numOfDeals = 442;
    [_fixturesStores addObject:retailer];
    retailer = [[USRetailer alloc] init];
    retailer.name = @"Metropolitan Market";
    retailer.address = @"100 Mercer";
    retailer.numOfDeals = 442;
    [_fixturesStores addObject:retailer];

    retailer = [[USRetailer alloc] init];
    retailer.name = @"Safeway";
    retailer.address = @"516 1st Ave W";
    retailer.numOfDeals = 468;
    [_fixturesStores addObject:retailer];

    _fixturesRestaurants = [NSMutableArray arrayWithCapacity:1];
    retailer = [[USRetailer alloc] init];
    retailer.name = @"Restaurant";
    retailer.address = @"516 1st Ave W";
    retailer.numOfDeals = 468;
    retailer.favorited = YES;
    [_fixturesRestaurants addObject:retailer];

    _fixturesOnline = [NSMutableArray arrayWithCapacity:5];
    retailer = [[USRetailer alloc] init];
    retailer.name = @"Online";
    retailer.address = @"516 1st Ave W";
    retailer.numOfDeals = 468;
    [_fixturesOnline addObject:retailer];
    
    _filteredPlaces = [NSMutableArray arrayWithCapacity:[_fixturesStores count]];

    //self.edgesForExtendedLayout = UIRectEdgeTop + UIRectEdgeBottom;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //self.automaticallyAdjustsScrollViewInsets = YES;
    //CGRect newBounds = self.tableView.bounds;
    //newBounds.origin.y = newBounds.origin.y - 88;
    //self.tableView.bounds = newBounds;
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    self.tableView.contentOffset = CGPointMake(0, _placesSearchBar.bounds.size.height);
}

- (NSMutableArray *)getFixtureArray
{
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0: return _fixturesStores;
        case 1: return _fixturesRestaurants;
        case 2: return _fixturesOnline;
        default: return _fixturesStores;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _placesSearchController.searchResultsTableView) {
        return [_filteredPlaces count];
    } else {
        // Return the number of rows in the section.
        return [[self getFixtureArray] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseIdentifier = @"USRetailerCell";
    USRetailerCell *cell = (USRetailerCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if (cell == nil)
        cell = [[USRetailerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];

    USRetailer *retailer;
    if (tableView == _placesSearchController.searchResultsTableView) {
        retailer = [_filteredPlaces objectAtIndex:indexPath.row];
    } else {
        retailer = [[self getFixtureArray] objectAtIndex:indexPath.row];
    }

    cell.nameLabel.text = retailer.name;
    cell.addressLabel.text = retailer.address;
    cell.numOfDealsLabel.text = [NSString stringWithFormat:@"%i", retailer.numOfDeals];
    cell.retailerImageView.image = [UIImage imageNamed:@"retailers-icon.png"];
    cell.heartToggle.selected = retailer.favorited;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    [self.tableView reloadData];
}

- (IBAction)searchButtonClick:(UIBarButtonItem *)sender {
    [_placesSearchBar becomeFirstResponder];
}

#pragma mark - Content Filtering

- (void) filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    [_filteredPlaces removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    _filteredPlaces = [NSMutableArray arrayWithArray:[[self getFixtureArray] filteredArrayUsingPredicate:predicate]];
}

#pragma mark - Search Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[_placesSearchBar scopeButtonTitles] objectAtIndex:[_placesSearchBar selectedScopeButtonIndex]]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:_placesSearchBar.text scope:
     [[_placesSearchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"placesDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        USPlacesTwoTVC *destViewController = segue.destinationViewController;
        USRetailer *retailer = [[self getFixtureArray] objectAtIndex:indexPath.row];
        destViewController.exchName = retailer.name;
    }
}

@end
