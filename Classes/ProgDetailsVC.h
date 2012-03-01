//
//  ProgDetailsVC.h
//  iURM
//
//  Created by Alberto De Bortoli on 8/7/10.
//  Copyright 2010 Alberto De Bortoli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProgListVC;

@interface ProgDetailsVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
	ProgListVC *parent;
	int index;
	
	IBOutlet UITableView *tableInstructions;
	IBOutlet UILabel *lblDescription;
	IBOutlet UIButton *runButton;
	
	NSArray *program;
    NSMutableArray *instructions;
}

- (IBAction)addInstruction;
- (IBAction)runProgram;

@property(nonatomic, strong) ProgListVC *parent;
@property(nonatomic, strong) UITableView *tableInstructions;
@property(nonatomic) int index;

@end
