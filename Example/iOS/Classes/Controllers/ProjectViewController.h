//
//  ProjectViewController.h
//  vWork
//
//  Created by Marcus Wyatt on 5/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ProjectViewController : UIViewController {
    UITextField *nameField;
    UITextField *plannedStartField;
    UITextField *publishedByField;
    UITextField *deletedAtField;
    UILabel *createdAtLabel;
    UILabel *updatedAtLabel;

    NSManagedObject *model;
}

#pragma mark -
#pragma mark Properties

@property (nonatomic, assign) IBOutlet UITextField *nameField;
@property (nonatomic, assign) IBOutlet UITextField *plannedStartField;
@property (nonatomic, assign) IBOutlet UITextField *publishedByField;
@property (nonatomic, assign) IBOutlet UITextField *deletedAtField;
@property (nonatomic, assign) IBOutlet UILabel *createdAtLabel;
@property (nonatomic, assign) IBOutlet UILabel *updatedAtLabel;
@property (nonatomic, retain) NSManagedObject *model;

#pragma mark -
#pragma mark IBActions

- (IBAction)nameFieldChanged:(id)sender;
- (IBAction)plannedStartFieldChanged:(id)sender;
- (IBAction)publishedByFieldChanged:(id)sender;
- (IBAction)deletedAtFieldChanged:(id)sender;

@end
