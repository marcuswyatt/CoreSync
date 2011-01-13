//
//  DetailViewController_iPhone.m
//  vWork
//
//  Created by Marcus Wyatt on 6/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import "DetailViewController_iPhone.h"
#import "ProjectViewController.h"
#import "MilestonesViewController.h"

@implementation DetailViewController_iPhone

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

#pragma mark -
#pragma mark View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

    [super loadView];

    projectViewController = [[ProjectViewController alloc] initWithNibName:@"ProjectViewController_iPhone" bundle:nil];

    milestonesViewController = [[MilestonesViewController alloc] initWithNibName:@"MilestonesViewController_iPhone" bundle:nil];

    NSArray *viewControllers = [NSArray arrayWithObjects:projectViewController, milestonesViewController, nil];

    [projectViewController release];
    [milestonesViewController release];

    tabBarController = [[UITabBarController alloc] init];

    [[self tabBarController] setViewControllers:viewControllers];
    [[self tabBarController] setDelegate:self];
    [[self tabBarController] setSelectedIndex:0];

    [[self view] addSubview:[[self tabBarController] view]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"[%s:%s:%d] %@",__FUNCTION__,__FILE__,__LINE__, [[self tabBarController] selectedViewController]);

    [super setModelOnChildViewController:[[self tabBarController] selectedViewController]];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {

    [model release], model = nil;
    [projectViewController release], projectViewController = nil;
    [milestonesViewController release], milestonesViewController = nil;

    [super dealloc];
}


@end
