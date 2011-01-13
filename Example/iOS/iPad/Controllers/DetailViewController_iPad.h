//
//  DetailViewController_iPad.h
//  vWork
//
//  Created by Marcus Wyatt on 5/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import "DetailViewController.h"

@class RootViewController_iPad;

@interface DetailViewController_iPad : DetailViewController<UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
    UIPopoverController *popoverController;
    UIToolbar *toolbar;

    RootViewController_iPad *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, assign) IBOutlet RootViewController_iPad *rootViewController;

- (IBAction)insertNewObject:(id)sender;

@end
