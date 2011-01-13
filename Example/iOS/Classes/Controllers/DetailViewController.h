//
//  DetailViewController.h
//  vWork
//
//  Created by Marcus Wyatt on 5/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//
//  IMPORTANT: The DetailViewController is an Abstract Class. Please Use one
//             of the device specific controllers for non generic code

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ProjectViewController.h"
#import "MilestonesViewController.h"

@interface DetailViewController : UIViewController <UITabBarControllerDelegate> {

    NSManagedObject *model;

    UITabBarController *tabBarController;
    ProjectViewController *projectViewController;
    MilestonesViewController *milestonesViewController;
}

@property (nonatomic, retain) NSManagedObject *model;
@property (nonatomic, assign) IBOutlet UITabBarController *tabBarController;

- (void)setModelOnChildViewController:(id)viewController;

@end
