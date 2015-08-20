//
//  USNewPriceTVC.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 25/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USNewPriceTVC.h"
#import "USDetailTVC.h"
#import "USInputVC.h"

@interface USNewPriceTVC ()<USDetailTVCDelegate,USInputVCDelegate>
{
    NSIndexPath *_selectedRow;
    NSArray *dummyRetailers;
    UIImageView *imgViewSnapped;
}
@end

@implementation USNewPriceTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.sectionFooterHeight = 0.f;
    self.tableView.sectionHeaderHeight = 0.f;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.00001)]; // neglegible height
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.00001)]; // neglegible height
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *submitBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitBarButtonClicked:)];
    self.navigationItem.rightBarButtonItem = submitBarButton;
	
	if (self.openFor == OpenForAddWineInRetailer) {
		UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonClicked:)];
		self.navigationItem.leftBarButtonItem = cancelBarButton;
	}
    
    dummyRetailers = [NSArray arrayWithObjects:@"retailer 1",@"retailer 2",@"retailer 3",@"retailer 4",@"retailer 5",@"retailer 6",@"retailer 7",@"retailer 8",@"retailer 9",@"retailer 10",@"retailer 11",@"retailer 12",@"retailer 13",@"retailer 14",@"retailer 15",@"retailer 16",@"retailer 17",@"retailer 18", nil];
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
	return (self.openFor == OpenForAddWineInRetailer ? 4 : 3);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return kScreenHeight - 246; // 64 + (44 * 3) + 50
    }
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"new_price_cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *textTitle, *detailTextValue;
    switch (indexPath.row) {
        case 0:
            textTitle = @"Retailer";
            detailTextValue = @"";
            break;
        case 1:
            textTitle = @"Size";
            detailTextValue = @"750ML"; // default value is 750ML
            break;
        case 3:
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            imgViewSnapped = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 246)];
            imgViewSnapped.image = self.wineImage;
            [cell.contentView addSubview:imgViewSnapped];
            break;
        default:
            textTitle = @"Price";
            detailTextValue = @"";
            break;
    }
    cell.textLabel.text = textTitle;
    cell.detailTextLabel.text = detailTextValue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedRow = indexPath;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    USDetailTVC *detailVC = [[USDetailTVC alloc] initWithStyle:UITableViewStyleGrouped];
    detailVC.selectedText = selectedCell.detailTextLabel.text;
    detailVC.delegate = self;
    
    switch (indexPath.row) {
        case 0:
            detailVC.title = @"Retailer";
            detailVC.arrTableDataSource = dummyRetailers;
            break;
        case 1:
            detailVC.title = @"Size";
            detailVC.arrTableDataSource = [NSArray arrayWithObjects:@"1.5L",@"750ML",@"375ML", nil];
            break;
        case 3:
            LogInfo(@"Image tapped");
            return;
        default:
            [self navigateToPriceInputFrom:selectedCell];
            return;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)navigateToPriceInputFrom:(UITableViewCell *)cell {
    USInputVC *inputVC = [USInputVC new];
    inputVC.title = @"Price";
    inputVC.placeHolderText = @"Enter Price";
    inputVC.keyboardType = NUMBER_PUNCTUATION;
	inputVC.inputType = InputTypePrice;
    inputVC.delegate = self;
    if (cell.detailTextLabel.text.length > 0) {
        inputVC.selectedText = [cell.detailTextLabel.text substringFromIndex:1]; // remove dollar sign $
    }
    [self.navigationController pushViewController:inputVC animated:YES];
}


#pragma mark - DetailVC Delegate
- (void)selectedValue:(NSString *)value {
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:_selectedRow];
    selectedCell.detailTextLabel.text = value;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inputBoxValueEntered:(NSString *)value {
    [self selectedValue:[NSString stringWithFormat:@"$%@",value]];
}

#pragma mark - Bar Button Action Event
- (void)submitBarButtonClicked:(UIBarButtonItem *)sender {
    LogInfo(@"submit clicked. Hit api to update records");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelBarButtonClicked:(UIBarButtonItem *)sender {
	LogInfo(@"cancel clicked. navigate back without success");
	[self.navigationController popViewControllerAnimated:YES];
}

@end
