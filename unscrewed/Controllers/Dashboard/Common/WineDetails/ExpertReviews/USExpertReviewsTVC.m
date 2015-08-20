//
//  USExpertReviewsTVC.m
//  unscrewed
//
//  Created by Robin Garg on 20/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USExpertReviewsTVC.h"
#import "USExpertReviewCell.h"
#import "USExpertReviews.h"
#import "USExpertReview.h"

@interface USExpertReviewsTVC ()<USExpertReviewCellDelegate>

@end

@implementation USExpertReviewsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USExpertReviewCell class]) bundle:nil]
		 forCellReuseIdentifier:NSStringFromClass([USExpertReviewCell class])];
	[self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
	[self.tableView setRowHeight:103.f];
    
    [self.navigationItem setTitle:@"Expert Review"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//    return self.objExpertReviews.arrExpertReviews.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    USExpertReviewCell *cell = (USExpertReviewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USExpertReviewCell class]) forIndexPath:indexPath];
	cell.delegate = self;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
//	[cell fillExpertReviewCellWithInfo:self.objExpertReviews.arrExpertReviews[indexPath.row]];
	[cell fillExpertReviewCellWithInfo:self.expertReview];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	USExpertReview *objExpertReview = [self.objExpertReviews.arrExpertReviews objectAtIndex:indexPath.row];
	return [USExpertReviewCell cellHeightForExpertReview:objExpertReview];
}

#pragma mark Expert Review Cell Delegate
- (void)expertReviewCellSelectedWithExpertReviewInfo:(USExpertReview *)expertReview {
}

@end
