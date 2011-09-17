//
//  InstrAddEditVC.h
//  iURM
//
//  Created by Alberto De Bortoli on 8/8/10.
//  Copyright 2010 Alberto De Bortoli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProgDetailsVC;

@interface InstrAddEditVC : UIViewController <UITextFieldDelegate> {

	ProgDetailsVC *parent;
	int index;
	BOOL editMode;
	
	NSString *typeOfInstruction;
	int argumentOne;
	int argumentTwo;
	int argumentThree;
	
	IBOutlet UITextField *tfArgumentOne;
	IBOutlet UITextField *tfArgumentTwo;
	IBOutlet UITextField *tfArgumentThree;
	
	IBOutlet UISegmentedControl *sgmTypeOfInstruction;
	IBOutlet UILabel *lblInstuction;
	
	NSMutableArray *program;
  NSMutableArray *instructions;
}

- (void)setTextFieldVisible;

- (IBAction)changeTypeOfInstruction;
- (IBAction)dismissButton;
- (IBAction)saveButton;


@property(nonatomic, strong) ProgDetailsVC *parent;
@property(nonatomic) int index;
@property(nonatomic) BOOL editMode;

@end
