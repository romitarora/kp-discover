//
//  USDetailTVC.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 25/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USDetailTVC.h"

@interface USDetailTVC ()<UITextFieldDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSIndexPath *_selectedRow;
    UITextField *txtField;
    
    NSMutableArray *searchData;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
}

@property (nonatomic, assign, getter=isSearching) BOOL searching;

@end

@implementation USDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
	self.tableView.tableFooterView = [UIView new];
	if (self.removeSearchOption == NO) {
		[self addSearchDisplayController];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searching) {
        return [searchData count];
    }
    return [self.arrTableDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"detail_cell_identifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.tintColor = [USColor themeSelectedColor];
		[cell.textLabel setFont:[USFont defaultTableCellTextFont]];		
    }
	NSString *cellText;
    if (self.searching) {
		cellText = [searchData objectAtIndex:indexPath.row];
    } else {
		cellText = [self.arrTableDataSource objectAtIndex:indexPath.row];
    }
	cell.textLabel.text = cellText;
    if([cellText isEqualToString:self.selectedText] ||
	   [cellText isEqual:self.selectedText]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _selectedRow = indexPath;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *_tableview;
    NSString *_text;
    
    if(self.searching) {
        _tableview = searchDisplayController.searchResultsTableView;
        _text = [searchData objectAtIndex:indexPath.row];
    } else {
        _tableview = self.tableView;
        _text = [self.arrTableDataSource objectAtIndex:indexPath.row];
    }

    [_tableview deselectRowAtIndexPath:indexPath animated:YES];
    [_tableview cellForRowAtIndexPath:_selectedRow].accessoryType = UITableViewCellAccessoryNone;
    [_tableview cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    _selectedRow = indexPath; // holding for future purpose
    self.selectedText = [self.arrTableDataSource objectAtIndex:indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedValue:)]) {
        [self.delegate selectedValue:_text];
    }
}

#pragma mark - Search Display Controller
#pragma mark ADD
- (void)addSearchDisplayController {
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsTableView.delegate = self;
    searchDisplayController.searchResultsTableView.dataSource = self;
    
    self.tableView.tableHeaderView = searchBar;
}

#pragma mark DELEGATES
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    self.searching = YES;
    [self.tableView reloadData];
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    self.searching = NO;
    [self.tableView reloadData];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:searchDisplayController.searchBar.text scope:
     [[searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [searchData removeAllObjects];

    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    searchData = [NSMutableArray arrayWithArray:[self.arrTableDataSource filteredArrayUsingPredicate:predicate]];
}

@end
