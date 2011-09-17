//
//  ProgListVC.m
//  iURM
//
//  Created by Alberto De Bortoli on 8/7/10.
//  Copyright 2010 Alberto De Bortoli. All rights reserved.
//

#import "ProgListVC.h"
#import "iURMAppDelegate.h"
#include <unistd.h>


@implementation ProgListVC


@synthesize programsArray, tableList;


#pragma mark - View lifecycle

- (void)viewDidLoad {
  
  [self setTitle:@"iURM Program List"];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title=@"List";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *pathDB = [documentsDirectory stringByAppendingPathComponent:@"DB.plist"];
	programsArray = [[NSMutableArray alloc] initWithContentsOfFile:pathDB];	
	
	UIBarButtonItem *addButton = [[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProgram)];
	[self.navigationItem setRightBarButtonItem:addButton];
	
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
	[infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *buttonInfo = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[self.navigationItem setLeftBarButtonItem:buttonInfo];
	tableList.separatorColor = [UIColor viewFlipsideBackgroundColor];
	
  [super viewDidLoad];
}


#pragma mark - Delegate methods

- (void)AboutViewControllerDidFinish:(AboutViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Actions

- (IBAction)showInfo {
  
	AboutViewController *controller;
	controller = [[AboutViewController alloc] initWithNibName:@"AboutView" bundle:nil];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
}

- (IBAction)addProgram {
	
	ProgAddEditVC *pad = [[ProgAddEditVC alloc] initWithNibName:@"ProgAddEditVC" bundle:nil];
	pad.parent = self;
	
	// starting from 0, count saves the index of the new entry in the queue
	pad.index = [programsArray count];
	pad.editMode = NO;
	UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:pad];
	[self presentModalViewController:navigation animated:YES];
}


#pragma mark - Logic methods

- (void)saveToDB {
	
	//store in the plist files
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *pathDB = [documentsDirectory stringByAppendingPathComponent:@"DB.plist"];
	[programsArray writeToFile:pathDB atomically:YES];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [programsArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }
  
  cell.textLabel.text = [[programsArray objectAtIndex:indexPath.row] objectAtIndex:0];
	//cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
	cell.detailTextLabel.text = [[programsArray objectAtIndex:indexPath.row] objectAtIndex:1];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  return cell;
}


- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  
	if (indexPath.row == 0 || indexPath.row%2 == 0) {
		UIColor *altCellColor = [UIColor colorWithWhite:0.8 alpha:1.0];
		cell.backgroundColor = altCellColor;
	}
	else {
		UIColor *altCellColor = [UIColor colorWithWhite:0.85 alpha:1.0];
		cell.backgroundColor = altCellColor;
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
	return 54;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		[programsArray removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
}

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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
	// Navigation logic may go here -- for example, create and push another view controller.
	ProgDetailsVC *pd = [[ProgDetailsVC alloc] initWithNibName:@"ProgDetailsVC" bundle:nil];
	pd.parent = self;
	pd.index = indexPath.row;
	
	[self.navigationController pushViewController:pd animated:YES];
}


#pragma mark - Memory management

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}



@end

