//
//  ProgDetailsVC.m
//  iURM
//
//  Created by Alberto De Bortoli on 8/7/10.
//  Copyright 2010 Alberto De Bortoli. All rights reserved.
//

#import "ProgDetailsVC.h"
#import "ProgListVC.h"
#import "InstrAddEditVC.h"
#import "ExecVC.h"

@implementation ProgDetailsVC

@synthesize parent;
@synthesize index;
@synthesize tableInstructions;

- (void)viewDidLoad
{	
    [self setTitle:[[parent.programsArray objectAtIndex:index] objectAtIndex:0]];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	program = [parent.programsArray objectAtIndex:index];
    instructions = [program objectAtIndex:2];
	
	lblDescription.text = [program objectAtIndex:1];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addInstruction)];
	[self.navigationItem setRightBarButtonItem:addButton];
	
	[tableInstructions setEditing:YES animated:YES];
	[tableInstructions setBackgroundColor:[UIColor clearColor]];
	
	[runButton setImage:[UIImage imageNamed:@"runButton.png"] forState:UIControlStateNormal];
    [runButton setImage:[UIImage imageNamed:@"runButtonPush.png"] forState:UIControlStateHighlighted];
    
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)addInstruction
{	
	InstrAddEditVC *iad = [[InstrAddEditVC alloc] initWithNibName:@"InstrAddEditVC" bundle:nil];
	iad.parent = self;
	
	// starting from 0, count saves the index of the new entry in the queue
	iad.index = [instructions count];
	iad.editMode = NO;
	UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:iad];
	[self presentModalViewController:navigation animated:YES];
}

- (IBAction)runProgram
{
	// Navigation logic may go here -- for example, create and push another view controller.
	ExecVC *vc = [[ExecVC alloc] initWithNibName:@"ExecVC" bundle:nil];
	vc.parent = self;
	UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:vc];
	[self presentModalViewController:navigation animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [instructions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
    NSString *typeOfInstruction = [[instructions objectAtIndex:indexPath.row] objectAtIndex:0];
	int argumentOne = [[[instructions objectAtIndex:indexPath.row] objectAtIndex:1] intValue];
	
	if ([typeOfInstruction isEqualToString:@"Z"])
		cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)", typeOfInstruction, argumentOne];
    
	if ([typeOfInstruction isEqualToString:@"S"])
		cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)", typeOfInstruction, argumentOne];
    
	if ([typeOfInstruction isEqualToString:@"T"]) {
		int argumentTwo = [[[instructions objectAtIndex:indexPath.row] objectAtIndex:2] intValue];
		cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d, %d)", typeOfInstruction, argumentOne, argumentTwo];
	}
    
	if ([typeOfInstruction isEqualToString:@"J"]) {
		int argumentTwo = [[[instructions objectAtIndex:indexPath.row] objectAtIndex:2] intValue];
		int argumentThree = [[[instructions objectAtIndex:indexPath.row] objectAtIndex:3] intValue];
		cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d, %d, %d)", typeOfInstruction, argumentOne, argumentTwo, argumentThree];
	}
	
	cell.showsReorderControl = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{	
    if (indexPath.row == 0 || indexPath.row%2 == 0) {
		UIColor *altCellColor = [UIColor colorWithWhite:0.8 alpha:1.0];
		cell.backgroundColor = altCellColor;
	}
	else {
		UIColor *altCellColor = [UIColor colorWithWhite:0.85 alpha:1.0];
		cell.backgroundColor = altCellColor;
	}
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[instructions removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
}

- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath
{	
    NSMutableArray *instructionToMove = [instructions objectAtIndex:fromIndexPath.row];
    [instructions removeObjectAtIndex:fromIndexPath.row];
    [instructions insertObject:instructionToMove atIndex:toIndexPath.row];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
	InstrAddEditVC *iad = [[InstrAddEditVC alloc] initWithNibName:@"InstrAddEditVC" bundle:nil];
	iad.parent = self;
	iad.index = indexPath.row;
	iad.editMode = YES;
	UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:iad];
	[self presentModalViewController:navigation animated:YES];
}

#pragma mark - Memory management

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    tableInstructions = nil;
    lblDescription = nil;
    runButton = nil;
}

@end
