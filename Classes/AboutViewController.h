//
//  AboutViewController.h
//  Utility
//
//  Created by Alberto De Bortoli on 6/15/10.
//  Copyright Alberto De Bortoli 2011. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol AboutViewControllerDelegate;


@interface AboutViewController : UIViewController {
	id <AboutViewControllerDelegate> delegate;
}

- (IBAction)done;

@property(nonatomic, assign) id <AboutViewControllerDelegate> delegate;

@end


@protocol AboutViewControllerDelegate
- (void)AboutViewControllerDidFinish:(AboutViewController *)controller;
@end

