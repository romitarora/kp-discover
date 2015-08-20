//
//  USNewActivityTVC.m
//  unscrewed
//
//  Created by Rav Chandra on 25/09/14.
//  Copyright (c) 2014 unscrewed. All rights reserved.
//

#import "USNewActivityTVC.h"
#import "USBlogWebViewVC.h"
#import "AFNetworking.h"
#import "USArticleCell.h"
#import "USPosts.h"
#import "USSettingsTVC.h"
#import "USLocationManager.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


static NSString *const postCellIdentifire = @"articleCell";

@interface USNewActivityTVC ()
{
    UILabel * lblTitleView;
    UIImageView * dropImg;
    UIButton  * locationBtn;
}
@property (nonatomic, strong) USPosts *objPosts;
@property (nonatomic, assign) BOOL gettingPosts;

@end

@implementation USNewActivityTVC

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


- (void)viewDidLoad
{
	[super viewDidLoad];
    
    NSString *locationName = @"los angeles"; //should be changed
	[self.navigationItem setTitleView:[HelperFunctions kerningTitleViewWithTitle:locationName]];
	[self.tableView registerNib:[UINib nibWithNibName:@"USArticleCell" bundle:nil]
		 forCellReuseIdentifier:postCellIdentifire];
	[self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
    
    
    UIBarButtonItem *barButtonSearch = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"find"] style:UIBarButtonItemStylePlain target:self action:@selector(barButtonSearchActionEvent)];
    [self.navigationItem setRightBarButtonItem:barButtonSearch];
    
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshNavigationTitle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNavigationTitle) name:@"refreshNavigationTitle" object:nil];

    
    
}

#pragma mark - UI Setup
- (void)setupUI {
    
    
        
        NSString * titleStr =[[NSUserDefaults standardUserDefaults] valueForKey:@"LatestLocation"];
    
    
    if (titleStr == nil || [titleStr length]==0 || [titleStr isEqual:[NSNull null]])
    {
        titleStr=@"los angeles";
        [[USLocationManager sharedInstance] setSelectedLocation:SelectedLocationLosAngeles];
        [self refreshNavigationTitle];
        
    }
    else
    {
        
    }
    
        titleStr = [titleStr lowercaseString];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleStr];
        
        if (titleStr != nil && titleStr != NULL && ![titleStr isEqualToString:@""])
        {
            attributedString = [[NSMutableAttributedString alloc] initWithString:titleStr];
        }//oneclick 18-8
        else
        {
            attributedString = [[NSMutableAttributedString alloc] initWithString:@"stores"];
            
        }
        
        UIView * navView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 226, 44)];
        navView.backgroundColor=[UIColor clearColor];
        
        CGSize totalLengh =[self sizeOfMultiLineLabelWithText:titleStr andGivenWidth:150 withFontSize:20];
        
        
        lblTitleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200,40)];
        [lblTitleView setFrame:CGRectMake((navView.frame.size.width-totalLengh.width)/2, 4, totalLengh.width, 40)];
        [attributedString addAttribute:NSKernAttributeName value:@(-2.f) range:NSMakeRange(0, attributedString.length)];
        
        [lblTitleView setTextAlignment:NSTextAlignmentCenter];
        [lblTitleView setTextColor:[UIColor whiteColor]];
        [lblTitleView setAttributedText:attributedString];
        lblTitleView.backgroundColor=[UIColor clearColor];
        [lblTitleView setFont:[UIFont fontWithName:@"HelveticaNeue-bold" size:22.f]];
        //        [lblTitleView setFont:[USFont placeNameFont]];
        
        [navView addSubview:lblTitleView];//RAJU 10-08-2015
        
        
        dropImg =[[UIImageView alloc] init];
        dropImg.image=[UIImage imageNamed:@"dot"];
        dropImg.frame=CGRectMake(totalLengh.width+2, 21, 10, 4);
        [lblTitleView addSubview:dropImg];
        
        
        locationBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [locationBtn addTarget:self action:@selector(locationButtonClick) forControlEvents:UIControlEventTouchUpInside];
        locationBtn.frame=CGRectMake(totalLengh.width, 0, 140, 40);
        locationBtn.backgroundColor=[UIColor clearColor];
        [navView addSubview:locationBtn];
        
        
        
        [self.navigationItem setTitleView:navView];//oneclick
 
        
        
    
}

-(void)SearchButtonClick
{
    
}

-(void)locationButtonClick
{
    USSettingsTVC *objSettingsTVC = [[USSettingsTVC alloc] initWithStyle:UITableViewStyleGrouped];
    objSettingsTVC.isFromNearBy=YES;
    UINavigationController * nav =[[UINavigationController alloc] initWithRootViewController:objSettingsTVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}
-(void)refreshNavigationTitle
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
                  
                  
                  
                  [[NSUserDefaults standardUserDefaults] setObject:placemark.locality forKey:@"LatestLocation"];
                  [[NSUserDefaults standardUserDefaults] synchronize];
                  
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
                  
                  
                  NSString * titleStr =[[NSUserDefaults standardUserDefaults] valueForKey:@"LatestLocation"];
                  titleStr =[titleStr lowercaseString];
                  
                  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleStr];
                  
                  
                  if ([titleStr isEqualToString:@"(null)"] || [titleStr length]==0 || [titleStr isEqual:[NSNull null]])
                  {
                      lblTitleView.text=@"stores";
                  }
                  else
                  {
                      CGSize totalLengh =[self sizeOfMultiLineLabelWithText:titleStr andGivenWidth:150 withFontSize:20];
                      [lblTitleView setFrame:CGRectMake((226-totalLengh.width)/2, 4, totalLengh.width, 40)];
                      
                      [attributedString addAttribute:NSKernAttributeName value:@(-2.f) range:NSMakeRange(0, attributedString.length)];
                      
                      [lblTitleView setAttributedText:attributedString];
                      
                      dropImg.frame=CGRectMake(totalLengh.width+2, 21, 10, 4);
                      //                      (totalLengh.width+3, 23, 6, 3)
                      locationBtn.frame=CGRectMake(totalLengh.width, 0, 140, 40);
                      
                  }
                  
                  
                  
              }
     
     ];
    
    
    
    
}


-(void)barButtonSearchActionEvent{
    //add action for Search icon right bar button of Discover
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (!self.objPosts) {
		[self getPosts];
	}
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark Pagination
//Load more posts if table view scroll to the end
- (void)loadMorePostsIfTableScrolledToLastRecord {
	NSArray *arrVisibleRows = [self.tableView indexPathsForVisibleRows];
	NSIndexPath *lastVisibleIndexPath = [arrVisibleRows lastObject];
	if (lastVisibleIndexPath.row == self.objPosts.arrPosts.count-1 && self.objPosts.isReachedEnd == NO) {
		if (self.gettingPosts == NO) {
			// Get More Posts
			[self getPosts];
		}
	}
}

#pragma mark - $$ WEB SERVICES $$
#pragma mark Get Posts
- (void)getPostsFailureHandlerWithError:(id)error {
	DLog(@"error = %@",error);
	self.objPosts = nil;
	self.gettingPosts = NO;
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

- (void)getPostsSuccessHandlerWithInfo:(id)info {
	self.gettingPosts = NO;
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	[self.tableView reloadData];
}

- (void)getPosts {
	if (!self.objPosts) {
		self.objPosts = [USPosts new];
	}
	[[HelperFunctions sharedInstance] showProgressIndicator];
	self.gettingPosts = YES;
	[self.objPosts getPostsWithParams:[NSMutableDictionary new]
							   target:self
						   completion:@selector(getPostsSuccessHandlerWithInfo:)
							  failure:@selector(getPostsFailureHandlerWithError:)];
}

#pragma mark Navigation
- (void)navigateToBlogWebViewControllerWithPost:(USPost *)blogPost {
	USBlogWebViewVC *objBlogWebView = [[USBlogWebViewVC alloc] init];
	objBlogWebView.objPost = blogPost;
    
    objBlogWebView.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:objBlogWebView animated:YES];
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	return [self.objPosts.arrPosts count];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	USArticleCell *cell =
	[tableView dequeueReusableCellWithIdentifier:postCellIdentifire forIndexPath:indexPath];
	USPost *newPost = [self.objPosts.arrPosts objectAtIndex:indexPath.row];
	[cell fillPostInfo:newPost];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	USPost *objPost = [self.objPosts.arrPosts objectAtIndex:indexPath.row];
	return [USArticleCell cellHeightForPost:objPost];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DLog(@"%@",indexPath);
	USPost *objPost = [self.objPosts.arrPosts objectAtIndex:indexPath.row];
	if (objPost.blogUrl) {
		[self navigateToBlogWebViewControllerWithPost:objPost];
	}
}

#pragma mark Scroll View Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (decelerate) return;
	[self loadMorePostsIfTableScrolledToLastRecord];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self loadMorePostsIfTableScrolledToLastRecord];
}

#pragma mark - Get Size of Text
-(CGSize)sizeOfMultiLineLabelWithText:(NSString*)givenString andGivenWidth:(CGFloat)givenWidth withFontSize:(int)givenFontSize
{
    NSAssert(self, @"UILabel was nil");
    
    //Label text
    NSString *aLabelTextString = givenString;
    
    //Label font
    UIFont *aLabelFont = [UIFont systemFontOfSize:givenFontSize];
    
    //Width of the Label
    CGFloat aLabelSizeWidth = givenWidth;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        //Return the calculated size of the Label
        return [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : aLabelFont } context:nil].size;
    }
    else
    {
        //version < 7.0
        return [aLabelTextString sizeWithFont:aLabelFont constrainedToSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
}



@end
