//
//  iURMAppDelegate.m
//  iURM
//
//  Created by Alberto De Bortoli on 8/7/10.
//  Copyright Alberto De Bortoli 2011. All rights reserved.
//

#import "iURMAppDelegate.h"
#import "ProgListVC.h"
#include <unistd.h>

@implementation iURMAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize referenceToProgListForSaving;

#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
	// Override point for customization after application launch.
    
	// Add the navigation controller's view to the window and display.
	UIImageView *splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
	splashView.image = [UIImage imageNamed:@"background.png"];
	[window addSubview:splashView];
	[window bringSubviewToFront:splashView];
	
	[window addSubview:navigationController.view];
	[window makeKeyAndVisible];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *pathDB = [documentsDirectory stringByAppendingPathComponent:@"DB.plist"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:pathDB]){
		[[NSFileManager defaultManager] createFileAtPath:pathDB contents:nil attributes:nil]; //contents:root
		
		NSString *pathBundle = [[NSBundle mainBundle] pathForResource:@"DB" ofType:@"plist"];
		NSString *pathDocs = [documentsDirectory stringByAppendingPathComponent:@"DB.plist"];
		NSArray *plist = [NSMutableArray arrayWithContentsOfFile:pathBundle];
		[plist writeToFile:pathDocs atomically:YES];
	}
	
	usleep(1000000);
	
	// fade out effect for splash screen 
	splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
	splashView.image = [UIImage imageNamed:@"Default.png"];
	[window addSubview:splashView];
	[window bringSubviewToFront:splashView];
    
    [UIView animateWithDuration:0.5 animations:^{
        [splashView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [splashView removeFromSuperview];
    }];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[referenceToProgListForSaving saveToDB];
	NSLog(@"Saving DB on applicationDidEnterBackground");
	
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[referenceToProgListForSaving saveToDB];
    NSLog(@"Saving DB on applicationWillTerminate");
}

@end

