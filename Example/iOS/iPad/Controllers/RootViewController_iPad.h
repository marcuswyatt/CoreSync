//
//  RootViewController_iPad.h
//  vWork
//
//  Created by Marcus Wyatt on 5/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//
#import "RootViewController.h"

@class DetailViewController_iPad;

@interface RootViewController_iPad : RootViewController {
    DetailViewController_iPad *detailViewController;
}

@property (nonatomic, retain) IBOutlet DetailViewController_iPad *detailViewController;

@end
