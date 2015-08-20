//
//  USMyWinesTVC.m
//  unscrewed
//
//  Created by Robin Garg on 11/03/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USMyWinesTVC.h"
#import "USWineDetailTVC.h"
#import "USWineSearchResultsCell.h"
#import "USSnappedWineCell.h"
#import "USMyWineFiltersTVC.h"
#import "USWines.h"
#import "USMeSceneTVC.h"
#import "IBActionSheet.h"
#import "FTWCache.h"
#import <FPPicker/FPPicker.h>

static const CGFloat SAVED_CELL_HEIGHT = 155.f;
static const CGFloat SNAPPED_CELL_HEIGHT = 367.f;
static const CGFloat SECTION_HEIGHT = 44.f;

@interface USMyWinesTVC ()<USMyWineFiltersDelegate, IBActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FPPickerDelegate>
{
    UIBarButtonItem *barButtonCamera, *barButtonFilter;
    UISegmentedControl *segment;
	UIView *headerView;
}

@property (nonatomic, strong) NSMutableArray *arrSnappedWines;
@property (nonatomic, strong) USWines *objSavedWines;
//@property (nonatomic, strong) USWines *objSnappedWines;
@property (nonatomic, assign) BOOL gettingWines;
@property (nonatomic, strong) NSString *filter;
@end

@implementation USMyWinesTVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"My Wines";
	NSArray *arrSnappedWines = [NSArray arrayWithContentsOfFile:[self snappedWineFilePath]];
	if (arrSnappedWines) {
		self.arrSnappedWines = [[NSMutableArray alloc] initWithArray:arrSnappedWines];
	}
	// Set Default Sort
	if (![[NSUserDefaults standardUserDefaults] objectForKey:kMyWinesFilterSortTypeKey]) {
		[[NSUserDefaults standardUserDefaults] setObject:@"Most Recent" forKey:kMyWinesFilterSortTypeKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}// Get Selected Filter/Default
	self.filter = [[NSUserDefaults standardUserDefaults] objectForKey:kMyWinesFilterValueKey];
	// Saved Wines
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USWineSearchResultsCell class]) bundle:nil]
		 forCellReuseIdentifier:NSStringFromClass([USWineSearchResultsCell class])];
	// Snapped Wines
	[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([USSnappedWineCell class]) bundle:nil]
		 forCellReuseIdentifier:NSStringFromClass([USSnappedWineCell class])];
	// Saparator Color
	[self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
	
    UIBarButtonItem *barButtonProfile = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonProfileActionEvent)];
    [self.navigationItem setLeftBarButtonItem:barButtonProfile];
    
	barButtonCamera = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"] style:UIBarButtonItemStylePlain target:self action:@selector(barButtonCameraActionEvent)];
    barButtonFilter = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonFilterActionEvent)];
	
    [self showIntro];
}

- (NSString *)snappedWineFilePath {
	NSString *documentDirectory = [HelperFunctions documentDirectoryPath];
	NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"snappedWines"];
	return filePath;
}

- (void)showIntro{
    
    if([self.arrSnappedWines count] == 0){
            
        // Intro for Empty Snapped
        UIView* introView = [[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight)];
        
        introView.backgroundColor = [UIColor clearColor];
        introView.tag = 99;
        
        //UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"Images/Blocks/%@block.jpg", colour]];
        UIImageView * iphone = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"snap_iphone.png"]];
        float iphoneRatio = iphone.frame.size.width / kScreenWidth;
        float iWidth = (iphone.frame.size.width * iphoneRatio)*.9;
        float iHeight = (iphone.frame.size.height * iphoneRatio)*.9;
        
        iphone.frame = CGRectMake((kScreenWidth/2)-(iWidth/2), kScreenWidth*0.4, iWidth, iHeight);
        [introView addSubview:iphone];
        
        UIImageView * arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"snap_arrow.png"]];
        float arrowWidth = ((kScreenWidth/2)-(iWidth/2))*.9;
        float arrowHeight = iHeight*.65;
        arrow.frame = CGRectMake((kScreenWidth/2)+(iWidth/2), 60, arrowWidth, arrowHeight);
        [introView addSubview:arrow];
        
        UILabel *introTitle = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*.1, arrow.frame.origin.y+(iHeight*1.4), kScreenWidth*.8, 40)];
        introTitle.numberOfLines = 0;
        introTitle.textAlignment = NSTextAlignmentCenter;
        [introTitle setTextColor:[UIColor blackColor]];
        [introTitle setBackgroundColor:[UIColor clearColor]];
        [introTitle setFont:[UIFont fontWithName: @"HelveticaNeue" size: 17.0f]];
        introTitle.text = @"Snap pics of wines you\nwant to remember";
        [introView addSubview:introTitle];
        
        UILabel *introDetails = [[UILabel alloc] initWithFrame:CGRectMake(introTitle.frame.origin.x, introTitle.frame.origin.y + introTitle.frame.size.height*1.4, introTitle.frame.size.width, 80)];
        introDetails.numberOfLines = 0;
        introDetails.textAlignment = NSTextAlignmentCenter;
        [introDetails setTextColor:[UIColor blackColor]];
        [introDetails setBackgroundColor:[UIColor clearColor]];
        [introDetails setFont:[UIFont fontWithName: @"HelveticaNeue-Thin" size: 15.0f]];
        introDetails.text = @"They're saved in 'Snapped'\nand within 24hrs we'll insert a\nlink so you can find it nearby,\nbuy online, review, etc.";
        [introView addSubview:introDetails];
        
        introView.userInteractionEnabled = NO;
        [self.parentViewController.view addSubview:introView];
        
        //introView.hidden = NO;
    }
}
- (void)showIntroAgain{
    
    if([self.arrSnappedWines count] == 0){
        
        UIView *introView = [self.parentViewController.view viewWithTag:99];
        if(introView){
            introView.hidden = NO;
        }
    }
}
- (void)hideIntro{
    UIView *introView = [self.parentViewController.view viewWithTag:99];
    if(introView){
        introView.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (segment.selectedSegmentIndex == 1 && self.gettingWines == NO) {
		self.objSavedWines = nil;
		[self getMyWinesWithParam:nil];
	} else {
		[self.tableView reloadData];
	}
}

-(void)viewDidAppear:(BOOL)animated{
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"opencam"] isEqual:@"YES"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"opencam"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //[self openActionSheetToAddPhoto];
		[self openFilePickerForSnappedWines];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openImagePickerForIndex:(NSInteger)index {
	UIImagePickerController *imagePickercontroller = [[UIImagePickerController alloc] init];
	imagePickercontroller.delegate = self;
	if (index == 0) { // Take Photos from Camera
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			imagePickercontroller.sourceType = UIImagePickerControllerSourceTypeCamera;
		} else {
			DLog(@"Camera Functionality not available in Simulator");
			[HelperFunctions showAlertWithTitle:kAlert
										message:@"Camera Functionality not available in this device."
									   delegate:nil
							  cancelButtonTitle:kOk
							   otherButtonTitle:nil];
			return;
		}
	} else { // Take Photos from Photos Gallery
		imagePickercontroller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
    [self presentViewController:imagePickercontroller animated:YES completion:nil];
    [self hideIntro];
}

- (void)openActionSheetToAddPhoto {
	IBActionSheet *objActionSheet = [[IBActionSheet alloc] initWithTitle:@"Upload Wine Photo" delegate:self cancelButtonTitle:kCancel destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
	
	[objActionSheet setButtonTextColor:[USColor actionSheetDescriptionColor]];
	[objActionSheet setTitleTextColor:[USColor actionSheetTitleColor]];
	[objActionSheet setCancelButtonTextColor:[USColor themeSelectedColor]];
	
	[objActionSheet setCancelButtonFont:[USFont actionSheetCancelFont]];
	[objActionSheet showInView:[[[kAppDelegate window] rootViewController] view]];
}

- (void)openFilePickerForSnappedWines {
	FPPickerController *filePicker = [[FPPickerController alloc] init];
	filePicker.title = @"Add Wine Image";
	filePicker.fpdelegate = self;
	filePicker.dataTypes = @[@"image/*"];
	filePicker.sourceNames = @[FPSourceCamera, FPSourceCameraRoll];
	[self presentViewController:filePicker animated:YES completion:nil];
}

#pragma mark - $$ HELPER METHODS $$
#pragma mark Navigation
- (void)navigateToWineDetailsViewControllerForWine:(USWine *)wine {
	USWineDetailTVC *objWineDetailsTVC = [[USWineDetailTVC alloc] initWithStyle:UITableViewStylePlain];
	objWineDetailsTVC.wineId = wine.wineId;
	objWineDetailsTVC.wineName = wine.name;
	[self.navigationController pushViewController:objWineDetailsTVC animated:YES];
}

#pragma mark Upload Photo
/*- (void)uploadImage:(UIImage *)image {
	// Integrate Upload Image API
	if (!self.objSnappedWines) {
		self.objSnappedWines = [[USWines alloc] init];
		self.objSnappedWines.arrWines = [NSMutableArray new];
	}
	USSnappedWine *snappedWine = [[USSnappedWine alloc] init];
	snappedWine.snappedImage = image;
	snappedWine.assignedOnServer = NO;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MMMM d"];
	snappedWine.postedOn = [formatter stringFromDate:[NSDate date]];
	snappedWine.name = @"Pending";
	[self.objSnappedWines.arrWines addObject:snappedWine];
	[self.tableView reloadData];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.objSnappedWines.arrWines.count-1 inSection:0]
						  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}*/

#pragma mark - $$ WEB SERVICES $$
- (void)getMyWinesFailureHandlerWithError:(id)error {
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
- (void)getMyWinesSuccessHandlerWithInfo:(id)info {
	self.gettingWines = NO;
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	[self.tableView reloadData];
}
- (void)getMyWinesWithParam:(NSMutableDictionary *)params {
	if (!self.objSavedWines) {
		self.objSavedWines = [USWines new];
	}
	self.gettingWines = YES;
	if (!params) {
		params = [NSMutableDictionary new];
	}
	if (self.filter && self.filter.length) {
		[params setObject:self.filter forKey:filterKey];
	}
	[[HelperFunctions sharedInstance] showProgressIndicator];
	[self.objSavedWines getMyWinesWithParams:params
								 target:self
							 completion:@selector(getMyWinesSuccessHandlerWithInfo:)
								failure:@selector(getMyWinesFailureHandlerWithError:)];
}

#pragma mark Upload Snapped Wine
- (void)uploadSnappedWineImageFailureHandler:(id)error {
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

- (void)uploadSnappedWineImageSuccessHandler:(id)info {
	self.gettingWines = NO;
	if (!self.arrSnappedWines) {
		self.arrSnappedWines = [NSMutableArray new];
	}
	[self.arrSnappedWines addObject:info];
	[self.arrSnappedWines writeToFile:[self snappedWineFilePath] atomically:YES];

	[[HelperFunctions sharedInstance] hideProgressIndicator];

	[self.tableView reloadData];
}

- (void)uploadSnappedWineImageWithUrl:(NSURL *)imageUrl {
//	if (!self.objSnappedWines) {
//		self.objSnappedWines = [USWines new];
//	}
	NSMutableDictionary *params = [NSMutableDictionary new];
	[params setObject:imageUrl.absoluteString forKey:photoUrlKey];
	[params setObject:@"wine" forKey:photoSubjectKey];
	self.gettingWines = YES;
	[[HelperFunctions sharedInstance] showProgressIndicator];
	
	USWines *objWines = [USWines new];
	[objWines uploadSnappedWineImageWithParams:params
										target:self
									completion:@selector(uploadSnappedWineImageSuccessHandler:)
									   failure:@selector(uploadSnappedWineImageFailureHandler:)];
}

#pragma mark Delete Wine
- (void)deleteWineFailureHandlerWithError:(id)error {
	DLog(@"error = %@",error);
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
- (void)deleteWineSuccessHandlerWithInfo:(id)info {
	[[HelperFunctions sharedInstance] hideProgressIndicator];
	
	if (segment.selectedSegmentIndex == 1) {
		self.objSavedWines = nil;
		[self getMyWinesWithParam:nil];
	}

}
- (void)deleteWine:(USWine *)wine {
	[[HelperFunctions sharedInstance] showProgressIndicator];
	USWines *objWines = [USWines new];
	[objWines deleteWineWithId:wine.wineId
						target:self
					completion:@selector(deleteWineSuccessHandlerWithInfo:)
					   failure:@selector(deleteWineFailureHandlerWithError:)];
}

#pragma mark - $$ EVENT HANDLER $$
#pragma mark Bar Button Event Handler
- (void)barButtonProfileActionEvent {
    [self hideIntro];
    
    USMeSceneTVC *objMeVC = [[USMeSceneTVC alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:objMeVC animated:YES];
}

- (void)barButtonCameraActionEvent {
    [self hideIntro];
    
    LogInfo(@"Camera clicked");
	[self openFilePickerForSnappedWines];
	//[self openActionSheetToAddPhoto];
}

- (void)barButtonFilterActionEvent {
    [self hideIntro];
    
    LogInfo(@"Filter Clicked");
	USMyWineFiltersTVC *objMyWinesFilter = [[USMyWineFiltersTVC alloc] init];
	objMyWinesFilter.delegate = self;
	[self.navigationController pushViewController:objMyWinesFilter animated:YES];
}

#pragma mark - $$ PROTOCOLS $$
#pragma mark Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return (segment.selectedSegmentIndex == 0 ? self.arrSnappedWines.count : self.objSavedWines.arrWines.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (segment.selectedSegmentIndex == 0 ? SNAPPED_CELL_HEIGHT : SAVED_CELL_HEIGHT);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (segment.selectedSegmentIndex == 0) return;
	
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
	if (segment.selectedSegmentIndex == 1) { // Saved
		USWineSearchResultsCell *cell =
		[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USWineSearchResultsCell class])
										forIndexPath:indexPath];
		cell.wineCellType = WineCellTypeMyWines;
		USWine *wine = [self.objSavedWines.arrWines objectAtIndex:indexPath.row];
		[cell fillWineCellWithWineInfo:wine indexPath:indexPath];
		return cell;
	} else {
		USSnappedWineCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USSnappedWineCell class])
																  forIndexPath:indexPath];
		id objWine = [self.arrSnappedWines objectAtIndex:indexPath.row];
		[cell fillSnappedWineCellWithInfo:objWine];
		return cell;
	}
}

#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (segment.selectedSegmentIndex == 0) return;
	
	USWine *wine = [self.objSavedWines.arrWines objectAtIndex:indexPath.row];
	[self navigateToWineDetailsViewControllerForWine:wine];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return SECTION_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
		if (!headerView) {
			segment = [[UISegmentedControl alloc] initWithItems:@[@"Snapped", @"Saved"]];
			segment.frame = CGRectMake(63, 7, 198, 29);
			[self setSegmentSelectedIndex:0];
			segment.tintColor = [USColor themeSelectedColor];
			[segment addTarget:self action:@selector(segmentIndexChanged:) forControlEvents:UIControlEventValueChanged];
			
			headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SECTION_HEIGHT)];
			[headerView setBackgroundColor:[UIColor whiteColor]];
			[headerView addSubview:segment];
			return headerView;
		} else {
			return segment.superview;
		}
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if saved wines is selected.
	return segment.selectedSegmentIndex;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(segment.selectedSegmentIndex == 0){
            [self.arrSnappedWines removeObjectAtIndex:indexPath.row];
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
			USWine *objWine = self.objSavedWines.arrWines[indexPath.row];
			[self deleteWine:objWine];
        }
    }
}

#pragma mark My wines filter delegate
- (void)myWinesFilterSelectionCompletedForSorting:(BOOL)sorting {
	if (sorting) {
		[self.navigationController popToRootViewControllerAnimated:YES];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
		self.filter = [[NSUserDefaults standardUserDefaults] objectForKey:kMyWinesFilterValueKey];
		self.objSavedWines = nil;
		[self getMyWinesWithParam:nil];
	}
}

#pragma mark File Picker Delegate Methods
- (void)FPPickerController:(FPPickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	//UIImage *originalImage = [info objectForKey:@"FPPickerControllerOriginalImage"];
	NSURL* profileImageFPUrl = [info objectForKey:@"FPPickerControllerRemoteURL"];

	[self dismissViewControllerAnimated:YES completion:^{
		if (profileImageFPUrl) {
			[self uploadSnappedWineImageWithUrl:profileImageFPUrl];
			//[self uploadImage:originalImage];
		}
	}];
}

- (void)FPPickerControllerDidCancel:(FPPickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Image Picker View Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	[self dismissViewControllerAnimated:YES completion:^{
		//[self uploadImage:originalImage];
	}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark IBActionSheet Delegate Method
-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex > 1) return;
	[self openImagePickerForIndex:buttonIndex];
}

#pragma mark Segment Control
- (void)setSegmentSelectedIndex:(NSInteger)index {
    segment.selectedSegmentIndex = index;
    if (segment.selectedSegmentIndex == 0) { // snapped
        
        [self showIntroAgain];
        
        self.navigationItem.rightBarButtonItem = barButtonCamera;
		[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		[self.tableView reloadData];
    } else { // saved
        
        [self hideIntro];
        
        self.navigationItem.rightBarButtonItem = barButtonFilter;
		if (!self.objSavedWines) {
			[self getMyWinesWithParam:nil];
		}
		[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
		[self.tableView reloadData];
    }
}

- (void)segmentIndexChanged:(UISegmentedControl *)segmentControl {
	[self setSegmentSelectedIndex:segmentControl.selectedSegmentIndex];
}

@end
