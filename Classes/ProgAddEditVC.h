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
	
	UITextField *tfName;
	UITextField *tfNote;
	UITextField *tfNumberOfInstruction;
}

- (IBAction)dismissButton;
- (IBAction)saveButton;

@property(nonatomic, strong) ProgListVC *parent;
@property(nonatomic, unsafe_unretained) int index;
@property(nonatomic, unsafe_unretained) BOOL editMode;

@end
