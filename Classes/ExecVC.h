//
//  ExecVC.h
//  iURM
//
//  Created by Alberto De Bortoli on 8/8/10.
//  Copyright 2010 Alberto De Bortoli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProgDetailsVC;

@interface ExecVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate> {

	ProgDetailsVC *parent;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIPickerView *picker;
	IBOutlet UILabel *lblProgramCounter;
	IBOutlet UIButton *buttonForBackground;
	IBOutlet UIButton *startButton;
	IBOutlet UIButton *clearButton;
	IBOutlet UIButton *startOverButton;
	IBOutlet UIView *viewProgramCounter;
	IBOutlet UIImageView *imgProgramCounter;
	IBOutlet UILabel *startLabel;
	
	int PC;
	int arg1;
	int arg2;
	int arg3;
	int value;
	CGRect previousFrame;
	UIView *originView;
	UIView *destinationView;
	UITextField *origin;
	UITextField *destination;
	
	NSArray *program;
	NSArray *instructions;
	NSMutableArray *usedRegisters;
}

- (IBAction)start;
- (IBAction)startOver;
- (IBAction)clearRegisters;
- (IBAction)makeKeyboardGoAway;

- (void)enableButtonsForAnimation:(BOOL)state;
- (void)hideKeyboard;
- (void)addButtonToKeyboard;
- (void)programEndedAlert;
- (NSMutableArray *)calculateUsedRegisters;

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) ProgDetailsVC *parent;
@property(nonatomic, strong) UIPickerView *picker;

@end
