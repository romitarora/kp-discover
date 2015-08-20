//
//  WineDealSelectionViewController.m
//  unscrewed-ios
//
//  Created by Gary Earle on 8/13/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USWineSearchFirstFilterTVC.h"
#import "USWineSearchResultsTVC.h"
#import "USWineTypeCollectionCell.h"
#import "USSettingsTVC.h"
#import "USSearchOperation.h"
#import "USWines.h"
#import "USWineDetailTVC.h"
#import "USLocationManager.h"
#import "USMyWineFiltersTVC.h"
#import "USMyWinesTVC.h"
#import "USWineTabBarRootVC.h"
#import "USIntermediateTVC.h"
#import <AlgoliaSearch-Client/ASAPIClient.h>
#import <AlgoliaSearch-Client/ASRemoteIndex.h>

static NSString *const collectionViewCellIdentifire = @"WineTypeCollectionCell";

@interface USWineSearchFirstFilterTVC ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
	ASRemoteIndex *index;
    int selectedWineIndex;//OneClick
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *arrWineTypes;
@property (nonatomic, strong) NSArray *arrWineFilterOptions;

@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, assign, getter=isSearching) BOOL searching;
@property (nonatomic, strong) USWines *objSearchedWines;
@property (nonatomic, assign) BOOL gettingWines;
@property (nonatomic, strong) NSOperationQueue *searchQueue;

@property (nonatomic, strong) USWines *objSnappedWines;
@property (nonatomic, strong) USWineFilters *objWineFilters;

@end

@implementation USWineSearchFirstFilterTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.searchQueue = [NSOperationQueue new];
	index = [[kAppDelegate apiClient] getIndex:@"wines_production"];

	[self.navigationItem setTitleView:[HelperFunctions kerningTitleViewWithTitle:@"unscrewed"]];
	self.arrWineTypes = [HelperFunctions arrWineTypesForRetailer:NO];
	self.arrWineFilterOptions = [HelperFunctions arrFindWineOptionsWithSnap];
	[self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
	[self.tableView setTableFooterView:[UIView new]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor=[UIColor clearColor];

	
	[self.searchDisplayController.searchBar setPlaceholder:@"Search wines"];
	[self.searchDisplayController.searchResultsTableView setSeparatorColor:[USColor cellSeparatorColor]];

	UIBarButtonItem *barButtonSettings = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(barButtonSettingsTappedEvent)];
	[barButtonSettings setImageInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
	[self.navigationItem setLeftBarButtonItem:barButtonSettings];

	UIBarButtonItem *barButtonCamera = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"] style:UIBarButtonItemStylePlain target:self action:@selector(snapMethodClick)];
    [barButtonCamera setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.navigationItem setRightBarButtonItem:barButtonCamera];
    
    [[self.arrWineTypes objectAtIndex:0] setObject:@"yes" forKey:@"selected"];
    [[self.arrWineFilterOptions objectAtIndex:0] setObject:@"All Reds" forKey:@"title"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddress) name:@"refreshAddress" object:nil];
        [self refreshAddress];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (!self.objWineFilters) {
		[self getWineFilters];
	}
}

-(void)refreshAddress
{
    
    USLocation *selectedLocation = [[USLocationManager sharedInstance] selectedLocationCordinate];
    if (selectedLocation)
    {
    }
    
    
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:[selectedLocation.latitudeAsString doubleValue] longitude:[selectedLocation.longitudeAsString doubleValue]]; //insert your coordinates
    
    
    NSString * str =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"SelectedLocation"]];
    
    
    if ([str isEqualToString:@"1"])
        
    {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"current_lat"] ==nil||[[NSUserDefaults standardUserDefaults] valueForKey:@"current_lon"] ==nil)
        {
            loc = [[CLLocation alloc]initWithLatitude:0 longitude:0];
            
        }
        else
        {
            loc = [[CLLocation alloc]initWithLatitude:[[[NSUserDefaults standardUserDefaults] valueForKey:@"current_lat"] doubleValue] longitude:[[[NSUserDefaults standardUserDefaults] valueForKey:@"current_lon"] doubleValue]];
            
        }
        
    }
    
    
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  NSLog(@"placemark %@",placemark);
                  //String to hold address
                  NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                  NSLog(@"addressDictionary %@", placemark.addressDictionary);
                  
                  NSLog(@"placemark %@",placemark.region);
                  NSLog(@"placemark %@",placemark.country);  // Give Country Name
                  NSLog(@"placemark %@",placemark.locality); // Extract the city name
                  NSLog(@"location %@",placemark.name);
                  
                  
                  NSLog(@"location %@",placemark.ocean);
                  NSLog(@"location %@",placemark.postalCode);
                  NSLog(@"location %@",placemark.subLocality);
                  
                  NSLog(@"location %@",placemark.location);
                  //Print the location to console
                  NSLog(@"I am currently at %@",locatedAt);
                  
                  if ([str isEqualToString:@"1"])
                      
                  {
                      [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"Search near %@",placemark.name] forKey:@"localAddress"];
                      [[NSUserDefaults standardUserDefaults] synchronize];

                  }
                  else
                  {
                      NSString * stateStr =[NSString stringWithFormat:@"%@",[placemark.addressDictionary objectForKey:@"State"]];
                      
                      if (stateStr==nil || [stateStr length]==0)
                      {
                          stateStr=@"";
                      }
                      else
                      {
                          
                      }
                      [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"Search near %@,%@",placemark.locality,stateStr] forKey:@"localAddress"];
                      [[NSUserDefaults standardUserDefaults] synchronize];

                  }
                  [self.tableView reloadData];
              }
     
     ];
}
#pragma mark - Photo Tap Method
-(void)snapMethodClick
{
    [self openActionSheetToAddPhoto];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark Pagination
//Load more wines if table view scroll to the end
- (void)loadMorePostsIfTableScrolledToLastRecord {
	NSArray *arrVisibleRows = [self.searchDisplayController.searchResultsTableView indexPathsForVisibleRows];
	NSIndexPath *lastVisibleIndexPath = [arrVisibleRows lastObject];
	if (lastVisibleIndexPath.row == self.objSearchedWines.arrWines.count-1 && self.objSearchedWines.isReachedEnd == NO) {
		if (self.gettingWines == NO) {
			// Get More Wines
			[self loadMoreAutofilWines];
			/*
			NSMutableDictionary *params = [NSMutableDictionary new];
			[params setObject:self.searchString forKey:queryKey];
			[self getWinesWithParam:params];*/
		}
	}
}

- (NSDictionary *)presetFiltersForIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *dictionary;
	switch (indexPath.row) {
		case 0:
			dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"Under $10", filterPriceRangesKey, nil];
			break;
		case 1:
			dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"90-95, 95-100", filterExpertRatingRangesKey,
							                                          @"Under $10, $10-$20", filterPriceRangesKey, nil];
			break;
		case 2:
			break;
		case 3:
			break;
	}
	return dictionary;
}

#pragma mark Navigation
- (void)navigateToWineResultViewControllerForWineType:(NSString *)wineType presetFilter:(NSIndexPath *)indexPath
{
    if ([wineType isEqualToString:@"All Reds"])
    {
        wineType=@"red";
    }
    else if ([wineType isEqualToString:@"All Whites"])
    {
        wineType=@"white";

    }
    else if ([wineType isEqualToString:@"All Sparkling & Champagne"])
    {
        wineType=@"sparkling";

    }
   
	USWineSearchResultsTVC *objWineResultVC = [[USWineSearchResultsTVC alloc] initWithStyle:UITableViewStylePlain];
	objWineResultVC.objWineFilters = self.objWineFilters;
	if (wineType) {
		objWineResultVC.wineColorSelected = wineType;
		objWineResultVC.wineHeaderTitle = [wineType capitalizedString];
	} else {
		NSDictionary *dictionary = [self presetFiltersForIndexPath:indexPath];
		if (dictionary) {
			objWineResultVC.wineSearchArguments = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
			objWineResultVC.wineHeaderTitle = [[dictionary allValues] componentsJoinedByString:@" ,"];
		}
	}
	[self.navigationController pushViewController:objWineResultVC animated:YES];
}

- (void)navigateToWineDetailsViewControllerForWine:(USWine *)wine {
	USWineDetailTVC *objWineDetailsTVC = [[USWineDetailTVC alloc] initWithStyle:UITableViewStylePlain];
	objWineDetailsTVC.wineId = wine.wineId;
	objWineDetailsTVC.wineName = wine.name;
	[self.navigationController pushViewController:objWineDetailsTVC animated:YES];
}

#pragma mark - $$ WEB SERVICES $$
#pragma mark Get Wine Filters
- (void)getWineFiltersFailureHandlerWithError:(id)error {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
}

- (void)getWineFiltersSuccessHandlerWithInfo:(USWineFilters *)wineFilters {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	
	[wineFilters fillSortFilterWithSelectedValue:nil];
	[wineFilters fillDistanceFilterWithSelectedValue:nil];
	self.objWineFilters = wineFilters;
}
- (void)getWineFilters {
	[[HelperFunctions sharedInstance] showProgressIndicator];

	USWineFilters *objWineFilters = [USWineFilters new];
	[objWineFilters getWineFiltersWithTarget:self
									   completion:@selector(getWineFiltersSuccessHandlerWithInfo:)
										  failure:@selector(getWineFiltersFailureHandlerWithError:)];
}

#pragma mark Get Wines
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
	[self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)getWinesWithParam:(NSMutableDictionary *)params {
	self.gettingWines = YES;
	[[HelperFunctions sharedInstance] showProgressIndicator];
	[self.objSearchedWines getWinesWithParams:params
							   target:self
						   completion:@selector(getWinesSuccessHandlerWithInfo:)
							  failure:@selector(getWinesFailureHandlerWithError:)];
}

#pragma mark - $$ EVENT HANDLER $$
#pragma mark Bar Button Event
- (void)barButtonSettingsTappedEvent {
	DLog(@"Settings Icon Tapped");
	USSettingsTVC *objSettingsTVC = [[USSettingsTVC alloc] initWithStyle:UITableViewStyleGrouped];
	[self.navigationController pushViewController:objSettingsTVC animated:YES];
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
		return 1;
	}
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        return self.objSearchedWines.arrWines.count;
    }
    else
    {
        if (selectedWineIndex==3)
        {
            return (section == 0 ? 1 : self.arrWineFilterOptions.count-3);
            
        }
        else
        {
            return (section == 0 ? 1 : self.arrWineFilterOptions.count);
            
        }
    }
    return (section == 0 ? 1 : self.arrWineFilterOptions.count);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) return;

	// Set seperator inset
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		switch (indexPath.section) {
			case 0:
				[cell setSeparatorInset:UIEdgeInsetsZero];
				break;
			case 1:
				if (indexPath.row +1 == self.arrWineFilterOptions.count) {
					[cell setSeparatorInset:UIEdgeInsetsZero];
				}
			default:
				break;
		}
	}
	
	// Prevent the cell from inheriting the Table View's margin settings
	if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
		[cell setPreservesSuperviewLayoutMargins:NO];
	}
	
	// Explictly set your cell's layout margins
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		switch (indexPath.section) {
			case 0:
				[cell setLayoutMargins:UIEdgeInsetsZero];
				break;
			case 1:
				if (indexPath.row +1 == self.arrWineFilterOptions.count) {
					[cell setLayoutMargins:UIEdgeInsetsZero];
				}
			default:
				break;
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            [cell.textLabel setFont:[USFont defaultTableCellTextFont]];
            [cell.detailTextLabel setFont:[USFont tableHeaderMessageFont]];
            [cell.detailTextLabel setTextColor:[USColor lightDarkMenuOptionColor]];
        }
        USWine *objWine = [self.objSearchedWines.arrWines objectAtIndex:indexPath.row];
        [cell.textLabel setText:objWine.name];
        NSString *strDetailText = kEmptyString;
        if (objWine.wineType) {
            strDetailText = [NSString stringWithFormat:@"%@ Wine",objWine.wineType];
        }
        if (objWine.wineSubType) {
            strDetailText = [strDetailText stringByAppendingFormat:@" %@",objWine.wineSubType];
        }
        [cell.detailTextLabel setText:strDetailText.trim];
        return cell;
    }
    
    //	static NSString *wineTypeCellIdentifire = nil;
    static NSString *wineFilterCellIdentifire = nil;
    UITableViewCell *cell;
    if (indexPath.section ==0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:wineFilterCellIdentifire];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wineFilterCellIdentifire];
            [cell.imageView setTintColor:[UIColor colorWithRed:254.0/255.0 green:46.0/255.0 blue:108.0/255.0 alpha:1.0]];//[USColor themeSelectedColor]];
            [cell.textLabel setFont:[USFont defaultTableCellTextFont]];
        }
        
        UILabel * titleLbl =[[UILabel alloc] init];
        titleLbl.backgroundColor=[UIColor clearColor];
        titleLbl.frame=CGRectMake(12.8, 5, 300, 15);
        [cell.contentView addSubview:titleLbl];
        
        // Do any additional setup after loading the view, typically from a nib.
        
        NSString  * locationStr =[[NSUserDefaults standardUserDefaults] valueForKey:@"localAddress"];
        if ([locationStr length]==0 || locationStr==nil)
        {
            locationStr=@"Search near";
            
        }
        else
        {
        }
        NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] initWithString:locationStr];
        
        //Red and large
        [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:68.0/255.0 green:68.0/225.0 blue:76.0/255.0 alpha:1.0]} range:NSMakeRange(0, 11)];
        
        
        
        
        //Rest of text -- just futura
        [hintText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0f], NSForegroundColorAttributeName:[UIColor colorWithRed:68.0/255.0 green:68.0/225.0 blue:76.0/255.0 alpha:1.0]} range:NSMakeRange(11, hintText.length - 11)];
        
        
        [titleLbl setAttributedText:hintText];
        
        
        
        for(int i=0;i<[self.arrWineTypes count];i++)
        {
            UIButton * wineBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            wineBtn.frame=CGRectMake(12.8+i*(64+12.8), 33, 64, 64);
            wineBtn.tag=i;
            [wineBtn addTarget:self action:@selector(wineSelectedClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i==0)
            {
                wineBtn.frame=CGRectMake(12.8, 33, 64, 64);
                
                if ([[[self.arrWineTypes objectAtIndex:i] objectForKey:@"selected"] isEqualToString:@"yes"])
                {
                    [wineBtn setBackgroundImage:[UIImage imageNamed:@"Red Button Selected_new"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [wineBtn setBackgroundImage:[UIImage imageNamed:@"Red Button_new"] forState:UIControlStateNormal];
                    
                }
            }
            else if (i==1)
            {
                if ([[[self.arrWineTypes objectAtIndex:i] objectForKey:@"selected"] isEqualToString:@"yes"])
                {
                    [wineBtn setBackgroundImage:[UIImage imageNamed:@"White Button Selected_new"] forState:UIControlStateNormal];
                }
                else
                {
                    [wineBtn setBackgroundImage:[UIImage imageNamed:@"White Button_new"] forState:UIControlStateNormal];
                }
                
                
            }
            else if (i==2)
            {
                if ([[[self.arrWineTypes objectAtIndex:i] objectForKey:@"selected"] isEqualToString:@"yes"])
                {
                    [wineBtn setBackgroundImage:[UIImage imageNamed:@"Sparkling Button Selected_new"] forState:UIControlStateNormal];
                }
                else
                {
                    [wineBtn setBackgroundImage:[UIImage imageNamed:@"Sparkling Button_new"] forState:UIControlStateNormal];
                }
                
            }
            else if (i==3)
            {
                if ([[[self.arrWineTypes objectAtIndex:i] objectForKey:@"selected"] isEqualToString:@"yes"])
                {
                    [wineBtn setBackgroundImage:[UIImage imageNamed:@"Other Button Selected_new"] forState:UIControlStateNormal];
                }
                else
                {
                    [wineBtn setBackgroundImage:[UIImage imageNamed:@"Other Button_new"] forState:UIControlStateNormal];
                }
                
            }
            [cell.contentView addSubview:wineBtn];
        }
        
        
        UILabel * lineLbl =[[UILabel alloc] init];
        lineLbl.backgroundColor=[USColor cellSeparatorColor];
        lineLbl.frame=CGRectMake(0, 108+5, 320, 1);
        [cell.contentView addSubview:lineLbl];
        return cell;
        
    }
    
    else
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:nil];
        float cellHeight = 43.5; //Assumed from NSLog
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wineFilterCellIdentifire];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.imageView setTintColor:[UIColor colorWithRed:254.0/255.0 green:46.0/255.0 blue:108.0/255.0 alpha:1.0]];//[USColor themeSelectedColor]];
            [cell.textLabel setFont:[USFont defaultTableCellTextFont]];
        }
        NSDictionary *dictOption = [self.arrWineFilterOptions objectAtIndex:indexPath.row];
        if([[dictOption valueForKey:@"imageName"] isEqual:@"snap_pic"])
        {
            [cell.textLabel setText:[dictOption valueForKey:@"title"]];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[USFont defaultTableCellTextFont].pointSize-2]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            //[cell.textLabel setTintColor:[UIColor redColor]];
            [cell.textLabel setTextColor:[USColor themeSelectedColor]];
            
            [[cell viewWithTag:88] removeFromSuperview];
            UIImageView *camPic = [[UIImageView alloc] init];
            [camPic setImage:[UIImage imageNamed:@"camera@3x"]];
            camPic.frame = CGRectMake((kScreenWidth/2)-((kScreenWidth*.13)/2), (cellHeight*.6), (kScreenWidth*.13), (kScreenWidth*.13)*.8);
            camPic.tag = 88;
            [cell.textLabel setHidden:YES];
            
            //[cell addSubview:camPic];
        }else
        {
            [self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
            
            if (selectedWineIndex==3)
            {
                [cell.textLabel setText:[dictOption valueForKey:@"title"]];
                UIImage *renderedImage = [[UIImage imageNamed:@""]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [cell.imageView setImage:renderedImage];
            }
            else
            {
                [cell.textLabel setText:[dictOption valueForKey:@"title"]];
                UIImage *renderedImage = [[UIImage imageNamed:[dictOption valueForKey:@"imageName"]]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [cell.imageView setImage:renderedImage];
                
            }
            
            UILabel * lineLbl =[[UILabel alloc] init];
            lineLbl.backgroundColor=[USColor cellSeparatorColor];
            lineLbl.frame=CGRectMake(60, 43, 300, 1);
            [cell.contentView addSubview:lineLbl];
            
            if (selectedWineIndex==3)
            {
                lineLbl.frame=CGRectMake(15, 43, 320, 1);
                
            }
            
            
            //For Counter
            /*
             [[cell.contentView viewWithTag:88] removeFromSuperview]; //Remove if already renderred
             
             UILabel *counter = [[UILabel alloc] init];
             counter.frame = CGRectMake(kScreenWidth*.75-(cellHeight*.75), 0, kScreenWidth*.25, cellHeight);
             [counter setTextAlignment:NSTextAlignmentRight];
             [counter setTextColor:[USColor colorFromHexString:@"#5B5B5B"]];
             [counter setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:cell.textLabel.font.pointSize]];
             counter.text = @"0";
             counter.tag = 88;
             //NSString *num = [NSString stringWithFormat:@"%d", rand() % (100 - 1) + 1];
             if(indexPath.row == 0){ //Change Counter text for Under $10
             counter.text = @"21";
             }else if(indexPath.row == 1){ //Change Counter text for 90+ rated under $20
             counter.text = @"32";
             }else if(indexPath.row == 2){ //Change Counter text for New this week
             counter.text = @"2";
             }else if(indexPath.row == 3){ //Change Counter text for by pairing
             //counter.text = @"1";
             }
             if([counter.text isEqual:@"0"]){ //Hide counter text if zero
             counter.hidden = YES;
             }
             [cell.contentView addSubview:counter];
             */
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        NSLog(@"TRACING");
        return 44.f;
    }
    NSDictionary *dictOption = [self.arrWineFilterOptions objectAtIndex:indexPath.row];
    if([[dictOption valueForKey:@"imageName"] isEqual:@"snap_pic"])
    {
        return (kScreenWidth/2);
    }
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            return 64+15+15+15+5	;
            
        }
        else
        {
           	return 80+5;
            
        }
    }
    return (indexPath.section == 0 ? 80.f : 44.f);
}

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"Wine Filter selected at Index = %li",(long)indexPath.row);
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        // Search Display Controller Record Selected
        USWine *wine = [self.objSearchedWines.arrWines objectAtIndex:indexPath.row];
        [self navigateToWineDetailsViewControllerForWine:wine];
    } else {
        NSDictionary *dictOption = [self.arrWineFilterOptions objectAtIndex:indexPath.row];
        if([[dictOption valueForKey:@"imageName"] isEqual:@"snap_pic"]){
            [self openActionSheetToAddPhoto];
        } else
        {
            if (indexPath.row==0)
            {
                NSDictionary *wineType = [self.arrWineTypes objectAtIndex:indexPath.row];
            
                [self navigateToWineResultViewControllerForWineType:[self.arrWineFilterOptions objectAtIndex:indexPath.row][kTitleKey] presetFilter:nil];
                DLog(@"Wine Type Selected %@",wineType);
            }
            else
            {
                NSMutableArray *arrItems;
                NSMutableDictionary *filterDictionary = [NSMutableDictionary new];
                USIntermediateTVC *intTVC = [[USIntermediateTVC alloc] initWithStyle:UITableViewStylePlain];
                intTVC.headerTitle = @"Type";
                if(indexPath.row == 1){
                    [filterDictionary setObject:@"Under $10" forKey:filterPriceRangesKey];
                    arrItems = [NSMutableArray arrayWithObjects:@"Reds", @"Whites", @"Sparkling & Other", nil];
                }else if(indexPath.row == 2){
                    [filterDictionary setObject:@"Under $10, $10 - $25" forKey:filterPriceRangesKey];
                    [filterDictionary setObject:@"90 - 95, 95 - 100" forKey:filterExpertRatingRangesKey];
                    arrItems = [NSMutableArray arrayWithObjects:@"Reds", @"Whites", @"Sparkling & Other", nil];
                }else if(indexPath.row == 3){
                    intTVC.headerTitle = @"";
                    //arrItems = [NSMutableArray arrayWithObjects:@"Reds", @"Whites", @"Sparkling & Other", nil];
                }else if(indexPath.row == 4){
                    intTVC.headerTitle = @"Pairing";
                    arrItems = [NSMutableArray arrayWithObjects:@"BBQ", @"Beef", @"Cheeses", @"Chocolate", @"Fish", @"Fruit", @"Lamb", @"Pasta", @"Pizza", @"Pork", @"Poultry", @"Salad", @"Shellfish", @"Spicy", @"Sushi", @"Vanilla", nil];
                }
                intTVC.arrItems = arrItems;
                intTVC.filterDictionary = filterDictionary;
                intTVC.rowIndex = indexPath.row;
                [self.navigationController pushViewController:intTVC animated:YES];
            }
            
        }
    }
}

#pragma mark - Collection View Data Source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.arrWineTypes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	USWineTypeCollectionCell *cell = (USWineTypeCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentifire forIndexPath:indexPath];
    cell.showCounter = NO;
	[cell fillWineTypeCellInfo:[self.arrWineTypes objectAtIndex:indexPath.item]];
	return cell;
}

#pragma mark Collection View Flow Layout Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(89, 89);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *wineType = [self.arrWineTypes objectAtIndex:indexPath.item];
	[self navigateToWineResultViewControllerForWineType:wineType[kTitleKey] presetFilter:nil];
	DLog(@"Wine Type Selected %@",wineType);
}

#pragma mark - Search Controller Delegates
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
	self.searching = YES;
    CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
    self.searchDisplayController.searchBar.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
    self.tableView.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
	self.searchString = nil;
	self.objSearchedWines = nil;
	self.searching = NO;
    self.searchDisplayController.searchBar.transform = CGAffineTransformIdentity;
    self.tableView.transform = CGAffineTransformIdentity;
}

- (void)loadMoreAutofilWines {
	self.gettingWines = YES;

	ASQuery *query = [ASQuery queryWithFullTextQuery:self.searchString];
	query.page = self.objSearchedWines.currentPage+1;
	query.hitsPerPage = DATA_PAGE_SIZE;
	[[HelperFunctions sharedInstance] showProgressIndicator];
	[index search:query success:^(ASRemoteIndex *index, ASQuery *query, NSDictionary *result) {
		[[HelperFunctions sharedInstance] hideProgressIndicator];
		[self.objSearchedWines parseAutofillWinesWithResult:result];
		[self.searchDisplayController.searchResultsTableView reloadData];
		self.gettingWines = NO;
	} failure:^(ASRemoteIndex *index, ASQuery *query, NSString *errorMessage) {
		DLog(@"error = %@",errorMessage);
		[[HelperFunctions sharedInstance] hideProgressIndicator];
		self.gettingWines = NO;
	}];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	self.searchString = searchString;
	if (searchString.length >= 3) {
		self.gettingWines = YES;

		ASQuery *query = [ASQuery queryWithFullTextQuery:searchString];
		query.hitsPerPage = DATA_PAGE_SIZE;
		[[HelperFunctions sharedInstance] showProgressIndicator];
		[index search:query success:^(ASRemoteIndex *index, ASQuery *query, NSDictionary *result) {
			[[HelperFunctions sharedInstance] hideProgressIndicator];
			self.objSearchedWines = nil;
			self.objSearchedWines = [USWines new];
			[self.objSearchedWines parseAutofillWinesWithResult:result];
			[self.searchDisplayController.searchResultsTableView reloadData];
			self.gettingWines = NO;
		} failure:^(ASRemoteIndex *index, ASQuery *query, NSString *errorMessage) {
			DLog(@"error = %@",errorMessage);
			[[HelperFunctions sharedInstance] hideProgressIndicator];
			self.gettingWines = NO;
		}];
	}
	return NO;
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

#pragma mark - Scroll View Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if ([scrollView isEqual:self.tableView] || decelerate) return;
	
	[self loadMorePostsIfTableScrolledToLastRecord];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if ([scrollView isEqual:self.tableView]) return;
	
	[self loadMorePostsIfTableScrolledToLastRecord];
}

#pragma mark - Open Snap a Wine Pic

- (void)openActionSheetToAddPhoto {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"opencam"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [((USWineTabBarRootVC *)self.tabBarController) setSelectedIndex:3];
    USWineTabBarRootVC *tabBarController = [[USWineTabBarRootVC alloc] init];
    [tabBarController setSelectedIndex:3];
}

#pragma mark - New Wine Button selected Method
-(void)wineSelectedClick:(id)sender
{
    [[self.arrWineTypes objectAtIndex:0] setObject:@"no" forKey:@"selected"];
    [[self.arrWineTypes objectAtIndex:1] setObject:@"no" forKey:@"selected"];
    [[self.arrWineTypes objectAtIndex:2] setObject:@"no" forKey:@"selected"];
    [[self.arrWineTypes objectAtIndex:3] setObject:@"no" forKey:@"selected"];
    
    [[self.arrWineTypes objectAtIndex:[sender tag]] setObject:@"yes" forKey:@"selected"];
    
    //    NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]];
    //    [self.tableView beginUpdates];
    //    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    //    [self.tableView endUpdates];
    
    [[self.arrWineFilterOptions objectAtIndex:1] setObject:@"Under $10" forKey:@"title"];
    [[self.arrWineFilterOptions objectAtIndex:2] setObject:@"90+ Rated Under $20" forKey:@"title"];
    [[self.arrWineFilterOptions objectAtIndex:3] setObject:@"New this Week" forKey:@"title"];
    [[self.arrWineFilterOptions objectAtIndex:4] setObject:@"By Pairing" forKey:@"title"];
    
    
    
    
    selectedWineIndex=[sender tag];
    if ([[[self.arrWineTypes objectAtIndex:[sender tag]] objectForKey:@"title"] isEqualToString:@"red"])
    {
        
        [[self.arrWineFilterOptions objectAtIndex:2] setObject:@"90+ Rated Under $20" forKey:@"title"];
        
        [[self.arrWineFilterOptions objectAtIndex:0] setObject:@"wine-glass_new" forKey:@"imageName"];
        [[self.arrWineFilterOptions objectAtIndex:0] setObject:@"All Reds" forKey:@"title"];
        [[self.arrWineFilterOptions objectAtIndex:1] setObject:@"Under $10" forKey:@"title"];
        
        
        
        
    }
    else if ([[[self.arrWineTypes objectAtIndex:[sender tag]] objectForKey:@"title"] isEqualToString:@"white"])
    {
        [[self.arrWineFilterOptions objectAtIndex:0] setObject:@"All Whites" forKey:@"title"];
        [[self.arrWineFilterOptions objectAtIndex:0] setObject:@"White Wine Glass" forKey:@"imageName"];
        [[self.arrWineFilterOptions objectAtIndex:2] setObject:@"90+ Rated Under $20" forKey:@"title"];
        [[self.arrWineFilterOptions objectAtIndex:1] setObject:@"Under $10" forKey:@"title"];
        
        
        
        
        
    }
    else if ([[[self.arrWineTypes objectAtIndex:[sender tag]] objectForKey:@"title"] isEqualToString:@"sparkling"])
    {
        [[self.arrWineFilterOptions objectAtIndex:0] setObject:@"All Sparkling & Champagne" forKey:@"title"];
        [[self.arrWineFilterOptions objectAtIndex:0] setObject:@"Sparkling Wine Glass" forKey:@"imageName"];
        [[self.arrWineFilterOptions objectAtIndex:2] setObject:@"90+ Rated Under $40" forKey:@"title"];
        [[self.arrWineFilterOptions objectAtIndex:1] setObject:@"Under $15" forKey:@"title"];
        
        
        
    }
    else if ([[[self.arrWineTypes objectAtIndex:[sender tag]] objectForKey:@"title"] isEqualToString:@"rose"])
    {
        [[self.arrWineFilterOptions objectAtIndex:0] setObject:@"Rose" forKey:@"title"];
        [[self.arrWineFilterOptions objectAtIndex:1] setObject:@"Dessert" forKey:@"title"];
        [[self.arrWineFilterOptions objectAtIndex:2] setObject:@"All Other" forKey:@"title"];
        [[self.arrWineFilterOptions objectAtIndex:0] setObject:@"Other Glass" forKey:@"imageName"];
        
        
        
    }
    
    [self.tableView reloadData];
}


@end
