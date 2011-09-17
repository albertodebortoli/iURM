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


#pragma mark -
#pragma mark Application lifecycle

- (void)startupAnimationDone:(NSString *)animationID
                    finished:(NSNumber *)finished
                     context:(void *)context {
	[splashView removeFromSuperview];
}


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
	// Override point for customization after application launch.
    
	// Add the navigation controller's view to the window and display.
	splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
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
	
	// another splash screen, the first one needs for the background calling the About window
	// this one needs for the fade out
	splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
	splashView.image = [UIImage imageNamed:@"Default.png"];
	[window addSubview:splashView];
	[window bringSubviewToFront:splashView];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window cache:YES];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
	splashView.alpha = 0.0;
	[UIView commitAnimations];
	
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
   */
	[referenceToProgListForSaving saveToDB];
	NSLog(@"Saving DB on applicationDidEnterBackground");
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  /*
   Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application {
  /*
   Called when the application is about to terminate.
   See also applicationDidEnterBackground:.
   */
	[referenceToProgListForSaving saveToDB];
  NSLog(@"Saving DB on applicationWillTerminate");
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
  /*
   Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
   */
}



@end

