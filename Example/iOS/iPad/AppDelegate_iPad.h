//
//  AppDelegate_iPad.h
//  Jobber
//
//  Created by Marcus Wyatt on 13/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import "AppDelegate_Shared.h"

@class RootViewController_iPad;
@class DetailViewController_iPad;

@interface AppDelegate_iPad : AppDelegate_Shared {
    UISplitViewController *splitViewController;
    RootViewController_iPad *rootViewController;
	DetailViewController_iPad *detailViewController;
}

#pragma mark -
#pragma mark Properties

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController_iPad *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController_iPad *detailViewController;

@end

