//
//  USFriendsLikeWinesVC.m
//  unscrewed
//
//  Created by Sourabh B. on 27/05/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USFriendsLikeWinesVC.h"
#import "USWineSearchResultsCell.h"
#import "USWineDetailTVC.h"
#import "USWines.h"

@interface USFriendsLikeWinesVC ()
{
    __weak IBOutlet UITableView *tableview;
}

@property (nonatomic, strong) USWines *objWines;
@property (nonatomic, assign) BOOL gettingWines;

@property (nonatomic, strong) NSMutableArray *wineResults;


@end

@implementation USFriendsLikeWinesVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [tableview registerNib:[UINib nibWithNibName:@"USWineSearchResultsCell" bundle:nil] forCellReuseIdentifier:@"USWineSearchResultsCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getLikedWines];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Get Wines
- (void)getLikedWines {
//    if (!self.objWines)
    {
        self.objWines = [USWines new];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    self.gettingWines = YES;
    [params setObject:@YES forKey:self.filterType];
    [params setObject:self.placeId forKey:@"place_id"];
    
    LogInfo(@"params = %@",params);
    [[HelperFunctions sharedInstance] showProgressIndicator];
    [self.objWines getFriendLikeWinesWithParams:params
                               target:self
                           completion:@selector(getWinesSuccessHandlerWithInfo:)
                              failure:@selector(getWinesFailureHandlerWithError:)];
}


- (void)getWinesFailureHandlerWithError:(id)error {
    DLog(@"error = %@",error);
    self.gettingWines = NO;
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

- (void)getWinesSuccessHandlerWithInfo:(id)info {
    self.gettingWines = NO;
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    [tableview reloadData];
}


#pragma mark Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objWines.arrWines.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155.f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    USWineSearchResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USWineSearchResultsCell" forIndexPath:indexPath];
	cell.wineCellType = WineCellTypeFromRetailer;
    USWine *wine = [self.objWines.arrWines objectAtIndex:indexPath.row];
    [cell fillWineCellWithWineInfo:wine indexPath:indexPath];
    
    return cell;
}


#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    USWine *wine = [self.objWines.arrWines objectAtIndex:indexPath.row];
    [self navigateToWineDetailsViewControllerForWine:wine];
}

#pragma mark Navigation
- (void)navigateToWineDetailsViewControllerForWine:(USWine *)wine {
    USWineDetailTVC *objWineDetailsTVC = [[USWineDetailTVC alloc] initWithStyle:UITableViewStylePlain];
    objWineDetailsTVC.wineId = wine.wineId;
    objWineDetailsTVC.wineName = wine.name;
    [self.navigationController pushViewController:objWineDetailsTVC animated:YES];
}

@end
