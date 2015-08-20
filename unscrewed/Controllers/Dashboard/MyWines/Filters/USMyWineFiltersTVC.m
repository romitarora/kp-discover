//
//  USMyWineFiltersTVC.m
//  unscrewed
//
//  Created by Robin Garg on 11/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USMyWineFiltersTVC.h"
#import "USMeSceneCell.h"
#import "USDetailTVC.h"

@interface USMyWineFiltersTVC ()<USDetailTVCDelegate> {
	NSInteger selectedFilterIndex;
}

@end

@implementation USMyWineFiltersTVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *myWineFilter = [[NSUserDefaults standardUserDefaults] objectForKey:kMyWinesFilterTitleKey];
	if (!myWineFilter) {
		selectedFilterIndex = -1;
	} else if ([myWineFilter isEqualToString:kMyWinesFilterLikeTitle]) {
		selectedFilterIndex = 0;
	} else if ([myWineFilter isEqualToString:kMyWinesFilterWantTitle]) {
		selectedFilterIndex = 1;
	} else if ([myWineFilter isEqualToString:kMyWinesFilterRateTitle]) {
		selectedFilterIndex = 2;
	}
	
	self.navigationItem.title = @"Filter";
	[self.view setBackgroundColor:[USColor optionsViewBGColor]];
	[self.tableView setSeparatorColor:[USColor settingsViewTableSeparatorColor]];
	
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USMeSceneCell class]) bundle:nil]
		 forCellReuseIdentifier:NSStringFromClass([USMeSceneCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark Save Filter Option
- (void)saveFilterOptionForIndex:(NSInteger)row {
	if (selectedFilterIndex == row) {
		selectedFilterIndex = -1;
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:kMyWinesFilterTitleKey];
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:kMyWinesFilterValueKey];
	} else {
		switch (row) {
			case 0:
				[[NSUserDefaults standardUserDefaults] setObject:kMyWinesFilterLikeTitle forKey:kMyWinesFilterTitleKey];
				[[NSUserDefaults standardUserDefaults] setObject:kMyWinesFilterLikeValue forKey:kMyWinesFilterValueKey];
				break;
			case 1:
				[[NSUserDefaults standardUserDefaults] setObject:kMyWinesFilterWantTitle forKey:kMyWinesFilterTitleKey];
				[[NSUserDefaults standardUserDefaults] setObject:kMyWinesFilterWantValue forKey:kMyWinesFilterValueKey];
				break;
			default:
				[[NSUserDefaults standardUserDefaults] setObject:kMyWinesFilterRateTitle forKey:kMyWinesFilterTitleKey];
				[[NSUserDefaults standardUserDefaults] setObject:kMyWinesFilterRateValue forKey:kMyWinesFilterValueKey];
				break;
		}
		selectedFilterIndex = row;
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
	if (self.delegate && [self.delegate respondsToSelector:@selector(myWinesFilterSelectionCompletedForSorting:)]) {
		[self.delegate myWinesFilterSelectionCompletedForSorting:NO];
	}
}

#pragma mark Navigation
- (void)navigateToSortSelectionViewController {
	USDetailTVC *objDetailTVC = [[USDetailTVC alloc] initWithStyle:UITableViewStylePlain];
	objDetailTVC.arrTableDataSource = [HelperFunctions arrMyWinesSortOptions];
	objDetailTVC.selectedText = [[NSUserDefaults standardUserDefaults] objectForKey:kMyWinesFilterSortTypeKey];
	objDetailTVC.removeSearchOption = YES;
	objDetailTVC.delegate = self;
	[self.navigationController pushViewController:objDetailTVC animated:YES];
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return (section == 0 ? 1 : 3);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	USMeSceneCell *cell = (USMeSceneCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USMeSceneCell class])];
	[cell fillMyWinesFilterCellForIndexPath:indexPath];
	return cell;	
}

#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 1) {
		[self saveFilterOptionForIndex:indexPath.row];
	} else {
		[self navigateToSortSelectionViewController];
	}
}

#pragma mark Detail View Selection Completion Delegate
- (void)selectedValue:(NSString*)value {
	[[NSUserDefaults standardUserDefaults] setObject:value forKey:kMyWinesFilterSortTypeKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
	if (self.delegate && [self.delegate respondsToSelector:@selector(myWinesFilterSelectionCompletedForSorting:)]) {
		[self.delegate myWinesFilterSelectionCompletedForSorting:YES];
	}
}

@end
