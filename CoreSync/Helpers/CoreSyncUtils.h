//
//  CoreSyncUtils.h
//  vWork
//
//  Created by Marcus Wyatt on 9/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CoreSyncUtils : NSObject {

}

#pragma mark -
#pragma mark Helpers

+ (NSURL *)URLWithSite:(NSString *)site andFormat:(NSString *)format andParameters:(id)parameters;

@end
