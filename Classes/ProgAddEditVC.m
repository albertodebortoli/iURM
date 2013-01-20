//
//  ProgAddEditVC.m
//  iURM
//
//  Created by Alberto De Bortoli on 8/8/10.
//  Copyright 2010 Alberto De Bortoli. All rights reserved.
//

#import "ProgAddEditVC.h"
#import "ProgListVC.h"

@implementation ProgAddEditVC

- (void)viewDidLoad
{	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
																	  style:UIBarButtonItemStylePlain
																	 target:self
																	 action:@selector(dismissButton)];
	
	[self.navigationItem setLeftBarButtonItem:dismissButton];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
																   style:UIBarButtonItemStyleDone
																  target:self
																  action:@selector(saveButton)];
	
	[self.navigationItem setRightBarButtonItem:saveButton];
	
	// edit mode
	if (self.editMode)
		[self setTitle:@"Modify Program"];
    
	// add mode
	else
		[self setTitle:@"Add Program"];
	
	tfName = [[UITextField alloc] initWithFrame:CGRectMake(120,11,170,30)];
	tfName.placeholder = @"insert name ";
	tfName.textAlignment = UITextAlignmentRight;
	tfName.delegate = self;
	tfName.autocorrectionType = UITextAutocorrectionTypeNo;
	
	tfNote = [[UITextField alloc] initWithFrame:CGRectMake(120,11,170,30)];
	tfNote.placeholder = @"insert a note ";
	tfNote.textAlignment = UITextAlignmentRight;
	tfNote.autocapitalizationType = UITextAutocapitalizationTypeNone;
	tfNote.delegate = self;
	tfNote.autocorrectionType = UITextAutocorrectionTypeNo;
	
	tfNumberOfInstruction = [[UITextField alloc] initWithFrame:CGRectMake(120,11,170,30)];
	tfNumberOfInstruction.placeholder = @"insert # ";
	tfNumberOfInstruction.textAlignment = UITextAlignmentRight;
	tfNumberOfInstruction.delegate = self;
	tfNumberOfInstruction.keyboardType = UIKeyboardTypeNumberPad;
	tfNumberOfInstruction.autocorrectionType = UITextAutocorrectionTypeNo;
	
	[tfName becomeFirstResponder];
	
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)dismissButton
{	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveButton
{	
	if ("!editMode") {
		if ([tfName.text isEqualToString:@""] || [tfNote.text isEqualToString:@""] || [tfNumberOfInstruction.text isEqualToString:@""]) {
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Missing information"
                                                           message:@"Please fill all the fields."
                                                          delegate:nil
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
			
			[alert show];
		}
		else {
			NSMutableArray *instructions = [[NSMutableArray alloc] initWithArray:nil];
			NSArray *instruction;
			for (int i=0; i<[tfNumberOfInstruction.text intValue]; i++) {
				instruction = @[@"J", @1, @1, @1];
				[instructions addObject:instruction];
			}
			NSArray *newEntry = @[tfName.text, tfNote.text, instructions];
			[self.parent.programsArray insertObject:newEntry atIndex:self.index];
			[self.navigationController dismissModalViewControllerAnimated:YES];
			
			[self.parent.tableList reloadData];
		}
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (NSString *)tableView:(UITableView *)tableView 
titleForFooterInSection:(NSInteger)section
{    
	if (self.editMode) {
        return @"edit the data for the selected program";
	} else { // new program
		return @"fill the fields with the data for the new program";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
	if (indexPath.row == 0){
		cell.textLabel.text = @"Name";
		[cell addSubview:tfName];
	}
    
	if (indexPath.row == 1){
		cell.textLabel.text = @"Note";
		[cell addSubview:tfNote];
	}
    
	if (indexPath.row == 2){
		cell.textLabel.text = @"# of Instructions";
		[cell addSubview:tfNumberOfInstruction];
	}
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{	
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
	// nothing to do
}

@end
