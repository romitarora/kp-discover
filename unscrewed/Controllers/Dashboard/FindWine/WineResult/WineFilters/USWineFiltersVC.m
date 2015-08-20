//
//  USWineFiltersVC.m
//  unscrewed
//
//  Created by Robin Garg on 12/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USWineFiltersVC.h"
#import "USMeSceneCell.h"
#import "USDetailTVC.h"
#import "USPillCell.h"
#import "UICollectionViewLeftAlignedLayout.h"

#define PillCellHeaderHeight 37.f
#define PillCellFooterHeight 16.f
#define TransparentViewHeight 16.f

@interface USWineFiltersVC ()<UITableViewDataSource, UITableViewDelegate, USFilterValueSelectionDelegate,UICollectionViewDataSource,UICollectionViewDelegate,USPillCellDelegate>
{
    NSIndexPath *selectedIndexPath;
    NSString *collectionViewCellIdentifier;
    USPillCell *selectedPillCell;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation USWineFiltersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    collectionViewCellIdentifier = @"WineTypeCollectionCell";
	
	if (self.detailView) {
		self.navigationItem.title = self.selectedFilter.wineFilterTitle;
		[self.tableView setAllowsMultipleSelection:YES];
	} else {
		self.navigationItem.title = @"Filter";
	}
	UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonDoneActionEvent)];
	[self.navigationItem setLeftBarButtonItem:barButtonDone];
	
	if (self.sort == NO) {
		UIBarButtonItem *barButtonClear = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonClearActionEvent)];
		[self.navigationItem setRightBarButtonItem:barButtonClear];
	}
	[self.tableView setBackgroundColor:[USColor optionsViewBGColor]];
	[self.tableView setSeparatorColor:[USColor settingsViewTableSeparatorColor]];
	[self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.tableView.frame), 15)]];
	[self.tableView setSectionFooterHeight:0.f];
	[self.tableView setSectionHeaderHeight:15.f];
	
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USMeSceneCell class]) bundle:nil]
		 forCellReuseIdentifier:NSStringFromClass([USMeSceneCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark Get Wine Filter Object
- (USWineFilter *)wineFilterAtIndexPath:(NSIndexPath *)indexPath {
	USWineFilter *filter = nil;
	if (indexPath.section == 0) {
		filter = self.objWineFilters.sortFilter;
	} else {
		if (self.isNearByFilters && indexPath.section == 1) {
			filter = self.objWineFilters.distanceFilter;
		} else {
			filter = [self.objWineFilters.arrFilters objectAtIndex:indexPath.row];
		}
	}
	return filter;
}

#pragma mark Navigation
- (void)navigateToValueSelectorViewControllerWithWineFilter:(USWineFilter *)selectedWineFilter sort:(BOOL)sort {
	USWineFiltersVC *objWineFitlersVC = [[USWineFiltersVC alloc] initWithNibName:@"USWineFiltersVC" bundle:nil];
	objWineFitlersVC.selectedFilter = selectedWineFilter;
	objWineFitlersVC.valueSelectorDelegate = self;
	objWineFitlersVC.detailView = YES;
	objWineFitlersVC.sort = sort;
	[self.navigationController pushViewController:objWineFitlersVC animated:YES];
}

#pragma mark - Calculate Height
- (float)heightForFilterAtIndex:(NSInteger)rowIndex {
	USWineFilter *wineFilter = [self.objWineFilters.arrFilters objectAtIndex:rowIndex];
	int numberOfRows = MIN(2, ceil(wineFilter.objValues.arrValues.count / 2.f));
	float rowsHeight = ceilf(29.f * numberOfRows);
	float paddingBetweenRows = 11.f * (numberOfRows-1);
	float cellHeight = rowsHeight + paddingBetweenRows;
	if ([wineFilter.wineFilterKey isEqualToString:filterStylesKey]) {
		cellHeight += PillCellHeaderHeight + PillCellFooterHeight + TransparentViewHeight;
	} else {
		cellHeight += PillCellHeaderHeight + PillCellFooterHeight + (TransparentViewHeight * 2);
	}
    return cellHeight;
}

#pragma mark - $$ EVENT HANDLERS $$
#pragma mark Bar Button Event Handler
- (void)barButtonDoneActionEvent {
    LogInfo(@"Done Tapped");
	if (self.detailView) {
		if (self.valueSelectorDelegate &&
			[self.valueSelectorDelegate respondsToSelector:@selector(filterValueSelectedForFilter:selectedValue:)]) {
			[self.valueSelectorDelegate filterValueSelectedForFilter:self.selectedFilter selectedValue:self.selectedFilter.selectedValue];
		}
	} else {
		if (self.delegate && [self.delegate respondsToSelector:@selector(wineFilterSelectionDoneWithObject:)]) {
			[self.delegate wineFilterSelectionDoneWithObject:self.objWineFilters];
		}
	}
}

- (void)barButtonClearActionEvent {
    LogInfo(@"Clear Tapped");
	if (self.detailView) {
		if (self.selectedFilter.selectedValue) {
			NSInteger prevSelValue = [self.selectedFilter.objValues.arrValues indexOfObject:self.selectedFilter.selectedValue];
			self.selectedFilter.selectedValue = nil;
			[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:prevSelValue inSection:0]]
								  withRowAnimation:UITableViewRowAnimationNone];
			
		}
	} else {
		// Reset Sort
		USFilterValue *bestValue =
		[HelperFunctions filterValueForSelectedValue:self.objWineFilters.sortFilter.defaultValue
											  values:self.objWineFilters.sortFilter.objValues];
		self.objWineFilters.sortFilter.selectedValue = bestValue;
		[[NSUserDefaults standardUserDefaults] setObject:bestValue.filterValue forKey:kWinesSortTypeKey];
		// Reset Distance
		USFilterValue *defaultDistance =
		[HelperFunctions filterValueForSelectedValue:self.objWineFilters.distanceFilter.defaultValue
											  values:self.objWineFilters.distanceFilter.objValues];
		self.objWineFilters.distanceFilter.selectedValue = defaultDistance;
		[[NSUserDefaults standardUserDefaults] setObject:defaultDistance.filterValue forKey:kWinesDistanceKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
		// Reset Filters
		for (USWineFilter *wineFilter in self.objWineFilters.arrFilters) {
			wineFilter.selectedValue = nil;
		}
		
		USWineFilter *styleFilter = [self getFilterForKey:filterStylesKey];
		if (styleFilter) {
			[self.objWineFilters.arrFilters removeObject:styleFilter];
		}
		[self.tableView reloadData];
	}
}

#pragma mark - TABLEVIEW
#pragma mark Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	if (self.detailView) {
		return 1;
	} else if (self.isNearByFilters) {
		return 3;
	}
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	if (self.detailView) {
		return self.selectedFilter.objValues.arrValues.count;
	}

    if ((self.isNearByFilters && section == 2) ||
		(self.isNearByFilters == NO && section == 1)) {
		return self.objWineFilters.arrFilters.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.detailView) {
		USWineFilter *objFilter = [self.objWineFilters.arrFilters objectAtIndex:indexPath.row];
		if (objFilter.isPillFilter) {
			return ceilf([self heightForFilterAtIndex:indexPath.row]);
		}
	}
	return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DLog(@"cellForRowAtIndexPath");
	USMeSceneCell *cell = (USMeSceneCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USMeSceneCell class])];
	CGRect rect = cell.frame;
	rect.size.width = CGRectGetWidth([[UIApplication sharedApplication] keyWindow].frame) - kTransparentAreaWidth;
	cell.frame = rect;
	// Select Value
	if (self.detailView) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		USFilterValue *objValue = [self.selectedFilter.objValues.arrValues objectAtIndex:indexPath.row];
		[cell fillWineFilterValue:objValue selected:[objValue isEqual:self.selectedFilter.selectedValue] sort:self.sort];
		cell.accessoryType = UITableViewCellAccessoryNone;
		if ([objValue isEqual:self.selectedFilter.selectedValue]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		return cell;
	}
	
    if (indexPath.section == 0) {
        [cell fillWinesFilterCellForFilter:self.objWineFilters.sortFilter];
	} else {
		if (self.isNearByFilters && indexPath.section == 1) {
			[cell fillWinesFilterCellForFilter:self.objWineFilters.distanceFilter];
		} else {
			USWineFilter *filter = [self.objWineFilters.arrFilters objectAtIndex:indexPath.row];
			if (filter.isPillFilter) {
				return [self buildPillShapeFilterCellForIndexPath:indexPath];
			} else {
				[cell fillWinesFilterCellForFilter:filter];
			}
		}
	}
	return cell;
}

#pragma mark Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.detailView) {
		USFilterValue *filterValue = [self.selectedFilter.objValues.arrValues objectAtIndex:indexPath.row];

		NSMutableArray *rowsToBeReload = [NSMutableArray new];
		if (self.selectedFilter.selectedValue) {
			if ([self.selectedFilter.selectedValue isEqual:filterValue]) {
				if (self.sort) return;
				self.selectedFilter.selectedValue = nil;
			} else {
				NSInteger prevSelValue = [self.selectedFilter.objValues.arrValues indexOfObject:self.selectedFilter.selectedValue];
				[rowsToBeReload addObject:[NSIndexPath indexPathForRow:prevSelValue inSection:0]];
				self.selectedFilter.selectedValue = filterValue;
			}
		} else {
			self.selectedFilter.selectedValue = filterValue;
		}
		[rowsToBeReload addObject:indexPath];
		[self.tableView reloadRowsAtIndexPaths:rowsToBeReload withRowAnimation:UITableViewRowAnimationNone];
	} else {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		selectedIndexPath = indexPath;
		USWineFilter *filter = [self wineFilterAtIndexPath:indexPath];
		
		BOOL isSortOrDistance = (indexPath.section == 0 || (self.isNearByFilters && indexPath.section == 1));
		[self navigateToValueSelectorViewControllerWithWineFilter:filter sort:isSortOrDistance];
	}
}

#pragma mark - DetailVC Delegate
- (void)filterValueSelectedForFilter:(USWineFilter *)wineFilter selectedValue:(USFilterValue *)filterValue {
	if (selectedIndexPath.section == 0) {
		[[NSUserDefaults standardUserDefaults] setObject:self.objWineFilters.sortFilter.selectedValue.filterValue
												  forKey:kWinesSortTypeKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} else if ([wineFilter.wineFilterKey isEqualToString:radiusKey]) {
		[[NSUserDefaults standardUserDefaults] setObject:self.objWineFilters.distanceFilter.selectedValue.filterValue
												  forKey:kWinesDistanceKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} else { // If Wine Type Filter selected Update Wine Style Filter
		if ([wineFilter.wineFilterKey isEqualToString:filterTypesKey]) {
			USWineFilter *styleFilter = [USWineFilters wineStyleFilterForValue:filterValue];
			if (!styleFilter) { // If no style filter for selected Wine Type.
				USWineFilter *filter = [self getFilterForKey:filterStylesKey];
				if (filter) {  // then remove style filter if previously added
					[self.objWineFilters.arrFilters removeObject:filter];
				}
			} else { // Either add or update style filter
				USWineFilter *filter = [self getFilterForKey:filterStylesKey];
				if (filter) {
					int index = [self.objWineFilters.arrFilters indexOfObject:filter];
					[self.objWineFilters.arrFilters replaceObjectAtIndex:index withObject:styleFilter];
				} else {
					int index = [self.objWineFilters.arrFilters indexOfObject:wineFilter];
					[self.objWineFilters.arrFilters insertObject:styleFilter atIndex:index+1];
				}
			}
		}
	}
	//[self.tableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	[self.tableView reloadData];
	selectedIndexPath = nil;
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - COLLECTION VIEW
- (UITableViewCell *)buildPillShapeFilterCellForIndexPath:(NSIndexPath *)indexPath {
    static NSString *pillCellIdentifier = @"Pill-Shape-Cell-Identifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:pillCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pillCellIdentifier];
        CGRect rect = cell.frame;
        rect.size.width = CGRectGetWidth([[UIApplication sharedApplication] keyWindow].frame) - kTransparentAreaWidth;
        cell.frame = rect;
        cell.backgroundColor = [UIColor clearColor];
        
        //calculate height for collectionview
        float heightt = [self heightForFilterAtIndex:indexPath.row];
        
        // setup layout for collection view
		UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];		
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, ceilf(heightt)) collectionViewLayout:flowLayout];
        [collectionView setShowsHorizontalScrollIndicator:NO];
        [collectionView setBackgroundColor:[UIColor whiteColor]];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.tag = indexPath.row;
		collectionView.scrollEnabled = NO;
        
        // register cell
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([USPillCell class]) bundle:nil] forCellWithReuseIdentifier:collectionViewCellIdentifier];
        
        // register header and footers
        [flowLayout setHeaderReferenceSize:CGSizeMake(rect.size.width, PillCellHeaderHeight + TransparentViewHeight)];
        [flowLayout setFooterReferenceSize:CGSizeMake(rect.size.width, PillCellFooterHeight + TransparentViewHeight)];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind: UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];

        [cell.contentView addSubview:collectionView];
	} else {
		UICollectionView *collectionView = (UICollectionView *)[cell.contentView viewWithTag:indexPath.row];
		float heightt = [self heightForFilterAtIndex:indexPath.row];
		
		CGRect rect = collectionView.frame;
		rect.size.height = ceilf(heightt);
		collectionView.frame = rect;
		[collectionView reloadData];
	}
    return cell;
}

#pragma mark Data Source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    USWineFilter *wineFilter = [self.objWineFilters.arrFilters objectAtIndex:collectionView.tag];
    return wineFilter.objValues.arrValues.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    USPillCell *cell = (USPillCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    USWineFilter *wineFilter = [self.objWineFilters.arrFilters objectAtIndex:collectionView.tag];
	USFilterValue *value = [wineFilter.objValues.arrValues objectAtIndex:indexPath.item];
    [cell fillWithFilter:value selected:[value isEqual:wineFilter.selectedValue]];
    return cell;
}

#pragma mark Flow Layout Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    USWineFilter *wineFilter = [self.objWineFilters.arrFilters objectAtIndex:collectionView.tag];
    CGSize sizeOfCell = CGSizeMake([USPillCell widthForTitle:[wineFilter.objValues.arrValues objectAtIndex:indexPath.item]], 29);
    return sizeOfCell;
}

#pragma mark Insets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {   
//    NSInteger numberOfCells = self.view.frame.size.width / MaxWidthForFilterCell;
//    NSInteger edgeInsets = (self.view.frame.size.width - (numberOfCells * MaxWidthForFilterCell)) / (numberOfCells + 1);
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

#pragma mark Supplymentary Header / Footer View
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        if (reusableview == nil) {
            reusableview = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(collectionView.frame), PillCellHeaderHeight + TransparentViewHeight)];
        }
        UIView *viewLabels = [[UIView alloc] initWithFrame:reusableview.frame];
		
        UILabel *transparentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(reusableview.frame), TransparentViewHeight)];
        transparentLabel.backgroundColor = [USColor optionsViewBGColor];
        [viewLabels addSubview:transparentLabel];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(transparentLabel.frame), CGRectGetWidth(reusableview.frame) - 30, PillCellHeaderHeight)];
        label.backgroundColor = [UIColor whiteColor];
		NSString *strHeader = kEmptyString;
        USWineFilter *wineFilter = [self.objWineFilters.arrFilters objectAtIndex:collectionView.tag];
		if ([wineFilter.wineFilterKey isEqualToString:filterStylesKey]) {
			USWineFilter *wineTypeFilter = [self.objWineFilters.arrFilters objectAtIndex:collectionView.tag-1];
			strHeader = wineTypeFilter.selectedValue.filterValue;
		}
		strHeader = [strHeader stringByAppendingFormat:@" %@",wineFilter.wineFilterTitle];
        label.text = strHeader;
        //label.textAlignment = NSTextAlignmentCenter;
        label.font = [USFont defaultTableCellTextFont];
        [viewLabels addSubview:label];
        
        [reusableview addSubview:viewLabels];
        return reusableview;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        if (reusableview == nil) {
            reusableview = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(collectionView.frame), PillCellFooterHeight + TransparentViewHeight)];
        }
        
        UIView *viewLabels = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(reusableview.frame), CGRectGetHeight(reusableview.frame))];
        [viewLabels setBackgroundColor:[UIColor brownColor]];
        
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(reusableview.frame), PillCellFooterHeight)];
        footerLabel.backgroundColor = [UIColor whiteColor];
        [viewLabels addSubview:footerLabel];
        
        UILabel *transparentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(footerLabel.frame), CGRectGetWidth(reusableview.frame), TransparentViewHeight)];
        transparentLabel.backgroundColor = [USColor optionsViewBGColor];
        [viewLabels addSubview:transparentLabel];
        
        [reusableview addSubview:viewLabels];
        return reusableview;
    }
    return nil;
}

#pragma mark - USPillCell Delegate
- (void)filterValueSelected:(id)senderCell {
    selectedPillCell = (USPillCell *)senderCell;
    USFilterValue *selectedFilterValue = selectedPillCell.filter;
    
    UICollectionView *collectionViewRef = (UICollectionView *)[selectedPillCell superview];
    
    USWineFilter *wineFilter = [self.objWineFilters.arrFilters objectAtIndex:collectionViewRef.tag];
    if(selectedFilterValue == wineFilter.selectedValue) { // to deselect current selected value
        [selectedPillCell showSetSelected:NO];
        wineFilter.selectedValue = nil;
    } else {
        if (wineFilter.selectedValue && wineFilter.selectedValue != selectedFilterValue) { // to deselect previsous selected value
            NSInteger indexOfPreviousSelectedFilter = [wineFilter.objValues.arrValues indexOfObject:wineFilter.selectedValue];
            USPillCell *previousSelectedCell = (USPillCell *)[collectionViewRef cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexOfPreviousSelectedFilter inSection:0]];
            [previousSelectedCell showSetSelected:NO];
        }
        wineFilter.selectedValue = selectedFilterValue;
    }
    [self.objWineFilters.arrFilters replaceObjectAtIndex:collectionViewRef.tag withObject:wineFilter];
}

#pragma mark - Get Filter Value
- (USWineFilter *)getFilterForKey:(NSString *)key {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.wineFilterKey == %@",key];
    NSArray *arrResults = [self.objWineFilters.arrFilters filteredArrayUsingPredicate:predicate];
    if (arrResults.count) {
        USWineFilter *filter = [arrResults objectAtIndex:0];
        return filter;
    }
    return nil;
}

- (NSInteger )indexOfFilterWithKey:(NSString *)key {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.wineFilterKey == %@",key];
    NSArray *arrResults = [self.objWineFilters.arrFilters filteredArrayUsingPredicate:predicate];
    if (arrResults.count) {
        USWineFilter *filter = [arrResults objectAtIndex:0];
        return [self.objWineFilters.arrFilters indexOfObject:filter];
    }
    return -1;
}

@end
