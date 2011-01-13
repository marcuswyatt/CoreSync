//
//  DetailViewController_iPad.m
//  vWork
//
//  Created by Marcus Wyatt on 5/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import "DetailViewController_iPad.h"

@interface DetailViewController_iPad ()
@property (nonatomic, retain) UIPopoverController *popoverController;
@end

@implementation DetailViewController_iPad

@synthesize rootViewController, toolbar, popoverController;

#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setModel:(NSManagedObject *)managedObject {
    [super setModel:managedObject];

    // Make sure we dismiss popover if its shown
    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }
}

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
#pragma mark Object insertion

- (IBAction)insertNewObject:(id)sender {

	[self.rootViewController insertNewObject:sender];
}

#pragma mark -
#pragma mark View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

    [super loadView];

    projectViewController = [[ProjectViewController alloc] initWithNibName:@"ProjectViewController_iPad" bundle:nil];

    milestonesViewController = [[MilestonesViewController alloc] initWithNibName:@"MilestonesViewController_iPad" bundle:nil];

    NSArray *viewControllers = [NSArray arrayWithObjects:projectViewController, milestonesViewController, nil];

    [projectViewController release];
    [milestonesViewController release];

    tabBarController = [[UITabBarController alloc] init];

    [[[self tabBarController] view] setFrame:CGRectMake(0, 60, 768, 1004 - 60)];

    [[self tabBarController] setViewControllers:viewControllers];
    [[self tabBarController] setDelegate:self];

    [[self view] addSubview:[[self tabBarController] view]];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {

    barButtonItem.title = @"Projects";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {

    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.toolbar = nil;
    self.rootViewController = nil;
}


- (void)dealloc {

    [popoverController release], popoverController = nil;
    [rootViewController release], rootViewController = nil;

    [super dealloc];
}


@end
