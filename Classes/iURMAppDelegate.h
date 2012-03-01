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
    UINavigationController *navigationController;
	ProgListVC *referenceToProgListForSaving;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong) IBOutlet ProgListVC *referenceToProgListForSaving;

@end

