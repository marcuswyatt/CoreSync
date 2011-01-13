//
//  CoreDataModelUpdateOperation.m
//  vWork
//
//  Created by Marcus Wyatt on 11/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import "CoreDataModelUpdateOperation.h"

@interface CoreDataModelUpdateOperation(PrivateMethods)
- (void)updateModelWithAttributes:(NSDictionary *)anAttributes;
@end

@implementation CoreDataModelUpdateOperation

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
                    jsonResponseString:(NSString*)aJsonResponseString
              managedObjectIDUrlString:(NSString *)anObjectIdUrlString {

    if ((self = [super initWithMainManagedObjectContext:aMainManagedObjectContext
                                            mergePolicy:aMergePolicy
                                               delegate:aDelegate
                                     jsonResponseString:aJsonResponseString])) {

        NSURL *managedObjectIDUrl = [NSURL URLWithString:anObjectIdUrlString];
        self.objectID = [[[self threadedContext] persistentStoreCoordinator] managedObjectIDForURIRepresentation:managedObjectIDUrl];
    }

    return self;
}

#pragma mark -
#pragma mark Dealloc

/* dealloc */
- (void) dealloc {
    [objectID_ release], objectID_ = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark NSOperation

- (void)main {

    id parameters = [self deserializeJSONString];

    if ([parameters isKindOfClass:[NSArray class]]) {

        for (NSDictionary *model in parameters) {

            for (NSDictionary *modelAttributes in [model allValues]) {
                [self updateModelWithAttributes:modelAttributes];
            }
        }
    }
    else if ([parameters isKindOfClass:[NSDictionary class]]) {
        for (NSDictionary *modelAttributes in [parameters allValues]) {
            [self updateModelWithAttributes:modelAttributes];
        }
    }

    [self saveThreadedContext];
}

- (void)updateModelWithAttributes:(NSDictionary *)anAttributes {

    NSManagedObject *model = [[self threadedContext] objectWithID:[self objectID]];

    [self updatePropertiesFor:model withParameters:anAttributes];
}

@end
