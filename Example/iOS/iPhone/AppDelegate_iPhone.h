//
//  AppDelegate_iPhone.h
//  Jobber
//
//  Created by Marcus Wyatt on 13/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import "AppDelegate_Shared.h"

@interface AppDelegate_iPhone : AppDelegate_Shared {
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

