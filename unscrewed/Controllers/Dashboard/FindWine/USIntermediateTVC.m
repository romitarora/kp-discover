//
//  USIntermediateTVC.m
//  unscrewed
//
//  Created by Ray Venenoso on 6/29/15.
//  Copyright (c) 2015 unscrewed. All rights reserved.
//

#import "USIntermediateTVC.h"
#import "USWineSearchResultsTVC.h"

@interface USIntermediateTVC ()


@end

@implementation USIntermediateTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.headerTitle;
    
    [self.tableView setSeparatorColor:[USColor cellSeparatorColor]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.arrItems = [NSMutableArray arrayWithObjects:@"Testing", @"Testing 2", @"Test 3", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Navigation
- (void)navigateToWineResultViewController {
	USWineSearchResultsTVC *objWineResultVC = [[USWineSearchResultsTVC alloc] initWithStyle:UITableViewStylePlain];
	objWineResultVC.wineSearchArguments = self.filterDictionary;
	[self.navigationController pushViewController:objWineResultVC animated:YES];
}

- (NSString *)wineTypeForRowIndex:(NSInteger)rowIndex {
	switch (rowIndex) {
		case 0:
			return @"red";
		case 1:
			return @"white";
		case 2:
			return @"sparkling";
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (self.rowIndex) {
		case 0:
		case 1:
			[self.filterDictionary setObject:[self wineTypeForRowIndex:indexPath.row] forKey:filterTypesKey];
			break;
		case 3:
			[self.filterDictionary setObject:self.arrItems[indexPath.row] forKey:filterPairingsKey];
			break;
		default:
			break;
	}
	[self navigateToWineResultViewController];
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.arrItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //USIntermediateCell *cell = (USIntermediateCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USIntermediateCell class]) forIndexPath:indexPath];
    
    USIntermediateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"theCell"];
    if(cell == nil){
        [tableView registerNib:[UINib nibWithNibName:@"USIntermediateCell" bundle:nil] forCellReuseIdentifier:@"theCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"theCell"];

    }
    cell.theLabel.text = [self.arrItems objectAtIndex:indexPath.row];
    /*
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    //USFollowingUser *user = self.objUsers.arrUsers[indexPath.row];
    
   // UILabel *lbl = (UILabel*)[cell viewWithTag:1];
    //lbl.text = @"Testing";
    
    UILabel *labl = [[UILabel alloc] init];
    labl.frame = CGRectMake(0, 0, 50, 50);
    labl.text = @"Test 99999";
    [cell addSubview:labl];*/
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
