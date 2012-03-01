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

- (void)viewDidLoad
{
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	[super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)done
{
	[self.delegate AboutViewControllerDidFinish:self];	
}

#pragma mark - Memory management

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

@end
