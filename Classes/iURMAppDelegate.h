//
//  iURMAppDelegate.h
//  iURM
//
//  Created by Alberto De Bortoli on 8/7/10.
//  Copyright Alberto De Bortoli 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProgListVC;

@interface iURMAppDelegate : NSObject <UIApplicationDelegate> {
    
  UIWindow *window;
	UIImageView *splashView;
  UINavigationController *navigationController;
	ProgListVC *referenceToProgListForSaving;
}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet ProgListVC *referenceToProgListForSaving;

@end

