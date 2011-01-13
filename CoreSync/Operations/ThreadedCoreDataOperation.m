//
//  ThreadedCoreDataOperation.m
//  vWork
//
//  Created by Marcus Wyatt on 9/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import "ThreadedCoreDataOperation.h"
#import "CoreSyncManager.h"

/**
 Category for private API of this class.
 */
@interface ThreadedCoreDataOperation(PrivateMethods)

/**
 Selector called when the threaded context is saved (registered and unregistered for notifications) which is responsible
 for merging the threaded context changes into the main thread context.
 @param notification - notification
 */
- (void)mergeThreadedContextChangesIntoMainContext:(NSNotification *)notification;

@end

@implementation ThreadedCoreDataOperation

#pragma mark -
#pragma mark Properties

@synthesize remoteEntityName = remoteEntityName_;
@synthesize mainContext = mainContext_;
@synthesize threadedContext = threadedContext_;
@synthesize delegate = delegate_;
@synthesize jsonResponseString = jsonResponseString_;

@dynamic dateParserFormat;

/* defaultDateParserFormat */
- (NSString *)dateParserFormat {
    if (dateParserFormat_ == nil) {
        dateParserFormat_ = [[NSUserDefaults standardUserDefaults] valueForKey:@"CoreSync.DefaultDateParserFormat"];
    }

    return dateParserFormat_;
}

- (void)setDateParserFormat:(NSString *)aDateParserFormat {
    if (dateParserFormat_ != aDateParserFormat) {
        [dateParserFormat_ release];
        dateParserFormat_ = [aDateParserFormat copy];
    }
}

@dynamic modelMapper;

/* modelMapper */
- (CoreSyncModelMapper* )modelMapper {

    if (modelMapper_ == nil) {
        modelMapper_ = [[CoreSyncModelMapper alloc] initWithMainManagedObjectContext:[self threadedContext]
                                                                       remoteSiteURL:[[CoreSyncManager sharedInstance] remoteSiteURL]];
    }
    return modelMapper_;
}

#pragma mark -
#pragma mark Init

- (id)initWithMainManagedObjectContext:(NSManagedObjectContext*)aMainManagedObjectContext
                           mergePolicy:(id)aMergePolicy {

    return [self initWithMainManagedObjectContext:aMainManagedObjectContext
                                      mergePolicy:aMergePolicy
                                         delegate:nil];
}

- (id)initWithMainManagedObjectContext:(NSManagedObjectContext*)aMainManagedObjectContext
                           mergePolicy:(id)aMergePolicy
                              delegate:(id<ThreadedCoreDataOperationDelegate>)aDelegate {

    return [self initWithMainManagedObjectContext:aMainManagedObjectContext
                                      mergePolicy:aMergePolicy
                                         delegate:aDelegate
                               jsonResponseString:@""];
}

- (id)initWithMainManagedObjectContext:(NSManagedObjectContext*)aMainManagedObjectContext
                           mergePolicy:(id)aMergePolicy
                              delegate:(id<ThreadedCoreDataOperationDelegate>)aDelegate
                    jsonResponseString:(NSString*)aJsonResponseString {

    return [self initWithMainManagedObjectContext:aMainManagedObjectContext
                                      mergePolicy:aMergePolicy
                                         delegate:aDelegate
                               jsonResponseString:aJsonResponseString
                                 dateParserFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
}

- (id)initWithMainManagedObjectContext:(NSManagedObjectContext*)aMainManagedObjectContext
                           mergePolicy:(id)aMergePolicy
                              delegate:(id<ThreadedCoreDataOperationDelegate>)aDelegate
                    jsonResponseString:(NSString*)aJsonResponseString
                      dateParserFormat:(NSString*)aDateParserFormat {

    if ((self = [super init])) {
        mainContext_ = [aMainManagedObjectContext retain];
        mergePolicy_ = [aMergePolicy retain];
        remoteEntityName_ = nil;
        delegate_ = aDelegate;
        jsonResponseString_ = [aJsonResponseString copy];
        dateParserFormat_ = [aDateParserFormat copy];
    }
    return self;
}

#pragma mark -
#pragma mark Dealloc

/* dealloc */
- (void)dealloc {
    delegate_ = nil;

    remoteEntityName_ = nil;

    [mainContext_ release];
    [threadedContext_ release];
    [mergePolicy_ release];
    [dateParserFormat_ release], dateParserFormat_ = nil;
    [jsonResponseString_ release], jsonResponseString_ = nil;


    [super dealloc];
}

#pragma mark -
#pragma mark ThreadedCoreDataOperation

- (NSManagedObjectContext*)threadedContext {
    if (!threadedContext_) {
        threadedContext_ = [[NSManagedObjectContext alloc] init];
        [threadedContext_ setPersistentStoreCoordinator:[[self mainContext] persistentStoreCoordinator]];
        [threadedContext_ setMergePolicy:mergePolicy_];
    }

    return threadedContext_;
}

- (void)saveThreadedContext {

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];

    [defaultCenter addObserver:self
                      selector:@selector(mergeThreadedContextChangesIntoMainContext:)
                          name:NSManagedObjectContextDidSaveNotification
                        object:self.threadedContext];

    if ([[self threadedContext] hasChanges]) {

        NSError *error;

        if (![[self threadedContext] save:&error]) {

            // If the context failed to save, log out as many details as possible.
            NSLog(@"Failed to save to data store: %@", [error localizedDescription]);

            NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];

            if (detailedErrors != nil && [detailedErrors count] > 0) {

                for (NSError* detailedError in detailedErrors) {
                    NSLog(@"  DetailedError: %@", [detailedError userInfo]);
                }
            } else {
                NSLog(@"  %@", [error userInfo]);
            }
        }
    }

    [defaultCenter removeObserver:self name:NSManagedObjectContextDidSaveNotification object:[self threadedContext]];
}

#pragma mark -
#pragma mark PrivateMethods

- (void)mergeThreadedContextChangesIntoMainContext:(NSNotification *)notification {

    [mainContext_ performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                   withObject:notification
                                waitUntilDone:YES];
}

#pragma mark -
#pragma mark Helpers

- (void)updateLocalProperty:(NSString *)aLocalFieldName
                      model:(NSManagedObject *)anModel
                  withValue:(id)remoteValue
              attributeType:(NSAttributeType)attributeType {


    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[self dateParserFormat]];

    switch (attributeType) {
        case NSUndefinedAttributeType:
            //NSLog(@"[%s:%s:%d] NSUndefinedAttributeType for %@:%@",__FUNCTION__,__FILE__,__LINE__, [model class], localFieldName);
            break;
        case NSInteger16AttributeType:
            [anModel setValue:remoteValue forKey:aLocalFieldName];
            break;
        case NSInteger32AttributeType:
            [anModel setValue:remoteValue forKey:aLocalFieldName];
            break;
        case NSInteger64AttributeType:
            [anModel setValue:remoteValue forKey:aLocalFieldName];
            break;
        case NSDecimalAttributeType:
            [anModel setValue:[NSDecimalNumber decimalNumberWithString:remoteValue] forKey:aLocalFieldName];
            break;
        case NSDoubleAttributeType:
            [anModel setValue:remoteValue forKey:aLocalFieldName];
            break;
        case NSFloatAttributeType:
            [anModel setValue:remoteValue forKey:aLocalFieldName];
            break;
        case NSStringAttributeType:
            [anModel setValue:remoteValue forKey:aLocalFieldName];
            break;
        case NSBooleanAttributeType:
            [anModel setValue:remoteValue forKey:aLocalFieldName];
            break;
        case NSDateAttributeType: {
            if ([(NSString *)remoteValue isEqualToString:@"<null>"]) {
            } else {
                [anModel setValue:[dateFormatter dateFromString:(NSString *)remoteValue] forKey:aLocalFieldName];
            }
            break;
        }
        case NSBinaryDataAttributeType:
            // TODO: See what binary data we need to transform
            break;
        default:
            [anModel setValue:remoteValue forKey:aLocalFieldName];
            break;
    }
    [dateFormatter release];
}

- (NSManagedObject *)findNestedModel:(id)remoteId childModels:(NSArray *)childModels {

    for (NSManagedObject *childModel in childModels) {

        NSNumber *localIdField = [childModel valueForKey:[[self modelMapper] localIdField]];

        if (localIdField == remoteId) {
            return childModel;
        }
    }
    return nil;
}

- (void)updatePropertiesFor:(NSManagedObject *)model withParameters:(NSDictionary *)remoteModelAttributes {

    NSLog(@"[%s:%s:%d] ThreadedCoreDataOperation#updateAttributesFor((NSManagedObject *)%@, (NSDictionary *)%@)",__FUNCTION__,__FILE__,__LINE__, [model class], remoteModelAttributes);

    CoreSyncModelMapper *mapper = [self modelMapper];

    // Update the model attributes
    for (NSString *remoteFieldName in remoteModelAttributes) {

        NSString *localFieldName = [mapper localNameForRemoteField:remoteFieldName onModel:model];

        if (localFieldName == nil)  continue;

        NSPropertyDescription *propertyDescription = [mapper propertyDescriptionForField:localFieldName onModel:model];

        if ([propertyDescription isKindOfClass:[NSAttributeDescription class]]) {

            NSAttributeDescription *attributeDescription = (NSAttributeDescription *)propertyDescription;

            id remoteValue = [remoteModelAttributes valueForKey:remoteFieldName];

            if ((remoteValue == nil) || (remoteValue == (id)[NSNull null])) {
            } else {
                [self updateLocalProperty:localFieldName
                                    model:model
                                withValue:remoteValue
                            attributeType:[attributeDescription attributeType]];
            }

        } else if ([propertyDescription isKindOfClass:[NSRelationshipDescription class]]) {

            NSRelationshipDescription *relationship = (NSRelationshipDescription *)propertyDescription;

            if ([relationship isToMany]) {

                id remoteValue = [remoteModelAttributes valueForKey:localFieldName];

                if ((remoteValue == nil) || (remoteValue == (id)[NSNull null])) {
                } else {

                    NSArray *childModels = [model valueForKey:localFieldName];

                    for (NSDictionary *nestedModelAttributes in remoteValue) {

                        id remoteId = [nestedModelAttributes valueForKey:[mapper remoteIdField]];

                        NSManagedObject *childModel = [self findNestedModel:remoteId childModels:childModels];

                        if (childModel == nil) {
                            childModel = [[NSManagedObject alloc] initWithEntity:[relationship destinationEntity] insertIntoManagedObjectContext:[self threadedContext]];
                        }
                        [childModel setValue:model forKey:[[mapper remoteClassName:model] lowercaseString]];

                        [self updatePropertiesFor:childModel withParameters:nestedModelAttributes];
                    }
                }
            }
        }
    }
    [model setValue:[NSDate date] forKey:@"syncedAt"];

    NSLog(@"[%s:%s:%d] %@",__FUNCTION__,__FILE__,__LINE__, model);

}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    return [[self threadedContext] persistentStoreCoordinator];
}

- (NSManagedObjectModel *)managedObjectModel {
    return [[self persistentStoreCoordinator] managedObjectModel];
}

- (NSDictionary *)entitiesByName {
    return [[self managedObjectModel] entitiesByName];
}

- (NSArray *)entities {
    return [[self managedObjectModel] entities];
}

- (NSString *)entityName {
    return [[self entityDescription] name];
}

- (NSEntityDescription *)entityDescription {

    for (NSEntityDescription *entity in [self entities]) {

        NSString *remoteClassName = [[entity userInfo] objectForKey:@"remoteClassName"];

        if ([[remoteClassName lowercaseString] isEqual:[[self remoteEntityName] lowercaseString]]) {
            return entity;
        }
    }

    return nil;
}

#pragma mark -
#pragma mark Deserialization

- (id)deserializeJSONString {

//    @synchronized(self) {
        SBJsonParser *jsonParser = [SBJsonParser new];
        id jsonData = [jsonParser objectWithString:[self jsonResponseString]];

        if (jsonData == nil) {
            // Record error and return if JSON parsing failed
            NSError *error = [[NSError alloc] initWithDomain:[NSString stringWithFormat:@"JSON parsing failed: %@", [jsonParser error]] code:0 userInfo:nil];
            [[self delegate] jsonDeserializationFailed:error];
            [error release];
        } else {

            if ([jsonData isKindOfClass:[NSArray class]]) {
                // Collection Request
                remoteEntityName_ = [[[jsonData objectAtIndex:0] allKeys] objectAtIndex:0];
            }
            else if ([jsonData isKindOfClass:[NSDictionary class]]) {
                // Item Request
                remoteEntityName_ = [[jsonData allKeys] objectAtIndex:0];
            }
        }
        [jsonParser release];
        return jsonData;
//    }
}


@end
