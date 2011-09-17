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
	id <AboutViewControllerDelegate> __unsafe_unretained delegate;
}

- (IBAction)done;

@property(nonatomic, unsafe_unretained) id <AboutViewControllerDelegate> delegate;

@end


@protocol AboutViewControllerDelegate
- (void)AboutViewControllerDidFinish:(AboutViewController *)controller;
@end

