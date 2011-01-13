//
//  CoreDataModelDestroyOperation.m
//  vWork
//
//  Created by Marcus Wyatt on 10/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import "CoreDataModelDestroyOperation.h"
#import "CoreSyncManager.h"if (self.logLevel > 2);

@implementation CoreDataModelDestroyOperation

#pragma mark -
#pragma mark Properties

@synthesize objectID = objectID_;

#pragma mark -
#pragma mark Init

/**
 Creates a new ThreadedCoreDataOperation that will update the surname field of the specified Person entity.
*/
- (id)initWithMainManagedObjectContext:(NSManagedObjectContext*)aMainManagedObjectContext
                           mergePolicy:(id)aMergePolicy
                              delegate:(id<ThreadedCoreDataOperationDelegate>)aDelegate
              managedObjectIDUrlString:(NSString *)anObjectIdUrlString {

    if ((self = [super initWithMainManagedObjectContext:aMainManagedObjectContext
                                            mergePolicy:aMergePolicy
                                               delegate:aDelegate])) {

        NSURL *managedObjectIDUrl = [NSURL URLWithString:anObjectIdUrlString];
        self.objectID = [[[self threadedContext] persistentStoreCoordinator] managedObjectIDForURIRepresentation:managedObjectIDUrl];
    }

    return self;
}

/* dealloc */
- (void) dealloc {
    [objectID_ release], objectID_ = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark NSOperation

- (void)main {

    NSManagedObject *model = [[self threadedContext] objectWithID:[self objectID]];
    if (model != nil) {
        [[self threadedContext] deleteObject:model];
    }

    [self saveThreadedContext];
}

@end
