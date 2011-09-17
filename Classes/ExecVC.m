//
//  ExecVC.m
//  iURM
//
//  Created by Alberto De Bortoli on 8/8/10.
//  Copyright 2010 Alberto De Bortoli. All rights reserved.
//

#import "ExecVC.h"
#import "ProgDetailsVC.h"
#import "ProgListVC.h"
#import <QuartzCore/QuartzCore.h>

@implementation ExecVC

@synthesize scrollView, parent, picker;


#define PADDING_TOP 4
#define PADDING 4
#define THUMBNAIL_COLS 4
#define THUMBNAIL 150
#define THUMBNAIL_75 75


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self setTitle:@"Run Program!"];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc]
									  initWithTitle:@"Done" 
									  style:UIBarButtonItemStyleDone 
									  target:self 
									  action:@selector(dismissButton)];
	
	[self.navigationItem setRightBarButtonItem:dismissButton];
	
	program = [parent.parent.programsArray objectAtIndex:parent.index];
	instructions = [program objectAtIndex:2];
	
	
	// calculates the number of used registers
	usedRegisters = [[NSMutableArray alloc] initWithArray:nil];
	usedRegisters = [self calculateUsedRegisters];
	scrollView.tag = -1;
	buttonForBackground.tag = -2;
	
	for (int i = 0; i < [usedRegisters count]; i++) {
		
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(THUMBNAIL_75 * (i % THUMBNAIL_COLS) + PADDING * (i % THUMBNAIL_COLS) + PADDING,
																THUMBNAIL_75 * (i / THUMBNAIL_COLS) + PADDING * (i / THUMBNAIL_COLS) + PADDING + PADDING_TOP,
																THUMBNAIL_75, THUMBNAIL_75)];
		
		// needs to track views with tag index for later animations (T instructions)
		// a little hack, because tag 0 can't be used but register 0 can exists
		// (the greatest index of register the programs can used is indicated in the offset (1000, can be changed)
		view.tag = [[usedRegisters objectAtIndex:i] intValue] + 1000;
		
		
		UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, THUMBNAIL_75, THUMBNAIL_75)];
		[image setImage:[UIImage imageNamed:@"PC.png"]];
		
		[view setBackgroundColor:[UIColor clearColor]];
		
		UILabel *lblNumberRegister = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 55, 25)];
		lblNumberRegister.text = [NSString stringWithFormat:@"R%d",[[usedRegisters objectAtIndex:i] intValue]];
		[lblNumberRegister setBackgroundColor:[UIColor clearColor]];
		[lblNumberRegister setFont:[UIFont fontWithName:@"Courier" size:20]];
		lblNumberRegister.textAlignment = UITextAlignmentLeft;
		lblNumberRegister.textColor = [UIColor greenColor];
		
		UITextField *txtValueRegister = [[UITextField alloc] initWithFrame:CGRectMake(20, 35, 45, 35)];
		txtValueRegister.text = @"0";
		txtValueRegister.borderStyle = UITextBorderStyleNone;
		txtValueRegister.delegate = self;
		txtValueRegister.textAlignment = UITextAlignmentRight;
		[txtValueRegister setFont:[UIFont fontWithName:@"Courier" size:24]];
		txtValueRegister.textColor = [UIColor whiteColor];
		txtValueRegister.autocorrectionType = UITextAutocorrectionTypeNo;
		txtValueRegister.backgroundColor = [UIColor clearColor];
		txtValueRegister.keyboardType = UIKeyboardTypeNumberPad;
		txtValueRegister.tag = [[usedRegisters objectAtIndex:i] intValue] + 1; //se esiste il registro 0, tag = 0 non è riconosciuto, stranamente, quindi sommo 1
		txtValueRegister.adjustsFontSizeToFitWidth = YES;
		txtValueRegister.minimumFontSize = 5;
		
		[view addSubview:image];
		[view addSubview:lblNumberRegister];
		[view addSubview:txtValueRegister];
		
    
		[scrollView addSubview:view];
	}
	
	int rows = [usedRegisters count] / THUMBNAIL_COLS;
	if (((float)[usedRegisters count] / THUMBNAIL_COLS) - rows != 0) rows++;
	int height = THUMBNAIL_75 * rows + PADDING * rows + PADDING; // + PADDING_TOP;
	
	scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
	scrollView.clipsToBounds = YES;
	[scrollView setScrollEnabled:YES];
	
	[viewProgramCounter setBackgroundColor:[UIColor clearColor]];
	[imgProgramCounter setImage:[UIImage imageNamed:@"PC.png"]];
	
	[startButton setImage:[UIImage imageNamed:@"greenButton.png"] forState:UIControlStateNormal];
  [startButton setImage:[UIImage imageNamed:@"greenButtonPush.png"] forState:UIControlStateHighlighted];
	
	[clearButton setImage:[UIImage imageNamed:@"clearButton.png"] forState:UIControlStateNormal];
  [clearButton setImage:[UIImage imageNamed:@"clearButtonPush.png"] forState:UIControlStateHighlighted];
	
	[startOverButton setImage:[UIImage imageNamed:@"clearButton.png"] forState:UIControlStateNormal];
  [startOverButton setImage:[UIImage imageNamed:@"clearButtonPush.png"] forState:UIControlStateHighlighted];
	
	picker.userInteractionEnabled = NO;
	
	[self startOver];
	
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	// add observer for the respective notifications (depending on the os version)
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardDidShow:)
													 name:UIKeyboardDidShowNotification
												   object:nil];        
	} else {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
	}
	
  [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewDidDisappear:animated];
}


#pragma mark - Delegate methods

// A seconda della versione di iOS vengono chiamati due metodi diversi di notifica
- (void)keyboardWillShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 3.2)
		[self addButtonToKeyboard];
}

- (void)keyboardDidShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2)
		[self addButtonToKeyboard];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return YES;
}


#pragma mark - Actions

- (IBAction)makeKeyboardGoAway {
	for (int i = 0; i < [usedRegisters count]; i++) {
		int arg = [[usedRegisters objectAtIndex:i] intValue];
		[[scrollView viewWithTag:arg + 1000] viewWithTag:arg + 1];
		UIView *temp = [[scrollView viewWithTag:arg + 1000] viewWithTag:arg + 1];
		[(UITextField*)temp resignFirstResponder];
	}
}

- (IBAction)clearRegisters {
  
	for (int i = 0; i < [usedRegisters count]; i++) {
		int arg = [[usedRegisters objectAtIndex:i] intValue];
		
		originView = [scrollView viewWithTag:arg + 1000];
		origin = (UITextField*)[originView viewWithTag:arg + 1];
		[origin setText:[NSString stringWithFormat:@"%d", 0]];
	}
	
}

- (IBAction)startOver {
	
	PC = 0;
	[lblProgramCounter setText:[NSString stringWithFormat:@"%d", 1]];
	[picker selectRow:PC inComponent:0 animated:YES];
}

- (IBAction)start {
	
	if (PC >= [instructions count])
		[self programEndedAlert];
	
	else {
		NSArray *currentInstruction = [instructions objectAtIndex:PC];
		
		if ([[currentInstruction objectAtIndex:0] isEqualToString:@"Z"]) {
			
			arg1 = [[currentInstruction objectAtIndex:1] intValue];
			originView = [scrollView viewWithTag:arg1 + 1000];
			origin = (UITextField*)[originView viewWithTag:arg1 + 1]; 
			
			PC++;
			
			[self enableButtonsForAnimation:NO];
			
			//first animation
			[UIView beginAnimations:@"ZeroAnimation" context:nil];
			[UIView setAnimationDuration:0.25];
			[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:scrollView cache:YES];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(animateOtherStuff:finished:context:)];
			originView.alpha = 0.2;
			[UIView commitAnimations];
			
			[lblProgramCounter setText:[NSString stringWithFormat:@"%d", PC+1]];
			[picker selectRow:PC inComponent:0 animated:YES];
			if (PC >= [instructions count])
				[self programEndedAlert];
		} // end Z case
		
		if ([[currentInstruction objectAtIndex:0] isEqualToString:@"S"]) {
			
			arg1 = [[currentInstruction objectAtIndex:1] intValue];
			originView = [scrollView viewWithTag:arg1 + 1000];
			origin = (UITextField*)[originView viewWithTag:arg1 + 1]; 
			value = [[origin text] intValue];
			value++;
			PC++;
			
			[self enableButtonsForAnimation:NO];
			
			//first animation
			[UIView beginAnimations:@"SuccAnimation" context:nil];
			[UIView setAnimationDuration:0.25];
			[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:scrollView cache:YES];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(animateOtherStuff:finished:context:)];
			originView.alpha = 0.2;
			[UIView commitAnimations];
			
			
			[lblProgramCounter setText:[NSString stringWithFormat:@"%d", PC+1]];
			[picker selectRow:PC inComponent:0 animated:YES];
			if (PC >= [instructions count])
				[self programEndedAlert];
		} // end S case
		
		if ([[currentInstruction objectAtIndex:0] isEqualToString:@"T"]) {
			
			arg1 = [[currentInstruction objectAtIndex:1] intValue];
			arg2 = [[currentInstruction objectAtIndex:2] intValue];
			
			originView = [scrollView viewWithTag:arg1 + 1000];
			origin = (UITextField*)[originView viewWithTag:arg1 + 1]; 
			value = [[origin text] intValue];
			
			destinationView = [scrollView viewWithTag:arg2 + 1000];
			destination = (UITextField*)[destinationView viewWithTag:arg2 + 1]; 
			
			previousFrame = CGRectMake(originView.layer.frame.origin.x,
                                 originView.layer.frame.origin.y,
                                 originView.layer.frame.size.width,
                                 originView.layer.frame.size.height);
			
			[self enableButtonsForAnimation:NO];
			
			//first animation
			[UIView beginAnimations:@"FirstAnimation" context:nil];
			[UIView setAnimationDuration:0.75];
			[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:scrollView cache:YES];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(animateOtherStuff:finished:context:)];
			originView.frame = CGRectMake(destinationView.layer.frame.origin.x,
                                    destinationView.layer.frame.origin.y,
                                    destinationView.layer.frame.size.width,
                                    destinationView.layer.frame.size.height);
			
      originView.alpha = 0.0;
      [UIView commitAnimations];
			
			PC++;
			[lblProgramCounter setText:[NSString stringWithFormat:@"%d", PC+1]];
			[picker selectRow:PC inComponent:0 animated:YES];
			if (PC >= [instructions count])
				[self programEndedAlert];
		} // end T case
		
		if ([[currentInstruction objectAtIndex:0] isEqualToString:@"J"]) {
			
			arg1 = [[currentInstruction objectAtIndex:1] intValue];
			arg2 = [[currentInstruction objectAtIndex:2] intValue];
			arg3 = [[currentInstruction objectAtIndex:3] intValue];
			
			originView = [scrollView viewWithTag:arg1 + 1000];
			origin = (UITextField*)[originView viewWithTag:arg1 + 1];
			int value1 = [[(UITextField*)origin text] intValue];
			
			destinationView = [scrollView viewWithTag:arg2 + 1000];
			destination = (UITextField*)[destinationView viewWithTag:arg2 + 1]; 
			int value2 = [[destination text] intValue];
			
			if (value1 == value2) {
				PC = arg3-1;
				[lblProgramCounter setText:[NSString stringWithFormat:@"%d", PC+1]];
				if (PC >= [instructions count]) {
					[self programEndedAlert];
					[picker selectRow:[instructions count] inComponent:0 animated:YES];
				}
				else
					[picker selectRow:PC inComponent:0 animated:YES];
			}
			else {
				PC++;
				[lblProgramCounter setText:[NSString stringWithFormat:@"%d", PC+1]];
				[picker selectRow:PC inComponent:0 animated:YES];
			}
		} // end J case		
	} // end else
	
}

- (IBAction)dismissButton {
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark - Logic methods

- (void)hideKeyboard {
	for (int i = 0; i < [usedRegisters count]; i++) {
		int arg = [[usedRegisters objectAtIndex:i] intValue];
		[[scrollView viewWithTag:arg + 1000] viewWithTag:arg + 1];
		UIView *temp = [[scrollView viewWithTag:arg + 1000] viewWithTag:arg + 1];
		[(UITextField*)temp resignFirstResponder];
	}
}

- (void)addButtonToKeyboard {  
  // create custom button
  UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
  doneButton.frame = CGRectMake(0, 163, 106, 53);
  doneButton.adjustsImageWhenHighlighted = NO;
  [doneButton setImage:[UIImage imageNamed:@"doneUp.png"] forState:UIControlStateNormal];
  [doneButton setImage:[UIImage imageNamed:@"doneDown.png"] forState:UIControlStateHighlighted];
  [doneButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];

  // locate keyboard view
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView* keyboard;
	for(int i=0; i<[tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard found, add the button
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
			if([[keyboard description] hasPrefix:@"<UIPeripheralHost"])
				[keyboard addSubview:doneButton];
		}
    else {
			if([[keyboard description] hasPrefix:@"<UIKeyboard"])
				[keyboard addSubview:doneButton];
		}
	}
  
}

- (void)programEndedAlert {
	
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Program ended" 
						  message:@"This URM program terminates. Execution reached a null instruction."
						  delegate:nil cancelButtonTitle:@"Yeah!" 
						  otherButtonTitles:nil];
	
	[alert show];
}

- (void)enableButtonsForAnimation:(BOOL)state{
	clearButton.userInteractionEnabled = state;
	startButton.userInteractionEnabled = state;
	startOverButton.userInteractionEnabled = state;
}

- (void)animateOtherStuff:(NSString*)animationID
				 finished:(NSNumber*)finished
				  context:(void*)context {
  
  // This test allows to figure out what animation block ended. 
  // Not required but nice if you have multiple animations 
  // pointing to the same animation termination method
	
	originView = [scrollView viewWithTag:arg1 + 1000];

	if ([animationID isEqualToString:@"FirstAnimation"]) {
		originView.frame = previousFrame;
		//second animation
		[UIView beginAnimations:@"SecondAnimation" context:nil];
		[UIView setAnimationDuration:0.25];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:scrollView cache:YES];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector:@selector(animateOtherStuff:finished:context:)];
		originView.alpha = 1.0;
		destinationView.alpha = 1.0;
		[destination setText:[NSString stringWithFormat:@"%d", value]];
		[UIView commitAnimations];
  }
	
  if ([animationID isEqualToString:@"SecondAnimation"]) {
		[self enableButtonsForAnimation:YES];
  } 
	
  if ([animationID isEqualToString:@"ZeroAnimation2"]) {
		destinationView.alpha = 1.0;
		originView.alpha = 1.0;
		[origin setText:@"0"];
		[self enableButtonsForAnimation:YES];
  }
	
  if ([animationID isEqualToString:@"SuccAnimation2"]) {
		destinationView.alpha = 1.0;
		originView.alpha = 1.0;
		[origin setText:[NSString stringWithFormat:@"%d", value]];
		[self enableButtonsForAnimation:YES];
  }
	
	if ([animationID isEqualToString:@"ZeroAnimation"]) {
		[UIView beginAnimations:@"ZeroAnimation2" context:nil];
		[UIView setAnimationDuration:0.25];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:scrollView cache:YES];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector:@selector(animateOtherStuff:finished:context:)];
		originView.alpha = 1.0;
		[UIView commitAnimations];
	}
	
  if ([animationID isEqualToString:@"SuccAnimation"]) {
		[UIView beginAnimations:@"SuccAnimation2" context:nil];
		[UIView setAnimationDuration:0.25];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:scrollView cache:YES];
		[UIView setAnimationDelegate:self]; 
		[UIView setAnimationDidStopSelector:@selector(animateOtherStuff:finished:context:)];
		originView.alpha = 1.0;
		[UIView commitAnimations];
	}
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	return  YES;
}

- (NSMutableArray *)calculateUsedRegisters {
	
	for (int i = 0; i < [instructions count]; i++) {
		BOOL done = NO;
		int bound;
		if ([[[instructions objectAtIndex:i] objectAtIndex:0] isEqualToString:@"J"])
			// not adding the third parameter because it does not
			// refer to registers (it refers to instructions)
			bound = [[instructions objectAtIndex:i] count] - 1;
		else bound = [[instructions objectAtIndex:i] count];

		for (int j = 1; j < bound; j++) {
			done = NO;
			int temp = [[[instructions objectAtIndex:i] objectAtIndex:j] intValue];
			int k = 0;
			for (k = 0; (k < [usedRegisters count]) && (!done); k++) {
				if ([[usedRegisters objectAtIndex:k] intValue] == temp){
					done = YES;
				}
				if ([[usedRegisters objectAtIndex:k] intValue] > temp) {
					[usedRegisters insertObject:[NSNumber numberWithInt:temp] atIndex:k];
					done = YES;
				}
			}
			if (!done)
					[usedRegisters insertObject:[NSNumber numberWithInt:temp] atIndex:k];
		}
	}
  
	return usedRegisters;		

}


#pragma mark -
#pragma mark Picker view datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
	
	return ([instructions count] + 1);
}


#pragma mark -
#pragma mark Picker view delegate

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
	
	if (row == [instructions count])
		return @"END";
	
	NSArray *instruction = [instructions objectAtIndex:row];
	NSString *retval = @"";
	NSString *type = [instruction objectAtIndex:0];
	
	int visualPC = row + 1;
	
	if ([type isEqualToString:@"Z"])
		retval = [NSString stringWithFormat:@"i%d: Z(%d)", visualPC, [[instruction objectAtIndex:1] intValue]];
    
	if ([type isEqualToString:@"S"])
		retval = [NSString stringWithFormat:@"i%d: S(%d)", visualPC, [[instruction objectAtIndex:1] intValue]];
	
	if ([type isEqualToString:@"T"])
		retval = [NSString stringWithFormat:@"i%d: T(%d, %d)", visualPC, [[instruction objectAtIndex:1] intValue], [[instruction objectAtIndex:2] intValue]];
	
	if ([type isEqualToString:@"J"])
		retval = [NSString stringWithFormat:@"i%d: J(%d, %D, %D)", visualPC, [[instruction objectAtIndex:1] intValue], [[instruction objectAtIndex:2] intValue], [[instruction objectAtIndex:3] intValue]];
	
	return retval;
  
}

// if you feel creative to create your own cells...

/*- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *retval = (id)view;
	if (!retval) {
		retval= [[[UILabel alloc] initWithFrame:CGRectMake(40, 0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
	}
	retval.textAlignment = UITextAlignmentLeft;
	retval.font = [UIFont fontWithName:@"Courier" size:16];
	
	if (row == [instructions count]) {
		retval.text = @"END";
	}
	
	else {
		NSArray *instruction = [instructions objectAtIndex:row];
		NSString *type = [instruction objectAtIndex:0];
	
		int visualPC = row + 1;
	
		if
 ([type isEqualToString:@"Z"]) {
			retval.text = [NSString stringWithFormat:@"i%d: Z(%d)", visualPC, [[instruction objectAtIndex:1] intValue]];
		}
		if ([type isEqualToString:@"S"]) {
			retval.text = [NSString stringWithFormat:@"i%d: S(%d)", visualPC, [[instruction objectAtIndex:1] intValue]];
		}
		if ([type isEqualToString:@"T"]) {
			retval.text = [NSString stringWithFormat:@"i%d: T(%d,%d)", visualPC, [[instruction objectAtIndex:1] intValue], [[instruction objectAtIndex:2] intValue]];
		}
		if ([type isEqualToString:@"J"]) {
			retval.text = [NSString stringWithFormat:@"i%d: J(%d,%D,%D)", visualPC, [[instruction objectAtIndex:1] intValue], [[instruction objectAtIndex:2] intValue], [[instruction objectAtIndex:3] intValue]];
		}
	}
	
	return retval;
}*/

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}




@end
