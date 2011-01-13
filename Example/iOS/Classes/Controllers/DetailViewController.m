//
//  DetailViewController.m
//  vWork
//
//  Created by Marcus Wyatt on 5/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//
//  IMPORTANT: The DetailViewController is an Abstract Class. Please Use one
//             of the device specific controllers for non generic code

#import "DetailViewController.h"
#import "RootViewController.h"

@implementation DetailViewController

@synthesize model, tabBarController;


#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setModel:(NSManagedObject *)managedObject {

	if (model != managedObject) {
		[model release];
		model = [managedObject retain];

        // Update the view.
        [self setModelOnChildViewController:[[self tabBarController] selectedViewController]];
	}
}


- (void)setModelOnChildViewController:(id)viewController {

    if ([viewController respondsToSelector:@selector(setModel:)]) {
        [viewController performSelector:@selector(setModel:) withObject:model];
    }
}


#pragma mark -
#pragma mark UITabBarControllerDelegate Protocol

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

    // Update the view.
    [self setModelOnChildViewController:viewController];
}

#pragma mark -
#pragma mark View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    // Update the view.
    [self setModelOnChildViewController:[[self tabBarController] selectedViewController]];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {

	[model release], model = nil;
    [projectViewController release], projectViewController = nil;
    [milestonesViewController release], milestonesViewController = nil;

	[super dealloc];
}


@end
