//
//
//  AboutViewController.m
//  Utility
//
//  Created by Alberto De Bortoli on 6/15/10.
//  Copyright Alberto De Bortoli 2011. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

@synthesize delegate;


- (void)viewDidLoad {
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	[super viewDidLoad];
}


#pragma mark - Actions

- (IBAction)done {

	[self.delegate AboutViewControllerDidFinish:self];	
}


#pragma mark - Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
  delegate = nil;
  [super dealloc];
}


@end
