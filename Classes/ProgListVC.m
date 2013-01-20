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

#pragma mark - View lifecycle

- (void)viewDidLoad
{  
    [self setTitle:@"iURM Program List"];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title=@"List";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = paths[0];
	NSString *pathDB = [documentsDirectory stringByAppendingPathComponent:@"DB.plist"];
	self.programsArray = [[NSMutableArray alloc] initWithContentsOfFile:pathDB];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProgram)];
	[self.navigationItem setRightBarButtonItem:addButton];
	
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
	[infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *buttonInfo = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[self.navigationItem setLeftBarButtonItem:buttonInfo];
	self.tableList.separatorColor = [UIColor viewFlipsideBackgroundColor];
	
    [super viewDidLoad];
}

#pragma mark - Delegate methods

- (void)AboutViewControllerDidFinish:(AboutViewController *)controller
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Actions

- (IBAction)showInfo
{
	AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AboutView" bundle:nil];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
}

- (IBAction)addProgram
{	
	ProgAddEditVC *pad = [[ProgAddEditVC alloc] initWithNibName:@"ProgAddEditVC" bundle:nil];
	pad.parent = self;
	
	// starting from 0, count saves the index of the new entry in the queue
	pad.index = [self.programsArray count];
	pad.editMode = NO;
	UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:pad];
	[self presentModalViewController:navigation animated:YES];
}

#pragma mark - Logic methods

- (void)saveToDB
{	
	//store in the plist files
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = paths[0];
	NSString *pathDB = [documentsDirectory stringByAppendingPathComponent:@"DB.plist"];
	[self.programsArray writeToFile:pathDB atomically:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.programsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.programsArray[indexPath.row][0];
	cell.detailTextLabel.text = self.programsArray[indexPath.row][1];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{    
	if (indexPath.row == 0 || indexPath.row % 2 == 0) {
		UIColor *altCellColor = [UIColor colorWithWhite:0.8 alpha:1.0];
		cell.backgroundColor = altCellColor;
	}
	else {
		UIColor *altCellColor = [UIColor colorWithWhite:0.85 alpha:1.0];
		cell.backgroundColor = altCellColor;
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
	return 54;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		[self.programsArray removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
	}
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
	ProgDetailsVC *pd = [[ProgDetailsVC alloc] initWithNibName:@"ProgDetailsVC" bundle:nil];
	pd.parent = self;
	pd.index = indexPath.row;
	
	[self.navigationController pushViewController:pd animated:YES];
}

@end
