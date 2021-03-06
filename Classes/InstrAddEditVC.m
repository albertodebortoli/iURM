//
//  InstrAddEditVC.m
//  iURM
//
//  Created by Alberto De Bortoli on 8/8/10.
//  Copyright 2010 Alberto De Bortoli. All rights reserved.
//

#import "InstrAddEditVC.h"
#import "ProgListVC.h"
#import "ProgDetailsVC.h"

@implementation InstrAddEditVC

- (void)viewDidLoad
{	
	program = (self.parent.parent.programsArray)[self.parent.index];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    instructions = program[2];
	
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
	if (self.editMode) {
		[self setTitle:@"Modify Instruction"];
		
		typeOfInstruction = instructions[self.index][0];
		
		argumentOne = [instructions[self.index][1] intValue];
		
		if ([typeOfInstruction isEqualToString:@"Z"]) {
			sgmTypeOfInstruction.selectedSegmentIndex = 0;
		}
		
		if ([typeOfInstruction isEqualToString:@"S"]) {
			sgmTypeOfInstruction.selectedSegmentIndex = 1;
		}
		
		if ([typeOfInstruction isEqualToString:@"T"]) {
			sgmTypeOfInstruction.selectedSegmentIndex = 2;
			argumentTwo = [instructions[self.index][2] intValue];
		}
		
		if ([typeOfInstruction isEqualToString:@"J"]) {
			sgmTypeOfInstruction.selectedSegmentIndex = 3;
			argumentTwo = [instructions[self.index][2] intValue];
			argumentThree = [instructions[self.index][3] intValue];
		}
		
		tfArgumentOne.text = [NSString stringWithFormat:@"%d", argumentOne];
		tfArgumentTwo.text = [NSString stringWithFormat:@"%d", argumentTwo];
		tfArgumentThree.text = [NSString stringWithFormat:@"%d", argumentThree];
		[self setTextFieldVisible];
	}
	
	// add mode
	else {
		[self setTitle:@"Add Instruction"];
		typeOfInstruction = @"Z";
		argumentOne = 1;
		sgmTypeOfInstruction.selectedSegmentIndex = 0;
		[self setTextFieldVisible];
	}
	
	[tfArgumentOne becomeFirstResponder];
	
    [super viewDidLoad];
}

#pragma mark - Logic methods

- (void)setTextFieldVisible
{	
	if ([typeOfInstruction isEqualToString:@"Z"]) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:tfArgumentOne cache:YES];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
		tfArgumentOne.alpha = 1.0;
		tfArgumentTwo.alpha = 0.0;
		tfArgumentThree.alpha = 0.0;
		tfArgumentOne.frame = CGRectMake(120, 142, 80, 31);
		[UIView commitAnimations];
	}
    
	if ([typeOfInstruction isEqualToString:@"S"]) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:tfArgumentOne cache:YES];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
		tfArgumentOne.alpha = 1.0;
		tfArgumentTwo.alpha = 0.0;
		tfArgumentThree.alpha = 0.0;
		tfArgumentOne.frame = CGRectMake(120, 142, 80, 31);
		[UIView commitAnimations];
	}
    
	if ([typeOfInstruction isEqualToString:@"T"]) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:tfArgumentOne cache:YES];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
		tfArgumentOne.alpha = 1.0;
		tfArgumentOne.frame = CGRectMake(60, 142, 80, 31);
		[UIView commitAnimations];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:tfArgumentOne cache:YES];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
		tfArgumentTwo.alpha = 1.0;
		tfArgumentTwo.frame = CGRectMake(180, 142, 80, 31);
		
		tfArgumentThree.alpha = 0.0;
		[UIView commitAnimations];
	}
    
	if ([typeOfInstruction isEqualToString:@"J"]) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:tfArgumentOne cache:YES];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
		tfArgumentOne.frame = CGRectMake(20, 142, 80, 31);
		tfArgumentOne.alpha = 1.0;
		[UIView commitAnimations];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:tfArgumentOne cache:YES];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
		tfArgumentTwo.frame = CGRectMake(120, 142, 80, 31);
		tfArgumentTwo.alpha = 1.0;
		[UIView commitAnimations];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.75];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:tfArgumentOne cache:YES];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
		tfArgumentThree.frame = CGRectMake(220, 142, 80, 31);
		tfArgumentThree.alpha = 1.0;
		[UIView commitAnimations];
	}
}

#pragma mark - Actions

- (IBAction)changeTypeOfInstruction
{	
	if (sgmTypeOfInstruction.selectedSegmentIndex == 0)
		typeOfInstruction = @"Z";
	
	if (sgmTypeOfInstruction.selectedSegmentIndex == 1)
		typeOfInstruction = @"S";		
	
	if (sgmTypeOfInstruction.selectedSegmentIndex == 2)
		typeOfInstruction = @"T";
	
	if (sgmTypeOfInstruction.selectedSegmentIndex == 3)
		typeOfInstruction = @"J";
	
	[self setTextFieldVisible];
}

- (IBAction)dismissButton
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveButton
{	
	argumentOne = [tfArgumentOne.text intValue];
	argumentTwo = [tfArgumentTwo.text intValue];
	argumentThree = [tfArgumentThree.text intValue];
	NSMutableArray *newEntry;
	
	if (self.editMode)
		[instructions removeObjectAtIndex:self.index];
	
	if (sgmTypeOfInstruction.selectedSegmentIndex == 0) {
		newEntry = [NSMutableArray arrayWithObjects: @"Z",
					@(argumentOne), nil];
		
		[instructions insertObject:newEntry atIndex:self.index];
	}
	
	if (sgmTypeOfInstruction.selectedSegmentIndex == 1) {
		newEntry = [NSMutableArray arrayWithObjects: @"S",
					@(argumentOne), nil];
		[instructions insertObject:newEntry atIndex:self.index];
	}
	
	if (sgmTypeOfInstruction.selectedSegmentIndex == 2) {
		newEntry = [NSMutableArray arrayWithObjects: @"T",
					@(argumentOne),
					@(argumentTwo), nil];
		
		[instructions insertObject:newEntry atIndex:self.index];
	}
	
	if (sgmTypeOfInstruction.selectedSegmentIndex == 3) {
		newEntry = [NSMutableArray arrayWithObjects: @"J",
					@(argumentOne),
					@(argumentTwo),
					@(argumentThree), nil];
		
		[instructions insertObject:newEntry atIndex:self.index];
	}
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	[self.parent.tableInstructions reloadData];
}

@end
