//
//  CoreSyncManager.m
//  vWork
//
//  Created by Marcus Wyatt on 9/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import "CoreSyncManager.h"
#import "CoreSyncUtils.h"
#import "CoreDataModelSyncOperation.h"
#import "CoreDataModelDestroyOperation.h"
#import "CoreDataModelUpdateOperation.h"
#import "ASIFormDataRequest.h"

@interface CoreSyncManager (PrivateMethods)
- (void)saveChanges;
- (void)addPostValueOn:(ASIFormDataRequest *)request forModel:(NSManagedObject *)model;
@end

@interface CoreSyncManager (ActionMethods)

#pragma mark -
#pragma mark Action Methods

- (void)syncronizeUpdatedObjects;
- (void)syncronizeDeletedObjects;
- (void)syncronizeInsertedModelsforEntity:(NSEntityDescription *)entity;
- (void)syncronizeRemoteWithLocalForEntity:(NSEntityDescription *)entity;
- (void)syncronizeRemoteNestedResourcesWithLocalForEntity:(NSEntityDescription *)entity;
- (void)updateCreatedModelAttributes:(ASIHTTPRequest *)request;
- (void)checkLocalModelsExistRemoteForEntity:(NSEntityDescription *)entity;
- (void)deleteLocalModel:(ASIHTTPRequest *)request;

@end

@implementation CoreSyncManager

#pragma mark -
#pragma mark Properties

@synthesize mainMergePolicy = mainMergePolicy_;
@synthesize threadedMergePolicy = threadedMergePolicy_;
@synthesize remoteSiteURL = remoteSiteURL_;
@synthesize useBundleRequests = useBundleRequests_;
@synthesize bundleRequestDelay = bundleRequestDelay_;
@synthesize logLevel = logLevel_;
@synthesize mainManagedObjectContext = mainManagedObjectContext_;
@synthesize syncronizationQueue = syncronizationQueue_;
@synthesize requestQueue = requestQueue_;
@synthesize deserialzationQueue = deserialzationQueue_;
@synthesize syncTimerRunning = syncTimerRunning_;
@synthesize defaultDateParser = defaultDateParser_;

@dynamic modelMapper;

/* modelMapper */
- (CoreSyncModelMapper* )modelMapper {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    if (modelMapper_ == nil) {
        modelMapper_ = [[CoreSyncModelMapper alloc] initWithMainManagedObjectContext:[self mainManagedObjectContext]
                                                                       remoteSiteURL:[self remoteSiteURL]];
    }
    return modelMapper_;
}

@dynamic defaultDateParserFormat;

/* defaultDateParserFormat */
- (NSString *) defaultDateParserFormat {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    if (defaultDateParserFormat_ == nil) {
        defaultDateParserFormat_ = [[NSUserDefaults standardUserDefaults] valueForKey:@"CoreSync.DefaultDateParserFormat"];
    }

    return defaultDateParserFormat_;
}

- (void)setDefaultDateParserFormat:(NSString *)aDefaultDateParserFormat {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    if (defaultDateParserFormat_ != aDefaultDateParserFormat) {
        [defaultDateParserFormat_ release];
        defaultDateParserFormat_ = [aDefaultDateParserFormat copy];

        [[NSUserDefaults standardUserDefaults] setValue:defaultDateParserFormat_ forKey:@"CoreSync.DefaultDateParserFormat"];
		[[NSUserDefaults standardUserDefaults] synchronize];

    }
}

@dynamic syncFrequency;

/* syncFrequency */
- (NSNumber *)syncFrequency {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    if (syncFrequency_ == nil) {
        syncFrequency_ = [NSNumber numberWithInt:[[NSUserDefaults standardUserDefaults] integerForKey:@"CoreSync.SyncFrequency"]];
    }
    return syncFrequency_;
}

- (void)setSyncFrequency:(NSNumber *)aSyncFrequency {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d] %@",__FUNCTION__,__FILE__,__LINE__, aSyncFrequency);

    if (syncFrequency_ != aSyncFrequency) {
        //NSLog(@"%s:    old value of syncFrequency_: %@, changed to: %@", __FUNCTION__, syncFrequency_, aSyncFrequency);

        [syncFrequency_ release];
        syncFrequency_ = [aSyncFrequency copy];

        [[NSUserDefaults standardUserDefaults] setInteger:[syncFrequency_ intValue] forKey:@"CoreSync.SyncFrequency"];
		[[NSUserDefaults standardUserDefaults] synchronize];

        if (syncTimer_ != nil) {
            [self stop];

            syncTimer_ = [NSTimer timerWithTimeInterval:[syncFrequency_ floatValue]
                             target:self
                           selector:@selector(syncronize:)
                           userInfo:nil
                            repeats:YES];

            [self start];
        }
    }
}

#pragma mark -
#pragma mark Singleton

static CoreSyncManager* _sharedInstance;

+ (CoreSyncManager *)sharedInstance {
    @synchronized(self) {
        return _sharedInstance;
    }
}

+ (void)setSharedInstance:(CoreSyncManager *)aSharedInstance {
    _sharedInstance = aSharedInstance;
}

#pragma mark -
#pragma mark Init

- (id)init {
    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    return [self initWithMainObjectContext:nil usingOptions:nil];
}

// TODO: Document the options //
- (id)initWithMainObjectContext:(NSManagedObjectContext *)aManagedObjectContext
                   usingOptions:(NSDictionary*)aOptions {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    if ((self = [super init])) {

        // Setup hte sharedInstance Singleton
        if (_sharedInstance == nil) {
            _sharedInstance = self;
        }

        // Default Merge Policy
        self.mainMergePolicy = NSErrorMergePolicy;
        self.threadedMergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;

        self.remoteSiteURL = [[aOptions allKeys] containsObject:@"remoteSiteURL"] ? [aOptions valueForKey:@"remoteSiteURL"] : @"";

        self.defaultDateParserFormat = [[aOptions allKeys] containsObject:@"dateFormat"] ? [aOptions valueForKey:@"dateFormat"] : @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        // Default date parser is ruby DateTime.to_s style parser
        defaultDateParser_ = [[NSDateFormatter alloc] init];
        [self.defaultDateParser setDateFormat:[self defaultDateParserFormat]];

        self.useBundleRequests = [[aOptions allKeys] containsObject:@"useBundleRequests"] ? [[aOptions valueForKey:@"useBundleRequests"] boolValue] : NO;
        self.bundleRequestDelay = [[aOptions allKeys] containsObject:@"bundleRequestDelay"] ? [[aOptions valueForKey:@"bundleRequestDelay"] floatValue] : 0;
        self.logLevel = [[aOptions allKeys] containsObject:@"logLevel"] ? [[aOptions valueForKey:@"logLevel"] intValue] : 1;
        self.syncFrequency = [NSNumber numberWithFloat:[[aOptions allKeys] containsObject:@"syncFrequency"] ? [[aOptions valueForKey:@"syncFrequency"] floatValue] : 30.0];

        self.mainManagedObjectContext = aManagedObjectContext;

        self.syncronizationQueue = [[NSOperationQueue alloc] init];
        [[self syncronizationQueue] setMaxConcurrentOperationCount:2];

        self.requestQueue = [[NSOperationQueue alloc] init];
        [[self requestQueue] setMaxConcurrentOperationCount:2];

        self.deserialzationQueue = [[NSOperationQueue alloc] init];
        [[self deserialzationQueue] setMaxConcurrentOperationCount:2];

        self.syncTimerRunning = NO;
        syncTimer_ = [NSTimer timerWithTimeInterval:[[self syncFrequency] floatValue]
                                             target:self
                                           selector:@selector(syncronize:)
                                           userInfo:nil
                                            repeats:YES];
    }
    return self;
}

#pragma mark -
#pragma mark Dealloc
/*
 dealloc
 */
- (void)dealloc {

    if (self == _sharedInstance) {
        _sharedInstance = nil;
    }

    [mainMergePolicy_ release], mainMergePolicy_ = nil;
    [threadedMergePolicy_ release], threadedMergePolicy_ = nil;
    [remoteSiteURL_ release], remoteSiteURL_ = nil;
    [defaultDateParser_ release], defaultDateParser_ = nil;
    [mainManagedObjectContext_ release], mainManagedObjectContext_ = nil;
    [syncronizationQueue_ release], syncronizationQueue_ = nil;
    [requestQueue_ release], requestQueue_ = nil;
    [deserialzationQueue_ release], deserialzationQueue_ = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark Networking

- (void)enqueueRequest:(ASIHTTPRequest*)request {
    if (self.logLevel > 2)
        NSLog(@"[CoreSyncManager#enqueueRequest] request queued: %@", request.url);
    [[self requestQueue] addOperation:request];
}

#pragma mark -
#pragma mark NSTimer Delegate

- (void)syncronize:(NSTimer*)theTimer {
    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);
    [self syncronize];
}

#pragma mark -
#pragma mark Management

- (void)start {
    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);
    [self syncronize];
//    [[NSRunLoop mainRunLoop] addTimer:syncTimer_ forMode:NSDefaultRunLoopMode];
    self.syncTimerRunning = (BOOL *)YES;
}

- (void)stop {
    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);
    [syncTimer_ invalidate];
    self.syncTimerRunning = (BOOL *)NO;
}

- (void)syncronize {
    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    [self syncronizeUpdatedObjects];
    [self syncronizeDeletedObjects];

    [self saveChanges];

    NSArray *entities = [[[[self mainManagedObjectContext] persistentStoreCoordinator] managedObjectModel] entities];

    for (NSEntityDescription *entity in entities) {
        [self syncronizeInsertedModelsforEntity:entity];

        [self syncronizeRemoteWithLocalForEntity:entity];

        //[self syncronizeRemoteNestedResourcesWithLocalForEntity:entity];

        [self checkLocalModelsExistRemoteForEntity:entity];
    }
}

#pragma mark -
#pragma mark Action Methods

- (void)syncronizeInsertedModelsforEntity:(NSEntityDescription *)entity {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteId = nil"];
    [fetchRequest setPredicate:predicate];

    NSError *error = nil;
    NSArray *models = [[self mainManagedObjectContext] executeFetchRequest:fetchRequest error:&error];

    [fetchRequest release];

    for (NSManagedObject *model in models) {

        NSURL *url = [CoreSyncUtils URLWithSite:[[self modelMapper] itemURLUsingModel:model action:Create] andFormat:@"json" andParameters:nil];

        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        [request setDelegate:self];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request addRequestHeader:@"ObjectIdUrlString" value:[[[model objectID] URIRepresentation] absoluteString]];

        [self addPostValueOn:request forModel:model];
        [request setRequestMethod:@"POST"];
        [self enqueueRequest:request];
        [request release];
    }
}

- (void)syncronizeUpdatedObjects {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    NSSet *models = [[self mainManagedObjectContext] updatedObjects];

    for (NSManagedObject *model in [models allObjects]) {

        if ([model valueForKey:[[self modelMapper] localIdField]] == nil) continue;

        NSURL *url = [CoreSyncUtils URLWithSite:[[self modelMapper] itemURLUsingModel:model action:Update] andFormat:@"json" andParameters:nil];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        [request setDelegate:self];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [self addPostValueOn:request forModel:model];
        [request setRequestMethod:@"PUT"];
        [self enqueueRequest:request];
        [request release];
    }
}

- (void)syncronizeDeletedObjects {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    NSSet *models = [[self mainManagedObjectContext] deletedObjects];

    for (NSManagedObject *model in [models allObjects]) {

        NSString *urlString = [[self modelMapper] itemURLUsingModel:model action:Destroy];

        NSURL *url = [CoreSyncUtils URLWithSite:urlString andFormat:@"json" andParameters:nil];
        NSLog(@"[%s:%s:%d] DELETE:%@",__FUNCTION__,__FILE__,__LINE__, url);

        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setDelegate:self];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Accept" value:@"application/json"];

        [request setRequestMethod:@"DELETE"];
        [self enqueueRequest:request];
        [request release];
    }
}

- (void)checkLocalModelsExistRemoteForEntity:(NSEntityDescription *)entity {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];

    NSError *error = nil;
    NSArray *models = [[self mainManagedObjectContext] executeFetchRequest:fetchRequest error:&error];

    [fetchRequest release];

    for (NSManagedObject *model in models) {

        if ([model valueForKey:[[self modelMapper] localIdField]] == nil) continue;

        NSURL *url = [CoreSyncUtils URLWithSite:[[self modelMapper] itemURLUsingModel:model action:Read] andFormat:@"json" andParameters:nil];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setDelegate:self];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request addRequestHeader:@"ObjectIdUrlString" value:[[[model objectID] URIRepresentation] absoluteString]];

        [self enqueueRequest:request];
        [request release];
    }
}

- (void)updateCreatedModelAttributes:(ASIHTTPRequest *)request  {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    NSString *objectIdUrlString = [[request requestHeaders] valueForKey:@"ObjectIdUrlString"];

    if (objectIdUrlString == nil) return;
    if (objectIdUrlString == (id)[NSNull null]) return;

    NSOperation *modelUpdateOperation = [[CoreDataModelUpdateOperation alloc] initWithMainManagedObjectContext:[self mainManagedObjectContext]
                                                                                                   mergePolicy:[self mainMergePolicy]
                                                                                                      delegate:self
                                                                                            jsonResponseString:[request responseString]
                                                                                      managedObjectIDUrlString:objectIdUrlString];

    [[self syncronizationQueue] addOperation:modelUpdateOperation];
    [modelUpdateOperation release];
}

- (void)deleteLocalModel:(ASIHTTPRequest *)request {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    NSString *objectIdUrlString = [[request requestHeaders] valueForKey:@"ObjectIdUrlString"];

    if (objectIdUrlString == nil) return;
    if (objectIdUrlString == (id)[NSNull null]) return;

    NSOperation *destroyaModelOperation = [[CoreDataModelDestroyOperation alloc] initWithMainManagedObjectContext:[self mainManagedObjectContext]
                                                                                                   mergePolicy:[self mainMergePolicy]
                                                                                                      delegate:self
                                                                                      managedObjectIDUrlString:objectIdUrlString];
    [[self syncronizationQueue] addOperation:destroyaModelOperation];
    [destroyaModelOperation release];
}

- (void)syncronizeRemoteWithLocalForEntity:(NSEntityDescription *)entity {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    NSString *resourceUrl = [[self modelMapper] collectionURLUsingEntity:entity];

    if (resourceUrl == nil) return;

    NSURL *url = [CoreSyncUtils URLWithSite:resourceUrl andFormat:@"json" andParameters:nil];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setDelegate:self];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Accept" value:@"application/json"];

    [self enqueueRequest:request];
    [request release];
}

- (void)syncronizeRemoteNestedResourcesWithLocalForEntity:(NSEntityDescription *)parentEntity {

    // 1. Does entity have nested resources
    if ([[self modelMapper] hasNestedResourceRelationshipsOnEntity:parentEntity]) {

        // 2. Load all local models
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:parentEntity];

        NSError *error = nil;
        NSArray *models = [[self mainManagedObjectContext] executeFetchRequest:fetchRequest error:&error];

        [fetchRequest release];

        // 3. Iterate through
        for (NSManagedObject *parentModel in models) {

            NSString *resourceUrlString = [[self modelMapper] collectionURLUsingModel:parentModel];

            // 4. Construct request and enqueue request on queue
            NSURL *url = [CoreSyncUtils URLWithSite:resourceUrlString andFormat:@"json" andParameters:nil];
            ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
            [request setDelegate:self];
            [request addRequestHeader:@"Content-Type" value:@"application/json"];
            [request addRequestHeader:@"Accept" value:@"application/json"];

            [self enqueueRequest:request];
            [request release];
        }
    }
}

#pragma mark -
#pragma mark PrivateMethods

- (void)saveChanges {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    NSError *error = nil;
    if ([[self mainManagedObjectContext] hasChanges]) {
        [[self mainManagedObjectContext] save:&error];
    }
}

- (void)addPostValueOn:(ASIFormDataRequest *)request forModel:(NSManagedObject *)model {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    NSDictionary *postValues = [[self modelMapper] postValuesForModel:model];

    for (NSString *key in [postValues allKeys]) {
        [request setPostValue:[postValues valueForKey:key] forKey:key];
    }
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    switch ([request responseStatusCode]) {
        case 404:
            [self deleteLocalModel:request];
            break;

        case 201:
            // Update the newly created model
            [self updateCreatedModelAttributes:request];
            break;

        default:
            if ([[request requestMethod] isEqualToString:@"GET"]) {
                NSOperation *syncOperation = nil;
                syncOperation = [[CoreDataModelSyncOperation alloc] initWithMainManagedObjectContext:[self mainManagedObjectContext]
                                                                                         mergePolicy:[self threadedMergePolicy]
                                                                                            delegate:self
                                                                                  jsonResponseString:[request responseString]];
                [[self syncronizationQueue] addOperation:syncOperation];
                [syncOperation release];

            }
            break;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {

    if (self.logLevel > 2)
        NSLog(@"[%s:%s:%d]",__FUNCTION__,__FILE__,__LINE__);

    // NSLog(@"[%s:%s:%d] %@",__FUNCTION__,__FILE__,__LINE__, [request error]);
    if ([[request error] domain] == NetworkRequestErrorDomain) {
      switch ([[request error] code]) {
         case ASIRequestTimedOutErrorType:
            // timeout - show a message?
            break;
         case ASIConnectionFailureErrorType:
            // connection failure - perhaps phone has lost signal?
            break;
         case ASIAuthenticationErrorType:
            // Authentication needed - ask the user for login details?
            break;
         case ASIRequestCancelledErrorType:
            // request cancelled - generally you ignore this error
            break;
         default:
            // Other errors - these normally indicate a bug
            break;
      }
   }
}

@end
