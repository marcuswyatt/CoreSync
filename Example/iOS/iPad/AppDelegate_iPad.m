//
//  AppDelegate_iPad.m
//  Jobber
//
//  Created by Marcus Wyatt on 13/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import "AppDelegate_iPad.h"

#import "RootViewController_iPad.h"
#import "DetailViewController_iPad.h"

@implementation AppDelegate_iPad

@synthesize splitViewController, rootViewController, detailViewController;

#pragma mark -
#pragma mark Application lifecycle

- (void)awakeFromNib {
    // Pass the managed object context to the root view controller.
    rootViewController.managedObjectContext = self.managedObjectContext;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
    [self.window addSubview:splitViewController.view];
    [super application:application didFinishLaunchingWithOptions:launchOptions];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


/**
 Superclass implementation saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	[super applicationWillTerminate:application];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    [super applicationDidReceiveMemoryWarning:application];
}


- (void)dealloc {

    [splitViewController release];
	[rootViewController release];
	[detailViewController release];

	[super dealloc];
}


@end

