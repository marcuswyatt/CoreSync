//
//  CoreDataModelSyncOperation.m
//  vWork
//
//  Created by Marcus Wyatt on 10/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import "CoreDataModelSyncOperation.h"

@interface CoreDataModelSyncOperation(PrivateMethods)
- (void)updateModelWithAttributes:(NSDictionary *)anAttributes;
@end

@implementation CoreDataModelSyncOperation

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

    NSManagedObject *model = nil;

    // 1. Check if the model exist by querying the local persistence using id (remoteId)
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[self entityDescription]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteId == %@", [anAttributes valueForKey:@"id"]];
    [fetchRequest setPredicate:predicate];

    NSError *error = nil;
    NSArray *models = [[self threadedContext] executeFetchRequest:fetchRequest error:&error];

    [fetchRequest release];

    if (models != nil && [models count] == 1) {
        model = [[models objectAtIndex:0] retain];
    } else {
        // 2. Not found, Create a new model
        model = [[NSManagedObject alloc] initWithEntity:[self entityDescription] insertIntoManagedObjectContext:[self threadedContext]];
    }

    [self updatePropertiesFor:model withParameters:anAttributes];

    [model release];

}

@end
