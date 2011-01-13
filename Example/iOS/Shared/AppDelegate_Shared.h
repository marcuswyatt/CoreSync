//
//  AppDelegate_Shared.h
//  Jobber
//
//  Created by Marcus Wyatt on 13/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreSync.h"

@interface AppDelegate_Shared : NSObject <UIApplicationDelegate> {

    UIWindow *window;

    CoreSyncManager *coreSyncManager;

@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) CoreSyncManager *coreSyncManager;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end

