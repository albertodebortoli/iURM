//
//  ProgAddEditVC.h
//  iURM
//
//  Created by Alberto De Bortoli on 8/8/10.
//  Copyright 2010 Alberto De Bortoli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProgListVC;

@interface ProgAddEditVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate > {

	ProgListVC *parent;
	int index;
	BOOL editMode;
	
	UITextField *tfName;
	UITextField *tfNote;
	UITextField *tfNumberOfInstruction;
}

- (IBAction)dismissButton;
- (IBAction)saveButton;

@property(nonatomic, retain) ProgListVC *parent;
@property(nonatomic) int index;
@property(nonatomic) BOOL editMode;

@end
