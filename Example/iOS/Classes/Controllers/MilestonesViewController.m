//
//  MilestonesViewController.m
//  vWork
//
//  Created by Marcus Wyatt on 5/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import "MilestonesViewController.h"
#import "CoreSyncManager.h"

@implementation MilestonesViewController

#pragma mark -
#pragma mark Properties

@synthesize nameField;
@synthesize plannedStartField;
@synthesize publishedByField;
@synthesize deletedAtField;
@synthesize createdAtLabel;
@synthesize updatedAtLabel;
@synthesize model;

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
        [[self nameField] setText:[[model valueForKey:@"name"] description]];
        [[self plannedStartField] setText:[[model valueForKey:@"plannedStartAt"] description]];
        [[self publishedByField] setText:[[model valueForKey:@"publishedBy"] description]];
        [[self deletedAtField] setText:[[model valueForKey:@"deletedAt"] description]];
        [[self createdAtLabel] setText:[[model valueForKey:@"createdAt"] description]];
        [[self updatedAtLabel] setText:[[model valueForKey:@"updatedAt"] description]];
	}
}

- (id)init {
   if (self = [super initWithNibName:@"MilestonesViewController" bundle:nil]) {
      self.title = @"Milestones View Controller";

      UIImage* anImage = [UIImage imageNamed:@"icon-milestones.png"];
      UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"Milestones" image:anImage tag:0];
      self.tabBarItem = theItem;
      [theItem release];
   }
   return self;
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        self.title = @"Milestones View Controller";

        UIImage* anImage = [UIImage imageNamed:@"icon-milestones.png"];
        UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"Milestones" image:anImage tag:0];
        self.tabBarItem = theItem;
        [theItem release];
    }
    return self;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [[[self model] managedObjectContext] processPendingChanges];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.nameField = nil;
    self.plannedStartField = nil;
    self.publishedByField = nil;
    self.deletedAtField = nil;
    self.createdAtLabel = nil;
    self.updatedAtLabel = nil;
}


- (void)dealloc {

    [model release], model = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)nameFieldChanged:(id)sender {
    [[self model] setValue:[sender text] forKey:@"name"];
}

- (IBAction)plannedStartFieldChanged:(id)sender {
    NSDateFormatter *dateParser = [[CoreSyncManager sharedInstance] defaultDateParser];
    NSDate *plannedStartDate = [dateParser dateFromString:[sender text]];
    [[self model] setValue:plannedStartDate forKey:@"plannedStartAt"];
}

- (IBAction)publishedByFieldChanged:(id)sender {
    NSDateFormatter *dateParser = [[CoreSyncManager sharedInstance] defaultDateParser];
    NSDate *plannedStartDate = [dateParser dateFromString:[sender text]];
    [[self model] setValue:plannedStartDate forKey:@"publishedBy"];
}

- (IBAction)deletedAtFieldChanged:(id)sender {
    NSDateFormatter *dateParser = [[CoreSyncManager sharedInstance] defaultDateParser];
    NSDate *plannedStartDate = [dateParser dateFromString:[sender text]];
    [[self model] setValue:plannedStartDate forKey:@"deletedAt"];
}

@end
