//
//  ProgListVC.h
//  iURM
//
//  Created by Alberto De Bortoli on 8/7/10.
//  Copyright 2010 Alberto De Bortoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgDetailsVC.h"
#import "ProgAddEditVC.h"
#import "AboutViewController.h"


@interface ProgListVC : UIViewController <UITableViewDelegate, UITableViewDataSource, AboutViewControllerDelegate> {
	
	NSMutableArray *programsArray;
	IBOutlet UITableView *tableList;
}

- (IBAction)addProgram;
- (IBAction)showInfo;
- (void)saveToDB;

@property (nonatomic, strong) NSMutableArray *programsArray;
@property (nonatomic, strong) IBOutlet UITableView *tableList;

@end
