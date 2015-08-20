//
//  USRetailersListTVC.m
//  unscrewed
//
//  Created by Sourabh Bhardwaj on 19/02/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USRetailersListTVC.h"
#import "USFindRetailerCell.h"
#import "USRetailers.h"
#import "USLocationManager.h"
#import "USWebViewController.h"

@interface USRetailersListTVC ()<USFindRetailerCellDelegate>

@property(nonatomic)BOOL gettingPlaces;
@property(nonatomic,strong)USRetailers *objRetailers;

@end

@implementation USRetailersListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.isViewingOnline) {
        UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(sortButtonClicked:)];
        self.navigationItem.rightBarButtonItem = sortButton;
    }
	[self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USFindRetailerCell class]) bundle:nil]
         forCellReuseIdentifier:@"USFindRetailerCell"];
    
    [self getPlaces];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sortButtonClicked:(id)sender {
    DLog(@"Show sorting details");
}


#pragma mark Get Places
- (void)getPlaces {
    self.gettingPlaces = YES;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:self.wineId forKey:@"wine_id"];
    if (self.isViewingOnline) {
        [params setObject:@YES forKey:showOnlineKey];
	} else {
		[params setObject:@YES forKey:showOfflineKey];
		USLocation *selectedLocation = [[USLocationManager sharedInstance] selectedLocationCordinate];
		if (selectedLocation) {
			[params setObject:selectedLocation.latitudeAsString forKey:latitudeKey];
			[params setObject:selectedLocation.longitudeAsString forKey:longitudeKey];
		}
	}
    USRetailers *objRetailers;
    if (!self.objRetailers) {
        self.objRetailers = [USRetailers new];
    }
    objRetailers = self.objRetailers;
    
    LogInfo(@"params = %@",params);
    [[HelperFunctions sharedInstance] showProgressIndicator];
    [objRetailers getPlacesWithParams:params
                               target:self
                           completion:@selector(getPlacesSuccessHandlerWithInfo:)
                              failure:@selector(getPlacesFailureHandlerWithError:)];
}

- (void)getPlacesFailureHandlerWithError:(id)error {
    LogError(@"error = %@",error);
    self.gettingPlaces = NO;
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

- (void)getPlacesSuccessHandlerWithInfo:(id)info {
    self.gettingPlaces = NO;
    [[HelperFunctions sharedInstance] hideProgressIndicator];
    [self.tableView reloadData];
}


#pragma mark - USFindRetailerCellDelegate
- (void)btnBuyOrPickUpFromStore:(NSString *)storeUrl forStore:(NSString *)storeName {
    USWebViewController *objWebVC = [[USWebViewController alloc] init];
    objWebVC.title = storeName;
    objWebVC.storeUrl = storeUrl;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:objWebVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objRetailers.arrPlaces.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    USFindRetailerCell *cell = (USFindRetailerCell *)[tableView dequeueReusableCellWithIdentifier:@"USFindRetailerCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell fillRetailerInfo:[self.objRetailers.arrPlaces objectAtIndex:indexPath.row]];
    return cell;
}

@end
